#!/bin/bash

if [ -n "$1" ]; then
  BASE_DIR="$1"
else
  BASE_DIR="~/BatumiTimelapse"
fi

mkdir -p "$BASE_DIR"

DATE=$(date +%Y-%m-%d_%H-%M-%S)

DAYS_LEFT=$(python3 -c "
import datetime
today = datetime.date.today()
oct7 = datetime.date(today.year, 10, 7)
if today > oct7:
    oct7 = datetime.date(today.year + 1, 10, 7)
delta = oct7 - today
print(delta.days)
")

CAMERA_URLS=(
  "https://frn.rtsp.me/pNM8HoRKawfmejnrx7rviw/1730554185/hls/AZ28Sih4.m3u8?ip=185.70.53.112"
  "https://frn.rtsp.me/921iDHYf_OWhA9YeorWXIw/1730554510/hls/567EFTFd.m3u8?ip=185.70.53.112"
  "https://frn.rtsp.me/Uearuv8vSRwYB-L-JjNB_Q/1730554769/hls/TaHRrstz.m3u8?ip=185.70.53.112"
  "https://frn.rtsp.me/KE4bgIQfCer6TAXGBIQ83A/1730877521/hls/GGrARZ6t.m3u8?ip=83.139.28.32"
)

for i in "${!CAMERA_URLS[@]}"; do
  CAMERA_URL="${CAMERA_URLS[$i]}"
  CAMERA_DIR="$BASE_DIR/camera$((i+1))"
  OUTPUT_FILE="$CAMERA_DIR/frame_$DATE.jpg"

  mkdir -p "$CAMERA_DIR"

  ffmpeg -y -i "$CAMERA_URL" -ss 00:00:02 -vframes 1 \
    -vf "drawtext=text='$DAYS_LEFT':fontcolor=white:fontsize=64:x=10:y=H-th-10" \
    "$OUTPUT_FILE" \
    || echo "$((i+1)) failed"
done
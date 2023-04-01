#!/bin/bash

# Define the content of the switch-audio-port script
read -r -d '' SWITCH_AUDIO_PORT_SCRIPT <<'EOF'
#!/bin/bash

SINK_SPEAKERS="alsa_output.pci-0000_09_00.4.analog-stereo"
SINK_HEADPHONES="alsa_output.usb-Kingston_HyperX_7.1_Audio_00000000-00.analog-stereo"
PORT_SPEAKERS="analog-output-lineout"
PORT_HEADPHONES="analog-output-headphones"

current_sink=$(pactl list short sinks | grep RUNNING | awk '{print $2}')
if [ "$current_sink" == "$SINK_SPEAKERS" ]; then
    pactl set-sink-port "$SINK_HEADPHONES" "$PORT_HEADPHONES"
    pactl set-default-sink "$SINK_HEADPHONES"
else
    pactl set-sink-port "$SINK_SPEAKERS" "$PORT_SPEAKERS"
    pactl set-default-sink "$SINK_SPEAKERS"
fi
EOF

# Create the switch-audio-port file in /usr/local/bin
echo "$SWITCH_AUDIO_PORT_SCRIPT" | sudo tee /usr/local/bin/switch-audio-port > /dev/null

# Set the file permissions to make it executable
sudo chmod +x /usr/local/bin/switch-audio-port

echo "switch-audio-port script has been created and installed."
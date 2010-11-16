From: akpm@linux-foundation.org
Subject: [merged] documentation-led-drivers-lp5521-and-lp5523.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:30:47 -0800
Message-ID: <201011161934.oAGJXxRd003160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757672Ab0KPTeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:34:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, khali@linux-fr.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Documentation: led drivers lp5521 and lp5523
has been removed from the -mm tree.  Its filename was
     documentation-led-drivers-lp5521-and-lp5523.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: led drivers lp5521 and lp5523
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Create sub directory Documentation/leds and add short documentation for
LP5521 and LP5523 drivers.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/leds/leds-lp5521.txt |   88 +++++++++++++++++++++++++++
 Documentation/leds/leds-lp5523.txt |   84 +++++++++++++++++++++++++
 2 files changed, 172 insertions(+)

diff -puN /dev/null Documentation/leds/leds-lp5521.txt
--- /dev/null
+++ a/Documentation/leds/leds-lp5521.txt
@@ -0,0 +1,88 @@
+Kernel driver for lp5521
+========================
+
+* National Semiconductor LP5521 led driver chip
+* Datasheet: http://www.national.com/pf/LP/LP5521.html
+
+Authors: Mathias Nyman, Yuri Zaporozhets, Samu Onkalo
+Contact: Samu Onkalo (samu.p.onkalo-at-nokia.com)
+
+Description
+-----------
+
+LP5521 can drive up to 3 channels. Leds can be controlled directly via
+the led class control interface. Channels have generic names:
+lp5521:channelx, where x is 0 .. 2
+
+All three channels can be also controlled using the engine micro programs.
+More details of the instructions can be found from the public data sheet.
+
+Control interface for the engines:
+x is 1 .. 3
+enginex_mode : disabled, load, run
+enginex_load : store program (visible only in engine load mode)
+
+Example (start to blink the channel 2 led):
+cd   /sys/class/leds/lp5521:channel2/device
+echo "load" > engine3_mode
+echo "037f4d0003ff6000" > engine3_load
+echo "run" > engine3_mode
+
+stop the engine:
+echo "disabled" > engine3_mode
+
+sysfs contains a selftest entry.
+The test communicates with the chip and checks that
+the clock mode is automatically set to the requested one.
+
+Each channel has its own led current settings.
+/sys/class/leds/lp5521:channel0/led_current - RW
+/sys/class/leds/lp5521:channel0/max_current - RO
+Format: 10x mA i.e 10 means 1.0 mA
+
+example platform data:
+
+Note: chan_nr can have values between 0 and 2.
+
+static struct lp5521_led_config lp5521_led_config[] = {
+        {
+                .chan_nr        = 0,
+                .led_current    = 50,
+		.max_current    = 130,
+        }, {
+                .chan_nr        = 1,
+                .led_current    = 0,
+		.max_current    = 130,
+        }, {
+                .chan_nr        = 2,
+                .led_current    = 0,
+		.max_current    = 130,
+        }
+};
+
+static int lp5521_setup(void)
+{
+	/* setup HW resources */
+}
+
+static void lp5521_release(void)
+{
+	/* Release HW resources */
+}
+
+static void lp5521_enable(bool state)
+{
+	/* Control of chip enable signal */
+}
+
+static struct lp5521_platform_data lp5521_platform_data = {
+        .led_config     = lp5521_led_config,
+        .num_channels   = ARRAY_SIZE(lp5521_led_config),
+        .clock_mode     = LP5521_CLOCK_EXT,
+        .setup_resources   = lp5521_setup,
+        .release_resources = lp5521_release,
+        .enable            = lp5521_enable,
+};
+
+If the current is set to 0 in the platform data, that channel is
+disabled and it is not visible in the sysfs.
diff -puN /dev/null Documentation/leds/leds-lp5523.txt
--- /dev/null
+++ a/Documentation/leds/leds-lp5523.txt
@@ -0,0 +1,84 @@
+Kernel driver for lp5523
+========================
+
+* National Semiconductor LP5523 led driver chip
+* Datasheet: http://www.national.com/pf/LP/LP5523.html
+
+Authors: Mathias Nyman, Yuri Zaporozhets, Samu Onkalo
+Contact: Samu Onkalo (samu.p.onkalo-at-nokia.com)
+
+Description
+-----------
+LP5523 can drive up to 9 channels. Leds can be controlled directly via
+the led class control interface. Channels have generic names:
+lp5523:channelx where x is 0...8
+
+The chip provides 3 engines. Each engine can control channels without
+interaction from the main CPU. Details of the micro engine code can be found
+from the public data sheet. Leds can be muxed to different channels.
+
+Control interface for the engines:
+x is 1 .. 3
+enginex_mode : disabled, load, run
+enginex_load : microcode load (visible only in load mode)
+enginex_leds : led mux control (visible only in load mode)
+
+cd /sys/class/leds/lp5523:channel2/device
+echo "load" > engine3_mode
+echo "9d80400004ff05ff437f0000" > engine3_load
+echo "111111111" > engine3_leds
+echo "run" > engine3_mode
+
+sysfs contains a selftest entry. It measures each channel
+voltage level and checks if it looks reasonable. If the level is too high,
+the led is missing; if the level is too low, there is a short circuit.
+
+Selftest uses always the current from the platform data.
+
+Each channel contains led current settings.
+/sys/class/leds/lp5523:channel2/led_current - RW
+/sys/class/leds/lp5523:channel2/max_current - RO
+Format: 10x mA i.e 10 means 1.0 mA
+
+Example platform data:
+
+Note - chan_nr can have values between 0 and 8.
+
+static struct lp5523_led_config lp5523_led_config[] = {
+        {
+                .chan_nr        = 0,
+                .led_current    = 50,
+		.max_current    = 130,
+        },
+...
+        }, {
+                .chan_nr        = 8,
+                .led_current    = 50,
+		.max_current    = 130,
+        }
+};
+
+static int lp5523_setup(void)
+{
+	/* Setup HW resources */
+}
+
+static void lp5523_release(void)
+{
+	/* Release HW resources */
+}
+
+static void lp5523_enable(bool state)
+{
+	/* Control chip enable signal */
+}
+
+static struct lp5523_platform_data lp5523_platform_data = {
+        .led_config     = lp5523_led_config,
+        .num_channels   = ARRAY_SIZE(lp5523_led_config),
+        .clock_mode     = LP5523_CLOCK_EXT,
+        .setup_resources   = lp5523_setup,
+        .release_resources = lp5523_release,
+        .enable            = lp5523_enable,
+};
+
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

drivers-leds-leds-lp5521c-change-some-macros-to-functions.patch
drivers-leds-leds-lp5523c-change-some-macros-to-functions.patch
drivers-leds-leds-lp5521c-adjust-delays-and-add-comments-to-them.patch
drivers-leds-leds-lp5523c-adjust-delays-and-add-comments-to-them.patch
drivers-leds-leds-lp5521c-perform-sw-reset-before-detection.patch
drivers-leds-leds-lp5523c-perform-sw-reset-before-detection.patch


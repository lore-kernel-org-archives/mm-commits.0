From: akpm@linux-foundation.org
Subject: [merged] leds-support-automatic-start-of-blinking-with-ledtrig-timer.patch removed from -mm tree
Date: Wed, 25 May 2011 13:31:51 -0700
Message-ID: <201105252030.p4PKUEhL014946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932207Ab1EYUa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:30:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eha@doredevelopment.dk, rdunlap@xenotime.net, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: support automatic start of blinking with ledtrig-timer
has been removed from the -mm tree.  Its filename was
     leds-support-automatic-start-of-blinking-with-ledtrig-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: support automatic start of blinking with ledtrig-timer
From: Esben Haabendal <eha@doredevelopment.dk>

By setting initial values blink_delay_on and blink_delay_off in a
led_classdev struct, this change starts the blinking when the led is
initialized.

With this patch, you can initialize blink_delay_on and blink_delay_off in
led_classdev with default_trigger set to "timer", and the led will start
up blinking.  The current ledtrig-timer implementation ignores any initial
blink_delay_on/blink_delay_off settings, and requires setting
blink_delay_on/blink_delay_off (typically from userspace) before the led
blinks.

Signed-off-by: Esben Haabendal <eha@doredevelopment.dk>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/led-class.c     |    3 ++-
 drivers/leds/leds.h          |    7 +++++++
 drivers/leds/ledtrig-timer.c |    3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/leds/led-class.c~leds-support-automatic-start-of-blinking-with-ledtrig-timer drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~leds-support-automatic-start-of-blinking-with-ledtrig-timer
+++ a/drivers/leds/led-class.c
@@ -131,7 +131,8 @@ static void led_set_software_blink(struc
 	if (!led_cdev->blink_brightness)
 		led_cdev->blink_brightness = led_cdev->max_brightness;
 
-	if (delay_on == led_cdev->blink_delay_on &&
+	if (led_get_trigger_data(led_cdev) &&
+	    delay_on == led_cdev->blink_delay_on &&
 	    delay_off == led_cdev->blink_delay_off)
 		return;
 
diff -puN drivers/leds/leds.h~leds-support-automatic-start-of-blinking-with-ledtrig-timer drivers/leds/leds.h
--- a/drivers/leds/leds.h~leds-support-automatic-start-of-blinking-with-ledtrig-timer
+++ a/drivers/leds/leds.h
@@ -40,10 +40,17 @@ void led_trigger_set_default(struct led_
 void led_trigger_set(struct led_classdev *led_cdev,
 			struct led_trigger *trigger);
 void led_trigger_remove(struct led_classdev *led_cdev);
+
+static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
+{
+	return led_cdev->trigger_data;
+}
+
 #else
 #define led_trigger_set_default(x) do {} while (0)
 #define led_trigger_set(x, y) do {} while (0)
 #define led_trigger_remove(x) do {} while (0)
+#define led_get_trigger_data(x) (NULL)
 #endif
 
 ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
diff -puN drivers/leds/ledtrig-timer.c~leds-support-automatic-start-of-blinking-with-ledtrig-timer drivers/leds/ledtrig-timer.c
--- a/drivers/leds/ledtrig-timer.c~leds-support-automatic-start-of-blinking-with-ledtrig-timer
+++ a/drivers/leds/ledtrig-timer.c
@@ -91,6 +91,9 @@ static void timer_trig_activate(struct l
 	if (rc)
 		goto err_out_delayon;
 
+	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
+		      &led_cdev->blink_delay_off);
+
 	led_cdev->trigger_data = (void *)1;
 
 	return;
_

Patches currently in -mm which might be from eha@doredevelopment.dk are

origin.patch


From: akpm@linux-foundation.org
Subject: + led-class-always-implement-blinking-update.patch added to -mm tree
Date: Thu, 23 Sep 2010 14:31:36 -0700
Message-ID: <201009232131.o8NLVa2W020178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753041Ab0IWVcc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 17:32:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes.berg@intel.com, rpurdie@rpsys.net


The patch titled
     led-class-always-implement-blinking-update
has been added to the -mm tree.  Its filename is
     led-class-always-implement-blinking-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: led-class-always-implement-blinking-update
From: Johannes Berg <johannes.berg@intel.com>

v2: - update documentation
    - use documented way of turning blinking off
      by setting brightness to 0 rather than by
      setting delays to (0, 0)
    - add API to start blinking, set brightness
      (the latter will also stop sw blinking)

v3: - make LEDS_CLASS a bool rather than tristate
      because LEDS_TRIGGERS now depends on symbols
      it exports

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/leds-class.txt |   21 +++++-----
 drivers/leds/Kconfig         |    2 
 drivers/leds/led-class.c     |   69 ++++++++++++++++++++++-----------
 drivers/leds/led-triggers.c  |    4 -
 drivers/leds/ledtrig-timer.c |   10 +---
 include/linux/leds.h         |   42 ++++++++++++++++++--
 6 files changed, 102 insertions(+), 46 deletions(-)

diff -puN Documentation/leds-class.txt~led-class-always-implement-blinking-update Documentation/leds-class.txt
--- a/Documentation/leds-class.txt~led-class-always-implement-blinking-update
+++ a/Documentation/leds-class.txt
@@ -57,15 +57,18 @@ Hardware accelerated blink of LEDs
 
 Some LEDs can be programmed to blink without any CPU interaction. To
 support this feature, a LED driver can optionally implement the
-blink_set() function (see <linux/leds.h>). If implemented, triggers can
-attempt to use it before falling back to software timers. The blink_set()
-function should return 0 if the blink setting is supported, or -EINVAL
-otherwise, which means that LED blinking will be handled by software.
-
-The blink_set() function should choose a user friendly blinking
-value if it is called with *delay_on==0 && *delay_off==0 parameters. In
-this case the driver should give back the chosen value through delay_on
-and delay_off parameters to the leds subsystem.
+blink_set() function (see <linux/leds.h>). To set an LED to blinking,
+however, it is better to use use the API function led_blink_set(),
+as it will check and implement software fallback if necessary.
+
+To turn off blinking again, use the API function led_brightness_set()
+as that will not just set the LED brightness but also stop any software
+timers that may have been required for blinking.
+
+The blink_set() function should choose a user friendly blinking value
+if it is called with *delay_on==0 && *delay_off==0 parameters. In this
+case the driver should give back the chosen value through delay_on and
+delay_off parameters to the leds subsystem.
 
 Setting the brightness to zero with brightness_set() callback function
 should completely turn off the LED and cancel the previously programmed
diff -puN drivers/leds/Kconfig~led-class-always-implement-blinking-update drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~led-class-always-implement-blinking-update
+++ a/drivers/leds/Kconfig
@@ -7,7 +7,7 @@ menuconfig NEW_LEDS
 if NEW_LEDS
 
 config LEDS_CLASS
-	tristate "LED Class Support"
+	bool "LED Class Support"
 	help
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
diff -puN drivers/leds/led-class.c~led-class-always-implement-blinking-update drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~led-class-always-implement-blinking-update
+++ a/drivers/leds/led-class.c
@@ -111,8 +111,17 @@ static void led_timer_function(unsigned 
 	mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
 }
 
-static int led_blink_set(struct led_classdev *led_cdev,
-			 unsigned long *delay_on, unsigned long *delay_off)
+static void led_stop_software_blink(struct led_classdev *led_cdev)
+{
+	/* deactivate previous settings */
+	del_timer_sync(&led_cdev->blink_timer);
+	led_cdev->blink_delay_on = 0;
+	led_cdev->blink_delay_off = 0;
+}
+
+static void led_set_software_blink(struct led_classdev *led_cdev,
+				   unsigned long delay_on,
+				   unsigned long delay_off)
 {
 	int current_brightness;
 
@@ -122,29 +131,26 @@ static int led_blink_set(struct led_clas
 	if (!led_cdev->blink_brightness)
 		led_cdev->blink_brightness = led_cdev->max_brightness;
 
-	if (*delay_on == led_cdev->blink_delay_on &&
-	    *delay_off == led_cdev->blink_delay_off)
-		return 0;
+	if (delay_on == led_cdev->blink_delay_on &&
+	    delay_off == led_cdev->blink_delay_off)
+		return;
 
-	/* deactivate previous settings */
-	del_timer_sync(&led_cdev->blink_timer);
+	led_stop_software_blink(led_cdev);
 
-	led_cdev->blink_delay_on = *delay_on;
-	led_cdev->blink_delay_off = *delay_off;
+	led_cdev->blink_delay_on = delay_on;
+	led_cdev->blink_delay_off = delay_off;
 
 	/* never on - don't blink */
-	if (!*delay_on)
-		return 0;
+	if (!delay_on)
+		return;
 
 	/* never off - just set to brightness */
-	if (!*delay_off) {
+	if (!delay_off) {
 		led_set_brightness(led_cdev, led_cdev->blink_brightness);
-		return 0;
+		return;
 	}
 
 	mod_timer(&led_cdev->blink_timer, jiffies + 1);
-
-	return 0;
 }
 
 
@@ -219,9 +225,6 @@ int led_classdev_register(struct device 
 	led_cdev->blink_timer.function = led_timer_function;
 	led_cdev->blink_timer.data = (unsigned long)led_cdev;
 
-	if (!led_cdev->blink_set)
-		led_cdev->blink_set = led_blink_set;
-
 #ifdef CONFIG_LEDS_TRIGGERS
 	led_trigger_set_default(led_cdev);
 #endif
@@ -231,7 +234,6 @@ int led_classdev_register(struct device 
 
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(led_classdev_register);
 
 /**
@@ -242,8 +244,6 @@ EXPORT_SYMBOL_GPL(led_classdev_register)
  */
 void led_classdev_unregister(struct led_classdev *led_cdev)
 {
-	unsigned long on = 0, off = 0;
-
 #ifdef CONFIG_LEDS_TRIGGERS
 	down_write(&led_cdev->trigger_lock);
 	if (led_cdev->trigger)
@@ -251,7 +251,8 @@ void led_classdev_unregister(struct led_
 	up_write(&led_cdev->trigger_lock);
 #endif
 
-	led_cdev->blink_set(led_cdev, &on, &off);
+	/* Stop blinking */
+	led_brightness_set(led_cdev, LED_OFF);
 
 	device_unregister(led_cdev->dev);
 
@@ -261,6 +262,30 @@ void led_classdev_unregister(struct led_
 }
 EXPORT_SYMBOL_GPL(led_classdev_unregister);
 
+void led_blink_set(struct led_classdev *led_cdev,
+		   unsigned long *delay_on,
+		   unsigned long *delay_off)
+{
+	if (led_cdev->blink_set &&
+	    led_cdev->blink_set(led_cdev, delay_on, delay_off))
+		return;
+
+	/* blink with 1 Hz as default if nothing specified */
+	if (!*delay_on && !*delay_off)
+		*delay_on = *delay_off = 500;
+
+	led_set_software_blink(led_cdev, *delay_on, *delay_off);
+}
+EXPORT_SYMBOL(led_blink_set);
+
+void led_brightness_set(struct led_classdev *led_cdev,
+			enum led_brightness brightness)
+{
+	led_stop_software_blink(led_cdev);
+	led_cdev->brightness_set(led_cdev, brightness);
+}
+EXPORT_SYMBOL(led_brightness_set);
+
 static int __init leds_init(void)
 {
 	leds_class = class_create(THIS_MODULE, "leds");
diff -puN drivers/leds/led-triggers.c~led-class-always-implement-blinking-update drivers/leds/led-triggers.c
--- a/drivers/leds/led-triggers.c~led-class-always-implement-blinking-update
+++ a/drivers/leds/led-triggers.c
@@ -103,7 +103,6 @@ EXPORT_SYMBOL_GPL(led_trigger_show);
 void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
 {
 	unsigned long flags;
-	unsigned long on = 0, off = 0;
 
 	/* Remove any existing trigger */
 	if (led_cdev->trigger) {
@@ -114,8 +113,7 @@ void led_trigger_set(struct led_classdev
 		if (led_cdev->trigger->deactivate)
 			led_cdev->trigger->deactivate(led_cdev);
 		led_cdev->trigger = NULL;
-		led_cdev->blink_set(led_cdev, &on, &off);
-		led_set_brightness(led_cdev, LED_OFF);
+		led_brightness_set(led_cdev, LED_OFF);
 	}
 	if (trigger) {
 		write_lock_irqsave(&trigger->leddev_list_lock, flags);
diff -puN drivers/leds/ledtrig-timer.c~led-class-always-implement-blinking-update drivers/leds/ledtrig-timer.c
--- a/drivers/leds/ledtrig-timer.c~led-class-always-implement-blinking-update
+++ a/drivers/leds/ledtrig-timer.c
@@ -40,8 +40,7 @@ static ssize_t led_delay_on_store(struct
 		count++;
 
 	if (count == size) {
-		led_cdev->blink_set(led_cdev, &state,
-				    &led_cdev->blink_delay_off);
+		led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
 		ret = count;
 	}
 
@@ -69,8 +68,7 @@ static ssize_t led_delay_off_store(struc
 		count++;
 
 	if (count == size) {
-		led_cdev->blink_set(led_cdev, &led_cdev->blink_delay_on,
-				    &state);
+		led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
 		ret = count;
 	}
 
@@ -103,15 +101,13 @@ err_out_delayon:
 
 static void timer_trig_deactivate(struct led_classdev *led_cdev)
 {
-	unsigned long on = 0, off = 0;
-
 	if (led_cdev->trigger_data) {
 		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
 		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
 	}
 
 	/* Stop blinking */
-	led_cdev->blink_set(led_cdev, &on, &off);
+	led_brightness_set(led_cdev, LED_OFF);
 }
 
 static struct led_trigger timer_led_trigger = {
diff -puN include/linux/leds.h~led-class-always-implement-blinking-update include/linux/leds.h
--- a/include/linux/leds.h~led-class-always-implement-blinking-update
+++ a/include/linux/leds.h
@@ -46,10 +46,14 @@ struct led_classdev {
 	/* Get LED brightness level */
 	enum led_brightness (*brightness_get)(struct led_classdev *led_cdev);
 
-	/* Activate hardware accelerated blink, delays are in
-	 * miliseconds and if none is provided then a sensible default
-	 * should be chosen. The call can adjust the timings if it can't
-	 * match the values specified exactly. */
+	/*
+	 * Activate hardware accelerated blink, delays are in milliseconds
+	 * and if both are zero then a sensible default should be chosen.
+	 * The call should adjust the timings in that case and if it can't
+	 * match the values specified exactly.
+	 * Deactivate blinking again when the brightness is set to a fixed
+	 * value via the brightness_set() callback.
+	 */
 	int		(*blink_set)(struct led_classdev *led_cdev,
 				     unsigned long *delay_on,
 				     unsigned long *delay_off);
@@ -78,6 +82,36 @@ extern void led_classdev_unregister(stru
 extern void led_classdev_suspend(struct led_classdev *led_cdev);
 extern void led_classdev_resume(struct led_classdev *led_cdev);
 
+/**
+ * led_blink_set - set blinking with software fallback
+ * @led_cdev: the LED to start blinking
+ * @delay_on: the time it should be on (in ms)
+ * @delay_off: the time it should ble off (in ms)
+ *
+ * This function makes the LED blink, attempting to use the
+ * hardware acceleration if possible, but falling back to
+ * software blinking if there is no hardware blinking or if
+ * the LED refuses the passed values.
+ *
+ * Note that if software blinking is active, simply calling
+ * led_cdev->brightness_set() will not stop the blinking,
+ * use led_classdev_brightness_set() instead.
+ */
+extern void led_blink_set(struct led_classdev *led_cdev,
+			  unsigned long *delay_on,
+			  unsigned long *delay_off);
+/**
+ * led_brightness_set - set LED brightness
+ * @led_cdev: the LED to set
+ * @brightness: the brightness to set it to
+ *
+ * Set an LED's brightness, and, if necessary, cancel the
+ * software blink timer that implements blinking when the
+ * hardware doesn't.
+ */
+extern void led_brightness_set(struct led_classdev *led_cdev,
+			       enum led_brightness brightness);
+
 /*
  * LED Triggers
  */
_

Patches currently in -mm which might be from johannes.berg@intel.com are

linux-next.patch
led-class-always-implement-blinking.patch
led-class-always-implement-blinking-update.patch


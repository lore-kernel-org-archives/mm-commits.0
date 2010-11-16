From: akpm@linux-foundation.org
Subject: [merged] led-class-always-implement-blinking.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:30:38 -0800
Message-ID: <201011161933.oAGJXpTx003141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757587Ab0KPTdz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:33:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes.berg@intel.com, rpurdie@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     led-class: always implement blinking
has been removed from the -mm tree.  Its filename was
     led-class-always-implement-blinking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: led-class: always implement blinking
From: Johannes Berg <johannes.berg@intel.com>

Currently, blinking LEDs can be awkward because it is not guaranteed that
all LEDs implement blinking.  The trigger that wants it to blink then
needs to implement its own timer solution.

Rather than require that, add led_blink_set() API that triggers can use. 
This function will attempt to use hw blinking, but if that fails
implements a timer for it.  To stop blinking again, brightness_set() also
needs to be wrapped into API that will stop the software blink.

As a result of this, the timer trigger becomes a very trivial one, and
hopefully we can finally see triggers using blinking as well because it's
always easy to use.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/leds-class.txt        |   21 ++--
 drivers/leds/Kconfig                |    2 
 drivers/leds/led-class.c            |  105 +++++++++++++++++++++-
 drivers/leds/led-triggers.c         |    2 
 drivers/leds/ledtrig-timer.c        |  124 ++------------------------
 drivers/net/wireless/rt2x00/Kconfig |    3 
 include/linux/leds.h                |   47 +++++++++
 7 files changed, 171 insertions(+), 133 deletions(-)

diff -puN Documentation/leds-class.txt~led-class-always-implement-blinking Documentation/leds-class.txt
--- a/Documentation/leds-class.txt~led-class-always-implement-blinking
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
diff -puN drivers/leds/Kconfig~led-class-always-implement-blinking drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~led-class-always-implement-blinking
+++ a/drivers/leds/Kconfig
@@ -7,7 +7,7 @@ menuconfig NEW_LEDS
 if NEW_LEDS
 
 config LEDS_CLASS
-	tristate "LED Class Support"
+	bool "LED Class Support"
 	help
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
diff -puN drivers/leds/led-class.c~led-class-always-implement-blinking drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~led-class-always-implement-blinking
+++ a/drivers/leds/led-class.c
@@ -81,6 +81,79 @@ static struct device_attribute led_class
 	__ATTR_NULL,
 };
 
+static void led_timer_function(unsigned long data)
+{
+	struct led_classdev *led_cdev = (void *)data;
+	unsigned long brightness;
+	unsigned long delay;
+
+	if (!led_cdev->blink_delay_on || !led_cdev->blink_delay_off) {
+		led_set_brightness(led_cdev, LED_OFF);
+		return;
+	}
+
+	brightness = led_get_brightness(led_cdev);
+	if (!brightness) {
+		/* Time to switch the LED on. */
+		brightness = led_cdev->blink_brightness;
+		delay = led_cdev->blink_delay_on;
+	} else {
+		/* Store the current brightness value to be able
+		 * to restore it when the delay_off period is over.
+		 */
+		led_cdev->blink_brightness = brightness;
+		brightness = LED_OFF;
+		delay = led_cdev->blink_delay_off;
+	}
+
+	led_set_brightness(led_cdev, brightness);
+
+	mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
+}
+
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
+{
+	int current_brightness;
+
+	current_brightness = led_get_brightness(led_cdev);
+	if (current_brightness)
+		led_cdev->blink_brightness = current_brightness;
+	if (!led_cdev->blink_brightness)
+		led_cdev->blink_brightness = led_cdev->max_brightness;
+
+	if (delay_on == led_cdev->blink_delay_on &&
+	    delay_off == led_cdev->blink_delay_off)
+		return;
+
+	led_stop_software_blink(led_cdev);
+
+	led_cdev->blink_delay_on = delay_on;
+	led_cdev->blink_delay_off = delay_off;
+
+	/* never on - don't blink */
+	if (!delay_on)
+		return;
+
+	/* never off - just set to brightness */
+	if (!delay_off) {
+		led_set_brightness(led_cdev, led_cdev->blink_brightness);
+		return;
+	}
+
+	mod_timer(&led_cdev->blink_timer, jiffies + 1);
+}
+
+
 /**
  * led_classdev_suspend - suspend an led_classdev.
  * @led_cdev: the led_classdev to suspend.
@@ -148,6 +221,10 @@ int led_classdev_register(struct device 
 
 	led_update_brightness(led_cdev);
 
+	init_timer(&led_cdev->blink_timer);
+	led_cdev->blink_timer.function = led_timer_function;
+	led_cdev->blink_timer.data = (unsigned long)led_cdev;
+
 #ifdef CONFIG_LEDS_TRIGGERS
 	led_trigger_set_default(led_cdev);
 #endif
@@ -157,7 +234,6 @@ int led_classdev_register(struct device 
 
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(led_classdev_register);
 
 /**
@@ -175,6 +251,9 @@ void led_classdev_unregister(struct led_
 	up_write(&led_cdev->trigger_lock);
 #endif
 
+	/* Stop blinking */
+	led_brightness_set(led_cdev, LED_OFF);
+
 	device_unregister(led_cdev->dev);
 
 	down_write(&leds_list_lock);
@@ -183,6 +262,30 @@ void led_classdev_unregister(struct led_
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
diff -puN drivers/leds/led-triggers.c~led-class-always-implement-blinking drivers/leds/led-triggers.c
--- a/drivers/leds/led-triggers.c~led-class-always-implement-blinking
+++ a/drivers/leds/led-triggers.c
@@ -113,7 +113,7 @@ void led_trigger_set(struct led_classdev
 		if (led_cdev->trigger->deactivate)
 			led_cdev->trigger->deactivate(led_cdev);
 		led_cdev->trigger = NULL;
-		led_set_brightness(led_cdev, LED_OFF);
+		led_brightness_set(led_cdev, LED_OFF);
 	}
 	if (trigger) {
 		write_lock_irqsave(&trigger->leddev_list_lock, flags);
diff -puN drivers/leds/ledtrig-timer.c~led-class-always-implement-blinking drivers/leds/ledtrig-timer.c
--- a/drivers/leds/ledtrig-timer.c~led-class-always-implement-blinking
+++ a/drivers/leds/ledtrig-timer.c
@@ -12,73 +12,25 @@
  */
 
 #include <linux/module.h>
-#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
 #include <linux/device.h>
-#include <linux/sysdev.h>
-#include <linux/timer.h>
 #include <linux/ctype.h>
 #include <linux/leds.h>
-#include <linux/slab.h>
 #include "leds.h"
 
-struct timer_trig_data {
-	int brightness_on;		/* LED brightness during "on" period.
-					 * (LED_OFF < brightness_on <= LED_FULL)
-					 */
-	unsigned long delay_on;		/* milliseconds on */
-	unsigned long delay_off;	/* milliseconds off */
-	struct timer_list timer;
-};
-
-static void led_timer_function(unsigned long data)
-{
-	struct led_classdev *led_cdev = (struct led_classdev *) data;
-	struct timer_trig_data *timer_data = led_cdev->trigger_data;
-	unsigned long brightness;
-	unsigned long delay;
-
-	if (!timer_data->delay_on || !timer_data->delay_off) {
-		led_set_brightness(led_cdev, LED_OFF);
-		return;
-	}
-
-	brightness = led_get_brightness(led_cdev);
-	if (!brightness) {
-		/* Time to switch the LED on. */
-		brightness = timer_data->brightness_on;
-		delay = timer_data->delay_on;
-	} else {
-		/* Store the current brightness value to be able
-		 * to restore it when the delay_off period is over.
-		 */
-		timer_data->brightness_on = brightness;
-		brightness = LED_OFF;
-		delay = timer_data->delay_off;
-	}
-
-	led_set_brightness(led_cdev, brightness);
-
-	mod_timer(&timer_data->timer, jiffies + msecs_to_jiffies(delay));
-}
-
 static ssize_t led_delay_on_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 
-	return sprintf(buf, "%lu\n", timer_data->delay_on);
+	return sprintf(buf, "%lu\n", led_cdev->blink_delay_on);
 }
 
 static ssize_t led_delay_on_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 	int ret = -EINVAL;
 	char *after;
 	unsigned long state = simple_strtoul(buf, &after, 10);
@@ -88,21 +40,7 @@ static ssize_t led_delay_on_store(struct
 		count++;
 
 	if (count == size) {
-		if (timer_data->delay_on != state) {
-			/* the new value differs from the previous */
-			timer_data->delay_on = state;
-
-			/* deactivate previous settings */
-			del_timer_sync(&timer_data->timer);
-
-			/* try to activate hardware acceleration, if any */
-			if (!led_cdev->blink_set ||
-			    led_cdev->blink_set(led_cdev,
-			      &timer_data->delay_on, &timer_data->delay_off)) {
-				/* no hardware acceleration, blink via timer */
-				mod_timer(&timer_data->timer, jiffies + 1);
-			}
-		}
+		led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
 		ret = count;
 	}
 
@@ -113,16 +51,14 @@ static ssize_t led_delay_off_show(struct
 		struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 
-	return sprintf(buf, "%lu\n", timer_data->delay_off);
+	return sprintf(buf, "%lu\n", led_cdev->blink_delay_off);
 }
 
 static ssize_t led_delay_off_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 	int ret = -EINVAL;
 	char *after;
 	unsigned long state = simple_strtoul(buf, &after, 10);
@@ -132,21 +68,7 @@ static ssize_t led_delay_off_store(struc
 		count++;
 
 	if (count == size) {
-		if (timer_data->delay_off != state) {
-			/* the new value differs from the previous */
-			timer_data->delay_off = state;
-
-			/* deactivate previous settings */
-			del_timer_sync(&timer_data->timer);
-
-			/* try to activate hardware acceleration, if any */
-			if (!led_cdev->blink_set ||
-			    led_cdev->blink_set(led_cdev,
-			      &timer_data->delay_on, &timer_data->delay_off)) {
-				/* no hardware acceleration, blink via timer */
-				mod_timer(&timer_data->timer, jiffies + 1);
-			}
-		}
+		led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
 		ret = count;
 	}
 
@@ -158,60 +80,34 @@ static DEVICE_ATTR(delay_off, 0644, led_
 
 static void timer_trig_activate(struct led_classdev *led_cdev)
 {
-	struct timer_trig_data *timer_data;
 	int rc;
 
-	timer_data = kzalloc(sizeof(struct timer_trig_data), GFP_KERNEL);
-	if (!timer_data)
-		return;
-
-	timer_data->brightness_on = led_get_brightness(led_cdev);
-	if (timer_data->brightness_on == LED_OFF)
-		timer_data->brightness_on = led_cdev->max_brightness;
-	led_cdev->trigger_data = timer_data;
-
-	init_timer(&timer_data->timer);
-	timer_data->timer.function = led_timer_function;
-	timer_data->timer.data = (unsigned long) led_cdev;
+	led_cdev->trigger_data = NULL;
 
 	rc = device_create_file(led_cdev->dev, &dev_attr_delay_on);
 	if (rc)
-		goto err_out;
+		return;
 	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
 	if (rc)
 		goto err_out_delayon;
 
-	/* If there is hardware support for blinking, start one
-	 * user friendly blink rate chosen by the driver.
-	 */
-	if (led_cdev->blink_set)
-		led_cdev->blink_set(led_cdev,
-			&timer_data->delay_on, &timer_data->delay_off);
+	led_cdev->trigger_data = (void *)1;
 
 	return;
 
 err_out_delayon:
 	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
-err_out:
-	led_cdev->trigger_data = NULL;
-	kfree(timer_data);
 }
 
 static void timer_trig_deactivate(struct led_classdev *led_cdev)
 {
-	struct timer_trig_data *timer_data = led_cdev->trigger_data;
-	unsigned long on = 0, off = 0;
-
-	if (timer_data) {
+	if (led_cdev->trigger_data) {
 		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
 		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
-		del_timer_sync(&timer_data->timer);
-		kfree(timer_data);
 	}
 
-	/* If there is hardware support for blinking, stop it */
-	if (led_cdev->blink_set)
-		led_cdev->blink_set(led_cdev, &on, &off);
+	/* Stop blinking */
+	led_brightness_set(led_cdev, LED_OFF);
 }
 
 static struct led_trigger timer_led_trigger = {
diff -puN drivers/net/wireless/rt2x00/Kconfig~led-class-always-implement-blinking drivers/net/wireless/rt2x00/Kconfig
--- a/drivers/net/wireless/rt2x00/Kconfig~led-class-always-implement-blinking
+++ a/drivers/net/wireless/rt2x00/Kconfig
@@ -221,9 +221,6 @@ config RT2X00_LIB_LEDS
 	boolean
 	default y if (RT2X00_LIB=y && LEDS_CLASS=y) || (RT2X00_LIB=m && LEDS_CLASS!=n)
 
-comment "rt2x00 leds support disabled due to modularized LEDS_CLASS and built-in rt2x00"
-	depends on RT2X00_LIB=y && LEDS_CLASS=m
-
 config RT2X00_LIB_DEBUGFS
 	bool "Ralink debugfs support"
 	depends on RT2X00_LIB && MAC80211_DEBUGFS
diff -puN include/linux/leds.h~led-class-always-implement-blinking include/linux/leds.h
--- a/include/linux/leds.h~led-class-always-implement-blinking
+++ a/include/linux/leds.h
@@ -15,6 +15,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/rwsem.h>
+#include <linux/timer.h>
 
 struct device;
 /*
@@ -45,10 +46,14 @@ struct led_classdev {
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
@@ -57,6 +62,10 @@ struct led_classdev {
 	struct list_head	 node;			/* LED Device list */
 	const char		*default_trigger;	/* Trigger to use */
 
+	unsigned long		 blink_delay_on, blink_delay_off;
+	struct timer_list	 blink_timer;
+	int			 blink_brightness;
+
 #ifdef CONFIG_LEDS_TRIGGERS
 	/* Protects the trigger data below */
 	struct rw_semaphore	 trigger_lock;
@@ -73,6 +82,36 @@ extern void led_classdev_unregister(stru
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


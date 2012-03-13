From: akpm@linux-foundation.org
Subject: + led-class-change-back-leds_class-to-tristate-instead-of-bool.patch added to -mm tree
Date: Tue, 13 Mar 2012 15:58:26 -0700
Message-ID: <20120313225826.E7AC5A0331@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:56703 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760063Ab2CMW62 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Mar 2012 18:58:28 -0400
Received: by yenq2 with SMTP id q2so187786yen.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Mar 2012 15:58:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@canonical.com, linus.walleij@linaro.org, richard.purdie@linuxfoundation.org


The patch titled
     Subject: led-class: change back LEDS_CLASS to tristate instead of bool
has been added to the -mm tree.  Its filename is
     led-class-change-back-leds_class-to-tristate-instead-of-bool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bryan Wu <bryan.wu@canonical.com>
Subject: led-class: change back LEDS_CLASS to tristate instead of bool

After moving some core functions to led-core.c, led-class.c can be built
as module again.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig     |    2 -
 drivers/leds/led-class.c |   70 -------------------------------------
 drivers/leds/led-core.c  |   70 +++++++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+), 71 deletions(-)

diff -puN drivers/leds/Kconfig~led-class-change-back-leds_class-to-tristate-instead-of-bool drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~led-class-change-back-leds_class-to-tristate-instead-of-bool
+++ a/drivers/leds/Kconfig
@@ -17,7 +17,7 @@ menuconfig NEW_LEDS
 if NEW_LEDS
 
 config LEDS_CLASS
-	bool "LED Class Support"
+	tristate "LED Class Support"
 	help
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
diff -puN drivers/leds/led-class.c~led-class-change-back-leds_class-to-tristate-instead-of-bool drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~led-class-change-back-leds_class-to-tristate-instead-of-bool
+++ a/drivers/leds/led-class.c
@@ -110,50 +110,6 @@ static void led_timer_function(unsigned 
 	mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
 }
 
-static void led_stop_software_blink(struct led_classdev *led_cdev)
-{
-	/* deactivate previous settings */
-	del_timer_sync(&led_cdev->blink_timer);
-	led_cdev->blink_delay_on = 0;
-	led_cdev->blink_delay_off = 0;
-}
-
-static void led_set_software_blink(struct led_classdev *led_cdev,
-				   unsigned long delay_on,
-				   unsigned long delay_off)
-{
-	int current_brightness;
-
-	current_brightness = led_get_brightness(led_cdev);
-	if (current_brightness)
-		led_cdev->blink_brightness = current_brightness;
-	if (!led_cdev->blink_brightness)
-		led_cdev->blink_brightness = led_cdev->max_brightness;
-
-	if (led_get_trigger_data(led_cdev) &&
-	    delay_on == led_cdev->blink_delay_on &&
-	    delay_off == led_cdev->blink_delay_off)
-		return;
-
-	led_stop_software_blink(led_cdev);
-
-	led_cdev->blink_delay_on = delay_on;
-	led_cdev->blink_delay_off = delay_off;
-
-	/* never on - don't blink */
-	if (!delay_on)
-		return;
-
-	/* never off - just set to brightness */
-	if (!delay_off) {
-		led_set_brightness(led_cdev, led_cdev->blink_brightness);
-		return;
-	}
-
-	mod_timer(&led_cdev->blink_timer, jiffies + 1);
-}
-
-
 /**
  * led_classdev_suspend - suspend an led_classdev.
  * @led_cdev: the led_classdev to suspend.
@@ -262,32 +218,6 @@ void led_classdev_unregister(struct led_
 }
 EXPORT_SYMBOL_GPL(led_classdev_unregister);
 
-void led_blink_set(struct led_classdev *led_cdev,
-		   unsigned long *delay_on,
-		   unsigned long *delay_off)
-{
-	del_timer_sync(&led_cdev->blink_timer);
-
-	if (led_cdev->blink_set &&
-	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
-		return;
-
-	/* blink with 1 Hz as default if nothing specified */
-	if (!*delay_on && !*delay_off)
-		*delay_on = *delay_off = 500;
-
-	led_set_software_blink(led_cdev, *delay_on, *delay_off);
-}
-EXPORT_SYMBOL(led_blink_set);
-
-void led_brightness_set(struct led_classdev *led_cdev,
-			enum led_brightness brightness)
-{
-	led_stop_software_blink(led_cdev);
-	led_cdev->brightness_set(led_cdev, brightness);
-}
-EXPORT_SYMBOL(led_brightness_set);
-
 static int __init leds_init(void)
 {
 	leds_class = class_create(THIS_MODULE, "leds");
diff -puN drivers/leds/led-core.c~led-class-change-back-leds_class-to-tristate-instead-of-bool drivers/leds/led-core.c
--- a/drivers/leds/led-core.c~led-class-change-back-leds_class-to-tristate-instead-of-bool
+++ a/drivers/leds/led-core.c
@@ -23,3 +23,73 @@ EXPORT_SYMBOL_GPL(leds_list_lock);
 
 LIST_HEAD(leds_list);
 EXPORT_SYMBOL_GPL(leds_list);
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
+	if (led_get_trigger_data(led_cdev) &&
+	    delay_on == led_cdev->blink_delay_on &&
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
+void led_blink_set(struct led_classdev *led_cdev,
+		   unsigned long *delay_on,
+		   unsigned long *delay_off)
+{
+	del_timer_sync(&led_cdev->blink_timer);
+
+	if (led_cdev->blink_set &&
+	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
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
_
Subject: Subject: led-class: change back LEDS_CLASS to tristate instead of bool

Patches currently in -mm which might be from bryan.wu@canonical.com are

led-class-change-back-leds_class-to-tristate-instead-of-bool.patch


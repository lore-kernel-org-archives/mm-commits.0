From: akpm@linux-foundation.org
Subject: - leds-gpio-handles-timer-unsafe-gpios.patch removed from -mm tree
Date: Fri, 11 May 2007 22:16:02 -0700
Message-ID: <200705120516.l4C5G2Fm001797@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756140AbXELFQM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:16:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     leds-gpio handles timer-unsafe GPIOs
has been removed from the -mm tree.  Its filename was
     leds-gpio-handles-timer-unsafe-gpios.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: leds-gpio handles timer-unsafe GPIOs
From: David Brownell <david-b@pacbell.net>

Teach the new leds-gpio driver that some GPIOs can't be accessed from
timer callbacks ... which is how all today's standard triggers use them.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-gpio.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff -puN drivers/leds/leds-gpio.c~leds-gpio-handles-timer-unsafe-gpios drivers/leds/leds-gpio.c
--- a/drivers/leds/leds-gpio.c~leds-gpio-handles-timer-unsafe-gpios
+++ a/drivers/leds/leds-gpio.c
@@ -13,14 +13,26 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/leds.h>
+#include <linux/workqueue.h>
+
 #include <asm/gpio.h>
 
 struct gpio_led_data {
 	struct led_classdev cdev;
 	unsigned gpio;
+	struct work_struct work;
+	u8 new_level;
+	u8 can_sleep;
 	u8 active_low;
 };
 
+static void gpio_led_work(struct work_struct *work)
+{
+	struct gpio_led_data	*led_dat =
+		container_of(work, struct gpio_led_data, work);
+
+	gpio_set_value_cansleep(led_dat->gpio, led_dat->new_level);
+}
 
 static void gpio_led_set(struct led_classdev *led_cdev,
 	enum led_brightness value)
@@ -37,7 +49,15 @@ static void gpio_led_set(struct led_clas
 	if (led_dat->active_low)
 		level = !level;
 
-	gpio_set_value(led_dat->gpio, level);
+	/* setting GPIOs with I2C/etc requires a preemptible task context */
+	if (led_dat->can_sleep) {
+		if (preempt_count()) {
+			led_dat->new_level = level;
+			schedule_work(&led_dat->work);
+		} else
+			gpio_set_value_cansleep(led_dat->gpio, level);
+	} else
+		gpio_set_value(led_dat->gpio, level);
 }
 
 static int __init gpio_led_probe(struct platform_device *pdev)
@@ -62,6 +82,7 @@ static int __init gpio_led_probe(struct 
 		led_dat->cdev.name = cur_led->name;
 		led_dat->cdev.default_trigger = cur_led->default_trigger;
 		led_dat->gpio = cur_led->gpio;
+		led_dat->can_sleep = gpio_cansleep(cur_led->gpio);
 		led_dat->active_low = cur_led->active_low;
 		led_dat->cdev.brightness_set = gpio_led_set;
 		led_dat->cdev.brightness = cur_led->active_low ? LED_FULL : LED_OFF;
@@ -77,6 +98,8 @@ static int __init gpio_led_probe(struct 
 			gpio_free(led_dat->gpio);
 			goto err;
 		}
+
+		INIT_WORK(&led_dat->work, gpio_led_work);
 	}
 
 	platform_set_drvdata(pdev, leds_data);
@@ -108,6 +131,7 @@ static int __exit gpio_led_remove(struct
 		gpio_free(leds_data[i].gpio);
 	}
 	
+	flush_scheduled_work();
 	kfree(leds_data);
 
 	return 0;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
documentation-gpiotxt-mentions-generic_gpio.patch
rtc-rs5c313c-error-and-warning-are-fixed.patch
rtc-rs5c313c-rtc_time-value-are-fixed.patch
rtc-rs5c313c-add-error-handling-to-avoid-hardware-hangup.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
git-leds.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
use-menuconfig-objects-ii-rtc.patch

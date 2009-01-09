From: akpm@linux-foundation.org
Subject: - leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values.patch removed from -mm tree
Date: Fri, 09 Jan 2009 11:52:39 -0800
Message-ID: <200901091952.n09JqdKx026523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715AbZAITxh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 14:53:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lg@denx.de, ben-linux@fluff.org, hmh@hmh.eng.br, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: allow led-drivers to use a wider than 0...255 range of brightness values
has been removed from the -mm tree.  Its filename was
     leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: allow led-drivers to use a wider than 0...255 range of brightness values
From: Guennadi Liakhovetski <lg@denx.de>

This patch allows drivers to override the default maximum brightness value
of 255.  We take care to preserve backwards-compatibility as much as
possible, so that user-space ABI doesn't change for existing drivers.  All
existing drivers have been modified to explicitly set their maximum
brightness to LED_FULL.  LED trigger code has also been updated to use the
per-LED maximum.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/led-class.c          |   21 ++++++++++++++++++++-
 drivers/leds/leds-ams-delta.c     |    6 ++++++
 drivers/leds/leds-atmel-pwm.c     |    1 +
 drivers/leds/leds-clevo-mail.c    |    1 +
 drivers/leds/leds-cobalt-qube.c   |    1 +
 drivers/leds/leds-cobalt-raq.c    |    2 ++
 drivers/leds/leds-da903x.c        |    1 +
 drivers/leds/leds-fsg.c           |    6 ++++++
 drivers/leds/leds-gpio.c          |    1 +
 drivers/leds/leds-h1940.c         |    3 +++
 drivers/leds/leds-hp-disk.c       |    1 +
 drivers/leds/leds-hp6xx.c         |    2 ++
 drivers/leds/leds-locomo.c        |    2 ++
 drivers/leds/leds-net48xx.c       |    1 +
 drivers/leds/leds-pca9532.c       |    1 +
 drivers/leds/leds-pca955x.c       |    1 +
 drivers/leds/leds-s3c24xx.c       |    1 +
 drivers/leds/leds-sunfire.c       |    1 +
 drivers/leds/leds-wrap.c          |    3 +++
 drivers/leds/leds.h               |    4 ++--
 drivers/leds/ledtrig-default-on.c |    2 +-
 drivers/leds/ledtrig-heartbeat.c  |    4 ++--
 drivers/leds/ledtrig-ide-disk.c   |    3 ++-
 drivers/leds/ledtrig-timer.c      |    2 +-
 include/linux/leds.h              |    1 +
 25 files changed, 64 insertions(+), 8 deletions(-)

diff -puN drivers/leds/led-class.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/led-class.c
@@ -59,7 +59,16 @@ static ssize_t led_brightness_store(stru
 	return strnlen(buf, size);
 }
 
+static ssize_t led_max_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", led_cdev->max_brightness);
+}
+
 static DEVICE_ATTR(brightness, 0644, led_brightness_show, led_brightness_store);
+static DEVICE_ATTR(max_brightness, 0444, led_max_brightness_show, NULL);
 #ifdef CONFIG_LEDS_TRIGGERS
 static DEVICE_ATTR(trigger, 0644, led_trigger_show, led_trigger_store);
 #endif
@@ -113,6 +122,13 @@ int led_classdev_register(struct device 
 	list_add_tail(&led_cdev->node, &leds_list);
 	up_write(&leds_list_lock);
 
+	if (!led_cdev->max_brightness)
+		led_cdev->max_brightness = LED_FULL;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_max_brightness);
+	if (rc)
+		goto err_out_attr_max;
+
 	led_update_brightness(led_cdev);
 
 #ifdef CONFIG_LEDS_TRIGGERS
@@ -130,9 +146,11 @@ int led_classdev_register(struct device 
 
 #ifdef CONFIG_LEDS_TRIGGERS
 err_out_led_list:
+	device_remove_file(led_cdev->dev, &dev_attr_max_brightness);
+#endif
+err_out_attr_max:
 	device_remove_file(led_cdev->dev, &dev_attr_brightness);
 	list_del(&led_cdev->node);
-#endif
 err_out:
 	device_unregister(led_cdev->dev);
 	return rc;
@@ -147,6 +165,7 @@ EXPORT_SYMBOL_GPL(led_classdev_register)
  */
 void led_classdev_unregister(struct led_classdev *led_cdev)
 {
+	device_remove_file(led_cdev->dev, &dev_attr_max_brightness);
 	device_remove_file(led_cdev->dev, &dev_attr_brightness);
 #ifdef CONFIG_LEDS_TRIGGERS
 	device_remove_file(led_cdev->dev, &dev_attr_trigger);
diff -puN drivers/leds/leds-ams-delta.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-ams-delta.c
--- a/drivers/leds/leds-ams-delta.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-ams-delta.c
@@ -39,6 +39,7 @@ static struct ams_delta_led ams_delta_le
 		.cdev		= {
 			.name		= "ams-delta::camera",
 			.brightness_set = ams_delta_led_set,
+			.max_brightness	= LED_FULL,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_CAMERA,
 	},
@@ -46,6 +47,7 @@ static struct ams_delta_led ams_delta_le
 		.cdev		= {
 			.name		= "ams-delta::advert",
 			.brightness_set = ams_delta_led_set,
+			.max_brightness	= LED_FULL,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_ADVERT,
 	},
@@ -53,6 +55,7 @@ static struct ams_delta_led ams_delta_le
 		.cdev		= {
 			.name		= "ams-delta::email",
 			.brightness_set = ams_delta_led_set,
+			.max_brightness	= LED_FULL,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_EMAIL,
 	},
@@ -60,6 +63,7 @@ static struct ams_delta_led ams_delta_le
 		.cdev		= {
 			.name		= "ams-delta::handsfree",
 			.brightness_set = ams_delta_led_set,
+			.max_brightness	= LED_FULL,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_HANDSFREE,
 	},
@@ -67,6 +71,7 @@ static struct ams_delta_led ams_delta_le
 		.cdev		= {
 			.name		= "ams-delta::voicemail",
 			.brightness_set = ams_delta_led_set,
+			.max_brightness	= LED_FULL,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_VOICEMAIL,
 	},
@@ -74,6 +79,7 @@ static struct ams_delta_led ams_delta_le
 		.cdev		= {
 			.name		= "ams-delta::voice",
 			.brightness_set = ams_delta_led_set,
+			.max_brightness	= LED_FULL,
 		},
 		.bitmask	= AMS_DELTA_LATCH1_LED_VOICE,
 	},
diff -puN drivers/leds/leds-atmel-pwm.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-atmel-pwm.c
--- a/drivers/leds/leds-atmel-pwm.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-atmel-pwm.c
@@ -55,6 +55,7 @@ static int __init pwmled_probe(struct pl
 
 		led->cdev.name = dat->name;
 		led->cdev.brightness = LED_OFF;
+		led->cdev.max_brightness = LED_FULL;
 		led->cdev.brightness_set = pwmled_brightness;
 		led->cdev.default_trigger = dat->default_trigger;
 
diff -puN drivers/leds/leds-clevo-mail.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-clevo-mail.c
--- a/drivers/leds/leds-clevo-mail.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-clevo-mail.c
@@ -142,6 +142,7 @@ static struct led_classdev clevo_mail_le
 	.name			= "clevo::mail",
 	.brightness_set		= clevo_mail_led_set,
 	.blink_set		= clevo_mail_led_blink,
+	.max_brightness		= LED_FULL,
 };
 
 static int __init clevo_mail_led_probe(struct platform_device *pdev)
diff -puN drivers/leds/leds-cobalt-qube.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-cobalt-qube.c
--- a/drivers/leds/leds-cobalt-qube.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-cobalt-qube.c
@@ -30,6 +30,7 @@ static void qube_front_led_set(struct le
 static struct led_classdev qube_front_led = {
 	.name			= "qube-front",
 	.brightness		= LED_FULL,
+	.max_brightness		= LED_FULL,
 	.brightness_set		= qube_front_led_set,
 	.default_trigger	= "ide-disk",
 };
diff -puN drivers/leds/leds-cobalt-raq.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-cobalt-raq.c
--- a/drivers/leds/leds-cobalt-raq.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-cobalt-raq.c
@@ -51,6 +51,7 @@ static void raq_web_led_set(struct led_c
 static struct led_classdev raq_web_led = {
 	.name		= "raq-web",
 	.brightness_set	= raq_web_led_set,
+	.max_brightness	= LED_FULL,
 };
 
 static void raq_power_off_led_set(struct led_classdev *led_cdev,
@@ -72,6 +73,7 @@ static void raq_power_off_led_set(struct
 static struct led_classdev raq_power_off_led = {
 	.name			= "raq-power-off",
 	.brightness_set		= raq_power_off_led_set,
+	.max_brightness		= LED_FULL,
 	.default_trigger	= "power-off",
 };
 
diff -puN drivers/leds/leds-da903x.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-da903x.c
--- a/drivers/leds/leds-da903x.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-da903x.c
@@ -117,6 +117,7 @@ static int __devinit da903x_led_probe(st
 	led->cdev.default_trigger = pdata->default_trigger;
 	led->cdev.brightness_set = da903x_led_set;
 	led->cdev.brightness = LED_OFF;
+	led->cdev.max_brightness = LED_FULL;
 
 	led->id = id;
 	led->flags = pdata->flags;
diff -puN drivers/leds/leds-fsg.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-fsg.c
--- a/drivers/leds/leds-fsg.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-fsg.c
@@ -103,31 +103,37 @@ static void fsg_led_ring_set(struct led_
 static struct led_classdev fsg_wlan_led = {
 	.name			= "fsg:blue:wlan",
 	.brightness_set		= fsg_led_wlan_set,
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev fsg_wan_led = {
 	.name			= "fsg:blue:wan",
 	.brightness_set		= fsg_led_wan_set,
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev fsg_sata_led = {
 	.name			= "fsg:blue:sata",
 	.brightness_set		= fsg_led_sata_set,
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev fsg_usb_led = {
 	.name			= "fsg:blue:usb",
 	.brightness_set		= fsg_led_usb_set,
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev fsg_sync_led = {
 	.name			= "fsg:blue:sync",
 	.brightness_set		= fsg_led_sync_set,
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev fsg_ring_led = {
 	.name			= "fsg:blue:ring",
 	.brightness_set		= fsg_led_ring_set,
+	.max_brightness		= LED_FULL,
 };
 
 
diff -puN drivers/leds/leds-gpio.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-gpio.c
--- a/drivers/leds/leds-gpio.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-gpio.c
@@ -105,6 +105,7 @@ static int gpio_led_probe(struct platfor
 		}
 		led_dat->cdev.brightness_set = gpio_led_set;
 		led_dat->cdev.brightness = LED_OFF;
+		led_dat->cdev.max_brightness = LED_FULL;
 
 		gpio_direction_output(led_dat->gpio, led_dat->active_low);
 
diff -puN drivers/leds/leds-h1940.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-h1940.c
--- a/drivers/leds/leds-h1940.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-h1940.c
@@ -48,6 +48,7 @@ static struct led_classdev h1940_greenle
 	.name			= "h1940:green",
 	.brightness_set		= h1940_greenled_set,
 	.default_trigger	= "h1940-charger",
+	.max_brightness		= LED_FULL,
 };
 
 /*
@@ -78,6 +79,7 @@ static struct led_classdev h1940_redled 
 	.name			= "h1940:red",
 	.brightness_set		= h1940_redled_set,
 	.default_trigger	= "h1940-charger",
+	.max_brightness		= LED_FULL,
 };
 
 /*
@@ -102,6 +104,7 @@ static struct led_classdev h1940_blueled
 	.name			= "h1940:blue",
 	.brightness_set		= h1940_blueled_set,
 	.default_trigger	= "h1940-bluetooth",
+	.max_brightness		= LED_FULL,
 };
 
 static int __init h1940leds_probe(struct platform_device *pdev)
diff -puN drivers/leds/leds-hp-disk.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-hp-disk.c
--- a/drivers/leds/leds-hp-disk.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-hp-disk.c
@@ -68,6 +68,7 @@ static struct led_classdev hpled_led = {
 	.name			= "hp:red:hddprotection",
 	.default_trigger	= "heartbeat",
 	.brightness_set		= hpled_set,
+	.max_brightness		= LED_FULL,
 };
 
 #ifdef CONFIG_PM
diff -puN drivers/leds/leds-hp6xx.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-hp6xx.c
--- a/drivers/leds/leds-hp6xx.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-hp6xx.c
@@ -45,12 +45,14 @@ static struct led_classdev hp6xx_red_led
 	.name			= "hp6xx:red",
 	.default_trigger	= "hp6xx-charge",
 	.brightness_set		= hp6xxled_red_set,
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev hp6xx_green_led = {
 	.name			= "hp6xx:green",
 	.default_trigger	= "ide-disk",
 	.brightness_set		= hp6xxled_green_set,
+	.max_brightness		= LED_FULL,
 };
 
 #ifdef CONFIG_PM
diff -puN drivers/leds/leds-locomo.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-locomo.c
--- a/drivers/leds/leds-locomo.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-locomo.c
@@ -46,12 +46,14 @@ static struct led_classdev locomo_led0 =
 	.name			= "locomo:amber:charge",
 	.default_trigger	= "sharpsl-charge",
 	.brightness_set		= locomoled_brightness_set0,
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev locomo_led1 = {
 	.name			= "locomo:green:mail",
 	.default_trigger	= "nand-disk",
 	.brightness_set		= locomoled_brightness_set1,
+	.max_brightness		= LED_FULL,
 };
 
 static int locomoled_probe(struct locomo_dev *ldev)
diff -puN drivers/leds/leds-net48xx.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-net48xx.c
--- a/drivers/leds/leds-net48xx.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-net48xx.c
@@ -33,6 +33,7 @@ static void net48xx_error_led_set(struct
 static struct led_classdev net48xx_error_led = {
 	.name		= "net48xx::error",
 	.brightness_set	= net48xx_error_led_set,
+	.max_brightness	= LED_FULL,
 };
 
 #ifdef CONFIG_PM
diff -puN drivers/leds/leds-pca9532.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-pca9532.c
--- a/drivers/leds/leds-pca9532.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-pca9532.c
@@ -230,6 +230,7 @@ static int pca9532_configure(struct i2c_
 			led->name =  pled->name;
 			led->ldev.name = led->name;
 			led->ldev.brightness = LED_OFF;
+			led->ldev.max_brightness = LED_FULL;
 			led->ldev.brightness_set = pca9532_set_brightness;
 			led->ldev.blink_set = pca9532_set_blink;
                        INIT_WORK(&led->work, pca9532_led_work);
diff -puN drivers/leds/leds-pca955x.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-pca955x.c
--- a/drivers/leds/leds-pca955x.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-pca955x.c
@@ -310,6 +310,7 @@ static int __devinit pca955x_probe(struc
 
 		pca955x[i].led_cdev.name = pca955x[i].name;
 		pca955x[i].led_cdev.brightness_set = pca955x_led_set;
+		pca955x[i].led_cdev.max_brightness = LED_FULL;
 
 		INIT_WORK(&pca955x[i].work, pca955x_led_work);
 
diff -puN drivers/leds/leds-s3c24xx.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-s3c24xx.c
--- a/drivers/leds/leds-s3c24xx.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-s3c24xx.c
@@ -80,6 +80,7 @@ static int s3c24xx_led_probe(struct plat
 	platform_set_drvdata(dev, led);
 
 	led->cdev.brightness_set = s3c24xx_led_set;
+	led->cdev.max_brightness = LED_FULL;
 	led->cdev.default_trigger = pdata->def_trigger;
 	led->cdev.name = pdata->name;
 
diff -puN drivers/leds/leds-sunfire.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-sunfire.c
--- a/drivers/leds/leds-sunfire.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-sunfire.c
@@ -146,6 +146,7 @@ static int __devinit sunfire_led_generic
 		p->leds[i].reg = (void __iomem *) pdev->resource[0].start;
 		lp->name = types[i].name;
 		lp->brightness = LED_FULL;
+		lp->max_brightness = LED_FULL;
 		lp->brightness_set = types[i].handler;
 		lp->default_trigger = types[i].default_trigger;
 
diff -puN drivers/leds/leds-wrap.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds-wrap.c
--- a/drivers/leds/leds-wrap.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds-wrap.c
@@ -56,16 +56,19 @@ static struct led_classdev wrap_power_le
 	.name			= "wrap::power",
 	.brightness_set		= wrap_power_led_set,
 	.default_trigger	= "default-on",
+	.max_brightness		= LED_FULL,
 };
 
 static struct led_classdev wrap_error_led = {
 	.name		= "wrap::error",
 	.brightness_set	= wrap_error_led_set,
+	.max_brightness	= LED_FULL,
 };
 
 static struct led_classdev wrap_extra_led = {
 	.name           = "wrap::extra",
 	.brightness_set = wrap_extra_led_set,
+	.max_brightness	= LED_FULL,
 };
 
 #ifdef CONFIG_PM
diff -puN drivers/leds/leds.h~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/leds.h
--- a/drivers/leds/leds.h~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/leds.h
@@ -20,8 +20,8 @@
 static inline void led_set_brightness(struct led_classdev *led_cdev,
 					enum led_brightness value)
 {
-	if (value > LED_FULL)
-		value = LED_FULL;
+	if (value > led_cdev->max_brightness)
+		value = led_cdev->max_brightness;
 	led_cdev->brightness = value;
 	if (!(led_cdev->flags & LED_SUSPENDED))
 		led_cdev->brightness_set(led_cdev, value);
diff -puN drivers/leds/ledtrig-default-on.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/ledtrig-default-on.c
--- a/drivers/leds/ledtrig-default-on.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/ledtrig-default-on.c
@@ -19,7 +19,7 @@
 
 static void defon_trig_activate(struct led_classdev *led_cdev)
 {
-	led_set_brightness(led_cdev, LED_FULL);
+	led_set_brightness(led_cdev, led_cdev->max_brightness);
 }
 
 static struct led_trigger defon_led_trigger = {
diff -puN drivers/leds/ledtrig-heartbeat.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/ledtrig-heartbeat.c
--- a/drivers/leds/ledtrig-heartbeat.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/ledtrig-heartbeat.c
@@ -47,7 +47,7 @@ static void led_heartbeat_function(unsig
 			msecs_to_jiffies(heartbeat_data->period);
 		delay = msecs_to_jiffies(70);
 		heartbeat_data->phase++;
-		brightness = LED_FULL;
+		brightness = led_cdev->max_brightness;
 		break;
 	case 1:
 		delay = heartbeat_data->period / 4 - msecs_to_jiffies(70);
@@ -56,7 +56,7 @@ static void led_heartbeat_function(unsig
 	case 2:
 		delay = msecs_to_jiffies(70);
 		heartbeat_data->phase++;
-		brightness = LED_FULL;
+		brightness = led_cdev->max_brightness;
 		break;
 	default:
 		delay = heartbeat_data->period - heartbeat_data->period / 4 -
diff -puN drivers/leds/ledtrig-ide-disk.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/ledtrig-ide-disk.c
--- a/drivers/leds/ledtrig-ide-disk.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/ledtrig-ide-disk.c
@@ -37,7 +37,8 @@ static void ledtrig_ide_timerfunc(unsign
 {
 	if (ide_lastactivity != ide_activity) {
 		ide_lastactivity = ide_activity;
-		led_trigger_event(ledtrig_ide, LED_FULL);
+		/* INT_MAX will set each LED to its maximum brightness */
+		led_trigger_event(ledtrig_ide, INT_MAX);
 		mod_timer(&ledtrig_ide_timer, jiffies + msecs_to_jiffies(10));
 	} else {
 		led_trigger_event(ledtrig_ide, LED_OFF);
diff -puN drivers/leds/ledtrig-timer.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values drivers/leds/ledtrig-timer.c
--- a/drivers/leds/ledtrig-timer.c~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/drivers/leds/ledtrig-timer.c
@@ -158,7 +158,7 @@ static void timer_trig_activate(struct l
 
 	timer_data->brightness_on = led_get_brightness(led_cdev);
 	if (timer_data->brightness_on == LED_OFF)
-		timer_data->brightness_on = LED_FULL;
+		timer_data->brightness_on = led_cdev->max_brightness;
 	led_cdev->trigger_data = timer_data;
 
 	init_timer(&timer_data->timer);
diff -puN include/linux/leds.h~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values include/linux/leds.h
--- a/include/linux/leds.h~leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values
+++ a/include/linux/leds.h
@@ -30,6 +30,7 @@ enum led_brightness {
 struct led_classdev {
 	const char		*name;
 	int			 brightness;
+	int			 max_brightness;
 	int			 flags;
 
 #define LED_SUSPENDED		(1 << 0)
_

Patches currently in -mm which might be from lg@denx.de are

origin.patch
leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values.patch
leds-add-a-dac124s085-spi-led-driver.patch
leds-add-a-dac124s085-spi-led-driver-fix.patch


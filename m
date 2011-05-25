From: akpm@linux-foundation.org
Subject: [merged] leds-remove-the-leds-h1940-driver.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:00 -0700
Message-ID: <201105252030.p4PKUNYg014957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932309Ab1EYUb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:31:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anarsoul@gmail.com, arnaud.patard@rtp-net.org, ben-linux@fluff.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: remove the leds-h1940 driver
has been removed from the -mm tree.  Its filename was
     leds-remove-the-leds-h1940-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: remove the leds-h1940 driver
From: Vasily Khoruzhick <anarsoul@gmail.com>

The H1940 machine now uses leds-gpio and leds-h1940 has no users anymore. 

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig      |    7 -
 drivers/leds/Makefile     |    1 
 drivers/leds/leds-h1940.c |  170 ------------------------------------
 3 files changed, 178 deletions(-)

diff -puN drivers/leds/Kconfig~leds-remove-the-leds-h1940-driver drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-remove-the-leds-h1940-driver
+++ a/drivers/leds/Kconfig
@@ -115,13 +115,6 @@ config LEDS_ALIX2
 	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
 	  You have to set leds-alix2.force=1 for boards with Award BIOS.
 
-config LEDS_H1940
-	tristate "LED Support for iPAQ H1940 device"
-	depends on LEDS_CLASS
-	depends on ARCH_H1940
-	help
-	  This option enables support for the LEDs on the h1940.
-
 config LEDS_COBALT_QUBE
 	tristate "LED Support for the Cobalt Qube series front LED"
 	depends on LEDS_CLASS
diff -puN drivers/leds/Makefile~leds-remove-the-leds-h1940-driver drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-remove-the-leds-h1940-driver
+++ a/drivers/leds/Makefile
@@ -17,7 +17,6 @@ obj-$(CONFIG_LEDS_NET48XX)		+= leds-net4
 obj-$(CONFIG_LEDS_NET5501)		+= leds-net5501.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_ALIX2)		+= leds-alix2.o
-obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
 obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
 obj-$(CONFIG_LEDS_SUNFIRE)		+= leds-sunfire.o
diff -puN drivers/leds/leds-h1940.c~leds-remove-the-leds-h1940-driver /dev/null
--- a/drivers/leds/leds-h1940.c
+++ /dev/null
@@ -1,170 +0,0 @@
-/*
- * drivers/leds/leds-h1940.c
- * Copyright (c) Arnaud Patard <arnaud.patard@rtp-net.org>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive for
- * more details.
- *
- * H1940 leds driver
- *
- */
-
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/delay.h>
-#include <linux/string.h>
-#include <linux/ctype.h>
-#include <linux/leds.h>
-#include <linux/gpio.h>
-
-#include <mach/regs-gpio.h>
-#include <mach/hardware.h>
-#include <mach/h1940-latch.h>
-
-/*
- * Green led.
- */
-static void h1940_greenled_set(struct led_classdev *led_dev,
-			       enum led_brightness value)
-{
-	switch (value) {
-	case LED_HALF:
-		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
-		s3c2410_gpio_setpin(S3C2410_GPA7, 1);
-		break;
-	case LED_FULL:
-		h1940_latch_control(0, H1940_LATCH_LED_GREEN);
-		s3c2410_gpio_setpin(S3C2410_GPA7, 1);
-		break;
-	default:
-	case LED_OFF:
-		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
-		h1940_latch_control(H1940_LATCH_LED_GREEN, 0);
-		s3c2410_gpio_setpin(S3C2410_GPA7, 0);
-		break;
-	}
-}
-
-static struct led_classdev h1940_greenled = {
-	.name			= "h1940:green",
-	.brightness_set		= h1940_greenled_set,
-	.default_trigger	= "h1940-charger",
-};
-
-/*
- * Red led.
- */
-static void h1940_redled_set(struct led_classdev *led_dev,
-			     enum led_brightness value)
-{
-	switch (value) {
-	case LED_HALF:
-		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
-		s3c2410_gpio_setpin(S3C2410_GPA1, 1);
-		break;
-	case LED_FULL:
-		h1940_latch_control(0, H1940_LATCH_LED_RED);
-		s3c2410_gpio_setpin(S3C2410_GPA1, 1);
-		break;
-	default:
-	case LED_OFF:
-		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
-		h1940_latch_control(H1940_LATCH_LED_RED, 0);
-		s3c2410_gpio_setpin(S3C2410_GPA1, 0);
-		break;
-	}
-}
-
-static struct led_classdev h1940_redled = {
-	.name			= "h1940:red",
-	.brightness_set		= h1940_redled_set,
-	.default_trigger	= "h1940-charger",
-};
-
-/*
- * Blue led.
- * (it can only be blue flashing led)
- */
-static void h1940_blueled_set(struct led_classdev *led_dev,
-			      enum led_brightness value)
-{
-	if (value) {
-		/* flashing Blue */
-		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
-		s3c2410_gpio_setpin(S3C2410_GPA3, 1);
-	} else {
-		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
-		s3c2410_gpio_setpin(S3C2410_GPA3, 0);
-	}
-
-}
-
-static struct led_classdev h1940_blueled = {
-	.name			= "h1940:blue",
-	.brightness_set		= h1940_blueled_set,
-	.default_trigger	= "h1940-bluetooth",
-};
-
-static int __devinit h1940leds_probe(struct platform_device *pdev)
-{
-	int ret;
-
-	ret = led_classdev_register(&pdev->dev, &h1940_greenled);
-	if (ret)
-		goto err_green;
-
-	ret = led_classdev_register(&pdev->dev, &h1940_redled);
-	if (ret)
-		goto err_red;
-
-	ret = led_classdev_register(&pdev->dev, &h1940_blueled);
-	if (ret)
-		goto err_blue;
-
-	return 0;
-
-err_blue:
-	led_classdev_unregister(&h1940_redled);
-err_red:
-	led_classdev_unregister(&h1940_greenled);
-err_green:
-	return ret;
-}
-
-static int h1940leds_remove(struct platform_device *pdev)
-{
-	led_classdev_unregister(&h1940_greenled);
-	led_classdev_unregister(&h1940_redled);
-	led_classdev_unregister(&h1940_blueled);
-	return 0;
-}
-
-
-static struct platform_driver h1940leds_driver = {
-	.driver		= {
-		.name	= "h1940-leds",
-		.owner	= THIS_MODULE,
-	},
-	.probe		= h1940leds_probe,
-	.remove		= h1940leds_remove,
-};
-
-
-static int __init h1940leds_init(void)
-{
-	return platform_driver_register(&h1940leds_driver);
-}
-
-static void __exit h1940leds_exit(void)
-{
-	platform_driver_unregister(&h1940leds_driver);
-}
-
-module_init(h1940leds_init);
-module_exit(h1940leds_exit);

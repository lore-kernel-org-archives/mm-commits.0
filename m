From: akpm@linux-foundation.org
Subject: + backlight-locomolcd-fix-checkpatch-error-and-warning.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:13:59 -0700
Message-ID: <20121017231400.B14DB5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:39710 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2JQXOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:14:04 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so492615lbo.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:14:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: locomolcd: fix checkpatch error and warning
has been added to the -mm tree.  Its filename is
     backlight-locomolcd-fix-checkpatch-error-and-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: locomolcd: fix checkpatch error and warning

This patch fixes the checkpatch error and warning as below:

WARNING: line over 80 characters
WARNING: space prohibited between function name and open parenthesis '('
ERROR: trailing statements should be on next line

Also, long comments are fixed for the preferred style and
unnecessary lines are removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/locomolcd.c |   65 +++++++++++++++++---------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff -puN drivers/video/backlight/locomolcd.c~backlight-locomolcd-fix-checkpatch-error-and-warning drivers/video/backlight/locomolcd.c
--- a/drivers/video/backlight/locomolcd.c~backlight-locomolcd-fix-checkpatch-error-and-warning
+++ a/drivers/video/backlight/locomolcd.c
@@ -33,19 +33,25 @@ static unsigned long locomolcd_flags;
 
 static void locomolcd_on(int comadj)
 {
-	locomo_gpio_set_dir(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VSHA_ON, 0);
-	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VSHA_ON, 1);
+	locomo_gpio_set_dir(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VSHA_ON, 0);
+	locomo_gpio_write(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VSHA_ON, 1);
 	mdelay(2);
 
-	locomo_gpio_set_dir(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VSHD_ON, 0);
-	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VSHD_ON, 1);
+	locomo_gpio_set_dir(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VSHD_ON, 0);
+	locomo_gpio_write(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VSHD_ON, 1);
 	mdelay(2);
 
 	locomo_m62332_senddata(locomolcd_dev, comadj, 0);
 	mdelay(5);
 
-	locomo_gpio_set_dir(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VEE_ON, 0);
-	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VEE_ON, 1);
+	locomo_gpio_set_dir(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VEE_ON, 0);
+	locomo_gpio_write(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VEE_ON, 1);
 	mdelay(10);
 
 	/* TFTCRST | CPSOUT=0 | CPSEN */
@@ -68,16 +74,19 @@ static void locomolcd_off(int comadj)
 	locomo_writel(0x06, locomolcd_dev->mapbase + LOCOMO_TC);
 	mdelay(1);
 
-	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VSHA_ON, 0);
+	locomo_gpio_write(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VSHA_ON, 0);
 	mdelay(110);
 
-	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VEE_ON, 0);
+	locomo_gpio_write(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VEE_ON, 0);
 	mdelay(700);
 
 	/* TFTCRST=0 | CPSOUT=0 | CPSEN = 0 */
 	locomo_writel(0, locomolcd_dev->mapbase + LOCOMO_TC);
 	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_MOD, 0);
-	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VSHD_ON, 0);
+	locomo_gpio_write(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VSHD_ON, 0);
 }
 
 void locomolcd_power(int on)
@@ -107,7 +116,6 @@ void locomolcd_power(int on)
 }
 EXPORT_SYMBOL(locomolcd_power);
 
-
 static int current_intensity;
 
 static int locomolcd_set_intensity(struct backlight_device *bd)
@@ -122,13 +130,25 @@ static int locomolcd_set_intensity(struc
 		intensity = 0;
 
 	switch (intensity) {
-	/* AC and non-AC are handled differently, but produce same results in sharp code? */
-	case 0: locomo_frontlight_set(locomolcd_dev, 0, 0, 161); break;
-	case 1: locomo_frontlight_set(locomolcd_dev, 117, 0, 161); break;
-	case 2: locomo_frontlight_set(locomolcd_dev, 163, 0, 148); break;
-	case 3: locomo_frontlight_set(locomolcd_dev, 194, 0, 161); break;
-	case 4: locomo_frontlight_set(locomolcd_dev, 194, 1, 161); break;
-
+	/*
+	 * AC and non-AC are handled differently,
+	 * but produce same results in sharp code?
+	 */
+	case 0:
+		locomo_frontlight_set(locomolcd_dev, 0, 0, 161);
+		break;
+	case 1:
+		locomo_frontlight_set(locomolcd_dev, 117, 0, 161);
+		break;
+	case 2:
+		locomo_frontlight_set(locomolcd_dev, 163, 0, 148);
+		break;
+	case 3:
+		locomo_frontlight_set(locomolcd_dev, 194, 0, 161);
+		break;
+	case 4:
+		locomo_frontlight_set(locomolcd_dev, 194, 1, 161);
+		break;
 	default:
 		return -ENODEV;
 	}
@@ -175,9 +195,11 @@ static int locomolcd_probe(struct locomo
 
 	locomo_gpio_set_dir(ldev->dev.parent, LOCOMO_GPIO_FL_VR, 0);
 
-	/* the poodle_lcd_power function is called for the first time
+	/*
+	 * the poodle_lcd_power function is called for the first time
 	 * from fs_initcall, which is before locomo is activated.
-	 * We need to recall poodle_lcd_power here*/
+	 * We need to recall poodle_lcd_power here
+	 */
 	if (machine_is_poodle())
 		locomolcd_power(1);
 
@@ -190,8 +212,8 @@ static int locomolcd_probe(struct locomo
 							&ldev->dev, NULL,
 							&locomobl_data, &props);
 
-	if (IS_ERR (locomolcd_bl_device))
-		return PTR_ERR (locomolcd_bl_device);
+	if (IS_ERR(locomolcd_bl_device))
+		return PTR_ERR(locomolcd_bl_device);
 
 	/* Set up frontlight so that screen is readable */
 	locomolcd_bl_device->props.brightness = 2;
@@ -226,7 +248,6 @@ static struct locomo_driver poodle_lcd_d
 	.resume = locomolcd_resume,
 };
 
-
 static int __init locomolcd_init(void)
 {
 	return locomo_driver_register(&poodle_lcd_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata.patch
backlight-88pm860x_bl-fix-checkpatch-warning.patch
backlight-atmel-pwm-bl-fix-checkpatch-warning.patch
backlight-corgi_lcd-fix-checkpatch-error-and-warning.patch
backlight-da903x_bl-fix-checkpatch-warning.patch
backlight-generic_bl-fix-checkpatch-warning.patch
backlight-hp680_bl-fix-checkpatch-error-and-warning.patch
backlight-ili9320-fix-checkpatch-error-and-warning.patch
backlight-jornada720-fix-checkpatch-error-and-warning.patch
backlight-l4f00242t03-fix-checkpatch-warning.patch
backlight-lm3630-fix-checkpatch-warning.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch
backlight-omap1-fix-checkpatch-warning.patch
backlight-pcf50633-fix-checkpatch-warning.patch
backlight-platform_lcd-fix-checkpatch-error.patch
backlight-tdo24m-fix-checkpatch-warning.patch
backlight-tosa-fix-checkpatch-error-and-warning.patch
backlight-vgg2432a4-fix-checkpatch-warning.patch


From: akpm@linux-foundation.org
Subject: + backlight-corgi_lcd-use-devm_-functions.patch added to -mm tree
Date: Fri, 25 May 2012 13:47:31 -0700
Message-ID: <20120525204732.276C3A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:36895 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965290Ab2EYUrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 16:47:33 -0400
Received: by yhgm50 with SMTP id m50so143427yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 13:47:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, eric.y.miao@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: corgi_lcd: use devm_ functions
has been added to the -mm tree.  Its filename is
     backlight-corgi_lcd-use-devm_-functions.patch

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
Subject: backlight: corgi_lcd: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/corgi_lcd.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-devm_-functions drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-devm_-functions
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -544,7 +544,7 @@ static int __devinit corgi_lcd_probe(str
 		return -EINVAL;
 	}
 
-	lcd = kzalloc(sizeof(struct corgi_lcd), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct corgi_lcd), GFP_KERNEL);
 	if (!lcd) {
 		dev_err(&spi->dev, "failed to allocate memory\n");
 		return -ENOMEM;
@@ -554,10 +554,9 @@ static int __devinit corgi_lcd_probe(str
 
 	lcd->lcd_dev = lcd_device_register("corgi_lcd", &spi->dev,
 					lcd, &corgi_lcd_ops);
-	if (IS_ERR(lcd->lcd_dev)) {
-		ret = PTR_ERR(lcd->lcd_dev);
-		goto err_free_lcd;
-	}
+	if (IS_ERR(lcd->lcd_dev))
+		return PTR_ERR(lcd->lcd_dev);
+
 	lcd->power = FB_BLANK_POWERDOWN;
 	lcd->mode = (pdata) ? pdata->init_mode : CORGI_LCD_MODE_VGA;
 
@@ -591,8 +590,6 @@ err_unregister_bl:
 	backlight_device_unregister(lcd->bl_dev);
 err_unregister_lcd:
 	lcd_device_unregister(lcd->lcd_dev);
-err_free_lcd:
-	kfree(lcd);
 	return ret;
 }
 
@@ -613,7 +610,6 @@ static int __devexit corgi_lcd_remove(st
 
 	corgi_lcd_set_power(lcd->lcd_dev, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->lcd_dev);
-	kfree(lcd);
 
 	return 0;
 }
_
Subject: Subject: backlight: corgi_lcd: use devm_ functions

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
backlight-adp8860-use-kstrtoul.patch
backlight-adp8870-use-kstrtoul.patch
backlight-adp5520-use-kstrtoul.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk-fix.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-generic_bl-use-pr_info-instead-of-printk.patch
backlight-generic_bl-use-pr_info-instead-of-printk-fix.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-omap1-use-pr_info-instead-of-printk.patch
backlight-omap1-use-pr_info-instead-of-printk-fix.patch
backlight-progear-use-pr_err-instead-of-printk.patch
backlight-progear-use-pr_err-instead-of-printk-fix.patch
drivers-video-backlight-l4f00242t03c-use-pr_fmt.patch
backlight-initialize-struct-backlight_properties-properly.patch
backlight-adp8860-use-devm_-functions.patch
backlight-adp8870-use-devm_-functions.patch
backlight-ams369fg06-use-devm_-functions.patch
backlight-corgi_lcd-use-devm_-functions.patch
backlight-ili9320-use-devm_-functions.patch
backlight-l4f00242t03-use-devm_-functions.patch
backlight-ld9040-use-devm_-functions.patch
backlight-lms283gf05-use-devm_-functions.patch
backlight-ltv350qv-use-devm_-functions.patch
backlight-s6e63m0-use-devm_-functions.patch
backlight-tdo24m-use-devm_-functions.patch
backlight-tosa_bl-use-devm_-functions.patch
backlight-tosa_lcd-use-devm_-functions.patch


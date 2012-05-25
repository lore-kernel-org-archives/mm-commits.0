From: akpm@linux-foundation.org
Subject: + backlight-ams369fg06-use-devm_-functions.patch added to -mm tree
Date: Fri, 25 May 2012 13:47:29 -0700
Message-ID: <20120525204729.E0BD9A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:59337 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965284Ab2EYUrc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 16:47:32 -0400
Received: by wgbdt11 with SMTP id dt11so78103wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 13:47:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: ams369fg06: use devm_ functions
has been added to the -mm tree.  Its filename is
     backlight-ams369fg06-use-devm_-functions.patch

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
Subject: backlight: ams369fg06: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-use-devm_-functions drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-use-devm_-functions
+++ a/drivers/video/backlight/ams369fg06.c
@@ -482,7 +482,7 @@ static int __devinit ams369fg06_probe(st
 	struct backlight_device *bd = NULL;
 	struct backlight_properties props;
 
-	lcd = kzalloc(sizeof(struct ams369fg06), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct ams369fg06), GFP_KERNEL);
 	if (!lcd)
 		return -ENOMEM;
 
@@ -492,7 +492,7 @@ static int __devinit ams369fg06_probe(st
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		dev_err(&spi->dev, "spi setup failed.\n");
-		goto out_free_lcd;
+		return ret;
 	}
 
 	lcd->spi = spi;
@@ -501,15 +501,13 @@ static int __devinit ams369fg06_probe(st
 	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL\n");
-		goto out_free_lcd;
+		return -EFAULT;
 	}
 
 	ld = lcd_device_register("ams369fg06", &spi->dev, lcd,
 		&ams369fg06_lcd_ops);
-	if (IS_ERR(ld)) {
-		ret = PTR_ERR(ld);
-		goto out_free_lcd;
-	}
+	if (IS_ERR(ld))
+		return PTR_ERR(ld);
 
 	lcd->ld = ld;
 
@@ -547,8 +545,6 @@ static int __devinit ams369fg06_probe(st
 
 out_lcd_unregister:
 	lcd_device_unregister(ld);
-out_free_lcd:
-	kfree(lcd);
 	return ret;
 }
 
@@ -559,7 +555,6 @@ static int __devexit ams369fg06_remove(s
 	ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
 	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
-	kfree(lcd);
 
 	return 0;
 }
_
Subject: Subject: backlight: ams369fg06: use devm_ functions

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


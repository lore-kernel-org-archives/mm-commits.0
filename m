From: akpm@linux-foundation.org
Subject: + backlight-ld9040-use-devm_-functions.patch added to -mm tree
Date: Fri, 25 May 2012 13:47:37 -0700
Message-ID: <20120525204737.E914CA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:36895 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934069Ab2EYUri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 16:47:38 -0400
Received: by mail-yw0-f74.google.com with SMTP id m50so143427yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 13:47:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, dh09.lee@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: ld9040: use devm_ functions
has been added to the -mm tree.  Its filename is
     backlight-ld9040-use-devm_-functions.patch

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
Subject: backlight: ld9040: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Donghwa Lee <dh09.lee@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ld9040.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/video/backlight/ld9040.c~backlight-ld9040-use-devm_-functions drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~backlight-ld9040-use-devm_-functions
+++ a/drivers/video/backlight/ld9040.c
@@ -707,7 +707,7 @@ static int ld9040_probe(struct spi_devic
 	struct backlight_device *bd = NULL;
 	struct backlight_properties props;
 
-	lcd = kzalloc(sizeof(struct ld9040), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct ld9040), GFP_KERNEL);
 	if (!lcd)
 		return -ENOMEM;
 
@@ -717,7 +717,7 @@ static int ld9040_probe(struct spi_devic
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		dev_err(&spi->dev, "spi setup failed.\n");
-		goto out_free_lcd;
+		return ret;
 	}
 
 	lcd->spi = spi;
@@ -726,7 +726,7 @@ static int ld9040_probe(struct spi_devic
 	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
-		goto out_free_lcd;
+		return -EFAULT;
 	}
 
 	mutex_init(&lcd->lock);
@@ -734,13 +734,13 @@ static int ld9040_probe(struct spi_devic
 	ret = regulator_bulk_get(lcd->dev, ARRAY_SIZE(supplies), supplies);
 	if (ret) {
 		dev_err(lcd->dev, "Failed to get regulators: %d\n", ret);
-		goto out_free_lcd;
+		return ret;
 	}
 
 	ld = lcd_device_register("ld9040", &spi->dev, lcd, &ld9040_lcd_ops);
 	if (IS_ERR(ld)) {
 		ret = PTR_ERR(ld);
-		goto out_free_lcd;
+		goto out_free_regulator;
 	}
 
 	lcd->ld = ld;
@@ -782,10 +782,9 @@ static int ld9040_probe(struct spi_devic
 
 out_unregister_lcd:
 	lcd_device_unregister(lcd->ld);
-out_free_lcd:
+out_free_regulator:
 	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
 
-	kfree(lcd);
 	return ret;
 }
 
@@ -797,7 +796,6 @@ static int __devexit ld9040_remove(struc
 	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
 	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
-	kfree(lcd);
 
 	return 0;
 }
_
Subject: Subject: backlight: ld9040: use devm_ functions

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


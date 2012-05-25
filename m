From: akpm@linux-foundation.org
Subject: + backlight-tosa_lcd-use-devm_-functions.patch added to -mm tree
Date: Fri, 25 May 2012 13:47:49 -0700
Message-ID: <20120525204750.28873A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:49537 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934054Ab2EYUrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 16:47:51 -0400
Received: by ggeh3 with SMTP id h3so149919gge.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 13:47:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, dbaryshkov@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: tosa_lcd: use devm_ functions
has been added to the -mm tree.  Its filename is
     backlight-tosa_lcd-use-devm_-functions.patch

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
Subject: backlight: tosa_lcd: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_lcd.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/tosa_lcd.c~backlight-tosa_lcd-use-devm_-functions drivers/video/backlight/tosa_lcd.c
--- a/drivers/video/backlight/tosa_lcd.c~backlight-tosa_lcd-use-devm_-functions
+++ a/drivers/video/backlight/tosa_lcd.c
@@ -174,7 +174,8 @@ static int __devinit tosa_lcd_probe(stru
 	int ret;
 	struct tosa_lcd_data *data;
 
-	data = kzalloc(sizeof(struct tosa_lcd_data), GFP_KERNEL);
+	data = devm_kzalloc(&spi->dev, sizeof(struct tosa_lcd_data),
+				GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -187,7 +188,7 @@ static int __devinit tosa_lcd_probe(stru
 
 	ret = spi_setup(spi);
 	if (ret < 0)
-		goto err_spi;
+		return ret;
 
 	data->spi = spi;
 	dev_set_drvdata(&spi->dev, data);
@@ -224,8 +225,6 @@ err_gpio_dir:
 	gpio_free(TOSA_GPIO_TG_ON);
 err_gpio_tg:
 	dev_set_drvdata(&spi->dev, NULL);
-err_spi:
-	kfree(data);
 	return ret;
 }
 
@@ -242,7 +241,6 @@ static int __devexit tosa_lcd_remove(str
 
 	gpio_free(TOSA_GPIO_TG_ON);
 	dev_set_drvdata(&spi->dev, NULL);
-	kfree(data);
 
 	return 0;
 }
_
Subject: Subject: backlight: tosa_lcd: use devm_ functions

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


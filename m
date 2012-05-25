From: akpm@linux-foundation.org
Subject: + backlight-tdo24m-use-devm_-functions.patch added to -mm tree
Date: Fri, 25 May 2012 13:47:45 -0700
Message-ID: <20120525204745.EEB48A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:44717 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934065Ab2EYUrq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 16:47:46 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so150530qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 13:47:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, eric.y.miao@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: tdo24m: use devm_ functions
has been added to the -mm tree.  Its filename is
     backlight-tdo24m-use-devm_-functions.patch

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
Subject: backlight: tdo24m: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tdo24m.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff -puN drivers/video/backlight/tdo24m.c~backlight-tdo24m-use-devm_-functions drivers/video/backlight/tdo24m.c
--- a/drivers/video/backlight/tdo24m.c~backlight-tdo24m-use-devm_-functions
+++ a/drivers/video/backlight/tdo24m.c
@@ -349,7 +349,7 @@ static int __devinit tdo24m_probe(struct
 	if (err)
 		return err;
 
-	lcd = kzalloc(sizeof(struct tdo24m), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct tdo24m), GFP_KERNEL);
 	if (!lcd)
 		return -ENOMEM;
 
@@ -357,11 +357,9 @@ static int __devinit tdo24m_probe(struct
 	lcd->power = FB_BLANK_POWERDOWN;
 	lcd->mode = MODE_VGA;	/* default to VGA */
 
-	lcd->buf = kmalloc(TDO24M_SPI_BUFF_SIZE, GFP_KERNEL);
-	if (lcd->buf == NULL) {
-		kfree(lcd);
+	lcd->buf = devm_kzalloc(&spi->dev, TDO24M_SPI_BUFF_SIZE, GFP_KERNEL);
+	if (lcd->buf == NULL)
 		return -ENOMEM;
-	}
 
 	m = &lcd->msg;
 	x = &lcd->xfer;
@@ -383,15 +381,13 @@ static int __devinit tdo24m_probe(struct
 		break;
 	default:
 		dev_err(&spi->dev, "Unsupported model");
-		goto out_free;
+		return -EINVAL;
 	}
 
 	lcd->lcd_dev = lcd_device_register("tdo24m", &spi->dev,
 					lcd, &tdo24m_ops);
-	if (IS_ERR(lcd->lcd_dev)) {
-		err = PTR_ERR(lcd->lcd_dev);
-		goto out_free;
-	}
+	if (IS_ERR(lcd->lcd_dev))
+		return PTR_ERR(lcd->lcd_dev);
 
 	dev_set_drvdata(&spi->dev, lcd);
 	err = tdo24m_power(lcd, FB_BLANK_UNBLANK);
@@ -402,9 +398,6 @@ static int __devinit tdo24m_probe(struct
 
 out_unregister:
 	lcd_device_unregister(lcd->lcd_dev);
-out_free:
-	kfree(lcd->buf);
-	kfree(lcd);
 	return err;
 }
 
@@ -414,8 +407,6 @@ static int __devexit tdo24m_remove(struc
 
 	tdo24m_power(lcd, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->lcd_dev);
-	kfree(lcd->buf);
-	kfree(lcd);
 
 	return 0;
 }
_
Subject: Subject: backlight: tdo24m: use devm_ functions

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


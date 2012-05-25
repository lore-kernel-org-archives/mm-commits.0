From: akpm@linux-foundation.org
Subject: + backlight-ltv350qv-use-devm_-functions.patch added to -mm tree
Date: Fri, 25 May 2012 13:47:41 -0700
Message-ID: <20120525204741.D62B0A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:45988 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934069Ab2EYUrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 16:47:43 -0400
Received: by vbnl22 with SMTP id l22so148873vbn.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 13:47:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, hskinnemoen@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: ltv350qv: use devm_ functions
has been added to the -mm tree.  Its filename is
     backlight-ltv350qv-use-devm_-functions.patch

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
Subject: backlight: ltv350qv: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ltv350qv.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff -puN drivers/video/backlight/ltv350qv.c~backlight-ltv350qv-use-devm_-functions drivers/video/backlight/ltv350qv.c
--- a/drivers/video/backlight/ltv350qv.c~backlight-ltv350qv-use-devm_-functions
+++ a/drivers/video/backlight/ltv350qv.c
@@ -232,23 +232,20 @@ static int __devinit ltv350qv_probe(stru
 	struct lcd_device *ld;
 	int ret;
 
-	lcd = kzalloc(sizeof(struct ltv350qv), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct ltv350qv), GFP_KERNEL);
 	if (!lcd)
 		return -ENOMEM;
 
 	lcd->spi = spi;
 	lcd->power = FB_BLANK_POWERDOWN;
-	lcd->buffer = kzalloc(8, GFP_KERNEL);
-	if (!lcd->buffer) {
-		ret = -ENOMEM;
-		goto out_free_lcd;
-	}
+	lcd->buffer = devm_kzalloc(&spi->dev, 8, GFP_KERNEL);
+	if (!lcd->buffer)
+		return -ENOMEM;
 
 	ld = lcd_device_register("ltv350qv", &spi->dev, lcd, &ltv_ops);
-	if (IS_ERR(ld)) {
-		ret = PTR_ERR(ld);
-		goto out_free_buffer;
-	}
+	if (IS_ERR(ld))
+		return PTR_ERR(ld);
+
 	lcd->ld = ld;
 
 	ret = ltv350qv_power(lcd, FB_BLANK_UNBLANK);
@@ -261,10 +258,6 @@ static int __devinit ltv350qv_probe(stru
 
 out_unregister:
 	lcd_device_unregister(ld);
-out_free_buffer:
-	kfree(lcd->buffer);
-out_free_lcd:
-	kfree(lcd);
 	return ret;
 }
 
@@ -274,8 +267,6 @@ static int __devexit ltv350qv_remove(str
 
 	ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->ld);
-	kfree(lcd->buffer);
-	kfree(lcd);
 
 	return 0;
 }
_
Subject: Subject: backlight: ltv350qv: use devm_ functions

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


From: akpm@linux-foundation.org
Subject: + backlight-ili9320-use-devm_-functions.patch added to -mm tree
Date: Fri, 25 May 2012 13:47:33 -0700
Message-ID: <20120525204733.C8316A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:49799 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933230Ab2EYUrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 16:47:35 -0400
Received: by qabg24 with SMTP id g24so204727qab.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 13:47:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, ben-linux@fluff.org, rpurdie@rpsys.net


The patch titled
     Subject: backlight: ili9320: use devm_ functions
has been added to the -mm tree.  Its filename is
     backlight-ili9320-use-devm_-functions.patch

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
Subject: backlight: ili9320: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ili9320.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/video/backlight/ili9320.c~backlight-ili9320-use-devm_-functions drivers/video/backlight/ili9320.c
--- a/drivers/video/backlight/ili9320.c~backlight-ili9320-use-devm_-functions
+++ a/drivers/video/backlight/ili9320.c
@@ -220,7 +220,7 @@ int __devinit ili9320_probe_spi(struct s
 
 	/* allocate and initialse our state */
 
-	ili = kzalloc(sizeof(struct ili9320), GFP_KERNEL);
+	ili = devm_kzalloc(&spi->dev, sizeof(struct ili9320), GFP_KERNEL);
 	if (ili == NULL) {
 		dev_err(dev, "no memory for device\n");
 		return -ENOMEM;
@@ -240,8 +240,7 @@ int __devinit ili9320_probe_spi(struct s
 	lcd = lcd_device_register("ili9320", dev, ili, &ili9320_ops);
 	if (IS_ERR(lcd)) {
 		dev_err(dev, "failed to register lcd device\n");
-		ret = PTR_ERR(lcd);
-		goto err_free;
+		return PTR_ERR(lcd);
 	}
 
 	ili->lcd = lcd;
@@ -259,9 +258,6 @@ int __devinit ili9320_probe_spi(struct s
  err_unregister:
 	lcd_device_unregister(lcd);
 
- err_free:
-	kfree(ili);
-
 	return ret;
 }
 
@@ -272,7 +268,6 @@ int __devexit ili9320_remove(struct ili9
 	ili9320_power(ili, FB_BLANK_POWERDOWN);
 
 	lcd_device_unregister(ili->lcd);
-	kfree(ili);
 
 	return 0;
 }
_
Subject: Subject: backlight: ili9320: use devm_ functions

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


From: akpm@linux-foundation.org
Subject: + backlight-lms283gf05-use-devm_-functions.patch added to -mm tree
Date: Fri, 25 May 2012 13:47:39 -0700
Message-ID: <20120525204739.E6FBEA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:37329 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934065Ab2EYUrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 16:47:42 -0400
Received: by faaa25 with SMTP id a25so69944faa.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 13:47:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, marek.vasut@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: lms283gf05: use devm_ functions
has been added to the -mm tree.  Its filename is
     backlight-lms283gf05-use-devm_-functions.patch

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
Subject: backlight: lms283gf05: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Marek Vasut <marek.vasut@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms283gf05.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-use-devm_-functions drivers/video/backlight/lms283gf05.c
--- a/drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-use-devm_-functions
+++ a/drivers/video/backlight/lms283gf05.c
@@ -168,7 +168,8 @@ static int __devinit lms283gf05_probe(st
 			goto err;
 	}
 
-	st = kzalloc(sizeof(struct lms283gf05_state), GFP_KERNEL);
+	st = devm_kzalloc(&spi->dev, sizeof(struct lms283gf05_state),
+				GFP_KERNEL);
 	if (st == NULL) {
 		dev_err(&spi->dev, "No memory for device state\n");
 		ret = -ENOMEM;
@@ -178,7 +179,7 @@ static int __devinit lms283gf05_probe(st
 	ld = lcd_device_register("lms283gf05", &spi->dev, st, &lms_ops);
 	if (IS_ERR(ld)) {
 		ret = PTR_ERR(ld);
-		goto err2;
+		goto err;
 	}
 
 	st->spi = spi;
@@ -193,8 +194,6 @@ static int __devinit lms283gf05_probe(st
 
 	return 0;
 
-err2:
-	kfree(st);
 err:
 	if (pdata != NULL)
 		gpio_free(pdata->reset_gpio);
@@ -212,8 +211,6 @@ static int __devexit lms283gf05_remove(s
 	if (pdata != NULL)
 		gpio_free(pdata->reset_gpio);
 
-	kfree(st);
-
 	return 0;
 }
 
_
Subject: Subject: backlight: lms283gf05: use devm_ functions

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


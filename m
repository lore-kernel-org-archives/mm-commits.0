From: akpm@linux-foundation.org
Subject: + backlight-ams369fg06-remove-unnecessary-null-deference-check.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:37:11 -0800
Message-ID: <20121220203712.9602C200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:48731 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2LTUhP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:37:15 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so207644bkc.5
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:37:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: ams369fg06: remove unnecessary NULL deference check
has been added to the -mm tree.  Its filename is
     backlight-ams369fg06-remove-unnecessary-null-deference-check.patch

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
Subject: backlight: ams369fg06: remove unnecessary NULL deference check

Remove unnecessary NULL deference check, because it was already checked in
ams369fg06_probe().  Also, unnecessary parentheses are removed in
ams369fg06_power_is_on().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |   32 ++++++-------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-remove-unnecessary-null-deference-check drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-remove-unnecessary-null-deference-check
+++ a/drivers/video/backlight/ams369fg06.c
@@ -314,26 +314,17 @@ static int ams369fg06_ldi_disable(struct
 
 static int ams369fg06_power_is_on(int power)
 {
-	return ((power) <= FB_BLANK_NORMAL);
+	return power <= FB_BLANK_NORMAL;
 }
 
 static int ams369fg06_power_on(struct ams369fg06 *lcd)
 {
 	int ret = 0;
-	struct lcd_platform_data *pd = NULL;
-	struct backlight_device *bd = NULL;
+	struct lcd_platform_data *pd;
+	struct backlight_device *bd;
 
 	pd = lcd->lcd_pd;
-	if (!pd) {
-		dev_err(lcd->dev, "platform data is NULL.\n");
-		return -EFAULT;
-	}
-
 	bd = lcd->bd;
-	if (!bd) {
-		dev_err(lcd->dev, "backlight device is NULL.\n");
-		return -EFAULT;
-	}
 
 	if (!pd->power_on) {
 		dev_err(lcd->dev, "power_on is NULL.\n");
@@ -375,14 +366,10 @@ static int ams369fg06_power_on(struct am
 
 static int ams369fg06_power_off(struct ams369fg06 *lcd)
 {
-	int ret = 0;
-	struct lcd_platform_data *pd = NULL;
+	int ret;
+	struct lcd_platform_data *pd;
 
 	pd = lcd->lcd_pd;
-	if (!pd) {
-		dev_err(lcd->dev, "platform data is NULL\n");
-		return -EFAULT;
-	}
 
 	ret = ams369fg06_ldi_disable(lcd);
 	if (ret) {
@@ -392,11 +379,7 @@ static int ams369fg06_power_off(struct a
 
 	msleep(pd->power_off_delay);
 
-	if (!pd->power_on) {
-		dev_err(lcd->dev, "power_on is NULL.\n");
-		return -EFAULT;
-	} else
-		pd->power_on(lcd->ld, 0);
+	pd->power_on(lcd->ld, 0);
 
 	return 0;
 }
@@ -535,8 +518,9 @@ static int ams369fg06_probe(struct spi_d
 		lcd->power = FB_BLANK_POWERDOWN;
 
 		ams369fg06_power(lcd, FB_BLANK_UNBLANK);
-	} else
+	} else {
 		lcd->power = FB_BLANK_UNBLANK;
+	}
 
 	dev_set_drvdata(&spi->dev, lcd);
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-add-lms501kf03-lcd-driver.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-ld9040-use-sleep-instead-of-delay.patch
backlight-ld9040-remove-unnecessary-null-deference-check.patch
backlight-ld9040-replace-efault-with-einval.patch
backlight-ld9040-remove-redundant-return-variables.patch
backlight-ld9040-reorder-inclusions-of-linux-xxxh.patch
backlight-s6e63m0-use-lowercase-names-of-structs.patch
backlight-s6e63m0-use-sleep-instead-of-delay.patch
backlight-s6e63m0-remove-unnecessary-null-deference-check.patch
backlight-s6e63m0-replace-efault-with-einval.patch
backlight-s6e63m0-remove-redundant-variable-before_power.patch
backlight-s6e63m0-reorder-inclusions-of-linux-xxxh.patch
backlight-ams369fg06-use-sleep-instead-of-delay.patch
backlight-ams369fg06-remove-unnecessary-null-deference-check.patch
backlight-ams369fg06-replace-efault-with-einval.patch
backlight-ams369fg06-remove-redundant-variable-before_power.patch
backlight-ams369fg06-reorder-inclusions-of-linux-xxxh.patch


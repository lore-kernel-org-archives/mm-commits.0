From: akpm@linux-foundation.org
Subject: + backlight-s6e63m0-remove-unnecessary-null-deference-check.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:35:54 -0800
Message-ID: <20121220203555.42CDD100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:35301 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2LTUf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:35:56 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so406163vbi.3
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:35:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: s6e63m0: remove unnecessary NULL deference check
has been added to the -mm tree.  Its filename is
     backlight-s6e63m0-remove-unnecessary-null-deference-check.patch

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
Subject: backlight: s6e63m0: remove unnecessary NULL deference check

Remove unnecessary NULL deference check, because it was already checked in
s6e63m0_probe().  Also, POWER_IS_ON is replaced with
s6e63m0_power_is_on().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |   41 +++++++++-------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff -puN drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-remove-unnecessary-null-deference-check drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-remove-unnecessary-null-deference-check
+++ a/drivers/video/backlight/s6e63m0.c
@@ -43,8 +43,6 @@
 #define MIN_BRIGHTNESS		0
 #define MAX_BRIGHTNESS		10
 
-#define POWER_IS_ON(pwr)	((pwr) <= FB_BLANK_NORMAL)
-
 struct s6e63m0 {
 	struct device			*dev;
 	struct spi_device		*spi;
@@ -501,23 +499,19 @@ static int s6e63m0_ldi_disable(struct s6
 	return ret;
 }
 
+static int s6e63m0_power_is_on(int power)
+{
+	return power <= FB_BLANK_NORMAL;
+}
+
 static int s6e63m0_power_on(struct s6e63m0 *lcd)
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
@@ -559,14 +553,10 @@ static int s6e63m0_power_on(struct s6e63
 
 static int s6e63m0_power_off(struct s6e63m0 *lcd)
 {
-	int ret = 0;
-	struct lcd_platform_data *pd = NULL;
+	int ret;
+	struct lcd_platform_data *pd;
 
 	pd = lcd->lcd_pd;
-	if (!pd) {
-		dev_err(lcd->dev, "platform data is NULL.\n");
-		return -EFAULT;
-	}
 
 	ret = s6e63m0_ldi_disable(lcd);
 	if (ret) {
@@ -576,11 +566,7 @@ static int s6e63m0_power_off(struct s6e6
 
 	msleep(pd->power_off_delay);
 
-	if (!pd->power_on) {
-		dev_err(lcd->dev, "power_on is NULL.\n");
-		return -EFAULT;
-	} else
-		pd->power_on(lcd->ld, 0);
+	pd->power_on(lcd->ld, 0);
 
 	return 0;
 }
@@ -589,9 +575,9 @@ static int s6e63m0_power(struct s6e63m0 
 {
 	int ret = 0;
 
-	if (POWER_IS_ON(power) && !POWER_IS_ON(lcd->power))
+	if (s6e63m0_power_is_on(power) && !s6e63m0_power_is_on(lcd->power))
 		ret = s6e63m0_power_on(lcd);
-	else if (!POWER_IS_ON(power) && POWER_IS_ON(lcd->power))
+	else if (!s6e63m0_power_is_on(power) && s6e63m0_power_is_on(lcd->power))
 		ret = s6e63m0_power_off(lcd);
 
 	if (!ret)
@@ -812,8 +798,9 @@ static int s6e63m0_probe(struct spi_devi
 		lcd->power = FB_BLANK_POWERDOWN;
 
 		s6e63m0_power(lcd, FB_BLANK_UNBLANK);
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


From: akpm@linux-foundation.org
Subject: + backlight-ld9040-remove-unnecessary-null-deference-check.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:34:06 -0800
Message-ID: <20121220203407.217FE100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:57266 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2LTUeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:34:08 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so406375yen.2
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:34:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: ld9040: remove unnecessary NULL deference check
has been added to the -mm tree.  Its filename is
     backlight-ld9040-remove-unnecessary-null-deference-check.patch

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
Subject: backlight: ld9040: remove unnecessary NULL deference check

Removee unnecessary NULL deference check, because it was already checked
in ld9040_probe().  Also, power_is_on is replaced with
ld9040_power_is_on().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ld9040.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -puN drivers/video/backlight/ld9040.c~backlight-ld9040-remove-unnecessary-null-deference-check drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~backlight-ld9040-remove-unnecessary-null-deference-check
+++ a/drivers/video/backlight/ld9040.c
@@ -43,7 +43,6 @@
 
 #define MIN_BRIGHTNESS		0
 #define MAX_BRIGHTNESS		24
-#define power_is_on(pwr)	((pwr) <= FB_BLANK_NORMAL)
 
 struct ld9040 {
 	struct device			*dev;
@@ -567,15 +566,17 @@ static int ld9040_ldi_disable(struct ld9
 	return ret;
 }
 
+static int ld9040_power_is_on(int power)
+{
+	return power <= FB_BLANK_NORMAL;
+}
+
 static int ld9040_power_on(struct ld9040 *lcd)
 {
 	int ret = 0;
-	struct lcd_platform_data *pd = NULL;
+	struct lcd_platform_data *pd;
+
 	pd = lcd->lcd_pd;
-	if (!pd) {
-		dev_err(lcd->dev, "platform data is NULL.\n");
-		return -EFAULT;
-	}
 
 	/* lcd power on */
 	ld9040_regulator_enable(lcd);
@@ -605,14 +606,10 @@ static int ld9040_power_on(struct ld9040
 
 static int ld9040_power_off(struct ld9040 *lcd)
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
 
 	ret = ld9040_ldi_disable(lcd);
 	if (ret) {
@@ -632,9 +629,9 @@ static int ld9040_power(struct ld9040 *l
 {
 	int ret = 0;
 
-	if (power_is_on(power) && !power_is_on(lcd->power))
+	if (ld9040_power_is_on(power) && !ld9040_power_is_on(lcd->power))
 		ret = ld9040_power_on(lcd);
-	else if (!power_is_on(power) && power_is_on(lcd->power))
+	else if (!ld9040_power_is_on(power) && ld9040_power_is_on(lcd->power))
 		ret = ld9040_power_off(lcd);
 
 	if (!ret)
@@ -773,8 +770,9 @@ static int ld9040_probe(struct spi_devic
 		lcd->power = FB_BLANK_POWERDOWN;
 
 		ld9040_power(lcd, FB_BLANK_UNBLANK);
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


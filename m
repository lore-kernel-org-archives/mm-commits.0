From: akpm@linux-foundation.org
Subject: [merged] backlight-s6e63m0-remove-unnecessary-null-deference-check.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:32 -0800
Message-ID: <20130222204032.9BEAE5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:49533 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145Ab3BVUkd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:33 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so119387qaj.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: s6e63m0: remove unnecessary NULL deference check
has been removed from the -mm tree.  Its filename was
     backlight-s6e63m0-remove-unnecessary-null-deference-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch


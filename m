From: akpm@linux-foundation.org
Subject: [merged] backlight-ld9040-remove-unnecessary-null-deference-check.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:14 -0800
Message-ID: <20130222204014.9C8E15A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:38916 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657Ab3BVUkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:15 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so103730ggn.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ld9040: remove unnecessary NULL deference check
has been removed from the -mm tree.  Its filename was
     backlight-ld9040-remove-unnecessary-null-deference-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch


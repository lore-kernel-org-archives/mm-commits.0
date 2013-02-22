From: akpm@linux-foundation.org
Subject: [merged] backlight-ams369fg06-remove-unnecessary-null-deference-check.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:47 -0800
Message-ID: <20130222204047.99BC431C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:54688 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab3BVUks (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:48 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so103925yhr.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ams369fg06: remove unnecessary NULL deference check
has been removed from the -mm tree.  Its filename was
     backlight-ams369fg06-remove-unnecessary-null-deference-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch


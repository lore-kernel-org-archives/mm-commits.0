From: akpm@linux-foundation.org
Subject: [merged] backlight-corgi_lcd-use-lcd_get_data-instead-of-dev_get_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:50 -0800
Message-ID: <20130222204150.967F431C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:35270 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUlv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:51 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so104075vea.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: corgi_lcd: use lcd_get_data instead of dev_get_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-corgi_lcd-use-lcd_get_data-instead-of-dev_get_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: corgi_lcd: use lcd_get_data instead of dev_get_drvdata

Use the wrapper function for getting the driver data using lcd_device
instead of using dev_get_drvdata with &ld->dev, so we can directly pass a
struct lcd_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/corgi_lcd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-lcd_get_data-instead-of-dev_get_drvdata drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-lcd_get_data-instead-of-dev_get_drvdata
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -337,7 +337,7 @@ static void corgi_lcd_power_off(struct c
 
 static int corgi_lcd_set_mode(struct lcd_device *ld, struct fb_videomode *m)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&ld->dev);
+	struct corgi_lcd *lcd = lcd_get_data(ld);
 	int mode = CORGI_LCD_MODE_QVGA;
 
 	if (m->xres == 640 || m->xres == 480)
@@ -364,7 +364,7 @@ static int corgi_lcd_set_mode(struct lcd
 
 static int corgi_lcd_set_power(struct lcd_device *ld, int power)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&ld->dev);
+	struct corgi_lcd *lcd = lcd_get_data(ld);
 
 	if (POWER_IS_ON(power) && !POWER_IS_ON(lcd->power))
 		corgi_lcd_power_on(lcd);
@@ -378,7 +378,7 @@ static int corgi_lcd_set_power(struct lc
 
 static int corgi_lcd_get_power(struct lcd_device *ld)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&ld->dev);
+	struct corgi_lcd *lcd = lcd_get_data(ld);
 
 	return lcd->power;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch


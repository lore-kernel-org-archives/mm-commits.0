From: akpm@linux-foundation.org
Subject: [merged] backlight-corgi_lcd-use-bl_get_data-instead-of-dev_get_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:41 -0800
Message-ID: <20130222204141.9A3F55A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:41402 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:42 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so103995yhr.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: corgi_lcd: use bl_get_data instead of dev_get_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-corgi_lcd-use-bl_get_data-instead-of-dev_get_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: corgi_lcd: use bl_get_data instead of dev_get_drvdata

Use the wrapper function for getting the driver data using
backlight_device instead of using dev_get_drvdata with &bd->dev, so we can
directly pass a struct backlight_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/corgi_lcd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-bl_get_data-instead-of-dev_get_drvdata drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-bl_get_data-instead-of-dev_get_drvdata
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -391,7 +391,7 @@ static struct lcd_ops corgi_lcd_ops = {
 
 static int corgi_bl_get_intensity(struct backlight_device *bd)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&bd->dev);
+	struct corgi_lcd *lcd = bl_get_data(bd);
 
 	return lcd->intensity;
 }
@@ -423,7 +423,7 @@ static int corgi_bl_set_intensity(struct
 
 static int corgi_bl_update_status(struct backlight_device *bd)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&bd->dev);
+	struct corgi_lcd *lcd = bl_get_data(bd);
 	int intensity = bd->props.brightness;
 
 	if (bd->props.power != FB_BLANK_UNBLANK)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch


From: akpm@linux-foundation.org
Subject: [merged] backlight-corgi_lcd-use-devm_-functions.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:06 -0700
Message-ID: <20120531191906.57A5CA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56583 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab2EaTTH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:07 -0400
Received: by mail-ee0-f74.google.com with SMTP id t10so76371eei.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, eric.y.miao@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: corgi_lcd: use devm_ functions
has been removed from the -mm tree.  Its filename was
     backlight-corgi_lcd-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: corgi_lcd: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/corgi_lcd.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-devm_-functions drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-devm_-functions
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -544,7 +544,7 @@ static int __devinit corgi_lcd_probe(str
 		return -EINVAL;
 	}
 
-	lcd = kzalloc(sizeof(struct corgi_lcd), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct corgi_lcd), GFP_KERNEL);
 	if (!lcd) {
 		dev_err(&spi->dev, "failed to allocate memory\n");
 		return -ENOMEM;
@@ -554,10 +554,9 @@ static int __devinit corgi_lcd_probe(str
 
 	lcd->lcd_dev = lcd_device_register("corgi_lcd", &spi->dev,
 					lcd, &corgi_lcd_ops);
-	if (IS_ERR(lcd->lcd_dev)) {
-		ret = PTR_ERR(lcd->lcd_dev);
-		goto err_free_lcd;
-	}
+	if (IS_ERR(lcd->lcd_dev))
+		return PTR_ERR(lcd->lcd_dev);
+
 	lcd->power = FB_BLANK_POWERDOWN;
 	lcd->mode = (pdata) ? pdata->init_mode : CORGI_LCD_MODE_VGA;
 
@@ -591,8 +590,6 @@ err_unregister_bl:
 	backlight_device_unregister(lcd->bl_dev);
 err_unregister_lcd:
 	lcd_device_unregister(lcd->lcd_dev);
-err_free_lcd:
-	kfree(lcd);
 	return ret;
 }
 
@@ -613,7 +610,6 @@ static int __devexit corgi_lcd_remove(st
 
 	corgi_lcd_set_power(lcd->lcd_dev, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->lcd_dev);
-	kfree(lcd);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: [merged] backlight-corgi_lcd-use-devm_gpio_request.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:50:35 -0700
Message-ID: <20120731185036.15DFA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:40382 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab2GaSuh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:50:37 -0400
Received: by mail-we0-f202.google.com with SMTP id r1so292314wey.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:50:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, eric.y.miao@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: corgi_lcd: use devm_gpio_request()
has been removed from the -mm tree.  Its filename was
     backlight-corgi_lcd-use-devm_gpio_request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: corgi_lcd: use devm_gpio_request()

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_gpio_request() for these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/corgi_lcd.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-devm_gpio_request drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-devm_gpio_request
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -492,7 +492,8 @@ static int setup_gpio_backlight(struct c
 	lcd->gpio_backlight_cont = -1;
 
 	if (gpio_is_valid(pdata->gpio_backlight_on)) {
-		err = gpio_request(pdata->gpio_backlight_on, "BL_ON");
+		err = devm_gpio_request(&spi->dev, pdata->gpio_backlight_on,
+					"BL_ON");
 		if (err) {
 			dev_err(&spi->dev, "failed to request GPIO%d for "
 				"backlight_on\n", pdata->gpio_backlight_on);
@@ -504,11 +505,12 @@ static int setup_gpio_backlight(struct c
 	}
 
 	if (gpio_is_valid(pdata->gpio_backlight_cont)) {
-		err = gpio_request(pdata->gpio_backlight_cont, "BL_CONT");
+		err = devm_gpio_request(&spi->dev, pdata->gpio_backlight_cont,
+					"BL_CONT");
 		if (err) {
 			dev_err(&spi->dev, "failed to request GPIO%d for "
 				"backlight_cont\n", pdata->gpio_backlight_cont);
-			goto err_free_backlight_on;
+			return err;
 		}
 
 		lcd->gpio_backlight_cont = pdata->gpio_backlight_cont;
@@ -525,11 +527,6 @@ static int setup_gpio_backlight(struct c
 		}
 	}
 	return 0;
-
-err_free_backlight_on:
-	if (gpio_is_valid(lcd->gpio_backlight_on))
-		gpio_free(lcd->gpio_backlight_on);
-	return err;
 }
 
 static int __devinit corgi_lcd_probe(struct spi_device *spi)
@@ -602,12 +599,6 @@ static int __devexit corgi_lcd_remove(st
 	backlight_update_status(lcd->bl_dev);
 	backlight_device_unregister(lcd->bl_dev);
 
-	if (gpio_is_valid(lcd->gpio_backlight_on))
-		gpio_free(lcd->gpio_backlight_on);
-
-	if (gpio_is_valid(lcd->gpio_backlight_cont))
-		gpio_free(lcd->gpio_backlight_cont);

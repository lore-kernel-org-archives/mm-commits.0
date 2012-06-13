From: akpm@linux-foundation.org
Subject: + backlight-corgi_lcd-use-devm_gpio_request.patch added to -mm tree
Date: Wed, 13 Jun 2012 13:35:18 -0700
Message-ID: <20120613203518.D54B0A001B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:64352 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab2FMUfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 16:35:20 -0400
Received: by yhgm50 with SMTP id m50so137930yhg.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 13:35:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, eric.y.miao@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: corgi_lcd: use devm_gpio_request()
has been added to the -mm tree.  Its filename is
     backlight-corgi_lcd-use-devm_gpio_request.patch

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

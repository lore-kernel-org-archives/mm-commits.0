From: akpm@linux-foundation.org
Subject: [merged] backlight-tosa_lcd-use-devm_gpio_request.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:50:25 -0700
Message-ID: <20120731185025.ADCD31E007E@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab2GaSu0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:50:26 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:50:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, dbaryshkov@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: tosa_lcd: use devm_gpio_request()
has been removed from the -mm tree.  Its filename was
     backlight-tosa_lcd-use-devm_gpio_request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: tosa_lcd: use devm_gpio_request()

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_gpio_request() for these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_lcd.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/tosa_lcd.c~backlight-tosa_lcd-use-devm_gpio_request drivers/video/backlight/tosa_lcd.c
--- a/drivers/video/backlight/tosa_lcd.c~backlight-tosa_lcd-use-devm_gpio_request
+++ a/drivers/video/backlight/tosa_lcd.c
@@ -193,7 +193,7 @@ static int __devinit tosa_lcd_probe(stru
 	data->spi = spi;
 	dev_set_drvdata(&spi->dev, data);
 
-	ret = gpio_request(TOSA_GPIO_TG_ON, "tg #pwr");
+	ret = devm_gpio_request(&spi->dev, TOSA_GPIO_TG_ON, "tg #pwr");
 	if (ret < 0)
 		goto err_gpio_tg;
 
@@ -201,7 +201,7 @@ static int __devinit tosa_lcd_probe(stru
 
 	ret = gpio_direction_output(TOSA_GPIO_TG_ON, 0);
 	if (ret < 0)
-		goto err_gpio_dir;
+		goto err_gpio_tg;
 
 	mdelay(60);
 	tosa_lcd_tg_init(data);
@@ -221,8 +221,6 @@ static int __devinit tosa_lcd_probe(stru
 
 err_register:
 	tosa_lcd_tg_off(data);
-err_gpio_dir:
-	gpio_free(TOSA_GPIO_TG_ON);
 err_gpio_tg:
 	dev_set_drvdata(&spi->dev, NULL);
 	return ret;
@@ -239,7 +237,6 @@ static int __devexit tosa_lcd_remove(str
 
 	tosa_lcd_tg_off(data);
 
-	gpio_free(TOSA_GPIO_TG_ON);
 	dev_set_drvdata(&spi->dev, NULL);
 
 	return 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch


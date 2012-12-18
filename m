From: akpm@linux-foundation.org
Subject: [merged] backlight-tosa-use-devm_gpio_request_one.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:53 -0800
Message-ID: <20121218200454.2232C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:58925 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:56 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so63377lag.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, dbaryshkov@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: tosa: use devm_gpio_request_one
has been removed from the -mm tree.  Its filename was
     backlight-tosa-use-devm_gpio_request_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: tosa: use devm_gpio_request_one

By using devm_gpio_request_one it is possible to set the direction and
initial value in one shot.  Thus, using devm_gpio_request_one can make the
code simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_bl.c  |    6 ++----
 drivers/video/backlight/tosa_lcd.c |    8 ++------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/tosa_bl.c~backlight-tosa-use-devm_gpio_request_one drivers/video/backlight/tosa_bl.c
--- a/drivers/video/backlight/tosa_bl.c~backlight-tosa-use-devm_gpio_request_one
+++ a/drivers/video/backlight/tosa_bl.c
@@ -93,14 +93,12 @@ static int tosa_bl_probe(struct i2c_clie
 	data->comadj = sharpsl_param.comadj == -1 ?
 			COMADJ_DEFAULT : sharpsl_param.comadj;
 
-	ret = devm_gpio_request(&client->dev, TOSA_GPIO_BL_C20MA, "backlight");
+	ret = devm_gpio_request_one(&client->dev, TOSA_GPIO_BL_C20MA,
+				GPIOF_OUT_INIT_LOW, "backlight");
 	if (ret) {
 		dev_dbg(&data->bl->dev, "Unable to request gpio!\n");
 		return ret;
 	}
-	ret = gpio_direction_output(TOSA_GPIO_BL_C20MA, 0);
-	if (ret)
-		return ret;
 
 	i2c_set_clientdata(client, data);
 	data->i2c = client;
diff -puN drivers/video/backlight/tosa_lcd.c~backlight-tosa-use-devm_gpio_request_one drivers/video/backlight/tosa_lcd.c
--- a/drivers/video/backlight/tosa_lcd.c~backlight-tosa-use-devm_gpio_request_one
+++ a/drivers/video/backlight/tosa_lcd.c
@@ -195,17 +195,13 @@ static int tosa_lcd_probe(struct spi_dev
 	data->spi = spi;
 	dev_set_drvdata(&spi->dev, data);
 
-	ret = devm_gpio_request(&spi->dev, TOSA_GPIO_TG_ON, "tg #pwr");
+	ret = devm_gpio_request_one(&spi->dev, TOSA_GPIO_TG_ON,
+				GPIOF_OUT_INIT_LOW, "tg #pwr");
 	if (ret < 0)
 		goto err_gpio_tg;
 
 	mdelay(60);
 
-	ret = gpio_direction_output(TOSA_GPIO_TG_ON, 0);
-	if (ret < 0)
-		goto err_gpio_tg;

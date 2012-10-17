From: akpm@linux-foundation.org
Subject: + backlight-tosa-use-devm_gpio_request_one.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:55:23 -0700
Message-ID: <20121017235523.9A19C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:34942 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2JQXzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:55:24 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so132388yen.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:55:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, dbaryshkov@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: tosa: use devm_gpio_request_one
has been added to the -mm tree.  Its filename is
     backlight-tosa-use-devm_gpio_request_one.patch

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
@@ -93,14 +93,12 @@ static int __devinit tosa_bl_probe(struc
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
@@ -195,17 +195,13 @@ static int __devinit tosa_lcd_probe(stru
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
-
-	mdelay(60);
 	tosa_lcd_tg_init(data);
 
 	tosa_lcd_tg_on(data);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata.patch
backlight-88pm860x_bl-fix-checkpatch-warning.patch
backlight-atmel-pwm-bl-fix-checkpatch-warning.patch
backlight-corgi_lcd-fix-checkpatch-error-and-warning.patch
backlight-da903x_bl-fix-checkpatch-warning.patch
backlight-generic_bl-fix-checkpatch-warning.patch
backlight-hp680_bl-fix-checkpatch-error-and-warning.patch
backlight-ili9320-fix-checkpatch-error-and-warning.patch
backlight-jornada720-fix-checkpatch-error-and-warning.patch
backlight-l4f00242t03-fix-checkpatch-warning.patch
backlight-lm3630-fix-checkpatch-warning.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch
backlight-omap1-fix-checkpatch-warning.patch
backlight-pcf50633-fix-checkpatch-warning.patch
backlight-platform_lcd-fix-checkpatch-error.patch
backlight-tdo24m-fix-checkpatch-warning.patch
backlight-tosa-fix-checkpatch-error-and-warning.patch
backlight-vgg2432a4-fix-checkpatch-warning.patch
backlight-lms283gf05-use-devm_gpio_request_one.patch
backlight-tosa-use-devm_gpio_request_one.patch


From: akpm@linux-foundation.org
Subject: + backlight-tosa_lcd-use-devm_gpio_request.patch added to -mm tree
Date: Wed, 13 Jun 2012 13:35:12 -0700
Message-ID: <20120613203512.DAFE7A001B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:35640 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2FMUfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 16:35:15 -0400
Received: by bkty5 with SMTP id y5so54240bkt.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 13:35:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, dbaryshkov@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: tosa_lcd: use devm_gpio_request()
has been added to the -mm tree.  Its filename is
     backlight-tosa_lcd-use-devm_gpio_request.patch

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
Subject: Subject: backlight: tosa_lcd: use devm_gpio_request()

Patches currently in -mm which might be from jg1.han@samsung.com are

drivers-video-backlight-atmel-pwm-blc-use-devm_-functions.patch
drivers-video-backlight-ot200_blc-use-devm_-functions.patch
drivers-video-backlight-lm3533_blc-use-devm_-functions.patch
backlight-atmel-pwm-bl-use-devm_gpio_request.patch
backlight-ot200_bl-use-devm_gpio_request.patch
backlight-tosa_lcd-use-devm_gpio_request.patch
backlight-tosa_bl-use-devm_gpio_request.patch
backlight-lms283gf05-use-devm_gpio_request.patch
backlight-corgi_lcd-use-devm_gpio_request.patch
backlight-l4f00242t03-use-devm_gpio_request_one.patch


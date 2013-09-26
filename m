From: akpm@linux-foundation.org
Subject: +
 drivers-video-backlight-tosa_lcdc-remove-redundant-spi_set_drvdata.patch
 added to -mm tree
Date: Wed, 25 Sep 2013 17:08:08 -0700
Message-ID: <52437ae8.BEUbafv2U8JceLCW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3IZAIJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 20:08:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, sachin.kamat@linaro.org

Subject: + drivers-video-backlight-tosa_lcdc-remove-redundant-spi_set_drvdata.patch added to -mm tree
To: sachin.kamat@linaro.org,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 17:08:08 -0700


The patch titled
     Subject: drivers/video/backlight/tosa_lcd.c: remove redundant spi_set_drvdata
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-tosa_lcdc-remove-redundant-spi_set_drvdata.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-video-backlight-tosa_lcdc-remove-redundant-spi_set_drvdata.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-video-backlight-tosa_lcdc-remove-redundant-spi_set_drvdata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/video/backlight/tosa_lcd.c: remove redundant spi_set_drvdata

Driver core sets driver data to NULL upon failure or remove.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_lcd.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/video/backlight/tosa_lcd.c~drivers-video-backlight-tosa_lcdc-remove-redundant-spi_set_drvdata drivers/video/backlight/tosa_lcd.c
--- a/drivers/video/backlight/tosa_lcd.c~drivers-video-backlight-tosa_lcdc-remove-redundant-spi_set_drvdata
+++ a/drivers/video/backlight/tosa_lcd.c
@@ -198,7 +198,7 @@ static int tosa_lcd_probe(struct spi_dev
 	ret = devm_gpio_request_one(&spi->dev, TOSA_GPIO_TG_ON,
 				GPIOF_OUT_INIT_LOW, "tg #pwr");
 	if (ret < 0)
-		goto err_gpio_tg;
+		return ret;
 
 	mdelay(60);
 
@@ -219,8 +219,6 @@ static int tosa_lcd_probe(struct spi_dev
 
 err_register:
 	tosa_lcd_tg_off(data);
-err_gpio_tg:
-	spi_set_drvdata(spi, NULL);
 	return ret;
 }
 
@@ -235,8 +233,6 @@ static int tosa_lcd_remove(struct spi_de
 
 	tosa_lcd_tg_off(data);
 
-	spi_set_drvdata(spi, NULL);

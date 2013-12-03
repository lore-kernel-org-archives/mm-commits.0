From: akpm@linux-foundation.org
Subject: + backlight-tosa-use-devm_lcd_device_register.patch added to -mm
 tree
Date: Mon, 02 Dec 2013 17:00:38 -0800
Message-ID: <529d2d36.UhEtTJTRfU+o7gUI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3LCBAj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 20:00:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, jg1.han@samsung.com

Subject: + backlight-tosa-use-devm_lcd_device_register.patch added to -mm tree
To: jg1.han@samsung.com,tomi.valkeinen@ti.com
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 17:00:38 -0800


The patch titled
     Subject: backlight: tosa: use devm_lcd_device_register()
has been added to the -mm tree.  Its filename is
     backlight-tosa-use-devm_lcd_device_register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-tosa-use-devm_lcd_device_register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-tosa-use-devm_lcd_device_register.patch

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
Subject: backlight: tosa: use devm_lcd_device_register()

Use devm_lcd_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_lcd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/tosa_lcd.c~backlight-tosa-use-devm_lcd_device_register drivers/video/backlight/tosa_lcd.c
--- a/drivers/video/backlight/tosa_lcd.c~backlight-tosa-use-devm_lcd_device_register
+++ a/drivers/video/backlight/tosa_lcd.c
@@ -206,8 +206,8 @@ static int tosa_lcd_probe(struct spi_dev
 
 	tosa_lcd_tg_on(data);
 
-	data->lcd = lcd_device_register("tosa-lcd", &spi->dev, data,
-			&tosa_lcd_ops);
+	data->lcd = devm_lcd_device_register(&spi->dev, "tosa-lcd", &spi->dev,
+					data, &tosa_lcd_ops);
 
 	if (IS_ERR(data->lcd)) {
 		ret = PTR_ERR(data->lcd);
@@ -226,8 +226,6 @@ static int tosa_lcd_remove(struct spi_de
 {
 	struct tosa_lcd_data *data = spi_get_drvdata(spi);
 
-	lcd_device_unregister(data->lcd);

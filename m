From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-l4f00242t03c-convert-to-devm_regulator_get.patch added to -mm tree
Date: Mon, 07 Jan 2013 12:16:09 -0800
Message-ID: <20130107201609.A344F10004A@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:40689 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3AGUQK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 15:16:10 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so2122361ggm.2
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 12:16:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@ingics.com, jg1.han@samsung.com, maramaopercheseimorto@gmail.com


The patch titled
     Subject: drivers/video/backlight/l4f00242t03.c: convert to devm_regulator_get()
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-l4f00242t03c-convert-to-devm_regulator_get.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@ingics.com>
Subject: drivers/video/backlight/l4f00242t03.c: convert to devm_regulator_get()

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff -puN drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-convert-to-devm_regulator_get drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-convert-to-devm_regulator_get
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -190,27 +190,24 @@ static int l4f00242t03_probe(struct spi_
 		return ret;
 	}
 
-	priv->io_reg = regulator_get(&spi->dev, "vdd");
+	priv->io_reg = devm_regulator_get(&spi->dev, "vdd");
 	if (IS_ERR(priv->io_reg)) {
 		dev_err(&spi->dev, "%s: Unable to get the IO regulator\n",
 		       __func__);
 		return PTR_ERR(priv->io_reg);
 	}
 
-	priv->core_reg = regulator_get(&spi->dev, "vcore");
+	priv->core_reg = devm_regulator_get(&spi->dev, "vcore");
 	if (IS_ERR(priv->core_reg)) {
-		ret = PTR_ERR(priv->core_reg);
 		dev_err(&spi->dev, "%s: Unable to get the core regulator\n",
 		       __func__);
-		goto err1;
+		return PTR_ERR(priv->core_reg);
 	}
 
 	priv->ld = lcd_device_register("l4f00242t03",
 					&spi->dev, priv, &l4f_ops);
-	if (IS_ERR(priv->ld)) {
-		ret = PTR_ERR(priv->ld);
-		goto err2;
-	}
+	if (IS_ERR(priv->ld))
+		return PTR_ERR(priv->ld);
 
 	/* Init the LCD */
 	l4f00242t03_lcd_init(spi);
@@ -220,13 +217,6 @@ static int l4f00242t03_probe(struct spi_
 	dev_info(&spi->dev, "Epson l4f00242t03 lcd probed.\n");
 
 	return 0;
-
-err2:
-	regulator_put(priv->core_reg);
-err1:
-	regulator_put(priv->io_reg);
-
-	return ret;
 }
 
 static int l4f00242t03_remove(struct spi_device *spi)
@@ -235,12 +225,8 @@ static int l4f00242t03_remove(struct spi
 
 	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(priv->ld);
-
 	spi_set_drvdata(spi, NULL);
 
-	regulator_put(priv->io_reg);
-	regulator_put(priv->core_reg);

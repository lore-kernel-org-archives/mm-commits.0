From: akpm@linux-foundation.org
Subject: [merged] backlight-l4f00242t03-use-devm_gpio_request_one.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:50:39 -0700
Message-ID: <20120731185040.2FE555C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:49070 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab2GaSum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:50:42 -0400
Received: by eekd4 with SMTP id d4so295553eek.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:50:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, alberto@amarulasolutions.com, grant.likely@secretlab.ca, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: l4f00242t03: export and use devm_gpio_request_one()
has been removed from the -mm tree.  Its filename was
     backlight-l4f00242t03-use-devm_gpio_request_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: l4f00242t03: export and use devm_gpio_request_one()

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_gpio_request_one() for these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Alberto Panizzo <alberto@amarulasolutions.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |   29 ++++++++----------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff -puN drivers/video/backlight/l4f00242t03.c~backlight-l4f00242t03-use-devm_gpio_request_one drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~backlight-l4f00242t03-use-devm_gpio_request_one
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -175,28 +175,27 @@ static int __devinit l4f00242t03_probe(s
 
 	priv->spi = spi;
 
-	ret = gpio_request_one(pdata->reset_gpio, GPIOF_OUT_INIT_HIGH,
-						"lcd l4f00242t03 reset");
+	ret = devm_gpio_request_one(&spi->dev, pdata->reset_gpio,
+			GPIOF_OUT_INIT_HIGH, "lcd l4f00242t03 reset");
 	if (ret) {
 		dev_err(&spi->dev,
 			"Unable to get the lcd l4f00242t03 reset gpio.\n");
 		return ret;
 	}
 
-	ret = gpio_request_one(pdata->data_enable_gpio, GPIOF_OUT_INIT_LOW,
-						"lcd l4f00242t03 data enable");
+	ret = devm_gpio_request_one(&spi->dev, pdata->data_enable_gpio,
+			GPIOF_OUT_INIT_LOW, "lcd l4f00242t03 data enable");
 	if (ret) {
 		dev_err(&spi->dev,
 			"Unable to get the lcd l4f00242t03 data en gpio.\n");
-		goto err;
+		return ret;
 	}
 
 	priv->io_reg = regulator_get(&spi->dev, "vdd");
 	if (IS_ERR(priv->io_reg)) {
-		ret = PTR_ERR(priv->io_reg);
 		dev_err(&spi->dev, "%s: Unable to get the IO regulator\n",
 		       __func__);
-		goto err2;
+		return PTR_ERR(priv->io_reg);
 	}
 
 	priv->core_reg = regulator_get(&spi->dev, "vcore");
@@ -204,14 +203,14 @@ static int __devinit l4f00242t03_probe(s
 		ret = PTR_ERR(priv->core_reg);
 		dev_err(&spi->dev, "%s: Unable to get the core regulator\n",
 		       __func__);
-		goto err3;
+		goto err1;
 	}
 
 	priv->ld = lcd_device_register("l4f00242t03",
 					&spi->dev, priv, &l4f_ops);
 	if (IS_ERR(priv->ld)) {
 		ret = PTR_ERR(priv->ld);
-		goto err4;
+		goto err2;
 	}
 
 	/* Init the LCD */
@@ -223,14 +222,10 @@ static int __devinit l4f00242t03_probe(s
 
 	return 0;
 
-err4:
+err2:
 	regulator_put(priv->core_reg);
-err3:
+err1:
 	regulator_put(priv->io_reg);
-err2:
-	gpio_free(pdata->data_enable_gpio);
-err:
-	gpio_free(pdata->reset_gpio);
 
 	return ret;
 }
@@ -238,16 +233,12 @@ err:
 static int __devexit l4f00242t03_remove(struct spi_device *spi)
 {
 	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
-	struct l4f00242t03_pdata *pdata = priv->spi->dev.platform_data;
 
 	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(priv->ld);
 
 	dev_set_drvdata(&spi->dev, NULL);
 
-	gpio_free(pdata->data_enable_gpio);
-	gpio_free(pdata->reset_gpio);

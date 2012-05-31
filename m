From: akpm@linux-foundation.org
Subject: [merged] backlight-l4f00242t03-use-devm_-functions.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:10 -0700
Message-ID: <20120531191910.416F6A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:63608 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab2EaTTM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:12 -0400
Received: by wgbdt11 with SMTP id dt11so76208wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, alberto@amarulasolutions.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: l4f00242t03: use devm_ functions
has been removed from the -mm tree.  Its filename was
     backlight-l4f00242t03-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: l4f00242t03: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Alberto Panizzo <alberto@amarulasolutions.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |   25 ++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff -puN drivers/video/backlight/l4f00242t03.c~backlight-l4f00242t03-use-devm_-functions drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~backlight-l4f00242t03-use-devm_-functions
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -161,7 +161,8 @@ static int __devinit l4f00242t03_probe(s
 		return -EINVAL;
 	}
 
-	priv = kzalloc(sizeof(struct l4f00242t03_priv), GFP_KERNEL);
+	priv = devm_kzalloc(&spi->dev, sizeof(struct l4f00242t03_priv),
+				GFP_KERNEL);
 
 	if (priv == NULL) {
 		dev_err(&spi->dev, "No memory for this device.\n");
@@ -179,7 +180,7 @@ static int __devinit l4f00242t03_probe(s
 	if (ret) {
 		dev_err(&spi->dev,
 			"Unable to get the lcd l4f00242t03 reset gpio.\n");
-		goto err;
+		return ret;
 	}
 
 	ret = gpio_request_one(pdata->data_enable_gpio, GPIOF_OUT_INIT_LOW,
@@ -187,7 +188,7 @@ static int __devinit l4f00242t03_probe(s
 	if (ret) {
 		dev_err(&spi->dev,
 			"Unable to get the lcd l4f00242t03 data en gpio.\n");
-		goto err2;
+		goto err;
 	}
 
 	priv->io_reg = regulator_get(&spi->dev, "vdd");
@@ -195,7 +196,7 @@ static int __devinit l4f00242t03_probe(s
 		ret = PTR_ERR(priv->io_reg);
 		dev_err(&spi->dev, "%s: Unable to get the IO regulator\n",
 		       __func__);
-		goto err3;
+		goto err2;
 	}
 
 	priv->core_reg = regulator_get(&spi->dev, "vcore");
@@ -203,14 +204,14 @@ static int __devinit l4f00242t03_probe(s
 		ret = PTR_ERR(priv->core_reg);
 		dev_err(&spi->dev, "%s: Unable to get the core regulator\n",
 		       __func__);
-		goto err4;
+		goto err3;
 	}
 
 	priv->ld = lcd_device_register("l4f00242t03",
 					&spi->dev, priv, &l4f_ops);
 	if (IS_ERR(priv->ld)) {
 		ret = PTR_ERR(priv->ld);
-		goto err5;
+		goto err4;
 	}
 
 	/* Init the LCD */
@@ -222,16 +223,14 @@ static int __devinit l4f00242t03_probe(s
 
 	return 0;
 
-err5:
-	regulator_put(priv->core_reg);
 err4:
-	regulator_put(priv->io_reg);
+	regulator_put(priv->core_reg);
 err3:
-	gpio_free(pdata->data_enable_gpio);
+	regulator_put(priv->io_reg);
 err2:
-	gpio_free(pdata->reset_gpio);
+	gpio_free(pdata->data_enable_gpio);
 err:
-	kfree(priv);
+	gpio_free(pdata->reset_gpio);
 
 	return ret;
 }
@@ -252,8 +251,6 @@ static int __devexit l4f00242t03_remove(
 	regulator_put(priv->io_reg);
 	regulator_put(priv->core_reg);
 
-	kfree(priv);

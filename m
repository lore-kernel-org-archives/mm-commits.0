From: akpm@linux-foundation.org
Subject: + backlight-l4f00242t03-use-devm_-functions.patch added to -mm tree
Date: Fri, 25 May 2012 13:47:35 -0700
Message-ID: <20120525204736.1784AA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:61959 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934065Ab2EYUrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 16:47:39 -0400
Received: by lbbgp10 with SMTP id gp10so70430lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 13:47:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, alberto@amarulasolutions.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: l4f00242t03: use devm_ functions
has been added to the -mm tree.  Its filename is
     backlight-l4f00242t03-use-devm_-functions.patch

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
-
 	return 0;
 }
 
_
Subject: Subject: backlight: l4f00242t03: use devm_ functions

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
backlight-adp8860-use-kstrtoul.patch
backlight-adp8870-use-kstrtoul.patch
backlight-adp5520-use-kstrtoul.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk-fix.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-generic_bl-use-pr_info-instead-of-printk.patch
backlight-generic_bl-use-pr_info-instead-of-printk-fix.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-omap1-use-pr_info-instead-of-printk.patch
backlight-omap1-use-pr_info-instead-of-printk-fix.patch
backlight-progear-use-pr_err-instead-of-printk.patch
backlight-progear-use-pr_err-instead-of-printk-fix.patch
drivers-video-backlight-l4f00242t03c-use-pr_fmt.patch
backlight-initialize-struct-backlight_properties-properly.patch
backlight-adp8860-use-devm_-functions.patch
backlight-adp8870-use-devm_-functions.patch
backlight-ams369fg06-use-devm_-functions.patch
backlight-corgi_lcd-use-devm_-functions.patch
backlight-ili9320-use-devm_-functions.patch
backlight-l4f00242t03-use-devm_-functions.patch
backlight-ld9040-use-devm_-functions.patch
backlight-lms283gf05-use-devm_-functions.patch
backlight-ltv350qv-use-devm_-functions.patch
backlight-s6e63m0-use-devm_-functions.patch
backlight-tdo24m-use-devm_-functions.patch
backlight-tosa_bl-use-devm_-functions.patch
backlight-tosa_lcd-use-devm_-functions.patch


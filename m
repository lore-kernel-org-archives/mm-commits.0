From: akpm@linux-foundation.org
Subject: [merged] backlight-lms283gf05-use-devm_gpio_request.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:50:31 -0700
Message-ID: <20120731185032.15212200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:51872 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756234Ab2GaSue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2012 14:50:34 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so292127lag.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:50:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, marek.vasut@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lms283gf05: use devm_gpio_request()
has been removed from the -mm tree.  Its filename was
     backlight-lms283gf05-use-devm_gpio_request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lms283gf05: use devm_gpio_request()

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_gpio_request() for these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Marek Vasut <marek.vasut@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms283gf05.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff -puN drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-use-devm_gpio_request drivers/video/backlight/lms283gf05.c
--- a/drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-use-devm_gpio_request
+++ a/drivers/video/backlight/lms283gf05.c
@@ -158,29 +158,27 @@ static int __devinit lms283gf05_probe(st
 	int ret = 0;
 
 	if (pdata != NULL) {
-		ret = gpio_request(pdata->reset_gpio, "LMS285GF05 RESET");
+		ret = devm_gpio_request(&spi->dev, pdata->reset_gpio,
+					"LMS285GF05 RESET");
 		if (ret)
 			return ret;
 
 		ret = gpio_direction_output(pdata->reset_gpio,
 						!pdata->reset_inverted);
 		if (ret)
-			goto err;
+			return ret;
 	}
 
 	st = devm_kzalloc(&spi->dev, sizeof(struct lms283gf05_state),
 				GFP_KERNEL);
 	if (st == NULL) {
 		dev_err(&spi->dev, "No memory for device state\n");
-		ret = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	ld = lcd_device_register("lms283gf05", &spi->dev, st, &lms_ops);
-	if (IS_ERR(ld)) {
-		ret = PTR_ERR(ld);
-		goto err;
-	}
+	if (IS_ERR(ld))
+		return PTR_ERR(ld);
 
 	st->spi = spi;
 	st->ld = ld;
@@ -193,24 +191,14 @@ static int __devinit lms283gf05_probe(st
 	lms283gf05_toggle(spi, disp_initseq, ARRAY_SIZE(disp_initseq));
 
 	return 0;
-
-err:
-	if (pdata != NULL)
-		gpio_free(pdata->reset_gpio);
-
-	return ret;
 }
 
 static int __devexit lms283gf05_remove(struct spi_device *spi)
 {
 	struct lms283gf05_state *st = dev_get_drvdata(&spi->dev);
-	struct lms283gf05_pdata *pdata = st->spi->dev.platform_data;
 
 	lcd_device_unregister(st->ld);
 
-	if (pdata != NULL)
-		gpio_free(pdata->reset_gpio);

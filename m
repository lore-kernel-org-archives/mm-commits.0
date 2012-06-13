From: akpm@linux-foundation.org
Subject: + backlight-lms283gf05-use-devm_gpio_request.patch added to -mm tree
Date: Wed, 13 Jun 2012 13:35:16 -0700
Message-ID: <20120613203516.CEEA5A001B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:40199 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab2FMUfR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 16:35:17 -0400
Received: by ghbz15 with SMTP id z15so86235ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 13:35:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, marek.vasut@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: lms283gf05: use devm_gpio_request()
has been added to the -mm tree.  Its filename is
     backlight-lms283gf05-use-devm_gpio_request.patch

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

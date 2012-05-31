From: akpm@linux-foundation.org
Subject: [merged] backlight-lms283gf05-use-devm_-functions.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:14 -0700
Message-ID: <20120531191914.5B26DA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:60189 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab2EaTTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:16 -0400
Received: by faaa25 with SMTP id a25so75375faa.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, marek.vasut@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lms283gf05: use devm_ functions
has been removed from the -mm tree.  Its filename was
     backlight-lms283gf05-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lms283gf05: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Marek Vasut <marek.vasut@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms283gf05.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-use-devm_-functions drivers/video/backlight/lms283gf05.c
--- a/drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-use-devm_-functions
+++ a/drivers/video/backlight/lms283gf05.c
@@ -168,7 +168,8 @@ static int __devinit lms283gf05_probe(st
 			goto err;
 	}
 
-	st = kzalloc(sizeof(struct lms283gf05_state), GFP_KERNEL);
+	st = devm_kzalloc(&spi->dev, sizeof(struct lms283gf05_state),
+				GFP_KERNEL);
 	if (st == NULL) {
 		dev_err(&spi->dev, "No memory for device state\n");
 		ret = -ENOMEM;
@@ -178,7 +179,7 @@ static int __devinit lms283gf05_probe(st
 	ld = lcd_device_register("lms283gf05", &spi->dev, st, &lms_ops);
 	if (IS_ERR(ld)) {
 		ret = PTR_ERR(ld);
-		goto err2;
+		goto err;
 	}
 
 	st->spi = spi;
@@ -193,8 +194,6 @@ static int __devinit lms283gf05_probe(st
 
 	return 0;
 
-err2:
-	kfree(st);
 err:
 	if (pdata != NULL)
 		gpio_free(pdata->reset_gpio);
@@ -212,8 +211,6 @@ static int __devexit lms283gf05_remove(s
 	if (pdata != NULL)
 		gpio_free(pdata->reset_gpio);
 
-	kfree(st);

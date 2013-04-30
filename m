From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds1390-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:10 -0700
Message-ID: <20130430190010.6F9BE5A425C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:52678 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291Ab3D3TAM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:12 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so77827ves.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ds1390: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1390-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds1390: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1390.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-ds1390.c~rtc-rtc-ds1390-use-devm_-functions drivers/rtc/rtc-ds1390.c
--- a/drivers/rtc/rtc-ds1390.c~rtc-rtc-ds1390-use-devm_-functions
+++ a/drivers/rtc/rtc-ds1390.c
@@ -131,7 +131,7 @@ static int ds1390_probe(struct spi_devic
 	spi->bits_per_word = 8;
 	spi_setup(spi);
 
-	chip = kzalloc(sizeof *chip, GFP_KERNEL);
+	chip = devm_kzalloc(&spi->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip) {
 		dev_err(&spi->dev, "unable to allocate device memory\n");
 		return -ENOMEM;
@@ -141,16 +141,14 @@ static int ds1390_probe(struct spi_devic
 	res = ds1390_get_reg(&spi->dev, DS1390_REG_SECONDS, &tmp);
 	if (res != 0) {
 		dev_err(&spi->dev, "unable to read device\n");
-		kfree(chip);
 		return res;
 	}
 
-	chip->rtc = rtc_device_register("ds1390",
-				&spi->dev, &ds1390_rtc_ops, THIS_MODULE);
+	chip->rtc = devm_rtc_device_register(&spi->dev, "ds1390",
+					&ds1390_rtc_ops, THIS_MODULE);
 	if (IS_ERR(chip->rtc)) {
 		dev_err(&spi->dev, "unable to register device\n");
 		res = PTR_ERR(chip->rtc);
-		kfree(chip);
 	}
 
 	return res;
@@ -158,11 +156,6 @@ static int ds1390_probe(struct spi_devic
 
 static int ds1390_remove(struct spi_device *spi)
 {
-	struct ds1390 *chip = spi_get_drvdata(spi);
-
-	rtc_device_unregister(chip->rtc);
-	kfree(chip);

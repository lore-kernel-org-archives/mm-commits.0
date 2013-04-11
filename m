From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1305c-use-devm_-apis.patch added to -mm tree
Date: Thu, 11 Apr 2013 16:01:43 -0700
Message-ID: <20130411230143.C6F2C31C10E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:59187 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab3DKXBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 19:01:45 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so9557qcr.2
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 16:01:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-ds1305.c: use devm_* APIs
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1305c-use-devm_-apis.patch

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
Subject: drivers/rtc/rtc-ds1305.c: use devm_* APIs

devm_* functions are device managed and make cleanup code simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1305.c |   35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff -puN drivers/rtc/rtc-ds1305.c~drivers-rtc-rtc-ds1305c-use-devm_-apis drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~drivers-rtc-rtc-ds1305c-use-devm_-apis
+++ a/drivers/rtc/rtc-ds1305.c
@@ -619,7 +619,7 @@ static int ds1305_probe(struct spi_devic
 		return -EINVAL;
 
 	/* set up driver data */
-	ds1305 = kzalloc(sizeof *ds1305, GFP_KERNEL);
+	ds1305 = devm_kzalloc(&spi->dev, sizeof(*ds1305), GFP_KERNEL);
 	if (!ds1305)
 		return -ENOMEM;
 	ds1305->spi = spi;
@@ -632,7 +632,7 @@ static int ds1305_probe(struct spi_devic
 	if (status < 0) {
 		dev_dbg(&spi->dev, "can't %s, %d\n",
 				"read", status);
-		goto fail0;
+		return status;
 	}
 
 	dev_dbg(&spi->dev, "ctrl %s: %3ph\n", "read", ds1305->ctrl);
@@ -644,8 +644,7 @@ static int ds1305_probe(struct spi_devic
 	 */
 	if ((ds1305->ctrl[0] & 0x38) != 0 || (ds1305->ctrl[1] & 0xfc) != 0) {
 		dev_dbg(&spi->dev, "RTC chip is not present\n");
-		status = -ENODEV;
-		goto fail0;
+		return -ENODEV;
 	}
 	if (ds1305->ctrl[2] == 0)
 		dev_dbg(&spi->dev, "chip may not be present\n");
@@ -664,7 +663,7 @@ static int ds1305_probe(struct spi_devic
 
 		dev_dbg(&spi->dev, "clear WP --> %d\n", status);
 		if (status < 0)
-			goto fail0;
+			return status;
 	}
 
 	/* on DS1305, maybe start oscillator; like most low power
@@ -718,7 +717,7 @@ static int ds1305_probe(struct spi_devic
 		if (status < 0) {
 			dev_dbg(&spi->dev, "can't %s, %d\n",
 					"write", status);
-			goto fail0;
+			return status;
 		}
 
 		dev_dbg(&spi->dev, "ctrl %s: %3ph\n", "write", ds1305->ctrl);
@@ -730,7 +729,7 @@ static int ds1305_probe(struct spi_devic
 				&value, sizeof value);
 	if (status < 0) {
 		dev_dbg(&spi->dev, "read HOUR --> %d\n", status);
-		goto fail0;
+		return status;
 	}
 
 	ds1305->hr12 = (DS1305_HR_12 & value) != 0;
@@ -738,12 +737,12 @@ static int ds1305_probe(struct spi_devic
 		dev_dbg(&spi->dev, "AM/PM\n");
 
 	/* register RTC ... from here on, ds1305->ctrl needs locking */
-	ds1305->rtc = rtc_device_register("ds1305", &spi->dev,
+	ds1305->rtc = devm_rtc_device_register(&spi->dev, "ds1305",
 			&ds1305_ops, THIS_MODULE);
 	if (IS_ERR(ds1305->rtc)) {
 		status = PTR_ERR(ds1305->rtc);
 		dev_dbg(&spi->dev, "register rtc --> %d\n", status);
-		goto fail0;
+		return status;
 	}
 
 	/* Maybe set up alarm IRQ; be ready to handle it triggering right
@@ -754,12 +753,12 @@ static int ds1305_probe(struct spi_devic
 	 */
 	if (spi->irq) {
 		INIT_WORK(&ds1305->work, ds1305_work);
-		status = request_irq(spi->irq, ds1305_irq,
+		status = devm_request_irq(&spi->dev, spi->irq, ds1305_irq,
 				0, dev_name(&ds1305->rtc->dev), ds1305);
 		if (status < 0) {
 			dev_dbg(&spi->dev, "request_irq %d --> %d\n",
 					spi->irq, status);
-			goto fail1;
+			return status;
 		}
 
 		device_set_wakeup_capable(&spi->dev, 1);
@@ -769,18 +768,10 @@ static int ds1305_probe(struct spi_devic
 	status = sysfs_create_bin_file(&spi->dev.kobj, &nvram);
 	if (status < 0) {
 		dev_dbg(&spi->dev, "register nvram --> %d\n", status);
-		goto fail2;
+		return status;
 	}
 
 	return 0;
-
-fail2:
-	free_irq(spi->irq, ds1305);
-fail1:
-	rtc_device_unregister(ds1305->rtc);
-fail0:
-	kfree(ds1305);
-	return status;
 }
 
 static int ds1305_remove(struct spi_device *spi)
@@ -792,13 +783,11 @@ static int ds1305_remove(struct spi_devi
 	/* carefully shut down irq and workqueue, if present */
 	if (spi->irq) {
 		set_bit(FLAG_EXITING, &ds1305->flags);
-		free_irq(spi->irq, ds1305);
+		devm_free_irq(&spi->dev, spi->irq, ds1305);
 		cancel_work_sync(&ds1305->work);
 	}
 
-	rtc_device_unregister(ds1305->rtc);
 	spi_set_drvdata(spi, NULL);
-	kfree(ds1305);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

linux-next.patch
drivers-video-exynos-exynos_mipi_dsic-convert-to-devm_ioremap_resource.patch
drivers-rtc-rtc-tps6586xc-remove-incorrect-use-of-rtc_device_unregister.patch
drivers-rtc-rtc-tps65910c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8997c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max77686c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8907c-remove-redundant-code.patch
drivers-rtc-rtc-max77686c-use-devm_regmap_init_i2c.patch
drivers-rtc-rtc-88pm860xc-use-devm_-apis.patch
drivers-rtc-rtc-at32ap700xc-use-devm_-apis.patch
drivers-rtc-rtc-ds1305c-use-devm_-apis.patch
drivers-rtc-rtc-ds1374c-use-devm_-apis.patch
drivers-rtc-rtc-ds3232c-use-devm_-apis.patch
drivers-rtc-rtc-m48t35c-use-devm_-apis.patch
drivers-rtc-rtc-max8925c-use-devm_-apis.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch


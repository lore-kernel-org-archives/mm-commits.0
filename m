From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-ds1305c-use-devm_-apis.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:37 -0700
Message-ID: <20130430185937.7103131C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:44503 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933470Ab3D3S7i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:38 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so87176qen.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds1305.c: use devm_* APIs
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ds1305c-use-devm_-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch


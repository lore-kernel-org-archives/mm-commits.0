From: akpm@linux-foundation.org
Subject: [merged] rtc-fixed-potential-race-condition.patch removed from
 -mm tree
Date: Fri, 04 Apr 2014 12:34:40 -0700
Message-ID: <533f0950.bwO+yn1vHJZGB6mL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaDDTel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srikanth.srinivasan@freescale.com, shc_work@mail.ru, s.hauer@pengutronix.de, lee.jones@linaro.org, jkosina@suse.cz, iamjoonsoo.kim@lge.com, anemo@mba.ocn.ne.jp, alnovak@suse.cz, a.zummo@towertech.it

Subject: [merged] rtc-fixed-potential-race-condition.patch removed from -mm tree
To: a.zummo@towertech.it,alnovak@suse.cz,anemo@mba.ocn.ne.jp,iamjoonsoo.kim@lge.com,jkosina@suse.cz,lee.jones@linaro.org,s.hauer@pengutronix.de,shc_work@mail.ru,srikanth.srinivasan@freescale.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:40 -0700


The patch titled
     Subject: rtc: fix potential race condition
has been removed from the -mm tree.  Its filename was
     rtc-fixed-potential-race-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alessandro Zummo <a.zummo@towertech.it>
Subject: rtc: fix potential race condition

RTC drivers must not return an error after device registration.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexander Shiyan <shc_work@mail.ru>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Srikanth Srinivasan <srikanth.srinivasan@freescale.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ales Novak <alnovak@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1305.c |   10 ++----
 drivers/rtc/rtc-ds1307.c |   60 ++++++++++++++++++++-----------------
 drivers/rtc/rtc-ds1511.c |   18 ++++++-----
 drivers/rtc/rtc-ds1553.c |   18 ++++++-----
 drivers/rtc/rtc-ds1672.c |   11 +++---
 drivers/rtc/rtc-ds1742.c |    5 ++-
 drivers/rtc/rtc-ds3232.c |    2 -
 drivers/rtc/rtc-test.c   |    9 +----
 drivers/rtc/rtc-x1205.c  |    2 -
 9 files changed, 70 insertions(+), 65 deletions(-)

diff -puN drivers/rtc/rtc-ds1305.c~rtc-fixed-potential-race-condition drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~rtc-fixed-potential-race-condition
+++ a/drivers/rtc/rtc-ds1305.c
@@ -756,19 +756,17 @@ static int ds1305_probe(struct spi_devic
 		status = devm_request_irq(&spi->dev, spi->irq, ds1305_irq,
 				0, dev_name(&ds1305->rtc->dev), ds1305);
 		if (status < 0) {
-			dev_dbg(&spi->dev, "request_irq %d --> %d\n",
+			dev_err(&spi->dev, "request_irq %d --> %d\n",
 					spi->irq, status);
-			return status;
+		} else {
+			device_set_wakeup_capable(&spi->dev, 1);
 		}
-
-		device_set_wakeup_capable(&spi->dev, 1);
 	}
 
 	/* export NVRAM */
 	status = sysfs_create_bin_file(&spi->dev.kobj, &nvram);
 	if (status < 0) {
-		dev_dbg(&spi->dev, "register nvram --> %d\n", status);
-		return status;
+		dev_err(&spi->dev, "register nvram --> %d\n", status);
 	}
 
 	return 0;
diff -puN drivers/rtc/rtc-ds1307.c~rtc-fixed-potential-race-condition drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-fixed-potential-race-condition
+++ a/drivers/rtc/rtc-ds1307.c
@@ -930,52 +930,58 @@ read_rtc:
 	ds1307->rtc = devm_rtc_device_register(&client->dev, client->name,
 				&ds13xx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ds1307->rtc)) {
-		err = PTR_ERR(ds1307->rtc);
-		dev_err(&client->dev,
-			"unable to register the class device\n");
-		goto exit;
+		return PTR_ERR(ds1307->rtc);
 	}
 
 	if (want_irq) {
 		err = request_irq(client->irq, ds1307_irq, IRQF_SHARED,
 			  ds1307->rtc->name, client);
 		if (err) {
-			dev_err(&client->dev,
-				"unable to request IRQ!\n");
-			goto exit;
-		}
+			client->irq = 0;
+			dev_err(&client->dev, "unable to request IRQ!\n");
+		} else {
 
-		device_set_wakeup_capable(&client->dev, 1);
-		set_bit(HAS_ALARM, &ds1307->flags);
-		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
+			device_set_wakeup_capable(&client->dev, 1);
+			set_bit(HAS_ALARM, &ds1307->flags);
+			dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
+		}
 	}
 
 	if (chip->nvram_size) {
+
 		ds1307->nvram = devm_kzalloc(&client->dev,
 					sizeof(struct bin_attribute),
 					GFP_KERNEL);
 		if (!ds1307->nvram) {
-			err = -ENOMEM;
-			goto err_irq;
+			dev_err(&client->dev, "cannot allocate memory for nvram sysfs\n");
+		} else {
+
+			ds1307->nvram->attr.name = "nvram";
+			ds1307->nvram->attr.mode = S_IRUGO | S_IWUSR;
+
+			sysfs_bin_attr_init(ds1307->nvram);
+
+			ds1307->nvram->read = ds1307_nvram_read;
+			ds1307->nvram->write = ds1307_nvram_write;
+			ds1307->nvram->size = chip->nvram_size;
+			ds1307->nvram_offset = chip->nvram_offset;
+
+			err = sysfs_create_bin_file(&client->dev.kobj,
+						    ds1307->nvram);
+			if (err) {
+				dev_err(&client->dev,
+					"unable to create sysfs file: %s\n",
+					ds1307->nvram->attr.name);
+			} else {
+				set_bit(HAS_NVRAM, &ds1307->flags);
+				dev_info(&client->dev, "%zu bytes nvram\n",
+					 ds1307->nvram->size);
+			}
 		}
-		ds1307->nvram->attr.name = "nvram";
-		ds1307->nvram->attr.mode = S_IRUGO | S_IWUSR;
-		sysfs_bin_attr_init(ds1307->nvram);
-		ds1307->nvram->read = ds1307_nvram_read;
-		ds1307->nvram->write = ds1307_nvram_write;
-		ds1307->nvram->size = chip->nvram_size;
-		ds1307->nvram_offset = chip->nvram_offset;
-		err = sysfs_create_bin_file(&client->dev.kobj, ds1307->nvram);
-		if (err)
-			goto err_irq;
-		set_bit(HAS_NVRAM, &ds1307->flags);
-		dev_info(&client->dev, "%zu bytes nvram\n", ds1307->nvram->size);
 	}
 
 	return 0;
 
-err_irq:
-	free_irq(client->irq, client);
 exit:
 	return err;
 }
diff -puN drivers/rtc/rtc-ds1511.c~rtc-fixed-potential-race-condition drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~rtc-fixed-potential-race-condition
+++ a/drivers/rtc/rtc-ds1511.c
@@ -473,7 +473,6 @@ static struct bin_attribute ds1511_nvram
 
 static int ds1511_rtc_probe(struct platform_device *pdev)
 {
-	struct rtc_device *rtc;
 	struct resource *res;
 	struct rtc_plat_data *pdata;
 	int ret = 0;
@@ -512,6 +511,12 @@ static int ds1511_rtc_probe(struct platf
 
 	spin_lock_init(&pdata->lock);
 	platform_set_drvdata(pdev, pdata);
+
+	pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+					      &ds1511_rtc_ops, THIS_MODULE);
+	if (IS_ERR(pdata->rtc))
+		return PTR_ERR(pdata->rtc);
+
 	/*
 	 * if the platform has an interrupt in mind for this device,
 	 * then by all means, set it
@@ -526,15 +531,12 @@ static int ds1511_rtc_probe(struct platf
 		}
 	}
 
-	rtc = devm_rtc_device_register(&pdev->dev, pdev->name, &ds1511_rtc_ops,
-					THIS_MODULE);
-	if (IS_ERR(rtc))
-		return PTR_ERR(rtc);
-	pdata->rtc = rtc;
-
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1511_nvram_attr);
+	if (ret)
+		dev_err(&pdev->dev, "Unable to create sysfs entry: %s\n",
+			ds1511_nvram_attr.attr.name);
 
-	return ret;
+	return 0;
 }
 
 static int ds1511_rtc_remove(struct platform_device *pdev)
diff -puN drivers/rtc/rtc-ds1553.c~rtc-fixed-potential-race-condition drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-fixed-potential-race-condition
+++ a/drivers/rtc/rtc-ds1553.c
@@ -278,7 +278,6 @@ static struct bin_attribute ds1553_nvram
 
 static int ds1553_rtc_probe(struct platform_device *pdev)
 {
-	struct rtc_device *rtc;
 	struct resource *res;
 	unsigned int cen, sec;
 	struct rtc_plat_data *pdata;
@@ -311,6 +310,12 @@ static int ds1553_rtc_probe(struct platf
 	spin_lock_init(&pdata->lock);
 	pdata->last_jiffies = jiffies;
 	platform_set_drvdata(pdev, pdata);
+
+	pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+				  &ds1553_rtc_ops, THIS_MODULE);
+	if (IS_ERR(pdata->rtc))
+		return PTR_ERR(pdata->rtc);
+
 	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (devm_request_irq(&pdev->dev, pdata->irq,
@@ -321,15 +326,12 @@ static int ds1553_rtc_probe(struct platf
 		}
 	}
 
-	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
-				  &ds1553_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc))
-		return PTR_ERR(rtc);
-	pdata->rtc = rtc;
-
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1553_nvram_attr);
+	if (ret)
+		dev_err(&pdev->dev, "unable to create sysfs file: %s\n",
+			ds1553_nvram_attr.attr.name);
 
-	return ret;
+	return 0;
 }
 
 static int ds1553_rtc_remove(struct platform_device *pdev)
diff -puN drivers/rtc/rtc-ds1672.c~rtc-fixed-potential-race-condition drivers/rtc/rtc-ds1672.c
--- a/drivers/rtc/rtc-ds1672.c~rtc-fixed-potential-race-condition
+++ a/drivers/rtc/rtc-ds1672.c
@@ -177,8 +177,9 @@ static int ds1672_probe(struct i2c_clien
 
 	/* read control register */
 	err = ds1672_get_control(client, &control);
-	if (err)
-		goto exit_devreg;
+	if (err) {
+		dev_warn(&client->dev, "Unable to read the control register\n");
+	}
 
 	if (control & DS1672_REG_CONTROL_EOSC)
 		dev_warn(&client->dev, "Oscillator not enabled. "
@@ -187,12 +188,10 @@ static int ds1672_probe(struct i2c_clien
 	/* Register sysfs hooks */
 	err = device_create_file(&client->dev, &dev_attr_control);
 	if (err)
-		goto exit_devreg;
+		dev_err(&client->dev, "Unable to create sysfs entry: %s\n",
+			dev_attr_control.attr.name);
 
 	return 0;
-
- exit_devreg:
-	return err;
 }
 
 static struct i2c_device_id ds1672_id[] = {
diff -puN drivers/rtc/rtc-ds1742.c~rtc-fixed-potential-race-condition drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtc-fixed-potential-race-condition
+++ a/drivers/rtc/rtc-ds1742.c
@@ -204,8 +204,11 @@ static int ds1742_rtc_probe(struct platf
 		return PTR_ERR(rtc);
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
+	if (ret)
+		dev_err(&pdev->dev, "Unable to create sysfs entry: %s\n",
+			pdata->nvram_attr.attr.name);
 
-	return ret;
+	return 0;
 }
 
 static int ds1742_rtc_remove(struct platform_device *pdev)
diff -puN drivers/rtc/rtc-ds3232.c~rtc-fixed-potential-race-condition drivers/rtc/rtc-ds3232.c
--- a/drivers/rtc/rtc-ds3232.c~rtc-fixed-potential-race-condition
+++ a/drivers/rtc/rtc-ds3232.c
@@ -414,7 +414,6 @@ static int ds3232_probe(struct i2c_clien
 	ds3232->rtc = devm_rtc_device_register(&client->dev, client->name,
 					  &ds3232_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ds3232->rtc)) {
-		dev_err(&client->dev, "unable to register the class device\n");
 		return PTR_ERR(ds3232->rtc);
 	}
 
@@ -423,7 +422,6 @@ static int ds3232_probe(struct i2c_clien
 				 "ds3232", client);
 		if (ret) {
 			dev_err(&client->dev, "unable to request IRQ\n");
-			return ret;
 		}
 	}
 
diff -puN drivers/rtc/rtc-test.c~rtc-fixed-potential-race-condition drivers/rtc/rtc-test.c
--- a/drivers/rtc/rtc-test.c~rtc-fixed-potential-race-condition
+++ a/drivers/rtc/rtc-test.c
@@ -104,20 +104,17 @@ static int test_probe(struct platform_de
 	rtc = devm_rtc_device_register(&plat_dev->dev, "test",
 				&test_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
-		err = PTR_ERR(rtc);
-		return err;
+		return PTR_ERR(rtc);
 	}
 
 	err = device_create_file(&plat_dev->dev, &dev_attr_irq);
 	if (err)
-		goto err;
+		dev_err(&plat_dev->dev, "Unable to create sysfs entry: %s\n",
+			dev_attr_irq.attr.name);
 
 	platform_set_drvdata(plat_dev, rtc);
 
 	return 0;

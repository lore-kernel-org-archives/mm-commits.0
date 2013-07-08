From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds1307-use-devm_-functions.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:33:22 -0700
Message-ID: <51db1402.WWRWiQUFFoa2woYD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab3GHTdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-ds1307-use-devm_-functions.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:22 -0700


The patch titled
     Subject: rtc: rtc-ds1307: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1307-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds1307: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   43 ++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-rtc-ds1307-use-devm_-functions drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-rtc-ds1307-use-devm_-functions
+++ a/drivers/rtc/rtc-ds1307.c
@@ -683,7 +683,7 @@ static int ds1307_probe(struct i2c_clien
 	    && !i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
-	ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL);
+	ds1307 = devm_kzalloc(&client->dev, sizeof(struct ds1307), GFP_KERNEL);
 	if (!ds1307)
 		return -ENOMEM;
 
@@ -715,7 +715,7 @@ static int ds1307_probe(struct i2c_clien
 		if (tmp != 2) {
 			dev_dbg(&client->dev, "read error %d\n", tmp);
 			err = -EIO;
-			goto exit_free;
+			goto exit;
 		}
 
 		/* oscillator off?  turn it on, so clock can tick. */
@@ -754,7 +754,7 @@ static int ds1307_probe(struct i2c_clien
 		if (tmp != 2) {
 			dev_dbg(&client->dev, "read error %d\n", tmp);
 			err = -EIO;
-			goto exit_free;
+			goto exit;
 		}
 
 		/* oscillator off?  turn it on, so clock can tick. */
@@ -798,7 +798,7 @@ static int ds1307_probe(struct i2c_clien
 			if (tmp != 2) {
 				dev_dbg(&client->dev, "read error %d\n", tmp);
 				err = -EIO;
-				goto exit_free;
+				goto exit;
 			}
 
 			/* correct hour */
@@ -826,7 +826,7 @@ read_rtc:
 	if (tmp != 8) {
 		dev_dbg(&client->dev, "read error %d\n", tmp);
 		err = -EIO;
-		goto exit_free;
+		goto exit;
 	}
 
 	/*
@@ -868,7 +868,7 @@ read_rtc:
 		if (tmp < 0) {
 			dev_dbg(&client->dev, "read error %d\n", tmp);
 			err = -EIO;
-			goto exit_free;
+			goto exit;
 		}
 
 		/* oscillator fault?  clear flag, and warn */
@@ -927,13 +927,13 @@ read_rtc:
 				bin2bcd(tmp));
 	}
 
-	ds1307->rtc = rtc_device_register(client->name, &client->dev,
+	ds1307->rtc = devm_rtc_device_register(&client->dev, client->name,
 				&ds13xx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ds1307->rtc)) {
 		err = PTR_ERR(ds1307->rtc);
 		dev_err(&client->dev,
 			"unable to register the class device\n");
-		goto exit_free;
+		goto exit;
 	}
 
 	if (want_irq) {
@@ -942,7 +942,7 @@ read_rtc:
 		if (err) {
 			dev_err(&client->dev,
 				"unable to request IRQ!\n");
-			goto exit_irq;
+			goto exit;
 		}
 
 		device_set_wakeup_capable(&client->dev, 1);
@@ -951,11 +951,12 @@ read_rtc:
 	}
 
 	if (chip->nvram_size) {
-		ds1307->nvram = kzalloc(sizeof(struct bin_attribute),
-							GFP_KERNEL);
+		ds1307->nvram = devm_kzalloc(&client->dev,
+					sizeof(struct bin_attribute),
+					GFP_KERNEL);
 		if (!ds1307->nvram) {
 			err = -ENOMEM;
-			goto exit_nvram;
+			goto exit;
 		}
 		ds1307->nvram->attr.name = "nvram";
 		ds1307->nvram->attr.mode = S_IRUGO | S_IWUSR;
@@ -965,21 +966,15 @@ read_rtc:
 		ds1307->nvram->size = chip->nvram_size;
 		ds1307->nvram_offset = chip->nvram_offset;
 		err = sysfs_create_bin_file(&client->dev.kobj, ds1307->nvram);
-		if (err) {
-			kfree(ds1307->nvram);
-			goto exit_nvram;
-		}
+		if (err)
+			goto exit;
 		set_bit(HAS_NVRAM, &ds1307->flags);
 		dev_info(&client->dev, "%zu bytes nvram\n", ds1307->nvram->size);
 	}
 
 	return 0;
 
-exit_nvram:
-exit_irq:
-	rtc_device_unregister(ds1307->rtc);
-exit_free:
-	kfree(ds1307);
+exit:
 	return err;
 }
 
@@ -992,13 +987,9 @@ static int ds1307_remove(struct i2c_clie
 		cancel_work_sync(&ds1307->work);
 	}
 
-	if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags)) {
+	if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags))
 		sysfs_remove_bin_file(&client->dev.kobj, ds1307->nvram);
-		kfree(ds1307->nvram);
-	}
 
-	rtc_device_unregister(ds1307->rtc);
-	kfree(ds1307);
 	return 0;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch


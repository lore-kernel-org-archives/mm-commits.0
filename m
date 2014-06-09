From: akpm@linux-foundation.org
Subject: [merged] rtc-m41t80-clean-up-error-paths.patch removed from -mm
 tree
Date: Mon, 09 Jun 2014 12:28:37 -0700
Message-ID: <53960ae5.6DwJWVI+QSY0el93%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbaFIT2i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:28:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, a.zummo@towertech.it, wsa@sang-engineering.com

Subject: [merged] rtc-m41t80-clean-up-error-paths.patch removed from -mm tree
To: wsa@sang-engineering.com,a.zummo@towertech.it,jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:28:37 -0700


The patch titled
     Subject: drivers/rtc/rtc-m41t80.c: clean up error paths
has been removed from the -mm tree.  Its filename was
     rtc-m41t80-clean-up-error-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wolfram Sang <wsa@sang-engineering.com>
Subject: drivers/rtc/rtc-m41t80.c: clean up error paths

There is no cleanup needed when something fails in probe, so no need for
goto.  Directly return when something fails.

Signed-off-by: Wolfram Sang <wsa@sang-engineering.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t80.c |   64 +++++++++++++------------------------
 1 file changed, 23 insertions(+), 41 deletions(-)

diff -puN drivers/rtc/rtc-m41t80.c~rtc-m41t80-clean-up-error-paths drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-m41t80-clean-up-error-paths
+++ a/drivers/rtc/rtc-m41t80.c
@@ -627,37 +627,28 @@ static int m41t80_probe(struct i2c_clien
 	struct m41t80_data *clientdata = NULL;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C
-				     | I2C_FUNC_SMBUS_BYTE_DATA)) {
-		rc = -ENODEV;
-		goto exit;
-	}
+				     | I2C_FUNC_SMBUS_BYTE_DATA))
+		return -ENODEV;
 
 	clientdata = devm_kzalloc(&client->dev, sizeof(*clientdata),
 				GFP_KERNEL);
-	if (!clientdata) {
-		rc = -ENOMEM;
-		goto exit;
-	}
+	if (!clientdata)
+		return -ENOMEM;
 
 	clientdata->features = id->driver_data;
 	i2c_set_clientdata(client, clientdata);
 
 	rtc = devm_rtc_device_register(&client->dev, client->name,
 					&m41t80_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		rc = PTR_ERR(rtc);
-		rtc = NULL;
-		goto exit;
-	}
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 
 	clientdata->rtc = rtc;
 
 	/* Make sure HT (Halt Update) bit is cleared */
 	rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_HOUR);
-	if (rc < 0)
-		goto ht_err;
 
-	if (rc & M41T80_ALHOUR_HT) {
+	if (rc >= 0 && rc & M41T80_ALHOUR_HT) {
 		if (clientdata->features & M41T80_FEATURE_HT) {
 			m41t80_get_datetime(client, &tm);
 			dev_info(&client->dev, "HT bit was set!\n");
@@ -668,53 +659,44 @@ static int m41t80_probe(struct i2c_clien
 				 tm.tm_mon + 1, tm.tm_mday, tm.tm_hour,
 				 tm.tm_min, tm.tm_sec);
 		}
-		if (i2c_smbus_write_byte_data(client,
-					      M41T80_REG_ALARM_HOUR,
-					      rc & ~M41T80_ALHOUR_HT) < 0)
-			goto ht_err;
+		rc = i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_HOUR,
+					      rc & ~M41T80_ALHOUR_HT);
+	}
+
+	if (rc < 0) {
+		dev_err(&client->dev, "Can't clear HT bit\n");
+		return -EIO;
 	}
 
 	/* Make sure ST (stop) bit is cleared */
 	rc = i2c_smbus_read_byte_data(client, M41T80_REG_SEC);
-	if (rc < 0)
-		goto st_err;
 
-	if (rc & M41T80_SEC_ST) {
-		if (i2c_smbus_write_byte_data(client, M41T80_REG_SEC,
-					      rc & ~M41T80_SEC_ST) < 0)
-			goto st_err;
+	if (rc >= 0 && rc & M41T80_SEC_ST)
+		rc = i2c_smbus_write_byte_data(client, M41T80_REG_SEC,
+					      rc & ~M41T80_SEC_ST);
+	if (rc < 0) {
+		dev_err(&client->dev, "Can't clear ST bit\n");
+		return -EIO;
 	}
 
 	rc = m41t80_sysfs_register(&client->dev);
 	if (rc)
-		goto exit;
+		return rc;
 
 #ifdef CONFIG_RTC_DRV_M41T80_WDT
 	if (clientdata->features & M41T80_FEATURE_HT) {
 		save_client = client;
 		rc = misc_register(&wdt_dev);
 		if (rc)
-			goto exit;
+			return rc;
 		rc = register_reboot_notifier(&wdt_notifier);
 		if (rc) {
 			misc_deregister(&wdt_dev);
-			goto exit;
+			return rc;
 		}
 	}
 #endif
 	return 0;
-
-st_err:
-	rc = -EIO;
-	dev_err(&client->dev, "Can't clear ST bit\n");
-	goto exit;
-ht_err:
-	rc = -EIO;
-	dev_err(&client->dev, "Can't clear HT bit\n");
-	goto exit;

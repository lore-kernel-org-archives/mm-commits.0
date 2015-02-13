From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-v2.patch removed from -mm tree
Date: Fri, 13 Feb 2015 14:31:53 -0800
Message-ID: <54de7b59.xdZimmCOvTb4vLdI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbbBMWby (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 17:31:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-v2
has been removed from the -mm tree.  Its filename was
     rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-v2.patch

This patch was dropped because it was folded into rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip.patch

------------------------------------------------------
From: Arnaud Ebalard <arno@natisbad.org>
Subject: rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-v2

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/i2c/trivial-devices.txt |    2 
 drivers/rtc/rtc-ab-b5ze-s3.c                              |   32 ++++++----
 2 files changed, 22 insertions(+), 12 deletions(-)

diff -puN Documentation/devicetree/bindings/i2c/trivial-devices.txt~rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-v2 Documentation/devicetree/bindings/i2c/trivial-devices.txt
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt~rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-v2
+++ a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -9,7 +9,7 @@ document for it just like any other devi
 
 Compatible		Vendor / Chip
 ==========		=============
-abcn,abb5zes3		AB-RTCMC-32.768kHz-B5ZE-S3: Real Time Clock/Calendar Module with I2C Interface
+abracon,abb5zes3		AB-RTCMC-32.768kHz-B5ZE-S3: Real Time Clock/Calendar Module with I2C Interface
 ad,ad7414		SMBus/I2C Digital Temperature Sensor in 6-Pin SOT with SMBus Alert and Over Temperature Pin
 ad,adm9240		ADM9240:  Complete System Hardware Monitor for uProcessor-Based Systems
 adi,adt7461		+/-1C TDM Extended Temp Range I.C
diff -puN drivers/rtc/rtc-ab-b5ze-s3.c~rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-v2 drivers/rtc/rtc-ab-b5ze-s3.c
--- a/drivers/rtc/rtc-ab-b5ze-s3.c~rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-v2
+++ a/drivers/rtc/rtc-ab-b5ze-s3.c
@@ -648,31 +648,35 @@ static struct regmap_config abb5zes3_rtc
 static int abb5zes3_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
+	struct abb5zes3_rtc_data *data = NULL;
 	struct device *dev = &client->dev;
-	struct abb5zes3_rtc_data *data;
 	struct regmap *regmap;
 	int ret;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C |
 				     I2C_FUNC_SMBUS_BYTE_DATA |
-				     I2C_FUNC_SMBUS_I2C_BLOCK))
-		return -ENODEV;
+				     I2C_FUNC_SMBUS_I2C_BLOCK)) {
+		ret = -ENODEV;
+		goto err;
+	}
 
 	regmap = devm_regmap_init_i2c(client, &abb5zes3_rtc_regmap_config);
 	if (IS_ERR(regmap)) {
 		ret = PTR_ERR(regmap);
 		dev_err(dev, "%s: regmap allocation failed: %d\n",
 			__func__, ret);
-		return ret;
+		goto err;
 	}
 
 	ret = abb5zes3_i2c_validate_chip(regmap);
 	if (ret)
-		return ret;
+		goto err;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	if (!data) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
 	mutex_init(&data->lock);
 	data->regmap = regmap;
@@ -680,7 +684,7 @@ static int abb5zes3_probe(struct i2c_cli
 
 	ret = abb5zes3_rtc_check_setup(dev);
 	if (ret)
-		return ret;
+		goto err;
 
 	if (client->irq > 0) {
 		ret = devm_request_threaded_irq(dev, client->irq, NULL,
@@ -695,6 +699,7 @@ static int abb5zes3_probe(struct i2c_cli
 		} else {
 			dev_err(dev, "%s: irq %d unavailable (%d)\n",
 				__func__, client->irq, ret);
+			goto err;
 		}
 	}
 
@@ -704,7 +709,7 @@ static int abb5zes3_probe(struct i2c_cli
 	if (ret) {
 		dev_err(dev, "%s: unable to register RTC device (%d)\n",
 			__func__, ret);
-		device_init_wakeup(dev, false);
+		goto err;
 	}
 
 	/*
@@ -718,11 +723,16 @@ static int abb5zes3_probe(struct i2c_cli
 	/* Enable battery low detection interrupt if battery not already low */
 	if (!data->battery_low && data->irq) {
 		ret = _abb5zes3_rtc_battery_low_irq_enable(regmap, true);
-		if (ret)
+		if (ret) {
 			dev_err(dev, "%s: enabling battery low interrupt "
 				"generation failed (%d)\n", __func__, ret);
+			goto err;
+		}
 	}
 
+err:
+	if (ret && data && data->irq)
+		device_init_wakeup(dev, false);
 	return ret;
 }
 
@@ -763,7 +773,7 @@ static SIMPLE_DEV_PM_OPS(abb5zes3_rtc_pm
 
 #ifdef CONFIG_OF
 static const struct of_device_id abb5zes3_dt_match[] = {
-	{ .compatible = "abcn,abb5zes3" },
+	{ .compatible = "abracon,abb5zes3" },
 	{ },
 };
 #endif
_

Patches currently in -mm which might be from arno@natisbad.org are

origin.patch
rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver.patch
rtc-rtc-isl12057-add-isilirq2-can-wakeup-machine-property-for-in-tree-users.patch
arm-mvebu-isl12057-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120.patch
of-add-vendor-prefix-for-abracon-corporation.patch
rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip.patch
rtc-rtc-ab-b5ze-s3-add-sub-minute-alarm-support.patch
rtc-armada38x-add-the-device-tree-binding-documentation.patch
drivers-rtc-rtc-armada38x-add-a-new-rtc-driver-for-recent-mvebu-socs.patch
maintainers-add-the-rtc-driver-for-the-armada38x.patch
arm-mvebu-add-device-tree-description-of-rtc-on-armada-38x.patch
arm-mvebu-enable-armada-38x-rtc-driver-in-mvebu_v7_defconfig.patch


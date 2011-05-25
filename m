From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lm3530c-add-regulator.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:03 -0700
Message-ID: <201105252030.p4PKUQUc014962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932231Ab1EYUbL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:31:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shreshthakumar.sahu@stericsson.com, lee.jones@linaro.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-lm3530.c: add regulator
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lm3530c-add-regulator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-lm3530.c: add regulator
From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>

Add add regulator support to lm3530 driver.  The lm3530 driver needs to
get proper regulator during device probe and enable it before accessing
the device.  Also it disables the regulator in case of brightness ==
LED_OFF, and puts it back during driver removal.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |   75 ++++++++++++++++++++++++++++++-----
 1 file changed, 66 insertions(+), 9 deletions(-)

diff -puN drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-add-regulator drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-add-regulator
+++ a/drivers/leds/leds-lm3530.c
@@ -17,6 +17,7 @@
 #include <linux/input.h>
 #include <linux/led-lm3530.h>
 #include <linux/types.h>
+#include <linux/regulator/consumer.h>
 
 #define LM3530_LED_DEV "lcd-backlight"
 #define LM3530_NAME "lm3530-led"
@@ -96,12 +97,18 @@ static struct lm3530_mode_map mode_map[]
  * @client: i2c client
  * @pdata: LM3530 platform data
  * @mode: mode of operation - manual, ALS, PWM
+ * @regulator: regulator
+ * @brighness: previous brightness value
+ * @enable: regulator is enabled
  */
 struct lm3530_data {
 	struct led_classdev led_dev;
 	struct i2c_client *client;
 	struct lm3530_platform_data *pdata;
 	enum lm3530_mode mode;
+	struct regulator *regulator;
+	enum led_brightness brightness;
+	bool enable;
 };
 
 static const u8 lm3530_reg[LM3530_REG_MAX] = {
@@ -172,7 +179,10 @@ static int lm3530_init_registers(struct 
 	brt_ramp = (pltfm->brt_ramp_fall << LM3530_BRT_RAMP_FALL_SHIFT) |
 			(pltfm->brt_ramp_rise << LM3530_BRT_RAMP_RISE_SHIFT);
 
-	brightness = pltfm->brt_val;
+	if (drvdata->brightness)
+		brightness = drvdata->brightness;
+	else
+		brightness = drvdata->brightness = pltfm->brt_val;
 
 	reg_val[0] = gen_config;	/* LM3530_GEN_CONFIG */
 	reg_val[1] = als_config;	/* LM3530_ALS_CONFIG */
@@ -190,6 +200,16 @@ static int lm3530_init_registers(struct 
 	reg_val[13] = LM3530_DEF_ZT_3;	/* LM3530_ALS_Z3T_REG */
 	reg_val[14] = LM3530_DEF_ZT_4;	/* LM3530_ALS_Z4T_REG */
 
+	if (!drvdata->enable) {
+		ret = regulator_enable(drvdata->regulator);
+		if (ret) {
+			dev_err(&drvdata->client->dev,
+					"Enable regulator failed\n");
+			return ret;
+		}
+		drvdata->enable = true;
+	}
+
 	for (i = 0; i < LM3530_REG_MAX; i++) {
 		ret = i2c_smbus_write_byte_data(client,
 				lm3530_reg[i], reg_val[i]);
@@ -210,12 +230,31 @@ static void lm3530_brightness_set(struct
 	switch (drvdata->mode) {
 	case LM3530_BL_MODE_MANUAL:
 
+		if (!drvdata->enable) {
+			err = lm3530_init_registers(drvdata);
+			if (err) {
+				dev_err(&drvdata->client->dev,
+					"Register Init failed: %d\n", err);
+				break;
+			}
+		}
+
 		/* set the brightness in brightness control register*/
 		err = i2c_smbus_write_byte_data(drvdata->client,
 				LM3530_BRT_CTRL_REG, brt_val / 2);
 		if (err)
 			dev_err(&drvdata->client->dev,
 				"Unable to set brightness: %d\n", err);
+		else
+			drvdata->brightness = brt_val / 2;
+
+		if (brt_val == 0) {
+			err = regulator_disable(drvdata->regulator);
+			if (err)
+				dev_err(&drvdata->client->dev,
+					"Disable regulator failed\n");
+			drvdata->enable = false;
+		}
 		break;
 	case LM3530_BL_MODE_ALS:
 		break;
@@ -297,20 +336,31 @@ static int __devinit lm3530_probe(struct
 	drvdata->mode = pdata->mode;
 	drvdata->client = client;
 	drvdata->pdata = pdata;
+	drvdata->brightness = LED_OFF;
+	drvdata->enable = false;
 	drvdata->led_dev.name = LM3530_LED_DEV;
 	drvdata->led_dev.brightness_set = lm3530_brightness_set;
 
 	i2c_set_clientdata(client, drvdata);
 
-	err = lm3530_init_registers(drvdata);
-	if (err < 0) {
-		dev_err(&client->dev, "Register Init failed: %d\n", err);
-		err = -ENODEV;
-		goto err_reg_init;
+	drvdata->regulator = regulator_get(&client->dev, "vin");
+	if (IS_ERR(drvdata->regulator)) {
+		dev_err(&client->dev, "regulator get failed\n");
+		err = PTR_ERR(drvdata->regulator);
+		drvdata->regulator = NULL;
+		goto err_regulator_get;
+	}
+
+	if (drvdata->pdata->brt_val) {
+		err = lm3530_init_registers(drvdata);
+		if (err < 0) {
+			dev_err(&client->dev,
+				"Register Init failed: %d\n", err);
+			err = -ENODEV;
+			goto err_reg_init;
+		}
 	}
-
-	err = led_classdev_register((struct device *)
-				      &client->dev, &drvdata->led_dev);
+	err = led_classdev_register(&client->dev, &drvdata->led_dev);
 	if (err < 0) {
 		dev_err(&client->dev, "Register led class failed: %d\n", err);
 		err = -ENODEV;
@@ -330,6 +380,9 @@ err_create_file:
 	led_classdev_unregister(&drvdata->led_dev);
 err_class_register:
 err_reg_init:
+	regulator_put(drvdata->regulator);
+err_regulator_get:
+	i2c_set_clientdata(client, NULL);
 	kfree(drvdata);
 err_out:
 	return err;
@@ -340,6 +393,10 @@ static int __devexit lm3530_remove(struc
 	struct lm3530_data *drvdata = i2c_get_clientdata(client);
 
 	device_remove_file(drvdata->led_dev.dev, &dev_attr_mode);
+
+	if (drvdata->enable)
+		regulator_disable(drvdata->regulator);
+	regulator_put(drvdata->regulator);
 	led_classdev_unregister(&drvdata->led_dev);
 	kfree(drvdata);
 	return 0;
_

Patches currently in -mm which might be from shreshthakumar.sahu@stericsson.com are

origin.patch


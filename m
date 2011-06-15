From: akpm@linux-foundation.org
Subject: [folded] backlight-new-driver-for-the-adp8870-backlight-devices-v2.patch removed from -mm tree
Date: Wed, 15 Jun 2011 15:01:35 -0700
Message-ID: <201106152201.p5FM1aRs022014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555Ab1FOWCV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jun 2011 18:02:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, rpurdie@rpsys.net, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     backlight-new-driver-for-the-adp8870-backlight-devices-v2
has been removed from the -mm tree.  Its filename was
     backlight-new-driver-for-the-adp8870-backlight-devices-v2.patch

This patch was dropped because it was folded into backlight-new-driver-for-the-adp8870-backlight-devices.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight-new-driver-for-the-adp8870-backlight-devices-v2
From: Michael Hennerich <michael.hennerich@analog.com>

This should have all the feedback thus far posted addressed

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870 |   56 ++
 drivers/video/backlight/adp8870_bl.c                           |  192 +++++++---
 2 files changed, 199 insertions(+), 49 deletions(-)

diff -puN /dev/null Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870
@@ -0,0 +1,56 @@
+What:		/sys/class/backlight/<backlight>/<ambient light zone>_max
+What:		/sys/class/backlight/<backlight>/l1_daylight_max
+What:		/sys/class/backlight/<backlight>/l2_bright_max
+What:		/sys/class/backlight/<backlight>/l3_office_max
+What:		/sys/class/backlight/<backlight>/l4_indoor_max
+What:		/sys/class/backlight/<backlight>/l5_dark_max
+Date:		Mai 2011
+KernelVersion:	2.6.40
+Contact:	device-drivers-devel@blackfin.uclinux.org
+Description:
+		Control the maximum brightness for <ambient light zone>
+		on this <backlight>. Values are between 0 and 127. This file
+		will also show the brightness level stored for this
+		<ambient light zone>.
+
+What:		/sys/class/backlight/<backlight>/<ambient light zone>_dim
+What:		/sys/class/backlight/<backlight>/l2_bright_dim
+What:		/sys/class/backlight/<backlight>/l3_office_dim
+What:		/sys/class/backlight/<backlight>/l4_indoor_dim
+What:		/sys/class/backlight/<backlight>/l5_dark_dim
+Date:		Mai 2011
+KernelVersion:	2.6.40
+Contact:	device-drivers-devel@blackfin.uclinux.org
+Description:
+		Control the dim brightness for <ambient light zone>
+		on this <backlight>. Values are between 0 and 127, typically
+		set to 0. Full off when the backlight is disabled.
+		This file will also show the dim brightness level stored for
+		this <ambient light zone>.
+
+What:		/sys/class/backlight/<backlight>/ambient_light_level
+Date:		Mai 2011
+KernelVersion:	2.6.40
+Contact:	device-drivers-devel@blackfin.uclinux.org
+Description:
+		Get conversion value of the light sensor.
+		This value is updated every 80 ms (when the light sensor
+		is enabled). Returns integer between 0 (dark) and
+		8000 (max ambient brightness)
+
+What:		/sys/class/backlight/<backlight>/ambient_light_zone
+Date:		Mai 2011
+KernelVersion:	2.6.40
+Contact:	device-drivers-devel@blackfin.uclinux.org
+Description:
+		Get/Set current ambient light zone. Reading returns
+		integer between 1..5 (1 = daylight, 2 = bright, ..., 5 = dark).
+		Writing a value between 1..5 forces the backlight controller
+		to enter the corresponding ambient light zone.
+		Writing 0 returns to normal/automatic ambient light level
+		operation. The ambient light sensing feature on these devices
+		is an extension to the API documented in
+		Documentation/ABI/stable/sysfs-class-backlight.
+		It can be enabled by writing the value stored in
+		/sys/class/backlight/<backlight>/max_brightness to
+		/sys/class/backlight/<backlight>/brightness.
\ No newline at end of file
diff -puN drivers/video/backlight/adp8870_bl.c~backlight-new-driver-for-the-adp8870-backlight-devices-v2 drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~backlight-new-driver-for-the-adp8870-backlight-devices-v2
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -1,7 +1,7 @@
 /*
  * Backlight driver for Analog Devices ADP8870 Backlight Devices
  *
- * Copyright 2009-2010 Analog Devices Inc.
+ * Copyright 2009-2011 Analog Devices Inc.
  *
  * Licensed under the GPL-2 or later.
  */
@@ -104,7 +104,7 @@
 
 #define FADE_VAL(in, out)	((0xF & (in)) | ((0xF & (out)) << 4))
 #define BL_CFGR_VAL(law, blv)	((((blv) & CFGR_BLV_MASK) << CFGR_BLV_SHIFT) | ((0x3 & (law)) << 1))
-#define ALS_CMPR_CFG_VAL(filt)	((0x7 & filt) << 1)
+#define ALS_CMPR_CFG_VAL(filt)	((0x7 & (filt)) << 1)
 
 struct adp8870_bl {
 	struct i2c_client *client;
@@ -137,14 +137,18 @@ static int adp8870_read(struct i2c_clien
 		return ret;
 	}
 
-	*val = (uint8_t)ret;
+	*val = ret;
 	return 0;
 }
 
 
 static int adp8870_write(struct i2c_client *client, u8 reg, u8 val)
 {
-	return i2c_smbus_write_byte_data(client, reg, val);
+	int ret = i2c_smbus_write_byte_data(client, reg, val);
+	if (ret)
+		dev_err(&client->dev, "failed to write\n");
+
+	return ret;
 }
 
 static int adp8870_set_bits(struct i2c_client *client, int reg, uint8_t bit_mask)
@@ -203,6 +207,9 @@ static void adp8870_led_set(struct led_c
 
 	led = container_of(led_cdev, struct adp8870_led, cdev);
 	led->new_brightness = value;
+	/*
+	 * Use workqueue for IO since I2C operations can sleep.
+	 */
 	schedule_work(&led->work);
 }
 
@@ -212,13 +219,18 @@ static int adp8870_led_setup(struct adp8
 	int ret = 0;
 
 	ret = adp8870_write(client, ADP8870_ISC1 + led->id - 1, 0);
-	ret |= adp8870_set_bits(client, ADP8870_ISCC, 1 << (led->id - 1));
+	if (ret)
+		return ret;
+
+	ret = adp8870_set_bits(client, ADP8870_ISCC, 1 << (led->id - 1));
+	if (ret)
+		return ret;
 
 	if (led->id > 4)
-		ret |= adp8870_set_bits(client, ADP8870_ISCT1,
+		ret = adp8870_set_bits(client, ADP8870_ISCT1,
 				(led->flags & 0x3) << ((led->id - 5) * 2));
 	else
-		ret |= adp8870_set_bits(client, ADP8870_ISCT2,
+		ret = adp8870_set_bits(client, ADP8870_ISCT2,
 				(led->flags & 0x3) << ((led->id - 1) * 2));
 
 	return ret;
@@ -233,22 +245,26 @@ static int __devinit adp8870_led_probe(s
 	struct led_info *cur_led;
 	int ret, i;
 
-	led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
+
+	led = kcalloc(pdata->num_leds, sizeof(*led), GFP_KERNEL);
 	if (led == NULL) {
 		dev_err(&client->dev, "failed to alloc memory\n");
 		return -ENOMEM;
 	}
 
 	ret = adp8870_write(client, ADP8870_ISCLAW, pdata->led_fade_law);
+	if (ret)
+		goto err_free;
+
 	ret = adp8870_write(client, ADP8870_ISCT1,
 			(pdata->led_on_time & 0x3) << 6);
-	ret |= adp8870_write(client, ADP8870_ISCF,
-			FADE_VAL(pdata->led_fade_in, pdata->led_fade_out));
+	if (ret)
+		goto err_free;
 
-	if (ret) {
-		dev_err(&client->dev, "failed to write\n");
+	ret = adp8870_write(client, ADP8870_ISCF,
+			FADE_VAL(pdata->led_fade_in, pdata->led_fade_out));
+	if (ret)
 		goto err_free;
-	}
 
 	for (i = 0; i < pdata->num_leds; ++i) {
 		cur_led = &pdata->leds[i];
@@ -344,27 +360,39 @@ static int adp8870_bl_set(struct backlig
 	if (data->pdata->en_ambl_sens) {
 		if ((brightness > 0) && (brightness < ADP8870_MAX_BRIGHTNESS)) {
 			/* Disable Ambient Light auto adjust */
-			ret |= adp8870_clr_bits(client, ADP8870_MDCR,
+			ret = adp8870_clr_bits(client, ADP8870_MDCR,
 					CMP_AUTOEN);
-			ret |= adp8870_write(client, ADP8870_BLMX1, brightness);
+			if (ret)
+				return ret;
+			ret = adp8870_write(client, ADP8870_BLMX1, brightness);
+			if (ret)
+				return ret;
 		} else {
 			/*
 			 * MAX_BRIGHTNESS -> Enable Ambient Light auto adjust
 			 * restore daylight l1 sysfs brightness
 			 */
-			ret |= adp8870_write(client, ADP8870_BLMX1,
+			ret = adp8870_write(client, ADP8870_BLMX1,
 					 data->cached_daylight_max);
-			ret |= adp8870_set_bits(client, ADP8870_MDCR,
+			if (ret)
+				return ret;
+
+			ret = adp8870_set_bits(client, ADP8870_MDCR,
 					 CMP_AUTOEN);
+			if (ret)
+				return ret;
 		}
-	} else
-		ret |= adp8870_write(client, ADP8870_BLMX1, brightness);
+	} else {
+		ret = adp8870_write(client, ADP8870_BLMX1, brightness);
+		if (ret)
+			return ret;
+	}
 
 	if (data->current_brightness && brightness == 0)
-		ret |= adp8870_set_bits(client,
+		ret = adp8870_set_bits(client,
 				ADP8870_MDCR, DIM_EN);
 	else if (data->current_brightness == 0 && brightness)
-		ret |= adp8870_clr_bits(client,
+		ret = adp8870_clr_bits(client,
 				ADP8870_MDCR, DIM_EN);
 
 	if (!ret)
@@ -404,57 +432,119 @@ static int adp8870_bl_setup(struct backl
 	struct adp8870_backlight_platform_data *pdata = data->pdata;
 	int ret = 0;
 
-	ret |= adp8870_write(client, ADP8870_BLSEL, ~pdata->bl_led_assign);
-	ret |= adp8870_write(client, ADP8870_PWMLED, pdata->pwm_assign);
-	ret |= adp8870_write(client, ADP8870_BLMX1, pdata->l1_daylight_max);
-	ret |= adp8870_write(client, ADP8870_BLDM1, pdata->l1_daylight_dim);
+	ret = adp8870_write(client, ADP8870_BLSEL, ~pdata->bl_led_assign);
+	if (ret)
+		return ret;
+
+	ret = adp8870_write(client, ADP8870_PWMLED, pdata->pwm_assign);
+	if (ret)
+		return ret;
+
+	ret = adp8870_write(client, ADP8870_BLMX1, pdata->l1_daylight_max);
+	if (ret)
+		return ret;
+
+	ret = adp8870_write(client, ADP8870_BLDM1, pdata->l1_daylight_dim);
+	if (ret)
+		return ret;
 
 	if (pdata->en_ambl_sens) {
 		data->cached_daylight_max = pdata->l1_daylight_max;
-		ret |= adp8870_write(client, ADP8870_BLMX2,
+		ret = adp8870_write(client, ADP8870_BLMX2,
 						pdata->l2_bright_max);
-		ret |= adp8870_write(client, ADP8870_BLDM2,
+		if (ret)
+			return ret;
+		ret = adp8870_write(client, ADP8870_BLDM2,
 						pdata->l2_bright_dim);
-		ret |= adp8870_write(client, ADP8870_BLMX3,
+		if (ret)
+			return ret;
+
+		ret = adp8870_write(client, ADP8870_BLMX3,
 						pdata->l3_office_max);
-		ret |= adp8870_write(client, ADP8870_BLDM3,
+		if (ret)
+			return ret;
+		ret = adp8870_write(client, ADP8870_BLDM3,
 						pdata->l3_office_dim);
-		ret |= adp8870_write(client, ADP8870_BLMX4,
+		if (ret)
+			return ret;
+
+		ret = adp8870_write(client, ADP8870_BLMX4,
 						pdata->l4_indoor_max);
-		ret |= adp8870_write(client, ADP8870_BLDM4,
+		if (ret)
+			return ret;
+
+		ret = adp8870_write(client, ADP8870_BLDM4,
 						pdata->l4_indor_dim);
-		ret |= adp8870_write(client, ADP8870_BLMX5,
+		if (ret)
+			return ret;
+
+		ret = adp8870_write(client, ADP8870_BLMX5,
 						pdata->l5_dark_max);
-		ret |= adp8870_write(client, ADP8870_BLDM5,
+		if (ret)
+			return ret;
+
+		ret = adp8870_write(client, ADP8870_BLDM5,
 						pdata->l5_dark_dim);
+		if (ret)
+			return ret;
+
+		ret = adp8870_write(client, ADP8870_L2TRP, pdata->l2_trip);
+		if (ret)
+			return ret;
+
+		ret = adp8870_write(client, ADP8870_L2HYS, pdata->l2_hyst);
+		if (ret)
+			return ret;
+
+		ret = adp8870_write(client, ADP8870_L3TRP, pdata->l3_trip);
+		if (ret)
+			return ret;
+
+		ret = adp8870_write(client, ADP8870_L3HYS, pdata->l3_hyst);
+		if (ret)
+			return ret;
+
+		ret = adp8870_write(client, ADP8870_L4TRP, pdata->l4_trip);
+		if (ret)
+			return ret;
+
+		ret = adp8870_write(client, ADP8870_L4HYS, pdata->l4_hyst);
+		if (ret)
+			return ret;
+
+		ret = adp8870_write(client, ADP8870_L5TRP, pdata->l5_trip);
+		if (ret)
+			return ret;
+
+		ret = adp8870_write(client, ADP8870_L5HYS, pdata->l5_hyst);
+		if (ret)
+			return ret;
 
-		ret |= adp8870_write(client, ADP8870_L2TRP, pdata->l2_trip);
-		ret |= adp8870_write(client, ADP8870_L2HYS, pdata->l2_hyst);
-		ret |= adp8870_write(client, ADP8870_L3TRP, pdata->l3_trip);
-		ret |= adp8870_write(client, ADP8870_L3HYS, pdata->l3_hyst);
-		ret |= adp8870_write(client, ADP8870_L4TRP, pdata->l4_trip);
-		ret |= adp8870_write(client, ADP8870_L4HYS, pdata->l4_hyst);
-		ret |= adp8870_write(client, ADP8870_L5TRP, pdata->l5_trip);
-		ret |= adp8870_write(client, ADP8870_L5HYS, pdata->l5_hyst);
-		ret |= adp8870_write(client, ADP8870_ALS1_EN, L5_EN | L4_EN |
+		ret = adp8870_write(client, ADP8870_ALS1_EN, L5_EN | L4_EN |
 						L3_EN | L2_EN);
+		if (ret)
+			return ret;
 
-		ret |= adp8870_write(client, ADP8870_CMP_CTL,
+		ret = adp8870_write(client, ADP8870_CMP_CTL,
 			ALS_CMPR_CFG_VAL(pdata->abml_filt));
-
+		if (ret)
+			return ret;
 	}
 
-	ret |= adp8870_write(client, ADP8870_CFGR,
+	ret = adp8870_write(client, ADP8870_CFGR,
 			BL_CFGR_VAL(pdata->bl_fade_law, 0));
+	if (ret)
+		return ret;
 
-	ret |= adp8870_write(client, ADP8870_BLFR, FADE_VAL(pdata->bl_fade_in,
+	ret = adp8870_write(client, ADP8870_BLFR, FADE_VAL(pdata->bl_fade_in,
 			pdata->bl_fade_out));
-
+	if (ret)
+		return ret;
 	/*
 	 * ADP8870 Rev0 requires GDWN_DIS bit set
 	 */
 
-	ret |= adp8870_set_bits(client, ADP8870_MDCR, BLEN | DIM_EN | NSTBY |
+	ret = adp8870_set_bits(client, ADP8870_MDCR, BLEN | DIM_EN | NSTBY |
 			(data->revid == 0 ? GDWN_DIS : 0));
 
 	return ret;
@@ -659,8 +749,12 @@ static ssize_t adp8870_bl_ambient_light_
 
 	mutex_lock(&data->lock);
 	error = adp8870_read(data->client, ADP8870_PH1LEVL, &reg_val);
+	if (error < 0) {
+		mutex_unlock(&data->lock);
+		return error;
+	}
 	ret_val = reg_val;
-	error |= adp8870_read(data->client, ADP8870_PH1LEVH, &reg_val);
+	error = adp8870_read(data->client, ADP8870_PH1LEVH, &reg_val);
 	mutex_unlock(&data->lock);
 
 	if (error < 0)
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

backlight-new-driver-for-the-adp8870-backlight-devices.patch
backlight-add-backlight-type-fix.patch
linux-next.patch


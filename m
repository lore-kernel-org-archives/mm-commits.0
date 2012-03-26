From: akpm@linux-foundation.org
Subject: [merged] leds-lm3530-support-pwm-input-mode.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:50 -0700
Message-ID: <20120326192950.64C1AA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37807 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:52 -0400
Received: by mail-ey0-f202.google.com with SMTP id q10so289891eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-lm3530: support pwm input mode
has been removed from the -mm tree.  Its filename was
     leds-lm3530-support-pwm-input-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: leds-lm3530: support pwm input mode

* add 'struct lm3530_pwm_data' in the platform data
  The pwm data is the platform specific functions which generate the pwm.
  The pwm data is only valid when brightness is pwm input mode.
  Functions should be implemented by the pwm driver.
  pwm_set_intensity() : set duty of pwm.
  pwm_get_intensity() : get current the brightness.

* brightness control by pwm
  If the control mode is pwm, then brightness is changed by the duty of
  pwm=.  So pwm platform function should be called in lm3530_brightness_set().

* do not update brightness register when pwm input mode
  In pwm input mode, brightness register is not used.
  If any value is updated in this register, then the led will be off.

* when input mode is changed, set duty of pwm to 0 if unnecessary.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |   32 ++++++++++++++++++++++++--------
 include/linux/led-lm3530.h |    9 +++++++++
 2 files changed, 33 insertions(+), 8 deletions(-)

diff -puN drivers/leds/leds-lm3530.c~leds-lm3530-support-pwm-input-mode drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~leds-lm3530-support-pwm-input-mode
+++ a/drivers/leds/leds-lm3530.c
@@ -157,6 +157,7 @@ static int lm3530_init_registers(struct 
 	u32 als_vmin, als_vmax, als_vstep;
 	struct lm3530_platform_data *pltfm = drvdata->pdata;
 	struct i2c_client *client = drvdata->client;
+	struct lm3530_pwm_data *pwm = &pltfm->pwm_data;
 
 	gen_config = (pltfm->brt_ramp_law << LM3530_RAMP_LAW_SHIFT) |
 			((pltfm->max_current & 7) << LM3530_MAX_CURR_SHIFT);
@@ -240,6 +241,15 @@ static int lm3530_init_registers(struct 
 	}
 
 	for (i = 0; i < LM3530_REG_MAX; i++) {
+		/* do not update brightness register when pwm mode */
+		if (lm3530_reg[i] == LM3530_BRT_CTRL_REG &&
+		    drvdata->mode == LM3530_BL_MODE_PWM) {
+			if (pwm->pwm_set_intensity)
+				pwm->pwm_set_intensity(reg_val[i],
+					drvdata->led_dev.max_brightness);
+			continue;
+		}
+
 		ret = i2c_smbus_write_byte_data(client,
 				lm3530_reg[i], reg_val[i]);
 		if (ret)
@@ -255,6 +265,9 @@ static void lm3530_brightness_set(struct
 	int err;
 	struct lm3530_data *drvdata =
 	    container_of(led_cdev, struct lm3530_data, led_dev);
+	struct lm3530_platform_data *pdata = drvdata->pdata;
+	struct lm3530_pwm_data *pwm = &pdata->pwm_data;
+	u8 max_brightness = led_cdev->max_brightness;
 
 	switch (drvdata->mode) {
 	case LM3530_BL_MODE_MANUAL:
@@ -288,6 +301,8 @@ static void lm3530_brightness_set(struct
 	case LM3530_BL_MODE_ALS:
 		break;
 	case LM3530_BL_MODE_PWM:
+		if (pwm->pwm_set_intensity)
+			pwm->pwm_set_intensity(brt_val, max_brightness);
 		break;
 	default:
 		break;
@@ -318,23 +333,24 @@ static ssize_t lm3530_mode_set(struct de
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct lm3530_data *drvdata;
+	struct lm3530_pwm_data *pwm;
+	u8 max_brightness;
 	int mode, err;
 
 	drvdata = container_of(led_cdev, struct lm3530_data, led_dev);
+	pwm = &drvdata->pdata->pwm_data;
+	max_brightness = led_cdev->max_brightness;
 	mode = lm3530_get_mode_from_str(buf);
 	if (mode < 0) {
 		dev_err(dev, "Invalid mode\n");
 		return -EINVAL;
 	}
 
-	if (mode == LM3530_BL_MODE_MANUAL)
-		drvdata->mode = LM3530_BL_MODE_MANUAL;
-	else if (mode == LM3530_BL_MODE_ALS)
-		drvdata->mode = LM3530_BL_MODE_ALS;
-	else if (mode == LM3530_BL_MODE_PWM) {
-		dev_err(dev, "PWM mode not supported\n");
-		return -EINVAL;
-	}
+	drvdata->mode = mode;
+
+	/* set pwm to low if unnecessary */
+	if (mode != LM3530_BL_MODE_PWM && pwm->pwm_set_intensity)
+		pwm->pwm_set_intensity(0, max_brightness);
 
 	err = lm3530_init_registers(drvdata);
 	if (err) {
diff -puN include/linux/led-lm3530.h~leds-lm3530-support-pwm-input-mode include/linux/led-lm3530.h
--- a/include/linux/led-lm3530.h~leds-lm3530-support-pwm-input-mode
+++ a/include/linux/led-lm3530.h
@@ -72,6 +72,12 @@ enum lm3530_als_mode {
 	LM3530_INPUT_CEIL,	/* Max of ALS1 and ALS2 */
 };
 
+/* PWM Platform Specific Data */
+struct lm3530_pwm_data {
+	void (*pwm_set_intensity) (int brightness, int max_brightness);
+	int (*pwm_get_intensity) (int max_brightness);
+};
+
 /**
  * struct lm3530_platform_data
  * @mode: mode of operation i.e. Manual, ALS or PWM
@@ -87,6 +93,7 @@ enum lm3530_als_mode {
  * @als_vmin: als input voltage calibrated for max brightness in mV
  * @als_vmax: als input voltage calibrated for min brightness in mV
  * @brt_val: brightness value (0-255)
+ * @pwm_data: PWM control functions (only valid when the mode is PWM)
  */
 struct lm3530_platform_data {
 	enum lm3530_mode mode;
@@ -107,6 +114,8 @@ struct lm3530_platform_data {
 	u32 als_vmax;
 
 	u8 brt_val;
+
+	struct lm3530_pwm_data pwm_data;
 };
 
 #endif	/* _LINUX_LED_LM3530_H__ */
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch


From: akpm@linux-foundation.org
Subject: [to-be-updated] leds-lm3530-replace-pltfm-with-pdata.patch removed from -mm tree
Date: Tue, 07 Feb 2012 14:55:40 -0800
Message-ID: <20120207225540.80052A035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:60163 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141Ab2BGWzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2012 17:55:41 -0500
Received: by yenm1 with SMTP id m1so165958yen.1
        for <mm-commits@vger.kernel.org>; Tue, 07 Feb 2012 14:55:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, axel.lin@gmail.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-lm3530: replace pltfm with pdata
has been removed from the -mm tree.  Its filename was
     leds-lm3530-replace-pltfm-with-pdata.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: leds-lm3530: replace pltfm with pdata

Use 'pdata' rather than 'pltfm' in lm3530_init_registers().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |   36 +++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN drivers/leds/leds-lm3530.c~leds-lm3530-replace-pltfm-with-pdata drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~leds-lm3530-replace-pltfm-with-pdata
+++ a/drivers/leds/leds-lm3530.c
@@ -153,28 +153,28 @@ static int lm3530_init_registers(struct 
 	u8 reg_val[LM3530_REG_MAX];
 	u8 zones[LM3530_ALS_ZB_MAX];
 	u32 als_vmin, als_vmax, als_vstep;
-	struct lm3530_platform_data *pltfm = drvdata->pdata;
+	struct lm3530_platform_data *pdata = drvdata->pdata;
 	struct i2c_client *client = drvdata->client;
-	struct lm3530_pwm_data *pwm = &pltfm->pwm_data;
+	struct lm3530_pwm_data *pwm = &pdata->pwm_data;
 
-	gen_config = (pltfm->brt_ramp_law << LM3530_RAMP_LAW_SHIFT) |
-			((pltfm->max_current & 7) << LM3530_MAX_CURR_SHIFT);
+	gen_config = (pdata->brt_ramp_law << LM3530_RAMP_LAW_SHIFT) |
+			((pdata->max_current & 7) << LM3530_MAX_CURR_SHIFT);
 
 	if (drvdata->mode == LM3530_BL_MODE_MANUAL ||
 	    drvdata->mode == LM3530_BL_MODE_ALS)
 		gen_config |= (LM3530_ENABLE_I2C);
 
 	if (drvdata->mode == LM3530_BL_MODE_ALS) {
-		if (pltfm->als_vmax == 0) {
-			pltfm->als_vmin = 0;
-			pltfm->als_vmax = LM3530_ALS_WINDOW_mV;
+		if (pdata->als_vmax == 0) {
+			pdata->als_vmin = 0;
+			pdata->als_vmax = LM3530_ALS_WINDOW_mV;
 		}
 
-		als_vmin = pltfm->als_vmin;
-		als_vmax = pltfm->als_vmax;
+		als_vmin = pdata->als_vmin;
+		als_vmax = pdata->als_vmax;
 
 		if ((als_vmax - als_vmin) > LM3530_ALS_WINDOW_mV)
-			pltfm->als_vmax = als_vmax =
+			pdata->als_vmax = als_vmax =
 				als_vmin + LM3530_ALS_WINDOW_mV;
 
 		/* n zone boundary makes n+1 zones */
@@ -186,28 +186,28 @@ static int lm3530_init_registers(struct 
 					/ 1000;
 
 		als_config =
-			(pltfm->als_avrg_time << LM3530_ALS_AVG_TIME_SHIFT) |
+			(pdata->als_avrg_time << LM3530_ALS_AVG_TIME_SHIFT) |
 			(LM3530_ENABLE_ALS) |
-			(pltfm->als_input_mode << LM3530_ALS_SEL_SHIFT);
+			(pdata->als_input_mode << LM3530_ALS_SEL_SHIFT);
 
 		als_imp_sel =
-			(pltfm->als1_resistor_sel << LM3530_ALS1_IMP_SHIFT) |
-			(pltfm->als2_resistor_sel << LM3530_ALS2_IMP_SHIFT);
+			(pdata->als1_resistor_sel << LM3530_ALS1_IMP_SHIFT) |
+			(pdata->als2_resistor_sel << LM3530_ALS2_IMP_SHIFT);
 
 	}
 
 	if (drvdata->mode == LM3530_BL_MODE_PWM)
 		gen_config |= (LM3530_ENABLE_PWM) |
-				(pltfm->pwm_pol_hi << LM3530_PWM_POL_SHIFT) |
+				(pdata->pwm_pol_hi << LM3530_PWM_POL_SHIFT) |
 				(LM3530_ENABLE_PWM_SIMPLE);
 
-	brt_ramp = (pltfm->brt_ramp_fall << LM3530_BRT_RAMP_FALL_SHIFT) |
-			(pltfm->brt_ramp_rise << LM3530_BRT_RAMP_RISE_SHIFT);
+	brt_ramp = (pdata->brt_ramp_fall << LM3530_BRT_RAMP_FALL_SHIFT) |
+			(pdata->brt_ramp_rise << LM3530_BRT_RAMP_RISE_SHIFT);
 
 	if (drvdata->brightness)
 		brightness = drvdata->brightness;
 	else
-		brightness = drvdata->brightness = pltfm->brt_val;
+		brightness = drvdata->brightness = pdata->brt_val;
 
 	if (brightness > drvdata->led_dev.max_brightness)
 		brightness = drvdata->led_dev.max_brightness;
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

backlight-new-backlight-driver-for-lp855x-devices.patch
leds-lp5521-add-name-in-the-lp5521_led_config.patch
leds-lp5521-add-update_config-in-the-lp5521_platform_data.patch
leds-lp5521-support-led-pattern-data.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
leds-lp5521-redefinition-of-register-bits.patch


From: akpm@linux-foundation.org
Subject: + leds-lm3530-simplify-als-configuration-on-initialization.patch added to -mm tree
Date: Fri, 20 Apr 2012 16:12:04 -0700
Message-ID: <20120420231204.67C54A0333@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:65209 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab2DTXMF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 19:12:05 -0400
Received: by yenq2 with SMTP id q2so1162256yen.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 16:12:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, shreshthakumar.sahu@stericsson.com


The patch titled
     Subject: drivers/leds/leds-lm3530.c: simplify als configuration on initialization
has been added to the -mm tree.  Its filename is
     leds-lm3530-simplify-als-configuration-on-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: drivers/leds/leds-lm3530.c: simplify als configuration on initialization

For better code readability, ALS code is moved to new a function -
lm3530_als_configure()

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |  100 ++++++++++++++++++++---------------
 1 file changed, 58 insertions(+), 42 deletions(-)

diff -puN drivers/leds/leds-lm3530.c~leds-lm3530-simplify-als-configuration-on-initialization drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~leds-lm3530-simplify-als-configuration-on-initialization
+++ a/drivers/leds/leds-lm3530.c
@@ -113,6 +113,18 @@ struct lm3530_data {
 	bool enable;
 };
 
+/*
+ * struct lm3530_als_data
+ * @config  : value of ALS configuration register
+ * @imp_sel : value of ALS resistor select register
+ * @zone    : values of ALS ZB(Zone Boundary) registers
+ */
+struct lm3530_als_data {
+	u8 config;
+	u8 imp_sel;
+	u8 zones[LM3530_ALS_ZB_MAX];
+};
+
 static const u8 lm3530_reg[LM3530_REG_MAX] = {
 	LM3530_GEN_CONFIG,
 	LM3530_ALS_CONFIG,
@@ -141,29 +153,65 @@ static int lm3530_get_mode_from_str(cons
 	return -1;
 }
 
+static void lm3530_als_configure(struct lm3530_platform_data *pdata,
+				struct lm3530_als_data *als)
+{
+	int i;
+	u32 als_vmin, als_vmax, als_vstep;
+
+	if (pdata->als_vmax == 0) {
+		pdata->als_vmin = 0;
+		pdata->als_vmax = LM3530_ALS_WINDOW_mV;
+	}
+
+	als_vmin = pdata->als_vmin;
+	als_vmax = pdata->als_vmax;
+
+	if ((als_vmax - als_vmin) > LM3530_ALS_WINDOW_mV)
+		pdata->als_vmax = als_vmax = als_vmin + LM3530_ALS_WINDOW_mV;
+
+	/* n zone boundary makes n+1 zones */
+	als_vstep = (als_vmax - als_vmin) / (LM3530_ALS_ZB_MAX + 1);
+
+	for (i = 0; i < LM3530_ALS_ZB_MAX; i++)
+		als->zones[i] = (((als_vmin + LM3530_ALS_OFFSET_mV) +
+			als_vstep + (i * als_vstep)) * LED_FULL) / 1000;
+
+	als->config =
+		(pdata->als_avrg_time << LM3530_ALS_AVG_TIME_SHIFT) |
+		(LM3530_ENABLE_ALS) |
+		(pdata->als_input_mode << LM3530_ALS_SEL_SHIFT);
+
+	als->imp_sel =
+		(pdata->als1_resistor_sel << LM3530_ALS1_IMP_SHIFT) |
+		(pdata->als2_resistor_sel << LM3530_ALS2_IMP_SHIFT);
+}
+
 static int lm3530_init_registers(struct lm3530_data *drvdata)
 {
 	int ret = 0;
 	int i;
 	u8 gen_config;
-	u8 als_config = 0;
 	u8 brt_ramp;
-	u8 als_imp_sel = 0;
 	u8 brightness;
 	u8 reg_val[LM3530_REG_MAX];
-	u8 zones[LM3530_ALS_ZB_MAX];
-	u32 als_vmin, als_vmax, als_vstep;
 	struct lm3530_platform_data *pdata = drvdata->pdata;
 	struct i2c_client *client = drvdata->client;
 	struct lm3530_pwm_data *pwm = &pdata->pwm_data;
+	struct lm3530_als_data als;
+
+	memset(&als, 0, sizeof(struct lm3530_als_data));
 
 	gen_config = (pdata->brt_ramp_law << LM3530_RAMP_LAW_SHIFT) |
 			((pdata->max_current & 7) << LM3530_MAX_CURR_SHIFT);
 
 	switch (drvdata->mode) {
 	case LM3530_BL_MODE_MANUAL:
+		gen_config |= LM3530_ENABLE_I2C;
+		break;
 	case LM3530_BL_MODE_ALS:
 		gen_config |= LM3530_ENABLE_I2C;
+		lm3530_als_configure(pdata, &als);
 		break;
 	case LM3530_BL_MODE_PWM:
 		gen_config |= LM3530_ENABLE_PWM | LM3530_ENABLE_PWM_SIMPLE |
@@ -171,38 +219,6 @@ static int lm3530_init_registers(struct 
 		break;
 	}
 
-	if (drvdata->mode == LM3530_BL_MODE_ALS) {
-		if (pdata->als_vmax == 0) {
-			pdata->als_vmin = 0;
-			pdata->als_vmax = LM3530_ALS_WINDOW_mV;
-		}
-
-		als_vmin = pdata->als_vmin;
-		als_vmax = pdata->als_vmax;
-
-		if ((als_vmax - als_vmin) > LM3530_ALS_WINDOW_mV)
-			pdata->als_vmax = als_vmax =
-				als_vmin + LM3530_ALS_WINDOW_mV;
-
-		/* n zone boundary makes n+1 zones */
-		als_vstep = (als_vmax - als_vmin) / (LM3530_ALS_ZB_MAX + 1);
-
-		for (i = 0; i < LM3530_ALS_ZB_MAX; i++)
-			zones[i] = (((als_vmin + LM3530_ALS_OFFSET_mV) +
-					als_vstep + (i * als_vstep)) * LED_FULL)
-					/ 1000;
-
-		als_config =
-			(pdata->als_avrg_time << LM3530_ALS_AVG_TIME_SHIFT) |
-			(LM3530_ENABLE_ALS) |
-			(pdata->als_input_mode << LM3530_ALS_SEL_SHIFT);
-
-		als_imp_sel =
-			(pdata->als1_resistor_sel << LM3530_ALS1_IMP_SHIFT) |
-			(pdata->als2_resistor_sel << LM3530_ALS2_IMP_SHIFT);
-
-	}
-
 	brt_ramp = (pdata->brt_ramp_fall << LM3530_BRT_RAMP_FALL_SHIFT) |
 			(pdata->brt_ramp_rise << LM3530_BRT_RAMP_RISE_SHIFT);
 
@@ -215,14 +231,14 @@ static int lm3530_init_registers(struct 
 		brightness = drvdata->led_dev.max_brightness;
 
 	reg_val[0] = gen_config;	/* LM3530_GEN_CONFIG */
-	reg_val[1] = als_config;	/* LM3530_ALS_CONFIG */
+	reg_val[1] = als.config;	/* LM3530_ALS_CONFIG */
 	reg_val[2] = brt_ramp;		/* LM3530_BRT_RAMP_RATE */
-	reg_val[3] = als_imp_sel;	/* LM3530_ALS_IMP_SELECT */
+	reg_val[3] = als.imp_sel;	/* LM3530_ALS_IMP_SELECT */
 	reg_val[4] = brightness;	/* LM3530_BRT_CTRL_REG */
-	reg_val[5] = zones[0];		/* LM3530_ALS_ZB0_REG */
-	reg_val[6] = zones[1];		/* LM3530_ALS_ZB1_REG */
-	reg_val[7] = zones[2];		/* LM3530_ALS_ZB2_REG */
-	reg_val[8] = zones[3];		/* LM3530_ALS_ZB3_REG */
+	reg_val[5] = als.zones[0];	/* LM3530_ALS_ZB0_REG */
+	reg_val[6] = als.zones[1];	/* LM3530_ALS_ZB1_REG */
+	reg_val[7] = als.zones[2];	/* LM3530_ALS_ZB2_REG */
+	reg_val[8] = als.zones[3];	/* LM3530_ALS_ZB3_REG */
 	reg_val[9] = LM3530_DEF_ZT_0;	/* LM3530_ALS_Z0T_REG */
 	reg_val[10] = LM3530_DEF_ZT_1;	/* LM3530_ALS_Z1T_REG */
 	reg_val[11] = LM3530_DEF_ZT_2;	/* LM3530_ALS_Z2T_REG */
_
Subject: Subject: drivers/leds/leds-lm3530.c: simplify als configuration on initialization

Patches currently in -mm which might be from Milo.Kim@ti.com are

drivers-leds-leds-lp5521c-fix-lp5521_read-error-handling.patch
include-linux-led-lm3530h-comment-correction-about-the-range-of-brightness.patch
leds-lm3530-simplify-als-configuration-on-initialization.patch


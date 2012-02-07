From: akpm@linux-foundation.org
Subject: [to-be-updated] leds-lm3530-remove-lm3530_als_zone_reg-code.patch removed from -mm tree
Date: Tue, 07 Feb 2012 14:55:38 -0800
Message-ID: <20120207225538.6843AA035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:43859 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab2BGWzk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2012 17:55:40 -0500
Received: by mail-fx0-f74.google.com with SMTP id a19so981faa.1
        for <mm-commits@vger.kernel.org>; Tue, 07 Feb 2012 14:55:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-lm3530: remove LM3530_ALS_ZONE_REG code
has been removed from the -mm tree.  Its filename was
     leds-lm3530-remove-lm3530_als_zone_reg-code.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: leds-lm3530: remove LM3530_ALS_ZONE_REG code

LM3530_ALS_ZONE_REG is read-only register.
Writing this register is not necessary.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff -puN drivers/leds/leds-lm3530.c~leds-lm3530-remove-lm3530_als_zone_reg-code drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~leds-lm3530-remove-lm3530_als_zone_reg-code
+++ a/drivers/leds/leds-lm3530.c
@@ -26,7 +26,6 @@
 #define LM3530_GEN_CONFIG		0x10
 #define LM3530_ALS_CONFIG		0x20
 #define LM3530_BRT_RAMP_RATE		0x30
-#define LM3530_ALS_ZONE_REG		0x40
 #define LM3530_ALS_IMP_SELECT		0x41
 #define LM3530_BRT_CTRL_REG		0xA0
 #define LM3530_ALS_ZB0_REG		0x60
@@ -38,7 +37,7 @@
 #define LM3530_ALS_Z2T_REG		0x72
 #define LM3530_ALS_Z3T_REG		0x73
 #define LM3530_ALS_Z4T_REG		0x74
-#define LM3530_REG_MAX			15
+#define LM3530_REG_MAX			14
 
 /* General Control Register */
 #define LM3530_EN_I2C_SHIFT		(0)
@@ -118,7 +117,6 @@ static const u8 lm3530_reg[LM3530_REG_MA
 	LM3530_GEN_CONFIG,
 	LM3530_ALS_CONFIG,
 	LM3530_BRT_RAMP_RATE,
-	LM3530_ALS_ZONE_REG,
 	LM3530_ALS_IMP_SELECT,
 	LM3530_BRT_CTRL_REG,
 	LM3530_ALS_ZB0_REG,
@@ -217,18 +215,17 @@ static int lm3530_init_registers(struct 
 	reg_val[0] = gen_config;	/* LM3530_GEN_CONFIG */
 	reg_val[1] = als_config;	/* LM3530_ALS_CONFIG */
 	reg_val[2] = brt_ramp;		/* LM3530_BRT_RAMP_RATE */
-	reg_val[3] = 0x00;		/* LM3530_ALS_ZONE_REG */
-	reg_val[4] = als_imp_sel;	/* LM3530_ALS_IMP_SELECT */
-	reg_val[5] = brightness;	/* LM3530_BRT_CTRL_REG */
-	reg_val[6] = zones[0];		/* LM3530_ALS_ZB0_REG */
-	reg_val[7] = zones[1];		/* LM3530_ALS_ZB1_REG */
-	reg_val[8] = zones[2];		/* LM3530_ALS_ZB2_REG */
-	reg_val[9] = zones[3];		/* LM3530_ALS_ZB3_REG */
-	reg_val[10] = LM3530_DEF_ZT_0;	/* LM3530_ALS_Z0T_REG */
-	reg_val[11] = LM3530_DEF_ZT_1;	/* LM3530_ALS_Z1T_REG */
-	reg_val[12] = LM3530_DEF_ZT_2;	/* LM3530_ALS_Z2T_REG */
-	reg_val[13] = LM3530_DEF_ZT_3;	/* LM3530_ALS_Z3T_REG */
-	reg_val[14] = LM3530_DEF_ZT_4;	/* LM3530_ALS_Z4T_REG */
+	reg_val[3] = als_imp_sel;	/* LM3530_ALS_IMP_SELECT */
+	reg_val[4] = brightness;	/* LM3530_BRT_CTRL_REG */
+	reg_val[5] = zones[0];		/* LM3530_ALS_ZB0_REG */
+	reg_val[6] = zones[1];		/* LM3530_ALS_ZB1_REG */
+	reg_val[7] = zones[2];		/* LM3530_ALS_ZB2_REG */
+	reg_val[8] = zones[3];		/* LM3530_ALS_ZB3_REG */
+	reg_val[9] = LM3530_DEF_ZT_0;	/* LM3530_ALS_Z0T_REG */
+	reg_val[10] = LM3530_DEF_ZT_1;	/* LM3530_ALS_Z1T_REG */
+	reg_val[11] = LM3530_DEF_ZT_2;	/* LM3530_ALS_Z2T_REG */
+	reg_val[12] = LM3530_DEF_ZT_3;	/* LM3530_ALS_Z3T_REG */
+	reg_val[13] = LM3530_DEF_ZT_4;	/* LM3530_ALS_Z4T_REG */
 
 	if (!drvdata->enable) {
 		ret = regulator_enable(drvdata->regulator);
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

backlight-new-backlight-driver-for-lp855x-devices.patch
leds-lp5521-add-name-in-the-lp5521_led_config.patch
leds-lp5521-add-update_config-in-the-lp5521_platform_data.patch
leds-lp5521-support-led-pattern-data.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
leds-lp5521-redefinition-of-register-bits.patch
leds-lm3530-replace-pltfm-with-pdata.patch


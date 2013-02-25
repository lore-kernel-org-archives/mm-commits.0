From: akpm@linux-foundation.org
Subject: + backlight-add-new-lp8788-backlight-driver-v3.patch added to -mm tree
Date: Mon, 25 Feb 2013 14:33:44 -0800
Message-ID: <20130225223344.D97EB31C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:51121 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759890Ab3BYWdq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 17:33:46 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so361578ghb.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 14:33:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, devendra.aaru@gmail.com, milo.kim@ti.com, rpurdie@rpsys.net, sameo@linux.intel.com, thierry.reding@avionic-design.de


The patch titled
     Subject: backlight-add-new-lp8788-backlight-driver-v3
has been added to the -mm tree.  Its filename is
     backlight-add-new-lp8788-backlight-driver-v3.patch

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
Subject: backlight-add-new-lp8788-backlight-driver-v3

 Use generic PWM polarity enum type instead of LP8788 private data type.
   : 'lp8788_bl_pwm_polartiy' is replaced with 'pwm_polarity' enum type.
 Relocate the register description.
 Use prefix, '_SHIFT' for the bit shift arithmetic of the registers.
 Fix wrong coding style on comment.
 Use capital letters for PWM description except the code.
 Use PAGE_SIZE on the sysfs read operation.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: "devendra.aaru" <devendra.aaru@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp8788_bl.c |   83 ++++++++++----------------
 include/linux/mfd/lp8788.h          |    8 --
 2 files changed, 35 insertions(+), 56 deletions(-)

diff -puN drivers/video/backlight/lp8788_bl.c~backlight-add-new-lp8788-backlight-driver-v3 drivers/video/backlight/lp8788_bl.c
--- a/drivers/video/backlight/lp8788_bl.c~backlight-add-new-lp8788-backlight-driver-v3
+++ a/drivers/video/backlight/lp8788_bl.c
@@ -19,20 +19,19 @@
 #include <linux/pwm.h>
 #include <linux/slab.h>
 
-/* register address */
+/* Register address */
 #define LP8788_BL_CONFIG		0x96
+#define LP8788_BL_EN			BIT(0)
+#define LP8788_BL_PWM_INPUT_EN		BIT(5)
+#define LP8788_BL_FULLSCALE_SHIFT	2
+#define LP8788_BL_DIM_MODE_SHIFT	1
+#define LP8788_BL_PWM_POLARITY_SHIFT	6
+
 #define LP8788_BL_BRIGHTNESS		0x97
-#define LP8788_BL_RAMP			0x98
 
-/* mask/shift bits */
-#define LP8788_BL_EN			BIT(0)	/* Addr 96h */
-#define LP8788_BL_PWM_EN		BIT(5)
-#define LP8788_BL_FULLSCALE_S		2
-#define LP8788_BL_DIM_MODE_S		1
-#define LP8788_BL_PWM_POLARITY_S	6
-#define LP8788_BL_RAMP_RISE_S		4	/* Addr 98h */
+#define LP8788_BL_RAMP			0x98
+#define LP8788_BL_RAMP_RISE_SHIFT	4
 
-#define BUF_SIZE			20
 #define MAX_BRIGHTNESS			127
 #define DEFAULT_BL_NAME			"lcd-backlight"
 
@@ -42,7 +41,7 @@ struct lp8788_bl_config {
 	enum lp8788_bl_full_scale_current full_scale;
 	enum lp8788_bl_ramp_step rise_time;
 	enum lp8788_bl_ramp_step fall_time;
-	enum lp8788_bl_pwm_polarity pwm_pol;
+	enum pwm_polarity pwm_pol;
 };
 
 struct lp8788_bl {
@@ -59,7 +58,7 @@ struct lp8788_bl_config default_bl_confi
 	.full_scale = LP8788_FULLSCALE_1900uA,
 	.rise_time  = LP8788_RAMP_8192us,
 	.fall_time  = LP8788_RAMP_8192us,
-	.pwm_pol    = LP8788_PWM_ACTIVE_HIGH,
+	.pwm_pol    = PWM_POLARITY_NORMAL,
 };
 
 static inline bool is_brightness_ctrl_by_pwm(enum lp8788_bl_ctrl_mode mode)
@@ -80,8 +79,10 @@ static int lp8788_backlight_configure(st
 	int ret;
 	u8 val;
 
-	/* update chip configuration if platform data exists,
-	   otherwise use the default settings */
+	/*
+	 * Update chip configuration if platform data exists,
+	 * otherwise use the default settings.
+	 */
 	if (pdata) {
 		cfg->bl_mode    = pdata->bl_mode;
 		cfg->dim_mode   = pdata->dim_mode;
@@ -91,30 +92,25 @@ static int lp8788_backlight_configure(st
 		cfg->pwm_pol    = pdata->pwm_pol;
 	}
 
-	/* brightness ramp up/down */
-	val = (cfg->rise_time << LP8788_BL_RAMP_RISE_S) | cfg->fall_time;
+	/* Brightness ramp up/down */
+	val = (cfg->rise_time << LP8788_BL_RAMP_RISE_SHIFT) | cfg->fall_time;
 	ret = lp8788_write_byte(bl->lp, LP8788_BL_RAMP, val);
-	if (ret) {
-		/* no I2C needed in case of pwm control mode */
-		if (is_brightness_ctrl_by_pwm(cfg->bl_mode))
-			goto no_err;
-		else
-			return ret;
-	}
+	if (ret)
+		return ret;
 
-	/* fullscale current setting */
-	val = (cfg->full_scale << LP8788_BL_FULLSCALE_S) |
-		(cfg->dim_mode << LP8788_BL_DIM_MODE_S);
+	/* Fullscale current setting */
+	val = (cfg->full_scale << LP8788_BL_FULLSCALE_SHIFT) |
+		(cfg->dim_mode << LP8788_BL_DIM_MODE_SHIFT);
 
-	/* brightness control mode */
+	/* Brightness control mode */
 	switch (cfg->bl_mode) {
 	case LP8788_BL_REGISTER_ONLY:
 		val |= LP8788_BL_EN;
 		break;
 	case LP8788_BL_COMB_PWM_BASED:
 	case LP8788_BL_COMB_REGISTER_BASED:
-		val |= LP8788_BL_EN | LP8788_BL_PWM_EN |
-			(cfg->pwm_pol << LP8788_BL_PWM_POLARITY_S);
+		val |= LP8788_BL_EN | LP8788_BL_PWM_INPUT_EN |
+			(cfg->pwm_pol << LP8788_BL_PWM_POLARITY_SHIFT);
 		break;
 	default:
 		dev_err(bl->lp->dev, "invalid mode: %d\n", cfg->bl_mode);
@@ -124,9 +120,6 @@ static int lp8788_backlight_configure(st
 	bl->mode = cfg->bl_mode;
 
 	return lp8788_write_byte(bl->lp, LP8788_BL_CONFIG, val);
-
-no_err:
-	return 0;
 }
 
 static void lp8788_pwm_ctrl(struct lp8788_bl *bl, int br, int max_br)
@@ -143,11 +136,11 @@ static void lp8788_pwm_ctrl(struct lp878
 	duty = br * period / max_br;
 	dev = bl->lp->dev;
 
-	/* request pwm device with the consumer name */
+	/* request PWM device with the consumer name */
 	if (!bl->pwm) {
 		pwm = devm_pwm_get(dev, LP8788_DEV_BACKLIGHT);
 		if (IS_ERR(pwm)) {
-			dev_err(dev, "can not get pwm device\n");
+			dev_err(dev, "can not get PWM device\n");
 			return;
 		}
 
@@ -185,16 +178,6 @@ static int lp8788_bl_update_status(struc
 
 static int lp8788_bl_get_brightness(struct backlight_device *bl_dev)
 {
-	struct lp8788_bl *bl = bl_get_data(bl_dev);
-	enum lp8788_bl_ctrl_mode mode = bl->mode;
-
-	if (is_brightness_ctrl_by_register(mode)) {
-		u8 val = 0;
-
-		lp8788_read_byte(bl->lp, LP8788_BL_BRIGHTNESS, &val);
-		bl_dev->props.brightness = val;
-	}
-
 	return bl_dev->props.brightness;
 }
 
@@ -215,7 +198,7 @@ static int lp8788_backlight_register(str
 	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = MAX_BRIGHTNESS;
 
-	/* initial brightness */
+	/* Initial brightness */
 	if (pdata)
 		init_brt = min_t(int, pdata->initial_brightness,
 				props.max_brightness);
@@ -224,7 +207,7 @@ static int lp8788_backlight_register(str
 
 	props.brightness = init_brt;
 
-	/* backlight device name */
+	/* Backlight device name */
 	if (!pdata || !pdata->name)
 		name = DEFAULT_BL_NAME;
 	else
@@ -256,13 +239,13 @@ static ssize_t lp8788_get_bl_ctl_mode(st
 	char *strmode;
 
 	if (is_brightness_ctrl_by_pwm(mode))
-		strmode = "pwm based";
+		strmode = "PWM based";
 	else if (is_brightness_ctrl_by_register(mode))
-		strmode = "register based";
+		strmode = "Register based";
 	else
-		strmode = "invalid mode";
+		strmode = "Invalid mode";
 
-	return scnprintf(buf, BUF_SIZE, "%s\n", strmode);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", strmode);
 }
 
 static DEVICE_ATTR(bl_ctl_mode, S_IRUGO, lp8788_get_bl_ctl_mode, NULL);
diff -puN include/linux/mfd/lp8788.h~backlight-add-new-lp8788-backlight-driver-v3 include/linux/mfd/lp8788.h
--- a/include/linux/mfd/lp8788.h~backlight-add-new-lp8788-backlight-driver-v3
+++ a/include/linux/mfd/lp8788.h
@@ -16,6 +16,7 @@
 
 #include <linux/gpio.h>
 #include <linux/irqdomain.h>
+#include <linux/pwm.h>
 #include <linux/regmap.h>
 
 #define LP8788_DEV_BUCK		"lp8788-buck"
@@ -124,11 +125,6 @@ enum lp8788_bl_ramp_step {
 	LP8788_RAMP_65538us,
 };
 
-enum lp8788_bl_pwm_polarity {
-	LP8788_PWM_ACTIVE_HIGH,
-	LP8788_PWM_ACTIVE_LOW,
-};

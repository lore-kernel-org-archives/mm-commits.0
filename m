From: akpm@linux-foundation.org
Subject: + backlight-lp855x-move-backlight-mode-platform-data.patch added to -mm tree
Date: Mon, 22 Apr 2013 15:47:16 -0700
Message-ID: <20130422224716.A70565A4219@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:35532 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3DVWrR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 18:47:17 -0400
Received: by mail-yh0-f73.google.com with SMTP id i21so753691yha.2
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 15:47:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, milo.kim@ti.com


The patch titled
     Subject: backlight: lp855x: move backlight mode platform data
has been added to the -mm tree.  Its filename is
     backlight-lp855x-move-backlight-mode-platform-data.patch

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
Subject: backlight: lp855x: move backlight mode platform data

The brightness of LP855x devices is controlled by I2C register or PWM
input .  This mode was selected through the platform data, but it can be
chosen by the driver internally without platform data configuration.

How to decide the control mode:
  If the PWM period has specific value, the mode is PWM input.
  On the other hand, the mode is register-based.
  This mode selection is done on the _probe().

Move 'mode' from a header file to the driver private data structure,
'lp855 x'.  And correlated code was replaced.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/backlight/lp855x-driver.txt |    3 --
 drivers/video/backlight/lp855x_bl.c       |   21 ++++++++++++++------
 include/linux/platform_data/lp855x.h      |    7 ------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff -puN Documentation/backlight/lp855x-driver.txt~backlight-lp855x-move-backlight-mode-platform-data Documentation/backlight/lp855x-driver.txt
--- a/Documentation/backlight/lp855x-driver.txt~backlight-lp855x-move-backlight-mode-platform-data
+++ a/Documentation/backlight/lp855x-driver.txt
@@ -32,7 +32,6 @@ Platform data for lp855x
 For supporting platform specific data, the lp855x platform data can be used.
 
 * name : Backlight driver name. If it is not defined, default name is set.
-* mode : Brightness control mode. PWM or register based.
 * device_control : Value of DEVICE CONTROL register.
 * initial_brightness : Initial value of backlight brightness.
 * period_ns : Platform specific PWM period value. unit is nano.
@@ -54,7 +53,6 @@ static struct lp855x_rom_data lp8552_eep
 
 static struct lp855x_platform_data lp8552_pdata = {
 	.name = "lcd-bl",
-	.mode = REGISTER_BASED,
 	.device_control = I2C_CONFIG(LP8552),
 	.initial_brightness = INITIAL_BRT,
 	.load_new_rom_data = 1,
@@ -65,7 +63,6 @@ static struct lp855x_platform_data lp855
 example 2) lp8556 platform data : pwm input mode with default rom data
 
 static struct lp855x_platform_data lp8556_pdata = {
-	.mode = PWM_BASED,
 	.device_control = PWM_CONFIG(LP8556),
 	.initial_brightness = INITIAL_BRT,
 	.period_ns = 1000000,
diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x-move-backlight-mode-platform-data drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x-move-backlight-mode-platform-data
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -38,6 +38,11 @@
 #define DEFAULT_BL_NAME		"lcd-backlight"
 #define MAX_BRIGHTNESS		255
 
+enum lp855x_brightness_ctrl_mode {
+	PWM_BASED = 1,
+	REGISTER_BASED,
+};
+
 struct lp855x;
 
 /*
@@ -57,6 +62,7 @@ struct lp855x_device_config {
 struct lp855x {
 	const char *chipname;
 	enum lp855x_chip_id chip_id;
+	enum lp855x_brightness_ctrl_mode mode;
 	struct lp855x_device_config *cfg;
 	struct i2c_client *client;
 	struct backlight_device *bl;
@@ -238,18 +244,17 @@ static void lp855x_pwm_ctrl(struct lp855
 static int lp855x_bl_update_status(struct backlight_device *bl)
 {
 	struct lp855x *lp = bl_get_data(bl);
-	enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
 
 	if (bl->props.state & BL_CORE_SUSPENDED)
 		bl->props.brightness = 0;
 
-	if (mode == PWM_BASED) {
+	if (lp->mode == PWM_BASED) {
 		int br = bl->props.brightness;
 		int max_br = bl->props.max_brightness;
 
 		lp855x_pwm_ctrl(lp, br, max_br);
 
-	} else if (mode == REGISTER_BASED) {
+	} else if (lp->mode == REGISTER_BASED) {
 		u8 val = bl->props.brightness;
 		lp855x_write_byte(lp, lp->cfg->reg_brightness, val);
 	}
@@ -310,12 +315,11 @@ static ssize_t lp855x_get_bl_ctl_mode(st
 				     struct device_attribute *attr, char *buf)
 {
 	struct lp855x *lp = dev_get_drvdata(dev);
-	enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
 	char *strmode = NULL;
 
-	if (mode == PWM_BASED)
+	if (lp->mode == PWM_BASED)
 		strmode = "pwm based";
-	else if (mode == REGISTER_BASED)
+	else if (lp->mode == REGISTER_BASED)
 		strmode = "register based";
 
 	return scnprintf(buf, PAGE_SIZE, "%s\n", strmode);
@@ -352,6 +356,11 @@ static int lp855x_probe(struct i2c_clien
 	if (!lp)
 		return -ENOMEM;
 
+	if (pdata->period_ns > 0)
+		lp->mode = PWM_BASED;
+	else
+		lp->mode = REGISTER_BASED;
+
 	lp->client = cl;
 	lp->dev = &cl->dev;
 	lp->pdata = pdata;
diff -puN include/linux/platform_data/lp855x.h~backlight-lp855x-move-backlight-mode-platform-data include/linux/platform_data/lp855x.h
--- a/include/linux/platform_data/lp855x.h~backlight-lp855x-move-backlight-mode-platform-data
+++ a/include/linux/platform_data/lp855x.h
@@ -69,11 +69,6 @@ enum lp855x_chip_id {
 	LP8557,
 };
 
-enum lp855x_brightness_ctrl_mode {
-	PWM_BASED = 1,
-	REGISTER_BASED,
-};
-
 enum lp8550_brighntess_source {
 	LP8550_PWM_ONLY,
 	LP8550_I2C_ONLY = 2,
@@ -116,7 +111,6 @@ struct lp855x_rom_data {
 /**
  * struct lp855x_platform_data
  * @name : Backlight driver name. If it is not defined, default name is set.
- * @mode : brightness control by pwm or lp855x register
  * @device_control : value of DEVICE CONTROL register
  * @initial_brightness : initial value of backlight brightness
  * @period_ns : platform specific pwm period value. unit is nano.
@@ -129,7 +123,6 @@ struct lp855x_rom_data {
  */
 struct lp855x_platform_data {
 	const char *name;
-	enum lp855x_brightness_ctrl_mode mode;
 	u8 device_control;
 	int initial_brightness;
 	unsigned int period_ns;
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

linux-next.patch
backlight-lp855x-use-page_size-for-the-sysfs-read-operation.patch
backlight-lp855x-convert-a-type-of-device-name.patch
backlight-lp855x-move-backlight-mode-platform-data.patch
backlight-lp855x-fix-initial-brightness-type.patch
backlight-lp855x-remove-duplicate-platform-data.patch
backlight-lp855x-add-a-device-tree-structure.patch


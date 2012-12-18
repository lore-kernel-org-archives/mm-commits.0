From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:57 -0800
Message-ID: <20121218200458.2F75020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:33850 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUFB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:01 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so63381eaa.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, bryan.wu@canonical.com, milo.kim@ti.com, rpurdie@rpsys.net, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/lp855x_bl.c: use generic PWM functions
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: drivers/video/backlight/lp855x_bl.c: use generic PWM functions

The LP855x family devices support the PWM input for the backlight control.
 Period of the PWM is configurable in the platform side.  Platform
specific functions are unnecessary anymore because generic PWM functions
are used inside the driver.

(PWM input mode)
To set the brightness, new lp855x_pwm_ctrl() is used.
If a PWM device is not allocated, devm_pwm_get() is called.
The PWM consumer name is from the chip name such as 'lp8550' and 'lp8556'.
To get the brightness value, no additional handling is required.
Just the value of 'props.brightness' is returned.

If the PWM driver is not ready while initializing the LP855x driver, it's
OK.  The PWM device can be retrieved later, when the brightness value is
changed.

Documentation is updated with an example.

[akpm@linux-foundation.org: coding-style simplification, per Thierry]
Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/backlight/lp855x-driver.txt |   10 +----
 drivers/video/backlight/lp855x_bl.c       |   37 ++++++++++++++------
 include/linux/platform_data/lp855x.h      |    9 +---
 3 files changed, 30 insertions(+), 26 deletions(-)

diff -puN Documentation/backlight/lp855x-driver.txt~drivers-video-backlight-lp855x_blc-use-generic-pwm-functions Documentation/backlight/lp855x-driver.txt
--- a/Documentation/backlight/lp855x-driver.txt~drivers-video-backlight-lp855x_blc-use-generic-pwm-functions
+++ a/Documentation/backlight/lp855x-driver.txt
@@ -35,11 +35,8 @@ For supporting platform specific data, t
 * mode : Brightness control mode. PWM or register based.
 * device_control : Value of DEVICE CONTROL register.
 * initial_brightness : Initial value of backlight brightness.
-* pwm_data : Platform specific pwm generation functions.
+* period_ns : Platform specific PWM period value. unit is nano.
 	     Only valid when brightness is pwm input mode.
-	     Functions should be implemented by PWM driver.
-	     - pwm_set_intensity() : set duty of PWM
-	     - pwm_get_intensity() : get current duty of PWM
 * load_new_rom_data :
 	0 : use default configuration data
 	1 : update values of eeprom or eprom registers on loading driver
@@ -71,8 +68,5 @@ static struct lp855x_platform_data lp855
 	.mode = PWM_BASED,
 	.device_control = PWM_CONFIG(LP8556),
 	.initial_brightness = INITIAL_BRT,
-	.pwm_data = {
-		     .pwm_set_intensity = platform_pwm_set_intensity,
-		     .pwm_get_intensity = platform_pwm_get_intensity,
-		     },
+	.period_ns = 1000000,
 };
diff -puN drivers/video/backlight/lp855x_bl.c~drivers-video-backlight-lp855x_blc-use-generic-pwm-functions drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~drivers-video-backlight-lp855x_blc-use-generic-pwm-functions
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -15,6 +15,7 @@
 #include <linux/backlight.h>
 #include <linux/err.h>
 #include <linux/platform_data/lp855x.h>
+#include <linux/pwm.h>
 
 /* Registers */
 #define BRIGHTNESS_CTRL		0x00
@@ -36,6 +37,7 @@ struct lp855x {
 	struct device *dev;
 	struct mutex xfer_lock;
 	struct lp855x_platform_data *pdata;
+	struct pwm_device *pwm;
 };
 
 static int lp855x_read_byte(struct lp855x *lp, u8 reg, u8 *data)
@@ -121,6 +123,28 @@ static int lp855x_init_registers(struct 
 	return ret;
 }
 
+static void lp855x_pwm_ctrl(struct lp855x *lp, int br, int max_br)
+{
+	unsigned int period = lp->pdata->period_ns;
+	unsigned int duty = br * period / max_br;
+	struct pwm_device *pwm;
+
+	/* request pwm device with the consumer name */
+	if (!lp->pwm) {
+		pwm = devm_pwm_get(lp->dev, lp->chipname);
+		if (IS_ERR(pwm))
+			return;
+
+		lp->pwm = pwm;
+	}
+
+	pwm_config(lp->pwm, duty, period);
+	if (duty)
+		pwm_enable(lp->pwm);
+	else
+		pwm_disable(lp->pwm);
+}
+
 static int lp855x_bl_update_status(struct backlight_device *bl)
 {
 	struct lp855x *lp = bl_get_data(bl);
@@ -130,12 +154,10 @@ static int lp855x_bl_update_status(struc
 		bl->props.brightness = 0;
 
 	if (mode == PWM_BASED) {
-		struct lp855x_pwm_data *pd = &lp->pdata->pwm_data;
 		int br = bl->props.brightness;
 		int max_br = bl->props.max_brightness;
 
-		if (pd->pwm_set_intensity)
-			pd->pwm_set_intensity(br, max_br);
+		lp855x_pwm_ctrl(lp, br, max_br);
 
 	} else if (mode == REGISTER_BASED) {
 		u8 val = bl->props.brightness;
@@ -150,14 +172,7 @@ static int lp855x_bl_get_brightness(stru
 	struct lp855x *lp = bl_get_data(bl);
 	enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
 
-	if (mode == PWM_BASED) {
-		struct lp855x_pwm_data *pd = &lp->pdata->pwm_data;
-		int max_br = bl->props.max_brightness;
-
-		if (pd->pwm_get_intensity)
-			bl->props.brightness = pd->pwm_get_intensity(max_br);
-
-	} else if (mode == REGISTER_BASED) {
+	if (mode == REGISTER_BASED) {
 		u8 val = 0;
 
 		lp855x_read_byte(lp, BRIGHTNESS_CTRL, &val);
diff -puN include/linux/platform_data/lp855x.h~drivers-video-backlight-lp855x_blc-use-generic-pwm-functions include/linux/platform_data/lp855x.h
--- a/include/linux/platform_data/lp855x.h~drivers-video-backlight-lp855x_blc-use-generic-pwm-functions
+++ a/include/linux/platform_data/lp855x.h
@@ -89,11 +89,6 @@ enum lp8556_brightness_source {
 	LP8556_COMBINED2,	/* pwm + i2c after the shaper block */
 };
 
-struct lp855x_pwm_data {
-	void (*pwm_set_intensity) (int brightness, int max_brightness);
-	int (*pwm_get_intensity) (int max_brightness);
-};
-
 struct lp855x_rom_data {
 	u8 addr;
 	u8 val;
@@ -105,7 +100,7 @@ struct lp855x_rom_data {
  * @mode : brightness control by pwm or lp855x register
  * @device_control : value of DEVICE CONTROL register
  * @initial_brightness : initial value of backlight brightness
- * @pwm_data : platform specific pwm generation functions.
+ * @period_ns : platform specific pwm period value. unit is nano.
 		Only valid when mode is PWM_BASED.
  * @load_new_rom_data :
 	0 : use default configuration data
@@ -118,7 +113,7 @@ struct lp855x_platform_data {
 	enum lp855x_brightness_ctrl_mode mode;
 	u8 device_control;
 	int initial_brightness;
-	struct lp855x_pwm_data pwm_data;
+	unsigned int period_ns;
 	u8 load_new_rom_data;
 	int size_program;
 	struct lp855x_rom_data *rom_data;
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch


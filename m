From: akpm@linux-foundation.org
Subject: [folded] lp855x-bl-remove-unnecessary-platform-data.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:34:49 -0700
Message-ID: <20120323213449.EC673A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:64046 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab2CWVev (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:34:51 -0400
Received: by vbnl22 with SMTP id l22so301923vbn.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:34:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, axel.lin@gmail.com, milo.kim@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lp855x-bl: remove unnecessary platform data
has been removed from the -mm tree.  Its filename was
     lp855x-bl-remove-unnecessary-platform-data.patch

This patch was dropped because it was folded into backlight-new-backlight-driver-for-lp855x-devices.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: lp855x-bl: remove unnecessary platform data

All lp855x devices have 8-bits brightness contorl register.  The value of
max_brightness is set to 255.  So the max_brightness in the platform data
is unnecessary.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/backlight/lp855x-driver.txt |    3 ---
 drivers/video/backlight/lp855x_bl.c       |   11 +++++++----
 include/linux/lp855x.h                    |    2 --
 3 files changed, 7 insertions(+), 9 deletions(-)

diff -puN Documentation/backlight/lp855x-driver.txt~lp855x-bl-remove-unnecessary-platform-data Documentation/backlight/lp855x-driver.txt
--- a/Documentation/backlight/lp855x-driver.txt~lp855x-bl-remove-unnecessary-platform-data
+++ a/Documentation/backlight/lp855x-driver.txt
@@ -35,7 +35,6 @@ For supporting platform specific data, t
 * mode : Brightness control mode. PWM or register based.
 * device_control : Value of DEVICE CONTROL register.
 * initial_brightness : Initial value of backlight brightness.
-* max_brightness : Maximum value of backlight brightness.
 * pwm_data : Platform specific pwm generation functions.
 	     Only valid when brightness is pwm input mode.
 	     Functions should be implemented by PWM driver.
@@ -61,7 +60,6 @@ static struct lp855x_platform_data lp855
 	.mode = REGISTER_BASED,
 	.device_control = I2C_CONFIG(LP8552),
 	.initial_brightness = INITIAL_BRT,
-	.max_brightness = MAX_BRT,
 	.load_new_rom_data = 1,
 	.size_program = ARRAY_SIZE(lp8552_eeprom_arr),
 	.rom_data = lp8552_eeprom_arr,
@@ -73,7 +71,6 @@ static struct lp855x_platform_data lp855
 	.mode = PWM_BASED,
 	.device_control = PWM_CONFIG(LP8556),
 	.initial_brightness = INITIAL_BRT,
-	.max_brightness = MAX_BRT,
 	.pwm_data = {
 		     .pwm_set_intensity = platform_pwm_set_intensity,
 		     .pwm_get_intensity = platform_pwm_get_intensity,
diff -puN drivers/video/backlight/lp855x_bl.c~lp855x-bl-remove-unnecessary-platform-data drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~lp855x-bl-remove-unnecessary-platform-data
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -22,8 +22,9 @@
 #define BRIGHTNESS_CTRL		(0x00)
 #define DEVICE_CTRL		(0x01)
 
-#define BUF_SIZE		(20)
+#define BUF_SIZE		20
 #define DEFAULT_BL_NAME		"lcd-backlight"
+#define MAX_BRIGHTNESS		255
 
 struct lp855x {
 	const char *chipid;
@@ -171,10 +172,12 @@ static int lp855x_backlight_register(str
 	char *name = pdata->name ? : DEFAULT_BL_NAME;
 
 	props.type = BACKLIGHT_PLATFORM;
+	props.max_brightness = MAX_BRIGHTNESS;
+
+	if (pdata->initial_brightness > props.max_brightness)
+		pdata->initial_brightness = props.max_brightness;
+
 	props.brightness = pdata->initial_brightness;
-	props.max_brightness =
-		(pdata->max_brightness < pdata->initial_brightness) ?
-		255 : pdata->max_brightness;
 
 	bl = backlight_device_register(name, lp->dev, lp,
 				       &lp855x_bl_ops, &props);
diff -puN include/linux/lp855x.h~lp855x-bl-remove-unnecessary-platform-data include/linux/lp855x.h
--- a/include/linux/lp855x.h~lp855x-bl-remove-unnecessary-platform-data
+++ a/include/linux/lp855x.h
@@ -109,7 +109,6 @@ struct lp855x_rom_data {
  * @mode : brightness control by pwm or lp855x register
  * @device_control : value of DEVICE CONTROL register
  * @initial_brightness : initial value of backlight brightness
- * @max_brightness : maximum value of backlight brightness
  * @pwm_data : platform specific pwm generation functions.
 		Only valid when mode is PWM_BASED.
  * @load_new_rom_data :
@@ -123,7 +122,6 @@ struct lp855x_platform_data {
 	enum lp855x_brightness_ctrl_mode mode;
 	u8 device_control;
 	int initial_brightness;
-	int max_brightness;
 	struct lp855x_pwm_data pwm_data;
 	u8 load_new_rom_data;
 	int size_program;
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch
backlight-new-backlight-driver-for-lp855x-devices.patch
lp855x-bl-remove-unnecessary-headers.patch
leds-lp5521-add-name-in-the-lp5521_led_config.patch
leds-lp5521-add-update_config-in-the-lp5521_platform_data.patch
leds-lp5521-support-led-pattern-data.patch
leds-lp5521-redefinition-of-register-bits.patch
leds-lm3530-set-the-max_brightness-to-127.patch
leds-lm3530-replace-i2c_client-with-led_classdev.patch
leds-lm3530-support-pwm-input-mode.patch
leds-lm3530-remove-lm3530_als_zone_reg-code.patch
leds-lm3530-replace-pltfm-with-pdata.patch


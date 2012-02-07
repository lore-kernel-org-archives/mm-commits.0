From: akpm@linux-foundation.org
Subject: + leds-lm3530-set-the-max_brightness-to-127.patch added to -mm tree
Date: Tue, 07 Feb 2012 12:53:46 -0800
Message-ID: <20120207205347.33BB1A035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:58011 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533Ab2BGUxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2012 15:53:48 -0500
Received: by ggnp1 with SMTP id p1so734433ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 07 Feb 2012 12:53:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net


The patch titled
     Subject: leds-lm3530: set the max_brightness to 127
has been added to the -mm tree.  Its filename is
     leds-lm3530-set-the-max_brightness-to-127.patch

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
Subject: leds-lm3530: set the max_brightness to 127

Only 7 bits are used for updating the brightness.  (register address :
A0h) So the max_brightness property of lm3530 should be set to 127.

On initializing registers, maximum initial brightness is limited to
'max_brightness'.

Division-by-two is removed on updating the brightness.  This arithmetic is
not necessary because the range of brightness is 0 ~ 127= .

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN drivers/leds/leds-lm3530.c~leds-lm3530-set-the-max_brightness-to-127 drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~leds-lm3530-set-the-max_brightness-to-127
+++ a/drivers/leds/leds-lm3530.c
@@ -80,6 +80,9 @@
 #define LM3530_DEF_ZT_3			(0x33)
 #define LM3530_DEF_ZT_4			(0x19)
 
+/* 7 bits are used for the brightness : LM3530_BRT_CTRL_REG */
+#define MAX_BRIGHTNESS			(127)
+
 struct lm3530_mode_map {
 	const char *mode;
 	enum lm3530_mode mode_val;
@@ -207,6 +210,9 @@ static int lm3530_init_registers(struct 
 	else
 		brightness = drvdata->brightness = pltfm->brt_val;
 
+	if (brightness > drvdata->led_dev.max_brightness)
+		brightness = drvdata->led_dev.max_brightness;
+
 	reg_val[0] = gen_config;	/* LM3530_GEN_CONFIG */
 	reg_val[1] = als_config;	/* LM3530_ALS_CONFIG */
 	reg_val[2] = brt_ramp;		/* LM3530_BRT_RAMP_RATE */
@@ -264,12 +270,12 @@ static void lm3530_brightness_set(struct
 
 		/* set the brightness in brightness control register*/
 		err = i2c_smbus_write_byte_data(drvdata->client,
-				LM3530_BRT_CTRL_REG, brt_val / 2);
+				LM3530_BRT_CTRL_REG, brt_val);
 		if (err)
 			dev_err(&drvdata->client->dev,
 				"Unable to set brightness: %d\n", err);
 		else
-			drvdata->brightness = brt_val / 2;
+			drvdata->brightness = brt_val;
 
 		if (brt_val == 0) {
 			err = regulator_disable(drvdata->regulator);
@@ -380,6 +386,7 @@ static int __devinit lm3530_probe(struct
 	drvdata->enable = false;
 	drvdata->led_dev.name = LM3530_LED_DEV;
 	drvdata->led_dev.brightness_set = lm3530_brightness_set;
+	drvdata->led_dev.max_brightness = MAX_BRIGHTNESS;
 
 	i2c_set_clientdata(client, drvdata);
 
_
Subject: Subject: leds-lm3530: set the max_brightness to 127

Patches currently in -mm which might be from Milo.Kim@ti.com are

backlight-new-backlight-driver-for-lp855x-devices.patch
leds-lp5521-add-name-in-the-lp5521_led_config.patch
leds-lp5521-add-update_config-in-the-lp5521_platform_data.patch
leds-lp5521-support-led-pattern-data.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
leds-lp5521-redefinition-of-register-bits.patch
leds-lm3530-set-the-max_brightness-to-127.patch
leds-lm3530-replace-i2c_client-with-led_classdev.patch
leds-lm3530-support-pwm-input-mode.patch
leds-lm3530-remove-lm3530_als_zone_reg-code.patch
leds-lm3530-replace-pltfm-with-pdata.patch


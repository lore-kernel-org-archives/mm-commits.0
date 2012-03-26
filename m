From: akpm@linux-foundation.org
Subject: [merged] leds-lm3530-set-the-max_brightness-to-127.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:46 -0700
Message-ID: <20120326192946.61538A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:40916 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT3s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:48 -0400
Received: by mail-lb0-f202.google.com with SMTP id gj3so288108lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-lm3530: set the max_brightness to 127
has been removed from the -mm tree.  Its filename was
     leds-lm3530-set-the-max_brightness-to-127.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch


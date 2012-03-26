From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:58 -0700
Message-ID: <20120326192958.68709A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:41509 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT37 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:59 -0400
Received: by yhgm50 with SMTP id m50so833977yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, shreshthakumar.sahu@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-lm3530.c: move the code setting gen_config to one place
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/leds/leds-lm3530.c: move the code setting gen_config to one place

Improve the readability by moving the code setting gen_config to one
place.

[akpm@linux-foundation.org: fix some patch skew]
Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place
+++ a/drivers/leds/leds-lm3530.c
@@ -160,9 +160,16 @@ static int lm3530_init_registers(struct 
 	gen_config = (pdata->brt_ramp_law << LM3530_RAMP_LAW_SHIFT) |
 			((pdata->max_current & 7) << LM3530_MAX_CURR_SHIFT);
 
-	if (drvdata->mode == LM3530_BL_MODE_MANUAL ||
-	    drvdata->mode == LM3530_BL_MODE_ALS)
-		gen_config |= (LM3530_ENABLE_I2C);
+	switch (drvdata->mode) {
+	case LM3530_BL_MODE_MANUAL:
+	case LM3530_BL_MODE_ALS:
+		gen_config |= LM3530_ENABLE_I2C;
+		break;
+	case LM3530_BL_MODE_PWM:
+		gen_config |= LM3530_ENABLE_PWM | LM3530_ENABLE_PWM_SIMPLE |
+			      (pdata->pwm_pol_hi << LM3530_PWM_POL_SHIFT);
+		break;
+	}
 
 	if (drvdata->mode == LM3530_BL_MODE_ALS) {
 		if (pdata->als_vmax == 0) {
@@ -196,11 +203,6 @@ static int lm3530_init_registers(struct 
 
 	}
 
-	if (drvdata->mode == LM3530_BL_MODE_PWM)
-		gen_config |= (LM3530_ENABLE_PWM) |
-				(pdata->pwm_pol_hi << LM3530_PWM_POL_SHIFT) |
-				(LM3530_ENABLE_PWM_SIMPLE);

From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch added to -mm tree
Date: Mon, 13 Feb 2012 14:40:03 -0800
Message-ID: <20120213224003.B0950A00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:36947 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2BMWkF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2012 17:40:05 -0500
Received: by yhgm50 with SMTP id m50so643363yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2012 14:40:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, milo.kim@ti.com, rpurdie@rpsys.net, shreshthakumar.sahu@stericsson.com


The patch titled
     Subject: drivers/leds/leds-lm3530.c: move the code setting gen_config to one place
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/leds/leds-lm3530.c: move the code setting gen_config to one place

Improve the readability by moving the code setting gen_config to one
place.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
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
+			      (pltfm->pwm_pol_hi << LM3530_PWM_POL_SHIFT);
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

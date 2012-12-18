From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-pandora_blc-change-twl4030_module_pwm0-to-twl_module_pwm.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:36 -0800
Message-ID: <20121218200536.B95F082004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:38243 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2LRUFh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:37 -0500
Received: by mail-qa0-f73.google.com with SMTP id a19so157541qad.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:05:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.ujfalusi@ti.com, FlorianSchandinat@gmx.de, jg1.han@samsung.com, notasas@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/pandora_bl.c: change TWL4030_MODULE_PWM0 to TWL_MODULE_PWM
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-pandora_blc-change-twl4030_module_pwm0-to-twl_module_pwm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: drivers/video/backlight/pandora_bl.c: change TWL4030_MODULE_PWM0 to TWL_MODULE_PWM

TWL_MODULE_PWM is defined as:
#define TWL_MODULE_PWM		TWL4030_MODULE_PWM0

Use the common module ID define here which will facilitate the upcoming
twl-core cleanup.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Grazvydas Ignotas <notasas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pandora_bl.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/pandora_bl.c~drivers-video-backlight-pandora_blc-change-twl4030_module_pwm0-to-twl_module_pwm drivers/video/backlight/pandora_bl.c
--- a/drivers/video/backlight/pandora_bl.c~drivers-video-backlight-pandora_blc-change-twl4030_module_pwm0-to-twl_module_pwm
+++ a/drivers/video/backlight/pandora_bl.c
@@ -71,8 +71,7 @@ static int pandora_backlight_update_stat
 		 * set PWM duty cycle to max. TPS61161 seems to use this
 		 * to calibrate it's PWM sensitivity when it starts.
 		 */
-		twl_i2c_write_u8(TWL4030_MODULE_PWM0, MAX_VALUE,
-					TWL_PWM0_OFF);
+		twl_i2c_write_u8(TWL_MODULE_PWM, MAX_VALUE, TWL_PWM0_OFF);
 
 		/* first enable clock, then PWM0 out */
 		twl_i2c_read_u8(TWL4030_MODULE_INTBR, &r, TWL_INTBR_GPBR1);
@@ -90,8 +89,7 @@ static int pandora_backlight_update_stat
 		usleep_range(2000, 10000);
 	}
 
-	twl_i2c_write_u8(TWL4030_MODULE_PWM0, MIN_VALUE + brightness,
-				TWL_PWM0_OFF);
+	twl_i2c_write_u8(TWL_MODULE_PWM, MIN_VALUE + brightness, TWL_PWM0_OFF);
 
 done:
 	if (brightness != 0)
@@ -132,7 +130,7 @@ static int pandora_backlight_probe(struc
 	platform_set_drvdata(pdev, bl);
 
 	/* 64 cycle period, ON position 0 */
-	twl_i2c_write_u8(TWL4030_MODULE_PWM0, 0x80, TWL_PWM0_ON);
+	twl_i2c_write_u8(TWL_MODULE_PWM, 0x80, TWL_PWM0_ON);
 
 	bl->props.state |= PANDORABL_WAS_OFF;
 	bl->props.brightness = MAX_USER_VALUE;
_

Patches currently in -mm which might be from peter.ujfalusi@ti.com are

origin.patch
linux-next.patch


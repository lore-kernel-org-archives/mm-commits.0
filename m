From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-pandora_blc-change-twl4030_module_pwm0-to-twl_module_pwm.patch added to -mm tree
Date: Fri, 16 Nov 2012 14:07:00 -0800
Message-ID: <20121116220700.A8D7C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:37290 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2KPWHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Nov 2012 17:07:01 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so90172ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Nov 2012 14:07:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.ujfalusi@ti.com, FlorianSchandinat@gmx.de, jg1.han@samsung.com, notasas@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/pandora_bl.c: change TWL4030_MODULE_PWM0 to TWL_MODULE_PWM
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-pandora_blc-change-twl4030_module_pwm0-to-twl_module_pwm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-video-backlight-pandora_blc-change-twl4030_module_pwm0-to-twl_module_pwm.patch


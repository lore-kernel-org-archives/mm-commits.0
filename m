From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-lms283gf05c-use-gpiof_init-flags-when-using-devm_gpio_request_one.patch added to -mm tree
Date: Tue, 27 Nov 2012 12:11:59 -0800
Message-ID: <20121127201200.8ED7C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:39571 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2K0UME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 15:12:04 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so750984bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 12:12:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, marex@denx.de, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/lms283gf05.c: use GPIOF_INIT flags when using devm_gpio_request_one()
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-lms283gf05c-use-gpiof_init-flags-when-using-devm_gpio_request_one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/lms283gf05.c: use GPIOF_INIT flags when using devm_gpio_request_one()

GPIOF_DIR_OUT and GPIOF_DIR_IN are defined as below:
 GPIOF_DIR_OUT   (0 << 0)
 GPIOF_DIR_IN    (1 << 0)
So, when !pdata->reset_inverted is 1, the gpio pin can be set as
input, instead of output.

To prevent this problem, GPIOF_INIT flag should be used when using
devm_gpio_request_one().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Marek Vasut <marex@denx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms283gf05.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/lms283gf05.c~drivers-video-backlight-lms283gf05c-use-gpiof_init-flags-when-using-devm_gpio_request_one drivers/video/backlight/lms283gf05.c
--- a/drivers/video/backlight/lms283gf05.c~drivers-video-backlight-lms283gf05c-use-gpiof_init-flags-when-using-devm_gpio_request_one
+++ a/drivers/video/backlight/lms283gf05.c
@@ -159,7 +159,8 @@ static int __devinit lms283gf05_probe(st
 
 	if (pdata != NULL) {
 		ret = devm_gpio_request_one(&spi->dev, pdata->reset_gpio,
-				GPIOF_DIR_OUT | !pdata->reset_inverted,
+				GPIOF_DIR_OUT | (!pdata->reset_inverted ?
+				GPIOF_INIT_HIGH : GPIOF_INIT_LOW),
 				"LMS285GF05 RESET");
 		if (ret)
 			return ret;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata.patch
backlight-88pm860x_bl-fix-checkpatch-warning.patch
backlight-atmel-pwm-bl-fix-checkpatch-warning.patch
backlight-corgi_lcd-fix-checkpatch-error-and-warning.patch
backlight-da903x_bl-fix-checkpatch-warning.patch
backlight-generic_bl-fix-checkpatch-warning.patch
backlight-hp680_bl-fix-checkpatch-error-and-warning.patch
backlight-ili9320-fix-checkpatch-error-and-warning.patch
backlight-jornada720-fix-checkpatch-error-and-warning.patch
backlight-l4f00242t03-fix-checkpatch-warning.patch
backlight-lm3630-fix-checkpatch-warning.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch
backlight-omap1-fix-checkpatch-warning.patch
backlight-pcf50633-fix-checkpatch-warning.patch
backlight-platform_lcd-fix-checkpatch-error.patch
backlight-tdo24m-fix-checkpatch-warning.patch
backlight-tosa-fix-checkpatch-error-and-warning.patch
backlight-vgg2432a4-fix-checkpatch-warning.patch
backlight-lms283gf05-use-devm_gpio_request_one.patch
backlight-tosa-use-devm_gpio_request_one.patch
drivers-video-backlight-da9052_blc-add-missing-const.patch
drivers-video-backlight-lms283gf05c-add-missing-const.patch
drivers-video-backlight-tdo24mc-add-missing-const.patch
drivers-video-backlight-vgg2432a4c-add-missing-const.patch
drivers-video-backlight-s6e63m0c-remove-unnecessary-cast-of-void-pointer.patch
drivers-video-backlight-88pm860x_blc-drop-devm_kfree-of-devm_kzallocd-data.patch
drivers-video-backlight-max8925_blc-drop-devm_kfree-of-devm_kzallocd-data.patch
drivers-video-backlight-ep93xx_blc-fix-section-mismatch.patch
drivers-video-backlight-hp680_blc-add-missing-__devexit-macros-for-remove.patch
drivers-video-backlight-ili9320c-add-missing-__devexit-macros-for-remove.patch
backlight-add-of_find_backlight_by_node-function.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-add-of_find_backlight_by_node-function-fix-2.patch
drivers-video-backlight-pandora_blc-change-twl4030_module_pwm0-to-twl_module_pwm.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
backlight-lcd-return-enxio-when-ops-functions-cannot-be-called.patch
drivers-video-backlight-lms283gf05c-use-gpiof_init-flags-when-using-devm_gpio_request_one.patch
checkpatch-extend-line-continuation-test.patch


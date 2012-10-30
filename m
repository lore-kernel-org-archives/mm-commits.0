From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-ili9320c-add-missing-__devexit-macros-for-remove.patch added to -mm tree
Date: Tue, 30 Oct 2012 15:41:18 -0700
Message-ID: <20121030224119.16782100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:47969 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab2J3WlU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 18:41:20 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so92896yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 15:41:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/ili9320.c: add missing __devexit macros for remove
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-ili9320c-add-missing-__devexit-macros-for-remove.patch

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
Subject: drivers/video/backlight/ili9320.c: add missing __devexit macros for remove

The __devexit macros is added to remove function.  The macros moves the
remove function to devexit sections.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ili9320.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/ili9320.c~drivers-video-backlight-ili9320c-add-missing-__devexit-macros-for-remove drivers/video/backlight/ili9320.c
--- a/drivers/video/backlight/ili9320.c~drivers-video-backlight-ili9320c-add-missing-__devexit-macros-for-remove
+++ a/drivers/video/backlight/ili9320.c
@@ -260,7 +260,7 @@ int __devinit ili9320_probe_spi(struct s
 }
 EXPORT_SYMBOL_GPL(ili9320_probe_spi);
 
-int ili9320_remove(struct ili9320 *ili)
+int __devexit ili9320_remove(struct ili9320 *ili)
 {
 	ili9320_power(ili, FB_BLANK_POWERDOWN);
 
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


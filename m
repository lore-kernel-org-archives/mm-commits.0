From: akpm@linux-foundation.org
Subject: + backlight-lms283gf05-use-devm_gpio_request_one.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:54:45 -0700
Message-ID: <20121017235446.195285C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:62126 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2JQXys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:54:48 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so322947eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:54:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, marex@denx.de, rpurdie@rpsys.net


The patch titled
     Subject: backlight: lms283gf05: use devm_gpio_request_one
has been added to the -mm tree.  Its filename is
     backlight-lms283gf05-use-devm_gpio_request_one.patch

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
Subject: backlight: lms283gf05: use devm_gpio_request_one

By using devm_gpio_request_one it is possible to set the direction
and initial value in one shot. Thus, using devm_gpio_request_one
can make the code simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Acked-by: Marek Vasut <marex@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms283gf05.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-use-devm_gpio_request_one drivers/video/backlight/lms283gf05.c
--- a/drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-use-devm_gpio_request_one
+++ a/drivers/video/backlight/lms283gf05.c
@@ -158,13 +158,9 @@ static int __devinit lms283gf05_probe(st
 	int ret = 0;
 
 	if (pdata != NULL) {
-		ret = devm_gpio_request(&spi->dev, pdata->reset_gpio,
-					"LMS285GF05 RESET");
-		if (ret)
-			return ret;
-
-		ret = gpio_direction_output(pdata->reset_gpio,
-						!pdata->reset_inverted);
+		ret = devm_gpio_request_one(&spi->dev, pdata->reset_gpio,
+				GPIOF_DIR_OUT | !pdata->reset_inverted,
+				"LMS285GF05 RESET");
 		if (ret)
 			return ret;
 	}
_

Patches currently in -mm which might be from jg1.han@samsung.com are

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


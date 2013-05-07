From: akpm@linux-foundation.org
Subject: + backlight-atmel-pwm-bl-remove-unnecessary-platform_set_drvdata.patch added to -mm tree
Date: Tue, 07 May 2013 15:21:21 -0700
Message-ID: <20130507222121.C494331C145@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:42259 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3EGWVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 18:21:22 -0400
Received: by mail-yh0-f74.google.com with SMTP id t59so119639yho.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 15:21:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: atmel-pwm-bl: remove unnecessary platform_set_drvdata()
has been added to the -mm tree.  Its filename is
     backlight-atmel-pwm-bl-remove-unnecessary-platform_set_drvdata.patch

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
Subject: backlight: atmel-pwm-bl: remove unnecessary platform_set_drvdata()

The driver core clears the driver data to NULL after device_release or on
probe failure, since commit 0998d06310 ("device-core: Ensure drvdata =
NULL when no driver is bound").  Thus, it is not needed to manually clear
the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/atmel-pwm-bl.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-remove-unnecessary-platform_set_drvdata drivers/video/backlight/atmel-pwm-bl.c
--- a/drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-remove-unnecessary-platform_set_drvdata
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -195,7 +195,6 @@ static int __init atmel_pwm_bl_probe(str
 	return 0;
 
 err_free_bl_dev:
-	platform_set_drvdata(pdev, NULL);
 	backlight_device_unregister(bldev);
 err_free_pwm:
 	pwm_channel_free(&pwmbl->pwmc);
@@ -212,7 +211,6 @@ static int __exit atmel_pwm_bl_remove(st
 	pwm_channel_disable(&pwmbl->pwmc);
 	pwm_channel_free(&pwmbl->pwmc);
 	backlight_device_unregister(pwmbl->bldev);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
backlight-atmel-pwm-bl-remove-unnecessary-platform_set_drvdata.patch
backlight-ep93xx-remove-unnecessary-platform_set_drvdata.patch
backlight-lp8788-remove-unnecessary-platform_set_drvdata.patch
backlight-pcf50633-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch


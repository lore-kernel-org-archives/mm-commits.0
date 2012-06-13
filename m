From: akpm@linux-foundation.org
Subject: + backlight-atmel-pwm-bl-use-devm_gpio_request.patch added to -mm tree
Date: Wed, 13 Jun 2012 13:35:08 -0700
Message-ID: <20120613203509.22C4EA001B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58772 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2FMUfL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 16:35:11 -0400
Received: by eeit10 with SMTP id t10so54738eei.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 13:35:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, egtvedt@samfundet.no, rpurdie@rpsys.net


The patch titled
     Subject: backlight: atmel-pwm-bl: use devm_gpio_request()
has been added to the -mm tree.  Its filename is
     backlight-atmel-pwm-bl-use-devm_gpio_request.patch

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
Subject: backlight: atmel-pwm-bl: use devm_gpio_request()

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_gpio_request() for these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/atmel-pwm-bl.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-use-devm_gpio_request drivers/video/backlight/atmel-pwm-bl.c
--- a/drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-use-devm_gpio_request
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -155,7 +155,8 @@ static int atmel_pwm_bl_probe(struct pla
 		goto err_free_mem;
 
 	if (pwmbl->gpio_on != -1) {
-		retval = gpio_request(pwmbl->gpio_on, "gpio_atmel_pwm_bl");
+		retval = devm_gpio_request(&pdev->dev, pwmbl->gpio_on,
+					"gpio_atmel_pwm_bl");
 		if (retval) {
 			pwmbl->gpio_on = -1;
 			goto err_free_pwm;
@@ -165,7 +166,7 @@ static int atmel_pwm_bl_probe(struct pla
 		retval = gpio_direction_output(pwmbl->gpio_on,
 				0 ^ pdata->on_active_low);
 		if (retval)
-			goto err_free_gpio;
+			goto err_free_pwm;
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
@@ -175,7 +176,7 @@ static int atmel_pwm_bl_probe(struct pla
 					  &atmel_pwm_bl_ops, &props);
 	if (IS_ERR(bldev)) {
 		retval = PTR_ERR(bldev);
-		goto err_free_gpio;
+		goto err_free_pwm;
 	}
 
 	pwmbl->bldev = bldev;
@@ -197,9 +198,6 @@ static int atmel_pwm_bl_probe(struct pla
 err_free_bl_dev:
 	platform_set_drvdata(pdev, NULL);
 	backlight_device_unregister(bldev);
-err_free_gpio:
-	if (pwmbl->gpio_on != -1)
-		gpio_free(pwmbl->gpio_on);
 err_free_pwm:
 	pwm_channel_free(&pwmbl->pwmc);
 err_free_mem:
@@ -210,10 +208,8 @@ static int __exit atmel_pwm_bl_remove(st
 {
 	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
 
-	if (pwmbl->gpio_on != -1) {
+	if (pwmbl->gpio_on != -1)
 		gpio_set_value(pwmbl->gpio_on, 0);
-		gpio_free(pwmbl->gpio_on);
-	}
 	pwm_channel_disable(&pwmbl->pwmc);
 	pwm_channel_free(&pwmbl->pwmc);
 	backlight_device_unregister(pwmbl->bldev);
_
Subject: Subject: backlight: atmel-pwm-bl: use devm_gpio_request()

Patches currently in -mm which might be from jg1.han@samsung.com are

drivers-video-backlight-atmel-pwm-blc-use-devm_-functions.patch
drivers-video-backlight-ot200_blc-use-devm_-functions.patch
drivers-video-backlight-lm3533_blc-use-devm_-functions.patch
backlight-atmel-pwm-bl-use-devm_gpio_request.patch
backlight-ot200_bl-use-devm_gpio_request.patch
backlight-tosa_lcd-use-devm_gpio_request.patch
backlight-tosa_bl-use-devm_gpio_request.patch
backlight-lms283gf05-use-devm_gpio_request.patch
backlight-corgi_lcd-use-devm_gpio_request.patch
backlight-l4f00242t03-use-devm_gpio_request_one.patch


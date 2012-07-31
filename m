From: akpm@linux-foundation.org
Subject: [merged] backlight-atmel-pwm-bl-use-devm_gpio_request.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:50:17 -0700
Message-ID: <20120731185018.174255C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:33115 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab2GaSuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:50:20 -0400
Received: by wibhr14 with SMTP id hr14so147079wib.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:50:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, egtvedt@samfundet.no, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: atmel-pwm-bl: use devm_gpio_request()
has been removed from the -mm tree.  Its filename was
     backlight-atmel-pwm-bl-use-devm_gpio_request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + backlight-atmel-pwm-bl-use-gpio_request_one.patch added to -mm
 tree
Date: Fri, 01 Nov 2013 13:07:39 -0700
Message-ID: <52740a0b.AM82QOk0tSnD1gHu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab3KAUHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 16:07:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, jhovold@gmail.com

Subject: + backlight-atmel-pwm-bl-use-gpio_request_one.patch added to -mm tree
To: jhovold@gmail.com,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 13:07:39 -0700


The patch titled
     Subject: backlight: atmel-pwm-bl: use gpio_request_one
has been added to the -mm tree.  Its filename is
     backlight-atmel-pwm-bl-use-gpio_request_one.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-atmel-pwm-bl-use-gpio_request_one.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-atmel-pwm-bl-use-gpio_request_one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johan Hovold <jhovold@gmail.com>
Subject: backlight: atmel-pwm-bl: use gpio_request_one

Use devm_gpio_request_one rather than requesting and setting direction
in two calls.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/atmel-pwm-bl.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-use-gpio_request_one drivers/video/backlight/atmel-pwm-bl.c
--- a/drivers/video/backlight/atmel-pwm-bl.c~backlight-atmel-pwm-bl-use-gpio_request_one
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -124,6 +124,7 @@ static int __init atmel_pwm_bl_probe(str
 	const struct atmel_pwm_bl_platform_data *pdata;
 	struct backlight_device *bldev;
 	struct atmel_pwm_bl *pwmbl;
+	unsigned long flags;
 	int retval;
 
 	pdata = dev_get_platdata(&pdev->dev);
@@ -149,14 +150,14 @@ static int __init atmel_pwm_bl_probe(str
 		return retval;
 
 	if (gpio_is_valid(pwmbl->gpio_on)) {
-		retval = devm_gpio_request(&pdev->dev, pwmbl->gpio_on,
-					"gpio_atmel_pwm_bl");
-		if (retval)
-			goto err_free_pwm;
-
 		/* Turn display off by default. */
-		retval = gpio_direction_output(pwmbl->gpio_on,
-				0 ^ pdata->on_active_low);
+		if (pdata->on_active_low)
+			flags = GPIOF_OUT_INIT_HIGH;
+		else
+			flags = GPIOF_OUT_INIT_LOW;
+
+		retval = devm_gpio_request_one(&pdev->dev, pwmbl->gpio_on,
+						flags, "gpio_atmel_pwm_bl");
 		if (retval)
 			goto err_free_pwm;
 	}
_

Patches currently in -mm which might be from jhovold@gmail.com are

backlight-atmel-pwm-bl-fix-reported-brightness.patch
backlight-atmel-pwm-bl-fix-gpio-polarity-in-remove.patch
backlight-atmel-pwm-bl-fix-module-autoload.patch
backlight-atmel-pwm-bl-clean-up-probe-error-handling.patch
backlight-atmel-pwm-bl-clean-up-get_intensity.patch
backlight-atmel-pwm-bl-remove-unused-include.patch
backlight-atmel-pwm-bl-use-gpio_is_valid.patch
backlight-atmel-pwm-bl-refactor-gpio_on-handling.patch
backlight-atmel-pwm-bl-use-gpio_request_one.patch
linux-next.patch


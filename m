From: akpm@linux-foundation.org
Subject: + backlight-ot200_bl-use-devm_gpio_request.patch added to -mm tree
Date: Wed, 13 Jun 2012 13:35:10 -0700
Message-ID: <20120613203510.E03AEA001B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:34605 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2FMUfM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 16:35:12 -0400
Received: by qcsp5 with SMTP id p5so89183qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 13:35:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, christian.gmeiner@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: ot200_bl: use devm_gpio_request()
has been added to the -mm tree.  Its filename is
     backlight-ot200_bl-use-devm_gpio_request.patch

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
Subject: backlight: ot200_bl: use devm_gpio_request()

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_gpio_request() for these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ot200_bl.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/ot200_bl.c~backlight-ot200_bl-use-devm_gpio_request drivers/video/backlight/ot200_bl.c
--- a/drivers/video/backlight/ot200_bl.c~backlight-ot200_bl-use-devm_gpio_request
+++ a/drivers/video/backlight/ot200_bl.c
@@ -84,7 +84,8 @@ static int ot200_backlight_probe(struct 
 	int retval = 0;
 
 	/* request gpio */
-	if (gpio_request(GPIO_DIMM, "ot200 backlight dimmer") < 0) {
+	if (devm_gpio_request(&pdev->dev, GPIO_DIMM,
+				"ot200 backlight dimmer") < 0) {
 		dev_err(&pdev->dev, "failed to request GPIO %d\n", GPIO_DIMM);
 		return -ENODEV;
 	}
@@ -93,8 +94,7 @@ static int ot200_backlight_probe(struct 
 	pwm_timer = cs5535_mfgpt_alloc_timer(7, MFGPT_DOMAIN_ANY);
 	if (!pwm_timer) {
 		dev_err(&pdev->dev, "MFGPT 7 not available\n");
-		retval = -ENODEV;
-		goto error_mfgpt_alloc;
+		return -ENODEV;
 	}
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
@@ -131,8 +131,6 @@ static int ot200_backlight_probe(struct 
 
 error_devm_kzalloc:
 	cs5535_mfgpt_free_timer(pwm_timer);
-error_mfgpt_alloc:
-	gpio_free(GPIO_DIMM);
 	return retval;
 }
 
@@ -149,7 +147,6 @@ static int ot200_backlight_remove(struct
 		MAX_COMP2 - dim_table[100]);
 
 	cs5535_mfgpt_free_timer(pwm_timer);
-	gpio_free(GPIO_DIMM);
 
 	return 0;
 }
_
Subject: Subject: backlight: ot200_bl: use devm_gpio_request()

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


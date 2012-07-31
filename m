From: akpm@linux-foundation.org
Subject: [merged] backlight-ot200_bl-use-devm_gpio_request.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:50:21 -0700
Message-ID: <20120731185022.10E085C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:57525 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab2GaSuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:50:23 -0400
Received: by mail-ey0-f202.google.com with SMTP id o12so241388eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:50:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, christian.gmeiner@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ot200_bl: use devm_gpio_request()
has been removed from the -mm tree.  Its filename was
     backlight-ot200_bl-use-devm_gpio_request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch


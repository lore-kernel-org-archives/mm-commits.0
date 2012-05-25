From: akpm@linux-foundation.org
Subject: + backlight-adp8860-use-devm_-functions.patch added to -mm tree
Date: Fri, 25 May 2012 13:47:25 -0700
Message-ID: <20120525204726.30972A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:44717 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934007Ab2EYUr1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 16:47:27 -0400
Received: by qcsp5 with SMTP id p5so150530qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 13:47:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, michael.hennerich@analog.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: adp8860: use devm_ functions
has been added to the -mm tree.  Its filename is
     backlight-adp8860-use-devm_-functions.patch

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
Subject: backlight: adp8860: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8860_bl.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff -puN drivers/video/backlight/adp8860_bl.c~backlight-adp8860-use-devm_-functions drivers/video/backlight/adp8860_bl.c
--- a/drivers/video/backlight/adp8860_bl.c~backlight-adp8860-use-devm_-functions
+++ a/drivers/video/backlight/adp8860_bl.c
@@ -222,7 +222,8 @@ static int __devinit adp8860_led_probe(s
 	struct led_info *cur_led;
 	int ret, i;
 
-	led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
+	led = devm_kzalloc(&client->dev, sizeof(*led) * pdata->num_leds,
+				GFP_KERNEL);
 	if (led == NULL) {
 		dev_err(&client->dev, "failed to alloc memory\n");
 		return -ENOMEM;
@@ -236,7 +237,7 @@ static int __devinit adp8860_led_probe(s
 
 	if (ret) {
 		dev_err(&client->dev, "failed to write\n");
-		goto err_free;
+		return ret;
 	}
 
 	for (i = 0; i < pdata->num_leds; ++i) {
@@ -291,9 +292,6 @@ static int __devinit adp8860_led_probe(s
 		cancel_work_sync(&led[i].work);
 	}
 
- err_free:
-	kfree(led);
-
 	return ret;
 }
 
@@ -309,7 +307,6 @@ static int __devexit adp8860_led_remove(
 		cancel_work_sync(&data->led[i].work);
 	}
 
-	kfree(data->led);
 	return 0;
 }
 #else
@@ -675,13 +672,13 @@ static int __devinit adp8860_probe(struc
 		return -EINVAL;
 	}
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
 	ret = adp8860_read(client, ADP8860_MFDVID, &reg_val);
 	if (ret < 0)
-		goto out2;
+		return ret;
 
 	switch (ADP8860_MANID(reg_val)) {
 	case ADP8863_MANUFID:
@@ -694,8 +691,7 @@ static int __devinit adp8860_probe(struc
 		break;
 	default:
 		dev_err(&client->dev, "failed to probe\n");
-		ret = -ENODEV;
-		goto out2;
+		return -ENODEV;
 	}
 
 	/* It's confirmed that the DEVID field is actually a REVID */
@@ -717,8 +713,7 @@ static int __devinit adp8860_probe(struc
 			&client->dev, data, &adp8860_bl_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&client->dev, "failed to register backlight\n");
-		ret = PTR_ERR(bl);
-		goto out2;
+		return PTR_ERR(bl);
 	}
 
 	bl->props.brightness = ADP8860_MAX_BRIGHTNESS;
@@ -756,8 +751,6 @@ out:
 			&adp8860_bl_attr_group);
 out1:
 	backlight_device_unregister(bl);
-out2:
-	kfree(data);
 
 	return ret;
 }
@@ -776,7 +769,6 @@ static int __devexit adp8860_remove(stru
 			&adp8860_bl_attr_group);
 
 	backlight_device_unregister(data->bl);
-	kfree(data);
 
 	return 0;
 }
_
Subject: Subject: backlight: adp8860: use devm_ functions

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
backlight-adp8860-use-kstrtoul.patch
backlight-adp8870-use-kstrtoul.patch
backlight-adp5520-use-kstrtoul.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk-fix.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-generic_bl-use-pr_info-instead-of-printk.patch
backlight-generic_bl-use-pr_info-instead-of-printk-fix.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-omap1-use-pr_info-instead-of-printk.patch
backlight-omap1-use-pr_info-instead-of-printk-fix.patch
backlight-progear-use-pr_err-instead-of-printk.patch
backlight-progear-use-pr_err-instead-of-printk-fix.patch
drivers-video-backlight-l4f00242t03c-use-pr_fmt.patch
backlight-initialize-struct-backlight_properties-properly.patch
backlight-adp8860-use-devm_-functions.patch
backlight-adp8870-use-devm_-functions.patch
backlight-ams369fg06-use-devm_-functions.patch
backlight-corgi_lcd-use-devm_-functions.patch
backlight-ili9320-use-devm_-functions.patch
backlight-l4f00242t03-use-devm_-functions.patch
backlight-ld9040-use-devm_-functions.patch
backlight-lms283gf05-use-devm_-functions.patch
backlight-ltv350qv-use-devm_-functions.patch
backlight-s6e63m0-use-devm_-functions.patch
backlight-tdo24m-use-devm_-functions.patch
backlight-tosa_bl-use-devm_-functions.patch
backlight-tosa_lcd-use-devm_-functions.patch


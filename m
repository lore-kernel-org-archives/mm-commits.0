From: akpm@linux-foundation.org
Subject: + backlight-adp8870-use-devm_-functions.patch added to -mm tree
Date: Fri, 25 May 2012 13:47:27 -0700
Message-ID: <20120525204727.E6D03A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:60799 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934007Ab2EYUra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 16:47:30 -0400
Received: by were53 with SMTP id e53so70524wer.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 13:47:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, michael.hennerich@analog.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: adp8870: use devm_ functions
has been added to the -mm tree.  Its filename is
     backlight-adp8870-use-devm_-functions.patch

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
Subject: backlight: adp8870: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8870_bl.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff -puN drivers/video/backlight/adp8870_bl.c~backlight-adp8870-use-devm_-functions drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~backlight-adp8870-use-devm_-functions
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -244,8 +244,8 @@ static int __devinit adp8870_led_probe(s
 	struct led_info *cur_led;
 	int ret, i;
 
-
-	led = kcalloc(pdata->num_leds, sizeof(*led), GFP_KERNEL);
+	led = devm_kzalloc(&client->dev, pdata->num_leds * sizeof(*led),
+				GFP_KERNEL);
 	if (led == NULL) {
 		dev_err(&client->dev, "failed to alloc memory\n");
 		return -ENOMEM;
@@ -253,17 +253,17 @@ static int __devinit adp8870_led_probe(s
 
 	ret = adp8870_write(client, ADP8870_ISCLAW, pdata->led_fade_law);
 	if (ret)
-		goto err_free;
+		return ret;
 
 	ret = adp8870_write(client, ADP8870_ISCT1,
 			(pdata->led_on_time & 0x3) << 6);
 	if (ret)
-		goto err_free;
+		return ret;
 
 	ret = adp8870_write(client, ADP8870_ISCF,
 			FADE_VAL(pdata->led_fade_in, pdata->led_fade_out));
 	if (ret)
-		goto err_free;
+		return ret;
 
 	for (i = 0; i < pdata->num_leds; ++i) {
 		cur_led = &pdata->leds[i];
@@ -317,9 +317,6 @@ static int __devinit adp8870_led_probe(s
 		cancel_work_sync(&led[i].work);
 	}
 
- err_free:
-	kfree(led);
-
 	return ret;
 }
 
@@ -335,7 +332,6 @@ static int __devexit adp8870_led_remove(
 		cancel_work_sync(&data->led[i].work);
 	}
 
-	kfree(data->led);
 	return 0;
 }
 #else
@@ -874,7 +870,7 @@ static int __devinit adp8870_probe(struc
 		return -ENODEV;
 	}
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
@@ -894,8 +890,7 @@ static int __devinit adp8870_probe(struc
 			&client->dev, data, &adp8870_bl_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&client->dev, "failed to register backlight\n");
-		ret = PTR_ERR(bl);
-		goto out2;
+		return PTR_ERR(bl);
 	}
 
 	data->bl = bl;
@@ -930,8 +925,6 @@ out:
 			&adp8870_bl_attr_group);
 out1:
 	backlight_device_unregister(bl);
-out2:
-	kfree(data);
 
 	return ret;
 }
@@ -950,7 +943,6 @@ static int __devexit adp8870_remove(stru
 			&adp8870_bl_attr_group);
 
 	backlight_device_unregister(data->bl);
-	kfree(data);
 
 	return 0;
 }
_
Subject: Subject: backlight: adp8870: use devm_ functions

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


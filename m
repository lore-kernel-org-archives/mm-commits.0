From: akpm@linux-foundation.org
Subject: [merged] backlight-adp8860-use-devm_-functions.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:00 -0700
Message-ID: <20120531191900.54E0FA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:53340 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab2EaTTB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:01 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so134798ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, michael.hennerich@analog.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: adp8860: use devm_ functions
has been removed from the -mm tree.  Its filename was
     backlight-adp8860-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch


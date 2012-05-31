From: akpm@linux-foundation.org
Subject: [merged] backlight-adp8870-use-devm_-functions.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:02 -0700
Message-ID: <20120531191902.5A64CA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42010 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab2EaTTD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:03 -0400
Received: by qabg24 with SMTP id g24so154547qab.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, michael.hennerich@analog.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: adp8870: use devm_ functions
has been removed from the -mm tree.  Its filename was
     backlight-adp8870-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch


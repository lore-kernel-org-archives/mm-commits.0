From: akpm@linux-foundation.org
Subject: [merged]
 backlight-adp8870-use-devm_backlight_device_register.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:40:54 -0800
Message-ID: <5283e3d6.jpDhojOyUIhvCGtv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3KMUkz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-adp8870-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:54 -0800


The patch titled
     Subject: backlight: adp8870: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-adp8870-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: adp8870: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8870_bl.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/video/backlight/adp8870_bl.c~backlight-adp8870-use-devm_backlight_device_register drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~backlight-adp8870-use-devm_backlight_device_register
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -888,8 +888,9 @@ static int adp8870_probe(struct i2c_clie
 	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = props.brightness = ADP8870_MAX_BRIGHTNESS;
-	bl = backlight_device_register(dev_driver_string(&client->dev),
-			&client->dev, data, &adp8870_bl_ops, &props);
+	bl = devm_backlight_device_register(&client->dev,
+				dev_driver_string(&client->dev),
+				&client->dev, data, &adp8870_bl_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&client->dev, "failed to register backlight\n");
 		return PTR_ERR(bl);
@@ -902,7 +903,7 @@ static int adp8870_probe(struct i2c_clie
 			&adp8870_bl_attr_group);
 		if (ret) {
 			dev_err(&client->dev, "failed to register sysfs\n");
-			goto out1;
+			return ret;
 		}
 	}
 
@@ -925,8 +926,6 @@ out:
 	if (data->pdata->en_ambl_sens)
 		sysfs_remove_group(&data->bl->dev.kobj,
 			&adp8870_bl_attr_group);
-out1:
-	backlight_device_unregister(bl);
 
 	return ret;
 }
@@ -944,8 +943,6 @@ static int adp8870_remove(struct i2c_cli
 		sysfs_remove_group(&data->bl->dev.kobj,
 			&adp8870_bl_attr_group);
 
-	backlight_device_unregister(data->bl);

From: akpm@linux-foundation.org
Subject: [merged]
 backlight-adp5520-use-devm_backlight_device_register.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:40:50 -0800
Message-ID: <5283e3d2.5x5Ipdu/daVbEQE+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3KMUku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-adp5520-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:50 -0800


The patch titled
     Subject: backlight: adp5520: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-adp5520-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: adp5520: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp5520_bl.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/adp5520_bl.c~backlight-adp5520-use-devm_backlight_device_register drivers/video/backlight/adp5520_bl.c
--- a/drivers/video/backlight/adp5520_bl.c~backlight-adp5520-use-devm_backlight_device_register
+++ a/drivers/video/backlight/adp5520_bl.c
@@ -312,8 +312,9 @@ static int adp5520_bl_probe(struct platf
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = ADP5020_MAX_BRIGHTNESS;
-	bl = backlight_device_register(pdev->name, data->master, data,
-				       &adp5520_bl_ops, &props);
+	bl = devm_backlight_device_register(&pdev->dev, pdev->name,
+					data->master, data, &adp5520_bl_ops,
+					&props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		return PTR_ERR(bl);
@@ -326,7 +327,7 @@ static int adp5520_bl_probe(struct platf
 
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register sysfs\n");
-		backlight_device_unregister(bl);
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, bl);
@@ -347,8 +348,6 @@ static int adp5520_bl_remove(struct plat
 		sysfs_remove_group(&bl->dev.kobj,
 				&adp5520_bl_attr_group);
 
-	backlight_device_unregister(bl);

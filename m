From: akpm@linux-foundation.org
Subject: [merged]
 backlight-aat2870-use-devm_backlight_device_register.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:40:48 -0800
Message-ID: <5283e3d0.hHp36iAYfWWE8oF/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3KMUkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-aat2870-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:48 -0800


The patch titled
     Subject: backlight: aat2870: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-aat2870-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: aat2870: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/aat2870_bl.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/video/backlight/aat2870_bl.c~backlight-aat2870-use-devm_backlight_device_register drivers/video/backlight/aat2870_bl.c
--- a/drivers/video/backlight/aat2870_bl.c~backlight-aat2870-use-devm_backlight_device_register
+++ a/drivers/video/backlight/aat2870_bl.c
@@ -158,8 +158,9 @@ static int aat2870_bl_probe(struct platf
 	memset(&props, 0, sizeof(struct backlight_properties));
 
 	props.type = BACKLIGHT_RAW;
-	bd = backlight_device_register("aat2870-backlight", &pdev->dev,
-				       aat2870_bl, &aat2870_bl_ops, &props);
+	bd = devm_backlight_device_register(&pdev->dev, "aat2870-backlight",
+					&pdev->dev, aat2870_bl, &aat2870_bl_ops,
+					&props);
 	if (IS_ERR(bd)) {
 		dev_err(&pdev->dev,
 			"Failed allocate memory for backlight device\n");
@@ -194,13 +195,11 @@ static int aat2870_bl_probe(struct platf
 	ret = aat2870_bl_update_status(bd);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to initialize\n");
-		goto out_bl_dev_unregister;
+		return ret;
 	}
 
 	return 0;
 
-out_bl_dev_unregister:
-	backlight_device_unregister(bd);
 out:
 	return ret;
 }
@@ -214,8 +213,6 @@ static int aat2870_bl_remove(struct plat
 	bd->props.brightness = 0;
 	backlight_update_status(bd);
 
-	backlight_device_unregister(bd);

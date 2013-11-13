From: akpm@linux-foundation.org
Subject: [merged]
 backlight-lm3533_bl-use-devm_backlight_device_register.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:41:14 -0800
Message-ID: <5283e3ea.FyXx1G2oekpaw0Pp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3KMUlO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-lm3533_bl-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:41:14 -0800


The patch titled
     Subject: backlight: lm3533_bl: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-lm3533_bl-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lm3533_bl: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3533_bl.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/lm3533_bl.c~backlight-lm3533_bl-use-devm_backlight_device_register drivers/video/backlight/lm3533_bl.c
--- a/drivers/video/backlight/lm3533_bl.c~backlight-lm3533_bl-use-devm_backlight_device_register
+++ a/drivers/video/backlight/lm3533_bl.c
@@ -313,8 +313,9 @@ static int lm3533_bl_probe(struct platfo
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = LM3533_BL_MAX_BRIGHTNESS;
 	props.brightness = pdata->default_brightness;
-	bd = backlight_device_register(pdata->name, pdev->dev.parent, bl,
-						&lm3533_bl_ops, &props);
+	bd = devm_backlight_device_register(&pdev->dev, pdata->name,
+					pdev->dev.parent, bl, &lm3533_bl_ops,
+					&props);
 	if (IS_ERR(bd)) {
 		dev_err(&pdev->dev, "failed to register backlight device\n");
 		return PTR_ERR(bd);
@@ -328,7 +329,7 @@ static int lm3533_bl_probe(struct platfo
 	ret = sysfs_create_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to create sysfs attributes\n");
-		goto err_unregister;
+		return ret;
 	}
 
 	backlight_update_status(bd);
@@ -345,8 +346,6 @@ static int lm3533_bl_probe(struct platfo
 
 err_sysfs_remove:
 	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
-err_unregister:
-	backlight_device_unregister(bd);
 
 	return ret;
 }
@@ -363,7 +362,6 @@ static int lm3533_bl_remove(struct platf
 
 	lm3533_ctrlbank_disable(&bl->cb);
 	sysfs_remove_group(&bd->dev.kobj, &lm3533_bl_attribute_group);
-	backlight_device_unregister(bd);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
linux-next.patch
drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata.patch
w1-w1-gpio-use-dev_get_platdata.patch


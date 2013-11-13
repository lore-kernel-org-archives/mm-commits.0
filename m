From: akpm@linux-foundation.org
Subject: [merged]
 backlight-lp855x-use-devm_backlight_device_register.patch removed from -mm
 tree
Date: Wed, 13 Nov 2013 12:41:16 -0800
Message-ID: <5283e3ec.eOF8p2cHZpFl5Dn9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3KMUlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-lp855x-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:41:16 -0800


The patch titled
     Subject: backlight: lp855x: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-lp855x-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lp855x: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler.  Also,
unnecessary lp855x_backlight_unregister() is removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x-use-devm_backlight_device_register drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x-use-devm_backlight_device_register
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -300,7 +300,7 @@ static int lp855x_backlight_register(str
 
 	props.brightness = pdata->initial_brightness;
 
-	bl = backlight_device_register(name, lp->dev, lp,
+	bl = devm_backlight_device_register(lp->dev, name, lp->dev, lp,
 				       &lp855x_bl_ops, &props);
 	if (IS_ERR(bl))
 		return PTR_ERR(bl);
@@ -310,12 +310,6 @@ static int lp855x_backlight_register(str
 	return 0;
 }
 
-static void lp855x_backlight_unregister(struct lp855x *lp)
-{
-	if (lp->bl)
-		backlight_device_unregister(lp->bl);
-}
-
 static ssize_t lp855x_get_chip_id(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -439,29 +433,24 @@ static int lp855x_probe(struct i2c_clien
 	ret = lp855x_configure(lp);
 	if (ret) {
 		dev_err(lp->dev, "device config err: %d", ret);
-		goto err_dev;
+		return ret;
 	}
 
 	ret = lp855x_backlight_register(lp);
 	if (ret) {
 		dev_err(lp->dev,
 			"failed to register backlight. err: %d\n", ret);
-		goto err_dev;
+		return ret;
 	}
 
 	ret = sysfs_create_group(&lp->dev->kobj, &lp855x_attr_group);
 	if (ret) {
 		dev_err(lp->dev, "failed to register sysfs. err: %d\n", ret);
-		goto err_sysfs;
+		return ret;
 	}
 
 	backlight_update_status(lp->bl);
 	return 0;
-
-err_sysfs:
-	lp855x_backlight_unregister(lp);
-err_dev:
-	return ret;
 }
 
 static int lp855x_remove(struct i2c_client *cl)
@@ -471,7 +460,6 @@ static int lp855x_remove(struct i2c_clie
 	lp->bl->props.brightness = 0;
 	backlight_update_status(lp->bl);
 	sysfs_remove_group(&lp->dev->kobj, &lp855x_attr_group);
-	lp855x_backlight_unregister(lp);
 
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


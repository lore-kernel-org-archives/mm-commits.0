From: akpm@linux-foundation.org
Subject: [merged]
 backlight-bd6107-use-devm_backlight_device_register.patch removed from -mm
 tree
Date: Wed, 13 Nov 2013 12:41:00 -0800
Message-ID: <5283e3dc.Cb1YV2zw9OHAR6lJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3KMUlA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-bd6107-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:41:00 -0800


The patch titled
     Subject: backlight: bd6107: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-bd6107-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: bd6107: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/bd6107.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/bd6107.c~backlight-bd6107-use-devm_backlight_device_register drivers/video/backlight/bd6107.c
--- a/drivers/video/backlight/bd6107.c~backlight-bd6107-use-devm_backlight_device_register
+++ a/drivers/video/backlight/bd6107.c
@@ -166,7 +166,8 @@ static int bd6107_probe(struct i2c_clien
 	props.brightness = clamp_t(unsigned int, pdata->def_value, 0,
 				   props.max_brightness);
 
-	backlight = backlight_device_register(dev_name(&client->dev),
+	backlight = devm_backlight_device_register(&client->dev,
+					      dev_name(&client->dev),
 					      &bd->client->dev, bd,
 					      &bd6107_backlight_ops, &props);
 	if (IS_ERR(backlight)) {
@@ -186,7 +187,6 @@ static int bd6107_remove(struct i2c_clie
 
 	backlight->props.brightness = 0;
 	backlight_update_status(backlight);
-	backlight_device_unregister(backlight);
 
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


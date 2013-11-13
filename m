From: akpm@linux-foundation.org
Subject: [merged]
 backlight-da9052_bl-use-devm_backlight_device_register.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:41:04 -0800
Message-ID: <5283e3e0.6SKgmdI9fPO4AItp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3KMUlJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-da9052_bl-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:41:04 -0800


The patch titled
     Subject: backlight: da9052_bl: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-da9052_bl-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: da9052_bl: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/da9052_bl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/da9052_bl.c~backlight-da9052_bl-use-devm_backlight_device_register drivers/video/backlight/da9052_bl.c
--- a/drivers/video/backlight/da9052_bl.c~backlight-da9052_bl-use-devm_backlight_device_register
+++ a/drivers/video/backlight/da9052_bl.c
@@ -125,8 +125,9 @@ static int da9052_backlight_probe(struct
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = DA9052_MAX_BRIGHTNESS;
 
-	bl = backlight_device_register(pdev->name, wleds->da9052->dev, wleds,
-				       &da9052_backlight_ops, &props);
+	bl = devm_backlight_device_register(&pdev->dev, pdev->name,
+					wleds->da9052->dev, wleds,
+					&da9052_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "Failed to register backlight\n");
 		return PTR_ERR(bl);
@@ -147,7 +148,6 @@ static int da9052_backlight_remove(struc
 	wleds->brightness = 0;
 	wleds->state = DA9052_WLEDS_OFF;
 	da9052_adjust_wled_brightness(wleds);
-	backlight_device_unregister(bl);
 
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


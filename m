From: akpm@linux-foundation.org
Subject: [merged] backlight-aat2870-use-bl_get_data-instead-of-dev_get_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:32 -0800
Message-ID: <20130222204132.9E3445A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:48921 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab3BVUld (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:33 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so104052vea.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: aat2870: use bl_get_data instead of dev_get_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-aat2870-use-bl_get_data-instead-of-dev_get_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: aat2870: use bl_get_data instead of dev_get_drvdata

Use the wrapper function for getting the driver data using
backlight_device instead of using dev_get_drvdata with &bd->dev, so we can
directly pass a struct backlight_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/aat2870_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/aat2870_bl.c~backlight-aat2870-use-bl_get_data-instead-of-dev_get_drvdata drivers/video/backlight/aat2870_bl.c
--- a/drivers/video/backlight/aat2870_bl.c~backlight-aat2870-use-bl_get_data-instead-of-dev_get_drvdata
+++ a/drivers/video/backlight/aat2870_bl.c
@@ -74,7 +74,7 @@ static int aat2870_bl_get_brightness(str
 
 static int aat2870_bl_update_status(struct backlight_device *bd)
 {
-	struct aat2870_bl_driver_data *aat2870_bl = dev_get_drvdata(&bd->dev);
+	struct aat2870_bl_driver_data *aat2870_bl = bl_get_data(bd);
 	struct aat2870_data *aat2870 =
 			dev_get_drvdata(aat2870_bl->pdev->dev.parent);
 	int brightness = bd->props.brightness;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch


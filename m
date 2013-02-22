From: akpm@linux-foundation.org
Subject: [merged] backlight-omap1-use-bl_get_data-instead-of-dev_get_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:47 -0800
Message-ID: <20130222204147.9351B31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:60720 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:48 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so103908yen.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: omap1: use bl_get_data instead of dev_get_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-omap1-use-bl_get_data-instead-of-dev_get_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: omap1: use bl_get_data instead of dev_get_drvdata

Use the wrapper function for getting the driver data using
backlight_device instead of using dev_get_drvdata with &bd->dev, so we can
directly pass a struct backlight_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/omap1_bl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/omap1_bl.c~backlight-omap1-use-bl_get_data-instead-of-dev_get_drvdata drivers/video/backlight/omap1_bl.c
--- a/drivers/video/backlight/omap1_bl.c~backlight-omap1-use-bl_get_data-instead-of-dev_get_drvdata
+++ a/drivers/video/backlight/omap1_bl.c
@@ -77,7 +77,7 @@ static void omapbl_blank(struct omap_bac
 static int omapbl_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct backlight_device *dev = platform_get_drvdata(pdev);
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	struct omap_backlight *bl = bl_get_data(dev);
 
 	omapbl_blank(bl, FB_BLANK_POWERDOWN);
 	return 0;
@@ -86,7 +86,7 @@ static int omapbl_suspend(struct platfor
 static int omapbl_resume(struct platform_device *pdev)
 {
 	struct backlight_device *dev = platform_get_drvdata(pdev);
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	struct omap_backlight *bl = bl_get_data(dev);
 
 	omapbl_blank(bl, bl->powermode);
 	return 0;
@@ -98,7 +98,7 @@ static int omapbl_resume(struct platform
 
 static int omapbl_set_power(struct backlight_device *dev, int state)
 {
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	struct omap_backlight *bl = bl_get_data(dev);
 
 	omapbl_blank(bl, state);
 	bl->powermode = state;
@@ -108,7 +108,7 @@ static int omapbl_set_power(struct backl
 
 static int omapbl_update_status(struct backlight_device *dev)
 {
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	struct omap_backlight *bl = bl_get_data(dev);
 
 	if (bl->current_intensity != dev->props.brightness) {
 		if (bl->powermode == FB_BLANK_UNBLANK)
@@ -124,7 +124,7 @@ static int omapbl_update_status(struct b
 
 static int omapbl_get_intensity(struct backlight_device *dev)
 {
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	struct omap_backlight *bl = bl_get_data(dev);
 	return bl->current_intensity;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch


From: akpm@linux-foundation.org
Subject: [merged] backlight-tosa-use-bl_get_data-instead-of-dev_get_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:44 -0800
Message-ID: <20130222204144.9B8DE5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:38123 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUlp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:45 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so119385qaj.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: tosa: use bl_get_data instead of dev_get_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-tosa-use-bl_get_data-instead-of-dev_get_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: tosa: use bl_get_data instead of dev_get_drvdata

Use the wrapper function for getting the driver data using
backlight_device instead of using dev_get_drvdata with &bd->dev, so we can
directly pass a struct backlight_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/tosa_bl.c~backlight-tosa-use-bl_get_data-instead-of-dev_get_drvdata drivers/video/backlight/tosa_bl.c
--- a/drivers/video/backlight/tosa_bl.c~backlight-tosa-use-bl_get_data-instead-of-dev_get_drvdata
+++ a/drivers/video/backlight/tosa_bl.c
@@ -54,7 +54,7 @@ static void tosa_bl_set_backlight(struct
 static int tosa_bl_update_status(struct backlight_device *dev)
 {
 	struct backlight_properties *props = &dev->props;
-	struct tosa_bl_data *data = dev_get_drvdata(&dev->dev);
+	struct tosa_bl_data *data = bl_get_data(dev);
 	int power = max(props->power, props->fb_blank);
 	int brightness = props->brightness;
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch


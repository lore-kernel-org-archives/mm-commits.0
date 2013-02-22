From: akpm@linux-foundation.org
Subject: [merged] backlight-ams369fg06-use-bl_get_data-instead-of-dev_get_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:38 -0800
Message-ID: <20130222204138.97F2F5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:50388 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUlj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:39 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so103861yhr.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ams369fg06: use bl_get_data instead of dev_get_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-ams369fg06-use-bl_get_data-instead-of-dev_get_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ams369fg06: use bl_get_data instead of dev_get_drvdata

Use the wrapper function for getting the driver data using
backlight_device instead of using dev_get_drvdata with &bd->dev, so we can
directly pass a struct backlight_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-use-bl_get_data-instead-of-dev_get_drvdata drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-use-bl_get_data-instead-of-dev_get_drvdata
+++ a/drivers/video/backlight/ams369fg06.c
@@ -421,7 +421,7 @@ static int ams369fg06_set_brightness(str
 {
 	int ret = 0;
 	int brightness = bd->props.brightness;
-	struct ams369fg06 *lcd = dev_get_drvdata(&bd->dev);
+	struct ams369fg06 *lcd = bl_get_data(bd);
 
 	if (brightness < MIN_BRIGHTNESS ||
 		brightness > bd->props.max_brightness) {
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch


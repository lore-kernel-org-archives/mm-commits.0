From: akpm@linux-foundation.org
Subject: [merged] pwm_backlight-use-bl_get_data-instead-of-dev_get_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:35 -0800
Message-ID: <20130222204135.A477D31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:39724 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUlg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:36 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so103929ghb.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: pwm_backlight: use bl_get_data instead of dev_get_drvdata
has been removed from the -mm tree.  Its filename was
     pwm_backlight-use-bl_get_data-instead-of-dev_get_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: pwm_backlight: use bl_get_data instead of dev_get_drvdata

Use the wrapper function for getting the driver data using
backlight_device instead of using dev_get_drvdata with &bd->dev, so we can
directly pass a struct backlight_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pwm_bl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/pwm_bl.c~pwm_backlight-use-bl_get_data-instead-of-dev_get_drvdata drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~pwm_backlight-use-bl_get_data-instead-of-dev_get_drvdata
+++ a/drivers/video/backlight/pwm_bl.c
@@ -37,7 +37,7 @@ struct pwm_bl_data {
 
 static int pwm_backlight_update_status(struct backlight_device *bl)
 {
-	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+	struct pwm_bl_data *pb = bl_get_data(bl);
 	int brightness = bl->props.brightness;
 	int max = bl->props.max_brightness;
 
@@ -83,7 +83,7 @@ static int pwm_backlight_get_brightness(
 static int pwm_backlight_check_fb(struct backlight_device *bl,
 				  struct fb_info *info)
 {
-	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+	struct pwm_bl_data *pb = bl_get_data(bl);
 
 	return !pb->check_fb || pb->check_fb(pb->dev, info);
 }
@@ -264,7 +264,7 @@ err_alloc:
 static int pwm_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
-	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+	struct pwm_bl_data *pb = bl_get_data(bl);
 
 	backlight_device_unregister(bl);
 	pwm_config(pb->pwm, 0, pb->period);
@@ -278,7 +278,7 @@ static int pwm_backlight_remove(struct p
 static int pwm_backlight_suspend(struct device *dev)
 {
 	struct backlight_device *bl = dev_get_drvdata(dev);
-	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+	struct pwm_bl_data *pb = bl_get_data(bl);
 
 	if (pb->notify)
 		pb->notify(pb->dev, 0);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch


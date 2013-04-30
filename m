From: akpm@linux-foundation.org
Subject: [merged] backlight-locomolcd-convert-locomolcd-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:08 -0700
Message-ID: <20130430185208.6A2F031C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:46441 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab3D3SwJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:52:09 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so76959veb.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: locomolcd: convert locomolcd to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-locomolcd-convert-locomolcd-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: locomolcd: convert locomolcd to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/locomolcd.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/video/backlight/locomolcd.c~backlight-locomolcd-convert-locomolcd-to-dev_pm_ops drivers/video/backlight/locomolcd.c
--- a/drivers/video/backlight/locomolcd.c~backlight-locomolcd-convert-locomolcd-to-dev_pm_ops
+++ a/drivers/video/backlight/locomolcd.c
@@ -157,25 +157,24 @@ static const struct backlight_ops locomo
 	.update_status  = locomolcd_set_intensity,
 };
 
-#ifdef CONFIG_PM
-static int locomolcd_suspend(struct locomo_dev *dev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int locomolcd_suspend(struct device *dev)
 {
 	locomolcd_flags |= LOCOMOLCD_SUSPENDED;
 	locomolcd_set_intensity(locomolcd_bl_device);
 	return 0;
 }
 
-static int locomolcd_resume(struct locomo_dev *dev)
+static int locomolcd_resume(struct device *dev)
 {
 	locomolcd_flags &= ~LOCOMOLCD_SUSPENDED;
 	locomolcd_set_intensity(locomolcd_bl_device);
 	return 0;
 }
-#else
-#define locomolcd_suspend	NULL
-#define locomolcd_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(locomolcd_pm_ops, locomolcd_suspend, locomolcd_resume);
+
 static int locomolcd_probe(struct locomo_dev *ldev)
 {
 	struct backlight_properties props;
@@ -230,13 +229,12 @@ static int locomolcd_remove(struct locom
 
 static struct locomo_driver poodle_lcd_driver = {
 	.drv = {
-		.name = "locomo-backlight",
+		.name	= "locomo-backlight",
+		.pm	= &locomolcd_pm_ops,
 	},
 	.devid	= LOCOMO_DEVID_BACKLIGHT,
 	.probe	= locomolcd_probe,
 	.remove	= locomolcd_remove,
-	.suspend = locomolcd_suspend,
-	.resume = locomolcd_resume,
 };
 
 static int __init locomolcd_init(void)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch


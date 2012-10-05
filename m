From: akpm@linux-foundation.org
Subject: [merged] backlight-platform-lcd-add-support-for-device-tree-based-probe.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:15:12 -0700
Message-ID: <20121005201512.A71BF100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:34607 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab2JEUPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:15:13 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so236494vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:15:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/platform_lcd.c: add support for device tree based probe
has been removed from the -mm tree.  Its filename was
     backlight-platform-lcd-add-support-for-device-tree-based-probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/platform_lcd.c: add support for device tree based probe

This patch adds the of_match_table to platform-lcd driver to be
probed when platform-lcd device node is found in the device tree.

[akpm@linux-foundation.org: include of.h]
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/platform_lcd.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/video/backlight/platform_lcd.c~backlight-platform-lcd-add-support-for-device-tree-based-probe drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~backlight-platform-lcd-add-support-for-device-tree-based-probe
+++ a/drivers/video/backlight/platform_lcd.c
@@ -16,6 +16,7 @@
 #include <linux/fb.h>
 #include <linux/backlight.h>
 #include <linux/lcd.h>
+#include <linux/of.h>
 #include <linux/slab.h>
 
 #include <video/platform_lcd.h>
@@ -145,6 +146,14 @@ static SIMPLE_DEV_PM_OPS(platform_lcd_pm
 			platform_lcd_resume);
 #endif
 
+#ifdef CONFIG_OF
+static const struct of_device_id platform_lcd_of_match[] = {
+	{ .compatible = "platform-lcd" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, platform_lcd_of_match);
+#endif
+
 static struct platform_driver platform_lcd_driver = {
 	.driver		= {
 		.name	= "platform-lcd",
@@ -152,6 +161,7 @@ static struct platform_driver platform_l
 #ifdef CONFIG_PM
 		.pm	= &platform_lcd_pm_ops,
 #endif
+		.of_match_table = of_match_ptr(platform_lcd_of_match),
 	},
 	.probe		= platform_lcd_probe,
 	.remove		= __devexit_p(platform_lcd_remove),
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + backlight-platform-lcd-add-support-for-device-tree-based-probe.patch added to -mm tree
Date: Fri, 21 Sep 2012 14:52:15 -0700
Message-ID: <20120921215216.39637100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:51484 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757950Ab2IUVwR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Sep 2012 17:52:17 -0400
Received: by ggnq2 with SMTP id q2so279405ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Sep 2012 14:52:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/platform_lcd.c: add support for device tree based probe
has been added to the -mm tree.  Its filename is
     backlight-platform-lcd-add-support-for-device-tree-based-probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/platform_lcd.c: add support for device tree based probe

This patch adds the of_match_table to platform-lcd driver to be
probed when platform-lcd device node is found in the device tree.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/platform_lcd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/video/backlight/platform_lcd.c~backlight-platform-lcd-add-support-for-device-tree-based-probe drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~backlight-platform-lcd-add-support-for-device-tree-based-probe
+++ a/drivers/video/backlight/platform_lcd.c
@@ -145,6 +145,14 @@ static SIMPLE_DEV_PM_OPS(platform_lcd_pm
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
@@ -152,6 +160,7 @@ static struct platform_driver platform_l
 #ifdef CONFIG_PM
 		.pm	= &platform_lcd_pm_ops,
 #endif
+		.of_match_table = of_match_ptr(platform_lcd_of_match),
 	},
 	.probe		= platform_lcd_probe,
 	.remove		= __devexit_p(platform_lcd_remove),
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-da9052_blc-drop-devm_kfree-of-devm_kzallocd-data.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe-fix.patch


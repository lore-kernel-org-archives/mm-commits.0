From: akpm@linux-foundation.org
Subject: [merged] backlight-convert-pwm_bl-to-dev_pm_ops.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:30:08 -0800
Message-ID: <20120111213008.954A01E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:42148 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159Ab2AKVaJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:30:09 -0500
Received: by yenm1 with SMTP id m1so7711yen.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:30:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, FlorianSchandinat@gmx.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: convert pwm_bl to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-convert-pwm_bl-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: backlight: convert pwm_bl to dev_pm_ops

Should be no functional changes, mainly a reorganisation to support future
work.

[akpm@linux-foundation.org: fix CONFIG_PM=n build]
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pwm_bl.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/pwm_bl.c~backlight-convert-pwm_bl-to-dev_pm_ops drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~backlight-convert-pwm_bl-to-dev_pm_ops
+++ a/drivers/video/backlight/pwm_bl.c
@@ -169,10 +169,9 @@ static int pwm_backlight_remove(struct p
 }
 
 #ifdef CONFIG_PM
-static int pwm_backlight_suspend(struct platform_device *pdev,
-				 pm_message_t state)
+static int pwm_backlight_suspend(struct device *dev)
 {
-	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
 
 	if (pb->notify)
@@ -184,27 +183,29 @@ static int pwm_backlight_suspend(struct 
 	return 0;
 }
 
-static int pwm_backlight_resume(struct platform_device *pdev)
+static int pwm_backlight_resume(struct device *dev)
 {
-	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
 
 	backlight_update_status(bl);
 	return 0;
 }
-#else
-#define pwm_backlight_suspend	NULL
-#define pwm_backlight_resume	NULL
+
+static SIMPLE_DEV_PM_OPS(pwm_backlight_pm_ops, pwm_backlight_suspend,
+			 pwm_backlight_resume);
+
 #endif
 
 static struct platform_driver pwm_backlight_driver = {
 	.driver		= {
 		.name	= "pwm-backlight",
 		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &pwm_backlight_pm_ops,
+#endif
 	},
 	.probe		= pwm_backlight_probe,
 	.remove		= pwm_backlight_remove,
-	.suspend	= pwm_backlight_suspend,
-	.resume		= pwm_backlight_resume,
 };
 
 module_platform_driver(pwm_backlight_driver);
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch


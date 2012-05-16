From: akpm@linux-foundation.org
Subject: [merged] video-exynos-mipi-dsi-do-not-use-deprecated-suspend-resume-callbacks.patch removed from -mm tree
Date: Wed, 16 May 2012 11:47:07 -0700
Message-ID: <20120516184707.70795A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:58944 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760358Ab2EPSrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 14:47:08 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so142767qab.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 11:47:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.nawrocki@samsung.com, FlorianSchandinat@gmx.de, dh09.lee@samsung.com, inki.dae@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: video: exynos mipi dsi: Do not use deprecated suspend/resume callbacks
has been removed from the -mm tree.  Its filename was
     video-exynos-mipi-dsi-do-not-use-deprecated-suspend-resume-callbacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: video: exynos mipi dsi: Do not use deprecated suspend/resume callbacks

Use proper PM ops from struct dev_pm_ops rather than the deprecated ones.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Donghwa Lee <dh09.lee@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/exynos/exynos_mipi_dsi.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/video/exynos/exynos_mipi_dsi.c~video-exynos-mipi-dsi-do-not-use-deprecated-suspend-resume-callbacks drivers/video/exynos/exynos_mipi_dsi.c
--- a/drivers/video/exynos/exynos_mipi_dsi.c~video-exynos-mipi-dsi-do-not-use-deprecated-suspend-resume-callbacks
+++ a/drivers/video/exynos/exynos_mipi_dsi.c
@@ -517,10 +517,10 @@ static int __devexit exynos_mipi_dsi_rem
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int exynos_mipi_dsi_suspend(struct platform_device *pdev,
-		pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int exynos_mipi_dsi_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct mipi_dsim_device *dsim = platform_get_drvdata(pdev);
 	struct mipi_dsim_lcd_driver *client_drv = dsim->dsim_lcd_drv;
 	struct mipi_dsim_lcd_device *client_dev = dsim->dsim_lcd_dev;
@@ -546,8 +546,9 @@ static int exynos_mipi_dsi_suspend(struc
 	return 0;
 }
 
-static int exynos_mipi_dsi_resume(struct platform_device *pdev)
+static int exynos_mipi_dsi_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct mipi_dsim_device *dsim = platform_get_drvdata(pdev);
 	struct mipi_dsim_lcd_driver *client_drv = dsim->dsim_lcd_drv;
 	struct mipi_dsim_lcd_device *client_dev = dsim->dsim_lcd_dev;
@@ -579,19 +580,19 @@ static int exynos_mipi_dsi_resume(struct
 
 	return 0;
 }
-#else
-#define exynos_mipi_dsi_suspend NULL
-#define exynos_mipi_dsi_resume NULL
 #endif
 
+static const struct dev_pm_ops exynos_mipi_dsi_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(exynos_mipi_dsi_suspend, exynos_mipi_dsi_resume)
+};
+
 static struct platform_driver exynos_mipi_dsi_driver = {
 	.probe = exynos_mipi_dsi_probe,
 	.remove = __devexit_p(exynos_mipi_dsi_remove),
-	.suspend = exynos_mipi_dsi_suspend,
-	.resume = exynos_mipi_dsi_resume,
 	.driver = {
 		   .name = "exynos-mipi-dsim",
 		   .owner = THIS_MODULE,
+		   .pm = &exynos_mipi_dsi_pm_ops,
 	},
 };
 
_

Patches currently in -mm which might be from s.nawrocki@samsung.com are

origin.patch
linux-next.patch


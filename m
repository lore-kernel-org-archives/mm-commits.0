From: akpm@linux-foundation.org
Subject: + video-exynos-mipi-dsi-do-not-use-deprecated-suspend-resume-callbacks.patch added to -mm tree
Date: Wed, 09 May 2012 13:40:40 -0700
Message-ID: <20120509204040.E59FEA03DB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:48805 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761163Ab2EIUko (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2012 16:40:44 -0400
Received: by eaaq10 with SMTP id q10so37462eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 09 May 2012 13:40:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s.nawrocki@samsung.com, FlorianSchandinat@gmx.de, dh09.lee@samsung.com, inki.dae@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: video: exynos mipi dsi: Do not use deprecated suspend/resume callbacks
has been added to the -mm tree.  Its filename is
     video-exynos-mipi-dsi-do-not-use-deprecated-suspend-resume-callbacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: video: exynos mipi dsi: Do not use deprecated suspend/resume callbacks

Patches currently in -mm which might be from s.nawrocki@samsung.com are

linux-next.patch
video-exynos-mipi-dsi-do-not-use-deprecated-suspend-resume-callbacks.patch
video-exynos-mipi-dsi-avoid-races-in-probe.patch
video-exynos-mipi-dsi-properly-interpret-the-interrupt-source-flags.patch


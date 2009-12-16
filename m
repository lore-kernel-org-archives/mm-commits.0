From: akpm@linux-foundation.org
Subject: [merged] rtc-convert-wm8350-rtc-driver-to-dev_pm_ops.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:34:47 -0800
Message-ID: <200912162034.nBGKYlQo013044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935148AbZLPUe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:34:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc: convert WM8350 RTC driver to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     rtc-convert-wm8350-rtc-driver-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: convert WM8350 RTC driver to dev_pm_ops
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Convert WM8350 RTC driver to dev_pm_ops

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm8350.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-wm8350.c~rtc-convert-wm8350-rtc-driver-to-dev_pm_ops drivers/rtc/rtc-wm8350.c
--- a/drivers/rtc/rtc-wm8350.c~rtc-convert-wm8350-rtc-driver-to-dev_pm_ops
+++ a/drivers/rtc/rtc-wm8350.c
@@ -354,8 +354,9 @@ static const struct rtc_class_ops wm8350
 };
 
 #ifdef CONFIG_PM
-static int wm8350_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int wm8350_rtc_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct wm8350 *wm8350 = dev_get_drvdata(&pdev->dev);
 	int ret = 0;
 	u16 reg;
@@ -373,8 +374,9 @@ static int wm8350_rtc_suspend(struct pla
 	return ret;
 }
 
-static int wm8350_rtc_resume(struct platform_device *pdev)
+static int wm8350_rtc_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct wm8350 *wm8350 = dev_get_drvdata(&pdev->dev);
 	int ret;
 
@@ -484,13 +486,17 @@ static int __devexit wm8350_rtc_remove(s
 	return 0;
 }
 
+static struct dev_pm_ops wm8350_rtc_pm_ops = {
+	.suspend = wm8350_rtc_suspend,
+	.resume = wm8350_rtc_resume,
+};
+
 static struct platform_driver wm8350_rtc_driver = {
 	.probe = wm8350_rtc_probe,
 	.remove = __devexit_p(wm8350_rtc_remove),
-	.suspend = wm8350_rtc_suspend,
-	.resume = wm8350_rtc_resume,
 	.driver = {
 		.name = "wm8350-rtc",
+		.pm = &wm8350_rtc_pm_ops,
 	},
 };
 
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch


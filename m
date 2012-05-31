From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-tegrac-clean-up-probe-remove-routines.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:43 -0700
Message-ID: <20120531192043.707B6A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:49749 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104Ab2EaTUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:45 -0400
Received: by mail-fa0-f74.google.com with SMTP id a25so75487faa.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-hannu.m.heikkinen@nokia.com, a.zummo@towertech.it, swarren@wwwdotorg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tegra.c: clean up probe/remove routines
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-tegrac-clean-up-probe-remove-routines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hannu Heikkinen <ext-hannu.m.heikkinen@nokia.com>
Subject: drivers/rtc/rtc-tegra.c: clean up probe/remove routines

Use the devres managed resource functions in the probe routine.  Also
affects the remove routine where the previously used free and release
functions are not needed.

The devm_* functions eliminate the need for manual resource releasing and
simplify error handling.  Resources allocated by devm_* are freed
automatically on driver detach.

Signed-off-by: Hannu Heikkinen <ext-hannu.m.heikkinen@nokia.com>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tegra.c |   50 +++++++++-----------------------------
 1 file changed, 13 insertions(+), 37 deletions(-)

diff -puN drivers/rtc/rtc-tegra.c~drivers-rtc-rtc-tegrac-clean-up-probe-remove-routines drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~drivers-rtc-rtc-tegrac-clean-up-probe-remove-routines
+++ a/drivers/rtc/rtc-tegra.c
@@ -309,7 +309,8 @@ static int __devinit tegra_rtc_probe(str
 	struct resource *res;
 	int ret;
 
-	info = kzalloc(sizeof(struct tegra_rtc_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct tegra_rtc_info),
+		GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
@@ -317,29 +318,18 @@ static int __devinit tegra_rtc_probe(str
 	if (!res) {
 		dev_err(&pdev->dev,
 			"Unable to allocate resources for device.\n");
-		ret = -EBUSY;
-		goto err_free_info;
+		return -EBUSY;
 	}
 
-	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
-		dev_err(&pdev->dev,
-			"Unable to request mem region for device.\n");
-		ret = -EBUSY;
-		goto err_free_info;
+	info->rtc_base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!info->rtc_base) {
+		dev_err(&pdev->dev, "Unable to request mem region and grab IOs for device.\n");
+		return -EBUSY;
 	}
 
 	info->tegra_rtc_irq = platform_get_irq(pdev, 0);
-	if (info->tegra_rtc_irq <= 0) {
-		ret = -EBUSY;
-		goto err_release_mem_region;
-	}
-
-	info->rtc_base = ioremap_nocache(res->start, resource_size(res));
-	if (!info->rtc_base) {
-		dev_err(&pdev->dev, "Unable to grab IOs for device.\n");
-		ret = -EBUSY;
-		goto err_release_mem_region;
-	}
+	if (info->tegra_rtc_irq <= 0)
+		return -EBUSY;
 
 	/* set context info. */
 	info->pdev = pdev;
@@ -362,11 +352,12 @@ static int __devinit tegra_rtc_probe(str
 		dev_err(&pdev->dev,
 			"Unable to register device (err=%d).\n",
 			ret);
-		goto err_iounmap;
+		return ret;
 	}
 
-	ret = request_irq(info->tegra_rtc_irq, tegra_rtc_irq_handler,
-		IRQF_TRIGGER_HIGH, "rtc alarm", &pdev->dev);
+	ret = devm_request_irq(&pdev->dev, info->tegra_rtc_irq,
+			tegra_rtc_irq_handler, IRQF_TRIGGER_HIGH,
+			"rtc alarm", &pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev,
 			"Unable to request interrupt for device (err=%d).\n",
@@ -380,12 +371,6 @@ static int __devinit tegra_rtc_probe(str
 
 err_dev_unreg:
 	rtc_device_unregister(info->rtc_dev);
-err_iounmap:
-	iounmap(info->rtc_base);
-err_release_mem_region:
-	release_mem_region(res->start, resource_size(res));
-err_free_info:
-	kfree(info);
 
 	return ret;
 }
@@ -393,17 +378,8 @@ err_free_info:
 static int __devexit tegra_rtc_remove(struct platform_device *pdev)
 {
 	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
-	struct resource *res;

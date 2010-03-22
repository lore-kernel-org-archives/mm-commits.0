From: akpm@linux-foundation.org
Subject: + davinci-mmc-updates-to-suspend-resume-implementation.patch added to -mm tree
Date: Mon, 22 Mar 2010 12:40:05 -0700
Message-ID: <201003221940.o2MJe6aw023160__33481.963692657$1269286849$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755995Ab0CVTkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 15:40:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chaithrika@ti.com, khilman@deeprootsystems.com, linux-mmc@vger.kernel.org, sudhakar.raj@ti.com, vipin.bhandari@ti.com


The patch titled
     davinci: mmc: updates to suspend/resume implementation
has been added to the -mm tree.  Its filename is
     davinci-mmc-updates-to-suspend-resume-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: davinci: mmc: updates to suspend/resume implementation
From: Chaithrika U S <chaithrika@ti.com>

Improve the suspend and resume callbacks in DaVinci MMC host controller
driver.  Modify the reset status of the contorller and clock during
suspend and resume.  Also migrate the power management callbacks from
platform driver to dev_pm_ops structure.

Tested on DA850/OMAP-L138 EVM.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Vipin Bhandari <vipin.bhandari@ti.com>
Cc: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/davinci_mmc.c |   51 ++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 8 deletions(-)

diff -puN drivers/mmc/host/davinci_mmc.c~davinci-mmc-updates-to-suspend-resume-implementation drivers/mmc/host/davinci_mmc.c
--- a/drivers/mmc/host/davinci_mmc.c~davinci-mmc-updates-to-suspend-resume-implementation
+++ a/drivers/mmc/host/davinci_mmc.c
@@ -171,6 +171,7 @@ struct mmc_davinci_host {
 #define DAVINCI_MMC_DATADIR_READ	1
 #define DAVINCI_MMC_DATADIR_WRITE	2
 	unsigned char data_dir;
+	unsigned char suspended;
 
 	/* buffer is used during PIO of one scatterlist segment, and
 	 * is updated along with buffer_bytes_left.  bytes_left applies
@@ -1332,32 +1333,66 @@ static int __exit davinci_mmcsd_remove(s
 }
 
 #ifdef CONFIG_PM
-static int davinci_mmcsd_suspend(struct platform_device *pdev, pm_message_t msg)
+static int davinci_mmcsd_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
+	struct pm_message msg = { PM_EVENT_SUSPEND };
+	int ret;
 
-	return mmc_suspend_host(host->mmc, msg);
+	mmc_host_enable(host->mmc);
+	ret = mmc_suspend_host(host->mmc, msg);
+	if (!ret) {
+		writel(0, host->base + DAVINCI_MMCIM);
+		mmc_davinci_reset_ctrl(host, 1);
+		mmc_host_disable(host->mmc);
+		clk_disable(host->clk);
+		host->suspended = 1;
+	} else {
+		host->suspended = 0;
+		mmc_host_disable(host->mmc);
+	}
+
+	return ret;
 }
 
-static int davinci_mmcsd_resume(struct platform_device *pdev)
+static int davinci_mmcsd_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
+	int ret;
 
-	return mmc_resume_host(host->mmc);
+	if (!host->suspended)
+		return 0;
+
+	clk_enable(host->clk);
+	mmc_host_enable(host->mmc);
+
+	mmc_davinci_reset_ctrl(host, 0);
+	ret = mmc_resume_host(host->mmc);
+	if (!ret)
+		host->suspended = 0;
+
+	return ret;
 }
+
+static struct dev_pm_ops davinci_mmcsd_pm = {
+	.suspend        = davinci_mmcsd_suspend,
+	.resume         = davinci_mmcsd_resume,
+};
+
+#define davinci_mmcsd_pm_ops (&davinci_mmcsd_pm)
 #else
-#define davinci_mmcsd_suspend	NULL
-#define davinci_mmcsd_resume	NULL
+#define davinci_mmcsd_pm_ops NULL
 #endif
 
 static struct platform_driver davinci_mmcsd_driver = {
 	.driver		= {
 		.name	= "davinci_mmc",
 		.owner	= THIS_MODULE,
+		.pm	= davinci_mmcsd_pm_ops,
 	},
 	.remove		= __exit_p(davinci_mmcsd_remove),
-	.suspend	= davinci_mmcsd_suspend,
-	.resume		= davinci_mmcsd_resume,
 };
 
 static int __init davinci_mmcsd_init(void)
_

Patches currently in -mm which might be from chaithrika@ti.com are

linux-next.patch
davinci-mmc-add-a-function-to-control-reset-state-of-the-controller.patch
davinci-mmc-updates-to-suspend-resume-implementation.patch


From: akpm@linux-foundation.org
Subject: + mmc-omap-hs-mmc-convert-to-dev_pm_ops.patch added to -mm tree
Date: Wed, 12 May 2010 13:45:51 -0700
Message-ID: <201005122045.o4CKjpRY019402__6927.73154373771$1273697175$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820Ab0ELUqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 16:46:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khilman@deeprootsystems.com, adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, linux-mmc@vger.kernel.org, madhu.cr@ti.com, matt@console-pimps.org, tony@atomide.com


The patch titled
     mmc: OMAP HS-MMC: convert to dev_pm_ops
has been added to the -mm tree.  Its filename is
     mmc-omap-hs-mmc-convert-to-dev_pm_ops.patch

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
Subject: mmc: OMAP HS-MMC: convert to dev_pm_ops
From: Kevin Hilman <khilman@deeprootsystems.com>

Convert PM operations to use dev_pm_ops.  This will facilitate the runtime
PM coversion which will add to dev_pm_ops hooks.

Note that dev_pm_ops version of the suspend hook no longer takes a 'state'
argument.  However, the MMC core function mmc_suspend_host() still takes a
'state' argument, but it is unused, so a dummy state variable was created
to pass to the MMC core.

In the future, the MMC core should be converted to drop this state
argument and the rest of the MMC drivers could be easily converted to
dev_pm_ops as well.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Madhusudhan Chikkature <madhu.cr@ti.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~mmc-omap-hs-mmc-convert-to-dev_pm_ops drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~mmc-omap-hs-mmc-convert-to-dev_pm_ops
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -2267,10 +2267,12 @@ static int omap_hsmmc_remove(struct plat
 }
 
 #ifdef CONFIG_PM
-static int omap_hsmmc_suspend(struct platform_device *pdev, pm_message_t state)
+static int omap_hsmmc_suspend(struct device *dev)
 {
 	int ret = 0;
+	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_hsmmc_host *host = platform_get_drvdata(pdev);
+	pm_message_t state = PMSG_SUSPEND; /* unused by MMC core */
 
 	if (host && host->suspended)
 		return 0;
@@ -2316,9 +2318,10 @@ static int omap_hsmmc_suspend(struct pla
 }
 
 /* Routine to resume the MMC device */
-static int omap_hsmmc_resume(struct platform_device *pdev)
+static int omap_hsmmc_resume(struct device *dev)
 {
 	int ret = 0;
+	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_hsmmc_host *host = platform_get_drvdata(pdev);
 
 	if (host && !host->suspended)
@@ -2369,13 +2372,17 @@ clk_en_err:
 #define omap_hsmmc_resume		NULL
 #endif
 
-static struct platform_driver omap_hsmmc_driver = {
-	.remove		= omap_hsmmc_remove,
+static struct dev_pm_ops omap_hsmmc_dev_pm_ops = {
 	.suspend	= omap_hsmmc_suspend,
 	.resume		= omap_hsmmc_resume,
+};
+
+static struct platform_driver omap_hsmmc_driver = {
+	.remove		= omap_hsmmc_remove,
 	.driver		= {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
+		.pm = &omap_hsmmc_dev_pm_ops,
 	},
 };
 
_

Patches currently in -mm which might be from khilman@deeprootsystems.com are

linux-next.patch
davinci-mmc-pass-number-of-sg-segments-as-platform-data.patch
davinci-mmc-add-a-function-to-control-reset-state-of-the-controller.patch
davinci-mmc-updates-to-suspend-resume-implementation.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
mmc-omap-hs-mmc-convert-to-dev_pm_ops.patch


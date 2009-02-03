From: akpm@linux-foundation.org
Subject: [merged] ricoh_mmc-use-suspend-resume_noirq-v2.patch removed from -mm tree
Date: Tue, 03 Feb 2009 11:54:31 -0800
Message-ID: <200902031954.n13JsV7H027101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752065AbZBCTzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 14:55:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipl@overt.org, drzeus@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     ricoh_mmc: Use suspend/resume_noirq
has been removed from the -mm tree.  Its filename was
     ricoh_mmc-use-suspend-resume_noirq-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ricoh_mmc: Use suspend/resume_noirq
From: Philip Langdale <philipl@overt.org>

If ricoh_mmc suspends before sdhci_pci, it will pull the card out from
under the controller, which could leave the system in a very confused
state.

Using suspend/resume_noirq ensures that sdhci_pci suspends first and
resumes second.

Signed-off-by: Philip Langdale <philipl@overt.org>
Acked-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/ricoh_mmc.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/host/ricoh_mmc.c~ricoh_mmc-use-suspend-resume_noirq-v2 drivers/mmc/host/ricoh_mmc.c
--- a/drivers/mmc/host/ricoh_mmc.c~ricoh_mmc-use-suspend-resume_noirq-v2
+++ a/drivers/mmc/host/ricoh_mmc.c
@@ -196,10 +196,14 @@ static void __devexit ricoh_mmc_remove(s
 	pci_set_drvdata(pdev, NULL);
 }
 
-static int ricoh_mmc_suspend(struct pci_dev *pdev, pm_message_t state)
+static int ricoh_mmc_suspend_noirq(struct device *dev)
 {
+	struct pci_dev *pdev = NULL;
 	struct pci_dev *fw_dev = NULL;
 
+	pdev = to_pci_dev(dev);
+	BUG_ON(pdev == NULL);
+
 	fw_dev = pci_get_drvdata(pdev);
 	BUG_ON(fw_dev == NULL);
 
@@ -210,10 +214,14 @@ static int ricoh_mmc_suspend(struct pci_
 	return 0;
 }
 
-static int ricoh_mmc_resume(struct pci_dev *pdev)
+static int ricoh_mmc_resume_noirq(struct device *dev)
 {
+	struct pci_dev *pdev = NULL;
 	struct pci_dev *fw_dev = NULL;
 
+	pdev = to_pci_dev(dev);
+	BUG_ON(pdev == NULL);
+
 	fw_dev = pci_get_drvdata(pdev);
 	BUG_ON(fw_dev == NULL);
 
@@ -224,13 +232,17 @@ static int ricoh_mmc_resume(struct pci_d
 	return 0;
 }
 
+static struct dev_pm_ops ricoh_mmc_pm_opts = {
+	.suspend_noirq =	ricoh_mmc_suspend_noirq,
+	.resume_noirq =		ricoh_mmc_resume_noirq,
+};
+
 static struct pci_driver ricoh_mmc_driver = {
 	.name = 	DRIVER_NAME,
 	.id_table =	pci_ids,
 	.probe = 	ricoh_mmc_probe,
 	.remove =	__devexit_p(ricoh_mmc_remove),
-	.suspend =	ricoh_mmc_suspend,
-	.resume =	ricoh_mmc_resume,
+	.driver.pm =	&ricoh_mmc_pm_opts,
 };
 
 /*****************************************************************************\
_

Patches currently in -mm which might be from philipl@overt.org are

origin.patch


From: akpm@linux-foundation.org
Subject: + ricoh_mmc-use-suspend-resume_noirq.patch added to -mm tree
Date: Tue, 02 Dec 2008 18:11:20 -0800
Message-ID: <200812030211.mB32BK3H000744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421AbYLCCMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 21:12:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipl@overt.org, drzeus@drzeus.cx


The patch titled
     ricoh_mmc: use suspend/resume_noirq
has been added to the -mm tree.  Its filename is
     ricoh_mmc-use-suspend-resume_noirq.patch

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
Subject: ricoh_mmc: use suspend/resume_noirq
From: Philip Langdale <philipl@overt.org>

If ricoh_mmc suspends before sdhci_pci, it will pull the card out from
under the controller, which could leave the system in a very confused
state.

Using suspend/resume_noirq ensures that sdhci_pci suspends first and
resumes second.

Signed-off-by: Philip Langdale <philipl@overt.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/ricoh_mmc.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/host/ricoh_mmc.c~ricoh_mmc-use-suspend-resume_noirq drivers/mmc/host/ricoh_mmc.c
--- a/drivers/mmc/host/ricoh_mmc.c~ricoh_mmc-use-suspend-resume_noirq
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
 
+static struct pm_ext_ops ricoh_mmc_pm_ext_opts = {
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
+	.pm =		&ricoh_mmc_pm_ext_opts,
 };
 
 /*****************************************************************************\
_

Patches currently in -mm which might be from philipl@overt.org are

linux-next.patch
ricoh_mmc-handle-newer-models-of-ricoh-controllers.patch
ricoh_mmc-use-suspend-resume_noirq.patch


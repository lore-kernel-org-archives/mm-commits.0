From: akpm@linux-foundation.org
Subject: - reorder-suspend-resume-code.patch removed from -mm tree
Date: Thu, 05 Jun 2008 11:21:37 -0700
Message-ID: <200806051821.m55ILbj6023240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbYFESVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 14:21:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ranma+kernel@tdiedrich.de, aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: reorder suspend/resume code
has been removed from the -mm tree.  Its filename was
     reorder-suspend-resume-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: forcedeth: reorder suspend/resume code
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>

Match the suspend/resume code ordering in e100/e1000e more closely.  For
example the configuration space should be saved on suspend even for
devices that are not up.

Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff -puN drivers/net/forcedeth.c~reorder-suspend-resume-code drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~reorder-suspend-resume-code
+++ a/drivers/net/forcedeth.c
@@ -5800,22 +5800,20 @@ static int nv_suspend(struct pci_dev *pd
 	u8 __iomem *base = get_hwbase(dev);
 	int i;
 
-	if (!netif_running(dev))
-		goto out;
-
+	if (netif_running(dev)) {
+		// Gross.
+		nv_close(dev);
+	}
 	netif_device_detach(dev);
 
-	// Gross.
-	nv_close(dev);
-
 	/* save non-pci configuration space */
 	for (i = 0;i <= np->register_size/sizeof(u32); i++)
 		np->saved_config_space[i] = readl(base + i*sizeof(u32));
 
 	pci_save_state(pdev);
 	pci_enable_wake(pdev, pci_choose_state(pdev, state), np->wolenabled);
+	pci_disable_device(pdev);
 	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-out:
 	return 0;
 }
 
@@ -5826,22 +5824,20 @@ static int nv_resume(struct pci_dev *pde
 	u8 __iomem *base = get_hwbase(dev);
 	int i, rc = 0;
 
-	if (!netif_running(dev))
-		goto out;
-
-	netif_device_attach(dev);
-
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
+	/* ack any pending wake events, disable PME */
 	pci_enable_wake(pdev, PCI_D0, 0);
 
 	/* restore non-pci configuration space */
 	for (i = 0;i <= np->register_size/sizeof(u32); i++)
 		writel(np->saved_config_space[i], base+i*sizeof(u32));
 
-	rc = nv_open(dev);
-	nv_set_multicast(dev);
-out:
+	netif_device_attach(dev);
+	if (netif_running(dev)) {
+		rc = nv_open(dev);
+		nv_set_multicast(dev);
+	}
 	return rc;
 }
 
_

Patches currently in -mm which might be from ranma+kernel@tdiedrich.de are

linux-next.patch


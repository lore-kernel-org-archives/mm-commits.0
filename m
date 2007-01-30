From: akpm@osdl.org
Subject: - broadcom-4400-resume-small-fix-v2.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:47:41 -0800
Message-ID: <200701302147.l0ULlfQ2030198@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51972 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbXA3Vrn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:47:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Broadcom 4400 resume small fix
has been removed from the -mm tree.  Its filename was
     broadcom-4400-resume-small-fix-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Broadcom 4400 resume small fix
From: Dmitriy Monakhov <dmonakhov@openvz.org>

Some issues in b44_resume().

- Return value of pci_enable_device() was ignored.

- If request_irq() has failed we have to just disable device and exit.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/b44.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/net/b44.c~broadcom-4400-resume-small-fix-v2 drivers/net/b44.c
--- a/drivers/net/b44.c~broadcom-4400-resume-small-fix-v2
+++ a/drivers/net/b44.c
@@ -2320,16 +2320,27 @@ static int b44_resume(struct pci_dev *pd
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct b44 *bp = netdev_priv(dev);
+	int rc = 0;
 
 	pci_restore_state(pdev);
-	pci_enable_device(pdev);
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		printk(KERN_ERR PFX "%s: pci_enable_device failed\n",
+			dev->name);
+		return rc;
+	}
+
 	pci_set_master(pdev);
 
 	if (!netif_running(dev))
 		return 0;
 
-	if (request_irq(dev->irq, b44_interrupt, IRQF_SHARED, dev->name, dev))
+	rc = request_irq(dev->irq, b44_interrupt, IRQF_SHARED, dev->name, dev);
+	if (rc) {
 		printk(KERN_ERR PFX "%s: request_irq failed\n", dev->name);
+		pci_disable_device(pdev);
+		return rc;
+	}
 
 	spin_lock_irq(&bp->lock);
 
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

origin.patch
ext-jbd-layer-function-called-instead-of-fs-specific-one.patch

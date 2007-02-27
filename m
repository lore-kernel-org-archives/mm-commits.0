From: akpm@linux-foundation.org
Subject: + 3c59x-handle-pci_enable_device-failure-while-resuming.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:48:03 -0800
Message-ID: <200702272048.l1RKm79S028000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51137 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbXB0Usr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:48:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@sw.ru, dmonakhov@openvz.org


The patch titled
     3c59x: Handle pci_enable_device() failure while resuming
has been added to the -mm tree.  Its filename is
     3c59x-handle-pci_enable_device-failure-while-resuming.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 3c59x: Handle pci_enable_device() failure while resuming
From: Dmitriy Monakhov <dmonakhov@sw.ru>

Handle pci_enable_device() failure while resuming, we can safely exit here.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c59x.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/net/3c59x.c~3c59x-handle-pci_enable_device-failure-while-resuming drivers/net/3c59x.c
--- a/drivers/net/3c59x.c~3c59x-handle-pci_enable_device-failure-while-resuming
+++ a/drivers/net/3c59x.c
@@ -822,11 +822,17 @@ static int vortex_resume(struct pci_dev 
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct vortex_private *vp = netdev_priv(dev);
+	int err;
 
 	if (dev && vp) {
 		pci_set_power_state(pdev, PCI_D0);
 		pci_restore_state(pdev);
-		pci_enable_device(pdev);
+		err = pci_enable_device(pdev);
+		if (err) {
+			printk(KERN_WARNING "%s: Could not enable device \n",
+				dev->name);
+			return err;
+		}
 		pci_set_master(pdev);
 		if (request_irq(dev->irq, vp->full_bus_master_rx ?
 				&boomerang_interrupt : &vortex_interrupt, IRQF_SHARED, dev->name, dev)) {
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch
3c59x-handle-pci_enable_device-failure-while-resuming.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch

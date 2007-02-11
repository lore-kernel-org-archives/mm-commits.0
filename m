From: akpm@linux-foundation.org
Subject: - ioc3-ioc4-pci-mem-space-resources.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:50:22 -0800
Message-ID: <200702112250.l1BMoMOR015852@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60384 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932818AbXBKWxm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:53:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcasavan@sgi.com, pfg@sgi.com, ralf@linux-mips.org, skylark@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     IOC3/IOC4: PCI mem space resources
has been removed from the -mm tree.  Its filename was
     ioc3-ioc4-pci-mem-space-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IOC3/IOC4: PCI mem space resources
From: Brent Casavant <bcasavan@sgi.com>

The SGI IOC3 and IOC4 PCI devices implement memory space apertures, not I/O
space apertures.  Use the appropriate region management functions.

Signed-off-by: Brent Casavant <bcasavan@sgi.com>
Cc: Pat Gefre <pfg@sgi.com>
Cc: Stanislaw Skowronek <skylark@linux-mips.org>
Cc: Brent Casavant <bcasavan@sgi.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ioc4.c          |    6 +++---
 drivers/serial/ioc4_serial.c |    6 +++---
 drivers/sn/ioc3.c            |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/misc/ioc4.c~ioc3-ioc4-pci-mem-space-resources drivers/misc/ioc4.c
--- a/drivers/misc/ioc4.c~ioc3-ioc4-pci-mem-space-resources
+++ a/drivers/misc/ioc4.c
@@ -309,7 +309,7 @@ ioc4_probe(struct pci_dev *pdev, const s
 		ret = -ENODEV;
 		goto out_pci;
 	}
-	if (!request_region(idd->idd_bar0, sizeof(struct ioc4_misc_regs),
+	if (!request_mem_region(idd->idd_bar0, sizeof(struct ioc4_misc_regs),
 			    "ioc4_misc")) {
 		printk(KERN_WARNING
 		       "%s: Unable to request IOC4 misc region "
@@ -379,7 +379,7 @@ ioc4_probe(struct pci_dev *pdev, const s
 	return 0;
 
 out_misc_region:
-	release_region(idd->idd_bar0, sizeof(struct ioc4_misc_regs));
+	release_mem_region(idd->idd_bar0, sizeof(struct ioc4_misc_regs));
 out_pci:
 	kfree(idd);
 out_idd:
@@ -418,7 +418,7 @@ ioc4_remove(struct pci_dev *pdev)
 		       "Device removal may be incomplete.\n",
 		       __FUNCTION__, pci_name(idd->idd_pdev));
 	}
-	release_region(idd->idd_bar0, sizeof(struct ioc4_misc_regs));
+	release_mem_region(idd->idd_bar0, sizeof(struct ioc4_misc_regs));
 
 	/* Disable IOC4 and relinquish */
 	pci_disable_device(pdev);
diff -puN drivers/serial/ioc4_serial.c~ioc3-ioc4-pci-mem-space-resources drivers/serial/ioc4_serial.c
--- a/drivers/serial/ioc4_serial.c~ioc3-ioc4-pci-mem-space-resources
+++ a/drivers/serial/ioc4_serial.c
@@ -2685,7 +2685,7 @@ static int ioc4_serial_remove_one(struct
 		free_irq(control->ic_irq, soft);
 		if (soft->is_ioc4_serial_addr) {
 			iounmap(soft->is_ioc4_serial_addr);
-			release_region((unsigned long)
+			release_mem_region((unsigned long)
 			     soft->is_ioc4_serial_addr,
 				sizeof(struct ioc4_serial));
 		}
@@ -2790,7 +2790,7 @@ ioc4_serial_attach_one(struct ioc4_drive
 	/* request serial registers */
 	tmp_addr1 = idd->idd_bar0 + IOC4_SERIAL_OFFSET;
 
-	if (!request_region(tmp_addr1, sizeof(struct ioc4_serial),
+	if (!request_mem_region(tmp_addr1, sizeof(struct ioc4_serial),
 					"sioc4_uart")) {
 		printk(KERN_WARNING
 			"ioc4 (%p): unable to get request region for "
@@ -2889,7 +2889,7 @@ out3:
 out2:
 	if (serial)
 		iounmap(serial);
-	release_region(tmp_addr1, sizeof(struct ioc4_serial));
+	release_mem_region(tmp_addr1, sizeof(struct ioc4_serial));
 out1:
 
 	return ret;
diff -puN drivers/sn/ioc3.c~ioc3-ioc4-pci-mem-space-resources drivers/sn/ioc3.c
--- a/drivers/sn/ioc3.c~ioc3-ioc4-pci-mem-space-resources
+++ a/drivers/sn/ioc3.c
@@ -654,7 +654,7 @@ static int ioc3_probe(struct pci_dev *pd
 		ret = -ENODEV;
 		goto out_pci;
 	}
-	if (!request_region(idd->pma, IOC3_PCI_SIZE, "ioc3")) {
+	if (!request_mem_region(idd->pma, IOC3_PCI_SIZE, "ioc3")) {
 		printk(KERN_WARNING
 		       "%s: Unable to request IOC3 region "
 		       "for pci_dev %s.\n",
@@ -744,7 +744,7 @@ static int ioc3_probe(struct pci_dev *pd
 	return 0;
 
 out_misc_region:
-	release_region(idd->pma, IOC3_PCI_SIZE);
+	release_mem_region(idd->pma, IOC3_PCI_SIZE);
 out_pci:
 	kfree(idd);
 out_idd:
@@ -785,7 +785,7 @@ static void ioc3_remove(struct pci_dev *
 	if(idd->dual_irq)
 		free_irq(idd->irq_eth, (void *)idd);
 	iounmap(idd->vma);
-	release_region(idd->pma, IOC3_PCI_SIZE);
+	release_mem_region(idd->pma, IOC3_PCI_SIZE);
 
 	/* Disable IOC3 and relinquish */
 	pci_disable_device(pdev);
_

Patches currently in -mm which might be from bcasavan@sgi.com are

origin.patch

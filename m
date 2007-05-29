From: akpm@linux-foundation.org
Subject: - misc-phantom-take-care-of-pci-posting.patch removed from -mm tree
Date: Tue, 29 May 2007 11:52:08 -0700
Message-ID: <200705291852.l4TIq7N4008376@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758017AbXE2Swa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:52:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Misc: phantom, take care of pci posting
has been removed from the -mm tree.  Its filename was
     misc-phantom-take-care-of-pci-posting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Misc: phantom, take care of pci posting
From: Jiri Slaby <jirislaby@gmail.com>

phantom, take care of pci posting

thanks to akpm for pointing this out

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/phantom.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/misc/phantom.c~misc-phantom-take-care-of-pci-posting drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~misc-phantom-take-care-of-pci-posting
+++ a/drivers/misc/phantom.c
@@ -60,8 +60,11 @@ static int phantom_status(struct phantom
 		atomic_set(&dev->counter, 0);
 		iowrite32(PHN_CTL_IRQ, dev->iaddr + PHN_CONTROL);
 		iowrite32(0x43, dev->caddr + PHN_IRQCTL);
-	} else if ((dev->status & PHB_RUNNING) && !(newstat & PHB_RUNNING))
+		ioread32(dev->caddr + PHN_IRQCTL); /* PCI posting */
+	} else if ((dev->status & PHB_RUNNING) && !(newstat & PHB_RUNNING)) {
 		iowrite32(0, dev->caddr + PHN_IRQCTL);
+		ioread32(dev->caddr + PHN_IRQCTL); /* PCI posting */
+	}
 
 	dev->status = newstat;
 
@@ -102,6 +105,7 @@ static long phantom_ioctl(struct file *f
 
 		pr_debug("phantom: writing %x to %u\n", r.value, r.reg);
 		iowrite32(r.value, dev->iaddr + r.reg);
+		ioread32(dev->iaddr); /* PCI posting */
 
 		if (r.reg == PHN_CONTROL && !(r.value & PHN_CTL_IRQ))
 			phantom_status(dev, dev->status & ~PHB_RUNNING);
@@ -116,6 +120,7 @@ static long phantom_ioctl(struct file *f
 		for (i = 0; i < min(rs.count, 8U); i++)
 			if ((1 << i) & rs.mask)
 				iowrite32(rs.values[i], dev->oaddr + i);
+		ioread32(dev->iaddr); /* PCI posting */
 		spin_unlock(&dev->ioctl_lock);
 		break;
 	case PHN_GET_REG:
@@ -221,6 +226,7 @@ static irqreturn_t phantom_isr(int irq, 
 
 	iowrite32(0, dev->iaddr);
 	iowrite32(0xc0, dev->iaddr);
+	ioread32(dev->iaddr); /* PCI posting */
 
 	atomic_inc(&dev->counter);
 	wake_up_interruptible(&dev->wait);
@@ -297,6 +303,7 @@ static int __devinit phantom_probe(struc
 	pht->cdev.owner = THIS_MODULE;
 
 	iowrite32(0, pht->caddr + PHN_IRQCTL);
+	ioread32(pht->caddr + PHN_IRQCTL); /* PCI posting */
 	retval = request_irq(pdev->irq, phantom_isr,
 			IRQF_SHARED | IRQF_DISABLED, "phantom", pht);
 	if (retval) {
@@ -347,6 +354,7 @@ static void __devexit phantom_remove(str
 	cdev_del(&pht->cdev);
 
 	iowrite32(0, pht->caddr + PHN_IRQCTL);
+	ioread32(pht->caddr + PHN_IRQCTL); /* PCI posting */
 	free_irq(pdev->irq, pht);
 
 	pci_iounmap(pdev, pht->oaddr);
@@ -368,6 +376,7 @@ static int phantom_suspend(struct pci_de
 	struct phantom_device *dev = pci_get_drvdata(pdev);
 
 	iowrite32(0, dev->caddr + PHN_IRQCTL);
+	ioread32(dev->caddr + PHN_IRQCTL); /* PCI posting */
 
 	return 0;
 }
_

Patches currently in -mm which might be from jirislaby@gmail.com are

rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
shrink_slab-handle-bad-shrinkers.patch

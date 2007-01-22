From: akpm@osdl.org
Subject: - hpt3xx-switch-to-using-pci_get_slot.patch removed from -mm tree
Date: Mon, 22 Jan 2007 13:10:51 -0800
Message-ID: <200701222110.l0MLApxu002186@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52974 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932697AbXAVVRW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 16:17:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     HPT3xx: switch to using pci_get_slot()
has been removed from the -mm tree.  Its filename was
     hpt3xx-switch-to-using-pci_get_slot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: HPT3xx: switch to using pci_get_slot()
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Switch to using pci_get_slot() to get to the function 1 of HPT36x/374 chips --
there's no need for the driver itself to walk the list of the PCI devices, and
it also forgets to check the bus number of the device found.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/hpt366.c |   61 ++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

diff -puN drivers/ide/pci/hpt366.c~hpt3xx-switch-to-using-pci_get_slot drivers/ide/pci/hpt366.c
--- a/drivers/ide/pci/hpt366.c~hpt3xx-switch-to-using-pci_get_slot
+++ a/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 0.44	May 20, 2006
+ * linux/drivers/ide/pci/hpt366.c		Version 0.45	May 27, 2006
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -79,6 +79,7 @@
  * - prefix the driver startup messages with the real chip name
  * - claim the extra 240 bytes of I/O space for all chips
  * - optimize the rate masking/filtering and the drive list lookup code
+ * - use pci_get_slot() to get to the function 1 of HPT36x/374
  *		<source@mvista.com>
  *
  */
@@ -1416,24 +1417,24 @@ static void __devinit init_iops_hpt366(i
 
 static int __devinit init_setup_hpt374(struct pci_dev *dev, ide_pci_device_t *d)
 {
-	struct pci_dev *findev = NULL;
+	struct pci_dev *dev2;
 
 	if (PCI_FUNC(dev->devfn) & 1)
 		return -ENODEV;
 
-	while ((findev = pci_find_device(PCI_ANY_ID, PCI_ANY_ID, findev)) != NULL) {
-		if ((findev->vendor == dev->vendor) &&
-		    (findev->device == dev->device) &&
-		    ((findev->devfn - dev->devfn) == 1) &&
-		    (PCI_FUNC(findev->devfn) & 1)) {
-			if (findev->irq != dev->irq) {
-				/* FIXME: we need a core pci_set_interrupt() */
-				findev->irq = dev->irq;
-				printk(KERN_WARNING "%s: pci-config space interrupt "
-					"fixed.\n", d->name);
-			}
-			return ide_setup_pci_devices(dev, findev, d);
+	if ((dev2 = pci_get_slot(dev->bus, dev->devfn + 1)) != NULL) {
+		int ret;
+
+		if (dev2->irq != dev->irq) {
+			/* FIXME: we need a core pci_set_interrupt() */
+			dev2->irq = dev->irq;
+			printk(KERN_WARNING "%s: PCI config space interrupt "
+			       "fixed.\n", d->name);
 		}
+		ret = ide_setup_pci_devices(dev, dev2, d);
+		if (ret < 0)
+			pci_dev_put(dev2);
+		return ret;
 	}
 	return ide_setup_pci_device(dev, d);
 }
@@ -1491,8 +1492,8 @@ static int __devinit init_setup_hpt302(s
 
 static int __devinit init_setup_hpt366(struct pci_dev *dev, ide_pci_device_t *d)
 {
-	struct pci_dev *findev = NULL;
-	u8 rev = 0, pin1 = 0, pin2 = 0;
+	struct pci_dev *dev2;
+	u8 rev = 0;
 	static char   *chipset_names[] = { "HPT366", "HPT366",  "HPT368",
 					   "HPT370", "HPT370A", "HPT372",
 					   "HPT372N" };
@@ -1512,21 +1513,21 @@ static int __devinit init_setup_hpt366(s
 
 	d->channels = 1;
 
-	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin1);
-	while ((findev = pci_find_device(PCI_ANY_ID, PCI_ANY_ID, findev)) != NULL) {
-		if ((findev->vendor == dev->vendor) &&
-		    (findev->device == dev->device) &&
-		    ((findev->devfn - dev->devfn) == 1) &&
-		    (PCI_FUNC(findev->devfn) & 1)) {
-			pci_read_config_byte(findev, PCI_INTERRUPT_PIN, &pin2);
-			if ((pin1 != pin2) && (dev->irq == findev->irq)) {
-				d->bootable = ON_BOARD;
-				printk("%s: onboard version of chipset, "
-					"pin1=%d pin2=%d\n", d->name,
-					pin1, pin2);
-			}
-			return ide_setup_pci_devices(dev, findev, d);
+	if ((dev2 = pci_get_slot(dev->bus, dev->devfn + 1)) != NULL) {
+	  	u8  pin1 = 0, pin2 = 0;
+		int ret;
+
+		pci_read_config_byte(dev,  PCI_INTERRUPT_PIN, &pin1);
+		pci_read_config_byte(dev2, PCI_INTERRUPT_PIN, &pin2);
+		if (pin1 != pin2 && dev->irq == dev2->irq) {
+			d->bootable = ON_BOARD;
+			printk("%s: onboard version of chipset, pin1=%d pin2=%d\n",
+			       d->name, pin1, pin2);
 		}
+		ret = ide_setup_pci_devices(dev, dev2, d);
+		if (ret < 0)
+			pci_dev_put(dev2);
+		return ret;
 	}
 init_single:
 	return ide_setup_pci_device(dev, d);
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

git-mtd.patch
3x59x-fix-pci-resource-management.patch

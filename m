From: akpm@linux-foundation.org
Subject: - adjust-legacy-ide-resource-setting-v2.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:52:13 -0800
Message-ID: <200702282352.l1SNqDj0030976@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48222 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932624AbXB1XwW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:52:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     adjust legacy IDE resource setting (v2)
has been removed from the -mm tree.  Its filename was
     adjust-legacy-ide-resource-setting-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: adjust legacy IDE resource setting (v2)
From: "Jan Beulich" <jbeulich@novell.com>

The change to force legacy mode IDE channels' resources to fixed non-zero
values confuses (at least some versions of) X, because the values reported
by the kernel and those readable from PCI config space aren't consistent
anymore.  Therefore, this patch arranges for the respective BARs to also
get updated if possible.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |   45 +++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff -puN drivers/pci/probe.c~adjust-legacy-ide-resource-setting-v2 drivers/pci/probe.c
--- a/drivers/pci/probe.c~adjust-legacy-ide-resource-setting-v2
+++ a/drivers/pci/probe.c
@@ -682,7 +682,34 @@ static void pci_read_irq(struct pci_dev 
 	dev->irq = irq;
 }
 
-#define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
+static void change_legacy_io_resource(struct pci_dev * dev, unsigned index,
+                                      unsigned start, unsigned end)
+{
+	unsigned base = start & PCI_BASE_ADDRESS_IO_MASK;
+	unsigned len = (end | ~PCI_BASE_ADDRESS_IO_MASK) - base + 1;
+
+	/*
+	 * Some X versions get confused when the BARs reported through
+	 * /sys or /proc differ from those seen in config space, thus
+	 * try to update the config space values, too.
+	 */
+	if (!(pci_resource_flags(dev, index) & IORESOURCE_IO))
+		printk(KERN_WARNING "%s: cannot adjust BAR%u (not I/O)\n",
+		       pci_name(dev), index);
+	else if (pci_resource_len(dev, index) != len)
+		printk(KERN_WARNING "%s: cannot adjust BAR%u (size %04X)\n",
+		       pci_name(dev), index, (unsigned)pci_resource_len(dev, index));
+	else {
+		printk(KERN_INFO "%s: trying to change BAR%u from %04X to %04X\n",
+		       pci_name(dev), index,
+		       (unsigned)pci_resource_start(dev, index), base);
+		pci_write_config_dword(dev, PCI_BASE_ADDRESS_0 + index * 4, base);
+	}
+	pci_resource_start(dev, index) = start;
+	pci_resource_end(dev, index)   = end;
+	pci_resource_flags(dev, index) =
+		IORESOURCE_IO | IORESOURCE_PCI_FIXED | PCI_BASE_ADDRESS_SPACE_IO;
+}
 
 /**
  * pci_setup_device - fill in class and map information of a device
@@ -735,20 +762,12 @@ static int pci_setup_device(struct pci_d
 			u8 progif;
 			pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
 			if ((progif & 1) == 0) {
-				dev->resource[0].start = 0x1F0;
-				dev->resource[0].end = 0x1F7;
-				dev->resource[0].flags = LEGACY_IO_RESOURCE;
-				dev->resource[1].start = 0x3F6;
-				dev->resource[1].end = 0x3F6;
-				dev->resource[1].flags = LEGACY_IO_RESOURCE;
+				change_legacy_io_resource(dev, 0, 0x1F0, 0x1F7);
+				change_legacy_io_resource(dev, 1, 0x3F6, 0x3F6);
 			}
 			if ((progif & 4) == 0) {
-				dev->resource[2].start = 0x170;
-				dev->resource[2].end = 0x177;
-				dev->resource[2].flags = LEGACY_IO_RESOURCE;
-				dev->resource[3].start = 0x376;
-				dev->resource[3].end = 0x376;
-				dev->resource[3].flags = LEGACY_IO_RESOURCE;
+				change_legacy_io_resource(dev, 2, 0x170, 0x177);
+				change_legacy_io_resource(dev, 3, 0x376, 0x376);
 			}
 		}
 		break;
_

Patches currently in -mm which might be from jbeulich@novell.com are

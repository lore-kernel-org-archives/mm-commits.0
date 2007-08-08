From: akpm@linux-foundation.org
Subject: + pci-align-bar-settings-for-legacy-mode-ide.patch added to -mm tree
Date: Wed, 08 Aug 2007 01:07:05 -0700
Message-ID: <200708080807.l78875Su028194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57512 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753568AbXHHIHe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 04:07:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, greg@kroah.com, ktk@enterprise.bidmc.harvard.edu, protasnb@gmail.com


The patch titled
     pci: align BAR settings for legacy mode IDE
has been added to the -mm tree.  Its filename is
     pci-align-bar-settings-for-legacy-mode-ide.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci: align BAR settings for legacy mode IDE
From: Jan Beulich <jbeulich@novell.com>

Fix http://bugzilla.kernel.org/show_bug.cgi?id=8187

The change to force legacy mode IDE channels' resources to fixed non-zero
values confuses (at least some versions of) X, because the values reported by
the kernel and those readable from PCI config space aren't consistent anymore.
 Therefore, this patch arranges for the respective BARs to also get updated if
possible.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Kristofer T. Karas" <ktk@enterprise.bidmc.harvard.edu>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Natalie Protasevich <protasnb@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff -puN drivers/pci/probe.c~pci-align-bar-settings-for-legacy-mode-ide drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-align-bar-settings-for-legacy-mode-ide
+++ a/drivers/pci/probe.c
@@ -741,7 +741,31 @@ static void pci_read_irq(struct pci_dev 
 	dev->irq = irq;
 }
 
-#define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
+static void change_legacy_io_resource(struct pci_dev * dev, unsigned index,
+                                      unsigned start, unsigned end)
+{
+	unsigned base = start & PCI_BASE_ADDRESS_IO_MASK;
+	unsigned len = (end | ~PCI_BASE_ADDRESS_IO_MASK) - base + 1;
+
+	if (!(pci_resource_flags(dev, index) & IORESOURCE_IO)) {
+		printk(KERN_WARNING "%s: cannot adjust BAR%u (not I/O)\n",
+		       pci_name(dev), index);
+		return;
+	}
+	if (pci_resource_len(dev, index) != len)
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
@@ -795,20 +819,12 @@ static int pci_setup_device(struct pci_d
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

pci-align-bar-settings-for-legacy-mode-ide.patch
pci-align-bar-settings-for-legacy-mode-ide-fix.patch

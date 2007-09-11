From: akpm@linux-foundation.org
Subject: - fix-boot-time-hang-on-g31-g33-pc.patch removed from -mm tree
Date: Tue, 11 Sep 2007 13:20:55 -0700
Message-ID: <200709112020.l8BKKt2U027742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933761AbXIKUVf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 16:21:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, greg@kroah.com, grundler@parisc-linux.org, hancockr@shaw.ca, ink@jurassic.park.msu.ru, jesse.barnes@intel.com, mm-commits@vger.kernel.org


The patch titled
     Fix boot-time hang on G31/G33 PC
has been removed from the -mm tree.  Its filename was
     fix-boot-time-hang-on-g31-g33-pc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix boot-time hang on G31/G33 PC
From: Matthew Wilcox <matthew@wil.cx>

This patch, loosely based on a patch from Robert Hancock, which was in turn
based on a patch from Jesse Barnes, fixes a boot-time hang on my shiny new
PC.  The 'conflict' mentioned in the patch in my case happens to be between
mmconfig and the graphics card, but it could easily be between any pair of
devices if they are left enabled by the BIOS and mappen in the wrong place.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
Acked-by: Robert Hancock <hancockr@shaw.ca>
Acked-by: Jesse Barnes <jesse.barnes@intel.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN drivers/pci/probe.c~fix-boot-time-hang-on-g31-g33-pc drivers/pci/probe.c
--- a/drivers/pci/probe.c~fix-boot-time-hang-on-g31-g33-pc
+++ a/drivers/pci/probe.c
@@ -180,11 +180,26 @@ static inline int is_64bit_memory(u32 ma
 	return 0;
 }
 
+/*
+ * Sizing PCI BARs requires us to disable decoding, otherwise we may run
+ * into conflicts with other devices while trying to size the BAR.  Normally
+ * this isn't a problem, but it happens on some machines normally, and can
+ * happen on others during PCI device hotplug.  Don't disable BARs for host
+ * bridges, though.  Some of them do silly things like disable accesses to
+ * RAM from the CPU
+ */
 static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 {
 	unsigned int pos, reg, next;
 	u32 l, sz;
 	struct resource *res;
+	u16 orig_cmd;
+
+	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_HOST) {
+		pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
+		pci_write_config_word(dev, PCI_COMMAND,
+			orig_cmd & ~(PCI_COMMAND_MEMORY | PCI_COMMAND_IO));
+	}
 
 	for(pos=0; pos<howmany; pos = next) {
 		u64 l64;
@@ -283,6 +298,9 @@ static void pci_read_bases(struct pci_de
 			}
 		}
 	}
+
+	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_HOST)
+		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
 }
 
 void pci_read_bridge_bases(struct pci_bus *child)
_

Patches currently in -mm which might be from matthew@wil.cx are

fix-dac960-driver-on-machines-which-dont-support-64-bit-dma.patch
ptr_align.patch
git-scsi-misc.patch
drivers-scsi-advansysc-ld-error-re-2623-rc3-mm1.patch
make-sure-nobodys-leaking-resources.patch

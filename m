From: akpm@linux-foundation.org
Subject: + pci-disable-decode-of-io-memory-during-bar-sizing.patch added to -mm tree
Date: Mon, 04 Jun 2007 13:33:02 -0700
Message-ID: <200706042033.l54KX2Cj018154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32848 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbXFDUdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:33:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hancockr@shaw.ca, ak@suse.de, greg@kroah.com, jesse.barnes@intel.com


The patch titled
     PCI: disable decode of IO/memory during BAR sizing
has been added to the -mm tree.  Its filename is
     pci-disable-decode-of-io-memory-during-bar-sizing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PCI: disable decode of IO/memory during BAR sizing
From: Robert Hancock <hancockr@shaw.ca>

Change PCI BAR sizing to disable the decode of memory or IO, as
appropriate, while we are writing the all-ones value to the BAR to
determine the size.  If this is not done, the device may spuriously decode
accesses to memory areas it should not.  On some Intel PCI Express
chipsets, this breaks MMCONFIG configuration space access, since the memory
the graphics card ends up decoding during this period overlaps the MMCONFIG
area, and thus it steals the accesses to the area to do any other
configuration space access, including changing the BAR back to its previous
value.

However, don't do this disabling on host bridge devices, as it is reported that
some of them do silly things like disable CPU to RAM access if this is done.

Based on an original patch by Jesse Barnes.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Cc: Greg KH <greg@kroah.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jesse Barnes <jesse.barnes@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |   63 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 55 insertions(+), 8 deletions(-)

diff -puN drivers/pci/probe.c~pci-disable-decode-of-io-memory-during-bar-sizing drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-disable-decode-of-io-memory-during-bar-sizing
+++ a/drivers/pci/probe.c
@@ -169,6 +169,58 @@ static inline int is_64bit_memory(u32 ma
 	return 0;
 }
 
+#define BAR_IS_MEMORY(bar) (((bar) & PCI_BASE_ADDRESS_SPACE) ==	\
+			    PCI_BASE_ADDRESS_SPACE_MEMORY)
+
+/**
+ * pci_bar_size - get raw PCI BAR size
+ * @dev: PCI device
+ * @reg: BAR to probe
+ *
+ * Use basic PCI probing:
+ *   - save original BAR value
+ *   - disable MEM or IO decode in PCI_COMMAND reg if appropriate
+ *   - write all 1s to the BAR
+ *   - read back value
+ *   - reenble MEM or IO decode as necessary
+ *   - write original value back
+ *
+ * Returns raw BAR size to caller.
+ */
+static u32 pci_bar_size(struct pci_dev *dev, unsigned int reg)
+{
+	u32 orig_reg, sz;
+	u16 orig_cmd;
+
+	pci_read_config_dword(dev, reg, &orig_reg);
+	pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
+
+	/*
+	 * Disable memory or IO decode on the device while writing the test
+	 * value to the BAR. This prevents possible spurious decoding
+	 * of random addresses by the device. Don't do this for host bridges,
+	 * however, since some of them do silly things like disable CPU to RAM
+	 * access if this is done.
+	 */
+	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_HOST) {
+		if (BAR_IS_MEMORY(orig_reg))
+			pci_write_config_word(dev, PCI_COMMAND,
+					      orig_cmd & ~PCI_COMMAND_MEMORY);
+		else
+			pci_write_config_word(dev, PCI_COMMAND,
+					      orig_cmd & ~PCI_COMMAND_IO);
+	}
+
+	pci_write_config_dword(dev, reg, 0xffffffff);
+	pci_read_config_dword(dev, reg, &sz);
+	pci_write_config_dword(dev, reg, orig_reg);
+
+	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_HOST)
+		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
+
+	return sz;
+}
+
 static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 {
 	unsigned int pos, reg, next;
@@ -185,16 +237,13 @@ static void pci_read_bases(struct pci_de
 		res->name = pci_name(dev);
 		reg = PCI_BASE_ADDRESS_0 + (pos << 2);
 		pci_read_config_dword(dev, reg, &l);
-		pci_write_config_dword(dev, reg, ~0);
-		pci_read_config_dword(dev, reg, &sz);
-		pci_write_config_dword(dev, reg, l);
+		sz = pci_bar_size(dev, reg);
 		if (!sz || sz == 0xffffffff)
 			continue;
 		if (l == 0xffffffff)
 			l = 0;
 		raw_sz = sz;
-		if ((l & PCI_BASE_ADDRESS_SPACE) ==
-				PCI_BASE_ADDRESS_SPACE_MEMORY) {
+		if (BAR_IS_MEMORY(l)) {
 			sz = pci_size(l, sz, (u32)PCI_BASE_ADDRESS_MEM_MASK);
 			/*
 			 * For 64bit prefetchable memory sz could be 0, if the
@@ -218,9 +267,7 @@ static void pci_read_bases(struct pci_de
 			u32 szhi, lhi;
 
 			pci_read_config_dword(dev, reg+4, &lhi);
-			pci_write_config_dword(dev, reg+4, ~0);
-			pci_read_config_dword(dev, reg+4, &szhi);
-			pci_write_config_dword(dev, reg+4, lhi);
+			szhi = pci_bar_size(dev, reg+4);
 			sz64 = ((u64)szhi << 32) | raw_sz;
 			l64 = ((u64)lhi << 32) | l;
 			sz64 = pci_size64(l64, sz64, PCI_BASE_ADDRESS_MEM_MASK);
_

Patches currently in -mm which might be from hancockr@shaw.ca are

libata-add-human-readable-error-value-decoding.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
pci-disable-decode-of-io-memory-during-bar-sizing.patch

From: akpm@osdl.org
Subject: + pci-quirk-1k-i-o-space-iobl_adr-fix-on-p64h2.patch added to -mm tree
Date: Thu, 21 Dec 2006 13:29:47 -0800
Message-ID: <200612212129.kBLLTl8I005544@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42746 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423119AbWLUV3x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 16:29:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.yeisley@unisys.com, ak@suse.de, greg@kroah.com


The patch titled
     PCI Quirk: 1k I/O space IOBL_ADR fix on P64H2
has been added to the -mm tree.  Its filename is
     pci-quirk-1k-i-o-space-iobl_adr-fix-on-p64h2.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PCI Quirk: 1k I/O space IOBL_ADR fix on P64H2
From: Daniel Yeisley <dan.yeisley@unisys.com>

There's an existing quirk for the kernel to use 1k IO space granularity on
the Intel P64H2.  It turns out however that pci_setup_bridge() in
drivers/pci/setup-bus.c reads in the IO base and limit address register
masks it off to the nearest 4k, and writes it back.  This causes the kernel
to be on 1k boundaries and the hardware to be 4k aligned.  The patch below
fixes the problem.

Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>
Cc: Greg KH <greg@kroah.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/quirks.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+)

diff -puN drivers/pci/quirks.c~pci-quirk-1k-i-o-space-iobl_adr-fix-on-p64h2 drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-quirk-1k-i-o-space-iobl_adr-fix-on-p64h2
+++ a/drivers/pci/quirks.c
@@ -1592,6 +1592,31 @@ static void __devinit quirk_p64h2_1k_io(
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	0x1460,		quirk_p64h2_1k_io);
 
+/* Fix the IOBL_ADR for 1k I/O space granularity on the Intel P64H2 
+ * The IOBL_ADR gets re-written to 4k boundaries in pci_setup_bridge() 
+ * in drivers/pci/setup-bus.c
+ */
+static void __devinit quirk_p64h2_1k_io_fix_iobl(struct pci_dev *dev)
+{
+	u16 en1k, iobl_adr, iobl_adr_1k;
+	struct resource *res = dev->resource + PCI_BRIDGE_RESOURCES;
+
+	pci_read_config_word(dev, 0x40, &en1k);
+
+	if (en1k & 0x200) {
+		pci_read_config_word(dev, PCI_IO_BASE, &iobl_adr);
+	
+		iobl_adr_1k = iobl_adr | (res->start >> 8) | (res->end & 0xfc00);
+
+		if (iobl_adr != iobl_adr_1k) {
+			printk(KERN_INFO "PCI: Fixing P64H2 IOBL_ADR from 0x%x to 0x%x for 1 KB Granularity\n",
+				iobl_adr,iobl_adr_1k);
+			pci_write_config_word(dev, PCI_IO_BASE, iobl_adr_1k);
+		}
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x1460,		quirk_p64h2_1k_io_fix_iobl);
+
 /* Under some circumstances, AER is not linked with extended capabilities.
  * Force it to be linked by setting the corresponding control bit in the
  * config space.
_

Patches currently in -mm which might be from dan.yeisley@unisys.com are

pci-quirk-1k-i-o-space-iobl_adr-fix-on-p64h2.patch


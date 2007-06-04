From: akpm@linux-foundation.org
Subject: + x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch added to -mm tree
Date: Mon, 04 Jun 2007 11:54:24 -0700
Message-ID: <200706041854.l54IsO4T010946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51481 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758935AbXFDSy4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 14:54:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muli@il.ibm.com, ak@suse.de


The patch titled
     x86-64: Calgary: reserve TCEs with the same address as MEM regions
has been added to the -mm tree.  Its filename is
     x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-64: Calgary: reserve TCEs with the same address as MEM regions
From: Muli Ben-Yehuda <muli@il.ibm.com>

This works around a bug where DMAs that have the same addresses as
some MEM regions do not go through. Not clear yet if this is due to a
mis-configuration or something deeper.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   67 +++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -1536,3 +1536,70 @@ static int __init calgary_parse_options(
 	return 1;
 }
 __setup("calgary=", calgary_parse_options);
+
+static void __init calgary_fixup_one_tce_space(struct pci_dev *dev)
+{
+	struct iommu_table *tbl;
+	unsigned int npages;
+	int i;
+
+	tbl = dev->sysdata;
+
+	for (i = 0; i < 4; i++) {
+		struct resource *r = &dev->resource[PCI_BRIDGE_RESOURCES + i];
+
+		/* Don't give out TCEs that map MEM resources */
+		if (!(r->flags & IORESOURCE_MEM))
+			continue;
+
+		/* 0-based? we reserve the whole 1st MB anyway */
+		if (!r->start)
+			continue;
+
+		/* cover the whole region */
+		npages = (r->end - r->start) >> PAGE_SHIFT;
+		npages++;
+
+		printk(KERN_DEBUG "Calg: dev %p [%x] tbl %p reserving "
+		       "0x%Lx-0x%Lx [0x%x pages]\n", dev, dev->bus->number,
+		       tbl, r->start, r->end, npages);
+
+		iommu_range_reserve(tbl, r->start, npages);
+	}
+}
+
+static int __init calgary_fixup_tce_spaces(void)
+{
+	struct pci_dev *dev = NULL;
+	void* tce_space;
+
+	if (no_iommu || swiotlb || !calgary_detected)
+		return -ENODEV;
+
+	printk(KERN_DEBUG "Calgary: fixing tce spaces\n");
+
+	do {
+		dev = pci_get_device(PCI_VENDOR_ID_IBM, PCI_ANY_ID, dev);
+		if (!dev)
+			break;
+		if (!is_cal_pci_dev(dev->device))
+			continue;
+		if (!translate_phb(dev))
+			continue;
+
+		tce_space = bus_info[dev->bus->number].tce_space;
+		if (!tce_space)
+			continue;
+
+		calgary_fixup_one_tce_space(dev);
+
+	} while (1);
+
+	return 0;
+}
+
+/*
+ * We need to be call after pcibios_assign_resources (fs_initcall level)
+ * and before device_initcall.
+ */
+rootfs_initcall(calgary_fixup_tce_spaces);
_

Patches currently in -mm which might be from muli@il.ibm.com are

x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch
x86-64-calgary-update-copyright-notice.patch
x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-introduce-chipset-specific-ops-fix.patch
x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch
x86-64-calgary-introduce-calioc2-support.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch
x86-64-calgary-make-dump_error_regs-a-chip-op.patch
x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
x86-64-calgary-cleanup-of-unneeded-macros.patch
x86-64-calgary-tabify-and-trim-trailing-whitespace.patch
x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch
x86-64-calgary-tidy-up-debug-printks.patch
oss-trident-massive-whitespace-removal.patch
oss-trident-fix-locking-around-write_voice_regs.patch
oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch

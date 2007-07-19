From: akpm@linux-foundation.org
Subject: - x86-64-calgary-introduce-chipset-specific-ops.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:09 -0700
Message-ID: <200707192009.l6JK99tt020551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756167AbXGSUPg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary: introduce chipset specific ops
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-introduce-chipset-specific-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: Calgary: introduce chipset specific ops
From: Muli Ben-Yehuda <muli@il.ibm.com>

Calgary and CalIOC2 share most of the same logic. Introduce struct
cal_chipset_ops for quirks and tce flush logic which are

[akpm@linux-foundation.org: make calgary_chip_ops static]
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   24 +++++++++++++++++-------
 include/asm-x86_64/calgary.h     |    8 +++++++-
 2 files changed, 24 insertions(+), 8 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-introduce-chipset-specific-ops arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-introduce-chipset-specific-ops
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -155,9 +155,15 @@ struct calgary_bus_info {
 	void __iomem *bbar;
 };
 
-static struct calgary_bus_info bus_info[MAX_PHB_BUS_NUM] = { { NULL, 0, 0 }, };
+static void calgary_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev);
+static void calgary_tce_cache_blast(struct iommu_table *tbl);
+
+static struct cal_chipset_ops calgary_chip_ops = {
+	.handle_quirks = calgary_handle_quirks,
+	.tce_cache_blast = calgary_tce_cache_blast
+};
 
-static void tce_cache_blast(struct iommu_table *tbl);
+static struct calgary_bus_info bus_info[MAX_PHB_BUS_NUM] = { { NULL, 0, 0 }, };
 
 /* enable this to stress test the chip's TCE cache */
 #ifdef CONFIG_IOMMU_DEBUG
@@ -243,7 +249,7 @@ static unsigned long iommu_range_alloc(s
 	offset = find_next_zero_string(tbl->it_map, tbl->it_hint,
 				       tbl->it_size, npages);
 	if (offset == ~0UL) {
-		tce_cache_blast(tbl);
+		tbl->chip_ops->tce_cache_blast(tbl);
 		offset = find_next_zero_string(tbl->it_map, 0,
 					       tbl->it_size, npages);
 		if (offset == ~0UL) {
@@ -552,7 +558,7 @@ static inline void __iomem* calgary_reg(
 	return (void __iomem*)target;
 }
 
-static void tce_cache_blast(struct iommu_table *tbl)
+static void calgary_tce_cache_blast(struct iommu_table *tbl)
 {
 	u64 val;
 	u32 aer;
@@ -698,6 +704,8 @@ static int __init calgary_setup_tar(stru
 	tbl->it_base = (unsigned long)bus_info[dev->bus->number].tce_space;
 	tce_free(tbl, 0, tbl->it_size);
 
+	tbl->chip_ops = &calgary_chip_ops;
+
 	calgary_reserve_regions(dev);
 
 	/* set TARs for each PHB */
@@ -807,10 +815,10 @@ static void __init calgary_set_split_com
 	readq(target); /* flush */
 }
 
-static void __init calgary_handle_quirks(struct pci_dev* dev)
+static void __init calgary_handle_quirks(struct iommu_table *tbl,
+	struct pci_dev *dev)
 {
 	unsigned char busnum = dev->bus->number;
-	struct iommu_table *tbl = dev->sysdata;
 
 	/*
 	 * Give split completion a longer timeout on bus 1 for aic94xx
@@ -885,6 +893,7 @@ static void __init calgary_init_one_nont
 static int __init calgary_init_one(struct pci_dev *dev)
 {
 	void __iomem *bbar;
+	struct iommu_table *tbl;
 	int ret;
 
 	BUG_ON(dev->bus->number >= MAX_PHB_BUS_NUM);
@@ -897,7 +906,8 @@ static int __init calgary_init_one(struc
 	pci_dev_get(dev);
 	dev->bus->self = dev;
 
-	calgary_handle_quirks(dev);
+	tbl = dev->sysdata;
+	tbl->chip_ops->handle_quirks(tbl, dev);
 
 	calgary_enable_translation(dev);
 
diff -puN include/asm-x86_64/calgary.h~x86-64-calgary-introduce-chipset-specific-ops include/asm-x86_64/calgary.h
--- a/include/asm-x86_64/calgary.h~x86-64-calgary-introduce-chipset-specific-ops
+++ a/include/asm-x86_64/calgary.h
@@ -1,7 +1,7 @@
 /*
  * Derived from include/asm-powerpc/iommu.h
  *
- * Copyright (C) IBM Corporation, 2006
+ * Copyright IBM Corporation, 2006-2007
  *
  * Author: Jon Mason <jdmason@us.ibm.com>
  * Author: Muli Ben-Yehuda <muli@il.ibm.com>
@@ -31,6 +31,7 @@
 #include <asm/types.h>
 
 struct iommu_table {
+	struct cal_chipset_ops *chip_ops; /* chipset specific funcs */
 	unsigned long  it_base;      /* mapped address of tce table */
 	unsigned long  it_hint;      /* Hint for next alloc */
 	unsigned long *it_map;       /* A simple allocation bitmap for now */
@@ -42,6 +43,11 @@ struct iommu_table {
 	unsigned char  it_busno;     /* Bus number this table belongs to */
 };
 
+struct cal_chipset_ops {
+	void (*handle_quirks)(struct iommu_table *tbl, struct pci_dev *dev);
+	void (*tce_cache_blast)(struct iommu_table *tbl);
+};
+
 #define TCE_TABLE_SIZE_UNSPECIFIED	~0
 #define TCE_TABLE_SIZE_64K		0
 #define TCE_TABLE_SIZE_128K		1
_

Patches currently in -mm which might be from muli@il.ibm.com are

origin.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FEDC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23C0422CB8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgLOX7R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:32886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728017AbgLOXW4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:56 -0500
Date:   Tue, 15 Dec 2020 15:20:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074451;
        bh=6hvJkd5dsiMNpkMP0+wdCYUe5fPldSsrQbsnlEGccFA=;
        h=From:To:Subject:From;
        b=kXUH5d6SExAVQOtOnqtJn+1ygwf+cUULLqpt3Uho0+6SDh3bLqNb8UPSM42Kvr2Sk
         F3DaMNxTdVIT3P6gkd0UMavsULTi8f9IGP+RV+aGyTWpyM/zIdZW2Iscey4KOFwMgc
         6a86IGvIsmmFJ0kmcRavVHsYcOILWadNFpz6Awz8=
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, catalin.marinas@arm.com, corbet@lwn.net,
        geert@linux-m68k.org, gerg@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, linux@armlinux.org.uk,
        mattst88@gmail.com, mm-commits@vger.kernel.org, mroos@linux.ee,
        rppt@linux.ibm.com, schmitzmic@gmail.com, tony.luck@intel.com,
        vgupta@synopsys.com, will@kernel.org
Subject:  [merged]
 ia64-forbid-using-virtual_mem_map-with-flatmem.patch removed from -mm tree
Message-ID: <20201215232050.S1gK05AKS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: forbid using VIRTUAL_MEM_MAP with FLATMEM
has been removed from the -mm tree.  Its filename was
     ia64-forbid-using-virtual_mem_map-with-flatmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: ia64: forbid using VIRTUAL_MEM_MAP with FLATMEM

Virtual memory map was intended to avoid wasting memory on the memory map
on systems with large holes in the physical memory layout. Long ago it been
superseded first by DISCONTIGMEM and then by SPARSEMEM. Moreover,
SPARSEMEM_VMEMMAP provide the same functionality in much more portable way.

As the first step to removing the VIRTUAL_MEM_MAP forbid it's usage with
FLATMEM and panic on systems with large holes in the physical memory
layout that try to run FLATMEM kernels.

Link: https://lkml.kernel.org/r/20201101170454.9567-7-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Meelis Roos <mroos@linux.ee>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig               |    2 -
 arch/ia64/include/asm/meminit.h |    2 -
 arch/ia64/mm/contig.c           |   52 +++++++++++++-----------------
 arch/ia64/mm/init.c             |   14 --------
 4 files changed, 24 insertions(+), 46 deletions(-)

--- a/arch/ia64/include/asm/meminit.h~ia64-forbid-using-virtual_mem_map-with-flatmem
+++ a/arch/ia64/include/asm/meminit.h
@@ -59,10 +59,8 @@ extern int reserve_elfcorehdr(u64 *start
 extern int register_active_ranges(u64 start, u64 len, int nid);
 
 #ifdef CONFIG_VIRTUAL_MEM_MAP
-# define LARGE_GAP	0x40000000 /* Use virtual mem map if hole is > than this */
   extern unsigned long VMALLOC_END;
   extern struct page *vmem_map;
-  extern int find_largest_hole(u64 start, u64 end, void *arg);
   extern int create_mem_map_page_table(u64 start, u64 end, void *arg);
   extern int vmemmap_find_next_valid_pfn(int, int);
 #else
--- a/arch/ia64/Kconfig~ia64-forbid-using-virtual_mem_map-with-flatmem
+++ a/arch/ia64/Kconfig
@@ -329,7 +329,7 @@ config NODES_SHIFT
 # VIRTUAL_MEM_MAP has been retained for historical reasons.
 config VIRTUAL_MEM_MAP
 	bool "Virtual mem map"
-	depends on !SPARSEMEM
+	depends on !SPARSEMEM && !FLATMEM
 	default y
 	help
 	  Say Y to compile the kernel with support for a virtual mem map.
--- a/arch/ia64/mm/contig.c~ia64-forbid-using-virtual_mem_map-with-flatmem
+++ a/arch/ia64/mm/contig.c
@@ -19,15 +19,12 @@
 #include <linux/mm.h>
 #include <linux/nmi.h>
 #include <linux/swap.h>
+#include <linux/sizes.h>
 
 #include <asm/meminit.h>
 #include <asm/sections.h>
 #include <asm/mca.h>
 
-#ifdef CONFIG_VIRTUAL_MEM_MAP
-static unsigned long max_gap;
-#endif
-
 /* physical address where the bootmem map is located */
 unsigned long bootmap_start;
 
@@ -166,33 +163,30 @@ find_memory (void)
 	alloc_per_cpu_data();
 }
 
-static void __init virtual_map_init(void)
+static int __init find_largest_hole(u64 start, u64 end, void *arg)
 {
-#ifdef CONFIG_VIRTUAL_MEM_MAP
-	efi_memmap_walk(find_largest_hole, (u64 *)&max_gap);
-	if (max_gap < LARGE_GAP) {
-		vmem_map = (struct page *) 0;
-	} else {
-		unsigned long map_size;
-
-		/* allocate virtual_mem_map */
-
-		map_size = PAGE_ALIGN(ALIGN(max_low_pfn, MAX_ORDER_NR_PAGES) *
-			sizeof(struct page));
-		VMALLOC_END -= map_size;
-		vmem_map = (struct page *) VMALLOC_END;
-		efi_memmap_walk(create_mem_map_page_table, NULL);
+	u64 *max_gap = arg;
 
-		/*
-		 * alloc_node_mem_map makes an adjustment for mem_map
-		 * which isn't compatible with vmem_map.
-		 */
-		NODE_DATA(0)->node_mem_map = vmem_map +
-			find_min_pfn_with_active_regions();
+	static u64 last_end = PAGE_OFFSET;
 
-		printk("Virtual mem_map starts at 0x%p\n", mem_map);
-	}
-#endif /* !CONFIG_VIRTUAL_MEM_MAP */
+	/* NOTE: this algorithm assumes efi memmap table is ordered */
+
+	if (*max_gap < (start - last_end))
+		*max_gap = start - last_end;
+	last_end = end;
+	return 0;
+}
+
+static void __init verify_gap_absence(void)
+{
+	unsigned long max_gap;
+
+	/* Forbid FLATMEM if hole is > than 1G */
+	efi_memmap_walk(find_largest_hole, (u64 *)&max_gap);
+	if (max_gap >= SZ_1G)
+		panic("Cannot use FLATMEM with %ldMB hole\n"
+		      "Please switch over to SPARSEMEM\n",
+		      (max_gap >> 20));
 }
 
 /*
@@ -210,7 +204,7 @@ paging_init (void)
 	max_zone_pfns[ZONE_DMA32] = max_dma;
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 
-	virtual_map_init();
+	verify_gap_absence();
 
 	free_area_init(max_zone_pfns);
 	zero_page_memmap_ptr = virt_to_page(ia64_imva(empty_zero_page));
--- a/arch/ia64/mm/init.c~ia64-forbid-using-virtual_mem_map-with-flatmem
+++ a/arch/ia64/mm/init.c
@@ -574,20 +574,6 @@ ia64_pfn_valid (unsigned long pfn)
 }
 EXPORT_SYMBOL(ia64_pfn_valid);
 
-int __init find_largest_hole(u64 start, u64 end, void *arg)
-{
-	u64 *max_gap = arg;
-
-	static u64 last_end = PAGE_OFFSET;
-
-	/* NOTE: this algorithm assumes efi memmap table is ordered */
-
-	if (*max_gap < (start - last_end))
-		*max_gap = start - last_end;
-	last_end = end;
-	return 0;
-}
-
 #endif /* CONFIG_VIRTUAL_MEM_MAP */
 
 int __init register_active_ranges(u64 start, u64 len, int nid)
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-add-memcg-accounting.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BC6C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E383020721
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgLODS0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:18:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727928AbgLODMP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:15 -0500
Date:   Mon, 14 Dec 2020 19:09:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001789;
        bh=AaDzmsOJJIkKbGz6OJQbeFeKmHzUgt++uC8t3jPxtuM=;
        h=From:To:Subject:In-Reply-To:From;
        b=T66qjWgzuGmJpIzKY+A4USvKWeHbz7sxnWehxPAwFLR2pZJmIGfmuqupxSbM9aS3r
         VIqIG8RrQ+5WmGJk0aw2pMb8IVpY7Rdv3hZGWzWrJfgXzrdHbSLWNhnV4iKElyggF0
         zwqNHkpMF5xRb9mptm2zjgl+5w8/oCaDd730cCzs=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        catalin.marinas@arm.com, corbet@lwn.net, geert@linux-m68k.org,
        gerg@linux-m68k.org, glaubitz@physik.fu-berlin.de,
        linux-mm@kvack.org, linux@armlinux.org.uk, mattst88@gmail.com,
        mm-commits@vger.kernel.org, mroos@linux.ee, rppt@linux.ibm.com,
        schmitzmic@gmail.com, tony.luck@intel.com,
        torvalds@linux-foundation.org, vgupta@synopsys.com, will@kernel.org
Subject:  [patch 111/200] ia64: forbid using VIRTUAL_MEM_MAP with
 FLATMEM
Message-ID: <20201215030947.iyM0XyzzO%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

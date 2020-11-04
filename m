Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 581B6C388F2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A198223C7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604459482;
	bh=DL+OiXQAclS5b+5RLAtjz2hW0qwFlO0yQ45/yfdV4Xs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CgHJzSGrWVYCvena6jePK267lbK4oprISriHJgBI2Aal+fQ6taUSuBdwaujjhqj3b
	 OXGDLDW4ODO3KXDLm/ySaO1F4ZOmyGmz3UP8wiGw4qRYaqoCulqjPd2zsaDUlJPtwP
	 7Ounq5nsRVxpqtAd7bltRyxqFQS4ll9i9bVviUG8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730735AbgKDDLV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 22:11:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbgKDDLV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 22:11:21 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2356E20657;
        Wed,  4 Nov 2020 03:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604459480;
        bh=DL+OiXQAclS5b+5RLAtjz2hW0qwFlO0yQ45/yfdV4Xs=;
        h=Date:From:To:Subject:From;
        b=tj2+cAltUhI6d4tjwhDxeWyP8FuQ+RawKK1yrZ9b9cs1tq3R621lBcFQHH44eIwEV
         DTaULEkieks4BH9IuCI08RLc7X3XNGP4MXei33xgB131y8ulDwXKORkNRttvZsu9/E
         mMoDIpn0MMgMGSJr/sGU0uei84gxO1nHGOpBnjmc=
Date:   Tue, 03 Nov 2020 19:11:18 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vgupta@synopsys.com,
        tony.luck@intel.com, schmitzmic@gmail.com, mroos@linux.ee,
        mattst88@gmail.com, linux@armlinux.org.uk,
        glaubitz@physik.fu-berlin.de, gerg@linux-m68k.org,
        geert@linux-m68k.org, corbet@lwn.net, catalin.marinas@arm.com,
        adobriyan@gmail.com, rppt@linux.ibm.com
Subject:  + ia64-forbid-using-virtual_mem_map-with-flatmem.patch
 added to -mm tree
Message-ID: <20201104031118.-ucFx%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: forbid using VIRTUAL_MEM_MAP with FLATMEM
has been added to the -mm tree.  Its filename is
     ia64-forbid-using-virtual_mem_map-with-flatmem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-forbid-using-virtual_mem_map-with-flatmem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-forbid-using-virtual_mem_map-with-flatmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-introduce-debug_pagealloc_map_pages-helper.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch
alpha-switch-from-discontigmem-to-sparsemem.patch
ia64-remove-custom-__early_pfn_to_nid.patch
ia64-remove-ifdef-config_zone_dma32-statements.patch
ia64-discontig-paging_init-remove-local-max_pfn-calculation.patch
ia64-split-virtual-map-initialization-out-of-paging_init.patch
ia64-forbid-using-virtual_mem_map-with-flatmem.patch
ia64-make-sparsemem-default-and-disable-discontigmem.patch
arm-remove-config_arch_has_holes_memorymodel.patch
arm-arm64-move-free_unused_memmap-to-generic-mm.patch
arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem.patch
m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch
m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch
m68k-deprecate-discontigmem.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CEABC4743B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4459222D07
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgLOX7L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727879AbgLOXWa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:30 -0500
Date:   Tue, 15 Dec 2020 15:20:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074448;
        bh=UmZFbAgezHVwRUYRa4P/dWtGUGrLyrDoEGGy9N16PHI=;
        h=From:To:Subject:From;
        b=XXD9DzVYVbAoZOisGjvrRjOy+ONUTidbfEbgCv0RSjP5B3h7gUS8+JLIsqrUul88t
         T4NTgrJ4f8nJ3i/pRtKCTuhpFqZ7SwiECbgQQOh49fJiB6fq+Wuj3/g+Rxo+wKFPh1
         zMqePj6TvsBteSTkeB3Jjo1vi6Y40X0PC60Zhihw=
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, catalin.marinas@arm.com, corbet@lwn.net,
        geert@linux-m68k.org, gerg@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, linux@armlinux.org.uk,
        mattst88@gmail.com, mm-commits@vger.kernel.org, mroos@linux.ee,
        rppt@linux.ibm.com, schmitzmic@gmail.com, tony.luck@intel.com,
        vgupta@synopsys.com, will@kernel.org
Subject:  [merged]
 ia64-split-virtual-map-initialization-out-of-paging_init.patch removed from
 -mm tree
Message-ID: <20201215232047.iIO2BvNPz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: split virtual map initialization out of paging_init()
has been removed from the -mm tree.  Its filename was
     ia64-split-virtual-map-initialization-out-of-paging_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: ia64: split virtual map initialization out of paging_init()

For both FLATMEM and DISCONTIGMEM/SPARSEMEM the virtual map initialization
is spread over paging_init() for no good reason.

Split out the bits related to virtual map initialization to a helper
functions, one for FLATMEM and another for !FLATMEM configurations.

Link: https://lkml.kernel.org/r/20201101170454.9567-6-rppt@kernel.org
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

 arch/ia64/mm/contig.c    |   34 ++++++++++++++++++++--------------
 arch/ia64/mm/discontig.c |   37 ++++++++++++++++++++-----------------
 2 files changed, 40 insertions(+), 31 deletions(-)

--- a/arch/ia64/mm/contig.c~ia64-split-virtual-map-initialization-out-of-paging_init
+++ a/arch/ia64/mm/contig.c
@@ -166,21 +166,8 @@ find_memory (void)
 	alloc_per_cpu_data();
 }
 
-/*
- * Set up the page tables.
- */
-
-void __init
-paging_init (void)
+static void __init virtual_map_init(void)
 {
-	unsigned long max_dma;
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-
-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-	max_dma = virt_to_phys((void *) MAX_DMA_ADDRESS) >> PAGE_SHIFT;
-	max_zone_pfns[ZONE_DMA32] = max_dma;
-	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
-
 #ifdef CONFIG_VIRTUAL_MEM_MAP
 	efi_memmap_walk(find_largest_hole, (u64 *)&max_gap);
 	if (max_gap < LARGE_GAP) {
@@ -206,6 +193,25 @@ paging_init (void)
 		printk("Virtual mem_map starts at 0x%p\n", mem_map);
 	}
 #endif /* !CONFIG_VIRTUAL_MEM_MAP */
+}
+
+/*
+ * Set up the page tables.
+ */
+
+void __init
+paging_init (void)
+{
+	unsigned long max_dma;
+	unsigned long max_zone_pfns[MAX_NR_ZONES];
+
+	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+	max_dma = virt_to_phys((void *) MAX_DMA_ADDRESS) >> PAGE_SHIFT;
+	max_zone_pfns[ZONE_DMA32] = max_dma;
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+
+	virtual_map_init();
+
 	free_area_init(max_zone_pfns);
 	zero_page_memmap_ptr = virt_to_page(ia64_imva(empty_zero_page));
 }
--- a/arch/ia64/mm/discontig.c~ia64-split-virtual-map-initialization-out-of-paging_init
+++ a/arch/ia64/mm/discontig.c
@@ -584,6 +584,25 @@ void call_pernode_memory(unsigned long s
 	}
 }
 
+static void __init virtual_map_init(void)
+{
+#ifdef CONFIG_VIRTUAL_MEM_MAP
+	int node;
+
+	VMALLOC_END -= PAGE_ALIGN(ALIGN(max_low_pfn, MAX_ORDER_NR_PAGES) *
+		sizeof(struct page));
+	vmem_map = (struct page *) VMALLOC_END;
+	efi_memmap_walk(create_mem_map_page_table, NULL);
+	printk("Virtual mem_map starts at 0x%p\n", vmem_map);
+
+	for_each_online_node(node) {
+		unsigned long pfn_offset = mem_data[node].min_pfn;
+
+		NODE_DATA(node)->node_mem_map = vmem_map + pfn_offset;
+	}
+#endif
+}
+
 /**
  * paging_init - setup page tables
  *
@@ -593,29 +612,13 @@ void call_pernode_memory(unsigned long s
 void __init paging_init(void)
 {
 	unsigned long max_dma;
-	unsigned long pfn_offset = 0;
-	int node;
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 
 	max_dma = virt_to_phys((void *) MAX_DMA_ADDRESS) >> PAGE_SHIFT;
 
 	sparse_init();
 
-#ifdef CONFIG_VIRTUAL_MEM_MAP
-	VMALLOC_END -= PAGE_ALIGN(ALIGN(max_low_pfn, MAX_ORDER_NR_PAGES) *
-		sizeof(struct page));
-	vmem_map = (struct page *) VMALLOC_END;
-	efi_memmap_walk(create_mem_map_page_table, NULL);
-	printk("Virtual mem_map starts at 0x%p\n", vmem_map);
-#endif
-
-	for_each_online_node(node) {
-		pfn_offset = mem_data[node].min_pfn;
-
-#ifdef CONFIG_VIRTUAL_MEM_MAP
-		NODE_DATA(node)->node_mem_map = vmem_map + pfn_offset;
-#endif
-	}
+	virtual_map_init();
 
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 	max_zone_pfns[ZONE_DMA32] = max_dma;
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


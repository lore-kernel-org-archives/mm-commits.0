From: akpm@linux-foundation.org
Subject: - ia64-clean-up-sparsemem-memory_present-calls.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:52:11 -0800
Message-ID: <200702071952.l17JqBdg025221@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33594 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422738AbXBGTwT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:52:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bob.picco@hp.com, mel@csn.ul.ie, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: clean up sparsemem memory_present call
has been removed from the -mm tree.  Its filename was
     ia64-clean-up-sparsemem-memory_present-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: clean up sparsemem memory_present call
From: "Bob Picco" <bob.picco@hp.com>

Eliminate arch specific memory_present call ia64 NUMA by utilizing
sparse_memory_present_with_active_regions.

Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Bob Picco <bob.picco@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/discontig.c |   36 +++---------------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

diff -puN arch/ia64/mm/discontig.c~ia64-clean-up-sparsemem-memory_present-calls arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~ia64-clean-up-sparsemem-memory_present-calls
+++ a/arch/ia64/mm/discontig.c
@@ -412,37 +412,6 @@ static void __init memory_less_nodes(voi
 	return;
 }
 
-#ifdef CONFIG_SPARSEMEM
-/**
- * register_sparse_mem - notify SPARSEMEM that this memory range exists.
- * @start: physical start of range
- * @end: physical end of range
- * @arg: unused
- *
- * Simply calls SPARSEMEM to register memory section(s).
- */
-static int __init register_sparse_mem(unsigned long start, unsigned long end,
-	void *arg)
-{
-	int nid;
-
-	start = __pa(start) >> PAGE_SHIFT;
-	end = __pa(end) >> PAGE_SHIFT;
-	nid = early_pfn_to_nid(start);
-	memory_present(nid, start, end);
-
-	return 0;
-}
-
-static void __init arch_sparse_init(void)
-{
-	efi_memmap_walk(register_sparse_mem, NULL);
-	sparse_init();
-}
-#else
-#define arch_sparse_init() do {} while (0)
-#endif
-
 /**
  * find_memory - walk the EFI memory map and setup the bootmem allocator
  *
@@ -688,10 +657,11 @@ void __init paging_init(void)
 
 	max_dma = virt_to_phys((void *) MAX_DMA_ADDRESS) >> PAGE_SHIFT;
 
-	arch_sparse_init();
-
 	efi_memmap_walk(filter_rsvd_memory, count_node_pages);
 
+	sparse_memory_present_with_active_regions(MAX_NUMNODES);
+	sparse_init();
+
 #ifdef CONFIG_VIRTUAL_MEM_MAP
 	vmalloc_end -= PAGE_ALIGN(ALIGN(max_low_pfn, MAX_ORDER_NR_PAGES) *
 		sizeof(struct page));
_

Patches currently in -mm which might be from bob.picco@hp.com are

origin.patch
x86_64-clean-up-sparsemem-memory_present-call.patch

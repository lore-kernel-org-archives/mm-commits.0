From: akpm@osdl.org
Subject: + ia64-clean-up-sparsemem-memory_present-calls.patch added to -mm tree
Date: Tue, 23 Jan 2007 22:38:30 -0800
Message-ID: <200701240638.l0O6cU7s010628@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54390 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932936AbXAXGih (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 01:38:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bob.picco@hp.com, mel@csn.ul.ie, tony.luck@intel.com


The patch titled
     ia64: clean up sparsemem memory_present call
has been added to the -mm tree.  Its filename is
     ia64-clean-up-sparsemem-memory_present-calls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: clean up sparsemem memory_present call
From: "Bob Picco" <bob.picco@hp.com>

Eliminate arch specific memory_present call ia64 NUMA by utilizing
sparse_memory_present_with_active_regions.

Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Bob Picco <bob.picco@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

ia64-register-memory-ranges-in-a-consistent-manner.patch
ia64-clean-up-sparsemem-memory_present-calls.patch

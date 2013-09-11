From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-sparse-introduce-alloc_usemap_and_memmap-fix-2.patch removed from -mm
 tree
Date: Wed, 11 Sep 2013 14:01:32 -0700
Message-ID: <5230da2c.VsGZmW+pzoWcvnoO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab3IKVBd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:01:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, liwanp@linux.vnet.ibm.com

Subject: [folded-merged] mm-sparse-introduce-alloc_usemap_and_memmap-fix-2.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:01:32 -0700


The patch titled
     Subject: mm/sparse: introduce alloc_usemap_and_memmap fix-2
has been removed from the -mm tree.  Its filename was
     mm-sparse-introduce-alloc_usemap_and_memmap-fix-2.patch

This patch was dropped because it was folded into mm-sparse-introduce-alloc_usemap_and_memmap.patch

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/sparse: introduce alloc_usemap_and_memmap fix-2

Pass function pointer to alloc_usemap_and_memmap() instead of true/false.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   41 +++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff -puN mm/sparse.c~mm-sparse-introduce-alloc_usemap_and_memmap-fix-2 mm/sparse.c
--- a/mm/sparse.c~mm-sparse-introduce-alloc_usemap_and_memmap-fix-2
+++ a/mm/sparse.c
@@ -339,13 +339,14 @@ static void __init check_usemap_section_
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
-static void __init sparse_early_usemaps_alloc_node(unsigned long**usemap_map,
+static void __init sparse_early_usemaps_alloc_node(void **data,
 				 unsigned long pnum_begin,
 				 unsigned long pnum_end,
 				 unsigned long usemap_count, int nodeid)
 {
 	void *usemap;
 	unsigned long pnum;
+	unsigned long **usemap_map = (unsigned long **)data;
 	int size = usemap_size();
 
 	usemap = sparse_early_usemaps_alloc_pgdat_section(NODE_DATA(nodeid),
@@ -430,23 +431,16 @@ void __init sparse_mem_maps_populate_nod
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
-static void __init sparse_early_mem_maps_alloc_node(struct page **map_map,
+static void __init sparse_early_mem_maps_alloc_node(void **data,
 				 unsigned long pnum_begin,
 				 unsigned long pnum_end,
 				 unsigned long map_count, int nodeid)
 {
+	struct page **map_map = (struct page **)data;
 	sparse_mem_maps_populate_node(map_map, pnum_begin, pnum_end,
 					 map_count, nodeid);
 }
 #else
-
-static void __init sparse_early_mem_maps_alloc_node(struct page **map_map,
-				unsigned long pnum_begin,
-				unsigned long pnum_end,
-				unsigned long map_count, int nodeid)
-{
-}
-
 static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 {
 	struct page *map;
@@ -471,9 +465,10 @@ void __attribute__((weak)) __meminit vme
 /**
  *  alloc_usemap_and_memmap - memory alloction for pageblock flags and vmemmap
  *  @map: usemap_map for pageblock flags or mmap_map for vmemmap
- *  @use_map: true if memory allocated for pageblock flags, otherwise false
  */
-static void __init alloc_usemap_and_memmap(unsigned long **map, bool use_map)
+static void __init alloc_usemap_and_memmap(void (*alloc_func)
+					(void **, unsigned long, unsigned long,
+					unsigned long, int), void **data)
 {
 	unsigned long pnum;
 	unsigned long map_count;
@@ -504,24 +499,16 @@ static void __init alloc_usemap_and_memm
 			continue;
 		}
 		/* ok, we need to take cake of from pnum_begin to pnum - 1*/
-		if (use_map)
-			sparse_early_usemaps_alloc_node(map, pnum_begin, pnum,
-						 map_count, nodeid_begin);
-		else
-			sparse_early_mem_maps_alloc_node((struct page **)map,
-				pnum_begin, pnum, map_count, nodeid_begin);
+		alloc_func(data, pnum_begin, pnum,
+						map_count, nodeid_begin);
 		/* new start, update count etc*/
 		nodeid_begin = nodeid;
 		pnum_begin = pnum;
 		map_count = 1;
 	}
 	/* ok, last chunk */
-	if (use_map)
-		sparse_early_usemaps_alloc_node(map, pnum_begin,
-				NR_MEM_SECTIONS, map_count, nodeid_begin);
-	else
-		sparse_early_mem_maps_alloc_node((struct page **)map,
-			pnum_begin, NR_MEM_SECTIONS, map_count, nodeid_begin);
+	alloc_func(data, pnum_begin, NR_MEM_SECTIONS,
+						map_count, nodeid_begin);
 }
 
 /*
@@ -561,14 +548,16 @@ void __init sparse_init(void)
 	usemap_map = alloc_bootmem(size);
 	if (!usemap_map)
 		panic("can not allocate usemap_map\n");
-	alloc_usemap_and_memmap(usemap_map, true);
+	alloc_usemap_and_memmap(sparse_early_usemaps_alloc_node,
+							(void **)usemap_map);
 
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
 	size2 = sizeof(struct page *) * NR_MEM_SECTIONS;
 	map_map = alloc_bootmem(size2);
 	if (!map_map)
 		panic("can not allocate map_map\n");
-	alloc_usemap_and_memmap((unsigned long **)map_map, false);
+	alloc_usemap_and_memmap(sparse_early_mem_maps_alloc_node,
+							(void **)map_map);
 #endif
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-zswapc-get-swapper-address_space-by-using-macro.patch
mm-fix-potential-null-pointer-dereference.patch
mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-vmalloc-remove-useless-variable-in-vmap_block.patch
mm-vmalloc-use-well-defined-find_last_bit-func.patch
mm-hotplug-verify-hotplug-memory-range.patch
mm-hotplug-remove-stop_machine-from-try_offline_node.patch
mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage.patch
mm-hugetlb-change-variable-name-reservations-to-resv.patch
mm-hugetlb-fix-subpool-accounting-handling.patch
mm-hugetlb-remove-useless-check-about-mapping-type.patch
mm-hugetlb-grab-a-page_table_lock-after-page_cache_release.patch
mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch
mm-sparse-introduce-alloc_usemap_and_memmap.patch
mm-sparse-introduce-alloc_usemap_and_memmap-fix-3.patch
mm-writeback-make-writeback_inodes_wb-static.patch
mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch
hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page.patch
mm-hwpoison-fix-loss-of-pg_dirty-for-errors-on-mlocked-pages.patch
mm-hwpoison-dont-need-to-hold-compound-lock-for-hugetlbfs-page.patch
mm-hwpoison-fix-race-against-poison-thp.patch
mm-hwpoison-replace-atomic_long_sub-with-atomic_long_dec.patch
mm-hwpoison-dont-set-migration-type-twice-to-avoid-holding-heavily-contend-zone-lock.patch
mm-hwpoison-drop-forward-reference-declarations-__soft_offline_page.patch
mm-hwpoison-add-to-madvise_hwpoison.patch
mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page.patch
mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200.patch
mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page.patch
mm-hwpoison-fix-return-value-of-madvise_hwpoison.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch


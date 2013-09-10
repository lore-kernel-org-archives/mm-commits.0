From: akpm@linux-foundation.org
Subject: + mm-sparse-introduce-alloc_usemap_and_memmap-fix-3.patch added
 to -mm tree
Date: Tue, 10 Sep 2013 16:32:01 -0700
Message-ID: <522fabf1.yopl2L6VFYyixTYp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3IJXcD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 19:32:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, liwanp@linux.vnet.ibm.com

Subject: + mm-sparse-introduce-alloc_usemap_and_memmap-fix-3.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 16:32:01 -0700


The patch titled
     Subject: mm-sparse-introduce-alloc_usemap_and_memmap-fix-3
has been added to the -mm tree.  Its filename is
     mm-sparse-introduce-alloc_usemap_and_memmap-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-introduce-alloc_usemap_and_memmap-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-introduce-alloc_usemap_and_memmap-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm-sparse-introduce-alloc_usemap_and_memmap-fix-3

Replace void ** by void *.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/sparse.c~mm-sparse-introduce-alloc_usemap_and_memmap-fix-3 mm/sparse.c
--- a/mm/sparse.c~mm-sparse-introduce-alloc_usemap_and_memmap-fix-3
+++ a/mm/sparse.c
@@ -339,7 +339,7 @@ static void __init check_usemap_section_
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
-static void __init sparse_early_usemaps_alloc_node(void **data,
+static void __init sparse_early_usemaps_alloc_node(void *data,
 				 unsigned long pnum_begin,
 				 unsigned long pnum_end,
 				 unsigned long usemap_count, int nodeid)
@@ -431,7 +431,7 @@ void __init sparse_mem_maps_populate_nod
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
-static void __init sparse_early_mem_maps_alloc_node(void **data,
+static void __init sparse_early_mem_maps_alloc_node(void *data,
 				 unsigned long pnum_begin,
 				 unsigned long pnum_end,
 				 unsigned long map_count, int nodeid)
@@ -467,8 +467,8 @@ void __attribute__((weak)) __meminit vme
  *  @map: usemap_map for pageblock flags or mmap_map for vmemmap
  */
 static void __init alloc_usemap_and_memmap(void (*alloc_func)
-					(void **, unsigned long, unsigned long,
-					unsigned long, int), void **data)
+					(void *, unsigned long, unsigned long,
+					unsigned long, int), void *data)
 {
 	unsigned long pnum;
 	unsigned long map_count;
@@ -549,7 +549,7 @@ void __init sparse_init(void)
 	if (!usemap_map)
 		panic("can not allocate usemap_map\n");
 	alloc_usemap_and_memmap(sparse_early_usemaps_alloc_node,
-							(void **)usemap_map);
+							(void *)usemap_map);
 
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
 	size2 = sizeof(struct page *) * NR_MEM_SECTIONS;
@@ -557,7 +557,7 @@ void __init sparse_init(void)
 	if (!map_map)
 		panic("can not allocate map_map\n");
 	alloc_usemap_and_memmap(sparse_early_mem_maps_alloc_node,
-							(void **)map_map);
+							(void *)map_map);
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
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-hotplug-remove-stop_machine-from-try_offline_node.patch
mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage.patch
mm-hugetlb-change-variable-name-reservations-to-resv.patch
mm-hugetlb-fix-subpool-accounting-handling.patch
mm-hugetlb-remove-useless-check-about-mapping-type.patch
mm-hugetlb-grab-a-page_table_lock-after-page_cache_release.patch
mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch
mm-sparse-introduce-alloc_usemap_and_memmap.patch
mm-sparse-introduce-alloc_usemap_and_memmap-fix.patch
mm-sparse-introduce-alloc_usemap_and_memmap-fix-2.patch
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


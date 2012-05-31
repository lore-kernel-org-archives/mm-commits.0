From: akpm@linux-foundation.org
Subject: [merged] mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:23 -0700
Message-ID: <20120531191523.773DAA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:46876 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936Ab2EaTPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:25 -0400
Received: by mail-bk0-f74.google.com with SMTP id y5so75342bkt.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, shangw@linux.vnet.ibm.com, tj@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove sparsemem allocation details from the bootmem allocator
has been removed from the -mm tree.  Its filename was
     mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: remove sparsemem allocation details from the bootmem allocator

alloc_bootmem_section() derives allocation area constraints from the
specified sparsemem section.  This is a bit specific for a generic memory
allocator like bootmem, though, so move it over to sparsemem.

As __alloc_bootmem_node_nopanic() already retries failed allocations with
relaxed area constraints, the fallback code in sparsemem.c can be removed
and the code becomes a bit more compact overall.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    3 ---
 mm/bootmem.c            |   22 ----------------------
 mm/nobootmem.c          |   22 ----------------------
 mm/sparse.c             |   25 ++++++++++++-------------
 4 files changed, 12 insertions(+), 60 deletions(-)

diff -puN include/linux/bootmem.h~mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator
+++ a/include/linux/bootmem.h
@@ -135,9 +135,6 @@ extern void *__alloc_bootmem_low_node(pg
 extern int reserve_bootmem_generic(unsigned long addr, unsigned long size,
 				   int flags);
 
-extern void *alloc_bootmem_section(unsigned long size,
-				   unsigned long section_nr);
-
 #ifdef CONFIG_HAVE_ARCH_ALLOC_REMAP
 extern void *alloc_remap(int nid, unsigned long size);
 #else
diff -puN mm/bootmem.c~mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator mm/bootmem.c
--- a/mm/bootmem.c~mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator
+++ a/mm/bootmem.c
@@ -803,28 +803,6 @@ void * __init __alloc_bootmem_node_high(
 
 }
 
-#ifdef CONFIG_SPARSEMEM
-/**
- * alloc_bootmem_section - allocate boot memory from a specific section
- * @size: size of the request in bytes
- * @section_nr: sparse map section to allocate from
- *
- * Return NULL on failure.
- */
-void * __init alloc_bootmem_section(unsigned long size,
-				    unsigned long section_nr)
-{
-	bootmem_data_t *bdata;
-	unsigned long pfn, goal;
-
-	pfn = section_nr_to_pfn(section_nr);
-	goal = pfn << PAGE_SHIFT;
-	bdata = &bootmem_node_data[early_pfn_to_nid(pfn)];
-
-	return alloc_bootmem_bdata(bdata, size, SMP_CACHE_BYTES, goal, 0);
-}
-#endif
-
 #ifndef ARCH_LOW_ADDRESS_LIMIT
 #define ARCH_LOW_ADDRESS_LIMIT	0xffffffffUL
 #endif
diff -puN mm/nobootmem.c~mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator mm/nobootmem.c
--- a/mm/nobootmem.c~mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator
+++ a/mm/nobootmem.c
@@ -355,28 +355,6 @@ void * __init __alloc_bootmem_node_high(
 	return __alloc_bootmem_node(pgdat, size, align, goal);
 }
 
-#ifdef CONFIG_SPARSEMEM
-/**
- * alloc_bootmem_section - allocate boot memory from a specific section
- * @size: size of the request in bytes
- * @section_nr: sparse map section to allocate from
- *
- * Return NULL on failure.
- */
-void * __init alloc_bootmem_section(unsigned long size,
-				    unsigned long section_nr)
-{
-	unsigned long pfn, goal, limit;
-
-	pfn = section_nr_to_pfn(section_nr);
-	goal = pfn << PAGE_SHIFT;
-	limit = section_nr_to_pfn(section_nr + 1) << PAGE_SHIFT;
-
-	return __alloc_memory_core_early(early_pfn_to_nid(pfn), size,
-					 SMP_CACHE_BYTES, goal, limit);
-}
-#endif
-
 #ifndef ARCH_LOW_ADDRESS_LIMIT
 #define ARCH_LOW_ADDRESS_LIMIT	0xffffffffUL
 #endif
diff -puN mm/sparse.c~mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator mm/sparse.c
--- a/mm/sparse.c~mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator
+++ a/mm/sparse.c
@@ -273,10 +273,10 @@ static unsigned long *__kmalloc_section_
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static unsigned long * __init
 sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
-					 unsigned long count)
+					 unsigned long size)
 {
-	unsigned long section_nr;
-
+	pg_data_t *host_pgdat;
+	unsigned long goal;
 	/*
 	 * A page may contain usemaps for other sections preventing the
 	 * page being freed and making a section unremovable while
@@ -287,8 +287,10 @@ sparse_early_usemaps_alloc_pgdat_section
 	 * from the same section as the pgdat where possible to avoid
 	 * this problem.
 	 */
-	section_nr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
-	return alloc_bootmem_section(usemap_size() * count, section_nr);
+	goal = __pa(pgdat) & PAGE_SECTION_MASK;
+	host_pgdat = NODE_DATA(early_pfn_to_nid(goal >> PAGE_SHIFT));
+	return __alloc_bootmem_node_nopanic(host_pgdat, size,
+					    SMP_CACHE_BYTES, goal);
 }
 
 static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
@@ -332,9 +334,9 @@ static void __init check_usemap_section_
 #else
 static unsigned long * __init
 sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
-					 unsigned long count)
+					 unsigned long size)
 {
-	return NULL;
+	return alloc_bootmem_node_nopanic(pgdat, size);
 }
 
 static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
@@ -352,13 +354,10 @@ static void __init sparse_early_usemaps_
 	int size = usemap_size();
 
 	usemap = sparse_early_usemaps_alloc_pgdat_section(NODE_DATA(nodeid),
-								 usemap_count);
+							  size * usemap_count);
 	if (!usemap) {
-		usemap = alloc_bootmem_node(NODE_DATA(nodeid), size * usemap_count);
-		if (!usemap) {
-			printk(KERN_WARNING "%s: allocation failed\n", __func__);
-			return;
-		}
+		printk(KERN_WARNING "%s: allocation failed\n", __func__);
+		return;
 	}
 
 	for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
mm-slab-remove-duplicate-check.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-simplify-migrate_huge_page-fix.patch
memcg-add-hugetlb-extension.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch


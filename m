From: akpm@linux-foundation.org
Subject: + mm-sparse-introduce-alloc_usemap_and_memmap.patch added to -mm
 tree
Date: Tue, 20 Aug 2013 16:08:21 -0700
Message-ID: <5213f6e5.gVx0d887IfvazHGI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3HTXIW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Aug 2013 19:08:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tj@kernel.org, rientjes@google.com, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, jkosina@suse.cz, isimatu.yasuaki@jp.fujitsu.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, fengguang.wu@intel.com, dave.hansen@linux.intel.com, liwanp@linux.vnet.ibm.com

Subject: + mm-sparse-introduce-alloc_usemap_and_memmap.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,dave.hansen@linux.intel.com,fengguang.wu@intel.com,hannes@cmpxchg.org,iamjoonsoo.kim@lge.com,isimatu.yasuaki@jp.fujitsu.com,jkosina@suse.cz,kosaki.motohiro@jp.fujitsu.com,riel@redhat.com,rientjes@google.com,tj@kernel.org,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 20 Aug 2013 16:08:21 -0700


The patch titled
     Subject: mm/sparse: introduce alloc_usemap_and_memmap
has been added to the -mm tree.  Its filename is
     mm-sparse-introduce-alloc_usemap_and_memmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-introduce-alloc_usemap_and_memmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-introduce-alloc_usemap_and_memmap.patch

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
Subject: mm/sparse: introduce alloc_usemap_and_memmap

After commit 9bdac91424075 ("sparsemem: Put mem map for one node
together."), vmemmap for one node will be allocated together, its logic is
similar as memory allocation for pageblock flags.  This patch introduces
alloc_usemap_and_memmap to extract the same logic of memory alloction for
pageblock flags and vmemmap.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |  140 +++++++++++++++++++++++---------------------------
 1 file changed, 66 insertions(+), 74 deletions(-)

diff -puN mm/sparse.c~mm-sparse-introduce-alloc_usemap_and_memmap mm/sparse.c
--- a/mm/sparse.c~mm-sparse-introduce-alloc_usemap_and_memmap
+++ a/mm/sparse.c
@@ -439,6 +439,14 @@ static void __init sparse_early_mem_maps
 					 map_count, nodeid);
 }
 #else
+
+static void __init sparse_early_mem_maps_alloc_node(struct page **map_map,
+				unsigned long pnum_begin,
+				unsigned long pnum_end,
+				unsigned long map_count, int nodeid)
+{
+}
+
 static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 {
 	struct page *map;
@@ -460,6 +468,62 @@ void __attribute__((weak)) __meminit vme
 {
 }
 
+/**
+ *  alloc_usemap_and_memmap - memory alloction for pageblock flags and vmemmap
+ *  @map: usemap_map for pageblock flags or mmap_map for vmemmap
+ *  @use_map: true if memory allocated for pageblock flags, otherwise false
+ */
+static void alloc_usemap_and_memmap(unsigned long **map, bool use_map)
+{
+	unsigned long pnum;
+	unsigned long map_count;
+	int nodeid_begin = 0;
+	unsigned long pnum_begin = 0;
+
+	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		struct mem_section *ms;
+
+		if (!present_section_nr(pnum))
+			continue;
+		ms = __nr_to_section(pnum);
+		nodeid_begin = sparse_early_nid(ms);
+		pnum_begin = pnum;
+		break;
+	}
+	map_count = 1;
+	for (pnum = pnum_begin + 1; pnum < NR_MEM_SECTIONS; pnum++) {
+		struct mem_section *ms;
+		int nodeid;
+
+		if (!present_section_nr(pnum))
+			continue;
+		ms = __nr_to_section(pnum);
+		nodeid = sparse_early_nid(ms);
+		if (nodeid == nodeid_begin) {
+			map_count++;
+			continue;
+		}
+		/* ok, we need to take cake of from pnum_begin to pnum - 1*/
+		if (use_map)
+			sparse_early_usemaps_alloc_node(map, pnum_begin, pnum,
+						 map_count, nodeid_begin);
+		else
+			sparse_early_mem_maps_alloc_node((struct page **)map,
+				pnum_begin, pnum, map_count, nodeid_begin);
+		/* new start, update count etc*/
+		nodeid_begin = nodeid;
+		pnum_begin = pnum;
+		map_count = 1;
+	}
+	/* ok, last chunk */
+	if (use_map)
+		sparse_early_usemaps_alloc_node(map, pnum_begin,
+				NR_MEM_SECTIONS, map_count, nodeid_begin);
+	else
+		sparse_early_mem_maps_alloc_node((struct page **)map,
+			pnum_begin, NR_MEM_SECTIONS, map_count, nodeid_begin);
+}
+
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
@@ -471,11 +535,7 @@ void __init sparse_init(void)
 	unsigned long *usemap;
 	unsigned long **usemap_map;
 	int size;
-	int nodeid_begin = 0;
-	unsigned long pnum_begin = 0;
-	unsigned long usemap_count;
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
-	unsigned long map_count;
 	int size2;
 	struct page **map_map;
 #endif
@@ -501,82 +561,14 @@ void __init sparse_init(void)
 	usemap_map = alloc_bootmem(size);
 	if (!usemap_map)
 		panic("can not allocate usemap_map\n");
-
-	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-		struct mem_section *ms;
-
-		if (!present_section_nr(pnum))
-			continue;
-		ms = __nr_to_section(pnum);
-		nodeid_begin = sparse_early_nid(ms);
-		pnum_begin = pnum;
-		break;
-	}
-	usemap_count = 1;
-	for (pnum = pnum_begin + 1; pnum < NR_MEM_SECTIONS; pnum++) {
-		struct mem_section *ms;
-		int nodeid;
-
-		if (!present_section_nr(pnum))
-			continue;
-		ms = __nr_to_section(pnum);
-		nodeid = sparse_early_nid(ms);
-		if (nodeid == nodeid_begin) {
-			usemap_count++;
-			continue;
-		}
-		/* ok, we need to take cake of from pnum_begin to pnum - 1*/
-		sparse_early_usemaps_alloc_node(usemap_map, pnum_begin, pnum,
-						 usemap_count, nodeid_begin);
-		/* new start, update count etc*/
-		nodeid_begin = nodeid;
-		pnum_begin = pnum;
-		usemap_count = 1;
-	}
-	/* ok, last chunk */
-	sparse_early_usemaps_alloc_node(usemap_map, pnum_begin, NR_MEM_SECTIONS,
-					 usemap_count, nodeid_begin);
+	alloc_usemap_and_memmap(usemap_map, true);
 
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
 	size2 = sizeof(struct page *) * NR_MEM_SECTIONS;
 	map_map = alloc_bootmem(size2);
 	if (!map_map)
 		panic("can not allocate map_map\n");
-
-	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-		struct mem_section *ms;
-
-		if (!present_section_nr(pnum))
-			continue;
-		ms = __nr_to_section(pnum);
-		nodeid_begin = sparse_early_nid(ms);
-		pnum_begin = pnum;
-		break;
-	}
-	map_count = 1;
-	for (pnum = pnum_begin + 1; pnum < NR_MEM_SECTIONS; pnum++) {
-		struct mem_section *ms;
-		int nodeid;
-
-		if (!present_section_nr(pnum))
-			continue;
-		ms = __nr_to_section(pnum);
-		nodeid = sparse_early_nid(ms);
-		if (nodeid == nodeid_begin) {
-			map_count++;
-			continue;
-		}
-		/* ok, we need to take cake of from pnum_begin to pnum - 1*/
-		sparse_early_mem_maps_alloc_node(map_map, pnum_begin, pnum,
-						 map_count, nodeid_begin);
-		/* new start, update count etc*/
-		nodeid_begin = nodeid;
-		pnum_begin = pnum;
-		map_count = 1;
-	}
-	/* ok, last chunk */
-	sparse_early_mem_maps_alloc_node(map_map, pnum_begin, NR_MEM_SECTIONS,
-					 map_count, nodeid_begin);
+	alloc_usemap_and_memmap((unsigned long **)map_map, false);
 #endif
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

mm-zswapc-get-swapper-address_space-by-using-macro.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_shmem_file_read.patch
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
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch
mm-sparse-introduce-alloc_usemap_and_memmap.patch
mm-writeback-make-writeback_inodes_wb-static.patch
mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch
linux-next.patch


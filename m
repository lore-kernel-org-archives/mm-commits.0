From: akpm@linux-foundation.org
Subject: +
 mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch added
 to -mm tree
Date: Mon, 09 Dec 2013 16:29:09 -0800
Message-ID: <52a66055.76Gq44S7kmAVygmN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3LJA3L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 19:29:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, santosh.shilimkar@ti.com, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, grygorii.strashko@ti.com

Subject: + mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch added to -mm tree
To: grygorii.strashko@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,santosh.shilimkar@ti.com,tj@kernel.org,tony@atomide.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 16:29:09 -0800


The patch titled
     Subject: mm/memblock: switch to use NUMA_NO_NODE instead of MAX_NUMNODES
has been added to the -mm tree.  Its filename is
     mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Grygorii Strashko <grygorii.strashko@ti.com>
Subject: mm/memblock: switch to use NUMA_NO_NODE instead of MAX_NUMNODES

It's recommended to use NUMA_NO_NODE everywhere to select "process any
node" behavior or to indicate that "no node id specified".

Hence, update __next_free_mem_range*() API's to accept both NUMA_NO_NODE
and MAX_NUMNODES, but emit warning once on MAX_NUMNODES, and correct
corresponding API's documentation to describe new behavior.  Also, update
other memblock/nobootmem APIs where MAX_NUMNODES is used dirrectly.

The change was suggested by Tejun Heo.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ++--
 mm/memblock.c            |   28 +++++++++++++++++++---------
 mm/nobootmem.c           |    8 ++++----
 3 files changed, 25 insertions(+), 15 deletions(-)

diff -puN include/linux/memblock.h~mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes
+++ a/include/linux/memblock.h
@@ -118,7 +118,7 @@ void __next_free_mem_range(u64 *idx, int
 /**
  * for_each_free_mem_range - iterate through free memblock areas
  * @i: u64 used as loop variable
- * @nid: node selector, %MAX_NUMNODES for all nodes
+ * @nid: node selector, %NUMA_NO_NODE for all nodes
  * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @p_nid: ptr to int for nid of the range, can be %NULL
@@ -138,7 +138,7 @@ void __next_free_mem_range_rev(u64 *idx,
 /**
  * for_each_free_mem_range_reverse - rev-iterate through free memblock areas
  * @i: u64 used as loop variable
- * @nid: node selector, %MAX_NUMNODES for all nodes
+ * @nid: node selector, %NUMA_NO_NODE for all nodes
  * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @p_nid: ptr to int for nid of the range, can be %NULL
diff -puN mm/memblock.c~mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes mm/memblock.c
--- a/mm/memblock.c~mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes
+++ a/mm/memblock.c
@@ -94,7 +94,7 @@ static long __init_memblock memblock_ove
  * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
  * @size: size of free area to find
  * @align: alignment of free area to find
- * @nid: nid of the free area to find, %MAX_NUMNODES for any node
+ * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
  *
  * Utility called from memblock_find_in_range_node(), find free area bottom-up.
  *
@@ -126,7 +126,7 @@ __memblock_find_range_bottom_up(phys_add
  * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
  * @size: size of free area to find
  * @align: alignment of free area to find
- * @nid: nid of the free area to find, %MAX_NUMNODES for any node
+ * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
  *
  * Utility called from memblock_find_in_range_node(), find free area top-down.
  *
@@ -161,7 +161,7 @@ __memblock_find_range_top_down(phys_addr
  * @align: alignment of free area to find
  * @start: start of candidate range
  * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
- * @nid: nid of the free area to find, %MAX_NUMNODES for any node
+ * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
  *
  * Find @size free area aligned to @align in the specified range and node.
  *
@@ -242,7 +242,7 @@ phys_addr_t __init_memblock memblock_fin
 					phys_addr_t align)
 {
 	return memblock_find_in_range_node(size, align, start, end,
-					    MAX_NUMNODES);
+					    NUMA_NO_NODE);
 }
 
 static void __init_memblock memblock_remove_region(struct memblock_type *type, unsigned long r)
@@ -754,7 +754,7 @@ int __init_memblock memblock_clear_hotpl
 /**
  * __next_free_mem_range - next function for for_each_free_mem_range()
  * @idx: pointer to u64 loop variable
- * @nid: node selector, %MAX_NUMNODES for all nodes
+ * @nid: node selector, %NUMA_NO_NODE for all nodes
  * @out_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @out_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @out_nid: ptr to int for nid of the range, can be %NULL
@@ -782,6 +782,11 @@ void __init_memblock __next_free_mem_ran
 	struct memblock_type *rsv = &memblock.reserved;
 	int mi = *idx & 0xffffffff;
 	int ri = *idx >> 32;
+	bool check_node = (nid != NUMA_NO_NODE) && (nid != MAX_NUMNODES);
+
+	if (nid == MAX_NUMNODES)
+		pr_warn_once("%s: Usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE instead\n",
+			     __func__);
 
 	for ( ; mi < mem->cnt; mi++) {
 		struct memblock_region *m = &mem->regions[mi];
@@ -789,7 +794,7 @@ void __init_memblock __next_free_mem_ran
 		phys_addr_t m_end = m->base + m->size;
 
 		/* only memory regions are associated with nodes, check it */
-		if (nid != MAX_NUMNODES && nid != memblock_get_region_node(m))
+		if (check_node && nid != memblock_get_region_node(m))
 			continue;
 
 		/* scan areas before each reservation for intersection */
@@ -830,7 +835,7 @@ void __init_memblock __next_free_mem_ran
 /**
  * __next_free_mem_range_rev - next function for for_each_free_mem_range_reverse()
  * @idx: pointer to u64 loop variable
- * @nid: nid: node selector, %MAX_NUMNODES for all nodes
+ * @nid: nid: node selector, %NUMA_NO_NODE for all nodes
  * @out_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @out_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @out_nid: ptr to int for nid of the range, can be %NULL
@@ -850,6 +855,11 @@ void __init_memblock __next_free_mem_ran
 	struct memblock_type *rsv = &memblock.reserved;
 	int mi = *idx & 0xffffffff;
 	int ri = *idx >> 32;
+	bool check_node = (nid != NUMA_NO_NODE) && (nid != MAX_NUMNODES);
+
+	if (nid == MAX_NUMNODES)
+		pr_warn_once("%s: Usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE instead\n",
+			     __func__);
 
 	if (*idx == (u64)ULLONG_MAX) {
 		mi = mem->cnt - 1;
@@ -862,7 +872,7 @@ void __init_memblock __next_free_mem_ran
 		phys_addr_t m_end = m->base + m->size;
 
 		/* only memory regions are associated with nodes, check it */
-		if (nid != MAX_NUMNODES && nid != memblock_get_region_node(m))
+		if (check_node && nid != memblock_get_region_node(m))
 			continue;
 
 		/* skip hotpluggable memory regions if needed */
@@ -989,7 +999,7 @@ phys_addr_t __init memblock_alloc_nid(ph
 
 phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
 {
-	return memblock_alloc_base_nid(size, align, max_addr, MAX_NUMNODES);
+	return memblock_alloc_base_nid(size, align, max_addr, NUMA_NO_NODE);
 }
 
 phys_addr_t __init memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
diff -puN mm/nobootmem.c~mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes mm/nobootmem.c
--- a/mm/nobootmem.c~mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes
+++ a/mm/nobootmem.c
@@ -117,7 +117,7 @@ static unsigned long __init free_low_mem
 	phys_addr_t start, end, size;
 	u64 i;
 
-	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL)
+	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
 	/* free range that is used for reserved array if we allocate it */
@@ -161,7 +161,7 @@ unsigned long __init free_all_bootmem(vo
 	reset_all_zones_managed_pages();
 
 	/*
-	 * We need to use MAX_NUMNODES instead of NODE_DATA(0)->node_id
+	 * We need to use NUMA_NO_NODE instead of NODE_DATA(0)->node_id
 	 *  because in some case like Node0 doesn't have RAM installed
 	 *  low ram will be on Node1
 	 */
@@ -215,7 +215,7 @@ static void * __init ___alloc_bootmem_no
 
 restart:
 
-	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align, goal, limit);
+	ptr = __alloc_memory_core_early(NUMA_NO_NODE, size, align, goal, limit);
 
 	if (ptr)
 		return ptr;
@@ -299,7 +299,7 @@ again:
 	if (ptr)
 		return ptr;
 
-	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
+	ptr = __alloc_memory_core_early(NUMA_NO_NODE, size, align,
 					goal, limit);
 	if (ptr)
 		return ptr;
_

Patches currently in -mm which might be from grygorii.strashko@ti.com are

mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch
mm-bootmem-remove-duplicated-declaration-of-__free_pages_bootmem.patch
mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch
mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch
mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch
mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
mm-init-use-memblock-apis-for-early-memory-allocations.patch
mm-printk-use-memblock-apis-for-early-memory-allocations.patch
mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch
mm-power-use-memblock-apis-for-early-memory-allocations.patch
lib-swiotlbc-use-memblock-apis-for-early-memory-allocations.patch
lib-cpumaskc-use-memblock-apis-for-early-memory-allocations.patch
mm-sparse-use-memblock-apis-for-early-memory-allocations.patch
mm-hugetlb-use-memblock-apis-for-early-memory-allocations.patch
mm-page_cgroup-use-memblock-apis-for-early-memory-allocations.patch
mm-percpu-use-memblock-apis-for-early-memory-allocations.patch
mm-memory_hotplug-use-memblock-apis-for-early-memory-allocations.patch
drivers-firmware-memmapc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-kernel-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mm-initc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mach-omap2-omap_hwmodc-use-memblock-apis-for-early-memory-allocations.patch
rtc-rtc-twl-use-devm_-functions.patch
rtc-rtc-vr41xx-use-devm_-functions.patch
linux-next.patch


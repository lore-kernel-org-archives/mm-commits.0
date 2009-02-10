From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole.patch removed from -mm tree
Date: Tue, 10 Feb 2009 15:24:52 -0800
Message-ID: <200902102324.n1ANOqmF011976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756209AbZBJXZI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 18:25:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, davem@davemlloft.net, heiko.carstens@de.ibm.com, mel@csn.ul.ie, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: fix memmap init to initialize valid memmap for memory hole
has been removed from the -mm tree.  Its filename was
     mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix memmap init to initialize valid memmap for memory hole
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

If PFN is not in early_node_map[] then struct page for it is not
initialized.  If there are holes within a MAX_ORDER_NE_PAGES range of
pages, then PG_reserved will not be set.  Code that walks PFNs within
MAX_ORDER_NR_PAGES will the use uninitialized struct pages.

To avoid any problems, this patch initializes holes within a
MAX_ORDER_NR_PAGES that valid memmap exists but is otherwise unused.

Sayeth davem:

What's happening is that the assertion in mm/page_alloc.c:move_freepages()
is triggering:

	BUG_ON(page_zone(start_page) != page_zone(end_page));

Once I knew this is what was happening, I added some annotations:

	if (unlikely(page_zone(start_page) != page_zone(end_page))) {
		printk(KERN_ERR "move_freepages: Bogus zones: "
		       "start_page[%p] end_page[%p] zone[%p]\n",
		       start_page, end_page, zone);
		printk(KERN_ERR "move_freepages: "
		       "start_zone[%p] end_zone[%p]\n",
		       page_zone(start_page), page_zone(end_page));
		printk(KERN_ERR "move_freepages: "
		       "start_pfn[0x%lx] end_pfn[0x%lx]\n",
		       page_to_pfn(start_page), page_to_pfn(end_page));
		printk(KERN_ERR "move_freepages: "
		       "start_nid[%d] end_nid[%d]\n",
		       page_to_nid(start_page), page_to_nid(end_page));
 ...

And here's what I got:

	move_freepages: Bogus zones: start_page[2207d0000] end_page[2207dffc0] zone[fffff8103effcb00]
	move_freepages: start_zone[fffff8103effcb00] end_zone[fffff8003fffeb00]
	move_freepages: start_pfn[0x81f600] end_pfn[0x81f7ff]
	move_freepages: start_nid[1] end_nid[0]

My memory layout on this box is:

[    0.000000] Zone PFN ranges:
[    0.000000]   Normal   0x00000000 -> 0x0081ff5d
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[8] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00020000
[    0.000000]     1: 0x00800000 -> 0x0081f7ff
[    0.000000]     1: 0x0081f800 -> 0x0081fe50
[    0.000000]     1: 0x0081fed1 -> 0x0081fed8
[    0.000000]     1: 0x0081feda -> 0x0081fedb
[    0.000000]     1: 0x0081fedd -> 0x0081fee5
[    0.000000]     1: 0x0081fee7 -> 0x0081ff51
[    0.000000]     1: 0x0081ff59 -> 0x0081ff5d

So it's a block move in that 0x81f600-->0x81f7ff region which triggers
the problem.

So I did a lot (and I do mean _A LOT_) of digging.  And it seems that
unless you set HOLES_IN_ZONE you have to make sure that all of the
memmap regions of free space in a zone begin and end on an HPAGE_SIZE
boundary (the requirement used to be that it had to be MAX_ORDER
sized).

Well, this assumption enterred the tree back in 2005 (!!!) from
the following commit in the history-2.6 tree:

commit 69fba2dd0335abec0b0de9ac53d5bbb67c31fc60
Author: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date:   Fri Jan 7 22:01:35 2005 -0800

    [PATCH] no buddy bitmap patch revisit: for mm/page_alloc.c


Reported-by: David Miller <davem@davemlloft.net>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/numa.c    |   12 ++++++++++--
 arch/x86/mm/numa_64.c  |    6 +++++-
 include/linux/mm.h     |    1 +
 include/linux/mmzone.h |    6 ------
 mm/page_alloc.c        |   34 +++++++++++++++++++++++++++++++---
 5 files changed, 47 insertions(+), 12 deletions(-)

diff -puN include/linux/mmzone.h~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole
+++ a/include/linux/mmzone.h
@@ -1070,12 +1070,6 @@ void sparse_init(void);
 #define sparse_index_init(_sec, _nid)  do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
-#ifdef CONFIG_NODES_SPAN_OTHER_NODES
-#define early_pfn_in_nid(pfn, nid)	(early_pfn_to_nid(pfn) == (nid))
-#else
-#define early_pfn_in_nid(pfn, nid)	(1)
-#endif
-
 #ifndef early_pfn_valid
 #define early_pfn_valid(pfn)	(1)
 #endif
diff -puN mm/page_alloc.c~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole
+++ a/mm/page_alloc.c
@@ -2557,6 +2557,21 @@ static inline unsigned long wait_table_b
  * higher will lead to a bigger reserve which will get freed as contiguous
  * blocks as reclaim kicks in
  */
+#ifdef CONFIG_NODE_SPAN_OTHER_NODE
+static inline bool init_pfn_under_nid(unsigned long pfn, int nid)
+{
+	int nid_in_map = early_pfn_to_nid_solid(pfn);
+
+	if (nid_in_map == -1)
+		return true;
+	return (nid_in_map == nid);
+}
+#else
+static inline bool init_pfn_under_nid(unsigned long pfn, int nid)
+{
+	return true;
+}
+#endif
 static void setup_zone_migrate_reserve(struct zone *zone)
 {
 	unsigned long start_pfn, pfn, end_pfn;
@@ -2635,7 +2650,11 @@ void __meminit memmap_init_zone(unsigned
 		if (context == MEMMAP_EARLY) {
 			if (!early_pfn_valid(pfn))
 				continue;
-			if (!early_pfn_in_nid(pfn, nid))
+			/*
+			 * This returns false if the page exists and it's
+			 * not under this node.
+			 */
+			if (!init_pfn_under_nid(pfn, nid))
 				continue;
 		}
 		page = pfn_to_page(pfn);
@@ -2990,7 +3009,7 @@ static int __meminit next_active_region_
  * was used and there are no special requirements, this is a convenient
  * alternative
  */
-int __meminit early_pfn_to_nid(unsigned long pfn)
+int __meminit early_pfn_to_nid_solid(unsigned long pfn)
 {
 	int i;
 
@@ -3001,8 +3020,17 @@ int __meminit early_pfn_to_nid(unsigned 
 		if (start_pfn <= pfn && pfn < end_pfn)
 			return early_node_map[i].nid;
 	}
+	return -1;
+}
+/* Allow fallback to 0 */
+int __meminit early_pfn_to_nid(unsigned long pfn)
+{
+	int nid;
 
-	return 0;
+	nid = early_pfn_to_nid_solid(pfn);
+	if (nid < 0)
+		return 0;
+	return nid;
 }
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
diff -puN arch/ia64/mm/numa.c~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole arch/ia64/mm/numa.c
--- a/arch/ia64/mm/numa.c~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole
+++ a/arch/ia64/mm/numa.c
@@ -58,7 +58,7 @@ paddr_to_nid(unsigned long paddr)
  * SPARSEMEM to allocate the SPARSEMEM sectionmap on the NUMA node where
  * the section resides.
  */
-int early_pfn_to_nid(unsigned long pfn)
+int early_pfn_to_nid_solid(unsigned long pfn)
 {
 	int i, section = pfn >> PFN_SECTION_SHIFT, ssec, esec;
 
@@ -70,9 +70,17 @@ int early_pfn_to_nid(unsigned long pfn)
 			return node_memblk[i].nid;
 	}
 
-	return 0;
+	return -1;
 }
 
+int early_pfn_to_nid(unsigned long pfn)
+{
+	int nid = early_pfn_to_nid_solid(pfn);
+
+	if (nid < 0) /* see page_alloc.c */
+		return 0;
+	return nid;
+}
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
  *  SRAT information is stored in node_memblk[], then we can use SRAT
diff -puN arch/x86/mm/numa_64.c~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole
+++ a/arch/x86/mm/numa_64.c
@@ -166,10 +166,14 @@ int __init compute_hash_shift(struct boo
 	return shift;
 }
 
-int early_pfn_to_nid(unsigned long pfn)
+int early_pfn_to_nid_solid(unsigned long pfn)
 {
 	return phys_to_nid(pfn << PAGE_SHIFT);
 }
+int early_pfn_to_nid(unsigned long pfn)
+{
+	return early_pfn_to_nid_solid(pfn);
+}
 
 static void * __init early_node_mem(int nodeid, unsigned long start,
 				    unsigned long end, unsigned long size,
diff -puN include/linux/mm.h~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole include/linux/mm.h
--- a/include/linux/mm.h~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole
+++ a/include/linux/mm.h
@@ -1047,6 +1047,7 @@ extern void work_with_active_regions(int
 extern void sparse_memory_present_with_active_regions(int nid);
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 extern int early_pfn_to_nid(unsigned long pfn);
+extern int early_pfn_to_solid(unsigned long pfn);
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 extern void set_dma_reserve(unsigned long new_dma_reserve);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-use-__gfp_nowarn-in-page-cgroup-allocation.patch
linux-next.patch
mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch


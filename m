From: akpm@linux-foundation.org
Subject: [folded] mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole-fix.patch removed from -mm tree
Date: Tue, 10 Feb 2009 15:24:24 -0800
Message-ID: <200902102324.n1ANOPnV011314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756041AbZBJXYh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 18:24:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, davem@davemlloft.net, heiko.carstens@de.ibm.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Aditional fix for memmap initalization
has been removed from the -mm tree.  Its filename was
     mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole-fix.patch

This patch was dropped because it was folded into mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Aditional fix for memmap initalization
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

After investigation, changing return value of early_pfn_to_nid() doesn't seem
to be very good. This patch adds early_pfn_to_nid_solid() for our purpose
(init memmap) and fixes all breakage.

Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Miller <davem@davemlloft.net>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/numa.c   |   12 ++++++++++--
 arch/x86/mm/numa_64.c |    6 +++++-
 include/linux/mm.h    |    1 +
 mm/page_alloc.c       |   39 +++++++++++++++++++++++++++++----------
 4 files changed, 45 insertions(+), 13 deletions(-)

diff -puN arch/ia64/mm/numa.c~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole-fix arch/ia64/mm/numa.c
--- a/arch/ia64/mm/numa.c~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole-fix
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
diff -puN arch/x86/mm/numa_64.c~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole-fix arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole-fix
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
diff -puN include/linux/mm.h~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole-fix
+++ a/include/linux/mm.h
@@ -1047,6 +1047,7 @@ extern void work_with_active_regions(int
 extern void sparse_memory_present_with_active_regions(int nid);
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 extern int early_pfn_to_nid(unsigned long pfn);
+extern int early_pfn_to_solid(unsigned long pfn);
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 extern void set_dma_reserve(unsigned long new_dma_reserve);
diff -puN mm/page_alloc.c~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole-fix
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
@@ -2633,18 +2648,13 @@ void __meminit memmap_init_zone(unsigned
 		 * exist on hotplugged memory.
 		 */
 		if (context == MEMMAP_EARLY) {
-			int nid_from_node_memory_map;
-
 			if (!early_pfn_valid(pfn))
 				continue;
 			/*
-			 * early_pfn_to_nid() returns -1 if the page doesn't
-			 * exist in early_node_map[]. Initialize it in force
-			 * and set PG_reserved at el.
+			 * This returns false if the page exists and it's
+			 * not under this node.
 			 */
-			nid_from_node_memory_map = early_pfn_to_nid(pfn);
-			if (nid_from_node_memory_map > -1 &&
-				nid_from_node_memory_map != nid)
+			if (!init_pfn_under_nid(pfn, nid))
 				continue;
 		}
 		page = pfn_to_page(pfn);
@@ -2999,7 +3009,7 @@ static int __meminit next_active_region_
  * was used and there are no special requirements, this is a convenient
  * alternative
  */
-int __meminit early_pfn_to_nid(unsigned long pfn)
+int __meminit early_pfn_to_nid_solid(unsigned long pfn)
 {
 	int i;
 
@@ -3010,9 +3020,18 @@ int __meminit early_pfn_to_nid(unsigned 
 		if (start_pfn <= pfn && pfn < end_pfn)
 			return early_node_map[i].nid;
 	}
-
 	return -1;
 }
+/* Allow fallback to 0 */
+int __meminit early_pfn_to_nid(unsigned long pfn)
+{
+	int nid;
+
+	nid = early_pfn_to_nid_solid(pfn);
+	if (nid < 0)
+		return 0;
+	return nid;
+}
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
 /* Basic iterator support to walk early_node_map[] */
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-use-__gfp_nowarn-in-page-cgroup-allocation.patch
linux-next.patch
mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole.patch
mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole-fix.patch
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


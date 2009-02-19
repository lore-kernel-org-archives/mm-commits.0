From: akpm@linux-foundation.org
Subject: [merged] mm-clean-up-for-early_pfn_to_nid.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:17:01 -0800
Message-ID: <200902191917.n1JJH1Av016326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754049AbZBSTTJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:19:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, davem@davemlloft.net, heiko.carstens@de.ibm.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: clean up for early_pfn_to_nid()
has been removed from the -mm tree.  Its filename was
     mm-clean-up-for-early_pfn_to_nid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: clean up for early_pfn_to_nid()
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

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


This patch:

Declaration of early_pfn_to_nid() is scattered over per-arch include
files, and it seems it's complicated to know when the declaration is used.
 I think it makes fix-for-memmap-init not easy.

This patch moves all declaration to include/linux/mm.h

After this,
  if !CONFIG_NODES_POPULATES_NODE_MAP && !CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
     -> Use static definition in include/linux/mm.h
  else if !CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
     -> Use generic definition in mm/page_alloc.c
  else
     -> per-arch back end function will be called.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported-by: David Miller <davem@davemlloft.net>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x, 2.6.27.x, 2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/mmzone.h   |    4 ----
 arch/ia64/mm/numa.c              |    2 +-
 arch/x86/include/asm/mmzone_32.h |    2 --
 arch/x86/include/asm/mmzone_64.h |    2 --
 arch/x86/mm/numa_64.c            |    2 +-
 include/linux/mm.h               |   19 ++++++++++++++++---
 mm/page_alloc.c                  |    8 +++++++-
 7 files changed, 25 insertions(+), 14 deletions(-)

diff -puN arch/ia64/include/asm/mmzone.h~mm-clean-up-for-early_pfn_to_nid arch/ia64/include/asm/mmzone.h
--- a/arch/ia64/include/asm/mmzone.h~mm-clean-up-for-early_pfn_to_nid
+++ a/arch/ia64/include/asm/mmzone.h
@@ -31,10 +31,6 @@ static inline int pfn_to_nid(unsigned lo
 #endif
 }
 
-#ifdef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
-extern int early_pfn_to_nid(unsigned long pfn);
-#endif
-
 #ifdef CONFIG_IA64_DIG /* DIG systems are small */
 # define MAX_PHYSNODE_ID	8
 # define NR_NODE_MEMBLKS	(MAX_NUMNODES * 8)
diff -puN arch/ia64/mm/numa.c~mm-clean-up-for-early_pfn_to_nid arch/ia64/mm/numa.c
--- a/arch/ia64/mm/numa.c~mm-clean-up-for-early_pfn_to_nid
+++ a/arch/ia64/mm/numa.c
@@ -58,7 +58,7 @@ paddr_to_nid(unsigned long paddr)
  * SPARSEMEM to allocate the SPARSEMEM sectionmap on the NUMA node where
  * the section resides.
  */
-int early_pfn_to_nid(unsigned long pfn)
+int __meminit __early_pfn_to_nid(unsigned long pfn)
 {
 	int i, section = pfn >> PFN_SECTION_SHIFT, ssec, esec;
 
diff -puN arch/x86/include/asm/mmzone_32.h~mm-clean-up-for-early_pfn_to_nid arch/x86/include/asm/mmzone_32.h
--- a/arch/x86/include/asm/mmzone_32.h~mm-clean-up-for-early_pfn_to_nid
+++ a/arch/x86/include/asm/mmzone_32.h
@@ -32,8 +32,6 @@ static inline void get_memcfg_numa(void)
 	get_memcfg_numa_flat();
 }
 
-extern int early_pfn_to_nid(unsigned long pfn);
-
 extern void resume_map_numa_kva(pgd_t *pgd);
 
 #else /* !CONFIG_NUMA */
diff -puN arch/x86/include/asm/mmzone_64.h~mm-clean-up-for-early_pfn_to_nid arch/x86/include/asm/mmzone_64.h
--- a/arch/x86/include/asm/mmzone_64.h~mm-clean-up-for-early_pfn_to_nid
+++ a/arch/x86/include/asm/mmzone_64.h
@@ -40,8 +40,6 @@ static inline __attribute__((pure)) int 
 #define node_end_pfn(nid)       (NODE_DATA(nid)->node_start_pfn +	\
 				 NODE_DATA(nid)->node_spanned_pages)
 
-extern int early_pfn_to_nid(unsigned long pfn);
-
 #ifdef CONFIG_NUMA_EMU
 #define FAKE_NODE_MIN_SIZE	(64 * 1024 * 1024)
 #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
diff -puN arch/x86/mm/numa_64.c~mm-clean-up-for-early_pfn_to_nid arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~mm-clean-up-for-early_pfn_to_nid
+++ a/arch/x86/mm/numa_64.c
@@ -145,7 +145,7 @@ int __init compute_hash_shift(struct boo
 	return shift;
 }
 
-int early_pfn_to_nid(unsigned long pfn)
+int __meminit  __early_pfn_to_nid(unsigned long pfn)
 {
 	return phys_to_nid(pfn << PAGE_SHIFT);
 }
diff -puN include/linux/mm.h~mm-clean-up-for-early_pfn_to_nid include/linux/mm.h
--- a/include/linux/mm.h~mm-clean-up-for-early_pfn_to_nid
+++ a/include/linux/mm.h
@@ -1041,10 +1041,23 @@ extern void free_bootmem_with_active_reg
 typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
 extern void work_with_active_regions(int nid, work_fn_t work_fn, void *data);
 extern void sparse_memory_present_with_active_regions(int nid);
-#ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
-extern int early_pfn_to_nid(unsigned long pfn);
-#endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
+
+#if !defined(CONFIG_ARCH_POPULATES_NODE_MAP) && \
+    !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
+static inline int __early_pfn_to_nid(unsigned long pfn)
+{
+	return 0;
+}
+#else
+/* please see mm/page_alloc.c */
+extern int __meminit early_pfn_to_nid(unsigned long pfn);
+#ifdef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
+/* there is a per-arch backend function. */
+extern int __meminit __early_pfn_to_nid(unsigned long pfn);
+#endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
+#endif
+
 extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long,
 				unsigned long, enum memmap_context);
diff -puN mm/page_alloc.c~mm-clean-up-for-early_pfn_to_nid mm/page_alloc.c
--- a/mm/page_alloc.c~mm-clean-up-for-early_pfn_to_nid
+++ a/mm/page_alloc.c
@@ -2989,7 +2989,7 @@ static int __meminit next_active_region_
  * was used and there are no special requirements, this is a convenient
  * alternative
  */
-int __meminit early_pfn_to_nid(unsigned long pfn)
+int __meminit __early_pfn_to_nid(unsigned long pfn)
 {
 	int i;
 
@@ -3005,6 +3005,12 @@ int __meminit early_pfn_to_nid(unsigned 
 }
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
+int __meminit early_pfn_to_nid(unsigned long pfn)
+{
+	return __early_pfn_to_nid(pfn);
+}
+
+
 /* Basic iterator support to walk early_node_map[] */
 #define for_each_active_range_index_in_nid(i, nid) \
 	for (i = first_active_region_index_in_nid(nid); i != -1; \
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
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


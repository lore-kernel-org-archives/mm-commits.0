From: akpm@linux-foundation.org
Subject: [patch 034/101] mm: move page mapped accounting to the node
Date: Thu, 28 Jul 2016 15:46:14 -0700
Message-ID: <579a8b36.bo9m/smpjntwMhJ8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbcG1WqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:46:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: move page mapped accounting to the node

Reclaim makes decisions based on the number of pages that are mapped but
it's mixing node and zone information.  Account NR_FILE_MAPPED and
NR_ANON_PAGES pages on the node.

Link: http://lkml.kernel.org/r/1467970510-21195-18-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/mm/pgtable.c |    2 +-
 drivers/base/node.c    |    4 ++--
 fs/proc/meminfo.c      |    4 ++--
 include/linux/mmzone.h |    6 +++---
 mm/page_alloc.c        |    6 +++---
 mm/rmap.c              |   14 +++++++-------
 mm/vmscan.c            |    2 +-
 mm/vmstat.c            |    4 ++--
 8 files changed, 21 insertions(+), 21 deletions(-)

diff -puN arch/tile/mm/pgtable.c~mm-move-page-mapped-accounting-to-the-node arch/tile/mm/pgtable.c
--- a/arch/tile/mm/pgtable.c~mm-move-page-mapped-accounting-to-the-node
+++ a/arch/tile/mm/pgtable.c
@@ -55,7 +55,7 @@ void show_mem(unsigned int filter)
 	       global_page_state(NR_FREE_PAGES),
 	       (global_page_state(NR_SLAB_RECLAIMABLE) +
 		global_page_state(NR_SLAB_UNRECLAIMABLE)),
-	       global_page_state(NR_FILE_MAPPED),
+	       global_node_page_state(NR_FILE_MAPPED),
 	       global_page_state(NR_PAGETABLE),
 	       global_page_state(NR_BOUNCE),
 	       global_page_state(NR_FILE_PAGES),
diff -puN drivers/base/node.c~mm-move-page-mapped-accounting-to-the-node drivers/base/node.c
--- a/drivers/base/node.c~mm-move-page-mapped-accounting-to-the-node
+++ a/drivers/base/node.c
@@ -121,8 +121,8 @@ static ssize_t node_read_meminfo(struct
 		       nid, K(sum_zone_node_page_state(nid, NR_FILE_DIRTY)),
 		       nid, K(sum_zone_node_page_state(nid, NR_WRITEBACK)),
 		       nid, K(sum_zone_node_page_state(nid, NR_FILE_PAGES)),
-		       nid, K(sum_zone_node_page_state(nid, NR_FILE_MAPPED)),
-		       nid, K(sum_zone_node_page_state(nid, NR_ANON_PAGES)),
+		       nid, K(node_page_state(pgdat, NR_FILE_MAPPED)),
+		       nid, K(node_page_state(pgdat, NR_ANON_PAGES)),
 		       nid, K(i.sharedram),
 		       nid, sum_zone_node_page_state(nid, NR_KERNEL_STACK) *
 				THREAD_SIZE / 1024,
diff -puN fs/proc/meminfo.c~mm-move-page-mapped-accounting-to-the-node fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-move-page-mapped-accounting-to-the-node
+++ a/fs/proc/meminfo.c
@@ -140,8 +140,8 @@ static int meminfo_proc_show(struct seq_
 		K(i.freeswap),
 		K(global_page_state(NR_FILE_DIRTY)),
 		K(global_page_state(NR_WRITEBACK)),
-		K(global_page_state(NR_ANON_PAGES)),
-		K(global_page_state(NR_FILE_MAPPED)),
+		K(global_node_page_state(NR_ANON_PAGES)),
+		K(global_node_page_state(NR_FILE_MAPPED)),
 		K(i.sharedram),
 		K(global_page_state(NR_SLAB_RECLAIMABLE) +
 				global_page_state(NR_SLAB_UNRECLAIMABLE)),
diff -puN include/linux/mmzone.h~mm-move-page-mapped-accounting-to-the-node include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-move-page-mapped-accounting-to-the-node
+++ a/include/linux/mmzone.h
@@ -115,9 +115,6 @@ enum zone_stat_item {
 	NR_ZONE_LRU_ANON = NR_ZONE_LRU_BASE,
 	NR_ZONE_LRU_FILE,
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
-	NR_ANON_PAGES,	/* Mapped anonymous pages */
-	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
-			   only modified from process context */
 	NR_FILE_PAGES,
 	NR_FILE_DIRTY,
 	NR_WRITEBACK,
@@ -164,6 +161,9 @@ enum node_stat_item {
 	WORKINGSET_REFAULT,
 	WORKINGSET_ACTIVATE,
 	WORKINGSET_NODERECLAIM,
+	NR_ANON_PAGES,	/* Mapped anonymous pages */
+	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
+			   only modified from process context */
 	NR_VM_NODE_STAT_ITEMS
 };
 
diff -puN mm/page_alloc.c~mm-move-page-mapped-accounting-to-the-node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-move-page-mapped-accounting-to-the-node
+++ a/mm/page_alloc.c
@@ -4312,7 +4312,7 @@ void show_free_areas(unsigned int filter
 		global_page_state(NR_UNSTABLE_NFS),
 		global_page_state(NR_SLAB_RECLAIMABLE),
 		global_page_state(NR_SLAB_UNRECLAIMABLE),
-		global_page_state(NR_FILE_MAPPED),
+		global_node_page_state(NR_FILE_MAPPED),
 		global_page_state(NR_SHMEM),
 		global_page_state(NR_PAGETABLE),
 		global_page_state(NR_BOUNCE),
@@ -4334,6 +4334,7 @@ void show_free_areas(unsigned int filter
 			" unevictable:%lukB"
 			" isolated(anon):%lukB"
 			" isolated(file):%lukB"
+			" mapped:%lukB"
 			" all_unreclaimable? %s"
 			"\n",
 			pgdat->node_id,
@@ -4344,6 +4345,7 @@ void show_free_areas(unsigned int filter
 			K(node_page_state(pgdat, NR_UNEVICTABLE)),
 			K(node_page_state(pgdat, NR_ISOLATED_ANON)),
 			K(node_page_state(pgdat, NR_ISOLATED_FILE)),
+			K(node_page_state(pgdat, NR_FILE_MAPPED)),
 			!pgdat_reclaimable(pgdat) ? "yes" : "no");
 	}
 
@@ -4368,7 +4370,6 @@ void show_free_areas(unsigned int filter
 			" mlocked:%lukB"
 			" dirty:%lukB"
 			" writeback:%lukB"
-			" mapped:%lukB"
 			" shmem:%lukB"
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			" shmem_thp: %lukB"
@@ -4397,7 +4398,6 @@ void show_free_areas(unsigned int filter
 			K(zone_page_state(zone, NR_MLOCK)),
 			K(zone_page_state(zone, NR_FILE_DIRTY)),
 			K(zone_page_state(zone, NR_WRITEBACK)),
-			K(zone_page_state(zone, NR_FILE_MAPPED)),
 			K(zone_page_state(zone, NR_SHMEM)),
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			K(zone_page_state(zone, NR_SHMEM_THPS) * HPAGE_PMD_NR),
diff -puN mm/rmap.c~mm-move-page-mapped-accounting-to-the-node mm/rmap.c
--- a/mm/rmap.c~mm-move-page-mapped-accounting-to-the-node
+++ a/mm/rmap.c
@@ -1214,7 +1214,7 @@ void do_page_add_anon_rmap(struct page *
 		 */
 		if (compound)
 			__inc_zone_page_state(page, NR_ANON_THPS);
-		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, nr);
+		__mod_node_page_state(page_pgdat(page), NR_ANON_PAGES, nr);
 	}
 	if (unlikely(PageKsm(page)))
 		return;
@@ -1258,7 +1258,7 @@ void page_add_new_anon_rmap(struct page
 		/* increment count (starts at -1) */
 		atomic_set(&page->_mapcount, 0);
 	}
-	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, nr);
+	__mod_node_page_state(page_pgdat(page), NR_ANON_PAGES, nr);
 	__page_set_anon_rmap(page, vma, address, 1);
 }
 
@@ -1293,7 +1293,7 @@ void page_add_file_rmap(struct page *pag
 		if (!atomic_inc_and_test(&page->_mapcount))
 			goto out;
 	}
-	__mod_zone_page_state(page_zone(page), NR_FILE_MAPPED, nr);
+	__mod_node_page_state(page_pgdat(page), NR_FILE_MAPPED, nr);
 	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
 out:
 	unlock_page_memcg(page);
@@ -1329,11 +1329,11 @@ static void page_remove_file_rmap(struct
 	}
 
 	/*
-	 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
+	 * We use the irq-unsafe __{inc|mod}_zone_page_state because
 	 * these counters are not modified in interrupt context, and
 	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
-	__mod_zone_page_state(page_zone(page), NR_FILE_MAPPED, -nr);
+	__mod_node_page_state(page_pgdat(page), NR_FILE_MAPPED, -nr);
 	mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
 
 	if (unlikely(PageMlocked(page)))
@@ -1375,7 +1375,7 @@ static void page_remove_anon_compound_rm
 		clear_page_mlock(page);
 
 	if (nr) {
-		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, -nr);
+		__mod_node_page_state(page_pgdat(page), NR_ANON_PAGES, -nr);
 		deferred_split_huge_page(page);
 	}
 }
@@ -1404,7 +1404,7 @@ void page_remove_rmap(struct page *page,
 	 * these counters are not modified in interrupt context, and
 	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
-	__dec_zone_page_state(page, NR_ANON_PAGES);
+	__dec_node_page_state(page, NR_ANON_PAGES);
 
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
diff -puN mm/vmscan.c~mm-move-page-mapped-accounting-to-the-node mm/vmscan.c
--- a/mm/vmscan.c~mm-move-page-mapped-accounting-to-the-node
+++ a/mm/vmscan.c
@@ -3589,7 +3589,7 @@ int sysctl_min_slab_ratio = 5;
 
 static inline unsigned long zone_unmapped_file_pages(struct zone *zone)
 {
-	unsigned long file_mapped = zone_page_state(zone, NR_FILE_MAPPED);
+	unsigned long file_mapped = node_page_state(zone->zone_pgdat, NR_FILE_MAPPED);
 	unsigned long file_lru = node_page_state(zone->zone_pgdat, NR_INACTIVE_FILE) +
 		node_page_state(zone->zone_pgdat, NR_ACTIVE_FILE);
 
diff -puN mm/vmstat.c~mm-move-page-mapped-accounting-to-the-node mm/vmstat.c
--- a/mm/vmstat.c~mm-move-page-mapped-accounting-to-the-node
+++ a/mm/vmstat.c
@@ -925,8 +925,6 @@ const char * const vmstat_text[] = {
 	"nr_zone_anon_lru",
 	"nr_zone_file_lru",
 	"nr_mlock",
-	"nr_anon_pages",
-	"nr_mapped",
 	"nr_file_pages",
 	"nr_dirty",
 	"nr_writeback",
@@ -970,6 +968,8 @@ const char * const vmstat_text[] = {
 	"workingset_refault",
 	"workingset_activate",
 	"workingset_nodereclaim",
+	"nr_anon_pages",
+	"nr_mapped",
 
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
_

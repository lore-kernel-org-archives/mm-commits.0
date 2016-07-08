From: akpm@linux-foundation.org
Subject: + mm-move-page-mapped-accounting-to-the-node.patch added to -mm
 tree
Date: Fri, 08 Jul 2016 13:33:46 -0700
Message-ID: <57800e2a.0WBiAvtcGDnuPuFT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbcGHUdr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 16:33:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move page mapped accounting to the node
has been added to the -mm tree.  Its filename is
     mm-move-page-mapped-accounting-to-the-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-page-mapped-accounting-to-the-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-page-mapped-accounting-to-the-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
@@ -1217,7 +1217,7 @@ void do_page_add_anon_rmap(struct page *
 		 */
 		if (compound)
 			__inc_zone_page_state(page, NR_ANON_THPS);
-		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, nr);
+		__mod_node_page_state(page_pgdat(page), NR_ANON_PAGES, nr);
 	}
 	if (unlikely(PageKsm(page)))
 		return;
@@ -1261,7 +1261,7 @@ void page_add_new_anon_rmap(struct page
 		/* increment count (starts at -1) */
 		atomic_set(&page->_mapcount, 0);
 	}
-	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, nr);
+	__mod_node_page_state(page_pgdat(page), NR_ANON_PAGES, nr);
 	__page_set_anon_rmap(page, vma, address, 1);
 }
 
@@ -1296,7 +1296,7 @@ void page_add_file_rmap(struct page *pag
 		if (!atomic_inc_and_test(&page->_mapcount))
 			goto out;
 	}
-	__mod_zone_page_state(page_zone(page), NR_FILE_MAPPED, nr);
+	__mod_node_page_state(page_pgdat(page), NR_FILE_MAPPED, nr);
 	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
 out:
 	unlock_page_memcg(page);
@@ -1332,11 +1332,11 @@ static void page_remove_file_rmap(struct
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
@@ -1378,7 +1378,7 @@ static void page_remove_anon_compound_rm
 		clear_page_mlock(page);
 
 	if (nr) {
-		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, -nr);
+		__mod_node_page_state(page_pgdat(page), NR_ANON_PAGES, -nr);
 		deferred_split_huge_page(page);
 	}
 }
@@ -1407,7 +1407,7 @@ void page_remove_rmap(struct page *page,
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
@@ -3587,7 +3587,7 @@ int sysctl_min_slab_ratio = 5;
 
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

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-meminit-always-return-a-valid-node-from-early_pfn_to_nid.patch
mm-meminit-ensure-node-is-online-before-checking-whether-pages-are-uninitialised.patch
mm-meminit-remove-early_page_nid_uninitialised.patch
mm-vmstat-add-infrastructure-for-per-node-vmstats.patch
mm-vmscan-move-lru_lock-to-the-node.patch
mm-vmscan-move-lru-lists-to-node.patch
mm-mmzone-clarify-the-usage-of-zone-padding.patch
mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis.patch
mm-vmscan-have-kswapd-only-scan-based-on-the-highest-requested-zone.patch
mm-vmscan-make-kswapd-reclaim-in-terms-of-nodes.patch
mm-vmscan-remove-balance-gap.patch
mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps.patch
mm-vmscan-by-default-have-direct-reclaim-only-shrink-once-per-node.patch
mm-vmscan-remove-duplicate-logic-clearing-node-congestion-and-dirty-state.patch
mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch
mm-vmscan-make-shrink_node-decisions-more-node-centric.patch
mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch
mm-workingset-make-working-set-detection-node-aware.patch
mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes.patch
mm-move-page-mapped-accounting-to-the-node.patch
mm-rename-nr_anon_pages-to-nr_anon_mapped.patch
mm-move-most-file-based-accounting-to-the-node.patch
mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch
mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch
mm-page_alloc-wake-kswapd-based-on-the-highest-eligible-zone.patch
mm-convert-zone_reclaim-to-node_reclaim.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready.patch
mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch
mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch


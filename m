From: akpm@linux-foundation.org
Subject: + mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg.patch added to -mm tree
Date: Fri, 15 Jul 2016 13:37:46 -0700
Message-ID: <5789499a.ir48/61OOf5pHXF6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbcGOUhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jul 2016 16:37:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: Update all zone LRU sizes before updating memcg
has been added to the -mm tree.  Its filename is
     mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg.patch

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
Subject: mm, vmscan: Update all zone LRU sizes before updating memcg

Minchan Kim reported setting the following warning on a 32-bit system
although it can affect 64-bit systems.

  WARNING: CPU: 4 PID: 1322 at mm/memcontrol.c:998 mem_cgroup_update_lru_size+0x103/0x110
  mem_cgroup_update_lru_size(f44b4000, 1, -7): zid 1 lru_size 1 but empty
  Modules linked in:
  CPU: 4 PID: 1322 Comm: cp Not tainted 4.7.0-rc4-mm1+ #143
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
   00000086 00000086 c2bc5a10 db3e4a97 c2bc5a54 db9d4025 c2bc5a40 db07b82a
   db9d0594 c2bc5a70 0000052a db9d4025 000003e6 db208463 000003e6 00000001
   f44b4000 00000001 c2bc5a5c db07b88b 00000009 00000000 c2bc5a54 db9d0594
  Call Trace:
   [<db3e4a97>] dump_stack+0x76/0xaf
   [<db07b82a>] __warn+0xea/0x110
   [<db208463>] ? mem_cgroup_update_lru_size+0x103/0x110
   [<db07b88b>] warn_slowpath_fmt+0x3b/0x40
   [<db208463>] mem_cgroup_update_lru_size+0x103/0x110
   [<db1b52a2>] isolate_lru_pages.isra.61+0x2e2/0x360
   [<db1b6ffc>] shrink_active_list+0xac/0x2a0
   [<db3f136e>] ? __delay+0xe/0x10
   [<db1b772c>] shrink_node_memcg+0x53c/0x7a0
   [<db1b7a3b>] shrink_node+0xab/0x2a0
   [<db1b7cf6>] do_try_to_free_pages+0xc6/0x390
   [<db1b8205>] try_to_free_pages+0x245/0x590

LRU list contents and counts are updated separately. Counts are updated
before pages are added to the LRU and updated after pages are removed.
The warning above is from a check in mem_cgroup_update_lru_size that
ensures that list sizes of zero are empty.

The problem is that node-lru needs to account for highmem pages if
CONFIG_HIGHMEM is set. One impact of the implementation is that the
sizes are updated in multiple passes when pages from multiple zones were
isolated. This happens whether HIGHMEM is set or not. When multiple zones
are isolated, it's possible for a debugging check in memcg to be tripped.

This patch forces all the zone counts to be updated before the memcg
function is called.

Link: http://lkml.kernel.org/r/1468588165-12461-6-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: Minchan Kim <minchan@kernel.org>
Reported-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 -
 include/linux/mm_inline.h  |    5 +---
 mm/memcontrol.c            |    5 ----
 mm/vmscan.c                |   40 ++++++++++++++++++++++++++++-------
 4 files changed, 37 insertions(+), 15 deletions(-)

diff -puN include/linux/memcontrol.h~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg
+++ a/include/linux/memcontrol.h
@@ -431,7 +431,7 @@ static inline bool mem_cgroup_online(str
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
 
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-		enum zone_type zid, int nr_pages);
+		int nr_pages);
 
 unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
 					   int nid, unsigned int lru_mask);
diff -puN include/linux/mm_inline.h~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg
+++ a/include/linux/mm_inline.h
@@ -56,10 +56,9 @@ static __always_inline void update_lru_s
 				enum lru_list lru, enum zone_type zid,
 				int nr_pages)
 {
-#ifdef CONFIG_MEMCG
-	mem_cgroup_update_lru_size(lruvec, lru, zid, nr_pages);
-#else
 	__update_lru_size(lruvec, lru, zid, nr_pages);
+#ifdef CONFIG_MEMCG
+	mem_cgroup_update_lru_size(lruvec, lru, nr_pages);
 #endif
 }
 
diff -puN mm/memcontrol.c~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg mm/memcontrol.c
--- a/mm/memcontrol.c~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg
+++ a/mm/memcontrol.c
@@ -965,7 +965,6 @@ out:
  * mem_cgroup_update_lru_size - account for adding or removing an lru page
  * @lruvec: mem_cgroup per zone lru vector
  * @lru: index of lru list the page is sitting on
- * @zid: Zone ID of the zone pages have been added to
  * @nr_pages: positive when adding or negative when removing
  *
  * This function must be called under lru_lock, just before a page is added
@@ -973,15 +972,13 @@ out:
  * so as to allow it to check that lru_size 0 is consistent with list_empty).
  */
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-				enum zone_type zid, int nr_pages)
+				int nr_pages)
 {
 	struct mem_cgroup_per_node *mz;
 	unsigned long *lru_size;
 	long size;
 	bool empty;
 
-	__update_lru_size(lruvec, lru, zid, nr_pages);
-
 	if (mem_cgroup_disabled())
 		return;
 
diff -puN mm/vmscan.c~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg
+++ a/mm/vmscan.c
@@ -1350,6 +1350,38 @@ int __isolate_lru_page(struct page *page
 	return ret;
 }
 
+
+/*
+ * Update LRU sizes after isolating pages. The LRU size updates must
+ * be complete before mem_cgroup_update_lru_size due to a santity check.
+ */
+static __always_inline void update_lru_sizes(struct lruvec *lruvec,
+			enum lru_list lru, unsigned long *nr_zone_taken,
+			unsigned long nr_taken)
+{
+#ifdef CONFIG_HIGHMEM
+	int zid;
+
+	/*
+	 * Highmem has separate accounting for highmem pages so each zone
+	 * is updated separately.
+	 */
+	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+		if (!nr_zone_taken[zid])
+			continue;
+
+		__update_lru_size(lruvec, lru, zid, -nr_zone_taken[zid]);
+	}
+#else
+	/* Zone ID does not matter on !HIGHMEM */
+	__update_lru_size(lruvec, lru, 0, -nr_taken);
+#endif
+
+#ifdef CONFIG_MEMCG
+	mem_cgroup_update_lru_size(lruvec, lru, -nr_taken);
+#endif
+}
+
 /*
  * zone_lru_lock is heavily contended.  Some of the functions that
  * shrink the lists perform better by taking out a batch of pages
@@ -1436,13 +1468,7 @@ static unsigned long isolate_lru_pages(u
 	*nr_scanned = scan;
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan, scan,
 				    nr_taken, mode, is_file_lru(lru));
-	for (scan = 0; scan < MAX_NR_ZONES; scan++) {
-		nr_pages = nr_zone_taken[scan];
-		if (!nr_pages)
-			continue;
-
-		update_lru_size(lruvec, lru, scan, -nr_pages);
-	}
+	update_lru_sizes(lruvec, lru, nr_zone_taken, nr_taken);
 	return nr_taken;
 }
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

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
mm-vmscan-make-shrink_node-decisions-more-node-centric-fix.patch
mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch
mm-workingset-make-working-set-detection-node-aware.patch
mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes.patch
mm-move-page-mapped-accounting-to-the-node.patch
mm-rename-nr_anon_pages-to-nr_anon_mapped.patch
mm-move-most-file-based-accounting-to-the-node.patch
mm-move-most-file-based-accounting-to-the-node-fix.patch
mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch
mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch
mm-page_alloc-wake-kswapd-based-on-the-highest-eligible-zone.patch
mm-convert-zone_reclaim-to-node_reclaim.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready-fix.patch
mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit-fix.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim-fix.patch
mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch
mm-pagevec-release-reacquire-lru_lock-on-pgdat-change.patch
mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg.patch


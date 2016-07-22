From: akpm@linux-foundation.org
Subject: +
 mm-consider-whether-to-decivate-based-on-eligible-zones-inactive-ratio.patch added to -mm tree
Date: Fri, 22 Jul 2016 11:28:59 -0700
Message-ID: <579265eb.vGYrJmIB8sfsNN9Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbcGVS3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jul 2016 14:29:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: consider whether to decivate based on eligible zones inactive ratio
has been added to the -mm tree.  Its filename is
     mm-consider-whether-to-decivate-based-on-eligible-zones-inactive-ratio.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-consider-whether-to-decivate-based-on-eligible-zones-inactive-ratio.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-consider-whether-to-decivate-based-on-eligible-zones-inactive-ratio.patch

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
Subject: mm: consider whether to decivate based on eligible zones inactive ratio

Minchan Kim reported that with per-zone lru state it was possible to
identify that a normal zone with 8^M anonymous pages could trigger OOM
with non-atomic order-0 allocations as all pages in the zone were in the
active list.

   gfp_mask=0x26004c0(GFP_KERNEL|__GFP_REPEAT|__GFP_NOTRACK), order=0
   Call Trace:
    [<c51a76e2>] __alloc_pages_nodemask+0xe52/0xe60
    [<c51f31dc>] ? new_slab+0x39c/0x3b0
    [<c51f31dc>] new_slab+0x39c/0x3b0
    [<c51f4eca>] ___slab_alloc.constprop.87+0x6da/0x840
    [<c563e6fc>] ? __alloc_skb+0x3c/0x260
    [<c50b8e93>] ? enqueue_task_fair+0x73/0xbf0
    [<c5219ee0>] ? poll_select_copy_remaining+0x140/0x140
    [<c5201645>] __slab_alloc.isra.81.constprop.86+0x40/0x6d
    [<c563e6fc>] ? __alloc_skb+0x3c/0x260
    [<c51f525c>] kmem_cache_alloc+0x22c/0x260
    [<c563e6fc>] ? __alloc_skb+0x3c/0x260
    [<c563e6fc>] __alloc_skb+0x3c/0x260
    [<c563eece>] alloc_skb_with_frags+0x4e/0x1a0
    [<c5638d6a>] sock_alloc_send_pskb+0x16a/0x1b0
    [<c570b581>] ? wait_for_unix_gc+0x31/0x90
    [<c57084dd>] unix_stream_sendmsg+0x28d/0x340
    [<c5634dad>] sock_sendmsg+0x2d/0x40
    [<c5634e2c>] sock_write_iter+0x6c/0xc0
    [<c5204a90>] __vfs_write+0xc0/0x120
    [<c52053ab>] vfs_write+0x9b/0x1a0
    [<c51cc4a9>] ? __might_fault+0x49/0xa0
    [<c52062c4>] SyS_write+0x44/0x90
    [<c50036c6>] do_fast_syscall_32+0xa6/0x1e0

   Mem-Info:
   active_anon:101103 inactive_anon:102219 isolated_anon:0
    active_file:503 inactive_file:544 isolated_file:0
    unevictable:0 dirty:0 writeback:34 unstable:0
    slab_reclaimable:6298 slab_unreclaimable:74669
    mapped:863 shmem:0 pagetables:100998 bounce:0
    free:23573 free_pcp:1861 free_cma:0
   Node 0 active_anon:404412kB inactive_anon:409040kB active_file:2012kB inactive_file:2176kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:3452kB dirty:0kB writeback:136kB shmem:0kB writeback_tmp:0kB unstable:0kB pages_scanned:1320845 all_unreclaimable? yes
   DMA free:3296kB min:68kB low:84kB high:100kB active_anon:5540kB inactive_anon:0kB active_file:0kB inactive_file:0kB present:15992kB managed:15916kB mlocked:0kB slab_reclaimable:248kB slab_unreclaimable:2628kB kernel_stack:792kB pagetables:2316kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
   lowmem_reserve[]: 0 809 1965 1965
   Normal free:3600kB min:3604kB low:4504kB high:5404kB active_anon:86304kB inactive_anon:0kB active_file:160kB inactive_file:376kB present:897016kB managed:858524kB mlocked:0kB slab_reclaimable:24944kB slab_unreclaimable:296048kB kernel_stack:163832kB pagetables:35892kB bounce:0kB free_pcp:3076kB local_pcp:656kB free_cma:0kB
   lowmem_reserve[]: 0 0 9247 9247
   HighMem free:86156kB min:512kB low:1796kB high:3080kB active_anon:312852kB inactive_anon:410024kB active_file:1924kB inactive_file:2012kB present:1183736kB managed:1183736kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:365784kB bounce:0kB free_pcp:3868kB local_pcp:720kB free_cma:0kB
   lowmem_reserve[]: 0 0 0 0
   DMA: 8*4kB (UM) 8*8kB (UM) 4*16kB (M) 2*32kB (UM) 2*64kB (UM) 1*128kB (M) 3*256kB (UME) 2*512kB (UE) 1*1024kB (E) 0*2048kB 0*4096kB = 3296kB
   Normal: 240*4kB (UME) 160*8kB (UME) 23*16kB (ME) 3*32kB (UE) 3*64kB (UME) 2*128kB (ME) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3408kB
   HighMem: 10942*4kB (UM) 3102*8kB (UM) 866*16kB (UM) 76*32kB (UM) 11*64kB (UM) 4*128kB (UM) 1*256kB (M) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 86344kB
   Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
   54409 total pagecache pages
   53215 pages in swap cache
   Swap cache stats: add 300982, delete 247765, find 157978/226539
   Free swap  = 3803244kB
   Total swap = 4192252kB
   524186 pages RAM
   295934 pages HighMem/MovableOnly
   9642 pages reserved
   0 pages cma reserved

The problem is due to the active deactivation logic in inactive_list_is_low.

	Node 0 active_anon:404412kB inactive_anon:409040kB

IOW, (inactive_anon of node * inactive_ratio > active_anon of node) due to
highmem anonymous stat so VM never deactivates normal zone's anonymous pages.

This patch is a modified version of Minchan's original solution but based
upon it. The problem with Minchan's patch is that any low zone with an
imbalanced list could force a rotation.

In this patch, a zone-constrained global reclaim will rotate the list if
the inactive/active ratio of all eligible zones needs to be corrected. It
is possible that higher zone pages will be initially rotated prematurely
but this is the safer choice to maintain overall LRU age.

Link: http://lkml.kernel.org/r/20160722090929.GJ10438@techsingularity.net
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-consider-whether-to-decivate-based-on-eligible-zones-inactive-ratio mm/vmscan.c
--- a/mm/vmscan.c~mm-consider-whether-to-decivate-based-on-eligible-zones-inactive-ratio
+++ a/mm/vmscan.c
@@ -1964,12 +1964,15 @@ static void shrink_active_list(unsigned
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-static bool inactive_list_is_low(struct lruvec *lruvec, bool file)
+static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
+						struct scan_control *sc)
 {
 	unsigned long inactive_ratio;
 	unsigned long inactive;
 	unsigned long active;
 	unsigned long gb;
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	int zid;
 
 	/*
 	 * If we don't have swap space, anonymous page deactivation
@@ -1981,6 +1984,27 @@ static bool inactive_list_is_low(struct
 	inactive = lruvec_lru_size(lruvec, file * LRU_FILE);
 	active = lruvec_lru_size(lruvec, file * LRU_FILE + LRU_ACTIVE);
 
+	/*
+	 * For zone-constrained allocations, it is necessary to check if
+	 * deactivations are required for lowmem to be reclaimed. This
+	 * calculates the inactive/active pages available in eligible zones.
+	 */
+	for (zid = sc->reclaim_idx + 1; zid < MAX_NR_ZONES; zid++) {
+		struct zone *zone = &pgdat->node_zones[zid];
+		unsigned long inactive_zone, active_zone;
+
+		if (!populated_zone(zone))
+			continue;
+
+		inactive_zone = zone_page_state(zone,
+				NR_ZONE_LRU_BASE + (file * LRU_FILE));
+		active_zone = zone_page_state(zone,
+				NR_ZONE_LRU_BASE + (file * LRU_FILE) + LRU_ACTIVE);
+
+		inactive -= min(inactive, inactive_zone);
+		active -= min(active, active_zone);
+	}
+
 	gb = (inactive + active) >> (30 - PAGE_SHIFT);
 	if (gb)
 		inactive_ratio = int_sqrt(10 * gb);
@@ -1994,7 +2018,7 @@ static unsigned long shrink_list(enum lr
 				 struct lruvec *lruvec, struct scan_control *sc)
 {
 	if (is_active_lru(lru)) {
-		if (inactive_list_is_low(lruvec, is_file_lru(lru)))
+		if (inactive_list_is_low(lruvec, is_file_lru(lru), sc))
 			shrink_active_list(nr_to_scan, lruvec, sc, lru);
 		return 0;
 	}
@@ -2125,7 +2149,7 @@ static void get_scan_count(struct lruvec
 	 * lruvec even if it has plenty of old anonymous pages unless the
 	 * system is under heavy pressure.
 	 */
-	if (!inactive_list_is_low(lruvec, true) &&
+	if (!inactive_list_is_low(lruvec, true, sc) &&
 	    lruvec_lru_size(lruvec, LRU_INACTIVE_FILE) >> sc->priority) {
 		scan_balance = SCAN_FILE;
 		goto out;
@@ -2367,7 +2391,7 @@ static void shrink_node_memcg(struct pgl
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
 	 */
-	if (inactive_list_is_low(lruvec, false))
+	if (inactive_list_is_low(lruvec, false, sc))
 		shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
 				   sc, LRU_ACTIVE_ANON);
 
@@ -3020,7 +3044,7 @@ static void age_active_anon(struct pglis
 	do {
 		struct lruvec *lruvec = mem_cgroup_lruvec(pgdat, memcg);
 
-		if (inactive_list_is_low(lruvec, false))
+		if (inactive_list_is_low(lruvec, false, sc))
 			shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
 					   sc, LRU_ACTIVE_ANON);
 
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
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries-fix.patch
mm-pagevec-release-reacquire-lru_lock-on-pgdat-change.patch
mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg.patch
mm-vmscan-remove-redundant-check-in-shrink_zones.patch
mm-vmscan-release-reacquire-lru_lock-on-pgdat-change.patch
mm-vmscan-release-reacquire-lru_lock-on-pgdat-change-fix.patch
mm-vmscan-remove-highmem_file_pages.patch
mm-remove-reclaim-and-compaction-retry-approximations.patch
mm-consider-whether-to-decivate-based-on-eligible-zones-inactive-ratio.patch
mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch


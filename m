From: akpm@linux-foundation.org
Subject: + mm-vmscan-kill-struct-mem_cgroup_zone.patch added to -mm tree
Date: Wed, 02 May 2012 14:21:38 -0700
Message-ID: <20120502212138.56510A0413@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:38935 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab2EBVVj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2012 17:21:39 -0400
Received: by vbnl22 with SMTP id l22so122888vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 02 May 2012 14:21:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     Subject: mm/vmscan: kill struct mem_cgroup_zone
has been added to the -mm tree.  Its filename is
     mm-vmscan-kill-struct-mem_cgroup_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm/vmscan: kill struct mem_cgroup_zone

Kill struct mem_cgroup_zone and rename shrink_mem_cgroup_zone() to
shrink_lruvec(), it always shrinks one lruvec which it takes as an
argument.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-kill-struct-mem_cgroup_zone mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-kill-struct-mem_cgroup_zone
+++ a/mm/vmscan.c
@@ -94,11 +94,6 @@ struct scan_control {
 	nodemask_t	*nodemask;
 };
 
-struct mem_cgroup_zone {
-	struct mem_cgroup *mem_cgroup;
-	struct zone *zone;
-};
-
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
 
 #ifdef ARCH_HAS_PREFETCH
@@ -1769,8 +1764,7 @@ static inline bool should_continue_recla
 /*
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
  */
-static void shrink_mem_cgroup_zone(struct mem_cgroup_zone *mz,
-				   struct scan_control *sc)
+static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
@@ -1778,9 +1772,6 @@ static void shrink_mem_cgroup_zone(struc
 	unsigned long nr_reclaimed, nr_scanned;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct blk_plug plug;
-	struct lruvec *lruvec;
-
-	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
 
 restart:
 	nr_reclaimed = 0;
@@ -1842,12 +1833,10 @@ static void shrink_zone(struct zone *zon
 
 	memcg = mem_cgroup_iter(root, NULL, &reclaim);
 	do {
-		struct mem_cgroup_zone mz = {
-			.mem_cgroup = memcg,
-			.zone = zone,
-		};
+		struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
+
+		shrink_lruvec(lruvec, sc);
 
-		shrink_mem_cgroup_zone(&mz, sc);
 		/*
 		 * Limit reclaim has historically picked one memcg and
 		 * scanned it with decreasing priority levels until
@@ -2172,10 +2161,7 @@ unsigned long mem_cgroup_shrink_node_zon
 		.priority = 0,
 		.target_mem_cgroup = memcg,
 	};
-	struct mem_cgroup_zone mz = {
-		.mem_cgroup = memcg,
-		.zone = zone,
-	};
+	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
@@ -2191,7 +2177,7 @@ unsigned long mem_cgroup_shrink_node_zon
 	 * will pick up pages from other mem cgroup's as well. We hack
 	 * the priority and make it zero.
 	 */
-	shrink_mem_cgroup_zone(&mz, &sc);
+	shrink_lruvec(lruvec, &sc);
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
 
_
Subject: Subject: mm/vmscan: kill struct mem_cgroup_zone

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
proc-pagemap-correctly-report-non-present-ptes-and-holes-between-vmas.patch
mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
bug-introduce-build_bug_on_invalid-macro.patch
bug-completely-remove-code-generated-by-disabled-vm_bug_on.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
mm-vmscan-store-priority-in-struct-scan_control.patch
mm-add-link-from-struct-lruvec-to-struct-zone.patch
mm-vmscan-push-lruvec-pointer-into-isolate_lru_pages.patch
mm-vmscan-push-zone-pointer-into-shrink_page_list.patch
mm-vmscan-remove-update_isolated_counts.patch
mm-vmscan-push-lruvec-pointer-into-putback_inactive_pages.patch
mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size.patch
mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low.patch
mm-vmscan-push-lruvec-pointer-into-shrink_list.patch
mm-vmscan-push-lruvec-pointer-into-get_scan_count.patch
mm-vmscan-push-lruvec-pointer-into-should_continue_reclaim.patch
mm-vmscan-kill-struct-mem_cgroup_zone.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch


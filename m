From: akpm@linux-foundation.org
Subject: + mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size.patch added to -mm tree
Date: Wed, 02 May 2012 14:21:24 -0700
Message-ID: <20120502212124.34F28A0413@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:58844 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab2EBVV1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2012 17:21:27 -0400
Received: by faaa25 with SMTP id a25so59532faa.1
        for <mm-commits@vger.kernel.org>; Wed, 02 May 2012 14:21:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     Subject: mm/vmscan: replace zone_nr_lru_pages() with get_lruvec_size()
has been added to the -mm tree.  Its filename is
     mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size.patch

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
Subject: mm/vmscan: replace zone_nr_lru_pages() with get_lruvec_size()

If memory cgroup is enabled we always use lruvecs which are embedded into
struct mem_cgroup_per_zone, so we can reach lru_size counters via
container_of().

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++----
 mm/memcontrol.c            |    9 +++++++++
 mm/vmscan.c                |   31 ++++++++++++++++---------------
 3 files changed, 27 insertions(+), 19 deletions(-)

diff -puN include/linux/memcontrol.h~mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size
+++ a/include/linux/memcontrol.h
@@ -124,8 +124,7 @@ int mem_cgroup_inactive_anon_is_low(stru
 int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg,
 				    struct zone *zone);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
-unsigned long mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg,
-					int nid, int zid, unsigned int lrumask);
+unsigned long mem_cgroup_get_lruvec_size(struct lruvec *lruvec, enum lru_list);
 struct zone_reclaim_stat*
 mem_cgroup_get_reclaim_stat_from_page(struct page *page);
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
@@ -344,8 +343,7 @@ mem_cgroup_inactive_file_is_low(struct m
 }
 
 static inline unsigned long
-mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg, int nid, int zid,
-				unsigned int lru_mask)
+mem_cgroup_get_lruvec_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	return 0;
 }
diff -puN mm/memcontrol.c~mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size mm/memcontrol.c
--- a/mm/memcontrol.c~mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size
+++ a/mm/memcontrol.c
@@ -743,6 +743,15 @@ static void mem_cgroup_charge_statistics
 }
 
 unsigned long
+mem_cgroup_get_lruvec_size(struct lruvec *lruvec, enum lru_list lru)
+{
+	struct mem_cgroup_per_zone *mz;
+
+	mz = container_of(lruvec, struct mem_cgroup_per_zone, lruvec);
+	return mz->lru_size[lru];
+}
+
+static unsigned long
 mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg, int nid, int zid,
 			unsigned int lru_mask)
 {
diff -puN mm/vmscan.c~mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size
+++ a/mm/vmscan.c
@@ -155,19 +155,14 @@ static struct zone_reclaim_stat *get_rec
 	return &mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup)->reclaim_stat;
 }
 
-static unsigned long zone_nr_lru_pages(struct mem_cgroup_zone *mz,
-				       enum lru_list lru)
+static unsigned long get_lruvec_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	if (!mem_cgroup_disabled())
-		return mem_cgroup_zone_nr_lru_pages(mz->mem_cgroup,
-						    zone_to_nid(mz->zone),
-						    zone_idx(mz->zone),
-						    BIT(lru));
+		return mem_cgroup_get_lruvec_size(lruvec, lru);
 
-	return zone_page_state(mz->zone, NR_LRU_BASE + lru);
+	return zone_page_state(lruvec_zone(lruvec), NR_LRU_BASE + lru);
 }
 
-
 /*
  * Add a shrinker callback to be called from the vm
  */
@@ -1603,6 +1598,9 @@ static void get_scan_count(struct mem_cg
 	enum lru_list lru;
 	int noswap = 0;
 	bool force_scan = false;
+	struct lruvec *lruvec;
+
+	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
 
 	/*
 	 * If the zone or memcg is small, nr[l] can be 0.  This
@@ -1628,10 +1626,10 @@ static void get_scan_count(struct mem_cg
 		goto out;
 	}
 
-	anon  = zone_nr_lru_pages(mz, LRU_ACTIVE_ANON) +
-		zone_nr_lru_pages(mz, LRU_INACTIVE_ANON);
-	file  = zone_nr_lru_pages(mz, LRU_ACTIVE_FILE) +
-		zone_nr_lru_pages(mz, LRU_INACTIVE_FILE);
+	anon  = get_lruvec_size(lruvec, LRU_ACTIVE_ANON) +
+		get_lruvec_size(lruvec, LRU_INACTIVE_ANON);
+	file  = get_lruvec_size(lruvec, LRU_ACTIVE_FILE) +
+		get_lruvec_size(lruvec, LRU_INACTIVE_FILE);
 
 	if (global_reclaim(sc)) {
 		free  = zone_page_state(mz->zone, NR_FREE_PAGES);
@@ -1694,7 +1692,7 @@ out:
 		int file = is_file_lru(lru);
 		unsigned long scan;
 
-		scan = zone_nr_lru_pages(mz, lru);
+		scan = get_lruvec_size(lruvec, lru);
 		if (sc->priority || noswap) {
 			scan >>= sc->priority;
 			if (!scan && force_scan)
@@ -1730,6 +1728,7 @@ static inline bool should_continue_recla
 {
 	unsigned long pages_for_compaction;
 	unsigned long inactive_lru_pages;
+	struct lruvec *lruvec;
 
 	/* If not in reclaim/compaction mode, stop */
 	if (!in_reclaim_compaction(sc))
@@ -1762,10 +1761,12 @@ static inline bool should_continue_recla
 	 * If we have not reclaimed enough pages for compaction and the
 	 * inactive lists are large enough, continue reclaiming
 	 */
+	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
 	pages_for_compaction = (2UL << sc->order);
-	inactive_lru_pages = zone_nr_lru_pages(mz, LRU_INACTIVE_FILE);
+	inactive_lru_pages = get_lruvec_size(lruvec, LRU_INACTIVE_FILE);
 	if (nr_swap_pages > 0)
-		inactive_lru_pages += zone_nr_lru_pages(mz, LRU_INACTIVE_ANON);
+		inactive_lru_pages += get_lruvec_size(lruvec,
+						      LRU_INACTIVE_ANON);
 	if (sc->nr_reclaimed < pages_for_compaction &&
 			inactive_lru_pages > pages_for_compaction)
 		return true;
_
Subject: Subject: mm/vmscan: replace zone_nr_lru_pages() with get_lruvec_size()

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


From: akpm@linux-foundation.org
Subject: + mm-vmscan-remove-update_isolated_counts.patch added to -mm tree
Date: Wed, 02 May 2012 14:21:19 -0700
Message-ID: <20120502212119.4FA54A06A6@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:59381 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2EBVVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2012 17:21:20 -0400
Received: by vcbfl13 with SMTP id fl13so2268vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 02 May 2012 14:21:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     Subject: mm/vmscan: remove update_isolated_counts()
has been added to the -mm tree.  Its filename is
     mm-vmscan-remove-update_isolated_counts.patch

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
Subject: mm/vmscan: remove update_isolated_counts()

update_isolated_counts() is no longer required, because lumpy-reclaim was
removed.  Insanity is over, now there is only one kind of inactive page.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   60 +++++---------------------------------------------
 1 file changed, 6 insertions(+), 54 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-remove-update_isolated_counts mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-remove-update_isolated_counts
+++ a/mm/vmscan.c
@@ -1205,52 +1205,6 @@ putback_inactive_pages(struct mem_cgroup
 	list_splice(&pages_to_free, page_list);
 }
 
-static noinline_for_stack void
-update_isolated_counts(struct mem_cgroup_zone *mz,
-		       struct list_head *page_list,
-		       unsigned long *nr_anon,
-		       unsigned long *nr_file)
-{
-	struct zone *zone = mz->zone;
-	unsigned int count[NR_LRU_LISTS] = { 0, };
-	unsigned long nr_active = 0;
-	struct page *page;
-	int lru;
-
-	/*
-	 * Count pages and clear active flags
-	 */
-	list_for_each_entry(page, page_list, lru) {
-		int numpages = hpage_nr_pages(page);
-		lru = page_lru_base_type(page);
-		if (PageActive(page)) {
-			lru += LRU_ACTIVE;
-			ClearPageActive(page);
-			nr_active += numpages;
-		}
-		count[lru] += numpages;
-	}
-
-	preempt_disable();
-	__count_vm_events(PGDEACTIVATE, nr_active);
-
-	__mod_zone_page_state(zone, NR_ACTIVE_FILE,
-			      -count[LRU_ACTIVE_FILE]);
-	__mod_zone_page_state(zone, NR_INACTIVE_FILE,
-			      -count[LRU_INACTIVE_FILE]);
-	__mod_zone_page_state(zone, NR_ACTIVE_ANON,
-			      -count[LRU_ACTIVE_ANON]);
-	__mod_zone_page_state(zone, NR_INACTIVE_ANON,
-			      -count[LRU_INACTIVE_ANON]);
-
-	*nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
-	*nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
-
-	__mod_zone_page_state(zone, NR_ISOLATED_ANON, *nr_anon);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, *nr_file);
-	preempt_enable();
-}
-
 /*
  * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
  * of reclaimed pages
@@ -1263,8 +1217,6 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_scanned;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_taken;
-	unsigned long nr_anon;
-	unsigned long nr_file;
 	unsigned long nr_dirty = 0;
 	unsigned long nr_writeback = 0;
 	isolate_mode_t isolate_mode = 0;
@@ -1292,6 +1244,10 @@ shrink_inactive_list(unsigned long nr_to
 
 	nr_taken = isolate_lru_pages(nr_to_scan, lruvec, &page_list,
 				     &nr_scanned, sc, isolate_mode, lru);
+
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, -nr_taken);
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, nr_taken);
+
 	if (global_reclaim(sc)) {
 		zone->pages_scanned += nr_scanned;
 		if (current_is_kswapd())
@@ -1306,15 +1262,12 @@ shrink_inactive_list(unsigned long nr_to
 	if (nr_taken == 0)
 		return 0;
 
-	update_isolated_counts(mz, &page_list, &nr_anon, &nr_file);
-
 	nr_reclaimed = shrink_page_list(&page_list, zone, sc,
 						&nr_dirty, &nr_writeback);
 
 	spin_lock_irq(&zone->lru_lock);
 
-	reclaim_stat->recent_scanned[0] += nr_anon;
-	reclaim_stat->recent_scanned[1] += nr_file;
+	reclaim_stat->recent_scanned[file] += nr_taken;
 
 	if (global_reclaim(sc)) {
 		if (current_is_kswapd())
@@ -1327,8 +1280,7 @@ shrink_inactive_list(unsigned long nr_to
 
 	putback_inactive_pages(mz, &page_list);
 
-	__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
 
 	spin_unlock_irq(&zone->lru_lock);
 
_
Subject: Subject: mm/vmscan: remove update_isolated_counts()

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


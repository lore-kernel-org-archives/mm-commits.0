From: akpm@linux-foundation.org
Subject: + mm-vmscan-push-lruvec-pointer-into-should_continue_reclaim.patch added to -mm tree
Date: Wed, 02 May 2012 14:21:35 -0700
Message-ID: <20120502212135.6D048A0413@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:51331 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab2EBVVh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2012 17:21:37 -0400
Received: by eekc41 with SMTP id c41so59153eek.1
        for <mm-commits@vger.kernel.org>; Wed, 02 May 2012 14:21:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     Subject: mm/vmscan: push lruvec pointer into should_continue_reclaim()
has been added to the -mm tree.  Its filename is
     mm-vmscan-push-lruvec-pointer-into-should_continue_reclaim.patch

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
Subject: mm/vmscan: push lruvec pointer into should_continue_reclaim()

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-push-lruvec-pointer-into-should_continue_reclaim mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-push-lruvec-pointer-into-should_continue_reclaim
+++ a/mm/vmscan.c
@@ -1708,14 +1708,13 @@ static bool in_reclaim_compaction(struct
  * calls try_to_compact_zone() that it will have enough free pages to succeed.
  * It will give up earlier than that if there is difficulty reclaiming pages.
  */
-static inline bool should_continue_reclaim(struct mem_cgroup_zone *mz,
+static inline bool should_continue_reclaim(struct lruvec *lruvec,
 					unsigned long nr_reclaimed,
 					unsigned long nr_scanned,
 					struct scan_control *sc)
 {
 	unsigned long pages_for_compaction;
 	unsigned long inactive_lru_pages;
-	struct lruvec *lruvec;
 
 	/* If not in reclaim/compaction mode, stop */
 	if (!in_reclaim_compaction(sc))
@@ -1748,7 +1747,6 @@ static inline bool should_continue_recla
 	 * If we have not reclaimed enough pages for compaction and the
 	 * inactive lists are large enough, continue reclaiming
 	 */
-	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
 	pages_for_compaction = (2UL << sc->order);
 	inactive_lru_pages = get_lruvec_size(lruvec, LRU_INACTIVE_FILE);
 	if (nr_swap_pages > 0)
@@ -1759,7 +1757,7 @@ static inline bool should_continue_recla
 		return true;
 
 	/* If compaction would go ahead or the allocation would succeed, stop */
-	switch (compaction_suitable(mz->zone, sc->order)) {
+	switch (compaction_suitable(lruvec_zone(lruvec), sc->order)) {
 	case COMPACT_PARTIAL:
 	case COMPACT_CONTINUE:
 		return false;
@@ -1826,7 +1824,7 @@ restart:
 				   sc, LRU_ACTIVE_ANON);
 
 	/* reclaim/compaction might need reclaim to continue */
-	if (should_continue_reclaim(mz, nr_reclaimed,
+	if (should_continue_reclaim(lruvec, nr_reclaimed,
 				    sc->nr_scanned - nr_scanned, sc))
 		goto restart;
 
_
Subject: Subject: mm/vmscan: push lruvec pointer into should_continue_reclaim()

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


From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-push-zone-pointer-into-shrink_page_list.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:22 -0700
Message-ID: <20120531191722.61EFCA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:39570 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab2EaTRX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:23 -0400
Received: by qcsp5 with SMTP id p5so136381qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: push zone pointer into shrink_page_list()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-push-zone-pointer-into-shrink_page_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm/vmscan: push zone pointer into shrink_page_list()

It doesn't need a pointer to the cgroup - pointer to the zone is enough. 
This patch also kills the "mz" argument of page_check_references() - it is
unused after "mm: memcg: count pte references from every member of the
reclaimed hierarch"

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-push-zone-pointer-into-shrink_page_list mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-push-zone-pointer-into-shrink_page_list
+++ a/mm/vmscan.c
@@ -629,7 +629,6 @@ enum page_references {
 };
 
 static enum page_references page_check_references(struct page *page,
-						  struct mem_cgroup_zone *mz,
 						  struct scan_control *sc)
 {
 	int referenced_ptes, referenced_page;
@@ -688,7 +687,7 @@ static enum page_references page_check_r
  * shrink_page_list() returns the number of reclaimed pages
  */
 static unsigned long shrink_page_list(struct list_head *page_list,
-				      struct mem_cgroup_zone *mz,
+				      struct zone *zone,
 				      struct scan_control *sc,
 				      unsigned long *ret_nr_dirty,
 				      unsigned long *ret_nr_writeback)
@@ -718,7 +717,7 @@ static unsigned long shrink_page_list(st
 			goto keep;
 
 		VM_BUG_ON(PageActive(page));
-		VM_BUG_ON(page_zone(page) != mz->zone);
+		VM_BUG_ON(page_zone(page) != zone);
 
 		sc->nr_scanned++;
 
@@ -741,7 +740,7 @@ static unsigned long shrink_page_list(st
 			goto keep;
 		}
 
-		references = page_check_references(page, mz, sc);
+		references = page_check_references(page, sc);
 		switch (references) {
 		case PAGEREF_ACTIVATE:
 			goto activate_locked;
@@ -931,7 +930,7 @@ keep:
 	 * will encounter the same problem
 	 */
 	if (nr_dirty && nr_dirty == nr_congested && global_reclaim(sc))
-		zone_set_flag(mz->zone, ZONE_CONGESTED);
+		zone_set_flag(zone, ZONE_CONGESTED);
 
 	free_hot_cold_page_list(&free_pages, 1);
 
@@ -1309,7 +1308,7 @@ shrink_inactive_list(unsigned long nr_to
 
 	update_isolated_counts(mz, &page_list, &nr_anon, &nr_file);
 
-	nr_reclaimed = shrink_page_list(&page_list, mz, sc,
+	nr_reclaimed = shrink_page_list(&page_list, zone, sc,
 						&nr_dirty, &nr_writeback);
 
 	spin_lock_irq(&zone->lru_lock);
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch


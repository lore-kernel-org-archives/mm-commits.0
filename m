From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:09:23 -0700
Message-ID: <201111012109.pA1L9NhZ016470@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29034 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab1KAVKc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:10:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aelder@sgi.com, chris.mason@oracle.com, dave@linux.vnet.ibm.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, jweiner@redhat.com, min


The patch titled
     Subject: mm: vmscan: do not writeback filesystem pages in kswapd except in high priority
has been removed from the -mm tree.  Its filename was
     mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: do not writeback filesystem pages in kswapd except in high priority

It is preferable that no dirty pages are dispatched for cleaning from the
page reclaim path.  At normal priorities, this patch prevents kswapd
writing pages.

However, page reclaim does have a requirement that pages be freed in a
particular zone.  If it is failing to make sufficient progress (reclaiming
< SWAP_CLUSTER_MAX at any priority priority), the priority is raised to
scan more pages.  A priority of DEF_PRIORITY - 3 is considered to be the
point where kswapd is getting into trouble reclaiming pages.  If this
priority is reached, kswapd will dispatch pages for writing.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alex Elder <aelder@sgi.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority
+++ a/mm/vmscan.c
@@ -750,7 +750,8 @@ static noinline_for_stack void free_page
  */
 static unsigned long shrink_page_list(struct list_head *page_list,
 				      struct zone *zone,
-				      struct scan_control *sc)
+				      struct scan_control *sc,
+				      int priority)
 {
 	LIST_HEAD(ret_pages);
 	LIST_HEAD(free_pages);
@@ -856,9 +857,11 @@ static unsigned long shrink_page_list(st
 
 			/*
 			 * Only kswapd can writeback filesystem pages to
-			 * avoid risk of stack overflow
+			 * avoid risk of stack overflow but do not writeback
+			 * unless under significant pressure.
 			 */
-			if (page_is_file_cache(page) && !current_is_kswapd()) {
+			if (page_is_file_cache(page) &&
+					(!current_is_kswapd() || priority >= DEF_PRIORITY - 2)) {
 				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
 				goto keep_locked;
 			}
@@ -1509,12 +1512,12 @@ shrink_inactive_list(unsigned long nr_to
 
 	spin_unlock_irq(&zone->lru_lock);
 
-	nr_reclaimed = shrink_page_list(&page_list, zone, sc);
+	nr_reclaimed = shrink_page_list(&page_list, zone, sc, priority);
 
 	/* Check if we should syncronously wait for writeback */
 	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
 		set_reclaim_mode(priority, sc, true);
-		nr_reclaimed += shrink_page_list(&page_list, zone, sc);
+		nr_reclaimed += shrink_page_list(&page_list, zone, sc, priority);
 	}
 
 	local_irq_disable();
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch


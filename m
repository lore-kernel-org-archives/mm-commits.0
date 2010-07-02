From: akpm@linux-foundation.org
Subject: + vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch added to -mm tree
Date: Fri, 02 Jul 2010 13:06:19 -0700
Message-ID: <201007022006.o62K6Jmj024240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757575Ab0GBUHO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 16:07:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, chris.mason@oracle.com, david@fromorbit.com, hannes@cmpxchg.org, hch@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mrubin@google.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan: remove unnecessary temporary vars in do_try_to_free_pages
has been added to the -mm tree.  Its filename is
     vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: remove unnecessary temporary vars in do_try_to_free_pages
From: Mel Gorman <mel@csn.ul.ie>

Remove temporary variable that is only used once and does not help clarify
code.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages mm/vmscan.c
--- a/mm/vmscan.c~vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages
+++ a/mm/vmscan.c
@@ -1726,13 +1726,12 @@ static void shrink_zone(int priority, st
 static bool shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
 {
-	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
 	struct zoneref *z;
 	struct zone *zone;
 	bool all_unreclaimable = true;
 
-	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
-					sc->nodemask) {
+	for_each_zone_zonelist_nodemask(zone, z, zonelist,
+					gfp_zone(sc->gfp_mask), sc->nodemask) {
 		if (!populated_zone(zone))
 			continue;
 		/*
@@ -1777,7 +1776,6 @@ static unsigned long do_try_to_free_page
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct zoneref *z;
 	struct zone *zone;
-	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
 	unsigned long writeback_threshold;
 
 	get_mems_allowed();
@@ -1797,7 +1795,7 @@ static unsigned long do_try_to_free_page
 		 */
 		if (scanning_global_lru(sc)) {
 			unsigned long lru_pages = 0;
-			for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
+			for_each_zone_zonelist(zone, z, zonelist, gfp_zone(sc->gfp_mask)) {
 				if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 					continue;
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

mm-vmscan-fix-mapping-use-after-free.patch
linux-next.patch
hugetlb-call-mmu-notifiers-on-hugepage-cow.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-tracing-add-trace-event-when-a-page-is-written.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
vmscan-kill-prev_priority-completely.patch
vmscan-simplify-shrink_inactive_list.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_page_list.patch
vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch


From: akpm@linux-foundation.org
Subject: + mm-page-allocator-drain-per-cpu-lists-after-direct-reclaim-allocation-fails.patch added to -mm tree
Date: Fri, 03 Sep 2010 16:01:28 -0700
Message-ID: <201009032301.o83N1TQL017726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399Ab0ICXCE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 19:02:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux.com, david@fromorbit.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     mm: page allocator: drain per-cpu lists after direct reclaim allocation fails
has been added to the -mm tree.  Its filename is
     mm-page-allocator-drain-per-cpu-lists-after-direct-reclaim-allocation-fails.patch

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
Subject: mm: page allocator: drain per-cpu lists after direct reclaim allocation fails
From: Mel Gorman <mel@csn.ul.ie>

When under significant memory pressure, a process enters direct reclaim
and immediately afterwards tries to allocate a page.  If it fails and no
further progress is made, it's possible the system will go OOM.  However,
on systems with large amounts of memory, it's possible that a significant
number of pages are on per-cpu lists and inaccessible to the calling
process.  This leads to a process entering direct reclaim more often than
it should increasing the pressure on the system and compounding the
problem.

This patch notes that if direct reclaim is making progress but allocations
are still failing that the system is already under heavy pressure.  In
this case, it drains the per-cpu lists and tries the allocation a second
time before continuing.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page-allocator-drain-per-cpu-lists-after-direct-reclaim-allocation-fails mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-allocator-drain-per-cpu-lists-after-direct-reclaim-allocation-fails
+++ a/mm/page_alloc.c
@@ -1847,6 +1847,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
 	struct task_struct *p = current;
+	bool drained = false;
 
 	cond_resched();
 
@@ -1865,14 +1866,25 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 
 	cond_resched();
 
-	if (order != 0)
-		drain_all_pages();
+	if (unlikely(!(*did_some_progress)))
+		return NULL;
 
-	if (likely(*did_some_progress))
-		page = get_page_from_freelist(gfp_mask, nodemask, order,
+retry:
+	page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
 					alloc_flags, preferred_zone,
 					migratetype);
+
+	/*
+	 * If an allocation failed after direct reclaim, it could be because
+	 * pages are pinned on the per-cpu lists. Drain them and try again
+	 */
+	if (!page && !drained) {
+		drain_all_pages();
+		drained = true;
+		goto retry;
+	}
+
 	return page;
 }
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

mm-avoid-warning-when-compaction-is-selected.patch
vmstat-update-zone-stat-threshold-when-onlining-a-cpu.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix.patch
mm-page-allocator-calculate-a-better-estimate-of-nr_free_pages-when-memory-is-low-and-kswapd-is-awake.patch
mm-page-allocator-drain-per-cpu-lists-after-direct-reclaim-allocation-fails.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
include-linux-pageblock-flagsh-fix-set_pageblock_flags-macro-definiton.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch


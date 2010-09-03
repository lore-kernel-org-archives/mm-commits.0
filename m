From: akpm@linux-foundation.org
Subject: + mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list.patch added to -mm tree
Date: Fri, 03 Sep 2010 16:01:43 -0700
Message-ID: <201009032301.o83N1iL3017732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399Ab0ICXCW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 19:02:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: page allocator: update free page counters after pages are placed on the free list
has been added to the -mm tree.  Its filename is
     mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list.patch

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
Subject: mm: page allocator: update free page counters after pages are placed on the free list
From: Mel Gorman <mel@csn.ul.ie>

When allocating a page, the system uses NR_FREE_PAGES counters to
determine if watermarks would remain intact after the allocation was made.
This check is made without interrupts disabled or the zone lock held and
so is race-prone by nature.  Unfortunately, when pages are being freed in
batch, the counters are updated before the pages are added on the list. 
During this window, the counters are misleading as the pages do not exist
yet.  When under significant pressure on systems with large numbers of
CPUs, it's possible for processes to make progress even though they should
have been stalled.  This is particularly problematic if a number of the
processes are using GFP_ATOMIC as the min watermark can be accidentally
breached and in extreme cases, the system can livelock.

This patch updates the counters after the pages have been added to the
list.  This makes the allocator more cautious with respect to preserving
the watermarks and mitigates livelock possibilities.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list
+++ a/mm/page_alloc.c
@@ -588,12 +588,12 @@ static void free_pcppages_bulk(struct zo
 {
 	int migratetype = 0;
 	int batch_free = 0;
+	int freed = count;
 
 	spin_lock(&zone->lock);
 	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
-	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
 	while (count) {
 		struct page *page;
 		struct list_head *list;
@@ -621,6 +621,7 @@ static void free_pcppages_bulk(struct zo
 			trace_mm_page_pcpu_drain(page, 0, page_private(page));
 		} while (--count && --batch_free && !list_empty(list));
 	}
+	__mod_zone_page_state(zone, NR_FREE_PAGES, freed);
 	spin_unlock(&zone->lock);
 }
 
@@ -631,8 +632,8 @@ static void free_one_page(struct zone *z
 	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
-	__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
 	__free_one_page(page, zone, order, migratetype);
+	__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
 	spin_unlock(&zone->lock);
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


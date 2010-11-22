From: akpm@linux-foundation.org
Subject: + mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch added to -mm tree
Date: Mon, 22 Nov 2010 12:06:35 -0800
Message-ID: <201011222006.oAMK6ZJh006904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757379Ab0KVUHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 15:07:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, apw@shadowen.org, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     mm: compaction: perform a faster migration scan when migrating asynchronously
has been added to the -mm tree.  Its filename is
     mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch

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
Subject: mm: compaction: perform a faster migration scan when migrating asynchronously
From: Mel Gorman <mel@csn.ul.ie>

try_to_compact_pages() is initially called to only migrate pages
asychronously and kswapd always compacts asynchronously.  Both are being
optimistic so it is important to complete the work as quickly as possible
to minimise stalls.

This patch alters the scanner when asynchronous to only consider
MIGRATE_MOVABLE pageblocks as migration candidates.  This reduces stalls
when allocating huge pages while not impairing allocation success rates as
a full scan will be performed if necessary after direct reclaim.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN mm/compaction.c~mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously mm/compaction.c
--- a/mm/compaction.c~mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously
+++ a/mm/compaction.c
@@ -240,6 +240,7 @@ static unsigned long isolate_migratepage
 					struct compact_control *cc)
 {
 	unsigned long low_pfn, end_pfn;
+	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
 
@@ -280,6 +281,20 @@ static unsigned long isolate_migratepage
 		if (PageBuddy(page))
 			continue;
 
+		/*
+		 * For async migration, also only scan in MOVABLE blocks. Async
+		 * migration is optimistic to see if the minimum amount of work
+		 * satisfies the allocation
+		 */
+		pageblock_nr = low_pfn >> pageblock_order;
+		if (!cc->sync && last_pageblock_nr != pageblock_nr &&
+				get_pageblock_migratetype(page) != MIGRATE_MOVABLE) {
+			low_pfn += pageblock_nr_pages;
+			low_pfn = ALIGN(low_pfn, pageblock_nr_pages) - 1;
+			last_pageblock_nr = pageblock_nr;
+			continue;
+		}
+
 		/* Try isolate the page */
 		if (__isolate_lru_page(page, ISOLATE_BOTH, 0) != 0)
 			continue;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
mm-remove-call-to-find_vma-in-pagewalk-for-non-hugetlbfs.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
add-debugging-aid-for-memory-initialisation-problems.patch


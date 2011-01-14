From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:45:01 -0800
Message-ID: <201101142247.p0EMlp4g005047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab1ANWsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, apw@shadowen.org, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: compaction: perform a faster migration scan when migrating asynchronously
has been removed from the -mm tree.  Its filename was
     mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
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

origin.patch
linux-next.patch
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
thp-add-pagetranscompound.patch
add-debugging-aid-for-memory-initialisation-problems.patch


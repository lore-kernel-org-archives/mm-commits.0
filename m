From: akpm@linux-foundation.org
Subject: [merged] thp-scale-nr_rotated-to-balance-memory-pressure.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:32 -0800
Message-ID: <201101142251.p0EMpMo3005502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058Ab1ANWvd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: scale nr_rotated to balance memory pressure
has been removed from the -mm tree.  Its filename was
     thp-scale-nr_rotated-to-balance-memory-pressure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: scale nr_rotated to balance memory pressure
From: Rik van Riel <riel@redhat.com>

Make sure we scale up nr_rotated when we encounter a referenced
transparent huge page.  This ensures pageout scanning balance is not
distorted when there are huge pages on the LRU.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~thp-scale-nr_rotated-to-balance-memory-pressure mm/vmscan.c
--- a/mm/vmscan.c~thp-scale-nr_rotated-to-balance-memory-pressure
+++ a/mm/vmscan.c
@@ -1276,7 +1276,8 @@ putback_lru_pages(struct zone *zone, str
 		add_page_to_lru_list(zone, page, lru);
 		if (is_active_lru(lru)) {
 			int file = is_file_lru(lru);
-			reclaim_stat->recent_rotated[file]++;
+			int numpages = hpage_nr_pages(page);
+			reclaim_stat->recent_rotated[file] += numpages;
 		}
 		if (!pagevec_add(&pvec, page)) {
 			spin_unlock_irq(&zone->lru_lock);
@@ -1552,7 +1553,7 @@ static void shrink_active_list(unsigned 
 		}
 
 		if (page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
-			nr_rotated++;
+			nr_rotated += hpage_nr_pages(page);
 			/*
 			 * Identify referenced, file-backed active pages and
 			 * give them one more trip around the active list. So
_

Patches currently in -mm which might be from riel@redhat.com are

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
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch


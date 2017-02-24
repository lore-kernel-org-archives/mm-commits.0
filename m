From: akpm@linux-foundation.org
Subject: [patch 017/124] mm: vmscan: move dirty pages out of the way until they're flushed
Date: Fri, 24 Feb 2017 14:56:23 -0800
Message-ID: <58b0ba17.0U8r7DM47dWRRPUF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37154 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdBXW4Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:56:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, riel@redhat.com

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: move dirty pages out of the way until they're flushed

We noticed a performance regression when moving hadoop workloads from 3.10
kernels to 4.0 and 4.6.  This is accompanied by increased pageout activity
initiated by kswapd as well as frequent bursts of allocation stalls and
direct reclaim scans.  Even lowering the dirty ratios to the equivalent of
less than 1% of memory would not eliminate the issue, suggesting that
dirty pages concentrate where the scanner is looking.

This can be traced back to recent efforts of thrash avoidance.  Where 3.10
would not detect refaulting pages and continuously supply clean cache to
the inactive list, a thrashing workload on 4.0+ will detect and activate
refaulting pages right away, distilling used-once pages on the inactive
list much more effectively.  This is by design, and it makes sense for
clean cache.  But for the most part our workload's cache faults are
refaults and its use-once cache is from streaming writes.  We end up with
most of the inactive list dirty, and we don't go after the active cache as
long as we have use-once pages around.

But waiting for writes to avoid reclaiming clean cache that *might*
refault is a bad trade-off.  Even if the refaults happen, reads are faster
than writes.  Before getting bogged down on writeback, reclaim should
first look at *all* cache in the system, even active cache.

To accomplish this, activate pages that are dirty or under writeback
when they reach the end of the inactive LRU.  The pages are marked for
immediate reclaim, meaning they'll get moved back to the inactive LRU
tail as soon as they're written back and become reclaimable.  But in
the meantime, by reducing the inactive list to only immediately
reclaimable pages, we allow the scanner to deactivate and refill the
inactive list with clean cache from the active list tail to guarantee
forward progress.

[hannes@cmpxchg.org: update comment]
  Link: http://lkml.kernel.org/r/20170202191957.22872-8-hannes@cmpxchg.org
Link: http://lkml.kernel.org/r/20170123181641.23938-6-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    7 +++++++
 mm/swap.c                 |    9 +++++----
 mm/vmscan.c               |   15 ++++++++++++---
 3 files changed, 24 insertions(+), 7 deletions(-)

diff -puN include/linux/mm_inline.h~mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed
+++ a/include/linux/mm_inline.h
@@ -50,6 +50,13 @@ static __always_inline void add_page_to_
 	list_add(&page->lru, &lruvec->lists[lru]);
 }
 
+static __always_inline void add_page_to_lru_list_tail(struct page *page,
+				struct lruvec *lruvec, enum lru_list lru)
+{
+	update_lru_size(lruvec, lru, page_zonenum(page), hpage_nr_pages(page));
+	list_add_tail(&page->lru, &lruvec->lists[lru]);
+}
+
 static __always_inline void del_page_from_lru_list(struct page *page,
 				struct lruvec *lruvec, enum lru_list lru)
 {
diff -puN mm/swap.c~mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed mm/swap.c
--- a/mm/swap.c~mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed
+++ a/mm/swap.c
@@ -209,9 +209,10 @@ static void pagevec_move_tail_fn(struct
 {
 	int *pgmoved = arg;
 
-	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
-		enum lru_list lru = page_lru_base_type(page);
-		list_move_tail(&page->lru, &lruvec->lists[lru]);
+	if (PageLRU(page) && !PageUnevictable(page)) {
+		del_page_from_lru_list(page, lruvec, page_lru(page));
+		ClearPageActive(page);
+		add_page_to_lru_list_tail(page, lruvec, page_lru(page));
 		(*pgmoved)++;
 	}
 }
@@ -235,7 +236,7 @@ static void pagevec_move_tail(struct pag
  */
 void rotate_reclaimable_page(struct page *page)
 {
-	if (!PageLocked(page) && !PageDirty(page) && !PageActive(page) &&
+	if (!PageLocked(page) && !PageDirty(page) &&
 	    !PageUnevictable(page) && PageLRU(page)) {
 		struct pagevec *pvec;
 		unsigned long flags;
diff -puN mm/vmscan.c~mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed
+++ a/mm/vmscan.c
@@ -1056,6 +1056,15 @@ static unsigned long shrink_page_list(st
 		 *    throttling so we could easily OOM just because too many
 		 *    pages are in writeback and there is nothing else to
 		 *    reclaim. Wait for the writeback to complete.
+		 *
+		 * In cases 1) and 2) we activate the pages to get them out of
+		 * the way while we continue scanning for clean pages on the
+		 * inactive list and refilling from the active list. The
+		 * observation here is that waiting for disk writes is more
+		 * expensive than potentially causing reloads down the line.
+		 * Since they're marked for immediate reclaim, they won't put
+		 * memory pressure on the cache working set any longer than it
+		 * takes to write them to disk.
 		 */
 		if (PageWriteback(page)) {
 			/* Case 1 above */
@@ -1063,7 +1072,7 @@ static unsigned long shrink_page_list(st
 			    PageReclaim(page) &&
 			    test_bit(PGDAT_WRITEBACK, &pgdat->flags)) {
 				nr_immediate++;
-				goto keep_locked;
+				goto activate_locked;
 
 			/* Case 2 above */
 			} else if (sane_reclaim(sc) ||
@@ -1081,7 +1090,7 @@ static unsigned long shrink_page_list(st
 				 */
 				SetPageReclaim(page);
 				nr_writeback++;
-				goto keep_locked;
+				goto activate_locked;
 
 			/* Case 3 above */
 			} else {
@@ -1174,7 +1183,7 @@ static unsigned long shrink_page_list(st
 				inc_node_page_state(page, NR_VMSCAN_IMMEDIATE);
 				SetPageReclaim(page);
 
-				goto keep_locked;
+				goto activate_locked;
 			}
 
 			if (references == PAGEREF_RECLAIM_CLEAN)
_

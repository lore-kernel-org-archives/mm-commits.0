From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed.patch added
 to -mm tree
Date: Mon, 23 Jan 2017 14:21:32 -0800
Message-ID: <588681ec.ijy7P0Ay3LQqxTP/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42970 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751823AbdAWWVd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 17:21:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: move dirty pages out of the way until they're flushed
has been added to the -mm tree.  Its filename is
     mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

To accomplish this, activate pages that have been dirty or under writeback
for two inactive LRU cycles.  We know at this point that there are not
enough clean inactive pages left to satisfy memory demand in the system. 
The pages are marked for immediate reclaim, meaning they'll get moved back
to the inactive LRU tail as soon as they're written back and become
reclaimable.  But in the meantime, by reducing the inactive list to only
immediately reclaimable pages, we allow the scanner to deactivate and
refill the inactive list with clean cache from the active list tail to
guarantee forward progress.

Link: http://lkml.kernel.org/r/20170123181641.23938-6-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    7 +++++++
 mm/swap.c                 |    9 +++++----
 mm/vmscan.c               |    6 +++---
 3 files changed, 15 insertions(+), 7 deletions(-)

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
@@ -1063,7 +1063,7 @@ static unsigned long shrink_page_list(st
 			    PageReclaim(page) &&
 			    test_bit(PGDAT_WRITEBACK, &pgdat->flags)) {
 				nr_immediate++;
-				goto keep_locked;
+				goto activate_locked;
 
 			/* Case 2 above */
 			} else if (sane_reclaim(sc) ||
@@ -1081,7 +1081,7 @@ static unsigned long shrink_page_list(st
 				 */
 				SetPageReclaim(page);
 				nr_writeback++;
-				goto keep_locked;
+				goto activate_locked;
 
 			/* Case 3 above */
 			} else {
@@ -1174,7 +1174,7 @@ static unsigned long shrink_page_list(st
 				inc_node_page_state(page, NR_VMSCAN_IMMEDIATE);
 				SetPageReclaim(page);
 
-				goto keep_locked;
+				goto activate_locked;
 			}
 
 			if (references == PAGEREF_RECLAIM_CLEAN)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-scan-dirty-pages-even-in-laptop-mode.patch
mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru.patch
mm-vmscan-remove-old-flusher-wakeup-from-direct-reclaim-path.patch
mm-vmscan-only-write-dirty-pages-that-the-scanner-has-seen-twice.patch
mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed.patch


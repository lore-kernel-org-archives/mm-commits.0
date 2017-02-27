From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-only-write-dirty-pages-that-the-scanner-has-seen-twice.patch
 removed from -mm tree
Date: Mon, 27 Feb 2017 12:24:48 -0800
Message-ID: <58b48b10.ohwWYiZ7Oue+svOv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34572 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751435AbdB0UmD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:42:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: only write dirty pages that the scanner has seen twice
has been removed from the -mm tree.  Its filename was
     mm-vmscan-only-write-dirty-pages-that-the-scanner-has-seen-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: only write dirty pages that the scanner has seen twice

Dirty pages can easily reach the end of the LRU while there are still
clean pages to reclaim around.  Don't let kswapd write them back just
because there are a lot of them.  It costs more CPU to find the clean
pages, but that's almost certainly better than to disrupt writeback from
the flushers with LRU-order single-page writes from reclaim.  And the
flushers have been woken up by that point, so we spend IO capacity on
flushing and CPU capacity on finding the clean cache.

Only start writing dirty pages if they have cycled around the LRU twice
now and STILL haven't been queued on the IO device.  It's possible that
the dirty pages are so sparsely distributed across different bdis, inodes,
memory cgroups, that the flushers take forever to get to the ones we want
reclaimed.  Once we see them twice on the LRU, we know that's the quicker
way to find them, so do LRU writeback.

Link: http://lkml.kernel.org/r/20170123181641.23938-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-only-write-dirty-pages-that-the-scanner-has-seen-twice mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-only-write-dirty-pages-that-the-scanner-has-seen-twice
+++ a/mm/vmscan.c
@@ -1153,13 +1153,18 @@ static unsigned long shrink_page_list(st
 
 		if (PageDirty(page)) {
 			/*
-			 * Only kswapd can writeback filesystem pages to
-			 * avoid risk of stack overflow but only writeback
-			 * if many dirty pages have been encountered.
+			 * Only kswapd can writeback filesystem pages
+			 * to avoid risk of stack overflow. But avoid
+			 * injecting inefficient single-page IO into
+			 * flusher writeback as much as possible: only
+			 * write pages when we've encountered many
+			 * dirty pages, and when we've already scanned
+			 * the rest of the LRU for clean pages and see
+			 * the same dirty pages again (PageReclaim).
 			 */
 			if (page_is_file_cache(page) &&
-					(!current_is_kswapd() ||
-					 !test_bit(PGDAT_DIRTY, &pgdat->flags))) {
+			    (!current_is_kswapd() || !PageReclaim(page) ||
+			     !test_bit(PGDAT_DIRTY, &pgdat->flags))) {
 				/*
 				 * Immediately reclaim when written back.
 				 * Similar in principal to deactivate_page()
_

Patches currently in -mm which might be from hannes@cmpxchg.org are



From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-data-corruption-caused-by-lazyfree-page.patch removed from -mm tree
Date: Wed, 04 Oct 2017 12:41:04 -0700
Message-ID: <20171004194104.pdZt3vUIW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33534 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTlF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:41:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: asavkov@redhat.com, hannes@cmpxchg.org, hdanton@sina.com, hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, shli@fb.com, stable@vger.kernel.org


The patch titled
     Subject: mm: fix data corruption caused by lazyfree page
has been removed from the -mm tree.  Its filename was
     mm-fix-data-corruption-caused-by-lazyfree-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shaohua Li <shli@fb.com>
Subject: mm: fix data corruption caused by lazyfree page

MADV_FREE clears pte dirty bit and then marks the page lazyfree (clear
SwapBacked).  There is no lock to prevent the page is added to swap cache
between these two steps by page reclaim.  If page reclaim finds such page,
it will simply add the page to swap cache without pageout the page to swap
because the page is marked as clean.  Next time, page fault will read data
from the swap slot which doesn't have the original data, so we have a data
corruption.  To fix issue, we mark the page dirty and pageout the page.

However, we shouldn't dirty all pages which is clean and in swap cache. 
swapin page is swap cache and clean too.  So we only dirty page which is
added into swap cache in page reclaim, which shouldn't be swapin page.  As
Minchan suggested, simply dirty the page in add_to_swap can do the job.

Fixes: 802a3a92ad7a ("mm: reclaim MADV_FREE pages")
Link: http://lkml.kernel.org/r/08c84256b007bf3f63c91d94383bd9eb6fee2daa.1506446061.git.shli@fb.com
Signed-off-by: Shaohua Li <shli@fb.com>
Reported-by: Artem Savkov <asavkov@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>	[4.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/swap_state.c~mm-fix-data-corruption-caused-by-lazyfree-page mm/swap_state.c
--- a/mm/swap_state.c~mm-fix-data-corruption-caused-by-lazyfree-page
+++ a/mm/swap_state.c
@@ -242,6 +242,17 @@ int add_to_swap(struct page *page)
 		 * clear SWAP_HAS_CACHE flag.
 		 */
 		goto fail;
+	/*
+	 * Normally the page will be dirtied in unmap because its pte should be
+	 * dirty. A special case is MADV_FREE page. The page'e pte could have
+	 * dirty bit cleared but the page's SwapBacked bit is still set because
+	 * clearing the dirty bit and SwapBacked bit has no lock protected. For
+	 * such page, unmap will not set dirty bit for it, so page reclaim will
+	 * not write the page out. This can cause data corruption when the page
+	 * is swap in later. Always setting the dirty bit for the page solves
+	 * the problem.
+	 */
+	set_page_dirty(page);
 
 	return 1;
 
_

Patches currently in -mm which might be from shli@fb.com are



From: akpm@linux-foundation.org
Subject: [patch 022/102] mm: fix lazyfree BUG_ON check in
 try_to_unmap_one()
Date: Wed, 03 May 2017 14:52:36 -0700
Message-ID: <20170503215236.vldKX-_1b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47500 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751561AbdECVwh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:52:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, shli@fb.com, torvalds@linux-foundation.org

From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix lazyfree BUG_ON check in try_to_unmap_one()

If a page is swapbacked, it means it should be in swapcache in
try_to_unmap_one's path.

If a page is !swapbacked, it mean it shouldn't be in swapcache in
try_to_unmap_one's path.

Check both two cases all at once and if it fails, warn and return
SWAP_FAIL.  Such bug never mean we should shut down the kernel.

[minchan@kernel.org: do not use VM_WARN_ON_ONCE as if condition[
  Link: http://lkml.kernel.org/r/20170309060226.GB854@bbox
Link: http://lkml.kernel.org/r/20170307055551.GC29458@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shaohua Li <shli@fb.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/rmap.c~mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one mm/rmap.c
--- a/mm/rmap.c~mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -1418,8 +1418,12 @@ static int try_to_unmap_one(struct page
 			 * Store the swap location in the pte.
 			 * See handle_pte_fault() ...
 			 */
-			VM_BUG_ON_PAGE(!PageSwapCache(page) && PageSwapBacked(page),
-				page);
+			if (unlikely(PageSwapBacked(page) != PageSwapCache(page))) {
+				WARN_ON_ONCE(1);
+				ret = SWAP_FAIL;
+				page_vma_mapped_walk_done(&pvmw);
+				break;
+			}
 
 			/* MADV_FREE page check */
 			if (!PageSwapBacked(page)) {
_

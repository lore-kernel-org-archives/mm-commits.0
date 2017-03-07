From: akpm@linux-foundation.org
Subject: + mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch added to -mm tree
Date: Tue, 07 Mar 2017 14:56:50 -0800
Message-ID: <58bf3ab2.nWt8kag+6Kq8UfTY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43988 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756295AbdCGXGg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2017 18:06:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, shli@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix lazyfree BUG_ON check in try_to_unmap_one()
has been added to the -mm tree.  Its filename is
     mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix lazyfree BUG_ON check in try_to_unmap_one()

If a page is swapbacked, it means it should be in swapcache in
try_to_unmap_one's path.

If a page is !swapbacked, it mean it shouldn't be in swapcache in
try_to_unmap_one's path.

Check both two cases all at once and if it fails, warn and return
SWAP_FAIL.  Such bug never mean we should shut down the kernel.

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

 mm/rmap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/rmap.c~mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one mm/rmap.c
--- a/mm/rmap.c~mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -1413,8 +1413,13 @@ static int try_to_unmap_one(struct page
 			 * Store the swap location in the pte.
 			 * See handle_pte_fault() ...
 			 */
-			VM_BUG_ON_PAGE(!PageSwapCache(page) && PageSwapBacked(page),
-				page);
+			if (VM_WARN_ON_ONCE(PageSwapBacked(page) !=
+						PageSwapCache(page))) {
+				ret = SWAP_FAIL;
+				page_vma_mapped_walk_done(&pvmw);
+				break;
+
+			}
 
 			/* MADV_FREE page check */
 			if (!PageSwapBacked(page)) {
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-reclaim-madv_free-pages-fix.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch


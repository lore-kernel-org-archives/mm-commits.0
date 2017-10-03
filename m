From: akpm@linux-foundation.org
Subject: [patch 24/51] mm: avoid marking swap cached page as lazyfree
Date: Tue, 03 Oct 2017 16:15:29 -0700
Message-ID: <59d41a11.ax18kSm9quXYfL+/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXPa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, shli@fb.com, asavkov@redhat.com, hannes@cmpxchg.org, hdanton@sina.com, hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, stable@vger.kernel.org

From: Shaohua Li <shli@fb.com>
Subject: mm: avoid marking swap cached page as lazyfree

MADV_FREE clears pte dirty bit and then marks the page lazyfree (clear
SwapBacked).  There is no lock to prevent the page is added to swap cache
between these two steps by page reclaim.  Page reclaim could add the page
to swap cache and unmap the page.  After page reclaim, the page is added
back to lru.  At that time, we probably start draining per-cpu pagevec and
mark the page lazyfree.  So the page could be in a state with SwapBacked
cleared and PG_swapcache set.  Next time there is a refault in the virtual
address, do_swap_page can find the page from swap cache but the page has
PageSwapCache false because SwapBacked isn't set, so do_swap_page will
bail out and do nothing.  The task will keep running into fault handler.

Fixes: 802a3a92ad7a ("mm: reclaim MADV_FREE pages")
Link: http://lkml.kernel.org/r/6537ef3814398c0073630b03f176263bc81f0902.1506446061.git.shli@fb.com
Signed-off-by: Shaohua Li <shli@fb.com>
Reported-by: Artem Savkov <asavkov@redhat.com>
Tested-by: Artem Savkov <asavkov@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>	[4.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/swap.c~mm-avoid-marking-swap-cached-page-as-lazyfree mm/swap.c
--- a/mm/swap.c~mm-avoid-marking-swap-cached-page-as-lazyfree
+++ a/mm/swap.c
@@ -575,7 +575,7 @@ static void lru_lazyfree_fn(struct page
 			    void *arg)
 {
 	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
-	    !PageUnevictable(page)) {
+	    !PageSwapCache(page) && !PageUnevictable(page)) {
 		bool active = PageActive(page);
 
 		del_page_from_lru_list(page, lruvec,
@@ -665,7 +665,7 @@ void deactivate_file_page(struct page *p
 void mark_page_lazyfree(struct page *page)
 {
 	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
-	    !PageUnevictable(page)) {
+	    !PageSwapCache(page) && !PageUnevictable(page)) {
 		struct pagevec *pvec = &get_cpu_var(lru_lazyfree_pvecs);
 
 		get_page(page);
_

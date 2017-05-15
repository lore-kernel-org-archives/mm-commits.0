From: akpm@linux-foundation.org
Subject: + mm-thp-swap-move-anonymous-thp-split-logic-to-vmscan.patch
 added to -mm tree
Date: Mon, 15 May 2017 13:18:13 -0700
Message-ID: <591a0d05.bOHVawi0jpwllptb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39646 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965496AbdEOUSO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 16:18:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aarcange@redhat.com, ebru.akagunduz@gmail.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, riel@redhat.com, shli@kernel.org, tj@kernel.org, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: move anonymous THP split logic to vmscan
has been added to the -mm tree.  Its filename is
     mm-thp-swap-move-anonymous-thp-split-logic-to-vmscan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-swap-move-anonymous-thp-split-logic-to-vmscan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-swap-move-anonymous-thp-split-logic-to-vmscan.patch

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
Subject: mm, THP, swap: move anonymous THP split logic to vmscan

The add_to_swap aims to allocate swap_space(ie, swap slot and swapcache)
so if it fails due to lack of space in case of THP or something(hdd swap
but tries THP swapout) *caller* rather than add_to_swap itself should
split the THP page and retry it with base page which is more natural.

Link: http://lkml.kernel.org/r/20170515112522.32457-4-ying.huang@intel.com
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++--
 mm/swap_state.c      |   23 ++++++-----------------
 mm/vmscan.c          |   17 ++++++++++++++++-
 3 files changed, 24 insertions(+), 20 deletions(-)

diff -puN include/linux/swap.h~mm-thp-swap-move-anonymous-thp-split-logic-to-vmscan include/linux/swap.h
--- a/include/linux/swap.h~mm-thp-swap-move-anonymous-thp-split-logic-to-vmscan
+++ a/include/linux/swap.h
@@ -353,7 +353,7 @@ extern struct address_space *swapper_spa
 		>> SWAP_ADDRESS_SPACE_SHIFT])
 extern unsigned long total_swapcache_pages(void);
 extern void show_swap_cache_info(void);
-extern int add_to_swap(struct page *, struct list_head *list);
+extern int add_to_swap(struct page *page);
 extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
 extern int __add_to_swap_cache(struct page *page, swp_entry_t entry);
 extern void __delete_from_swap_cache(struct page *);
@@ -473,7 +473,7 @@ static inline struct page *lookup_swap_c
 	return NULL;
 }
 
-static inline int add_to_swap(struct page *page, struct list_head *list)
+static inline int add_to_swap(struct page *page)
 {
 	return 0;
 }
diff -puN mm/swap_state.c~mm-thp-swap-move-anonymous-thp-split-logic-to-vmscan mm/swap_state.c
--- a/mm/swap_state.c~mm-thp-swap-move-anonymous-thp-split-logic-to-vmscan
+++ a/mm/swap_state.c
@@ -184,7 +184,7 @@ void __delete_from_swap_cache(struct pag
  * Allocate swap space for the page and add the page to the
  * swap cache.  Caller needs to hold the page lock. 
  */
-int add_to_swap(struct page *page, struct list_head *list)
+int add_to_swap(struct page *page)
 {
 	swp_entry_t entry;
 	int err;
@@ -192,12 +192,12 @@ int add_to_swap(struct page *page, struc
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageUptodate(page), page);
 
-retry:
 	entry = get_swap_page(page);
 	if (!entry.val)
-		goto fail;
+		return 0;
+
 	if (mem_cgroup_try_charge_swap(page, entry))
-		goto fail_free;
+		goto fail;
 
 	/*
 	 * Radix-tree node allocations from PF_MEMALLOC contexts could
@@ -218,23 +218,12 @@ retry:
 		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
 		 * clear SWAP_HAS_CACHE flag.
 		 */
-		goto fail_free;
-
-	if (PageTransHuge(page)) {
-		err = split_huge_page_to_list(page, list);
-		if (err) {
-			delete_from_swap_cache(page);
-			return 0;
-		}
-	}
+		goto fail;
 
 	return 1;
 
-fail_free:
-	put_swap_page(page, entry);
 fail:
-	if (PageTransHuge(page) && !split_huge_page_to_list(page, list))
-		goto retry;
+	put_swap_page(page, entry);
 	return 0;
 }
 
diff -puN mm/vmscan.c~mm-thp-swap-move-anonymous-thp-split-logic-to-vmscan mm/vmscan.c
--- a/mm/vmscan.c~mm-thp-swap-move-anonymous-thp-split-logic-to-vmscan
+++ a/mm/vmscan.c
@@ -1125,8 +1125,23 @@ static unsigned long shrink_page_list(st
 		    !PageSwapCache(page)) {
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
-			if (!add_to_swap(page, page_list))
+			if (!add_to_swap(page)) {
+				if (!PageTransHuge(page))
+					goto activate_locked;
+				/* Split THP and swap individual base pages */
+				if (split_huge_page_to_list(page, page_list))
+					goto activate_locked;
+				if (!add_to_swap(page))
+					goto activate_locked;
+			}
+
+			/* XXX: We don't support THP writes */
+			if (PageTransHuge(page) &&
+				  split_huge_page_to_list(page, page_list)) {
+				delete_from_swap_cache(page);
 				goto activate_locked;
+			}
+
 			may_enter_fs = 1;
 
 			/* Adding to swap updated mapping */
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page.patch
mm-thp-swap-move-anonymous-thp-split-logic-to-vmscan.patch


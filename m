From: akpm@linux-foundation.org
Subject: [merged] mm-remove-swap_mlock-in-ttu.patch removed from
 -mm tree
Date: Thu, 04 May 2017 12:11:36 -0700
Message-ID: <20170504191136.a13qdTxmS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51470 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755434AbdEDTLi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:11:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz


The patch titled
     Subject: mm: remove SWAP_MLOCK in ttu
has been removed from the -mm tree.  Its filename was
     mm-remove-swap_mlock-in-ttu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: remove SWAP_MLOCK in ttu

ttu doesn't need to return SWAP_MLOCK.  Instead, just return SWAP_FAIL
because it means the page is not-swappable so it should move to another
LRU list(active or unevictable).  putback friends will move it to right
list depending on the page's LRU flag.

Link: http://lkml.kernel.org/r/1489555493-14659-6-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 -
 mm/rmap.c            |    3 +--
 mm/vmscan.c          |   20 +++++++-------------
 3 files changed, 8 insertions(+), 16 deletions(-)

diff -puN include/linux/rmap.h~mm-remove-swap_mlock-in-ttu include/linux/rmap.h
--- a/include/linux/rmap.h~mm-remove-swap_mlock-in-ttu
+++ a/include/linux/rmap.h
@@ -297,6 +297,5 @@ static inline int page_mkclean(struct pa
 #define SWAP_SUCCESS	0
 #define SWAP_AGAIN	1
 #define SWAP_FAIL	2
-#define SWAP_MLOCK	3
 
 #endif	/* _LINUX_RMAP_H */
diff -puN mm/rmap.c~mm-remove-swap_mlock-in-ttu mm/rmap.c
--- a/mm/rmap.c~mm-remove-swap_mlock-in-ttu
+++ a/mm/rmap.c
@@ -1329,7 +1329,7 @@ static int try_to_unmap_one(struct page
 					 */
 					mlock_vma_page(page);
 				}
-				ret = SWAP_MLOCK;
+				ret = SWAP_FAIL;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
@@ -1506,7 +1506,6 @@ static int page_mapcount_is_zero(struct
  * SWAP_SUCCESS	- we succeeded in removing all mappings
  * SWAP_AGAIN	- we missed a mapping, try again later
  * SWAP_FAIL	- the page is unswappable
- * SWAP_MLOCK	- page is mlocked.
  */
 int try_to_unmap(struct page *page, enum ttu_flags flags)
 {
diff -puN mm/vmscan.c~mm-remove-swap_mlock-in-ttu mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-swap_mlock-in-ttu
+++ a/mm/vmscan.c
@@ -987,7 +987,7 @@ static unsigned long shrink_page_list(st
 		sc->nr_scanned++;
 
 		if (unlikely(!page_evictable(page)))
-			goto cull_mlocked;
+			goto activate_locked;
 
 		if (!sc->may_unmap && page_mapped(page))
 			goto keep_locked;
@@ -1152,8 +1152,6 @@ static unsigned long shrink_page_list(st
 				goto activate_locked;
 			case SWAP_AGAIN:
 				goto keep_locked;
-			case SWAP_MLOCK:
-				goto cull_mlocked;
 			case SWAP_SUCCESS:
 				; /* try to free the page below */
 			}
@@ -1295,20 +1293,16 @@ free_it:
 		list_add(&page->lru, &free_pages);
 		continue;
 
-cull_mlocked:
-		if (PageSwapCache(page))
-			try_to_free_swap(page);
-		unlock_page(page);
-		list_add(&page->lru, &ret_pages);
-		continue;

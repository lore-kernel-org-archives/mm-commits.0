From: akpm@linux-foundation.org
Subject: + mm-remove-swap_mlock-in-ttu.patch added to -mm tree
Date: Wed, 15 Mar 2017 12:36:54 -0700
Message-ID: <58c997d6./L0p8WyyU0QGtGMo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49860 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752889AbdCOTg4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2017 15:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove SWAP_MLOCK in ttu
has been added to the -mm tree.  Its filename is
     mm-remove-swap_mlock-in-ttu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-swap_mlock-in-ttu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-swap_mlock-in-ttu.patch

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
@@ -985,7 +985,7 @@ static unsigned long shrink_page_list(st
 		sc->nr_scanned++;
 
 		if (unlikely(!page_evictable(page)))
-			goto cull_mlocked;
+			goto activate_locked;
 
 		if (!sc->may_unmap && page_mapped(page))
 			goto keep_locked;
@@ -1150,8 +1150,6 @@ static unsigned long shrink_page_list(st
 				goto activate_locked;
 			case SWAP_AGAIN:
 				goto keep_locked;
-			case SWAP_MLOCK:
-				goto cull_mlocked;
 			case SWAP_SUCCESS:
 				; /* try to free the page below */
 			}
@@ -1293,20 +1291,16 @@ free_it:
 		list_add(&page->lru, &free_pages);
 		continue;
 
-cull_mlocked:
-		if (PageSwapCache(page))
-			try_to_free_swap(page);
-		unlock_page(page);
-		list_add(&page->lru, &ret_pages);
-		continue;
-
 activate_locked:
 		/* Not a candidate for swapping, so reclaim swap space. */
-		if (PageSwapCache(page) && mem_cgroup_swap_full(page))
+		if (PageSwapCache(page) && (mem_cgroup_swap_full(page) ||
+						PageMlocked(page)))
 			try_to_free_swap(page);
 		VM_BUG_ON_PAGE(PageActive(page), page);
-		SetPageActive(page);
-		pgactivate++;
+		if (!PageMlocked(page)) {
+			SetPageActive(page);
+			pgactivate++;
+		}
 keep_locked:
 		unlock_page(page);
 keep:
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-reclaim-madv_free-pages-fix.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch
mm-do-not-use-double-negation-for-testing-page-flags.patch
mm-remove-unncessary-ret-in-page_referenced.patch
mm-remove-swap_dirty-in-ttu.patch
mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch
mm-make-the-try_to_munlock-void-function.patch
mm-remove-swap_mlock-in-ttu.patch
mm-remove-swap_again-in-ttu.patch
mm-make-ttus-return-boolean.patch
mm-make-rmap_walk-void-function.patch
mm-make-rmap_one-boolean-function.patch
mm-remove-swap_.patch


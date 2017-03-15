From: akpm@linux-foundation.org
Subject: + mm-remove-swap_dirty-in-ttu.patch added to -mm tree
Date: Wed, 15 Mar 2017 12:36:46 -0700
Message-ID: <58c997ce.jdajh/UXT5OwfM7u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49810 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbdCOTgs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2017 15:36:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove SWAP_DIRTY in ttu
has been added to the -mm tree.  Its filename is
     mm-remove-swap_dirty-in-ttu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-swap_dirty-in-ttu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-swap_dirty-in-ttu.patch

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
Subject: mm: remove SWAP_DIRTY in ttu

If we found lazyfree page is dirty, try_to_unmap_one can just
SetPageSwapBakced in there like PG_mlocked page and just return with
SWAP_FAIL which is very natural because the page is not swappable right
now so that vmscan can activate it.  There is no point to introduce new
return value SWAP_DIRTY in try_to_unmap at the moment.

Link: http://lkml.kernel.org/r/1489555493-14659-3-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 -
 mm/rmap.c            |    4 ++--
 mm/vmscan.c          |    3 ---
 3 files changed, 2 insertions(+), 6 deletions(-)

diff -puN include/linux/rmap.h~mm-remove-swap_dirty-in-ttu include/linux/rmap.h
--- a/include/linux/rmap.h~mm-remove-swap_dirty-in-ttu
+++ a/include/linux/rmap.h
@@ -298,6 +298,5 @@ static inline int page_mkclean(struct pa
 #define SWAP_AGAIN	1
 #define SWAP_FAIL	2
 #define SWAP_MLOCK	3
-#define SWAP_DIRTY	4
 
 #endif	/* _LINUX_RMAP_H */
diff -puN mm/rmap.c~mm-remove-swap_dirty-in-ttu mm/rmap.c
--- a/mm/rmap.c~mm-remove-swap_dirty-in-ttu
+++ a/mm/rmap.c
@@ -1436,7 +1436,8 @@ static int try_to_unmap_one(struct page
 				 * discarded. Remap the page to page table.
 				 */
 				set_pte_at(mm, address, pvmw.pte, pteval);
-				ret = SWAP_DIRTY;
+				SetPageSwapBacked(page);
+				ret = SWAP_FAIL;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
@@ -1506,7 +1507,6 @@ static int page_mapcount_is_zero(struct
  * SWAP_AGAIN	- we missed a mapping, try again later
  * SWAP_FAIL	- the page is unswappable
  * SWAP_MLOCK	- page is mlocked.
- * SWAP_DIRTY	- page is dirty MADV_FREE page
  */
 int try_to_unmap(struct page *page, enum ttu_flags flags)
 {
diff -puN mm/vmscan.c~mm-remove-swap_dirty-in-ttu mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-swap_dirty-in-ttu
+++ a/mm/vmscan.c
@@ -1145,9 +1145,6 @@ static unsigned long shrink_page_list(st
 		if (page_mapped(page)) {
 			switch (ret = try_to_unmap(page,
 				ttu_flags | TTU_BATCH_FLUSH)) {
-			case SWAP_DIRTY:
-				SetPageSwapBacked(page);
-				/* fall through */
 			case SWAP_FAIL:
 				nr_unmap_fail++;
 				goto activate_locked;
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


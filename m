From: akpm@linux-foundation.org
Subject: [patch 053/102] mm: remove SWAP_AGAIN in ttu
Date: Wed, 03 May 2017 14:54:17 -0700
Message-ID: <20170503215417.qdNyqB82z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50260 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbdECVza (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:55:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Minchan Kim <minchan@kernel.org>
Subject: mm: remove SWAP_AGAIN in ttu

In 2002, [1] introduced SWAP_AGAIN.  At that time, try_to_unmap_one used
spin_trylock(&mm->page_table_lock) so it's really easy to contend and fail
to hold a lock so SWAP_AGAIN to keep LRU status makes sense.

However, now we changed it to mutex-based lock and be able to block
without skip pte so there is few of small window to return SWAP_AGAIN so
remove SWAP_AGAIN and just return SWAP_FAIL.

[1] c48c43e, minimal rmap

Link: http://lkml.kernel.org/r/1489555493-14659-7-git-send-email-minchan@kernel.org
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

 mm/rmap.c   |   11 +++--------
 mm/vmscan.c |    2 --
 2 files changed, 3 insertions(+), 10 deletions(-)

diff -puN mm/rmap.c~mm-remove-swap_again-in-ttu mm/rmap.c
--- a/mm/rmap.c~mm-remove-swap_again-in-ttu
+++ a/mm/rmap.c
@@ -1504,13 +1504,10 @@ static int page_mapcount_is_zero(struct
  * Return values are:
  *
  * SWAP_SUCCESS	- we succeeded in removing all mappings
- * SWAP_AGAIN	- we missed a mapping, try again later
  * SWAP_FAIL	- the page is unswappable
  */
 int try_to_unmap(struct page *page, enum ttu_flags flags)
 {
-	int ret;
-
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
 		.arg = (void *)flags,
@@ -1530,13 +1527,11 @@ int try_to_unmap(struct page *page, enum
 		rwc.invalid_vma = invalid_migration_vma;
 
 	if (flags & TTU_RMAP_LOCKED)
-		ret = rmap_walk_locked(page, &rwc);
+		rmap_walk_locked(page, &rwc);
 	else
-		ret = rmap_walk(page, &rwc);
+		rmap_walk(page, &rwc);
 
-	if (!page_mapcount(page))
-		ret = SWAP_SUCCESS;
-	return ret;
+	return !page_mapcount(page) ? SWAP_SUCCESS : SWAP_FAIL;
 }
 
 static int page_not_mapped(struct page *page)
diff -puN mm/vmscan.c~mm-remove-swap_again-in-ttu mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-swap_again-in-ttu
+++ a/mm/vmscan.c
@@ -1150,8 +1150,6 @@ static unsigned long shrink_page_list(st
 			case SWAP_FAIL:
 				nr_unmap_fail++;
 				goto activate_locked;
-			case SWAP_AGAIN:
-				goto keep_locked;
 			case SWAP_SUCCESS:
 				; /* try to free the page below */
 			}
_

From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-fix-a-typo-in-comment-manitained-maintained.patch removed from
 -mm tree
Date: Fri, 05 Jun 2020 13:18:22 -0700
Message-ID: <20200605201822.R6XKy9Jw5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgFEUSX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm/hugetlb: fix a typos in comments
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-a-typo-in-comment-manitained-maintained.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm/hugetlb: fix a typos in comments

[akpm@linux-foundation.org: coding style fixes]
Link: http://lkml.kernel.org/r/20200410163714.14085-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-a-typo-in-comment-manitained-maintained
+++ a/mm/hugetlb.c
@@ -85,7 +85,7 @@ static inline void unlock_or_release_sub
 	spin_unlock(&spool->lock);
 
 	/* If no pages are used, and no other handles to the subpool
-	 * remain, give up any reservations mased on minimum size and
+	 * remain, give up any reservations based on minimum size and
 	 * free the subpool */
 	if (free) {
 		if (spool->min_hpages != -1)
@@ -133,7 +133,7 @@ void hugepage_put_subpool(struct hugepag
  * the request.  Otherwise, return the number of pages by which the
  * global pools must be adjusted (upward).  The returned value may
  * only be different than the passed value (delta) in the case where
- * a subpool minimum size must be manitained.
+ * a subpool minimum size must be maintained.
  */
 static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
 				      long delta)
@@ -473,7 +473,7 @@ out_of_memory:
  *
  * Return the number of new huge pages added to the map.  This number is greater
  * than or equal to zero.  If file_region entries needed to be allocated for
- * this operation and we were not able to allocate, it ruturns -ENOMEM.
+ * this operation and we were not able to allocate, it returns -ENOMEM.
  * region_add of regions of length 1 never allocate file_regions and cannot
  * fail; region_chg will always allocate at least 1 entry and a region_add for
  * 1 page will only require at most 1 entry.
@@ -988,7 +988,7 @@ static bool vma_has_reserves(struct vm_a
 		 * We know VM_NORESERVE is not set.  Therefore, there SHOULD
 		 * be a region map for all pages.  The only situation where
 		 * there is no region map is if a hole was punched via
-		 * fallocate.  In this case, there really are no reverves to
+		 * fallocate.  In this case, there really are no reserves to
 		 * use.  This situation is indicated if chg != 0.
 		 */
 		if (chg)
@@ -1519,7 +1519,7 @@ static void prep_compound_gigantic_page(
 		 * For gigantic hugepages allocated through bootmem at
 		 * boot, it's safer to be consistent with the not-gigantic
 		 * hugepages and clear the PG_reserved bit from all tail pages
-		 * too.  Otherwse drivers using get_user_pages() to access tail
+		 * too.  Otherwise drivers using get_user_pages() to access tail
 		 * pages may get the reference counting wrong if they see
 		 * PG_reserved set on a tail page (despite the head page not
 		 * having PG_reserved set).  Enforcing this consistency between
@@ -4579,9 +4579,9 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	/*
 	 * entry could be a migration/hwpoison entry at this point, so this
 	 * check prevents the kernel from going below assuming that we have
-	 * a active hugepage in pagecache. This goto expects the 2nd page fault,
-	 * and is_hugetlb_entry_(migration|hwpoisoned) check will properly
-	 * handle it.
+	 * an active hugepage in pagecache. This goto expects the 2nd page
+	 * fault, and is_hugetlb_entry_(migration|hwpoisoned) check will
+	 * properly handle it.
 	 */
 	if (!pte_present(entry))
 		goto out_mutex;
_

Patches currently in -mm which might be from ethp@qq.com are

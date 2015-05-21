From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages.patch
 added to -mm tree
Date: Thu, 21 May 2015 16:18:33 -0700
Message-ID: <555e67c9.I1pC2bfWeFX9xIUZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbbEUXSe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 May 2015 19:18:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: handle races in alloc_huge_page and hugetlb_reserve_pages
has been added to the -mm tree.  Its filename is
     mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: handle races in alloc_huge_page and hugetlb_reserve_pages

alloc_huge_page and hugetlb_reserve_pages use region_chg to
calculate the number of pages which will be added to the reserve
map.  Subpool and global reserve counts are adjusted based on
the output of region_chg.  Before the pages are actually added
to the reserve map, these routines could race and add fewer
pages than expected.  If this happens, the subpool and global
reserve counts are not correct.

Compare the number of pages actually added (region_add) to those
expected to added (region_chg).  If fewer pages are actually added,
this indicates a race and adjust counters accordingly.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 1 file changed, 33 insertions(+), 4 deletions(-)

index 7f64034..63f6d43 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages
+++ a/mm/hugetlb.c
@@ -1475,13 +1475,16 @@ static long vma_commit_reservation(struc
 		return 0;
 }
 
+/* Forward declaration */
+static int hugetlb_acct_memory(struct hstate *h, long delta);
+
 static struct page *alloc_huge_page(struct vm_area_struct *vma,
 				    unsigned long addr, int avoid_reserve)
 {
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct page *page;
-	long chg;
+	long chg, commit;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg;
 
@@ -1522,7 +1525,20 @@ static struct page *alloc_huge_page(stru
 
 	set_page_private(page, (unsigned long)spool);
 
-	vma_commit_reservation(h, vma, addr);
+	commit = vma_commit_reservation(h, vma, addr);
+	if (unlikely(chg > commit)) {
+		/*
+		 * The page was added to the reservation map between
+		 * vma_needs_reservation and vma_commit_reservation.
+		 * This indicates a race with hugetlb_reserve_pages.
+		 * Adjust for the subpool count incremented above AND
+		 * in hugetlb_reserve_pages for the same page.  Also,
+		 * the reservation count added in hugetlb_reserve_pages
+		 * no longer applies.
+		 */
+		hugepage_subpool_put_pages(spool, 1);
+		hugetlb_acct_memory(h, -1);
+	}
 	return page;
 
 out_uncharge_cgroup:
@@ -3640,8 +3656,21 @@ int hugetlb_reserve_pages(struct inode *
 	 * consumed reservations are stored in the map. Hence, nothing
 	 * else has to be done for private mappings here
 	 */
-	if (!vma || vma->vm_flags & VM_MAYSHARE)
-		region_add(resv_map, from, to);
+	if (!vma || vma->vm_flags & VM_MAYSHARE) {
+		long add = region_add(resv_map, from, to);
+
+		if (unlikely(chg > add)) {
+			/*
+			 * pages in this range were added to the reserve
+			 * map between region_chg and region_add.  This
+			 * indicates a race with alloc_huge_page.  Adjust
+			 * the subpool and reserve counts modified above
+			 * based on the difference.
+			 */
+			hugepage_subpool_put_pages(spool, chg - add);
+			hugetlb_acct_memory(h, -(chg - ret));
+		}
+	}
 	return 0;
 out_err:
 	if (vma && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages.patch


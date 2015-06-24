From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v4.patch removed from -mm tree
Date: Wed, 24 Jun 2015 16:48:38 -0700
Message-ID: <558b41d6.F8lGYLZWcvLUYHzl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbbFXXsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jun 2015 19:48:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave@stgolabs.net, lcapitulino@redhat.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: handle races in alloc_huge_page and hugetlb_reserve_pages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v4.patch

This patch was dropped because it was folded into mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages.patch

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: handle races in alloc_huge_page and hugetlb_reserve_pages

Reserve count adjustments need to take into account hugetlbfs min_size
reservation pools

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v4 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v4
+++ a/mm/hugetlb.c
@@ -1594,8 +1594,10 @@ static struct page *alloc_huge_page(stru
 		 * the reservation count added in hugetlb_reserve_pages
 		 * no longer applies.
 		 */
-		hugepage_subpool_put_pages(spool, 1);
-		hugetlb_acct_memory(h, -1);
+		long rsv_adjust;
+
+		rsv_adjust = hugepage_subpool_put_pages(spool, 1);
+		hugetlb_acct_memory(h, -rsv_adjust);
 	}
 	return page;
 
@@ -3725,8 +3727,11 @@ int hugetlb_reserve_pages(struct inode *
 			 * the subpool and reserve counts modified above
 			 * based on the difference.
 			 */
-			hugepage_subpool_put_pages(spool, chg - add);
-			hugetlb_acct_memory(h, -(chg - ret));
+			long rsv_adjust;
+
+			rsv_adjust = hugepage_subpool_put_pages(spool,
+								chg - add);
+			hugetlb_acct_memory(h, -rsv_adjust);
 		}
 	}
 	return 0;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
mm-hugetlb-document-the-reserve-map-region-tracking-routines.patch
mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages.patch


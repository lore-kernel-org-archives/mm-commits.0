From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v4.patch added to -mm tree
Date: Tue, 02 Jun 2015 15:48:09 -0700
Message-ID: <556e32a9.MVprdCq5IulMb6gW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbbFBWsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2015 18:48:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave@stgolabs.net, lcapitulino@redhat.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: handle races in alloc_huge_page and hugetlb_reserve_pages
has been added to the -mm tree.  Its filename is
     mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v4.patch

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
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v4.patch


From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v2.patch removed from -mm tree
Date: Wed, 27 May 2015 14:20:53 -0700
Message-ID: <55663535.Su1KSdoWSrOXKVoQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbbE0VUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 May 2015 17:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave@stgolabs.net, lcapitulino@redhat.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: handle races in alloc_huge_page and hugetlb_reserve_pages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: handle races in alloc_huge_page and hugetlb_reserve_pages

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v2
+++ a/mm/hugetlb.c
@@ -1532,9 +1532,6 @@ static long vma_commit_reservation(struc
 	return __vma_reservation_common(h, vma, addr, (bool)0);
 }
 
-/* Forward declaration */
-static int hugetlb_acct_memory(struct hstate *h, long delta);

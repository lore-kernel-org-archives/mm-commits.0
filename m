From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-add-missing-annotation-for-gather_surplus_pages.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 18:59:38 -0700
Message-ID: <20200408015938.czcb_dzDU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB7j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbi.octave@gmail.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add missing annotation for gather_surplus_pages()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-missing-annotation-for-gather_surplus_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jules Irenge <jbi.octave@gmail.com>
Subject: mm/hugetlb: add missing annotation for gather_surplus_pages()

Sparse reports a warning at gather_surplus_pages()

warning: context imbalance in hugetlb_cow() - unexpected unlock

The root cause is the missing annotation at gather_surplus_pages()
Add the missing __must_hold(&hugetlb_lock)

Link: http://lkml.kernel.org/r/20200214204741.94112-7-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-hugetlb-add-missing-annotation-for-gather_surplus_pages
+++ a/mm/hugetlb.c
@@ -2010,6 +2010,7 @@ struct page *alloc_huge_page_vma(struct
  * of size 'delta'.
  */
 static int gather_surplus_pages(struct hstate *h, int delta)
+	__must_hold(&hugetlb_lock)
 {
 	struct list_head surplus_list;
 	struct page *page, *tmp;
_

Patches currently in -mm which might be from jbi.octave@gmail.com are

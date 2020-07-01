From: akpm@linux-foundation.org
Subject: + hugetlb-fix-pages-per-hugetlb-calculation.patch added to
 -mm tree
Date: Tue, 30 Jun 2020 17:17:24 -0700
Message-ID: <20200701001724.rJJWa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgGAAR0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 20:17:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@infradead.org, stable@kernel.org, mhocko@kernel.org, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com


The patch titled
     Subject: mm/hugetlb.c: fix pages per hugetlb calculation
has been added to the -mm tree.  Its filename is
     hugetlb-fix-pages-per-hugetlb-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-fix-pages-per-hugetlb-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-fix-pages-per-hugetlb-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb.c: fix pages per hugetlb calculation

The routine hpage_nr_pages() was incorrectly used to calculate the number
of base pages in a hugetlb page.  hpage_nr_pages is designed to be called
for THP pages and will return HPAGE_PMD_NR for hugetlb pages of any size.

Due to the context in which hpage_nr_pages was called, it is unlikely to
produce a user visible error.  The routine with the incorrect call is only
exercised in the case of hugetlb memory error or migration.  In addition,
this would need to be on an architecture which supports huge page sizes
less than PMD_SIZE.  And, the vma containing the huge page would also need
to smaller than PMD_SIZE.

Link: http://lkml.kernel.org/r/20200629185003.97202-1-mike.kravetz@oracle.com
Fixes: c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing synchronization")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-fix-pages-per-hugetlb-calculation
+++ a/mm/hugetlb.c
@@ -1593,7 +1593,7 @@ static struct address_space *_get_hugetl
 
 	/* Use first found vma */
 	pgoff_start = page_to_pgoff(hpage);
-	pgoff_end = pgoff_start + hpage_nr_pages(hpage) - 1;
+	pgoff_end = pgoff_start + pages_per_huge_page(page_hstate(hpage)) - 1;
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
 					pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-fix-pages-per-hugetlb-calculation.patch
hugetlbfs-prevent-filesystem-stacking-of-hugetlbfs.patch

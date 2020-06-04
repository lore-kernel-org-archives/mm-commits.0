From: akpm@linux-foundation.org
Subject: [merged]
 khugepaged-drain-lru-add-pagevec-after-swapin.patch removed from -mm tree
Date: Thu, 04 Jun 2020 10:18:59 -0700
Message-ID: <20200604171859.Z35fKvDdk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730043AbgFDRTA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:19:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com, william.kucharski@oracle.com, yang.shi@linux.alibaba.com, ziy@nvidia.com


The patch titled
     Subject: khugepaged: drain LRU add pagevec after swapin
has been removed from the -mm tree.  Its filename was
     khugepaged-drain-lru-add-pagevec-after-swapin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: khugepaged: drain LRU add pagevec after swapin

collapse_huge_page() tries to swap in pages that are part of the PMD
range.  Just swapped in page goes though LRU add cache.  The cache gets
extra reference on the page.

The extra reference can lead to the collapse fail: the following
__collapse_huge_page_isolate() would check refcount and abort collapse
seeing unexpected refcount.

The fix is to drain local LRU add cache in
__collapse_huge_page_swapin() if we successfully swapped in any pages.

Link: http://lkml.kernel.org/r/20200416160026.16538-5-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/khugepaged.c~khugepaged-drain-lru-add-pagevec-after-swapin
+++ a/mm/khugepaged.c
@@ -931,6 +931,11 @@ static bool __collapse_huge_page_swapin(
 	}
 	vmf.pte--;
 	pte_unmap(vmf.pte);
+
+	/* Drain LRU add pagevec to remove extra pin on the swapped in pages */
+	if (swapped_in)
+		lru_add_drain();
+
 	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 1);
 	return true;
 }
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

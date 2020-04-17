From: akpm@linux-foundation.org
Subject: + khugepaged-drain-lru-add-pagevec-after-swapin.patch
 added to -mm tree
Date: Thu, 16 Apr 2020 21:43:39 -0700
Message-ID: <20200417044339.MAfjRvY-n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgDQEnk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 00:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com, william.kucharski@oracle.com, yang.shi@linux.alibaba.com, ziy@nvidia.com


The patch titled
     Subject: khugepaged: drain LRU add pagevec after swapin
has been added to the -mm tree.  Its filename is
     khugepaged-drain-lru-add-pagevec-after-swapin.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/khugepaged-drain-lru-add-pagevec-after-swapin.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-drain-lru-add-pagevec-after-swapin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: khugepaged: drain LRU add pagevec after swapin

__collapse_huge_page_isolate() may fail due to extra pin in the LRU add
pagevec.  It's pretty common for swapin case: we swap in pages just to
fail due to the extra pin.

Drain LRU add pagevec on successful swapin.

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

khugepaged-add-self-test.patch
khugepaged-do-not-stop-collapse-if-less-than-half-ptes-are-referenced.patch
khugepaged-drain-all-lru-caches-before-scanning-pages.patch
khugepaged-drain-lru-add-pagevec-after-swapin.patch
khugepaged-allow-to-collapse-a-page-shared-across-fork.patch
khugepaged-allow-to-collapse-pte-mapped-compound-pages.patch
thp-change-cow-semantics-for-anon-thp.patch
khugepaged-introduce-max_ptes_shared-tunable.patch

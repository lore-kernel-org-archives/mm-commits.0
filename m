From: akpm@linux-foundation.org
Subject: [merged]
 khugepaged-drain-all-lru-caches-before-scanning-pages.patch removed from
 -mm tree
Date: Thu, 04 Jun 2020 10:18:57 -0700
Message-ID: <20200604171857.L33lzCkPF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730043AbgFDRS7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:18:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com, william.kucharski@oracle.com, yang.shi@linux.alibaba.com, ziy@nvidia.com


The patch titled
     Subject: khugepaged: drain all LRU caches before scanning pages
has been removed from the -mm tree.  Its filename was
     khugepaged-drain-all-lru-caches-before-scanning-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: khugepaged: drain all LRU caches before scanning pages

Having a page in LRU add cache offsets page refcount and gives
false-negative on PageLRU().  It reduces collapse success rate.

Drain all LRU add caches before scanning.  It happens relatively rare and
should not disturb the system too much.

Link: http://lkml.kernel.org/r/20200416160026.16538-4-kirill.shutemov@linux.intel.com
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

 mm/khugepaged.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/khugepaged.c~khugepaged-drain-all-lru-caches-before-scanning-pages
+++ a/mm/khugepaged.c
@@ -2079,6 +2079,8 @@ static void khugepaged_do_scan(void)
 
 	barrier(); /* write khugepaged_pages_to_scan to local stack */
 
+	lru_add_drain_all();
+
 	while (progress < pages) {
 		if (!khugepaged_prealloc_page(&hpage, &wait))
 			break;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

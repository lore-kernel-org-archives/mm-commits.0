From: akpm@linux-foundation.org
Subject: [merged]
 mm-huge_memoryc-use-head-to-check-huge-zero-page.patch removed from -mm
 tree
Date: Fri, 31 Jan 2020 15:18:54 -0800
Message-ID: <20200131231854.ciLqxbxAz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXS4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:18:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com


The patch titled
     Subject: mm/huge_memory.c: use head to check huge zero page
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-use-head-to-check-huge-zero-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/huge_memory.c: use head to check huge zero page

The page could be a tail page, if this is the case, this BUG_ON will never
be triggered.

Link: http://lkml.kernel.org/r/20200110032610.26499-1-richardw.yang@linux.intel.com
Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-use-head-to-check-huge-zero-page
+++ a/mm/huge_memory.c
@@ -2712,7 +2712,7 @@ int split_huge_page_to_list(struct page
 	unsigned long flags;
 	pgoff_t end;
 
-	VM_BUG_ON_PAGE(is_huge_zero_page(page), page);
+	VM_BUG_ON_PAGE(is_huge_zero_page(head), head);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are

From: akpm@linux-foundation.org
Subject: + mm-huge_memoryc-use-head-to-check-huge-zero-page.patch
 added to -mm tree
Date: Fri, 10 Jan 2020 13:20:56 -0800
Message-ID: <20200110212056.jQ25T-zeQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbgAJVU5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jan 2020 16:20:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com


The patch titled
     Subject: mm/huge_memory.c: use head to check huge zero page
has been added to the -mm tree.  Its filename is
     mm-huge_memoryc-use-head-to-check-huge-zero-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memoryc-use-head-to-check-huge-zero-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memoryc-use-head-to-check-huge-zero-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/huge_memory.c: use head to check huge zero page

The page could be a tail page, if this is the case, this BUG_ON will never
be triggered.

Link: http://lkml.kernel.org/r/20200110032610.26499-1-richardw.yang@linux.intel.com
Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
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

mm-thp-grab-the-lock-before-manipulation-defer-list.patch
mm-huge_memoryc-use-head-to-check-huge-zero-page.patch
mm-huge_memoryc-use-head-to-emphasize-the-purpose-of-page.patch
mm-remove-dead-code-totalram_pages_set.patch

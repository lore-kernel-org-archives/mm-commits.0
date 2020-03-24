From: akpm@linux-foundation.org
Subject: + mm-optimise-find_subpage-for-thp.patch added to -mm
 tree
Date: Mon, 23 Mar 2020 19:35:38 -0700
Message-ID: <20200324023538.OmteFw7ST%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgCXCfj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Mar 2020 22:35:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, hch@lst.de, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, willy@infradead.org


The patch titled
     Subject: include/linux/pagemap.h: optimise find_subpage for !THP
has been added to the -mm tree.  Its filename is
     mm-optimise-find_subpage-for-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-optimise-find_subpage-for-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-optimise-find_subpage-for-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: include/linux/pagemap.h: optimise find_subpage for !THP

If THP is disabled, find_subpage() can become a no-op by using
hpage_nr_pages() instead of compound_nr().  hpage_nr_pages() embeds a
check for PageTail, so we can drop the check here.

Link: http://lkml.kernel.org/r/20200318140253.6141-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/pagemap.h~mm-optimise-find_subpage-for-thp
+++ a/include/linux/pagemap.h
@@ -341,9 +341,7 @@ static inline struct page *find_subpage(
 	if (PageHuge(head))
 		return head;
 
-	VM_BUG_ON_PAGE(PageTail(head), head);

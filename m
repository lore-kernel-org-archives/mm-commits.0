From: akpm@linux-foundation.org
Subject: [merged] mm-optimise-find_subpage-for-thp.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 18:57:00 -0700
Message-ID: <20200408015700.G1jXeTPeV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbgDHB5B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, hch@lst.de, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, willy@infradead.org


The patch titled
     Subject: include/linux/pagemap.h: optimise find_subpage for !THP
has been removed from the -mm tree.  Its filename was
     mm-optimise-find_subpage-for-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

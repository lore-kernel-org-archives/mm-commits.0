From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 019/166] include/linux/pagemap.h: optimise
 find_subpage for !THP
Date: Mon, 06 Apr 2020 20:04:31 -0700
Message-ID: <20200407030431.Aua57ze5l%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGDEd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:04:33 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, hch@lst.de, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, torvalds@linux-foundation.org, willy@infradead.org

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

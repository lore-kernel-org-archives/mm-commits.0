From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 034/155] include/linux/pagemap.h: rename arguments
 to find_subpage
Date: Wed, 01 Apr 2020 21:04:57 -0700
Message-ID: <20200402040457.RfNiVsgpt%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEE6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:04:58 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, hch@lst.de, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, torvalds@linux-foundation.org, willy@infradead.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: include/linux/pagemap.h: rename arguments to find_subpage

This isn't just a random struct page, it's known to be a head page, and
calling it head makes the function better self-documenting.  The pgoff_t
is less confusing if it's named index instead of offset.  Also add a
couple of comments to explain why we're doing various things.

Link: http://lkml.kernel.org/r/20200318140253.6141-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/include/linux/pagemap.h~mm-rename-arguments-to-find_subpage
+++ a/include/linux/pagemap.h
@@ -333,14 +333,19 @@ static inline struct page *grab_cache_pa
 			mapping_gfp_mask(mapping));
 }
 
-static inline struct page *find_subpage(struct page *page, pgoff_t offset)
+/*
+ * Given the page we found in the page cache, return the page corresponding
+ * to this index in the file
+ */
+static inline struct page *find_subpage(struct page *head, pgoff_t index)
 {
-	if (PageHuge(page))
-		return page;
+	/* HugeTLBfs wants the head page regardless */
+	if (PageHuge(head))
+		return head;
 
-	VM_BUG_ON_PAGE(PageTail(page), page);
+	VM_BUG_ON_PAGE(PageTail(head), head);
 
-	return page + (offset & (compound_nr(page) - 1));
+	return head + (index & (compound_nr(head) - 1));
 }
 
 struct page *find_get_entry(struct address_space *mapping, pgoff_t offset);
_

From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 035/155] mm/page-writeback.c: use VM_BUG_ON_PAGE
 in clear_page_dirty_for_io
Date: Wed, 01 Apr 2020 21:05:00 -0700
Message-ID: <20200402040500.muLFLSj9h%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEFB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:05:01 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, hch@lst.de, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, torvalds@linux-foundation.org, willy@infradead.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page-writeback.c: use VM_BUG_ON_PAGE in clear_page_dirty_for_io

Dumping the page information in this circumstance helps for debugging.

Link: http://lkml.kernel.org/r/20200318140253.6141-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-use-vm_bug_on_page-in-clear_page_dirty_for_io
+++ a/mm/page-writeback.c
@@ -2655,7 +2655,7 @@ int clear_page_dirty_for_io(struct page
 	struct address_space *mapping = page_mapping(page);
 	int ret = 0;
 
-	BUG_ON(!PageLocked(page));
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
 	if (mapping && mapping_cap_account_dirty(mapping)) {
 		struct inode *inode = mapping->host;
_

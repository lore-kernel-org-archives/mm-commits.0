From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 155/155] include/linux/huge_mm.h: check PageTail
 in hpage_nr_pages even when !THP
Date: Wed, 01 Apr 2020 21:11:58 -0700
Message-ID: <20200402041158.dmswX8bQw%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEL7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:11:59 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, hch@lst.de, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, torvalds@linux-foundation.org, willy@infradead.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: include/linux/huge_mm.h: check PageTail in hpage_nr_pages even when !THP

It's even more important to check that we don't have a tail page when
calling hpage_nr_pages() when THP are disabled.

Link: http://lkml.kernel.org/r/20200318140253.6141-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/huge_mm.h~mm-check-pagetail-in-hpage_nr_pages-even-when-thp
+++ a/include/linux/huge_mm.h
@@ -287,7 +287,11 @@ static inline struct list_head *page_def
 #define HPAGE_PUD_MASK ({ BUILD_BUG(); 0; })
 #define HPAGE_PUD_SIZE ({ BUILD_BUG(); 0; })
 
-#define hpage_nr_pages(x) 1
+static inline int hpage_nr_pages(struct page *page)
+{
+	VM_BUG_ON_PAGE(PageTail(page), page);
+	return 1;
+}
 
 static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
 {
_

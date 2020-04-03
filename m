From: akpm@linux-foundation.org
Subject: [merged]
 mm-check-pagetail-in-hpage_nr_pages-even-when-thp.patch removed from -mm
 tree
Date: Fri, 03 Apr 2020 13:41:10 -0700
Message-ID: <20200403204110.vvIwDafyV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727907AbgDCUlL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:41:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, hch@lst.de, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, willy@infradead.org


The patch titled
     Subject: include/linux/huge_mm.h: check PageTail in hpage_nr_pages even when !THP
has been removed from the -mm tree.  Its filename was
     mm-check-pagetail-in-hpage_nr_pages-even-when-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are

mm-optimise-find_subpage-for-thp.patch
mm-remove-config_transparent_huge_pagecache.patch
proc-inline-vma_stop-into-m_stop.patch
proc-remove-m_cache_vma.patch
proc-use-ppos-instead-of-m-version.patch
seq_file-remove-m-version.patch
proc-inline-m_next_vma-into-m_next.patch

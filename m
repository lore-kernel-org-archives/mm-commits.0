From: akpm@linux-foundation.org
Subject: + mm-add-thp_order.patch added to -mm tree
Date: Tue, 30 Jun 2020 18:39:35 -0700
Message-ID: <20200701013935.B-R7r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgGABjh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 21:39:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ziy@nvidia.com, william.kucharski@oracle.com, mike.kravetz@oracle.com, kirill.shutemov@linux.intel.com, david@redhat.com, willy@infradead.org


The patch titled
     Subject: mm: add thp_order
has been added to the -mm tree.  Its filename is
     mm-add-thp_order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-thp_order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-thp_order.patch

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
Subject: mm: add thp_order

This function returns the order of a transparent huge page.  It compiles
to 0 if CONFIG_TRANSPARENT_HUGEPAGE is disabled.

Link: http://lkml.kernel.org/r/20200629151959.15779-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/include/linux/huge_mm.h~mm-add-thp_order
+++ a/include/linux/huge_mm.h
@@ -258,6 +258,19 @@ static inline spinlock_t *pud_trans_huge
 	else
 		return NULL;
 }
+
+/**
+ * thp_order - Order of a transparent huge page.
+ * @page: Head page of a transparent huge page.
+ */
+static inline unsigned int thp_order(struct page *page)
+{
+	VM_BUG_ON_PGFLAGS(PageTail(page), page);
+	if (PageHead(page))
+		return HPAGE_PMD_ORDER;
+	return 0;
+}
+
 static inline int hpage_nr_pages(struct page *page)
 {
 	if (unlikely(PageTransHuge(page)))
@@ -317,6 +330,12 @@ static inline struct list_head *page_def
 #define HPAGE_PUD_MASK ({ BUILD_BUG(); 0; })
 #define HPAGE_PUD_SIZE ({ BUILD_BUG(); 0; })
 
+static inline unsigned int thp_order(struct page *page)
+{
+	VM_BUG_ON_PGFLAGS(PageTail(page), page);
+	return 0;
+}
+
 static inline int hpage_nr_pages(struct page *page)
 {
 	VM_BUG_ON_PAGE(PageTail(page), page);
_

Patches currently in -mm which might be from willy@infradead.org are

vmalloc-convert-to-xarray.patch
mm-store-compound_nr-as-well-as-compound_order.patch
mm-move-page-flags-include-to-top-of-file.patch
mm-add-thp_order.patch
mm-add-thp_size.patch
mm-replace-hpage_nr_pages-with-thp_nr_pages.patch
mm-add-thp_head.patch
mm-introduce-offset_in_thp.patch

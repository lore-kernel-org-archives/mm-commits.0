From: akpm@linux-foundation.org
Subject: + mm-store-compound_nr-as-well-as-compound_order.patch
 added to -mm tree
Date: Tue, 30 Jun 2020 18:39:29 -0700
Message-ID: <20200701013929.nuuPE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgGABjb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 21:39:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ziy@nvidia.com, william.kucharski@oracle.com, mike.kravetz@oracle.com, kirill.shutemov@linux.intel.com, david@redhat.com, willy@infradead.org


The patch titled
     Subject: mm: store compound_nr as well as compound_order
has been added to the -mm tree.  Its filename is
     mm-store-compound_nr-as-well-as-compound_order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-store-compound_nr-as-well-as-compound_order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-store-compound_nr-as-well-as-compound_order.patch

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
Subject: mm: store compound_nr as well as compound_order

Patch series "THP prep patches".

These are some generic cleanups and improvements, which I would like
merged into mmotm soon.  The first one should be a performance improvement
for all users of compound pages, and the others are aimed at getting code
to compile away when CONFIG_TRANSPARENT_HUGEPAGE is disabled (ie small
systems).  Also better documented / less confusing than the current prefix
mixture of compound, hpage and thp.


This patch (of 7):

This removes a few instructions from functions which need to know how many
pages are in a compound page.  The storage used is either page->mapping on
64-bit or page->index on 32-bit.  Both of these are fine to overlay on
tail pages.

Link: http://lkml.kernel.org/r/20200629151959.15779-1-willy@infradead.org
Link: http://lkml.kernel.org/r/20200629151959.15779-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    5 ++++-
 include/linux/mm_types.h |    1 +
 mm/page_alloc.c          |    5 +++--
 3 files changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-store-compound_nr-as-well-as-compound_order
+++ a/include/linux/mm.h
@@ -913,12 +913,15 @@ static inline int compound_pincount(stru
 static inline void set_compound_order(struct page *page, unsigned int order)
 {
 	page[1].compound_order = order;
+	page[1].compound_nr = 1U << order;
 }
 
 /* Returns the number of pages in this potentially compound page. */
 static inline unsigned long compound_nr(struct page *page)
 {
-	return 1UL << compound_order(page);
+	if (!PageHead(page))
+		return 1;
+	return page[1].compound_nr;
 }
 
 /* Returns the number of bytes in this potentially compound page. */
--- a/include/linux/mm_types.h~mm-store-compound_nr-as-well-as-compound_order
+++ a/include/linux/mm_types.h
@@ -134,6 +134,7 @@ struct page {
 			unsigned char compound_dtor;
 			unsigned char compound_order;
 			atomic_t compound_mapcount;
+			unsigned int compound_nr; /* 1 << compound_order */
 		};
 		struct {	/* Second tail page of compound page */
 			unsigned long _compound_pad_1;	/* compound_head */
--- a/mm/page_alloc.c~mm-store-compound_nr-as-well-as-compound_order
+++ a/mm/page_alloc.c
@@ -668,8 +668,6 @@ void prep_compound_page(struct page *pag
 	int i;
 	int nr_pages = 1 << order;
 
-	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
-	set_compound_order(page, order);
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
@@ -677,6 +675,9 @@ void prep_compound_page(struct page *pag
 		p->mapping = TAIL_MAPPING;
 		set_compound_head(p, page);
 	}
+
+	set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
+	set_compound_order(page, order);
 	atomic_set(compound_mapcount_ptr(page), -1);
 	if (hpage_pincount_available(page))
 		atomic_set(compound_pincount_ptr(page), 0);
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

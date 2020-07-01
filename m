From: akpm@linux-foundation.org
Subject: + mm-introduce-offset_in_thp.patch added to -mm tree
Date: Tue, 30 Jun 2020 18:40:12 -0700
Message-ID: <20200701014012.Ni-zu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgGABkN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 21:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ziy@nvidia.com, william.kucharski@oracle.com, mike.kravetz@oracle.com, kirill.shutemov@linux.intel.com, david@redhat.com, willy@infradead.org


The patch titled
     Subject: mm: introduce offset_in_thp
has been added to the -mm tree.  Its filename is
     mm-introduce-offset_in_thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-offset_in_thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-offset_in_thp.patch

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
Subject: mm: introduce offset_in_thp

Mirroring offset_in_page(), this gives you the offset within this
particular page, no matter what size page it is.  It optimises down to
offset_in_page() if CONFIG_TRANSPARENT_HUGEPAGE is not set.

Link: http://lkml.kernel.org/r/20200629151959.15779-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm.h~mm-introduce-offset_in_thp
+++ a/include/linux/mm.h
@@ -1585,6 +1585,7 @@ static inline void clear_page_pfmemalloc
 extern void pagefault_out_of_memory(void);
 
 #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
+#define offset_in_thp(page, p)	((unsigned long)(p) & (thp_size(page) - 1))
 
 /*
  * Flags passed to show_mem() and show_free_areas() to suppress output in
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

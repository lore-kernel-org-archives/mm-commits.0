From: akpm@linux-foundation.org
Subject: + mm-move-page-flags-include-to-top-of-file.patch added to
 -mm tree
Date: Tue, 30 Jun 2020 18:39:32 -0700
Message-ID: <20200701013932.42GF0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgGABje (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 21:39:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ziy@nvidia.com, william.kucharski@oracle.com, mike.kravetz@oracle.com, kirill.shutemov@linux.intel.com, david@redhat.com, willy@infradead.org


The patch titled
     Subject: mm: move page-flags include to top of file
has been added to the -mm tree.  Its filename is
     mm-move-page-flags-include-to-top-of-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-page-flags-include-to-top-of-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-page-flags-include-to-top-of-file.patch

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
Subject: mm: move page-flags include to top of file

Give up on the notion that we can remove page-flags.h from mm.h.  There
are currently 14 inline functions which use a PageFoo function.  Also, two
of the files directly included by mm.h include page-flags.h themselves,
and there are probably more indirect inclusions.  So just include it at
the top like any other header file.

Link: http://lkml.kernel.org/r/20200629151959.15779-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-move-page-flags-include-to-top-of-file
+++ a/include/linux/mm.h
@@ -24,6 +24,7 @@
 #include <linux/resource.h>
 #include <linux/page_ext.h>
 #include <linux/err.h>
+#include <linux/page-flags.h>
 #include <linux/page_ref.h>
 #include <linux/memremap.h>
 #include <linux/overflow.h>
@@ -669,11 +670,6 @@ int vma_is_stack_for_current(struct vm_a
 struct mmu_gather;
 struct inode;
 
-/*
- * FIXME: take this include out, include page-flags.h in
- * files which need it (119 of them)
- */
-#include <linux/page-flags.h>
 #include <linux/huge_mm.h>
 
 /*
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

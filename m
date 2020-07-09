From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-print-head-flags-in-dump_page.patch added to -mm
 tree
Date: Thu, 09 Jul 2020 16:09:25 -0700
Message-ID: <20200709230925.5wF36K9bD%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgGIXJ0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 19:09:26 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhubbard@nvidia.com, kirill@shutemov.name, mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz, william.kucharski@oracle.com, willy@infradead.org


The patch titled
     Subject: mm/debug: print head flags in dump_page
has been added to the -mm tree.  Its filename is
     mm-print-head-flags-in-dump_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-print-head-flags-in-dump_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-print-head-flags-in-dump_page.patch

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
Subject: mm/debug: print head flags in dump_page

Tail page flags contain very little useful information.  Print the head
page's flags instead.  While the flags will contain "head" for tail pages,
this should not be too confusing as the previous line starts with the word
"head:" and so the flags should be interpreted as belonging to the head
page.

Link: http://lkml.kernel.org/r/20200709202117.7216-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug.c~mm-print-head-flags-in-dump_page
+++ a/mm/debug.c
@@ -162,7 +162,7 @@ void __dump_page(struct page *page, cons
 out_mapping:
 	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS + 1);
 
-	pr_warn("%sflags: %#lx(%pGp)%s\n", type, page->flags, &page->flags,
+	pr_warn("%sflags: %#lx(%pGp)%s\n", type, head->flags, &head->flags,
 		page_cma ? " CMA" : "");
 
 hex_only:
_

Patches currently in -mm which might be from willy@infradead.org are

mm-handle-page-mapping-better-in-dump_page.patch
mm-dump-compound-page-information-on-a-second-line.patch
mm-print-head-flags-in-dump_page.patch
mm-switch-dump_page-to-get_kernel_nofault.patch
mm-print-the-inode-number-in-dump_page.patch
mm-print-hashed-address-of-struct-page.patch
vmalloc-convert-to-xarray.patch
mm-store-compound_nr-as-well-as-compound_order.patch
mm-move-page-flags-include-to-top-of-file.patch
mm-add-thp_order.patch
mm-add-thp_size.patch
mm-replace-hpage_nr_pages-with-thp_nr_pages.patch
mm-add-thp_head.patch
mm-introduce-offset_in_thp.patch

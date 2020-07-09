From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-print-hashed-address-of-struct-page.patch added to
 -mm tree
Date: Thu, 09 Jul 2020 16:09:32 -0700
Message-ID: <20200709230932.txbub8IEQ%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgGIXJe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 19:09:34 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhubbard@nvidia.com, kirill@shutemov.name, mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz, william.kucharski@oracle.com, willy@infradead.org


The patch titled
     Subject: mm/debug: print hashed address of struct page
has been added to the -mm tree.  Its filename is
     mm-print-hashed-address-of-struct-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-print-hashed-address-of-struct-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-print-hashed-address-of-struct-page.patch

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
Subject: mm/debug: print hashed address of struct page

The actual address of the struct page isn't particularly helpful, while
the hashed address helps match with other messages elsewhere.  Add the PFN
that the page refers to in order to help diagnose problems where the page
is improperly aligned for the purpose.

Link: http://lkml.kernel.org/r/20200709202117.7216-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/debug.c~mm-print-hashed-address-of-struct-page
+++ a/mm/debug.c
@@ -89,17 +89,17 @@ void __dump_page(struct page *page, cons
 	 */
 	mapcount = PageSlab(head) ? 0 : page_mapcount(page);
 
-	pr_warn("page:%px refcount:%d mapcount:%d mapping:%p index:%#lx\n",
+	pr_warn("page:%p refcount:%d mapcount:%d mapping:%p index:%#lx pfn:%#lx\n",
 			page, page_ref_count(head), mapcount, mapping,
-			page_to_pgoff(page));
+			page_to_pgoff(page), page_to_pfn(page));
 	if (compound) {
 		if (hpage_pincount_available(page)) {
-			pr_warn("head:%px order:%u compound_mapcount:%d compound_pincount:%d\n",
+			pr_warn("head:%p order:%u compound_mapcount:%d compound_pincount:%d\n",
 					head, compound_order(head),
 					compound_mapcount(head),
 					compound_pincount(head));
 		} else {
-			pr_warn("head:%px order:%u compound_mapcount:%d\n",
+			pr_warn("head:%p order:%u compound_mapcount:%d\n",
 					head, compound_order(head),
 					compound_mapcount(head));
 		}
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

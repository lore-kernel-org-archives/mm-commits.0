From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-dump-compound-page-information-on-a-second-line.patch added to -mm tree
Date: Thu, 09 Jul 2020 16:09:23 -0700
Message-ID: <20200709230923.4UhOw0seP%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgGIXJY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 19:09:24 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhubbard@nvidia.com, kirill@shutemov.name, mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz, william.kucharski@oracle.com, willy@infradead.org


The patch titled
     Subject: mm/debug: dump compound page information on a second line
has been added to the -mm tree.  Its filename is
     mm-dump-compound-page-information-on-a-second-line.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dump-compound-page-information-on-a-second-line.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dump-compound-page-information-on-a-second-line.patch

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
Subject: mm/debug: dump compound page information on a second line

Simplify both the implementation and the output by splitting all the
compound page information onto a second line.

Link: http://lkml.kernel.org/r/20200709202117.7216-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

--- a/mm/debug.c~mm-dump-compound-page-information-on-a-second-line
+++ a/mm/debug.c
@@ -89,27 +89,21 @@ void __dump_page(struct page *page, cons
 	 */
 	mapcount = PageSlab(head) ? 0 : page_mapcount(page);
 
-	if (compound)
+	pr_warn("page:%px refcount:%d mapcount:%d mapping:%p index:%#lx\n",
+			page, page_ref_count(head), mapcount, mapping,
+			page_to_pgoff(page));
+	if (compound) {
 		if (hpage_pincount_available(page)) {
-			pr_warn("page:%px refcount:%d mapcount:%d mapping:%p "
-				"index:%#lx head:%px order:%u "
-				"compound_mapcount:%d compound_pincount:%d\n",
-				page, page_ref_count(head), mapcount,
-				mapping, page_to_pgoff(page), head,
-				compound_order(head), compound_mapcount(page),
-				compound_pincount(page));
+			pr_warn("head:%px order:%u compound_mapcount:%d compound_pincount:%d\n",
+					head, compound_order(head),
+					compound_mapcount(head),
+					compound_pincount(head));
 		} else {
-			pr_warn("page:%px refcount:%d mapcount:%d mapping:%p "
-				"index:%#lx head:%px order:%u "
-				"compound_mapcount:%d\n",
-				page, page_ref_count(head), mapcount,
-				mapping, page_to_pgoff(page), head,
-				compound_order(head), compound_mapcount(page));
+			pr_warn("head:%px order:%u compound_mapcount:%d\n",
+					head, compound_order(head),
+					compound_mapcount(head));
 		}
-	else
-		pr_warn("page:%px refcount:%d mapcount:%d mapping:%p index:%#lx\n",
-			page, page_ref_count(page), mapcount,
-			mapping, page_to_pgoff(page));
+	}
 	if (PageKsm(page))
 		type = "ksm ";
 	else if (PageAnon(page))
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

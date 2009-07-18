From: akpm@linux-foundation.org
Subject: + mm-add-gfp-mask-checking-for-__get_free_pages.patch added to -mm tree
Date: Fri, 17 Jul 2009 17:41:34 -0700
Message-ID: <200907180041.n6I0fY11020004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbZGRAlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jul 2009 20:41:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     mm: add gfp mask checking for __get_free_pages()
has been added to the -mm tree.  Its filename is
     mm-add-gfp-mask-checking-for-__get_free_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add gfp mask checking for __get_free_pages()
From: Akinobu Mita <akinobu.mita@gmail.com>

__get_free_pages() with __GFP_HIGHMEM is not safe because the return
address cannot represent a highmem page.  get_zeroed_page() already has
such a debug checking.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff -puN mm/page_alloc.c~mm-add-gfp-mask-checking-for-__get_free_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-gfp-mask-checking-for-__get_free_pages
+++ a/mm/page_alloc.c
@@ -1916,31 +1916,25 @@ EXPORT_SYMBOL(__alloc_pages_nodemask);
  */
 unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
 {
-	struct page * page;
+	struct page *page;
+
+	/*
+	 * __get_free_pages() returns a 32-bit address, which cannot represent
+	 * a highmem page
+	 */
+	VM_BUG_ON((gfp_mask & __GFP_HIGHMEM) != 0);
+
 	page = alloc_pages(gfp_mask, order);
 	if (!page)
 		return 0;
 	return (unsigned long) page_address(page);
 }
-
 EXPORT_SYMBOL(__get_free_pages);
 
 unsigned long get_zeroed_page(gfp_t gfp_mask)
 {
-	struct page * page;
-
-	/*
-	 * get_zeroed_page() returns a 32-bit address, which cannot represent
-	 * a highmem page
-	 */
-	VM_BUG_ON((gfp_mask & __GFP_HIGHMEM) != 0);
-
-	page = alloc_pages(gfp_mask | __GFP_ZERO, 0);
-	if (page)
-		return (unsigned long) page_address(page);
-	return 0;
+	return __get_free_pages(gfp_mask | __GFP_ZERO, 0);
 }

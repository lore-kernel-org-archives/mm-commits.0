From: akpm@linux-foundation.org
Subject: [merged] page-allocator-remove-dead-function-free_cold_page.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:41:00 -0700
Message-ID: <200909222041.n8MKf0rS006663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614AbZIVUln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:41:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     page-allocator: remove dead function free_cold_page()
has been removed from the -mm tree.  Its filename was
     page-allocator-remove-dead-function-free_cold_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator: remove dead function free_cold_page()
From: Mel Gorman <mel@csn.ul.ie>

The function free_cold_page() has no callers so delete it.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    1 -
 mm/page_alloc.c     |    5 -----
 2 files changed, 6 deletions(-)

diff -puN include/linux/gfp.h~page-allocator-remove-dead-function-free_cold_page include/linux/gfp.h
--- a/include/linux/gfp.h~page-allocator-remove-dead-function-free_cold_page
+++ a/include/linux/gfp.h
@@ -326,7 +326,6 @@ void free_pages_exact(void *virt, size_t
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
 extern void free_hot_page(struct page *page);
-extern void free_cold_page(struct page *page);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr),0)
diff -puN mm/page_alloc.c~page-allocator-remove-dead-function-free_cold_page mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-remove-dead-function-free_cold_page
+++ a/mm/page_alloc.c
@@ -1079,11 +1079,6 @@ void free_hot_page(struct page *page)
 	free_hot_cold_page(page, 0);
 }
 	
-void free_cold_page(struct page *page)
-{
-	free_hot_cold_page(page, 1);
-}

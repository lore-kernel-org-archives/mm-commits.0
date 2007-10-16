From: akpm@linux-foundation.org
Subject: - breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:35:26 -0700
Message-ID: <200710162035.l9GKZQwf015059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34828 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935872AbXJPVgh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:36:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Breakout page_order() to internal.h to avoid special knowledge of the buddy allocator
has been removed from the -mm tree.  Its filename was
     breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Breakout page_order() to internal.h to avoid special knowledge of the buddy allocator
From: Mel Gorman <mel@csn.ul.ie>

The statistics patch later needs to know what order a free page is on the free
lists.  Rather than having special knowledge of page_private() when
PageBuddy() is set, this patch places out page_order() in internal.h and adds
a VM_BUG_ON to catch using it on non-PageBuddy pages.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |   10 ++++++++++
 mm/page_alloc.c |   10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/internal.h~breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator mm/internal.h
--- a/mm/internal.h~breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator
+++ a/mm/internal.h
@@ -37,4 +37,14 @@ static inline void __put_page(struct pag
 extern void fastcall __init __free_pages_bootmem(struct page *page,
 						unsigned int order);
 
+/*
+ * function for dealing with page's order in buddy system.
+ * zone->lock is already acquired when we use these.
+ * So, we don't need atomic page->flags operations here.
+ */
+static inline unsigned long page_order(struct page *page)
+{
+	VM_BUG_ON(!PageBuddy(page));
+	return page_private(page);
+}
 #endif
diff -puN mm/page_alloc.c~breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator mm/page_alloc.c
--- a/mm/page_alloc.c~breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator
+++ a/mm/page_alloc.c
@@ -313,16 +313,6 @@ static inline void prep_zero_page(struct
 		clear_highpage(page + i);
 }
 
-/*
- * function for dealing with page's order in buddy system.
- * zone->lock is already acquired when we use these.
- * So, we don't need atomic page->flags operations here.
- */
-static inline unsigned long page_order(struct page *page)
-{
-	return page_private(page);
-}
-
 static inline void set_page_order(struct page *page, int order)
 {
 	set_page_private(page, order);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

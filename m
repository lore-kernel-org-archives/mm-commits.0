From: akpm@linux-foundation.org
Subject: [patch 048/126] zsmalloc: factor page chain functionality out
Date: Tue, 26 Jul 2016 15:23:20 -0700
Message-ID: <5797e2d8.+2ZWE+dVqk8z4h8p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbcGZWXV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:23:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz

From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: factor page chain functionality out

For page migration, we need to create page chain of zspage dynamically so
this patch factors it out from alloc_zspage.

Link: http://lkml.kernel.org/r/1464736881-24886-8-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   59 ++++++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-factor-page-chain-functionality-out mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-factor-page-chain-functionality-out
+++ a/mm/zsmalloc.c
@@ -960,7 +960,8 @@ static void init_zspage(struct size_clas
 	unsigned long off = 0;
 	struct page *page = first_page;
 
-	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
+	first_page->freelist = NULL;
+	set_zspage_inuse(first_page, 0);
 
 	while (page) {
 		struct page *next_page;
@@ -996,15 +997,16 @@ static void init_zspage(struct size_clas
 		page = next_page;
 		off %= PAGE_SIZE;
 	}
+
+	set_freeobj(first_page, (unsigned long)location_to_obj(first_page, 0));
 }
 
-/*
- * Allocate a zspage for the given size class
- */
-static struct page *alloc_zspage(struct size_class *class, gfp_t flags)
+static void create_page_chain(struct page *pages[], int nr_pages)
 {
-	int i, error;
-	struct page *first_page = NULL, *uninitialized_var(prev_page);
+	int i;
+	struct page *page;
+	struct page *prev_page = NULL;
+	struct page *first_page = NULL;
 
 	/*
 	 * Allocate individual pages and link them together as:
@@ -1017,20 +1019,14 @@ static struct page *alloc_zspage(struct
 	 * (i.e. no other sub-page has this flag set) and PG_private_2 to
 	 * identify the last page.
 	 */
-	error = -ENOMEM;
-	for (i = 0; i < class->pages_per_zspage; i++) {
-		struct page *page;
-
-		page = alloc_page(flags);
-		if (!page)
-			goto cleanup;
+	for (i = 0; i < nr_pages; i++) {
+		page = pages[i];
 
 		INIT_LIST_HEAD(&page->lru);
-		if (i == 0) {	/* first page */
+		if (i == 0) {
 			SetPagePrivate(page);
 			set_page_private(page, 0);
 			first_page = page;
-			set_zspage_inuse(first_page, 0);
 		}
 		if (i == 1)
 			set_page_private(first_page, (unsigned long)page);
@@ -1038,22 +1034,37 @@ static struct page *alloc_zspage(struct
 			set_page_private(page, (unsigned long)first_page);
 		if (i >= 2)
 			list_add(&page->lru, &prev_page->lru);
-		if (i == class->pages_per_zspage - 1)	/* last page */
+		if (i == nr_pages - 1)
 			SetPagePrivate2(page);
 		prev_page = page;
 	}
+}
 
-	init_zspage(class, first_page);
+/*
+ * Allocate a zspage for the given size class
+ */
+static struct page *alloc_zspage(struct size_class *class, gfp_t flags)
+{
+	int i;
+	struct page *first_page = NULL;
+	struct page *pages[ZS_MAX_PAGES_PER_ZSPAGE];
 
-	set_freeobj(first_page,	(unsigned long)location_to_obj(first_page, 0));
-	error = 0; /* Success */
+	for (i = 0; i < class->pages_per_zspage; i++) {
+		struct page *page;
 
-cleanup:
-	if (unlikely(error) && first_page) {
-		free_zspage(first_page);
-		first_page = NULL;
+		page = alloc_page(flags);
+		if (!page) {
+			while (--i >= 0)
+				__free_page(pages[i]);
+			return NULL;
+		}
+		pages[i] = page;
 	}
 
+	create_page_chain(pages, class->pages_per_zspage);
+	first_page = pages[0];
+	init_zspage(class, first_page);
+
 	return first_page;
 }
 
_

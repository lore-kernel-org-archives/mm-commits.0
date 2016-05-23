From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-use-first_page-rather-than-page.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:47:38 -0700
Message-ID: <57435e5a.5+XbB8uaKX+t7mXS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbcEWTrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use first_page rather than page
has been removed from the -mm tree.  Its filename was
     zsmalloc-use-first_page-rather-than-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: use first_page rather than page

Clean up function parameter "struct page".  Many functions of zsmalloc
expect that page paramter is "first_page" so use "first_page" rather than
"page" for code readability.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   62 ++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 30 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-use-first_page-rather-than-page mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-use-first_page-rather-than-page
+++ a/mm/zsmalloc.c
@@ -413,26 +413,28 @@ static int is_last_page(struct page *pag
 	return PagePrivate2(page);
 }
 
-static void get_zspage_mapping(struct page *page, unsigned int *class_idx,
+static void get_zspage_mapping(struct page *first_page,
+				unsigned int *class_idx,
 				enum fullness_group *fullness)
 {
 	unsigned long m;
-	BUG_ON(!is_first_page(page));
+	BUG_ON(!is_first_page(first_page));
 
-	m = (unsigned long)page->mapping;
+	m = (unsigned long)first_page->mapping;
 	*fullness = m & FULLNESS_MASK;
 	*class_idx = (m >> FULLNESS_BITS) & CLASS_IDX_MASK;
 }
 
-static void set_zspage_mapping(struct page *page, unsigned int class_idx,
+static void set_zspage_mapping(struct page *first_page,
+				unsigned int class_idx,
 				enum fullness_group fullness)
 {
 	unsigned long m;
-	BUG_ON(!is_first_page(page));
+	BUG_ON(!is_first_page(first_page));
 
 	m = ((class_idx & CLASS_IDX_MASK) << FULLNESS_BITS) |
 			(fullness & FULLNESS_MASK);
-	page->mapping = (struct address_space *)m;
+	first_page->mapping = (struct address_space *)m;
 }
 
 /*
@@ -625,14 +627,14 @@ static inline void zs_pool_stat_destroy(
  * the pool (not yet implemented). This function returns fullness
  * status of the given page.
  */
-static enum fullness_group get_fullness_group(struct page *page)
+static enum fullness_group get_fullness_group(struct page *first_page)
 {
 	int inuse, max_objects;
 	enum fullness_group fg;
-	BUG_ON(!is_first_page(page));
+	BUG_ON(!is_first_page(first_page));
 
-	inuse = page->inuse;
-	max_objects = page->objects;
+	inuse = first_page->inuse;
+	max_objects = first_page->objects;
 
 	if (inuse == 0)
 		fg = ZS_EMPTY;
@@ -652,12 +654,12 @@ static enum fullness_group get_fullness_
  * have. This functions inserts the given zspage into the freelist
  * identified by <class, fullness_group>.
  */
-static void insert_zspage(struct page *page, struct size_class *class,
+static void insert_zspage(struct page *first_page, struct size_class *class,
 				enum fullness_group fullness)
 {
 	struct page **head;
 
-	BUG_ON(!is_first_page(page));
+	BUG_ON(!is_first_page(first_page));
 
 	if (fullness >= _ZS_NR_FULLNESS_GROUPS)
 		return;
@@ -667,7 +669,7 @@ static void insert_zspage(struct page *p
 
 	head = &class->fullness_list[fullness];
 	if (!*head) {
-		*head = page;
+		*head = first_page;
 		return;
 	}
 
@@ -675,21 +677,21 @@ static void insert_zspage(struct page *p
 	 * We want to see more ZS_FULL pages and less almost
 	 * empty/full. Put pages with higher ->inuse first.
 	 */
-	list_add_tail(&page->lru, &(*head)->lru);
-	if (page->inuse >= (*head)->inuse)
-		*head = page;
+	list_add_tail(&first_page->lru, &(*head)->lru);
+	if (first_page->inuse >= (*head)->inuse)
+		*head = first_page;
 }
 
 /*
  * This function removes the given zspage from the freelist identified
  * by <class, fullness_group>.
  */
-static void remove_zspage(struct page *page, struct size_class *class,
+static void remove_zspage(struct page *first_page, struct size_class *class,
 				enum fullness_group fullness)
 {
 	struct page **head;
 
-	BUG_ON(!is_first_page(page));
+	BUG_ON(!is_first_page(first_page));
 
 	if (fullness >= _ZS_NR_FULLNESS_GROUPS)
 		return;
@@ -698,11 +700,11 @@ static void remove_zspage(struct page *p
 	BUG_ON(!*head);
 	if (list_empty(&(*head)->lru))
 		*head = NULL;
-	else if (*head == page)
+	else if (*head == first_page)
 		*head = (struct page *)list_entry((*head)->lru.next,
 					struct page, lru);
 
-	list_del_init(&page->lru);
+	list_del_init(&first_page->lru);
 	zs_stat_dec(class, fullness == ZS_ALMOST_EMPTY ?
 			CLASS_ALMOST_EMPTY : CLASS_ALMOST_FULL, 1);
 }
@@ -717,21 +719,21 @@ static void remove_zspage(struct page *p
  * fullness group.
  */
 static enum fullness_group fix_fullness_group(struct size_class *class,
-						struct page *page)
+						struct page *first_page)
 {
 	int class_idx;
 	enum fullness_group currfg, newfg;
 
-	BUG_ON(!is_first_page(page));
+	BUG_ON(!is_first_page(first_page));
 
-	get_zspage_mapping(page, &class_idx, &currfg);
-	newfg = get_fullness_group(page);
+	get_zspage_mapping(first_page, &class_idx, &currfg);
+	newfg = get_fullness_group(first_page);
 	if (newfg == currfg)
 		goto out;
 
-	remove_zspage(page, class, currfg);
-	insert_zspage(page, class, newfg);
-	set_zspage_mapping(page, class_idx, newfg);
+	remove_zspage(first_page, class, currfg);
+	insert_zspage(first_page, class, newfg);
+	set_zspage_mapping(first_page, class_idx, newfg);
 
 out:
 	return newfg;
@@ -1234,11 +1236,11 @@ static bool can_merge(struct size_class
 	return true;
 }
 
-static bool zspage_full(struct page *page)
+static bool zspage_full(struct page *first_page)
 {
-	BUG_ON(!is_first_page(page));
+	BUG_ON(!is_first_page(first_page));
 
-	return page->inuse == page->objects;
+	return first_page->inuse == first_page->objects;
 }
 
 unsigned long zs_get_total_pages(struct zs_pool *pool)
_

Patches currently in -mm which might be from minchan@kernel.org are

zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch


From: akpm@linux-foundation.org
Subject: [patch 065/162] zsmalloc: clean up many BUG_ON
Date: Fri, 20 May 2016 16:59:39 -0700
Message-ID: <573fa4eb.mwzkPooKSWn3sLiH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbcETX7k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:59:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, sergey.senozhatsky@gmail.com

From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: clean up many BUG_ON

There are many BUG_ON in zsmalloc.c which is not recommened so
change them as alternatives.

Normal rule is as follows:

1. avoid BUG_ON if possible. Instead, use VM_BUG_ON or VM_BUG_ON_PAGE

2. use VM_BUG_ON_PAGE if we need to see struct page's fields

3. use those assertion in primitive functions so higher functions can
   rely on the assertion in the primitive function.

4. Don't use assertion if following instruction can trigger Oops

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-clean-up-many-bug_on mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-clean-up-many-bug_on
+++ a/mm/zsmalloc.c
@@ -418,7 +418,7 @@ static void get_zspage_mapping(struct pa
 				enum fullness_group *fullness)
 {
 	unsigned long m;
-	BUG_ON(!is_first_page(first_page));
+	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
 	m = (unsigned long)first_page->mapping;
 	*fullness = m & FULLNESS_MASK;
@@ -430,7 +430,7 @@ static void set_zspage_mapping(struct pa
 				enum fullness_group fullness)
 {
 	unsigned long m;
-	BUG_ON(!is_first_page(first_page));
+	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
 	m = ((class_idx & CLASS_IDX_MASK) << FULLNESS_BITS) |
 			(fullness & FULLNESS_MASK);
@@ -631,7 +631,8 @@ static enum fullness_group get_fullness_
 {
 	int inuse, max_objects;
 	enum fullness_group fg;
-	BUG_ON(!is_first_page(first_page));
+
+	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
 	inuse = first_page->inuse;
 	max_objects = first_page->objects;
@@ -659,7 +660,7 @@ static void insert_zspage(struct page *f
 {
 	struct page **head;
 
-	BUG_ON(!is_first_page(first_page));
+	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
 	if (fullness >= _ZS_NR_FULLNESS_GROUPS)
 		return;
@@ -691,13 +692,13 @@ static void remove_zspage(struct page *f
 {
 	struct page **head;
 
-	BUG_ON(!is_first_page(first_page));
+	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
 	if (fullness >= _ZS_NR_FULLNESS_GROUPS)
 		return;
 
 	head = &class->fullness_list[fullness];
-	BUG_ON(!*head);
+	VM_BUG_ON_PAGE(!*head, first_page);
 	if (list_empty(&(*head)->lru))
 		*head = NULL;
 	else if (*head == first_page)
@@ -724,8 +725,6 @@ static enum fullness_group fix_fullness_
 	int class_idx;
 	enum fullness_group currfg, newfg;
 
-	BUG_ON(!is_first_page(first_page));
-
 	get_zspage_mapping(first_page, &class_idx, &currfg);
 	newfg = get_fullness_group(first_page);
 	if (newfg == currfg)
@@ -811,7 +810,7 @@ static void *location_to_obj(struct page
 	unsigned long obj;
 
 	if (!page) {
-		BUG_ON(obj_idx);
+		VM_BUG_ON(obj_idx);
 		return NULL;
 	}
 
@@ -844,7 +843,7 @@ static unsigned long obj_to_head(struct
 			void *obj)
 {
 	if (class->huge) {
-		VM_BUG_ON(!is_first_page(page));
+		VM_BUG_ON_PAGE(!is_first_page(page), page);
 		return page_private(page);
 	} else
 		return *(unsigned long *)obj;
@@ -894,8 +893,8 @@ static void free_zspage(struct page *fir
 {
 	struct page *nextp, *tmp, *head_extra;
 
-	BUG_ON(!is_first_page(first_page));
-	BUG_ON(first_page->inuse);
+	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
+	VM_BUG_ON_PAGE(first_page->inuse, first_page);
 
 	head_extra = (struct page *)page_private(first_page);
 
@@ -921,7 +920,8 @@ static void init_zspage(struct page *fir
 	unsigned long off = 0;
 	struct page *page = first_page;
 
-	BUG_ON(!is_first_page(first_page));
+	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
+
 	while (page) {
 		struct page *next_page;
 		struct link_free *link;
@@ -1238,7 +1238,7 @@ static bool can_merge(struct size_class
 
 static bool zspage_full(struct page *first_page)
 {
-	BUG_ON(!is_first_page(first_page));
+	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
 	return first_page->inuse == first_page->objects;
 }
@@ -1276,14 +1276,12 @@ void *zs_map_object(struct zs_pool *pool
 	struct page *pages[2];
 	void *ret;
 
-	BUG_ON(!handle);
-
 	/*
 	 * Because we use per-cpu mapping areas shared among the
 	 * pools/users, we can't allow mapping in interrupt context
 	 * because it can corrupt another users mappings.
 	 */
-	BUG_ON(in_interrupt());
+	WARN_ON_ONCE(in_interrupt());
 
 	/* From now on, migration cannot move the object */
 	pin_tag(handle);
@@ -1327,8 +1325,6 @@ void zs_unmap_object(struct zs_pool *poo
 	struct size_class *class;
 	struct mapping_area *area;
 
-	BUG_ON(!handle);
-
 	obj = handle_to_obj(handle);
 	obj_to_location(obj, &page, &obj_idx);
 	get_zspage_mapping(get_first_page(page), &class_idx, &fg);
@@ -1448,8 +1444,6 @@ static void obj_free(struct zs_pool *poo
 	unsigned long f_objidx, f_offset;
 	void *vaddr;
 
-	BUG_ON(!obj);
-
 	obj &= ~OBJ_ALLOCATED_TAG;
 	obj_to_location(obj, &f_page, &f_objidx);
 	first_page = get_first_page(f_page);
@@ -1549,7 +1543,6 @@ static void zs_object_copy(unsigned long
 			kunmap_atomic(d_addr);
 			kunmap_atomic(s_addr);
 			s_page = get_next_page(s_page);
-			BUG_ON(!s_page);
 			s_addr = kmap_atomic(s_page);
 			d_addr = kmap_atomic(d_page);
 			s_size = class->size - written;
@@ -1559,7 +1552,6 @@ static void zs_object_copy(unsigned long
 		if (d_off >= PAGE_SIZE) {
 			kunmap_atomic(d_addr);
 			d_page = get_next_page(d_page);
-			BUG_ON(!d_page);
 			d_addr = kmap_atomic(d_page);
 			d_size = class->size - written;
 			d_off = 0;
@@ -1694,8 +1686,6 @@ static enum fullness_group putback_zspag
 {
 	enum fullness_group fullness;
 
-	BUG_ON(!is_first_page(first_page));
-
 	fullness = get_fullness_group(first_page);
 	insert_zspage(first_page, class, fullness);
 	set_zspage_mapping(first_page, class->index, fullness);
@@ -1759,8 +1749,6 @@ static void __zs_compact(struct zs_pool
 	spin_lock(&class->lock);
 	while ((src_page = isolate_source_page(class))) {
 
-		BUG_ON(!is_first_page(src_page));

From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-use-accessor.patch removed from -mm tree
Date: Wed, 27 Jul 2016 12:00:28 -0700
Message-ID: <579904cc.QLOdp/XVuLMpaJ5P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042AbcG0TA3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:00:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use accessor
has been removed from the -mm tree.  Its filename was
     zsmalloc-use-accessor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: use accessor

Upcoming patch will change how to encode zspage meta so for easy review,
this patch wraps code to access metadata as accessor.

Link: http://lkml.kernel.org/r/1464736881-24886-7-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   82 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 60 insertions(+), 22 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-use-accessor mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-use-accessor
+++ a/mm/zsmalloc.c
@@ -268,10 +268,14 @@ struct zs_pool {
  * A zspage's class index and fullness group
  * are encoded in its (first)page->mapping
  */
-#define CLASS_IDX_BITS	28
 #define FULLNESS_BITS	4
-#define CLASS_IDX_MASK	((1 << CLASS_IDX_BITS) - 1)
-#define FULLNESS_MASK	((1 << FULLNESS_BITS) - 1)
+#define CLASS_BITS	28
+
+#define FULLNESS_SHIFT	0
+#define CLASS_SHIFT	(FULLNESS_SHIFT + FULLNESS_BITS)
+
+#define FULLNESS_MASK	((1UL << FULLNESS_BITS) - 1)
+#define CLASS_MASK	((1UL << CLASS_BITS) - 1)
 
 struct mapping_area {
 #ifdef CONFIG_PGTABLE_MAPPING
@@ -418,6 +422,41 @@ static int is_last_page(struct page *pag
 	return PagePrivate2(page);
 }
 
+static inline int get_zspage_inuse(struct page *first_page)
+{
+	return first_page->inuse;
+}
+
+static inline void set_zspage_inuse(struct page *first_page, int val)
+{
+	first_page->inuse = val;
+}
+
+static inline void mod_zspage_inuse(struct page *first_page, int val)
+{
+	first_page->inuse += val;
+}
+
+static inline int get_first_obj_offset(struct page *page)
+{
+	return page->index;
+}
+
+static inline void set_first_obj_offset(struct page *page, int offset)
+{
+	page->index = offset;
+}
+
+static inline unsigned long get_freeobj(struct page *first_page)
+{
+	return (unsigned long)first_page->freelist;
+}
+
+static inline void set_freeobj(struct page *first_page, unsigned long obj)
+{
+	first_page->freelist = (void *)obj;
+}
+
 static void get_zspage_mapping(struct page *first_page,
 				unsigned int *class_idx,
 				enum fullness_group *fullness)
@@ -426,8 +465,8 @@ static void get_zspage_mapping(struct pa
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
 	m = (unsigned long)first_page->mapping;
-	*fullness = m & FULLNESS_MASK;
-	*class_idx = (m >> FULLNESS_BITS) & CLASS_IDX_MASK;
+	*fullness = (m >> FULLNESS_SHIFT) & FULLNESS_MASK;
+	*class_idx = (m >> CLASS_SHIFT) & CLASS_MASK;
 }
 
 static void set_zspage_mapping(struct page *first_page,
@@ -437,8 +476,7 @@ static void set_zspage_mapping(struct pa
 	unsigned long m;
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
-	m = ((class_idx & CLASS_IDX_MASK) << FULLNESS_BITS) |
-			(fullness & FULLNESS_MASK);
+	m = (class_idx << CLASS_SHIFT) | (fullness << FULLNESS_SHIFT);
 	first_page->mapping = (struct address_space *)m;
 }
 
@@ -638,7 +676,7 @@ static enum fullness_group get_fullness_
 
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
-	inuse = first_page->inuse;
+	inuse = get_zspage_inuse(first_page);
 	objs_per_zspage = class->objs_per_zspage;
 
 	if (inuse == 0)
@@ -684,7 +722,7 @@ static void insert_zspage(struct size_cl
 	 * empty/full. Put pages with higher ->inuse first.
 	 */
 	list_add_tail(&first_page->lru, &(*head)->lru);
-	if (first_page->inuse >= (*head)->inuse)
+	if (get_zspage_inuse(first_page) >= get_zspage_inuse(*head))
 		*head = first_page;
 }
 
@@ -861,7 +899,7 @@ static unsigned long obj_idx_to_offset(s
 	unsigned long off = 0;
 
 	if (!is_first_page(page))
-		off = page->index;
+		off = get_first_obj_offset(page);
 
 	return off + obj_idx * class_size;
 }
@@ -896,7 +934,7 @@ static void free_zspage(struct page *fir
 	struct page *nextp, *tmp, *head_extra;
 
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
-	VM_BUG_ON_PAGE(first_page->inuse, first_page);
+	VM_BUG_ON_PAGE(get_zspage_inuse(first_page), first_page);
 
 	head_extra = (struct page *)page_private(first_page);
 
@@ -937,7 +975,7 @@ static void init_zspage(struct size_clas
 		 * head of corresponding zspage's freelist.
 		 */
 		if (page != first_page)
-			page->index = off;
+			set_first_obj_offset(page, off);
 
 		vaddr = kmap_atomic(page);
 		link = (struct link_free *)vaddr + off / sizeof(*link);
@@ -992,7 +1030,7 @@ static struct page *alloc_zspage(struct
 			SetPagePrivate(page);
 			set_page_private(page, 0);
 			first_page = page;
-			first_page->inuse = 0;
+			set_zspage_inuse(first_page, 0);
 		}
 		if (i == 1)
 			set_page_private(first_page, (unsigned long)page);
@@ -1007,7 +1045,7 @@ static struct page *alloc_zspage(struct
 
 	init_zspage(class, first_page);
 
-	first_page->freelist = location_to_obj(first_page, 0);
+	set_freeobj(first_page,	(unsigned long)location_to_obj(first_page, 0));
 	error = 0; /* Success */
 
 cleanup:
@@ -1239,7 +1277,7 @@ static bool zspage_full(struct size_clas
 {
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 
-	return first_page->inuse == class->objs_per_zspage;
+	return get_zspage_inuse(first_page) == class->objs_per_zspage;
 }
 
 unsigned long zs_get_total_pages(struct zs_pool *pool)
@@ -1358,13 +1396,13 @@ static unsigned long obj_malloc(struct s
 	void *vaddr;
 
 	handle |= OBJ_ALLOCATED_TAG;
-	obj = (unsigned long)first_page->freelist;
+	obj = get_freeobj(first_page);
 	obj_to_location(obj, &m_page, &m_objidx);
 	m_offset = obj_idx_to_offset(m_page, m_objidx, class->size);
 
 	vaddr = kmap_atomic(m_page);
 	link = (struct link_free *)vaddr + m_offset / sizeof(*link);
-	first_page->freelist = link->next;
+	set_freeobj(first_page, (unsigned long)link->next);
 	if (!class->huge)
 		/* record handle in the header of allocated chunk */
 		link->handle = handle;
@@ -1372,7 +1410,7 @@ static unsigned long obj_malloc(struct s
 		/* record handle in first_page->private */
 		set_page_private(first_page, handle);
 	kunmap_atomic(vaddr);
-	first_page->inuse++;
+	mod_zspage_inuse(first_page, 1);
 	zs_stat_inc(class, OBJ_USED, 1);
 
 	return obj;
@@ -1452,12 +1490,12 @@ static void obj_free(struct size_class *
 
 	/* Insert this object in containing zspage's freelist */
 	link = (struct link_free *)(vaddr + f_offset);
-	link->next = first_page->freelist;
+	link->next = (void *)get_freeobj(first_page);
 	if (class->huge)
 		set_page_private(first_page, 0);
 	kunmap_atomic(vaddr);
-	first_page->freelist = (void *)obj;
-	first_page->inuse--;
+	set_freeobj(first_page, obj);
+	mod_zspage_inuse(first_page, -1);
 	zs_stat_dec(class, OBJ_USED, 1);
 }
 
@@ -1573,7 +1611,7 @@ static unsigned long find_alloced_obj(st
 	void *addr = kmap_atomic(page);
 
 	if (!is_first_page(page))
-		offset = page->index;
+		offset = get_first_obj_offset(page);
 	offset += class->size * index;
 
 	while (offset < PAGE_SIZE) {
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-page_alloc-fix-dirtyable-highmem-calculation.patch
mm-show-node_pages_scanned-per-node-not-zone.patch
mm-show-node_pages_scanned-per-node-not-zone-fix.patch
mm-add-per-zone-lru-list-stat.patch
mm-bail-out-in-shrin_inactive_list.patch


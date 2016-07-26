From: akpm@linux-foundation.org
Subject: [patch 051/126] zsmalloc: use freeobj for index
Date: Tue, 26 Jul 2016 15:23:28 -0700
Message-ID: <5797e2e0.NtMsryxsMu+lguyD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbcGZWXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:23:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz

From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: use freeobj for index

Zsmalloc stores first free object's <PFN, obj_idx> position into freeobj
in each zspage.  If we change it with index from first_page instead of
position, it makes page migration simple because we don't need to correct
other entries for linked list if a page is migrated out.

Link: http://lkml.kernel.org/r/1464736881-24886-11-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |  139 +++++++++++++++++++++++++-----------------------
 1 file changed, 73 insertions(+), 66 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-use-freeobj-for-index mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-use-freeobj-for-index
+++ a/mm/zsmalloc.c
@@ -71,9 +71,7 @@
  * Object location (<PFN>, <obj_idx>) is encoded as
  * as single (unsigned long) handle value.
  *
- * Note that object index <obj_idx> is relative to system
- * page <PFN> it is stored in, so for each sub-page belonging
- * to a zspage, obj_idx starts with 0.
+ * Note that object index <obj_idx> starts from 0.
  *
  * This is made more complicated by various memory models and PAE.
  */
@@ -214,10 +212,10 @@ struct size_class {
 struct link_free {
 	union {
 		/*
-		 * Position of next free chunk (encodes <PFN, obj_idx>)
+		 * Free object index;
 		 * It's valid for non-allocated object
 		 */
-		void *next;
+		unsigned long next;
 		/*
 		 * Handle of allocated object.
 		 */
@@ -261,7 +259,7 @@ struct zspage {
 		unsigned int class:CLASS_BITS;
 	};
 	unsigned int inuse;
-	void *freeobj;
+	unsigned int freeobj;
 	struct page *first_page;
 	struct list_head list; /* fullness list */
 };
@@ -459,14 +457,14 @@ static inline void set_first_obj_offset(
 	page->index = offset;
 }
 
-static inline unsigned long get_freeobj(struct zspage *zspage)
+static inline unsigned int get_freeobj(struct zspage *zspage)
 {
-	return (unsigned long)zspage->freeobj;
+	return zspage->freeobj;
 }
 
-static inline void set_freeobj(struct zspage *zspage, unsigned long obj)
+static inline void set_freeobj(struct zspage *zspage, unsigned int obj)
 {
-	zspage->freeobj = (void *)obj;
+	zspage->freeobj = obj;
 }
 
 static void get_zspage_mapping(struct zspage *zspage,
@@ -810,6 +808,10 @@ static int get_pages_per_zspage(int clas
 	return max_usedpc_order;
 }
 
+static struct page *get_first_page(struct zspage *zspage)
+{
+	return zspage->first_page;
+}
 
 static struct zspage *get_zspage(struct page *page)
 {
@@ -821,37 +823,33 @@ static struct page *get_next_page(struct
 	return page->next;
 }
 
-/*
- * Encode <page, obj_idx> as a single handle value.
- * We use the least bit of handle for tagging.
+/**
+ * obj_to_location - get (<page>, <obj_idx>) from encoded object value
+ * @page: page object resides in zspage
+ * @obj_idx: object index
  */
-static void *location_to_obj(struct page *page, unsigned long obj_idx)
+static void obj_to_location(unsigned long obj, struct page **page,
+				unsigned int *obj_idx)
 {
-	unsigned long obj;
+	obj >>= OBJ_TAG_BITS;
+	*page = pfn_to_page(obj >> OBJ_INDEX_BITS);
+	*obj_idx = (obj & OBJ_INDEX_MASK);
+}
 
-	if (!page) {
-		VM_BUG_ON(obj_idx);
-		return NULL;
-	}
+/**
+ * location_to_obj - get obj value encoded from (<page>, <obj_idx>)
+ * @page: page object resides in zspage
+ * @obj_idx: object index
+ */
+static unsigned long location_to_obj(struct page *page, unsigned int obj_idx)
+{
+	unsigned long obj;
 
 	obj = page_to_pfn(page) << OBJ_INDEX_BITS;
-	obj |= ((obj_idx) & OBJ_INDEX_MASK);
+	obj |= obj_idx & OBJ_INDEX_MASK;
 	obj <<= OBJ_TAG_BITS;
 
-	return (void *)obj;
-}
-
-/*
- * Decode <page, obj_idx> pair from the given object handle. We adjust the
- * decoded obj_idx back to its original value since it was adjusted in
- * location_to_obj().
- */
-static void obj_to_location(unsigned long obj, struct page **page,
-				unsigned long *obj_idx)
-{
-	obj >>= OBJ_TAG_BITS;
-	*page = pfn_to_page(obj >> OBJ_INDEX_BITS);
-	*obj_idx = (obj & OBJ_INDEX_MASK);
+	return obj;
 }
 
 static unsigned long handle_to_obj(unsigned long handle)
@@ -869,16 +867,6 @@ static unsigned long obj_to_head(struct
 		return *(unsigned long *)obj;
 }
 
-static unsigned long obj_idx_to_offset(struct page *page,
-				unsigned long obj_idx, int class_size)
-{
-	unsigned long off;
-
-	off = get_first_obj_offset(page);
-
-	return off + obj_idx * class_size;
-}
-
 static inline int trypin_tag(unsigned long handle)
 {
 	return bit_spin_trylock(HANDLE_PIN_BIT, (unsigned long *)handle);
@@ -922,13 +910,13 @@ static void free_zspage(struct zs_pool *
 /* Initialize a newly allocated zspage */
 static void init_zspage(struct size_class *class, struct zspage *zspage)
 {
+	unsigned int freeobj = 1;
 	unsigned long off = 0;
 	struct page *page = zspage->first_page;
 
 	while (page) {
 		struct page *next_page;
 		struct link_free *link;
-		unsigned int i = 1;
 		void *vaddr;
 
 		set_first_obj_offset(page, off);
@@ -937,7 +925,7 @@ static void init_zspage(struct size_clas
 		link = (struct link_free *)vaddr + off / sizeof(*link);
 
 		while ((off += class->size) < PAGE_SIZE) {
-			link->next = location_to_obj(page, i++);
+			link->next = freeobj++ << OBJ_ALLOCATED_TAG;
 			link += class->size / sizeof(*link);
 		}
 
@@ -947,14 +935,21 @@ static void init_zspage(struct size_clas
 		 * page (if present)
 		 */
 		next_page = get_next_page(page);
-		link->next = location_to_obj(next_page, 0);
+		if (next_page) {
+			link->next = freeobj++ << OBJ_ALLOCATED_TAG;
+		} else {
+			/*
+			 * Reset OBJ_ALLOCATED_TAG bit to last link to tell
+			 * whether it's allocated object or not.
+			 */
+			link->next = -1 << OBJ_ALLOCATED_TAG;
+		}
 		kunmap_atomic(vaddr);
 		page = next_page;
 		off %= PAGE_SIZE;
 	}
 
-	set_freeobj(zspage,
-		(unsigned long)location_to_obj(zspage->first_page, 0));
+	set_freeobj(zspage, 0);
 }
 
 static void create_page_chain(struct zspage *zspage, struct page *pages[],
@@ -1271,7 +1266,8 @@ void *zs_map_object(struct zs_pool *pool
 {
 	struct zspage *zspage;
 	struct page *page;
-	unsigned long obj, obj_idx, off;
+	unsigned long obj, off;
+	unsigned int obj_idx;
 
 	unsigned int class_idx;
 	enum fullness_group fg;
@@ -1295,7 +1291,7 @@ void *zs_map_object(struct zs_pool *pool
 	zspage = get_zspage(page);
 	get_zspage_mapping(zspage, &class_idx, &fg);
 	class = pool->size_class[class_idx];
-	off = obj_idx_to_offset(page, obj_idx, class->size);
+	off = (class->size * obj_idx) & ~PAGE_MASK;
 
 	area = &get_cpu_var(zs_map_area);
 	area->vm_mm = mm;
@@ -1324,7 +1320,8 @@ void zs_unmap_object(struct zs_pool *poo
 {
 	struct zspage *zspage;
 	struct page *page;
-	unsigned long obj, obj_idx, off;
+	unsigned long obj, off;
+	unsigned int obj_idx;
 
 	unsigned int class_idx;
 	enum fullness_group fg;
@@ -1336,7 +1333,7 @@ void zs_unmap_object(struct zs_pool *poo
 	zspage = get_zspage(page);
 	get_zspage_mapping(zspage, &class_idx, &fg);
 	class = pool->size_class[class_idx];
-	off = obj_idx_to_offset(page, obj_idx, class->size);
+	off = (class->size * obj_idx) & ~PAGE_MASK;
 
 	area = this_cpu_ptr(&zs_map_area);
 	if (off + class->size <= PAGE_SIZE)
@@ -1358,21 +1355,28 @@ EXPORT_SYMBOL_GPL(zs_unmap_object);
 static unsigned long obj_malloc(struct size_class *class,
 				struct zspage *zspage, unsigned long handle)
 {
+	int i, nr_page, offset;
 	unsigned long obj;
 	struct link_free *link;
 
 	struct page *m_page;
-	unsigned long m_objidx, m_offset;
+	unsigned long m_offset;
 	void *vaddr;
 
 	handle |= OBJ_ALLOCATED_TAG;
 	obj = get_freeobj(zspage);
-	obj_to_location(obj, &m_page, &m_objidx);
-	m_offset = obj_idx_to_offset(m_page, m_objidx, class->size);
+
+	offset = obj * class->size;
+	nr_page = offset >> PAGE_SHIFT;
+	m_offset = offset & ~PAGE_MASK;
+	m_page = get_first_page(zspage);
+
+	for (i = 0; i < nr_page; i++)
+		m_page = get_next_page(m_page);
 
 	vaddr = kmap_atomic(m_page);
 	link = (struct link_free *)vaddr + m_offset / sizeof(*link);
-	set_freeobj(zspage, (unsigned long)link->next);
+	set_freeobj(zspage, link->next >> OBJ_ALLOCATED_TAG);
 	if (!class->huge)
 		/* record handle in the header of allocated chunk */
 		link->handle = handle;
@@ -1384,6 +1388,8 @@ static unsigned long obj_malloc(struct s
 	mod_zspage_inuse(zspage, 1);
 	zs_stat_inc(class, OBJ_USED, 1);
 
+	obj = location_to_obj(m_page, obj);
+
 	return obj;
 }
 
@@ -1449,22 +1455,22 @@ static void obj_free(struct size_class *
 	struct link_free *link;
 	struct zspage *zspage;
 	struct page *f_page;
-	unsigned long f_objidx, f_offset;
+	unsigned long f_offset;
+	unsigned int f_objidx;
 	void *vaddr;
 
 	obj &= ~OBJ_ALLOCATED_TAG;
 	obj_to_location(obj, &f_page, &f_objidx);
+	f_offset = (class->size * f_objidx) & ~PAGE_MASK;
 	zspage = get_zspage(f_page);
 
-	f_offset = obj_idx_to_offset(f_page, f_objidx, class->size);
-
 	vaddr = kmap_atomic(f_page);
 
 	/* Insert this object in containing zspage's freelist */
 	link = (struct link_free *)(vaddr + f_offset);
-	link->next = (void *)get_freeobj(zspage);
+	link->next = get_freeobj(zspage) << OBJ_ALLOCATED_TAG;
 	kunmap_atomic(vaddr);
-	set_freeobj(zspage, obj);
+	set_freeobj(zspage, f_objidx);
 	mod_zspage_inuse(zspage, -1);
 	zs_stat_dec(class, OBJ_USED, 1);
 }
@@ -1473,7 +1479,8 @@ void zs_free(struct zs_pool *pool, unsig
 {
 	struct zspage *zspage;
 	struct page *f_page;
-	unsigned long obj, f_objidx;
+	unsigned long obj;
+	unsigned int f_objidx;
 	int class_idx;
 	struct size_class *class;
 	enum fullness_group fullness;
@@ -1510,7 +1517,7 @@ static void zs_object_copy(struct size_c
 				unsigned long src)
 {
 	struct page *s_page, *d_page;
-	unsigned long s_objidx, d_objidx;
+	unsigned int s_objidx, d_objidx;
 	unsigned long s_off, d_off;
 	void *s_addr, *d_addr;
 	int s_size, d_size, size;
@@ -1521,8 +1528,8 @@ static void zs_object_copy(struct size_c
 	obj_to_location(src, &s_page, &s_objidx);
 	obj_to_location(dst, &d_page, &d_objidx);
 
-	s_off = obj_idx_to_offset(s_page, s_objidx, class->size);
-	d_off = obj_idx_to_offset(d_page, d_objidx, class->size);
+	s_off = (class->size * s_objidx) & ~PAGE_MASK;
+	d_off = (class->size * d_objidx) & ~PAGE_MASK;
 
 	if (s_off + class->size > PAGE_SIZE)
 		s_size = PAGE_SIZE - s_off;
_

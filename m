From: akpm@linux-foundation.org
Subject: + zsmalloc-decouple-handle-and-object.patch added to -mm tree
Date: Wed, 04 Mar 2015 14:02:28 -0800
Message-ID: <54f780f4.g+7bDrHTQs2Cnaju%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbCDWCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 17:02:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ddstreet@ieee.org, gunho.lee@lge.com, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, juno.choi@lge.com, mel@csn.ul.ie, ngupta@vflare.org, semenzato@google.com, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: decouple handle and object
has been added to the -mm tree.  Its filename is
     zsmalloc-decouple-handle-and-object.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-decouple-handle-and-object.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-decouple-handle-and-object.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: decouple handle and object

Recently, we started to use zram heavily and some of issues
popped.

1) external fragmentation

I got a report from Juneho Choi that fork failed although there are plenty
of free pages in the system.  His investigation revealed zram is one of
the culprit to make heavy fragmentation so there was no more contiguous
16K page for pgd to fork in the ARM.

2) non-movable pages

Other problem of zram now is that inherently, user want to use zram as
swap in small memory system so they use zRAM with CMA to use memory
efficiently.  However, unfortunately, it doesn't work well because zRAM
cannot use CMA's movable pages unless it doesn't support compaction.  I
got several reports about that OOM happened with zram although there are
lots of swap space and free space in CMA area.

3) internal fragmentation

zRAM has started support memory limitation feature to limit memory usage
and I sent a patchset(https://lkml.org/lkml/2014/9/21/148) for VM to be
harmonized with zram-swap to stop anonymous page reclaim if zram consumed
memory up to the limit although there are free space on the swap.  One
problem for that direction is zram has no way to know any hole in memory
space zsmalloc allocated by internal fragmentation so zram would regard
swap is full although there are free space in zsmalloc.  For solving the
issue, zram want to trigger compaction of zsmalloc before it decides full
or not.

This patchset is first step to support above issues.  For that, it adds
indirect layer between handle and object location and supports manual
compaction to solve 3th problem first of all.

After this patchset got merged, next step is to make VM aware of zsmalloc
compaction so that generic compaction will move zsmalloced-pages
automatically in runtime.

In my imaginary experiment(ie, high compress ratio data with heavy swap
in/out on 8G zram-swap), data is as follows,

Before =
zram allocated object :      60212066 bytes
zram total used:     140103680 bytes
ratio:         42.98 percent
MemFree:          840192 kB

Compaction

After =
frag ratio after compaction
zram allocated object :      60212066 bytes
zram total used:      76185600 bytes
ratio:         79.03 percent
MemFree:          901932 kB

Juneho reported below in his real platform with small aging.
So, I think the benefit would be bigger in real aging system
for a long time.

- frag_ratio increased 3% (ie, higher is better)
- memfree increased about 6MB
- In buddy info, Normal 2^3: 4, 2^2: 1: 2^1 increased, Highmem: 2^1 21 increased

frag ratio after swap fragment
used :        156677 kbytes
total:        166092 kbytes
frag_ratio :  94
meminfo before compaction
MemFree:           83724 kB
Node 0, zone   Normal  13642   1364     57     10     61     17      9      5      4      0      0 
Node 0, zone  HighMem    425     29      1      0      0      0      0      0      0      0      0 

num_migrated :  23630
compaction done

frag ratio after compaction
used :        156673 kbytes
total:        160564 kbytes
frag_ratio :  97
meminfo after compaction
MemFree:           89060 kB
Node 0, zone   Normal  14076   1544     67     14     61     17      9      5      4      0      0 
Node 0, zone  HighMem    863     50      1      0      0      0      0      0      0      0      0 

This patchset adds more logics(about 480 lines) in zsmalloc but when I
tested heavy swapin/out program, the regression for swapin/out speed is
marginal because most of overheads were caused by compress/decompress and
other MM reclaim stuff.  


This patch (of 7):

Currently, handle of zsmalloc encodes object's location directly so it
makes support of migration hard.

This patch decouples handle and object via adding indirect layer.  For
that, it allocates handle dynamically and returns it to user.  The handle
is the address allocated by slab allocation so it's unique and we could
keep object's location in the memory space allocated for handle.

With it, we can change object's position without changing handle itself.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Juneho Choi <juno.choi@lge.com>
Cc: Gunho Lee <gunho.lee@lge.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |  126 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 98 insertions(+), 28 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-decouple-handle-and-object mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-decouple-handle-and-object
+++ a/mm/zsmalloc.c
@@ -110,6 +110,8 @@
 #define ZS_MAX_ZSPAGE_ORDER 2
 #define ZS_MAX_PAGES_PER_ZSPAGE (_AC(1, UL) << ZS_MAX_ZSPAGE_ORDER)
 
+#define ZS_HANDLE_SIZE (sizeof(unsigned long))
+
 /*
  * Object location (<PFN>, <obj_idx>) is encoded as
  * as single (unsigned long) handle value.
@@ -140,7 +142,8 @@
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
 	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
-#define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
+/* each chunk includes extra space to keep handle */
+#define ZS_MAX_ALLOC_SIZE	(PAGE_SIZE + ZS_HANDLE_SIZE)
 
 /*
  * On systems with 4K page size, this gives 255 size classes! There is a
@@ -233,14 +236,24 @@ struct size_class {
  * This must be power of 2 and less than or equal to ZS_ALIGN
  */
 struct link_free {
-	/* Handle of next free chunk (encodes <PFN, obj_idx>) */
-	void *next;
+	union {
+		/*
+		 * Position of next free chunk (encodes <PFN, obj_idx>)
+		 * It's valid for non-allocated object
+		 */
+		void *next;
+		/*
+		 * Handle of allocated object.
+		 */
+		unsigned long handle;
+	};
 };
 
 struct zs_pool {
 	char *name;
 
 	struct size_class **size_class;
+	struct kmem_cache *handle_cachep;
 
 	gfp_t flags;	/* allocation flags used when growing pool */
 	atomic_long_t pages_allocated;
@@ -269,6 +282,34 @@ struct mapping_area {
 	enum zs_mapmode vm_mm; /* mapping mode */
 };
 
+static int create_handle_cache(struct zs_pool *pool)
+{
+	pool->handle_cachep = kmem_cache_create("zs_handle", ZS_HANDLE_SIZE,
+					0, 0, NULL);
+	return pool->handle_cachep ? 0 : 1;
+}
+
+static void destroy_handle_cache(struct zs_pool *pool)
+{
+	kmem_cache_destroy(pool->handle_cachep);
+}
+
+static unsigned long alloc_handle(struct zs_pool *pool)
+{
+	return (unsigned long)kmem_cache_alloc(pool->handle_cachep,
+		pool->flags & ~__GFP_HIGHMEM);
+}
+
+static void free_handle(struct zs_pool *pool, unsigned long handle)
+{
+	kmem_cache_free(pool->handle_cachep, (void *)handle);
+}
+
+static void record_obj(unsigned long handle, unsigned long obj)
+{
+	*(unsigned long *)handle = obj;
+}
+
 /* zpool driver */
 
 #ifdef CONFIG_ZPOOL
@@ -595,13 +636,18 @@ static void *obj_location_to_handle(stru
  * decoded obj_idx back to its original value since it was adjusted in
  * obj_location_to_handle().
  */
-static void obj_handle_to_location(unsigned long handle, struct page **page,
+static void obj_to_location(unsigned long handle, struct page **page,
 				unsigned long *obj_idx)
 {
 	*page = pfn_to_page(handle >> OBJ_INDEX_BITS);
 	*obj_idx = (handle & OBJ_INDEX_MASK) - 1;
 }
 
+static unsigned long handle_to_obj(unsigned long handle)
+{
+	return *(unsigned long *)handle;
+}
+
 static unsigned long obj_idx_to_offset(struct page *page,
 				unsigned long obj_idx, int class_size)
 {
@@ -860,12 +906,16 @@ static void __zs_unmap_object(struct map
 {
 	int sizes[2];
 	void *addr;
-	char *buf = area->vm_buf;
+	char *buf;
 
 	/* no write fastpath */
 	if (area->vm_mm == ZS_MM_RO)
 		goto out;
 
+	buf = area->vm_buf + ZS_HANDLE_SIZE;
+	size -= ZS_HANDLE_SIZE;
+	off += ZS_HANDLE_SIZE;
+
 	sizes[0] = PAGE_SIZE - off;
 	sizes[1] = size - sizes[0];
 
@@ -1153,13 +1203,14 @@ void *zs_map_object(struct zs_pool *pool
 			enum zs_mapmode mm)
 {
 	struct page *page;
-	unsigned long obj_idx, off;
+	unsigned long obj, obj_idx, off;
 
 	unsigned int class_idx;
 	enum fullness_group fg;
 	struct size_class *class;
 	struct mapping_area *area;
 	struct page *pages[2];
+	void *ret;
 
 	BUG_ON(!handle);
 
@@ -1170,7 +1221,8 @@ void *zs_map_object(struct zs_pool *pool
 	 */
 	BUG_ON(in_interrupt());
 
-	obj_handle_to_location(handle, &page, &obj_idx);
+	obj = handle_to_obj(handle);
+	obj_to_location(obj, &page, &obj_idx);
 	get_zspage_mapping(get_first_page(page), &class_idx, &fg);
 	class = pool->size_class[class_idx];
 	off = obj_idx_to_offset(page, obj_idx, class->size);
@@ -1180,7 +1232,8 @@ void *zs_map_object(struct zs_pool *pool
 	if (off + class->size <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
 		area->vm_addr = kmap_atomic(page);
-		return area->vm_addr + off;
+		ret = area->vm_addr + off;
+		goto out;
 	}
 
 	/* this object spans two pages */
@@ -1188,14 +1241,16 @@ void *zs_map_object(struct zs_pool *pool
 	pages[1] = get_next_page(page);
 	BUG_ON(!pages[1]);
 
-	return __zs_map_object(area, pages, off, class->size);
+	ret = __zs_map_object(area, pages, off, class->size);
+out:
+	return ret + ZS_HANDLE_SIZE;
 }
 EXPORT_SYMBOL_GPL(zs_map_object);
 
 void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
 {
 	struct page *page;
-	unsigned long obj_idx, off;
+	unsigned long obj, obj_idx, off;
 
 	unsigned int class_idx;
 	enum fullness_group fg;
@@ -1204,7 +1259,8 @@ void zs_unmap_object(struct zs_pool *poo
 
 	BUG_ON(!handle);
 
-	obj_handle_to_location(handle, &page, &obj_idx);
+	obj = handle_to_obj(handle);
+	obj_to_location(obj, &page, &obj_idx);
 	get_zspage_mapping(get_first_page(page), &class_idx, &fg);
 	class = pool->size_class[class_idx];
 	off = obj_idx_to_offset(page, obj_idx, class->size);
@@ -1236,7 +1292,7 @@ EXPORT_SYMBOL_GPL(zs_unmap_object);
  */
 unsigned long zs_malloc(struct zs_pool *pool, size_t size)
 {
-	unsigned long obj;
+	unsigned long handle, obj;
 	struct link_free *link;
 	struct size_class *class;
 	void *vaddr;
@@ -1244,9 +1300,15 @@ unsigned long zs_malloc(struct zs_pool *
 	struct page *first_page, *m_page;
 	unsigned long m_objidx, m_offset;
 
-	if (unlikely(!size || size > ZS_MAX_ALLOC_SIZE))
+	if (unlikely(!size || (size + ZS_HANDLE_SIZE) > ZS_MAX_ALLOC_SIZE))
+		return 0;
+
+	handle = alloc_handle(pool);
+	if (!handle)
 		return 0;
 
+	/* extra space in chunk to keep the handle */
+	size += ZS_HANDLE_SIZE;
 	class = pool->size_class[get_size_class_index(size)];
 
 	spin_lock(&class->lock);
@@ -1255,8 +1317,10 @@ unsigned long zs_malloc(struct zs_pool *
 	if (!first_page) {
 		spin_unlock(&class->lock);
 		first_page = alloc_zspage(class, pool->flags);
-		if (unlikely(!first_page))
+		if (unlikely(!first_page)) {
+			free_handle(pool, handle);
 			return 0;
+		}
 
 		set_zspage_mapping(first_page, class->index, ZS_EMPTY);
 		atomic_long_add(class->pages_per_zspage,
@@ -1268,40 +1332,45 @@ unsigned long zs_malloc(struct zs_pool *
 	}
 
 	obj = (unsigned long)first_page->freelist;
-	obj_handle_to_location(obj, &m_page, &m_objidx);
+	obj_to_location(obj, &m_page, &m_objidx);
 	m_offset = obj_idx_to_offset(m_page, m_objidx, class->size);
 
 	vaddr = kmap_atomic(m_page);
 	link = (struct link_free *)vaddr + m_offset / sizeof(*link);
 	first_page->freelist = link->next;
-	memset(link, POISON_INUSE, sizeof(*link));
+
+	/* record handle in the header of allocated chunk */
+	link->handle = handle;
 	kunmap_atomic(vaddr);
 
 	first_page->inuse++;
 	zs_stat_inc(class, OBJ_USED, 1);
 	/* Now move the zspage to another fullness group, if required */
 	fix_fullness_group(pool, first_page);
+	record_obj(handle, obj);
 	spin_unlock(&class->lock);
 
-	return obj;
+	return handle;
 }
 EXPORT_SYMBOL_GPL(zs_malloc);
 
-void zs_free(struct zs_pool *pool, unsigned long obj)
+void zs_free(struct zs_pool *pool, unsigned long handle)
 {
 	struct link_free *link;
 	struct page *first_page, *f_page;
-	unsigned long f_objidx, f_offset;
+	unsigned long obj, f_objidx, f_offset;
 	void *vaddr;
 
 	int class_idx;
 	struct size_class *class;
 	enum fullness_group fullness;
 
-	if (unlikely(!obj))
+	if (unlikely(!handle))
 		return;
 
-	obj_handle_to_location(obj, &f_page, &f_objidx);
+	obj = handle_to_obj(handle);
+	free_handle(pool, handle);
+	obj_to_location(obj, &f_page, &f_objidx);
 	first_page = get_first_page(f_page);
 
 	get_zspage_mapping(first_page, &class_idx, &fullness);
@@ -1355,20 +1424,20 @@ struct zs_pool *zs_create_pool(char *nam
 	if (!pool)
 		return NULL;
 
-	pool->name = kstrdup(name, GFP_KERNEL);
-	if (!pool->name) {
-		kfree(pool);
-		return NULL;
-	}
-
 	pool->size_class = kcalloc(zs_size_classes, sizeof(struct size_class *),
 			GFP_KERNEL);
 	if (!pool->size_class) {
-		kfree(pool->name);
 		kfree(pool);
 		return NULL;
 	}
 
+	pool->name = kstrdup(name, GFP_KERNEL);
+	if (!pool->name)
+		goto err;
+
+	if (create_handle_cache(pool))
+		goto err;
+
 	/*
 	 * Iterate reversly, because, size of size_class that we want to use
 	 * for merging should be larger or equal to current size.
@@ -1450,6 +1519,7 @@ void zs_destroy_pool(struct zs_pool *poo
 		kfree(class);
 	}
 
+	destroy_handle_cache(pool);
 	kfree(pool->size_class);
 	kfree(pool->name);
 	kfree(pool);
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zsmalloc-decouple-handle-and-object.patch
zsmalloc-factor-out-obj_.patch
zsmalloc-support-compaction.patch
zsmalloc-adjust-zs_almost_full.patch
zram-support-compaction.patch
zsmalloc-record-handle-in-page-private-for-huge-object.patch
zsmalloc-add-fullness-into-stat.patch


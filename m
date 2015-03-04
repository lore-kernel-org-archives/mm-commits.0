From: akpm@linux-foundation.org
Subject: + zsmalloc-record-handle-in-page-private-for-huge-object.patch
 added to -mm tree
Date: Wed, 04 Mar 2015 14:02:38 -0800
Message-ID: <54f780fe.GTj9JfF1WsEJzj01%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbbCDWCj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 17:02:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ddstreet@ieee.org, gunho.lee@lge.com, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, juno.choi@lge.com, mel@csn.ul.ie, ngupta@vflare.org, semenzato@google.com, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: record handle in page->private for huge object
has been added to the -mm tree.  Its filename is
     zsmalloc-record-handle-in-page-private-for-huge-object.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-record-handle-in-page-private-for-huge-object.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-record-handle-in-page-private-for-huge-object.patch

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
Subject: zsmalloc: record handle in page->private for huge object

We store handle on header of each allocated object so it increases the
size of each object by sizeof(unsigned long).

If zram stores 4096 bytes to zsmalloc(ie, bad compression), zsmalloc needs
4104B-class to add handle.

However, 4104B-class has 1-pages_per_zspage so wasted size by internal
fragment is 8192 - 4104, which is terrible.

So this patch records the handle in page->private on such huge object(ie,
pages_per_zspage == 1 && maxobj_per_zspage == 1) instead of header of each
object so we could use 4096B-class, not 4104B-class.

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

 mm/zsmalloc.c |   54 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-record-handle-in-page-private-for-huge-object mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-record-handle-in-page-private-for-huge-object
+++ a/mm/zsmalloc.c
@@ -57,6 +57,8 @@
  *
  *	page->private (union with page->first_page): refers to the
  *		component page after the first page
+ *		If the page is first_page for huge object, it stores handle.
+ *		Look at size_class->huge.
  *	page->freelist: points to the first free object in zspage.
  *		Free objects are linked together using in-place
  *		metadata.
@@ -162,7 +164,7 @@
 #define ZS_MIN_ALLOC_SIZE \
 	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
 /* each chunk includes extra space to keep handle */
-#define ZS_MAX_ALLOC_SIZE	(PAGE_SIZE + ZS_HANDLE_SIZE)
+#define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
 
 /*
  * On systems with 4K page size, this gives 255 size classes! There is a
@@ -238,6 +240,8 @@ struct size_class {
 
 	/* Number of PAGE_SIZE sized pages to combine to form a 'zspage' */
 	int pages_per_zspage;
+	/* huge object: pages_per_zspage == 1 && maxobj_per_zspage == 1 */
+	bool huge;
 
 #ifdef CONFIG_ZSMALLOC_STAT
 	struct zs_size_stat stats;
@@ -299,6 +303,7 @@ struct mapping_area {
 #endif
 	char *vm_addr; /* address of kmap_atomic()'ed pages */
 	enum zs_mapmode vm_mm; /* mapping mode */
+	bool huge;
 };
 
 static int create_handle_cache(struct zs_pool *pool)
@@ -456,7 +461,7 @@ static int get_size_class_index(int size
 		idx = DIV_ROUND_UP(size - ZS_MIN_ALLOC_SIZE,
 				ZS_SIZE_CLASS_DELTA);
 
-	return idx;
+	return min(zs_size_classes - 1, idx);
 }
 
 /*
@@ -665,9 +670,14 @@ static unsigned long handle_to_obj(unsig
 	return *(unsigned long *)handle;
 }
 
-unsigned long obj_to_head(void *obj)
+static unsigned long obj_to_head(struct size_class *class, struct page *page,
+			void *obj)
 {
-	return *(unsigned long *)obj;
+	if (class->huge) {
+		VM_BUG_ON(!is_first_page(page));
+		return *(unsigned long *)page_private(page);
+	} else
+		return *(unsigned long *)obj;
 }
 
 static unsigned long obj_idx_to_offset(struct page *page,
@@ -953,9 +963,12 @@ static void __zs_unmap_object(struct map
 	if (area->vm_mm == ZS_MM_RO)
 		goto out;
 
-	buf = area->vm_buf + ZS_HANDLE_SIZE;
-	size -= ZS_HANDLE_SIZE;
-	off += ZS_HANDLE_SIZE;
+	buf = area->vm_buf;
+	if (!area->huge) {
+		buf = buf + ZS_HANDLE_SIZE;
+		size -= ZS_HANDLE_SIZE;
+		off += ZS_HANDLE_SIZE;
+	}
 
 	sizes[0] = PAGE_SIZE - off;
 	sizes[1] = size - sizes[0];
@@ -1294,7 +1307,10 @@ void *zs_map_object(struct zs_pool *pool
 
 	ret = __zs_map_object(area, pages, off, class->size);
 out:
-	return ret + ZS_HANDLE_SIZE;
+	if (!class->huge)
+		ret += ZS_HANDLE_SIZE;
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(zs_map_object);
 
@@ -1351,8 +1367,12 @@ static unsigned long obj_malloc(struct p
 	vaddr = kmap_atomic(m_page);
 	link = (struct link_free *)vaddr + m_offset / sizeof(*link);
 	first_page->freelist = link->next;
-	/* record handle in the header of allocated chunk */
-	link->handle = handle;
+	if (!class->huge)
+		/* record handle in the header of allocated chunk */
+		link->handle = handle;
+	else
+		/* record handle in first_page->private */
+		set_page_private(first_page, handle);
 	kunmap_atomic(vaddr);
 	first_page->inuse++;
 	zs_stat_inc(class, OBJ_USED, 1);
@@ -1376,7 +1396,7 @@ unsigned long zs_malloc(struct zs_pool *
 	struct size_class *class;
 	struct page *first_page;
 
-	if (unlikely(!size || (size + ZS_HANDLE_SIZE) > ZS_MAX_ALLOC_SIZE))
+	if (unlikely(!size || size > ZS_MAX_ALLOC_SIZE))
 		return 0;
 
 	handle = alloc_handle(pool);
@@ -1386,6 +1406,11 @@ unsigned long zs_malloc(struct zs_pool *
 	/* extra space in chunk to keep the handle */
 	size += ZS_HANDLE_SIZE;
 	class = pool->size_class[get_size_class_index(size)];
+	/* In huge class size, we store the handle into first_page->private */
+	if (class->huge) {
+		size -= ZS_HANDLE_SIZE;
+		class = pool->size_class[get_size_class_index(size)];
+	}
 
 	spin_lock(&class->lock);
 	first_page = find_get_zspage(class);
@@ -1441,6 +1466,8 @@ static void obj_free(struct zs_pool *poo
 	/* Insert this object in containing zspage's freelist */
 	link = (struct link_free *)(vaddr + f_offset);
 	link->next = first_page->freelist;
+	if (class->huge)
+		set_page_private(first_page, 0);
 	kunmap_atomic(vaddr);
 	first_page->freelist = (void *)obj;
 	first_page->inuse--;
@@ -1566,7 +1593,7 @@ static unsigned long find_alloced_obj(st
 	offset += class->size * index;
 
 	while (offset < PAGE_SIZE) {
-		head = obj_to_head(addr + offset);
+		head = obj_to_head(class, page, addr + offset);
 		if (head & OBJ_ALLOCATED_TAG) {
 			handle = head & ~OBJ_ALLOCATED_TAG;
 			if (trypin_tag(handle))
@@ -1836,6 +1863,9 @@ struct zs_pool *zs_create_pool(char *nam
 		class->size = size;
 		class->index = i;
 		class->pages_per_zspage = pages_per_zspage;
+		if (pages_per_zspage == 1 &&
+			get_maxobj_per_zspage(size, pages_per_zspage) == 1)
+			class->huge = true;
 		spin_lock_init(&class->lock);
 		pool->size_class[i] = class;
 
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


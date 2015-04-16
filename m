From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-factor-out-obj_.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:53:21 -0700
Message-ID: <552fe901.fzdZN1dFACGw47wn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbbDPQrx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ddstreet@ieee.org, gunho.lee@lge.com, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, juno.choi@lge.com, mel@csn.ul.ie, ngupta@vflare.org, semenzato@google.com, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: factor out obj_[malloc|free]
has been removed from the -mm tree.  Its filename was
     zsmalloc-factor-out-obj_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: factor out obj_[malloc|free]

In later patch, migration needs some part of functions in zs_malloc and
zs_free so this patch factor out them.

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

 mm/zsmalloc.c |   98 +++++++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 38 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-factor-out-obj_ mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-factor-out-obj_
+++ a/mm/zsmalloc.c
@@ -525,11 +525,10 @@ static void remove_zspage(struct page *p
  * page from the freelist of the old fullness group to that of the new
  * fullness group.
  */
-static enum fullness_group fix_fullness_group(struct zs_pool *pool,
+static enum fullness_group fix_fullness_group(struct size_class *class,
 						struct page *page)
 {
 	int class_idx;
-	struct size_class *class;
 	enum fullness_group currfg, newfg;
 
 	BUG_ON(!is_first_page(page));
@@ -539,7 +538,6 @@ static enum fullness_group fix_fullness_
 	if (newfg == currfg)
 		goto out;
 
-	class = pool->size_class[class_idx];
 	remove_zspage(page, class, currfg);
 	insert_zspage(page, class, newfg);
 	set_zspage_mapping(page, class_idx, newfg);
@@ -1281,6 +1279,33 @@ void zs_unmap_object(struct zs_pool *poo
 }
 EXPORT_SYMBOL_GPL(zs_unmap_object);
 
+static unsigned long obj_malloc(struct page *first_page,
+		struct size_class *class, unsigned long handle)
+{
+	unsigned long obj;
+	struct link_free *link;
+
+	struct page *m_page;
+	unsigned long m_objidx, m_offset;
+	void *vaddr;
+
+	obj = (unsigned long)first_page->freelist;
+	obj_to_location(obj, &m_page, &m_objidx);
+	m_offset = obj_idx_to_offset(m_page, m_objidx, class->size);
+
+	vaddr = kmap_atomic(m_page);
+	link = (struct link_free *)vaddr + m_offset / sizeof(*link);
+	first_page->freelist = link->next;
+	/* record handle in the header of allocated chunk */
+	link->handle = handle;
+	kunmap_atomic(vaddr);
+	first_page->inuse++;
+	zs_stat_inc(class, OBJ_USED, 1);
+
+	return obj;
+}
+
+
 /**
  * zs_malloc - Allocate block of given size from pool.
  * @pool: pool to allocate from
@@ -1293,12 +1318,8 @@ EXPORT_SYMBOL_GPL(zs_unmap_object);
 unsigned long zs_malloc(struct zs_pool *pool, size_t size)
 {
 	unsigned long handle, obj;
-	struct link_free *link;
 	struct size_class *class;
-	void *vaddr;
-
-	struct page *first_page, *m_page;
-	unsigned long m_objidx, m_offset;
+	struct page *first_page;
 
 	if (unlikely(!size || (size + ZS_HANDLE_SIZE) > ZS_MAX_ALLOC_SIZE))
 		return 0;
@@ -1331,22 +1352,9 @@ unsigned long zs_malloc(struct zs_pool *
 				class->size, class->pages_per_zspage));
 	}
 
-	obj = (unsigned long)first_page->freelist;
-	obj_to_location(obj, &m_page, &m_objidx);
-	m_offset = obj_idx_to_offset(m_page, m_objidx, class->size);
-
-	vaddr = kmap_atomic(m_page);
-	link = (struct link_free *)vaddr + m_offset / sizeof(*link);
-	first_page->freelist = link->next;
-
-	/* record handle in the header of allocated chunk */
-	link->handle = handle;
-	kunmap_atomic(vaddr);
-
-	first_page->inuse++;
-	zs_stat_inc(class, OBJ_USED, 1);
+	obj = obj_malloc(first_page, class, handle);
 	/* Now move the zspage to another fullness group, if required */
-	fix_fullness_group(pool, first_page);
+	fix_fullness_group(class, first_page);
 	record_obj(handle, obj);
 	spin_unlock(&class->lock);
 
@@ -1354,46 +1362,60 @@ unsigned long zs_malloc(struct zs_pool *
 }
 EXPORT_SYMBOL_GPL(zs_malloc);
 
-void zs_free(struct zs_pool *pool, unsigned long handle)
+static void obj_free(struct zs_pool *pool, struct size_class *class,
+			unsigned long obj)
 {
 	struct link_free *link;
 	struct page *first_page, *f_page;
-	unsigned long obj, f_objidx, f_offset;
+	unsigned long f_objidx, f_offset;
 	void *vaddr;
-
 	int class_idx;
-	struct size_class *class;
 	enum fullness_group fullness;
 
-	if (unlikely(!handle))
-		return;
+	BUG_ON(!obj);
 
-	obj = handle_to_obj(handle);
-	free_handle(pool, handle);
 	obj_to_location(obj, &f_page, &f_objidx);
 	first_page = get_first_page(f_page);
 
 	get_zspage_mapping(first_page, &class_idx, &fullness);
-	class = pool->size_class[class_idx];
 	f_offset = obj_idx_to_offset(f_page, f_objidx, class->size);
 
-	spin_lock(&class->lock);
+	vaddr = kmap_atomic(f_page);
 
 	/* Insert this object in containing zspage's freelist */
-	vaddr = kmap_atomic(f_page);
 	link = (struct link_free *)(vaddr + f_offset);
 	link->next = first_page->freelist;
 	kunmap_atomic(vaddr);
 	first_page->freelist = (void *)obj;
-
 	first_page->inuse--;
-	fullness = fix_fullness_group(pool, first_page);
-
 	zs_stat_dec(class, OBJ_USED, 1);
+}
+
+void zs_free(struct zs_pool *pool, unsigned long handle)
+{
+	struct page *first_page, *f_page;
+	unsigned long obj, f_objidx;
+	int class_idx;
+	struct size_class *class;
+	enum fullness_group fullness;
+
+	if (unlikely(!handle))
+		return;
+
+	obj = handle_to_obj(handle);
+	free_handle(pool, handle);
+	obj_to_location(obj, &f_page, &f_objidx);
+	first_page = get_first_page(f_page);
+
+	get_zspage_mapping(first_page, &class_idx, &fullness);
+	class = pool->size_class[class_idx];
+
+	spin_lock(&class->lock);
+	obj_free(pool, class, obj);
+	fullness = fix_fullness_group(class, first_page);
 	if (fullness == ZS_EMPTY)
 		zs_stat_dec(class, OBJ_ALLOCATED, get_maxobj_per_zspage(
 				class->size, class->pages_per_zspage));
-
 	spin_unlock(&class->lock);
 
 	if (fullness == ZS_EMPTY) {
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch


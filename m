From: akpm@linux-foundation.org
Subject: +
 mm-balloon_compaction-remove-balloon-mapping-and-flag-as_balloon_map.patch
 added to -mm tree
Date: Wed, 01 Oct 2014 15:22:08 -0700
Message-ID: <542c7e90.gXMhR9JS8g9dda9b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaJAWWJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 18:22:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.khlebnikov@samsung.com, aquini@redhat.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/balloon_compaction: remove balloon mapping and flag AS_BALLOON_MAP
has been added to the -mm tree.  Its filename is
     mm-balloon_compaction-remove-balloon-mapping-and-flag-as_balloon_map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-balloon_compaction-remove-balloon-mapping-and-flag-as_balloon_map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-balloon_compaction-remove-balloon-mapping-and-flag-as_balloon_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Subject: mm/balloon_compaction: remove balloon mapping and flag AS_BALLOON_MAP

Now ballooned pages are detected using PageBalloon().  Fake mapping is no
longer required.  This patch links ballooned pages to balloon device using
field page->private instead of page->mapping.  Also this patch embeds
balloon_dev_info directly into struct virtio_balloon.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c    |   60 +++--------------
 include/linux/balloon_compaction.h |   72 +++++---------------
 include/linux/pagemap.h            |   18 -----
 mm/balloon_compaction.c            |   95 +--------------------------
 4 files changed, 39 insertions(+), 206 deletions(-)

diff -puN drivers/virtio/virtio_balloon.c~mm-balloon_compaction-remove-balloon-mapping-and-flag-as_balloon_map drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~mm-balloon_compaction-remove-balloon-mapping-and-flag-as_balloon_map
+++ a/drivers/virtio/virtio_balloon.c
@@ -59,7 +59,7 @@ struct virtio_balloon
 	 * Each page on this list adds VIRTIO_BALLOON_PAGES_PER_PAGE
 	 * to num_pages above.
 	 */
-	struct balloon_dev_info *vb_dev_info;
+	struct balloon_dev_info vb_dev_info;
 
 	/* Synchronize access/update to this struct virtio_balloon elements */
 	struct mutex balloon_lock;
@@ -127,7 +127,7 @@ static void set_page_pfns(u32 pfns[], st
 
 static void fill_balloon(struct virtio_balloon *vb, size_t num)
 {
-	struct balloon_dev_info *vb_dev_info = vb->vb_dev_info;
+	struct balloon_dev_info *vb_dev_info = &vb->vb_dev_info;
 
 	/* We can only do one array worth at a time. */
 	num = min(num, ARRAY_SIZE(vb->pfns));
@@ -171,7 +171,7 @@ static void release_pages_by_pfn(const u
 static void leak_balloon(struct virtio_balloon *vb, size_t num)
 {
 	struct page *page;
-	struct balloon_dev_info *vb_dev_info = vb->vb_dev_info;
+	struct balloon_dev_info *vb_dev_info = &vb->vb_dev_info;
 
 	/* We can only do one array worth at a time. */
 	num = min(num, ARRAY_SIZE(vb->pfns));
@@ -353,12 +353,11 @@ static int init_vqs(struct virtio_balloo
 	return 0;
 }
 
-static const struct address_space_operations virtio_balloon_aops;
 #ifdef CONFIG_BALLOON_COMPACTION
 /*
  * virtballoon_migratepage - perform the balloon page migration on behalf of
  *			     a compation thread.     (called under page lock)
- * @mapping: the page->mapping which will be assigned to the new migrated page.
+ * @vb_dev_info: the balloon device
  * @newpage: page that will replace the isolated page after migration finishes.
  * @page   : the isolated (old) page that is about to be migrated to newpage.
  * @mode   : compaction mode -- not used for balloon page migration.
@@ -373,17 +372,13 @@ static const struct address_space_operat
  * This function preforms the balloon page migration task.
  * Called through balloon_mapping->a_ops->migratepage
  */
-static int virtballoon_migratepage(struct address_space *mapping,
+static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
 		struct page *newpage, struct page *page, enum migrate_mode mode)
 {
-	struct balloon_dev_info *vb_dev_info = balloon_page_device(page);
-	struct virtio_balloon *vb;
+	struct virtio_balloon *vb = container_of(vb_dev_info,
+			struct virtio_balloon, vb_dev_info);
 	unsigned long flags;
 
-	BUG_ON(!vb_dev_info);
-
-	vb = vb_dev_info->balloon_device;
-
 	/*
 	 * In order to avoid lock contention while migrating pages concurrently
 	 * to leak_balloon() or fill_balloon() we just give up the balloon_lock
@@ -399,7 +394,7 @@ static int virtballoon_migratepage(struc
 
 	/* balloon's page migration 1st step  -- inflate "newpage" */
 	spin_lock_irqsave(&vb_dev_info->pages_lock, flags);
-	balloon_page_insert(newpage, mapping, &vb_dev_info->pages);
+	balloon_page_insert(vb_dev_info, newpage);
 	vb_dev_info->isolated_pages--;
 	spin_unlock_irqrestore(&vb_dev_info->pages_lock, flags);
 	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
@@ -418,18 +413,11 @@ static int virtballoon_migratepage(struc
 
 	return MIGRATEPAGE_SUCCESS;
 }
-
-/* define the balloon_mapping->a_ops callback to allow balloon page migration */
-static const struct address_space_operations virtio_balloon_aops = {
-			.migratepage = virtballoon_migratepage,
-};
 #endif /* CONFIG_BALLOON_COMPACTION */
 
 static int virtballoon_probe(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb;
-	struct address_space *vb_mapping;
-	struct balloon_dev_info *vb_devinfo;
 	int err;
 
 	vdev->priv = vb = kmalloc(sizeof(*vb), GFP_KERNEL);
@@ -445,30 +433,14 @@ static int virtballoon_probe(struct virt
 	vb->vdev = vdev;
 	vb->need_stats_update = 0;
 
-	vb_devinfo = balloon_devinfo_alloc(vb);
-	if (IS_ERR(vb_devinfo)) {
-		err = PTR_ERR(vb_devinfo);
-		goto out_free_vb;
-	}
-
-	vb_mapping = balloon_mapping_alloc(vb_devinfo,
-					   (balloon_compaction_check()) ?
-					   &virtio_balloon_aops : NULL);
-	if (IS_ERR(vb_mapping)) {
-		/*
-		 * IS_ERR(vb_mapping) && PTR_ERR(vb_mapping) == -EOPNOTSUPP
-		 * This means !CONFIG_BALLOON_COMPACTION, otherwise we get off.
-		 */
-		err = PTR_ERR(vb_mapping);
-		if (err != -EOPNOTSUPP)
-			goto out_free_vb_devinfo;
-	}
-
-	vb->vb_dev_info = vb_devinfo;
+	balloon_devinfo_init(&vb->vb_dev_info);
+#ifdef CONFIG_BALLOON_COMPACTION
+	vb->vb_dev_info.migratepage = virtballoon_migratepage;
+#endif
 
 	err = init_vqs(vb);
 	if (err)
-		goto out_free_vb_mapping;
+		goto out_free_vb;
 
 	vb->thread = kthread_run(balloon, vb, "vballoon");
 	if (IS_ERR(vb->thread)) {
@@ -480,10 +452,6 @@ static int virtballoon_probe(struct virt
 
 out_del_vqs:
 	vdev->config->del_vqs(vdev);
-out_free_vb_mapping:
-	balloon_mapping_free(vb_mapping);
-out_free_vb_devinfo:
-	balloon_devinfo_free(vb_devinfo);
 out_free_vb:
 	kfree(vb);
 out:
@@ -509,8 +477,6 @@ static void virtballoon_remove(struct vi
 
 	kthread_stop(vb->thread);
 	remove_common(vb);
-	balloon_mapping_free(vb->vb_dev_info->mapping);
-	balloon_devinfo_free(vb->vb_dev_info);
 	kfree(vb);
 }
 
diff -puN include/linux/balloon_compaction.h~mm-balloon_compaction-remove-balloon-mapping-and-flag-as_balloon_map include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-remove-balloon-mapping-and-flag-as_balloon_map
+++ a/include/linux/balloon_compaction.h
@@ -57,21 +57,22 @@
  * balloon driver as a page book-keeper for its registered balloon devices.
  */
 struct balloon_dev_info {
-	void *balloon_device;		/* balloon device descriptor */
-	struct address_space *mapping;	/* balloon special page->mapping */
 	unsigned long isolated_pages;	/* # of isolated pages for migration */
 	spinlock_t pages_lock;		/* Protection to pages list */
 	struct list_head pages;		/* Pages enqueued & handled to Host */
+	int (*migratepage)(struct balloon_dev_info *, struct page *newpage,
+			struct page *page, enum migrate_mode mode);
 };
 
 extern struct page *balloon_page_enqueue(struct balloon_dev_info *b_dev_info);
 extern struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info);
-extern struct balloon_dev_info *balloon_devinfo_alloc(
-						void *balloon_dev_descriptor);
 
-static inline void balloon_devinfo_free(struct balloon_dev_info *b_dev_info)
+static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 {
-	kfree(b_dev_info);
+	balloon->isolated_pages = 0;
+	spin_lock_init(&balloon->pages_lock);
+	INIT_LIST_HEAD(&balloon->pages);
+	balloon->migratepage = NULL;
 }
 
 #ifdef CONFIG_BALLOON_COMPACTION
@@ -79,14 +80,6 @@ extern bool balloon_page_isolate(struct
 extern void balloon_page_putback(struct page *page);
 extern int balloon_page_migrate(struct page *newpage,
 				struct page *page, enum migrate_mode mode);
-extern struct address_space
-*balloon_mapping_alloc(struct balloon_dev_info *b_dev_info,
-			const struct address_space_operations *a_ops);
-
-static inline void balloon_mapping_free(struct address_space *balloon_mapping)
-{
-	kfree(balloon_mapping);
-}
 
 /*
  * __is_movable_balloon_page - helper to perform @page PageBalloon tests
@@ -120,27 +113,25 @@ static inline bool isolated_balloon_page
 
 /*
  * balloon_page_insert - insert a page into the balloon's page list and make
- *		         the page->mapping assignment accordingly.
+ *			 the page->private assignment accordingly.
+ * @balloon : pointer to balloon device
  * @page    : page to be assigned as a 'balloon page'
- * @mapping : allocated special 'balloon_mapping'
- * @head    : balloon's device page list head
  *
  * Caller must ensure the page is locked and the spin_lock protecting balloon
  * pages list is held before inserting a page into the balloon device.
  */
-static inline void balloon_page_insert(struct page *page,
-				       struct address_space *mapping,
-				       struct list_head *head)
+static inline void balloon_page_insert(struct balloon_dev_info *balloon,
+				       struct page *page)
 {
 	__SetPageBalloon(page);
 	SetPagePrivate(page);
-	page->mapping = mapping;
-	list_add(&page->lru, head);
+	set_page_private(page, (unsigned long)balloon);
+	list_add(&page->lru, &balloon->pages);
 }
 
 /*
  * balloon_page_delete - delete a page from balloon's page list and clear
- *			 the page->mapping assignement accordingly.
+ *			 the page->private assignement accordingly.
  * @page    : page to be released from balloon's page list
  *
  * Caller must ensure the page is locked and the spin_lock protecting balloon
@@ -149,7 +140,7 @@ static inline void balloon_page_insert(s
 static inline void balloon_page_delete(struct page *page)
 {
 	__ClearPageBalloon(page);
-	page->mapping = NULL;
+	set_page_private(page, 0);
 	if (PagePrivate(page)) {
 		ClearPagePrivate(page);
 		list_del(&page->lru);
@@ -162,11 +153,7 @@ static inline void balloon_page_delete(s
  */
 static inline struct balloon_dev_info *balloon_page_device(struct page *page)
 {
-	struct address_space *mapping = page->mapping;
-	if (likely(mapping))
-		return mapping->private_data;
-
-	return NULL;
+	return (struct balloon_dev_info *)page_private(page);
 }
 
 static inline gfp_t balloon_mapping_gfp_mask(void)
@@ -174,29 +161,12 @@ static inline gfp_t balloon_mapping_gfp_
 	return GFP_HIGHUSER_MOVABLE;
 }
 
-static inline bool balloon_compaction_check(void)
-{
-	return true;
-}
-
 #else /* !CONFIG_BALLOON_COMPACTION */
 
-static inline void *balloon_mapping_alloc(void *balloon_device,
-				const struct address_space_operations *a_ops)
+static inline void balloon_page_insert(struct balloon_dev_info *balloon,
+				       struct page *page)
 {
-	return ERR_PTR(-EOPNOTSUPP);
-}
-
-static inline void balloon_mapping_free(struct address_space *balloon_mapping)
-{
-	return;
-}
-
-static inline void balloon_page_insert(struct page *page,
-				       struct address_space *mapping,
-				       struct list_head *head)
-{
-	list_add(&page->lru, head);
+	list_add(&page->lru, &balloon->pages);
 }
 
 static inline void balloon_page_delete(struct page *page)
@@ -240,9 +210,5 @@ static inline gfp_t balloon_mapping_gfp_
 	return GFP_HIGHUSER;
 }
 
-static inline bool balloon_compaction_check(void)
-{
-	return false;
-}
 #endif /* CONFIG_BALLOON_COMPACTION */
 #endif /* _LINUX_BALLOON_COMPACTION_H */
diff -puN include/linux/pagemap.h~mm-balloon_compaction-remove-balloon-mapping-and-flag-as_balloon_map include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-balloon_compaction-remove-balloon-mapping-and-flag-as_balloon_map
+++ a/include/linux/pagemap.h
@@ -24,8 +24,7 @@ enum mapping_flags {
 	AS_ENOSPC	= __GFP_BITS_SHIFT + 1,	/* ENOSPC on async write */
 	AS_MM_ALL_LOCKS	= __GFP_BITS_SHIFT + 2,	/* under mm_take_all_locks() */
 	AS_UNEVICTABLE	= __GFP_BITS_SHIFT + 3,	/* e.g., ramdisk, SHM_LOCK */
-	AS_BALLOON_MAP  = __GFP_BITS_SHIFT + 4, /* balloon page special map */
-	AS_EXITING	= __GFP_BITS_SHIFT + 5, /* final truncate in progress */
+	AS_EXITING	= __GFP_BITS_SHIFT + 4, /* final truncate in progress */
 };
 
 static inline void mapping_set_error(struct address_space *mapping, int error)
@@ -55,21 +54,6 @@ static inline int mapping_unevictable(st
 	return !!mapping;
 }
 
-static inline void mapping_set_balloon(struct address_space *mapping)
-{
-	set_bit(AS_BALLOON_MAP, &mapping->flags);
-}
-
-static inline void mapping_clear_balloon(struct address_space *mapping)
-{
-	clear_bit(AS_BALLOON_MAP, &mapping->flags);
-}
-
-static inline int mapping_balloon(struct address_space *mapping)
-{
-	return mapping && test_bit(AS_BALLOON_MAP, &mapping->flags);
-}
-
 static inline void mapping_set_exiting(struct address_space *mapping)
 {
 	set_bit(AS_EXITING, &mapping->flags);
diff -puN mm/balloon_compaction.c~mm-balloon_compaction-remove-balloon-mapping-and-flag-as_balloon_map mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-balloon_compaction-remove-balloon-mapping-and-flag-as_balloon_map
+++ a/mm/balloon_compaction.c
@@ -11,32 +11,6 @@
 #include <linux/balloon_compaction.h>
 
 /*
- * balloon_devinfo_alloc - allocates a balloon device information descriptor.
- * @balloon_dev_descriptor: pointer to reference the balloon device which
- *                          this struct balloon_dev_info will be servicing.
- *
- * Driver must call it to properly allocate and initialize an instance of
- * struct balloon_dev_info which will be used to reference a balloon device
- * as well as to keep track of the balloon device page list.
- */
-struct balloon_dev_info *balloon_devinfo_alloc(void *balloon_dev_descriptor)
-{
-	struct balloon_dev_info *b_dev_info;
-	b_dev_info = kmalloc(sizeof(*b_dev_info), GFP_KERNEL);
-	if (!b_dev_info)
-		return ERR_PTR(-ENOMEM);
-
-	b_dev_info->balloon_device = balloon_dev_descriptor;
-	b_dev_info->mapping = NULL;
-	b_dev_info->isolated_pages = 0;
-	spin_lock_init(&b_dev_info->pages_lock);
-	INIT_LIST_HEAD(&b_dev_info->pages);
-
-	return b_dev_info;
-}
-EXPORT_SYMBOL_GPL(balloon_devinfo_alloc);
-
-/*
  * balloon_page_enqueue - allocates a new page and inserts it into the balloon
  *			  page list.
  * @b_dev_info: balloon device decriptor where we will insert a new page to
@@ -61,7 +35,7 @@ struct page *balloon_page_enqueue(struct
 	 */
 	BUG_ON(!trylock_page(page));
 	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
-	balloon_page_insert(page, b_dev_info->mapping, &b_dev_info->pages);
+	balloon_page_insert(b_dev_info, page);
 	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
 	unlock_page(page);
 	return page;
@@ -127,60 +101,10 @@ struct page *balloon_page_dequeue(struct
 EXPORT_SYMBOL_GPL(balloon_page_dequeue);
 
 #ifdef CONFIG_BALLOON_COMPACTION
-/*
- * balloon_mapping_alloc - allocates a special ->mapping for ballooned pages.
- * @b_dev_info: holds the balloon device information descriptor.
- * @a_ops: balloon_mapping address_space_operations descriptor.
- *
- * Driver must call it to properly allocate and initialize an instance of
- * struct address_space which will be used as the special page->mapping for
- * balloon device enlisted page instances.
- */
-struct address_space *balloon_mapping_alloc(struct balloon_dev_info *b_dev_info,
-				const struct address_space_operations *a_ops)
-{
-	struct address_space *mapping;
-
-	mapping = kmalloc(sizeof(*mapping), GFP_KERNEL);
-	if (!mapping)
-		return ERR_PTR(-ENOMEM);
-
-	/*
-	 * Give a clean 'zeroed' status to all elements of this special
-	 * balloon page->mapping struct address_space instance.
-	 */
-	address_space_init_once(mapping);
-
-	/*
-	 * Set mapping->flags appropriately, to allow balloon pages
-	 * ->mapping identification.
-	 */
-	mapping_set_balloon(mapping);
-	mapping_set_gfp_mask(mapping, balloon_mapping_gfp_mask());
-
-	/* balloon's page->mapping->a_ops callback descriptor */
-	mapping->a_ops = a_ops;
-
-	/*
-	 * Establish a pointer reference back to the balloon device descriptor
-	 * this particular page->mapping will be servicing.
-	 * This is used by compaction / migration procedures to identify and
-	 * access the balloon device pageset while isolating / migrating pages.
-	 *
-	 * As some balloon drivers can register multiple balloon devices
-	 * for a single guest, this also helps compaction / migration to
-	 * properly deal with multiple balloon pagesets, when required.
-	 */
-	mapping->private_data = b_dev_info;
-	b_dev_info->mapping = mapping;
-
-	return mapping;
-}
-EXPORT_SYMBOL_GPL(balloon_mapping_alloc);
 
 static inline void __isolate_balloon_page(struct page *page)
 {
-	struct balloon_dev_info *b_dev_info = page->mapping->private_data;
+	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
 	unsigned long flags;
 
 	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
@@ -192,7 +116,7 @@ static inline void __isolate_balloon_pag
 
 static inline void __putback_balloon_page(struct page *page)
 {
-	struct balloon_dev_info *b_dev_info = page->mapping->private_data;
+	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
 	unsigned long flags;
 
 	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
@@ -202,12 +126,6 @@ static inline void __putback_balloon_pag
 	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
 }
 
-static inline int __migrate_balloon_page(struct address_space *mapping,
-		struct page *newpage, struct page *page, enum migrate_mode mode)
-{
-	return page->mapping->a_ops->migratepage(mapping, newpage, page, mode);
-}
-
 /* __isolate_lru_page() counterpart for a ballooned page */
 bool balloon_page_isolate(struct page *page)
 {
@@ -274,7 +192,7 @@ void balloon_page_putback(struct page *p
 int balloon_page_migrate(struct page *newpage,
 			 struct page *page, enum migrate_mode mode)
 {
-	struct address_space *mapping;
+	struct balloon_dev_info *balloon = balloon_page_device(page);
 	int rc = -EAGAIN;
 
 	/*
@@ -290,9 +208,8 @@ int balloon_page_migrate(struct page *ne
 		return rc;
 	}
 
-	mapping = page->mapping;
-	if (mapping)
-		rc = __migrate_balloon_page(mapping, newpage, page, mode);
+	if (balloon && balloon->migratepage)
+		rc = balloon->migratepage(balloon, newpage, page, mode);
 
 	unlock_page(newpage);
 	return rc;
_

Patches currently in -mm which might be from k.khlebnikov@samsung.com are

include-linux-migrateh-remove-migratepage-define.patch
mm-balloon_compaction-redesign-ballooned-pages-management.patch
mm-balloon_compaction-remove-balloon-mapping-and-flag-as_balloon_map.patch
mm-balloon_compaction-add-vmstat-counters-and-kpageflags-bit.patch
linux-next.patch


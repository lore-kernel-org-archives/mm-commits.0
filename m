From: akpm@linux-foundation.org
Subject: + mm-balloon-use-general-non-lru-movable-page-feature.patch added to -mm tree
Date: Wed, 01 Jun 2016 14:41:19 -0700
Message-ID: <574f567f.gNRG3LkacMVEALCN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbcFAVlU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2016 17:41:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aquini@redhat.com, gi-oh.kim@profitbricks.com, koct9i@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: balloon: use general non-lru movable page feature
has been added to the -mm tree.  Its filename is
     mm-balloon-use-general-non-lru-movable-page-feature.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-balloon-use-general-non-lru-movable-page-feature.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-balloon-use-general-non-lru-movable-page-feature.patch

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
Subject: mm: balloon: use general non-lru movable page feature

Now, VM has a feature to migrate non-lru movable pages so balloon doesn't
need custom migration hooks in migrate.c and compaction.c.  Instead, this
patch implements page->mapping->a_ops->{isolate|migrate|putback}
functions.

With that, we could remove hooks for ballooning in general migration
functions and make balloon compaction simple.

Link: http://lkml.kernel.org/r/1464736881-24886-4-git-send-email-minchan@kernel.org
Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c    |   54 +++++++++++++--
 include/linux/balloon_compaction.h |   53 ++++-----------
 include/uapi/linux/magic.h         |    1 
 mm/balloon_compaction.c            |   94 ++++-----------------------
 mm/compaction.c                    |    7 --
 mm/migrate.c                       |   19 -----
 mm/vmscan.c                        |    2 
 7 files changed, 85 insertions(+), 145 deletions(-)

diff -puN drivers/virtio/virtio_balloon.c~mm-balloon-use-general-non-lru-movable-page-feature drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~mm-balloon-use-general-non-lru-movable-page-feature
+++ a/drivers/virtio/virtio_balloon.c
@@ -30,6 +30,7 @@
 #include <linux/oom.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
+#include <linux/mount.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -45,6 +46,10 @@ static int oom_pages = OOM_VBALLOON_DEFA
 module_param(oom_pages, int, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(oom_pages, "pages to free on OOM");
 
+#ifdef CONFIG_BALLOON_COMPACTION
+static struct vfsmount *balloon_mnt;
+#endif
+
 struct virtio_balloon {
 	struct virtio_device *vdev;
 	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq;
@@ -488,8 +493,26 @@ static int virtballoon_migratepage(struc
 
 	put_page(page); /* balloon reference */
 
-	return MIGRATEPAGE_SUCCESS;
+	return 0;
 }
+
+static struct dentry *balloon_mount(struct file_system_type *fs_type,
+		int flags, const char *dev_name, void *data)
+{
+	static const struct dentry_operations ops = {
+		.d_dname = simple_dname,
+	};
+
+	return mount_pseudo(fs_type, "balloon-kvm:", NULL, &ops,
+				BALLOON_KVM_MAGIC);
+}
+
+static struct file_system_type balloon_fs = {
+	.name           = "balloon-kvm",
+	.mount          = balloon_mount,
+	.kill_sb        = kill_anon_super,
+};
+
 #endif /* CONFIG_BALLOON_COMPACTION */
 
 static int virtballoon_probe(struct virtio_device *vdev)
@@ -519,9 +542,6 @@ static int virtballoon_probe(struct virt
 	vb->vdev = vdev;
 
 	balloon_devinfo_init(&vb->vb_dev_info);
-#ifdef CONFIG_BALLOON_COMPACTION
-	vb->vb_dev_info.migratepage = virtballoon_migratepage;
-#endif
 
 	err = init_vqs(vb);
 	if (err)
@@ -531,13 +551,33 @@ static int virtballoon_probe(struct virt
 	vb->nb.priority = VIRTBALLOON_OOM_NOTIFY_PRIORITY;
 	err = register_oom_notifier(&vb->nb);
 	if (err < 0)
-		goto out_oom_notify;
+		goto out_del_vqs;
+
+#ifdef CONFIG_BALLOON_COMPACTION
+	balloon_mnt = kern_mount(&balloon_fs);
+	if (IS_ERR(balloon_mnt)) {
+		err = PTR_ERR(balloon_mnt);
+		unregister_oom_notifier(&vb->nb);
+		goto out_del_vqs;
+	}
+
+	vb->vb_dev_info.migratepage = virtballoon_migratepage;
+	vb->vb_dev_info.inode = alloc_anon_inode(balloon_mnt->mnt_sb);
+	if (IS_ERR(vb->vb_dev_info.inode)) {
+		err = PTR_ERR(vb->vb_dev_info.inode);
+		kern_unmount(balloon_mnt);
+		unregister_oom_notifier(&vb->nb);
+		vb->vb_dev_info.inode = NULL;
+		goto out_del_vqs;
+	}
+	vb->vb_dev_info.inode->i_mapping->a_ops = &balloon_aops;
+#endif
 
 	virtio_device_ready(vdev);
 
 	return 0;
 
-out_oom_notify:
+out_del_vqs:
 	vdev->config->del_vqs(vdev);
 out_free_vb:
 	kfree(vb);
@@ -571,6 +611,8 @@ static void virtballoon_remove(struct vi
 	cancel_work_sync(&vb->update_balloon_stats_work);
 
 	remove_common(vb);
+	if (vb->vb_dev_info.inode)
+		iput(vb->vb_dev_info.inode);
 	kfree(vb);
 }
 
diff -puN include/linux/balloon_compaction.h~mm-balloon-use-general-non-lru-movable-page-feature include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-balloon-use-general-non-lru-movable-page-feature
+++ a/include/linux/balloon_compaction.h
@@ -45,9 +45,10 @@
 #define _LINUX_BALLOON_COMPACTION_H
 #include <linux/pagemap.h>
 #include <linux/page-flags.h>
-#include <linux/migrate.h>
+#include <linux/compaction.h>
 #include <linux/gfp.h>
 #include <linux/err.h>
+#include <linux/fs.h>
 
 /*
  * Balloon device information descriptor.
@@ -62,6 +63,7 @@ struct balloon_dev_info {
 	struct list_head pages;		/* Pages enqueued & handled to Host */
 	int (*migratepage)(struct balloon_dev_info *, struct page *newpage,
 			struct page *page, enum migrate_mode mode);
+	struct inode *inode;
 };
 
 extern struct page *balloon_page_enqueue(struct balloon_dev_info *b_dev_info);
@@ -73,45 +75,19 @@ static inline void balloon_devinfo_init(
 	spin_lock_init(&balloon->pages_lock);
 	INIT_LIST_HEAD(&balloon->pages);
 	balloon->migratepage = NULL;
+	balloon->inode = NULL;
 }
 
 #ifdef CONFIG_BALLOON_COMPACTION
-extern bool balloon_page_isolate(struct page *page);
+extern const struct address_space_operations balloon_aops;
+extern bool balloon_page_isolate(struct page *page,
+				isolate_mode_t mode);
 extern void balloon_page_putback(struct page *page);
-extern int balloon_page_migrate(struct page *newpage,
+extern int balloon_page_migrate(struct address_space *mapping,
+				struct page *newpage,
 				struct page *page, enum migrate_mode mode);
 
 /*
- * __is_movable_balloon_page - helper to perform @page PageBalloon tests
- */
-static inline bool __is_movable_balloon_page(struct page *page)
-{
-	return PageBalloon(page);
-}
-
-/*
- * balloon_page_movable - test PageBalloon to identify balloon pages
- *			  and PagePrivate to check that the page is not
- *			  isolated and can be moved by compaction/migration.
- *
- * As we might return false positives in the case of a balloon page being just
- * released under us, this need to be re-tested later, under the page lock.
- */
-static inline bool balloon_page_movable(struct page *page)
-{
-	return PageBalloon(page) && PagePrivate(page);
-}
-
-/*
- * isolated_balloon_page - identify an isolated balloon page on private
- *			   compaction/migration page lists.
- */
-static inline bool isolated_balloon_page(struct page *page)
-{
-	return PageBalloon(page);
-}
-
-/*
  * balloon_page_insert - insert a page into the balloon's page list and make
  *			 the page->private assignment accordingly.
  * @balloon : pointer to balloon device
@@ -124,7 +100,7 @@ static inline void balloon_page_insert(s
 				       struct page *page)
 {
 	__SetPageBalloon(page);
-	SetPagePrivate(page);
+	__SetPageMovable(page, balloon->inode->i_mapping);
 	set_page_private(page, (unsigned long)balloon);
 	list_add(&page->lru, &balloon->pages);
 }
@@ -140,11 +116,14 @@ static inline void balloon_page_insert(s
 static inline void balloon_page_delete(struct page *page)
 {
 	__ClearPageBalloon(page);
+	__ClearPageMovable(page);
 	set_page_private(page, 0);
-	if (PagePrivate(page)) {
-		ClearPagePrivate(page);
+	/*
+	 * No touch page.lru field once @page has been isolated
+	 * because VM is using the field.
+	 */
+	if (!PageIsolated(page))
 		list_del(&page->lru);
-	}
 }
 
 /*
diff -puN include/uapi/linux/magic.h~mm-balloon-use-general-non-lru-movable-page-feature include/uapi/linux/magic.h
--- a/include/uapi/linux/magic.h~mm-balloon-use-general-non-lru-movable-page-feature
+++ a/include/uapi/linux/magic.h
@@ -80,5 +80,6 @@
 #define BPF_FS_MAGIC		0xcafe4a11
 /* Since UDF 2.01 is ISO 13346 based... */
 #define UDF_SUPER_MAGIC		0x15013346
+#define BALLOON_KVM_MAGIC	0x13661366
 
 #endif /* __LINUX_MAGIC_H__ */
diff -puN mm/balloon_compaction.c~mm-balloon-use-general-non-lru-movable-page-feature mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-balloon-use-general-non-lru-movable-page-feature
+++ a/mm/balloon_compaction.c
@@ -70,7 +70,7 @@ struct page *balloon_page_dequeue(struct
 		 */
 		if (trylock_page(page)) {
 #ifdef CONFIG_BALLOON_COMPACTION
-			if (!PagePrivate(page)) {
+			if (PageIsolated(page)) {
 				/* raced with isolation */
 				unlock_page(page);
 				continue;
@@ -106,110 +106,50 @@ EXPORT_SYMBOL_GPL(balloon_page_dequeue);
 
 #ifdef CONFIG_BALLOON_COMPACTION
 
-static inline void __isolate_balloon_page(struct page *page)
+bool balloon_page_isolate(struct page *page, isolate_mode_t mode)
+
 {
 	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
 	unsigned long flags;
 
 	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
-	ClearPagePrivate(page);
 	list_del(&page->lru);
 	b_dev_info->isolated_pages++;
 	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+
+	return true;
 }
 
-static inline void __putback_balloon_page(struct page *page)
+void balloon_page_putback(struct page *page)
 {
 	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
 	unsigned long flags;
 
 	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
-	SetPagePrivate(page);
 	list_add(&page->lru, &b_dev_info->pages);
 	b_dev_info->isolated_pages--;
 	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
 }
 
-/* __isolate_lru_page() counterpart for a ballooned page */
-bool balloon_page_isolate(struct page *page)
-{
-	/*
-	 * Avoid burning cycles with pages that are yet under __free_pages(),
-	 * or just got freed under us.
-	 *
-	 * In case we 'win' a race for a balloon page being freed under us and
-	 * raise its refcount preventing __free_pages() from doing its job
-	 * the put_page() at the end of this block will take care of
-	 * release this page, thus avoiding a nasty leakage.
-	 */
-	if (likely(get_page_unless_zero(page))) {
-		/*
-		 * As balloon pages are not isolated from LRU lists, concurrent
-		 * compaction threads can race against page migration functions
-		 * as well as race against the balloon driver releasing a page.
-		 *
-		 * In order to avoid having an already isolated balloon page
-		 * being (wrongly) re-isolated while it is under migration,
-		 * or to avoid attempting to isolate pages being released by
-		 * the balloon driver, lets be sure we have the page lock
-		 * before proceeding with the balloon page isolation steps.
-		 */
-		if (likely(trylock_page(page))) {
-			/*
-			 * A ballooned page, by default, has PagePrivate set.
-			 * Prevent concurrent compaction threads from isolating
-			 * an already isolated balloon page by clearing it.
-			 */
-			if (balloon_page_movable(page)) {
-				__isolate_balloon_page(page);
-				unlock_page(page);
-				return true;
-			}
-			unlock_page(page);
-		}
-		put_page(page);
-	}
-	return false;
-}
-
-/* putback_lru_page() counterpart for a ballooned page */
-void balloon_page_putback(struct page *page)
-{
-	/*
-	 * 'lock_page()' stabilizes the page and prevents races against
-	 * concurrent isolation threads attempting to re-isolate it.
-	 */
-	lock_page(page);
-
-	if (__is_movable_balloon_page(page)) {
-		__putback_balloon_page(page);
-		/* drop the extra ref count taken for page isolation */
-		put_page(page);
-	} else {
-		WARN_ON(1);
-		dump_page(page, "not movable balloon page");
-	}
-	unlock_page(page);
-}
 
 /* move_to_new_page() counterpart for a ballooned page */
-int balloon_page_migrate(struct page *newpage,
-			 struct page *page, enum migrate_mode mode)
+int balloon_page_migrate(struct address_space *mapping,
+		struct page *newpage, struct page *page,
+		enum migrate_mode mode)
 {
 	struct balloon_dev_info *balloon = balloon_page_device(page);
-	int rc = -EAGAIN;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
-	if (WARN_ON(!__is_movable_balloon_page(page))) {
-		dump_page(page, "not movable balloon page");
-		return rc;
-	}
+	return balloon->migratepage(balloon, newpage, page, mode);
+}
 
-	if (balloon && balloon->migratepage)
-		rc = balloon->migratepage(balloon, newpage, page, mode);
+const struct address_space_operations balloon_aops = {
+	.migratepage = balloon_page_migrate,
+	.isolate_page = balloon_page_isolate,
+	.putback_page = balloon_page_putback,
+};
+EXPORT_SYMBOL_GPL(balloon_aops);
 
-	return rc;
-}
 #endif /* CONFIG_BALLOON_COMPACTION */
diff -puN mm/compaction.c~mm-balloon-use-general-non-lru-movable-page-feature mm/compaction.c
--- a/mm/compaction.c~mm-balloon-use-general-non-lru-movable-page-feature
+++ a/mm/compaction.c
@@ -795,13 +795,6 @@ isolate_migratepages_block(struct compac
 		 */
 		is_lru = PageLRU(page);
 		if (!is_lru) {
-			if (unlikely(balloon_page_movable(page))) {
-				if (balloon_page_isolate(page)) {
-					/* Successfully isolated */
-					goto isolate_success;
-				}
-			}
-
 			/*
 			 * __PageMovable can return false positive so we need
 			 * to verify it under page_lock.
diff -puN mm/migrate.c~mm-balloon-use-general-non-lru-movable-page-feature mm/migrate.c
--- a/mm/migrate.c~mm-balloon-use-general-non-lru-movable-page-feature
+++ a/mm/migrate.c
@@ -170,14 +170,12 @@ void putback_movable_pages(struct list_h
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
-		if (unlikely(isolated_balloon_page(page))) {
-			balloon_page_putback(page);
 		/*
 		 * We isolated non-lru movable page so here we can use
 		 * __PageMovable because LRU page's mapping cannot have
 		 * PAGE_MAPPING_MOVABLE.
 		 */
-		} else if (unlikely(__PageMovable(page))) {
+		if (unlikely(__PageMovable(page))) {
 			VM_BUG_ON_PAGE(!PageIsolated(page), page);
 			lock_page(page);
 			if (PageMovable(page))
@@ -990,18 +988,6 @@ static int __unmap_and_move(struct page
 	if (unlikely(!trylock_page(newpage)))
 		goto out_unlock;
 
-	if (unlikely(isolated_balloon_page(page))) {
-		/*
-		 * A ballooned page does not need any special attention from
-		 * physical to virtual reverse mapping procedures.
-		 * Skip any attempt to unmap PTEs or to remap swap cache,
-		 * in order to avoid burning cycles at rmap level, and perform
-		 * the page migration right away (proteced by page lock).
-		 */
-		rc = balloon_page_migrate(newpage, page, mode);
-		goto out_unlock_both;
-	}
-
 	if (unlikely(!is_lru)) {
 		rc = move_to_new_page(newpage, page, mode);
 		goto out_unlock_both;
@@ -1056,8 +1042,7 @@ out:
 	 * list in here.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		if (unlikely(__is_movable_balloon_page(newpage) ||
-				__PageMovable(newpage)))
+		if (unlikely(__PageMovable(newpage)))
 			put_page(newpage);
 		else
 			putback_lru_page(newpage);
diff -puN mm/vmscan.c~mm-balloon-use-general-non-lru-movable-page-feature mm/vmscan.c
--- a/mm/vmscan.c~mm-balloon-use-general-non-lru-movable-page-feature
+++ a/mm/vmscan.c
@@ -1254,7 +1254,7 @@ unsigned long reclaim_clean_pages_from_l
 
 	list_for_each_entry_safe(page, next, page_list, lru) {
 		if (page_is_file_cache(page) && !PageDirty(page) &&
-		    !isolated_balloon_page(page)) {
+		    !__PageMovable(page)) {
 			ClearPageActive(page);
 			list_move(&page->lru, &clean_pages);
 		}
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-use-put_page-to-free-page-instead-of-putback_lru_page.patch
mm-migrate-support-non-lru-movable-page-migration.patch
mm-balloon-use-general-non-lru-movable-page-feature.patch
zsmalloc-keep-max_object-in-size_class.patch
zsmalloc-use-bit_spin_lock.patch
zsmalloc-use-accessor.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-introduce-zspage-structure.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-use-freeobj-for-index.patch
zsmalloc-page-migration-support.patch
zram-use-__gfp_movable-for-memory-allocation.patch


From: akpm@linux-foundation.org
Subject: +
 mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback.patch added to -mm tree
Date: Thu, 16 Mar 2017 13:51:46 -0700
Message-ID: <58cafae2.3mLTjFFnlh0lh+OC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52830 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752668AbdCPVDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 17:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: add new boolean copy flag to migratepage() callback
has been added to the -mm tree.  Its filename is
     mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/migrate: add new boolean copy flag to migratepage() callback

Allow migration without copy in case destination page already have source
page content.  This is usefull for new dma capable migration where use
device dma engine to copy pages.

This feature needs careful audit of filesystem code to make sure that no
one can write to the source page while it is unmapped and locked.  It
should be safe for most filesystem but as precaution return error until
support for device migration is added to them.

Link: http://lkml.kernel.org/r/1489680335-6594-7-git-send-email-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/llite/rw26.c |    8 ++
 fs/aio.c                                   |    7 ++
 fs/btrfs/disk-io.c                         |   11 ++-
 fs/f2fs/data.c                             |    8 ++
 fs/f2fs/f2fs.h                             |    2 
 fs/hugetlbfs/inode.c                       |    9 ++-
 fs/nfs/internal.h                          |    5 +
 fs/nfs/write.c                             |    9 ++-
 fs/ubifs/file.c                            |    8 ++
 include/linux/balloon_compaction.h         |    3 -
 include/linux/fs.h                         |   13 ++--
 include/linux/migrate.h                    |    7 +-
 mm/balloon_compaction.c                    |    2 
 mm/migrate.c                               |   56 +++++++++++--------
 mm/zsmalloc.c                              |   12 +++-
 15 files changed, 114 insertions(+), 46 deletions(-)

diff -puN drivers/staging/lustre/lustre/llite/rw26.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback drivers/staging/lustre/lustre/llite/rw26.c
--- a/drivers/staging/lustre/lustre/llite/rw26.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback
+++ a/drivers/staging/lustre/lustre/llite/rw26.c
@@ -43,6 +43,7 @@
 #include <linux/uaccess.h>
 
 #include <linux/migrate.h>
+#include <linux/memremap.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
@@ -642,9 +643,12 @@ static int ll_write_end(struct file *fil
 #ifdef CONFIG_MIGRATION
 static int ll_migratepage(struct address_space *mapping,
 			  struct page *newpage, struct page *page,
-			  enum migrate_mode mode
-		)
+			  enum migrate_mode mode, bool copy)
 {
+	/* Can only migrate addressable memory for now */
+	if (!is_addressable_page(newpage))
+		return -EINVAL;
+
 	/* Always fail page migration until we have a proper implementation */
 	return -EIO;
 }
diff -puN fs/aio.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback fs/aio.c
--- a/fs/aio.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback
+++ a/fs/aio.c
@@ -37,6 +37,7 @@
 #include <linux/blkdev.h>
 #include <linux/compat.h>
 #include <linux/migrate.h>
+#include <linux/memremap.h>
 #include <linux/ramfs.h>
 #include <linux/percpu-refcount.h>
 #include <linux/mount.h>
@@ -366,13 +367,17 @@ static const struct file_operations aio_
 
 #if IS_ENABLED(CONFIG_MIGRATION)
 static int aio_migratepage(struct address_space *mapping, struct page *new,
-			struct page *old, enum migrate_mode mode)
+			   struct page *old, enum migrate_mode mode, bool copy)
 {
 	struct kioctx *ctx;
 	unsigned long flags;
 	pgoff_t idx;
 	int rc;
 
+	/* Can only migrate addressable memory for now */
+	if (!is_addressable_page(new))
+		return -EINVAL;
+
 	rc = 0;
 
 	/* mapping->private_lock here protects against the kioctx teardown.  */
diff -puN fs/btrfs/disk-io.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback fs/btrfs/disk-io.c
--- a/fs/btrfs/disk-io.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback
+++ a/fs/btrfs/disk-io.c
@@ -27,6 +27,7 @@
 #include <linux/kthread.h>
 #include <linux/slab.h>
 #include <linux/migrate.h>
+#include <linux/memremap.h>
 #include <linux/ratelimit.h>
 #include <linux/uuid.h>
 #include <linux/semaphore.h>
@@ -1061,9 +1062,13 @@ out_w_error:
 
 #ifdef CONFIG_MIGRATION
 static int btree_migratepage(struct address_space *mapping,
-			struct page *newpage, struct page *page,
-			enum migrate_mode mode)
+			     struct page *newpage, struct page *page,
+			     enum migrate_mode mode, bool copy)
 {
+	/* Can only migrate addressable memory for now */
+	if (!is_addressable_page(newpage))
+		return -EINVAL;
+
 	/*
 	 * we can't safely write a btree page from here,
 	 * we haven't done the locking hook
@@ -1077,7 +1082,7 @@ static int btree_migratepage(struct addr
 	if (page_has_private(page) &&
 	    !try_to_release_page(page, GFP_KERNEL))
 		return -EAGAIN;
-	return migrate_page(mapping, newpage, page, mode);
+	return migrate_page(mapping, newpage, page, mode, copy);
 }
 #endif
 
diff -puN fs/f2fs/data.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback fs/f2fs/data.c
--- a/fs/f2fs/data.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback
+++ a/fs/f2fs/data.c
@@ -23,6 +23,7 @@
 #include <linux/memcontrol.h>
 #include <linux/cleancache.h>
 #include <linux/sched/signal.h>
+#include <linux/memremap.h>
 
 #include "f2fs.h"
 #include "node.h"
@@ -2049,7 +2050,8 @@ static sector_t f2fs_bmap(struct address
 #include <linux/migrate.h>
 
 int f2fs_migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page, enum migrate_mode mode)
+		struct page *newpage, struct page *page,
+		enum migrate_mode mode, bool copy)
 {
 	int rc, extra_count;
 	struct f2fs_inode_info *fi = F2FS_I(mapping->host);
@@ -2057,6 +2059,10 @@ int f2fs_migrate_page(struct address_spa
 
 	BUG_ON(PageWriteback(page));
 
+	/* Can only migrate addressable memory for now */
+	if (!is_addressable_page(newpage))
+		return -EINVAL;
+
 	/* migrating an atomic written page is safe with the inmem_lock hold */
 	if (atomic_written && !mutex_trylock(&fi->inmem_lock))
 		return -EAGAIN;
diff -puN fs/f2fs/f2fs.h~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback fs/f2fs/f2fs.h
--- a/fs/f2fs/f2fs.h~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback
+++ a/fs/f2fs/f2fs.h
@@ -2299,7 +2299,7 @@ void f2fs_invalidate_page(struct page *p
 int f2fs_release_page(struct page *page, gfp_t wait);
 #ifdef CONFIG_MIGRATION
 int f2fs_migrate_page(struct address_space *mapping, struct page *newpage,
-			struct page *page, enum migrate_mode mode);
+			struct page *page, enum migrate_mode mode, bool copy);
 #endif
 
 /*
diff -puN fs/hugetlbfs/inode.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback
+++ a/fs/hugetlbfs/inode.c
@@ -35,6 +35,7 @@
 #include <linux/security.h>
 #include <linux/magic.h>
 #include <linux/migrate.h>
+#include <linux/memremap.h>
 #include <linux/uio.h>
 
 #include <linux/uaccess.h>
@@ -842,11 +843,15 @@ static int hugetlbfs_set_page_dirty(stru
 }
 
 static int hugetlbfs_migrate_page(struct address_space *mapping,
-				struct page *newpage, struct page *page,
-				enum migrate_mode mode)
+				  struct page *newpage, struct page *page,
+				  enum migrate_mode mode, bool copy)
 {
 	int rc;
 
+	/* Can only migrate addressable memory for now */
+	if (!is_addressable_page(newpage))
+		return -EINVAL;
+
 	rc = migrate_huge_page_move_mapping(mapping, newpage, page);
 	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
diff -puN fs/nfs/internal.h~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback fs/nfs/internal.h
--- a/fs/nfs/internal.h~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback
+++ a/fs/nfs/internal.h
@@ -535,8 +535,9 @@ void nfs_clear_pnfs_ds_commit_verifiers(
 #endif
 
 #ifdef CONFIG_MIGRATION
-extern int nfs_migrate_page(struct address_space *,
-		struct page *, struct page *, enum migrate_mode);
+extern int nfs_migrate_page(struct address_space *mapping,
+			    struct page *newpage, struct page *page,
+			    enum migrate_mode, bool copy);
 #endif
 
 static inline int
diff -puN fs/nfs/write.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback fs/nfs/write.c
--- a/fs/nfs/write.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback
+++ a/fs/nfs/write.c
@@ -14,6 +14,7 @@
 #include <linux/writeback.h>
 #include <linux/swap.h>
 #include <linux/migrate.h>
+#include <linux/memremap.h>
 
 #include <linux/sunrpc/clnt.h>
 #include <linux/nfs_fs.h>
@@ -2020,8 +2021,12 @@ out_error:
 
 #ifdef CONFIG_MIGRATION
 int nfs_migrate_page(struct address_space *mapping, struct page *newpage,
-		struct page *page, enum migrate_mode mode)
+		     struct page *page, enum migrate_mode mode, bool copy)
 {
+	/* Can only migrate addressable memory for now */
+	if (!is_addressable_page(newpage))
+		return -EINVAL;
+
 	/*
 	 * If PagePrivate is set, then the page is currently associated with
 	 * an in-progress read or write request. Don't try to migrate it.
@@ -2036,7 +2041,7 @@ int nfs_migrate_page(struct address_spac
 	if (!nfs_fscache_release_page(page, GFP_KERNEL))
 		return -EBUSY;
 
-	return migrate_page(mapping, newpage, page, mode);
+	return migrate_page(mapping, newpage, page, mode, copy);
 }
 #endif
 
diff -puN fs/ubifs/file.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback fs/ubifs/file.c
--- a/fs/ubifs/file.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback
+++ a/fs/ubifs/file.c
@@ -53,6 +53,7 @@
 #include <linux/mount.h>
 #include <linux/slab.h>
 #include <linux/migrate.h>
+#include <linux/memremap.h>
 
 static int read_block(struct inode *inode, void *addr, unsigned int block,
 		      struct ubifs_data_node *dn)
@@ -1469,10 +1470,15 @@ static int ubifs_set_page_dirty(struct p
 
 #ifdef CONFIG_MIGRATION
 static int ubifs_migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page, enum migrate_mode mode)
+			      struct page *newpage, struct page *page,
+			      enum migrate_mode mode, bool copy)
 {
 	int rc;
 
+	/* Can only migrate addressable memory for now */
+	if (!is_addressable_page(newpage))
+		return -EINVAL;
+
 	rc = migrate_page_move_mapping(mapping, newpage, page, NULL, mode, 0);
 	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
diff -puN include/linux/balloon_compaction.h~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback
+++ a/include/linux/balloon_compaction.h
@@ -85,7 +85,8 @@ extern bool balloon_page_isolate(struct
 extern void balloon_page_putback(struct page *page);
 extern int balloon_page_migrate(struct address_space *mapping,
 				struct page *newpage,
-				struct page *page, enum migrate_mode mode);
+				struct page *page, enum migrate_mode mode,
+				bool copy);
 
 /*
  * balloon_page_insert - insert a page into the balloon's page list and make
diff -puN include/linux/fs.h~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback include/linux/fs.h
--- a/include/linux/fs.h~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback
+++ a/include/linux/fs.h
@@ -346,8 +346,9 @@ struct address_space_operations {
 	 * migrate the contents of a page to the specified target. If
 	 * migrate_mode is MIGRATE_ASYNC, it must not block.
 	 */
-	int (*migratepage) (struct address_space *,
-			struct page *, struct page *, enum migrate_mode);
+	int (*migratepage)(struct address_space *mapping,
+			   struct page *newpage, struct page *page,
+			   enum migrate_mode, bool copy);
 	bool (*isolate_page)(struct page *, isolate_mode_t);
 	void (*putback_page)(struct page *);
 	int (*launder_page) (struct page *);
@@ -3013,9 +3014,11 @@ extern int generic_file_fsync(struct fil
 extern int generic_check_addressable(unsigned, u64);
 
 #ifdef CONFIG_MIGRATION
-extern int buffer_migrate_page(struct address_space *,
-				struct page *, struct page *,
-				enum migrate_mode);
+extern int buffer_migrate_page(struct address_space *mapping,
+			       struct page *newpage,
+			       struct page *page,
+			       enum migrate_mode,
+			       bool copy);
 #else
 #define buffer_migrate_page NULL
 #endif
diff -puN include/linux/migrate.h~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback
+++ a/include/linux/migrate.h
@@ -33,8 +33,11 @@ extern char *migrate_reason_names[MR_TYP
 #ifdef CONFIG_MIGRATION
 
 extern void putback_movable_pages(struct list_head *l);
-extern int migrate_page(struct address_space *,
-			struct page *, struct page *, enum migrate_mode);
+extern int migrate_page(struct address_space *mapping,
+			struct page *newpage,
+			struct page *page,
+			enum migrate_mode,
+			bool copy);
 extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
 		unsigned long private, enum migrate_mode mode, int reason);
 extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
diff -puN mm/balloon_compaction.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback
+++ a/mm/balloon_compaction.c
@@ -135,7 +135,7 @@ void balloon_page_putback(struct page *p
 /* move_to_new_page() counterpart for a ballooned page */
 int balloon_page_migrate(struct address_space *mapping,
 		struct page *newpage, struct page *page,
-		enum migrate_mode mode)
+		enum migrate_mode mode, bool copy)
 {
 	struct balloon_dev_info *balloon = balloon_page_device(page);
 
diff -puN mm/migrate.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback mm/migrate.c
--- a/mm/migrate.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback
+++ a/mm/migrate.c
@@ -596,18 +596,10 @@ static void copy_huge_page(struct page *
 	}
 }
 
-/*
- * Copy the page to its new location
- */
-void migrate_page_copy(struct page *newpage, struct page *page)
+static void migrate_page_states(struct page *newpage, struct page *page)
 {
 	int cpupid;
 
-	if (PageHuge(page) || PageTransHuge(page))
-		copy_huge_page(newpage, page);
-	else
-		copy_highpage(newpage, page);
-
 	if (PageError(page))
 		SetPageError(newpage);
 	if (PageReferenced(page))
@@ -661,6 +653,19 @@ void migrate_page_copy(struct page *newp
 
 	mem_cgroup_migrate(page, newpage);
 }
+
+/*
+ * Copy the page to its new location
+ */
+void migrate_page_copy(struct page *newpage, struct page *page)
+{
+	if (PageHuge(page) || PageTransHuge(page))
+		copy_huge_page(newpage, page);
+	else
+		copy_highpage(newpage, page);
+
+	migrate_page_states(newpage, page);
+}
 EXPORT_SYMBOL(migrate_page_copy);
 
 /************************************************************
@@ -674,8 +679,8 @@ EXPORT_SYMBOL(migrate_page_copy);
  * Pages are locked upon entry and exit.
  */
 int migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page,
-		enum migrate_mode mode)
+		 struct page *newpage, struct page *page,
+		 enum migrate_mode mode, bool copy)
 {
 	int rc;
 
@@ -686,7 +691,11 @@ int migrate_page(struct address_space *m
 	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 
-	migrate_page_copy(newpage, page);
+	if (copy)
+		migrate_page_copy(newpage, page);
+	else
+		migrate_page_states(newpage, page);
+
 	return MIGRATEPAGE_SUCCESS;
 }
 EXPORT_SYMBOL(migrate_page);
@@ -698,13 +707,14 @@ EXPORT_SYMBOL(migrate_page);
  * exist.
  */
 int buffer_migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page, enum migrate_mode mode)
+			struct page *newpage, struct page *page,
+			enum migrate_mode mode, bool copy)
 {
 	struct buffer_head *bh, *head;
 	int rc;
 
 	if (!page_has_buffers(page))
-		return migrate_page(mapping, newpage, page, mode);
+		return migrate_page(mapping, newpage, page, mode, copy);
 
 	head = page_buffers(page);
 
@@ -736,12 +746,15 @@ int buffer_migrate_page(struct address_s
 
 	SetPagePrivate(newpage);
 
-	migrate_page_copy(newpage, page);
+	if (copy)
+		migrate_page_copy(newpage, page);
+	else
+		migrate_page_states(newpage, page);
 
 	bh = head;
 	do {
 		unlock_buffer(bh);
- 		put_bh(bh);
+		put_bh(bh);
 		bh = bh->b_this_page;
 
 	} while (bh != head);
@@ -796,7 +809,8 @@ static int writeout(struct address_space
  * Default handling if a filesystem does not provide a migration function.
  */
 static int fallback_migrate_page(struct address_space *mapping,
-	struct page *newpage, struct page *page, enum migrate_mode mode)
+				 struct page *newpage, struct page *page,
+				 enum migrate_mode mode)
 {
 	if (PageDirty(page)) {
 		/* Only writeback pages in full synchronous migration */
@@ -813,7 +827,7 @@ static int fallback_migrate_page(struct
 	    !try_to_release_page(page, GFP_KERNEL))
 		return -EAGAIN;
 
-	return migrate_page(mapping, newpage, page, mode);
+	return migrate_page(mapping, newpage, page, mode, true);
 }
 
 /*
@@ -841,7 +855,7 @@ static int move_to_new_page(struct page
 
 	if (likely(is_lru)) {
 		if (!mapping)
-			rc = migrate_page(mapping, newpage, page, mode);
+			rc = migrate_page(mapping, newpage, page, mode, true);
 		else if (mapping->a_ops->migratepage)
 			/*
 			 * Most pages have a mapping and most filesystems
@@ -851,7 +865,7 @@ static int move_to_new_page(struct page
 			 * for page migration.
 			 */
 			rc = mapping->a_ops->migratepage(mapping, newpage,
-							page, mode);
+							page, mode, true);
 		else
 			rc = fallback_migrate_page(mapping, newpage,
 							page, mode);
@@ -868,7 +882,7 @@ static int move_to_new_page(struct page
 		}
 
 		rc = mapping->a_ops->migratepage(mapping, newpage,
-						page, mode);
+						page, mode, true);
 		WARN_ON_ONCE(rc == MIGRATEPAGE_SUCCESS &&
 			!PageIsolated(page));
 	}
diff -puN mm/zsmalloc.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback
+++ a/mm/zsmalloc.c
@@ -52,6 +52,7 @@
 #include <linux/zpool.h>
 #include <linux/mount.h>
 #include <linux/migrate.h>
+#include <linux/memremap.h>
 #include <linux/pagemap.h>
 
 #define ZSPAGE_MAGIC	0x58
@@ -1968,7 +1969,7 @@ bool zs_page_isolate(struct page *page,
 }
 
 int zs_page_migrate(struct address_space *mapping, struct page *newpage,
-		struct page *page, enum migrate_mode mode)
+		    struct page *page, enum migrate_mode mode, bool copy)
 {
 	struct zs_pool *pool;
 	struct size_class *class;
@@ -1986,6 +1987,15 @@ int zs_page_migrate(struct address_space
 	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
 
+	/*
+	 * Offloading copy operation for zspage require special considerations
+	 * due to locking so for now we only support regular migration. I do
+	 * not expect we will ever want to support offloading copy. See hmm.h
+	 * for more informations on hmm_vma_migrate() and offload copy.
+	 */
+	if (!copy || !is_addressable_page(newpage))
+		return -EINVAL;
+
 	zspage = get_zspage(page);
 
 	/* Concurrent compactor cannot migrate any subpage in zspage */
_

Patches currently in -mm which might be from jglisse@redhat.com are

mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3.patch
mm-put_page-move-ref-decrement-to-put_zone_device_page.patch
mm-zone_device-free-page-callback-when-page-is-freed-v3.patch
mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3.patch
mm-zone_device-x86-add-support-for-un-addressable-device-memory.patch
mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2.patch


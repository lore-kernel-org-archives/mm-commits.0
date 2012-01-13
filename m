From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:35:11 -0800
Message-ID: <20120113203512.41CB45C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37836 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759055Ab2AMUfO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:35:14 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25396eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:35:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: determine if dirty pages can be migrated without blocking within ->migratepage
has been removed from the -mm tree.  Its filename was
     mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: determine if dirty pages can be migrated without blocking within ->migratepage

Asynchronous compaction is used when allocating transparent hugepages to
avoid blocking for long periods of time.  Due to reports of stalling,
there was a debate on disabling synchronous compaction but this severely
impacted allocation success rates.  Part of the reason was that many dirty
pages are skipped in asynchronous compaction by the following check;

	if (PageDirty(page) && !sync &&
		mapping->a_ops->migratepage != migrate_page)
			rc = -EBUSY;

This skips over all mapping aops using buffer_migrate_page() even though
it is possible to migrate some of these pages without blocking.  This
patch updates the ->migratepage callback with a "sync" parameter.  It is
the responsibility of the callback to fail gracefully if migration would
block.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/disk-io.c      |    4 -
 fs/hugetlbfs/inode.c    |    3 
 fs/nfs/internal.h       |    2 
 fs/nfs/write.c          |    4 -
 include/linux/fs.h      |    9 +-
 include/linux/migrate.h |    2 
 mm/migrate.c            |  129 +++++++++++++++++++++++++++-----------
 7 files changed, 106 insertions(+), 47 deletions(-)

diff -puN fs/btrfs/disk-io.c~mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage fs/btrfs/disk-io.c
--- a/fs/btrfs/disk-io.c~mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage
+++ a/fs/btrfs/disk-io.c
@@ -872,7 +872,7 @@ static int btree_submit_bio_hook(struct 
 
 #ifdef CONFIG_MIGRATION
 static int btree_migratepage(struct address_space *mapping,
-			struct page *newpage, struct page *page)
+			struct page *newpage, struct page *page, bool sync)
 {
 	/*
 	 * we can't safely write a btree page from here,
@@ -887,7 +887,7 @@ static int btree_migratepage(struct addr
 	if (page_has_private(page) &&
 	    !try_to_release_page(page, GFP_KERNEL))
 		return -EAGAIN;
-	return migrate_page(mapping, newpage, page);
+	return migrate_page(mapping, newpage, page, sync);
 }
 #endif
 
diff -puN fs/hugetlbfs/inode.c~mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage
+++ a/fs/hugetlbfs/inode.c
@@ -583,7 +583,8 @@ static int hugetlbfs_set_page_dirty(stru
 }
 
 static int hugetlbfs_migrate_page(struct address_space *mapping,
-				struct page *newpage, struct page *page)
+				struct page *newpage, struct page *page,
+				bool sync)
 {
 	int rc;
 
diff -puN fs/nfs/internal.h~mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage fs/nfs/internal.h
--- a/fs/nfs/internal.h~mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage
+++ a/fs/nfs/internal.h
@@ -332,7 +332,7 @@ void nfs_commit_release_pages(struct nfs
 
 #ifdef CONFIG_MIGRATION
 extern int nfs_migrate_page(struct address_space *,
-		struct page *, struct page *);
+		struct page *, struct page *, bool);
 #else
 #define nfs_migrate_page NULL
 #endif
diff -puN fs/nfs/write.c~mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage fs/nfs/write.c
--- a/fs/nfs/write.c~mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage
+++ a/fs/nfs/write.c
@@ -1688,7 +1688,7 @@ out_error:
 
 #ifdef CONFIG_MIGRATION
 int nfs_migrate_page(struct address_space *mapping, struct page *newpage,
-		struct page *page)
+		struct page *page, bool sync)
 {
 	/*
 	 * If PagePrivate is set, then the page is currently associated with
@@ -1703,7 +1703,7 @@ int nfs_migrate_page(struct address_spac
 
 	nfs_fscache_release_page(page, GFP_KERNEL);
 
-	return migrate_page(mapping, newpage, page);
+	return migrate_page(mapping, newpage, page, sync);
 }
 #endif
 
diff -puN include/linux/fs.h~mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage include/linux/fs.h
--- a/include/linux/fs.h~mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage
+++ a/include/linux/fs.h
@@ -609,9 +609,12 @@ struct address_space_operations {
 			loff_t offset, unsigned long nr_segs);
 	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
 						void **, unsigned long *);
-	/* migrate the contents of a page to the specified target */
+	/*
+	 * migrate the contents of a page to the specified target. If sync
+	 * is false, it must not block.
+	 */
 	int (*migratepage) (struct address_space *,
-			struct page *, struct page *);
+			struct page *, struct page *, bool);
 	int (*launder_page) (struct page *);
 	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
 					unsigned long);
@@ -2537,7 +2540,7 @@ extern int generic_check_addressable(uns
 
 #ifdef CONFIG_MIGRATION
 extern int buffer_migrate_page(struct address_space *,
-				struct page *, struct page *);
+				struct page *, struct page *, bool);
 #else
 #define buffer_migrate_page NULL
 #endif
diff -puN include/linux/migrate.h~mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage include/linux/migrate.h
--- a/include/linux/migrate.h~mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage
+++ a/include/linux/migrate.h
@@ -11,7 +11,7 @@ typedef struct page *new_page_t(struct p
 
 extern void putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
-			struct page *, struct page *);
+			struct page *, struct page *, bool);
 extern int migrate_pages(struct list_head *l, new_page_t x,
 			unsigned long private, bool offlining,
 			bool sync);
diff -puN mm/migrate.c~mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage mm/migrate.c
--- a/mm/migrate.c~mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage
+++ a/mm/migrate.c
@@ -216,6 +216,55 @@ out:
 	pte_unmap_unlock(ptep, ptl);
 }
 
+#ifdef CONFIG_BLOCK
+/* Returns true if all buffers are successfully locked */
+static bool buffer_migrate_lock_buffers(struct buffer_head *head, bool sync)
+{
+	struct buffer_head *bh = head;
+
+	/* Simple case, sync compaction */
+	if (sync) {
+		do {
+			get_bh(bh);
+			lock_buffer(bh);
+			bh = bh->b_this_page;
+
+		} while (bh != head);
+
+		return true;
+	}
+
+	/* async case, we cannot block on lock_buffer so use trylock_buffer */
+	do {
+		get_bh(bh);
+		if (!trylock_buffer(bh)) {
+			/*
+			 * We failed to lock the buffer and cannot stall in
+			 * async migration. Release the taken locks
+			 */
+			struct buffer_head *failed_bh = bh;
+			put_bh(failed_bh);
+			bh = head;
+			while (bh != failed_bh) {
+				unlock_buffer(bh);
+				put_bh(bh);
+				bh = bh->b_this_page;
+			}
+			return false;
+		}
+
+		bh = bh->b_this_page;
+	} while (bh != head);
+	return true;
+}
+#else
+static inline bool buffer_migrate_lock_buffers(struct buffer_head *head,
+								bool sync)
+{
+	return true;
+}
+#endif /* CONFIG_BLOCK */
+
 /*
  * Replace the page in the mapping.
  *
@@ -225,7 +274,8 @@ out:
  * 3 for pages with a mapping and PagePrivate/PagePrivate2 set.
  */
 static int migrate_page_move_mapping(struct address_space *mapping,
-		struct page *newpage, struct page *page)
+		struct page *newpage, struct page *page,
+		struct buffer_head *head, bool sync)
 {
 	int expected_count;
 	void **pslot;
@@ -255,6 +305,19 @@ static int migrate_page_move_mapping(str
 	}
 
 	/*
+	 * In the async migration case of moving a page with buffers, lock the
+	 * buffers using trylock before the mapping is moved. If the mapping
+	 * was moved, we later failed to lock the buffers and could not move
+	 * the mapping back due to an elevated page count, we would have to
+	 * block waiting on other references to be dropped.
+	 */
+	if (!sync && head && !buffer_migrate_lock_buffers(head, sync)) {
+		page_unfreeze_refs(page, expected_count);
+		spin_unlock_irq(&mapping->tree_lock);
+		return -EAGAIN;
+	}
+
+	/*
 	 * Now we know that no one else is looking at the page.
 	 */
 	get_page(newpage);	/* add cache reference */
@@ -409,13 +472,13 @@ EXPORT_SYMBOL(fail_migrate_page);
  * Pages are locked upon entry and exit.
  */
 int migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page)
+		struct page *newpage, struct page *page, bool sync)
 {
 	int rc;
 
 	BUG_ON(PageWriteback(page));	/* Writeback must be complete */
 
-	rc = migrate_page_move_mapping(mapping, newpage, page);
+	rc = migrate_page_move_mapping(mapping, newpage, page, NULL, sync);
 
 	if (rc)
 		return rc;
@@ -432,28 +495,28 @@ EXPORT_SYMBOL(migrate_page);
  * exist.
  */
 int buffer_migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page)
+		struct page *newpage, struct page *page, bool sync)
 {
 	struct buffer_head *bh, *head;
 	int rc;
 
 	if (!page_has_buffers(page))
-		return migrate_page(mapping, newpage, page);
+		return migrate_page(mapping, newpage, page, sync);
 
 	head = page_buffers(page);
 
-	rc = migrate_page_move_mapping(mapping, newpage, page);
+	rc = migrate_page_move_mapping(mapping, newpage, page, head, sync);
 
 	if (rc)
 		return rc;
 
-	bh = head;
-	do {
-		get_bh(bh);
-		lock_buffer(bh);
-		bh = bh->b_this_page;
-
-	} while (bh != head);
+	/*
+	 * In the async case, migrate_page_move_mapping locked the buffers
+	 * with an IRQ-safe spinlock held. In the sync case, the buffers
+	 * need to be locked now
+	 */
+	if (sync)
+		BUG_ON(!buffer_migrate_lock_buffers(head, sync));
 
 	ClearPagePrivate(page);
 	set_page_private(newpage, page_private(page));
@@ -530,10 +593,13 @@ static int writeout(struct address_space
  * Default handling if a filesystem does not provide a migration function.
  */
 static int fallback_migrate_page(struct address_space *mapping,
-	struct page *newpage, struct page *page)
+	struct page *newpage, struct page *page, bool sync)
 {
-	if (PageDirty(page))
+	if (PageDirty(page)) {
+		if (!sync)
+			return -EBUSY;
 		return writeout(mapping, page);
+	}
 
 	/*
 	 * Buffers may be managed in a filesystem specific way.
@@ -543,7 +609,7 @@ static int fallback_migrate_page(struct 
 	    !try_to_release_page(page, GFP_KERNEL))
 		return -EAGAIN;
 
-	return migrate_page(mapping, newpage, page);
+	return migrate_page(mapping, newpage, page, sync);
 }
 
 /*
@@ -579,29 +645,18 @@ static int move_to_new_page(struct page 
 
 	mapping = page_mapping(page);
 	if (!mapping)
-		rc = migrate_page(mapping, newpage, page);
-	else {
+		rc = migrate_page(mapping, newpage, page, sync);
+	else if (mapping->a_ops->migratepage)
 		/*
-		 * Do not writeback pages if !sync and migratepage is
-		 * not pointing to migrate_page() which is nonblocking
-		 * (swapcache/tmpfs uses migratepage = migrate_page).
+		 * Most pages have a mapping and most filesystems provide a
+		 * migratepage callback. Anonymous pages are part of swap
+		 * space which also has its own migratepage callback. This
+		 * is the most common path for page migration.
 		 */
-		if (PageDirty(page) && !sync &&
-		    mapping->a_ops->migratepage != migrate_page)
-			rc = -EBUSY;
-		else if (mapping->a_ops->migratepage)
-			/*
-			 * Most pages have a mapping and most filesystems
-			 * should provide a migration function. Anonymous
-			 * pages are part of swap space which also has its
-			 * own migration function. This is the most common
-			 * path for page migration.
-			 */
-			rc = mapping->a_ops->migratepage(mapping,
-							newpage, page);
-		else
-			rc = fallback_migrate_page(mapping, newpage, page);
-	}
+		rc = mapping->a_ops->migratepage(mapping,
+						newpage, page, sync);
+	else
+		rc = fallback_migrate_page(mapping, newpage, page, sync);
 
 	if (rc) {
 		newpage->mapping = NULL;
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
mm-__count_immobile_pages-make-sure-the-node-is-online.patch


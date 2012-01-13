From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:35:24 -0800
Message-ID: <20120113203525.44F9720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57647 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759065Ab2AMUf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:35:28 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23684eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:35:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: introduce sync-light migration for use by compaction
has been removed from the -mm tree.  Its filename was
     mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: introduce sync-light migration for use by compaction

This patch adds a lightweight sync migrate operation MIGRATE_SYNC_LIGHT
mode that avoids writing back pages to backing storage.  Async compaction
maps to MIGRATE_ASYNC while sync compaction maps to MIGRATE_SYNC_LIGHT. 
For other migrate_pages users such as memory hotplug, MIGRATE_SYNC is
used.

This avoids sync compaction stalling for an excessive length of time,
particularly when copying files to a USB stick where there might be a
large number of dirty pages backed by a filesystem that does not support
->writepages.

[aarcange@redhat.com: This patch is heavily based on Andrea's work]
[akpm@linux-foundation.org: fix fs/nfs/write.c build]
[akpm@linux-foundation.org: fix fs/btrfs/disk-io.c build]
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

 fs/btrfs/disk-io.c      |    5 +-
 fs/hugetlbfs/inode.c    |    2 
 fs/nfs/internal.h       |    2 
 fs/nfs/write.c          |    4 -
 include/linux/fs.h      |    6 +-
 include/linux/migrate.h |   23 ++++++++---
 mm/compaction.c         |    2 
 mm/memory-failure.c     |    2 
 mm/memory_hotplug.c     |    2 
 mm/mempolicy.c          |    2 
 mm/migrate.c            |   78 ++++++++++++++++++++------------------
 11 files changed, 76 insertions(+), 52 deletions(-)

diff -puN fs/btrfs/disk-io.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction fs/btrfs/disk-io.c
--- a/fs/btrfs/disk-io.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction
+++ a/fs/btrfs/disk-io.c
@@ -872,7 +872,8 @@ static int btree_submit_bio_hook(struct 
 
 #ifdef CONFIG_MIGRATION
 static int btree_migratepage(struct address_space *mapping,
-			struct page *newpage, struct page *page, bool sync)
+			struct page *newpage, struct page *page,
+			enum migrate_mode mode)
 {
 	/*
 	 * we can't safely write a btree page from here,
@@ -887,7 +888,7 @@ static int btree_migratepage(struct addr
 	if (page_has_private(page) &&
 	    !try_to_release_page(page, GFP_KERNEL))
 		return -EAGAIN;
-	return migrate_page(mapping, newpage, page, sync);
+	return migrate_page(mapping, newpage, page, mode);
 }
 #endif
 
diff -puN fs/hugetlbfs/inode.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction
+++ a/fs/hugetlbfs/inode.c
@@ -584,7 +584,7 @@ static int hugetlbfs_set_page_dirty(stru
 
 static int hugetlbfs_migrate_page(struct address_space *mapping,
 				struct page *newpage, struct page *page,
-				bool sync)
+				enum migrate_mode mode)
 {
 	int rc;
 
diff -puN fs/nfs/internal.h~mm-compaction-introduce-sync-light-migration-for-use-by-compaction fs/nfs/internal.h
--- a/fs/nfs/internal.h~mm-compaction-introduce-sync-light-migration-for-use-by-compaction
+++ a/fs/nfs/internal.h
@@ -332,7 +332,7 @@ void nfs_commit_release_pages(struct nfs
 
 #ifdef CONFIG_MIGRATION
 extern int nfs_migrate_page(struct address_space *,
-		struct page *, struct page *, bool);
+		struct page *, struct page *, enum migrate_mode);
 #else
 #define nfs_migrate_page NULL
 #endif
diff -puN fs/nfs/write.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction fs/nfs/write.c
--- a/fs/nfs/write.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction
+++ a/fs/nfs/write.c
@@ -1688,7 +1688,7 @@ out_error:
 
 #ifdef CONFIG_MIGRATION
 int nfs_migrate_page(struct address_space *mapping, struct page *newpage,
-		struct page *page, bool sync)
+		struct page *page, enum migrate_mode mode)
 {
 	/*
 	 * If PagePrivate is set, then the page is currently associated with
@@ -1703,7 +1703,7 @@ int nfs_migrate_page(struct address_spac
 
 	nfs_fscache_release_page(page, GFP_KERNEL);
 
-	return migrate_page(mapping, newpage, page, sync);
+	return migrate_page(mapping, newpage, page, mode);
 }
 #endif
 
diff -puN include/linux/fs.h~mm-compaction-introduce-sync-light-migration-for-use-by-compaction include/linux/fs.h
--- a/include/linux/fs.h~mm-compaction-introduce-sync-light-migration-for-use-by-compaction
+++ a/include/linux/fs.h
@@ -525,6 +525,7 @@ enum positive_aop_returns {
 struct page;
 struct address_space;
 struct writeback_control;
+enum migrate_mode;
 
 struct iov_iter {
 	const struct iovec *iov;
@@ -614,7 +615,7 @@ struct address_space_operations {
 	 * is false, it must not block.
 	 */
 	int (*migratepage) (struct address_space *,
-			struct page *, struct page *, bool);
+			struct page *, struct page *, enum migrate_mode);
 	int (*launder_page) (struct page *);
 	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
 					unsigned long);
@@ -2540,7 +2541,8 @@ extern int generic_check_addressable(uns
 
 #ifdef CONFIG_MIGRATION
 extern int buffer_migrate_page(struct address_space *,
-				struct page *, struct page *, bool);
+				struct page *, struct page *,
+				enum migrate_mode);
 #else
 #define buffer_migrate_page NULL
 #endif
diff -puN include/linux/migrate.h~mm-compaction-introduce-sync-light-migration-for-use-by-compaction include/linux/migrate.h
--- a/include/linux/migrate.h~mm-compaction-introduce-sync-light-migration-for-use-by-compaction
+++ a/include/linux/migrate.h
@@ -6,18 +6,31 @@
 
 typedef struct page *new_page_t(struct page *, unsigned long private, int **);
 
+/*
+ * MIGRATE_ASYNC means never block
+ * MIGRATE_SYNC_LIGHT in the current implementation means to allow blocking
+ *	on most operations but not ->writepage as the potential stall time
+ *	is too significant
+ * MIGRATE_SYNC will block when migrating pages
+ */
+enum migrate_mode {
+	MIGRATE_ASYNC,
+	MIGRATE_SYNC_LIGHT,
+	MIGRATE_SYNC,
+};
+
 #ifdef CONFIG_MIGRATION
 #define PAGE_MIGRATION 1
 
 extern void putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
-			struct page *, struct page *, bool);
+			struct page *, struct page *, enum migrate_mode);
 extern int migrate_pages(struct list_head *l, new_page_t x,
 			unsigned long private, bool offlining,
-			bool sync);
+			enum migrate_mode mode);
 extern int migrate_huge_pages(struct list_head *l, new_page_t x,
 			unsigned long private, bool offlining,
-			bool sync);
+			enum migrate_mode mode);
 
 extern int fail_migrate_page(struct address_space *,
 			struct page *, struct page *);
@@ -36,10 +49,10 @@ extern int migrate_huge_page_move_mappin
 static inline void putback_lru_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private, bool offlining,
-		bool sync) { return -ENOSYS; }
+		enum migrate_mode mode) { return -ENOSYS; }
 static inline int migrate_huge_pages(struct list_head *l, new_page_t x,
 		unsigned long private, bool offlining,
-		bool sync) { return -ENOSYS; }
+		enum migrate_mode mode) { return -ENOSYS; }
 
 static inline int migrate_prep(void) { return -ENOSYS; }
 static inline int migrate_prep_local(void) { return -ENOSYS; }
diff -puN mm/compaction.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction mm/compaction.c
--- a/mm/compaction.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction
+++ a/mm/compaction.c
@@ -557,7 +557,7 @@ static int compact_zone(struct zone *zon
 		nr_migrate = cc->nr_migratepages;
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
 				(unsigned long)cc, false,
-				cc->sync);
+				cc->sync ? MIGRATE_SYNC_LIGHT : MIGRATE_ASYNC);
 		update_nr_listpages(cc);
 		nr_remaining = cc->nr_migratepages;
 
diff -puN mm/memory-failure.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction mm/memory-failure.c
--- a/mm/memory-failure.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction
+++ a/mm/memory-failure.c
@@ -1557,7 +1557,7 @@ int soft_offline_page(struct page *page,
 					    page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
-								0, true);
+							0, MIGRATE_SYNC);
 		if (ret) {
 			putback_lru_pages(&pagelist);
 			pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
diff -puN mm/memory_hotplug.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction
+++ a/mm/memory_hotplug.c
@@ -809,7 +809,7 @@ do_migrate_range(unsigned long start_pfn
 		}
 		/* this function returns # of failed pages */
 		ret = migrate_pages(&source, hotremove_migrate_alloc, 0,
-								true, true);
+							true, MIGRATE_SYNC);
 		if (ret)
 			putback_lru_pages(&source);
 	}
diff -puN mm/mempolicy.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction mm/mempolicy.c
--- a/mm/mempolicy.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction
+++ a/mm/mempolicy.c
@@ -942,7 +942,7 @@ static int migrate_to_node(struct mm_str
 
 	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, new_node_page, dest,
-								false, true);
+							false, MIGRATE_SYNC);
 		if (err)
 			putback_lru_pages(&pagelist);
 	}
diff -puN mm/migrate.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction mm/migrate.c
--- a/mm/migrate.c~mm-compaction-introduce-sync-light-migration-for-use-by-compaction
+++ a/mm/migrate.c
@@ -218,12 +218,13 @@ out:
 
 #ifdef CONFIG_BLOCK
 /* Returns true if all buffers are successfully locked */
-static bool buffer_migrate_lock_buffers(struct buffer_head *head, bool sync)
+static bool buffer_migrate_lock_buffers(struct buffer_head *head,
+							enum migrate_mode mode)
 {
 	struct buffer_head *bh = head;
 
 	/* Simple case, sync compaction */
-	if (sync) {
+	if (mode != MIGRATE_ASYNC) {
 		do {
 			get_bh(bh);
 			lock_buffer(bh);
@@ -259,7 +260,7 @@ static bool buffer_migrate_lock_buffers(
 }
 #else
 static inline bool buffer_migrate_lock_buffers(struct buffer_head *head,
-								bool sync)
+							enum migrate_mode mode)
 {
 	return true;
 }
@@ -275,7 +276,7 @@ static inline bool buffer_migrate_lock_b
  */
 static int migrate_page_move_mapping(struct address_space *mapping,
 		struct page *newpage, struct page *page,
-		struct buffer_head *head, bool sync)
+		struct buffer_head *head, enum migrate_mode mode)
 {
 	int expected_count;
 	void **pslot;
@@ -311,7 +312,8 @@ static int migrate_page_move_mapping(str
 	 * the mapping back due to an elevated page count, we would have to
 	 * block waiting on other references to be dropped.
 	 */
-	if (!sync && head && !buffer_migrate_lock_buffers(head, sync)) {
+	if (mode == MIGRATE_ASYNC && head &&
+			!buffer_migrate_lock_buffers(head, mode)) {
 		page_unfreeze_refs(page, expected_count);
 		spin_unlock_irq(&mapping->tree_lock);
 		return -EAGAIN;
@@ -472,13 +474,14 @@ EXPORT_SYMBOL(fail_migrate_page);
  * Pages are locked upon entry and exit.
  */
 int migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page, bool sync)
+		struct page *newpage, struct page *page,
+		enum migrate_mode mode)
 {
 	int rc;
 
 	BUG_ON(PageWriteback(page));	/* Writeback must be complete */
 
-	rc = migrate_page_move_mapping(mapping, newpage, page, NULL, sync);
+	rc = migrate_page_move_mapping(mapping, newpage, page, NULL, mode);
 
 	if (rc)
 		return rc;
@@ -495,17 +498,17 @@ EXPORT_SYMBOL(migrate_page);
  * exist.
  */
 int buffer_migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page, bool sync)
+		struct page *newpage, struct page *page, enum migrate_mode mode)
 {
 	struct buffer_head *bh, *head;
 	int rc;
 
 	if (!page_has_buffers(page))
-		return migrate_page(mapping, newpage, page, sync);
+		return migrate_page(mapping, newpage, page, mode);
 
 	head = page_buffers(page);
 
-	rc = migrate_page_move_mapping(mapping, newpage, page, head, sync);
+	rc = migrate_page_move_mapping(mapping, newpage, page, head, mode);
 
 	if (rc)
 		return rc;
@@ -515,8 +518,8 @@ int buffer_migrate_page(struct address_s
 	 * with an IRQ-safe spinlock held. In the sync case, the buffers
 	 * need to be locked now
 	 */
-	if (sync)
-		BUG_ON(!buffer_migrate_lock_buffers(head, sync));
+	if (mode != MIGRATE_ASYNC)
+		BUG_ON(!buffer_migrate_lock_buffers(head, mode));
 
 	ClearPagePrivate(page);
 	set_page_private(newpage, page_private(page));
@@ -593,10 +596,11 @@ static int writeout(struct address_space
  * Default handling if a filesystem does not provide a migration function.
  */
 static int fallback_migrate_page(struct address_space *mapping,
-	struct page *newpage, struct page *page, bool sync)
+	struct page *newpage, struct page *page, enum migrate_mode mode)
 {
 	if (PageDirty(page)) {
-		if (!sync)
+		/* Only writeback pages in full synchronous migration */
+		if (mode != MIGRATE_SYNC)
 			return -EBUSY;
 		return writeout(mapping, page);
 	}
@@ -609,7 +613,7 @@ static int fallback_migrate_page(struct 
 	    !try_to_release_page(page, GFP_KERNEL))
 		return -EAGAIN;
 
-	return migrate_page(mapping, newpage, page, sync);
+	return migrate_page(mapping, newpage, page, mode);
 }
 
 /*
@@ -624,7 +628,7 @@ static int fallback_migrate_page(struct 
  *  == 0 - success
  */
 static int move_to_new_page(struct page *newpage, struct page *page,
-					int remap_swapcache, bool sync)
+				int remap_swapcache, enum migrate_mode mode)
 {
 	struct address_space *mapping;
 	int rc;
@@ -645,7 +649,7 @@ static int move_to_new_page(struct page 
 
 	mapping = page_mapping(page);
 	if (!mapping)
-		rc = migrate_page(mapping, newpage, page, sync);
+		rc = migrate_page(mapping, newpage, page, mode);
 	else if (mapping->a_ops->migratepage)
 		/*
 		 * Most pages have a mapping and most filesystems provide a
@@ -654,9 +658,9 @@ static int move_to_new_page(struct page 
 		 * is the most common path for page migration.
 		 */
 		rc = mapping->a_ops->migratepage(mapping,
-						newpage, page, sync);
+						newpage, page, mode);
 	else
-		rc = fallback_migrate_page(mapping, newpage, page, sync);
+		rc = fallback_migrate_page(mapping, newpage, page, mode);
 
 	if (rc) {
 		newpage->mapping = NULL;
@@ -671,7 +675,7 @@ static int move_to_new_page(struct page 
 }
 
 static int __unmap_and_move(struct page *page, struct page *newpage,
-				int force, bool offlining, bool sync)
+			int force, bool offlining, enum migrate_mode mode)
 {
 	int rc = -EAGAIN;
 	int remap_swapcache = 1;
@@ -680,7 +684,7 @@ static int __unmap_and_move(struct page 
 	struct anon_vma *anon_vma = NULL;
 
 	if (!trylock_page(page)) {
-		if (!force || !sync)
+		if (!force || mode == MIGRATE_ASYNC)
 			goto out;
 
 		/*
@@ -726,10 +730,12 @@ static int __unmap_and_move(struct page 
 
 	if (PageWriteback(page)) {
 		/*
-		 * For !sync, there is no point retrying as the retry loop
-		 * is expected to be too short for PageWriteback to be cleared
+		 * Only in the case of a full syncronous migration is it
+		 * necessary to wait for PageWriteback. In the async case,
+		 * the retry loop is too short and in the sync-light case,
+		 * the overhead of stalling is too much
 		 */
-		if (!sync) {
+		if (mode != MIGRATE_SYNC) {
 			rc = -EBUSY;
 			goto uncharge;
 		}
@@ -800,7 +806,7 @@ static int __unmap_and_move(struct page 
 
 skip_unmap:
 	if (!page_mapped(page))
-		rc = move_to_new_page(newpage, page, remap_swapcache, sync);
+		rc = move_to_new_page(newpage, page, remap_swapcache, mode);
 
 	if (rc && remap_swapcache)
 		remove_migration_ptes(page, page);
@@ -823,7 +829,8 @@ out:
  * to the newly allocated page in newpage.
  */
 static int unmap_and_move(new_page_t get_new_page, unsigned long private,
-			struct page *page, int force, bool offlining, bool sync)
+			struct page *page, int force, bool offlining,
+			enum migrate_mode mode)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -843,7 +850,7 @@ static int unmap_and_move(new_page_t get
 		if (unlikely(split_huge_page(page)))
 			goto out;
 
-	rc = __unmap_and_move(page, newpage, force, offlining, sync);
+	rc = __unmap_and_move(page, newpage, force, offlining, mode);
 out:
 	if (rc != -EAGAIN) {
 		/*
@@ -891,7 +898,8 @@ out:
  */
 static int unmap_and_move_huge_page(new_page_t get_new_page,
 				unsigned long private, struct page *hpage,
-				int force, bool offlining, bool sync)
+				int force, bool offlining,
+				enum migrate_mode mode)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -904,7 +912,7 @@ static int unmap_and_move_huge_page(new_
 	rc = -EAGAIN;
 
 	if (!trylock_page(hpage)) {
-		if (!force || !sync)
+		if (!force || mode != MIGRATE_SYNC)
 			goto out;
 		lock_page(hpage);
 	}
@@ -915,7 +923,7 @@ static int unmap_and_move_huge_page(new_
 	try_to_unmap(hpage, TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
 
 	if (!page_mapped(hpage))
-		rc = move_to_new_page(new_hpage, hpage, 1, sync);
+		rc = move_to_new_page(new_hpage, hpage, 1, mode);
 
 	if (rc)
 		remove_migration_ptes(hpage, hpage);
@@ -958,7 +966,7 @@ out:
  */
 int migrate_pages(struct list_head *from,
 		new_page_t get_new_page, unsigned long private, bool offlining,
-		bool sync)
+		enum migrate_mode mode)
 {
 	int retry = 1;
 	int nr_failed = 0;
@@ -979,7 +987,7 @@ int migrate_pages(struct list_head *from
 
 			rc = unmap_and_move(get_new_page, private,
 						page, pass > 2, offlining,
-						sync);
+						mode);
 
 			switch(rc) {
 			case -ENOMEM:
@@ -1009,7 +1017,7 @@ out:
 
 int migrate_huge_pages(struct list_head *from,
 		new_page_t get_new_page, unsigned long private, bool offlining,
-		bool sync)
+		enum migrate_mode mode)
 {
 	int retry = 1;
 	int nr_failed = 0;
@@ -1026,7 +1034,7 @@ int migrate_huge_pages(struct list_head 
 
 			rc = unmap_and_move_huge_page(get_new_page,
 					private, page, pass > 2, offlining,
-					sync);
+					mode);
 
 			switch(rc) {
 			case -ENOMEM:
@@ -1155,7 +1163,7 @@ set_status:
 	err = 0;
 	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, new_page_node,
-				(unsigned long)pm, 0, true);
+				(unsigned long)pm, 0, MIGRATE_SYNC);
 		if (err)
 			putback_lru_pages(&pagelist);
 	}
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
mm-__count_immobile_pages-make-sure-the-node-is-online.patch


From: akpm@linux-foundation.org
Subject: [merged] mm-add-replace_page_cache_page-function.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:34:07 -0700
Message-ID: <201103232037.p2NKbhIw028261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933349Ab1CWUzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: add replace_page_cache_page() function
has been removed from the -mm tree.  Its filename was
     mm-add-replace_page_cache_page-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add replace_page_cache_page() function
From: Miklos Szeredi <mszeredi@suse.cz>

This function basically does:

     remove_from_page_cache(old);
     page_cache_release(old);
     add_to_page_cache_locked(new);

Except it does this atomically, so there's no possibility for the "add" to
fail because of a race.

If memory cgroups are enabled, then the memory cgroup charge is also moved
from the old page to the new.

This function is currently used by fuse to move pages into the page cache
on read, instead of copying the page contents.

[minchan.kim@gmail.com: add freepage() hook to replace_page_cache_page()]
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dev.c              |   10 ++---
 include/linux/memcontrol.h |    4 +-
 include/linux/pagemap.h    |    1 
 mm/filemap.c               |   70 +++++++++++++++++++++++++++++++++++
 mm/memcontrol.c            |    4 +-
 mm/migrate.c               |    2 -
 6 files changed, 80 insertions(+), 11 deletions(-)

diff -puN fs/fuse/dev.c~mm-add-replace_page_cache_page-function fs/fuse/dev.c
--- a/fs/fuse/dev.c~mm-add-replace_page_cache_page-function
+++ a/fs/fuse/dev.c
@@ -737,14 +737,12 @@ static int fuse_try_move_page(struct fus
 	if (WARN_ON(PageMlocked(oldpage)))
 		goto out_fallback_unlock;
 
-	remove_from_page_cache(oldpage);
-	page_cache_release(oldpage);
-
-	err = add_to_page_cache_locked(newpage, mapping, index, GFP_KERNEL);
+	err = replace_page_cache_page(oldpage, newpage, GFP_KERNEL);
 	if (err) {
-		printk(KERN_WARNING "fuse_try_move_page: failed to add page");
-		goto out_fallback_unlock;
+		unlock_page(newpage);
+		return err;
 	}
+
 	page_cache_get(newpage);
 
 	if (!(buf->flags & PIPE_BUF_FLAG_LRU))
diff -puN include/linux/memcontrol.h~mm-add-replace_page_cache_page-function include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-add-replace_page_cache_page-function
+++ a/include/linux/memcontrol.h
@@ -96,7 +96,7 @@ extern struct cgroup_subsys_state *mem_c
 
 extern int
 mem_cgroup_prepare_migration(struct page *page,
-	struct page *newpage, struct mem_cgroup **ptr);
+	struct page *newpage, struct mem_cgroup **ptr, gfp_t gfp_mask);
 extern void mem_cgroup_end_migration(struct mem_cgroup *mem,
 	struct page *oldpage, struct page *newpage, bool migration_ok);
 
@@ -249,7 +249,7 @@ static inline struct cgroup_subsys_state
 
 static inline int
 mem_cgroup_prepare_migration(struct page *page, struct page *newpage,
-	struct mem_cgroup **ptr)
+	struct mem_cgroup **ptr, gfp_t gfp_mask)
 {
 	return 0;
 }
diff -puN include/linux/pagemap.h~mm-add-replace_page_cache_page-function include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-add-replace_page_cache_page-function
+++ a/include/linux/pagemap.h
@@ -457,6 +457,7 @@ int add_to_page_cache_lru(struct page *p
 				pgoff_t index, gfp_t gfp_mask);
 extern void remove_from_page_cache(struct page *page);
 extern void __remove_from_page_cache(struct page *page);
+int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask);
 
 /*
  * Like add_to_page_cache_locked, but used to add newly allocated pages:
diff -puN mm/filemap.c~mm-add-replace_page_cache_page-function mm/filemap.c
--- a/mm/filemap.c~mm-add-replace_page_cache_page-function
+++ a/mm/filemap.c
@@ -387,6 +387,76 @@ int filemap_write_and_wait_range(struct 
 EXPORT_SYMBOL(filemap_write_and_wait_range);
 
 /**
+ * replace_page_cache_page - replace a pagecache page with a new one
+ * @old:	page to be replaced
+ * @new:	page to replace with
+ * @gfp_mask:	allocation mode
+ *
+ * This function replaces a page in the pagecache with a new one.  On
+ * success it acquires the pagecache reference for the new page and
+ * drops it for the old page.  Both the old and new pages must be
+ * locked.  This function does not add the new page to the LRU, the
+ * caller must do that.
+ *
+ * The remove + add is atomic.  The only way this function can fail is
+ * memory allocation failure.
+ */
+int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
+{
+	int error;
+	struct mem_cgroup *memcg = NULL;
+
+	VM_BUG_ON(!PageLocked(old));
+	VM_BUG_ON(!PageLocked(new));
+	VM_BUG_ON(new->mapping);
+
+	/*
+	 * This is not page migration, but prepare_migration and
+	 * end_migration does enough work for charge replacement.
+	 *
+	 * In the longer term we probably want a specialized function
+	 * for moving the charge from old to new in a more efficient
+	 * manner.
+	 */
+	error = mem_cgroup_prepare_migration(old, new, &memcg, gfp_mask);
+	if (error)
+		return error;
+
+	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
+	if (!error) {
+		struct address_space *mapping = old->mapping;
+		void (*freepage)(struct page *);
+
+		pgoff_t offset = old->index;
+		freepage = mapping->a_ops->freepage;
+
+		page_cache_get(new);
+		new->mapping = mapping;
+		new->index = offset;
+
+		spin_lock_irq(&mapping->tree_lock);
+		__remove_from_page_cache(old);
+		error = radix_tree_insert(&mapping->page_tree, offset, new);
+		BUG_ON(error);
+		mapping->nrpages++;
+		__inc_zone_page_state(new, NR_FILE_PAGES);
+		if (PageSwapBacked(new))
+			__inc_zone_page_state(new, NR_SHMEM);
+		spin_unlock_irq(&mapping->tree_lock);
+		radix_tree_preload_end();
+		if (freepage)
+			freepage(old);
+		page_cache_release(old);
+		mem_cgroup_end_migration(memcg, old, new, true);
+	} else {
+		mem_cgroup_end_migration(memcg, old, new, false);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(replace_page_cache_page);
+
+/**
  * add_to_page_cache_locked - add a locked page to the pagecache
  * @page:	page to add
  * @mapping:	the page's address_space
diff -puN mm/memcontrol.c~mm-add-replace_page_cache_page-function mm/memcontrol.c
--- a/mm/memcontrol.c~mm-add-replace_page_cache_page-function
+++ a/mm/memcontrol.c
@@ -2883,7 +2883,7 @@ static inline int mem_cgroup_move_swap_a
  * page belongs to.
  */
 int mem_cgroup_prepare_migration(struct page *page,
-	struct page *newpage, struct mem_cgroup **ptr)
+	struct page *newpage, struct mem_cgroup **ptr, gfp_t gfp_mask)
 {
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
@@ -2940,7 +2940,7 @@ int mem_cgroup_prepare_migration(struct 
 		return 0;
 
 	*ptr = mem;
-	ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, ptr, false, PAGE_SIZE);
+	ret = __mem_cgroup_try_charge(NULL, gfp_mask, ptr, false, PAGE_SIZE);
 	css_put(&mem->css);/* drop extra refcnt */
 	if (ret || *ptr == NULL) {
 		if (PageAnon(page)) {
diff -puN mm/migrate.c~mm-add-replace_page_cache_page-function mm/migrate.c
--- a/mm/migrate.c~mm-add-replace_page_cache_page-function
+++ a/mm/migrate.c
@@ -678,7 +678,7 @@ static int unmap_and_move(new_page_t get
 	}
 
 	/* charge against new page */
-	charge = mem_cgroup_prepare_migration(page, newpage, &mem);
+	charge = mem_cgroup_prepare_migration(page, newpage, &mem, GFP_KERNEL);
 	if (charge == -ENOMEM) {
 		rc = -ENOMEM;
 		goto unlock;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch


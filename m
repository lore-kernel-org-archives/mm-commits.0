From: akpm@linux-foundation.org
Subject: + reiser4-adjust-to-the-new-aops.patch added to -mm tree
Date: Mon, 24 Nov 2008 14:08:53 -0800
Message-ID: <200811242208.mAOM8r75015408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643AbYKXWI4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 17:08:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com


The patch titled
     reiser4: adjust to the new aops
has been added to the -mm tree.  Its filename is
     reiser4-adjust-to-the-new-aops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: adjust to the new aops
From: Edward Shishkin <edward.shishkin@gmail.com>

. adjust reiser4 to the new aops (->write_begin, ->write_end)
. add support of loop devices over cryptcompress files.

Signed-off-by: Edward Shishkin<edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/as_ops.c                      |   18 ----
 fs/reiser4/page_cache.c                  |    4 -
 fs/reiser4/plugin/file/cryptcompress.c   |   56 +++++++++++---
 fs/reiser4/plugin/file/file.c            |   61 +++------------
 fs/reiser4/plugin/file/file.h            |   31 ++++---
 fs/reiser4/plugin/file/file_conversion.c |   83 +++++++++++++++++++++
 fs/reiser4/plugin/file_ops.c             |   47 -----------
 fs/reiser4/plugin/object.c               |   16 ++--
 fs/reiser4/plugin/object.h               |    3 
 fs/reiser4/plugin/plugin.h               |    8 +-
 10 files changed, 175 insertions(+), 152 deletions(-)

diff -puN fs/reiser4/as_ops.c~reiser4-adjust-to-the-new-aops fs/reiser4/as_ops.c
--- a/fs/reiser4/as_ops.c~reiser4-adjust-to-the-new-aops
+++ a/fs/reiser4/as_ops.c
@@ -347,24 +347,6 @@ int reiser4_writepages(struct address_sp
 	return inode_file_plugin(mapping->host)->writepages(mapping, wbc);
 }
 
-int reiser4_prepare_write(struct file *file, struct page *page,
-			  unsigned from, unsigned to)
-{
-	return inode_file_plugin(file->f_dentry->d_inode)->prepare_write(file,
-									 page,
-									 from,
-									 to);
-}
-
-int reiser4_commit_write(struct file *file, struct page *page,
-			 unsigned from, unsigned to)
-{
-	return inode_file_plugin(file->f_dentry->d_inode)->commit_write(file,
-									page,
-									from,
-									to);
-}
-
 /* Make Linus happy.
    Local variables:
    c-indentation-style: "K&R"
diff -puN /dev/null /dev/null
diff -puN fs/reiser4/page_cache.c~reiser4-adjust-to-the-new-aops fs/reiser4/page_cache.c
--- a/fs/reiser4/page_cache.c~reiser4-adjust-to-the-new-aops
+++ a/fs/reiser4/page_cache.c
@@ -560,8 +560,8 @@ static struct address_space_operations f
 	.set_page_dirty = formatted_set_page_dirty,
 	/* used for read-ahead. Not applicable */
 	.readpages = NULL,
-	.prepare_write = NULL,
-	.commit_write = NULL,
+	.write_begin = NULL,
+	.write_end = NULL,
 	.bmap = NULL,
 	/* called just before page is being detached from inode mapping and
 	   removed from memory. Called on truncate, cut/squeeze, and
diff -puN /dev/null /dev/null
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-adjust-to-the-new-aops fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-adjust-to-the-new-aops
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -3405,11 +3405,12 @@ static int cryptcompress_truncate(struct
 	return result;
 }
 
-/* Capture an anonymous pager cluster. (Page cluser is
- * anonymous if it contains at least one anonymous page
+/**
+ * Capture a pager cluster.
+ * @clust must be set up by a caller.
  */
-static int capture_anon_page_cluster(struct cluster_handle * clust,
-				     struct inode * inode)
+static int capture_page_cluster(struct cluster_handle * clust,
+				struct inode * inode)
 {
 	int result;
 
@@ -3420,6 +3421,7 @@ static int capture_anon_page_cluster(str
 	result = prepare_logical_cluster(inode, 0, 0, clust, LC_APPOV);
 	if (result)
 		return result;
+
 	set_cluster_pages_dirty(clust, inode);
 	result = checkin_logical_cluster(clust, inode);
 	put_hint_cluster(clust, inode, ZNODE_WRITE_LOCK);
@@ -3502,7 +3504,7 @@ static int capture_anon_pages(struct add
 			break;
 		}
 		move_cluster_forward(&clust, inode, pages[0]->index);
-		result = capture_anon_page_cluster(&clust, inode);
+		result = capture_page_cluster(&clust, inode);
 
 		put_found_pages(pages, found); /* find_anon_page_cluster */
 		if (result)
@@ -3743,18 +3745,48 @@ int release_cryptcompress(struct inode *
 }
 
 /* plugin->prepare_write */
-int prepare_write_cryptcompress(struct file *file, struct page *page,
-				unsigned from, unsigned to)
+int write_begin_cryptcompress(struct file *file, struct page *page,
+			  unsigned from, unsigned to)
 {
-	return -EINVAL;
+	return do_prepare_write(file, page, from, to);
 }
 
 /* plugin->commit_write */
-int commit_write_cryptcompress(struct file *file, struct page *page,
-			       unsigned from, unsigned to)
+int write_end_cryptcompress(struct file *file, struct page *page,
+			  unsigned from, unsigned to)
 {
-	BUG();
-	return 0;
+	int ret;
+	hint_t *hint;
+	lock_handle *lh;
+	struct inode * inode;
+	struct cluster_handle clust;
+
+	unlock_page(page);
+
+	inode = page->mapping->host;
+	hint = kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
+	if (hint == NULL)
+		return RETERR(-ENOMEM);
+	hint_init_zero(hint);
+	lh = &hint->lh;
+
+	cluster_init_read(&clust, NULL);
+	clust.hint = hint;
+
+	ret = alloc_cluster_pgset(&clust, cluster_nrpages(inode));
+	if (ret)
+		goto out;
+	clust.index = pg_to_clust(page->index, inode);
+	ret = capture_page_cluster(&clust, inode);
+	if (ret)
+		warning("edward-1557",
+			"Capture failed (inode %llu, result=%i)",
+			(unsigned long long)get_inode_oid(inode), ret);
+ out:
+	done_lh(lh);
+	kfree(hint);
+	put_cluster_handle(&clust);
+	return ret;
 }
 
 /* plugin->bmap */
diff -puN /dev/null /dev/null
diff -puN fs/reiser4/plugin/file/file.c~reiser4-adjust-to-the-new-aops fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-adjust-to-the-new-aops
+++ a/fs/reiser4/plugin/file/file.c
@@ -889,36 +889,12 @@ static int capture_page_and_create_exten
 	return result;
 }
 
-/* this is implementation of method commit_write of struct
-   address_space_operations for unix file plugin */
-int
-commit_write_unix_file(struct file *file, struct page *page,
-		       unsigned from, unsigned to)
+/* plugin->write_end() */
+int write_end_unix_file(struct file *file, struct page *page,
+			unsigned from, unsigned to)
 {
-	reiser4_context *ctx;
-	struct inode *inode;
-	int result;
-
-	assert("umka-3101", file != NULL);
-	assert("umka-3102", page != NULL);
-	assert("umka-3093", PageLocked(page));
-
-	SetPageUptodate(page);
-
-	inode = page->mapping->host;
-	ctx = reiser4_init_context(page->mapping->host->i_sb);
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
-	page_cache_get(page);
 	unlock_page(page);
-	result = capture_page_and_create_extent(page);
-	lock_page(page);
-	page_cache_release(page);
-
-	/* don't commit transaction under inode semaphore */
-	context_set_commit_async(ctx);
-	reiser4_exit_context(ctx);
-	return result;
+	return capture_page_and_create_extent(page);
 }
 
 /*
@@ -2687,32 +2663,23 @@ int delete_object_unix_file(struct inode
 	return reiser4_delete_object_common(inode);
 }
 
-int
-prepare_write_unix_file(struct file *file, struct page *page,
-			unsigned from, unsigned to)
+/* plugin->write_begin() */
+int write_begin_unix_file(struct file *file, struct page *page,
+			  unsigned from, unsigned to)
 {
-	reiser4_context *ctx;
-	struct unix_file_info *uf_info;
 	int ret;
+	struct unix_file_info *info;
 
-	ctx = reiser4_init_context(file->f_dentry->d_inode->i_sb);
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
-
-	uf_info = unix_file_inode_data(file->f_dentry->d_inode);
-	get_exclusive_access(uf_info);
-	ret = find_file_state(file->f_dentry->d_inode, uf_info);
-	if (ret == 0) {
-		if (uf_info->container == UF_CONTAINER_TAILS)
+	info = unix_file_inode_data(file->f_dentry->d_inode);
+	get_exclusive_access(info);
+	ret = find_file_state(file->f_dentry->d_inode, info);
+	if (likely(ret == 0)) {
+		if (info->container == UF_CONTAINER_TAILS)
 			ret = -EINVAL;
 		else
 			ret = do_prepare_write(file, page, from, to);
 	}
-	drop_exclusive_access(uf_info);
-
-	/* don't commit transaction under inode semaphore */
-	context_set_commit_async(ctx);
-	reiser4_exit_context(ctx);
+	drop_exclusive_access(info);
 	return ret;
 }
 
diff -puN /dev/null /dev/null
diff -puN fs/reiser4/plugin/file/file.h~reiser4-adjust-to-the-new-aops fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~reiser4-adjust-to-the-new-aops
+++ a/fs/reiser4/plugin/file/file.h
@@ -59,10 +59,14 @@ int reiser4_readpage(struct file *, stru
 int reiser4_readpages(struct file*, struct address_space*, struct list_head*,
 		      unsigned);
 int reiser4_writepages(struct address_space *, struct writeback_control *);
-int reiser4_prepare_write(struct file *, struct page *, unsigned from,
-			  unsigned to);
-int reiser4_commit_write(struct file *, struct page *, unsigned from,
-			 unsigned to);
+int reiser4_write_begin_careful(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned flags,
+				struct page **pagep, void **fsdata);
+int reiser4_write_end_careful(struct file *file,
+			      struct address_space *mapping,
+			      loff_t pos, unsigned len, unsigned copied,
+			      struct page *page, void *fsdata);
 sector_t reiser4_bmap_careful(struct address_space *, sector_t lblock);
 
 /*
@@ -87,12 +91,13 @@ int release_unix_file(struct inode *, st
 
 /* private address space operations */
 int readpage_unix_file(struct file *, struct page *);
-int readpages_unix_file(struct file*, struct address_space*, struct list_head*, unsigned);
+int readpages_unix_file(struct file*, struct address_space*, struct list_head*,
+			unsigned);
 int writepages_unix_file(struct address_space *, struct writeback_control *);
-int prepare_write_unix_file(struct file *, struct page *, unsigned from,
-			    unsigned to);
-int commit_write_unix_file(struct file *, struct page *, unsigned from,
-			   unsigned to);
+int write_begin_unix_file(struct file *file, struct page *page,
+			  unsigned from, unsigned to);
+int write_end_unix_file(struct file *file, struct page *page,
+			unsigned from, unsigned to);
 sector_t bmap_unix_file(struct address_space *, sector_t lblock);
 
 /* other private methods */
@@ -129,10 +134,10 @@ int readpages_cryptcompress(struct file*
 			    struct list_head*, unsigned);
 int writepages_cryptcompress(struct address_space *,
 			     struct writeback_control *);
-int prepare_write_cryptcompress(struct file *, struct page *, unsigned from,
-				unsigned to);
-int commit_write_cryptcompress(struct file *, struct page *, unsigned from,
-			       unsigned to);
+int write_begin_cryptcompress(struct file *file, struct page *page,
+			      unsigned from, unsigned to);
+int write_end_cryptcompress(struct file *file, struct page *page,
+			    unsigned from, unsigned to);
 sector_t bmap_cryptcompress(struct address_space *, sector_t lblock);
 
 /* other private methods */
diff -puN /dev/null /dev/null
diff -puN fs/reiser4/plugin/file/file_conversion.c~reiser4-adjust-to-the-new-aops fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~reiser4-adjust-to-the-new-aops
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -667,6 +667,89 @@ sector_t reiser4_bmap_careful(struct add
 	return PROT_PASSIVE(sector_t, bmap, (mapping, lblock));
 }
 
+int reiser4_write_begin_careful(struct file *file,
+				struct address_space *mapping,
+				loff_t pos,
+				unsigned len,
+				unsigned flags,
+				struct page **pagep,
+				void **fsdata)
+{
+	int ret = 0;
+	unsigned start, end;
+	struct page *page;
+	pgoff_t index;
+	reiser4_context *ctx;
+	struct inode * inode = file->f_dentry->d_inode;
+
+	index = pos >> PAGE_CACHE_SHIFT;
+	start = pos & (PAGE_CACHE_SIZE - 1);
+	end = start + len;
+
+	page = __grab_cache_page(mapping, index);
+	*pagep = page;
+	if (!page)
+		return -ENOMEM;
+
+	ctx = reiser4_init_context(file->f_dentry->d_inode->i_sb);
+	if (IS_ERR(ctx)) {
+		ret = PTR_ERR(ctx);
+		goto out;
+	}
+	ret = PROT_PASSIVE(int, write_begin, (file, page, start, end));
+
+	/* don't commit transaction under inode semaphore */
+	context_set_commit_async(ctx);
+	reiser4_exit_context(ctx);
+ out:
+	if (unlikely(ret)) {
+		unlock_page(page);
+		page_cache_release(page);
+	}
+	return ret;
+}
+
+int reiser4_write_end_careful(struct file *file,
+			      struct address_space *mapping,
+			      loff_t pos,
+			      unsigned len,
+			      unsigned copied,
+			      struct page *page,
+			      void *fsdata)
+{
+	int ret;
+	reiser4_context *ctx;
+	unsigned start, end;
+	struct inode *inode = page->mapping->host;
+
+	assert("umka-3101", file != NULL);
+	assert("umka-3102", page != NULL);
+	assert("umka-3093", PageLocked(page));
+
+	start = pos & (PAGE_CACHE_SIZE - 1);
+	end = start + len;
+
+	flush_dcache_page(page);
+	SetPageUptodate(page);
+
+	ctx = reiser4_init_context(page->mapping->host->i_sb);
+	if (IS_ERR(ctx)){
+		unlock_page(page);
+		ret = PTR_ERR(ctx);
+		goto out;
+	}
+	ret = PROT_PASSIVE(int, write_end, (file, page, start, end));
+
+	/* don't commit transaction under inode semaphore */
+	context_set_commit_async(ctx);
+	reiser4_exit_context(ctx);
+ out:
+	page_cache_release(page);
+	if (!ret)
+		ret = copied;
+	return ret;
+}
+
 /*
  * Wrappers without protection for:
  *
diff -puN /dev/null /dev/null
diff -puN fs/reiser4/plugin/file_ops.c~reiser4-adjust-to-the-new-aops fs/reiser4/plugin/file_ops.c
--- a/fs/reiser4/plugin/file_ops.c~reiser4-adjust-to-the-new-aops
+++ a/fs/reiser4/plugin/file_ops.c
@@ -95,55 +95,12 @@ int reiser4_sync_file_common(struct file
 	return 0;
 }
 
-/* this is common implementation of vfs's sendfile method of struct
-   file_operations
-
-   Reads @count bytes from @file and calls @actor for every page read. This is
-   needed for loop back devices support.
-*/
-#if 0
-ssize_t
-sendfile_common(struct file *file, loff_t *ppos, size_t count,
-		read_actor_t actor, void *target)
-{
-	reiser4_context *ctx;
-	ssize_t result;
-
-	ctx = reiser4_init_context(file->f_dentry->d_inode->i_sb);
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
-	result = generic_file_sendfile(file, ppos, count, actor, target);
-	reiser4_exit_context(ctx);
-	return result;
-}
-#endif  /*  0  */
 
 /* address space operations */
 
-/* this is common implementation of vfs's prepare_write method of struct
-   address_space_operations
-*/
-int
-prepare_write_common(struct file *file, struct page *page, unsigned from,
-		     unsigned to)
-{
-	reiser4_context *ctx;
-	int result;
 
-	ctx = reiser4_init_context(page->mapping->host->i_sb);
-	result = do_prepare_write(file, page, from, to);
-
-	/* don't commit transaction under inode semaphore */
-	context_set_commit_async(ctx);
-	reiser4_exit_context(ctx);
-
-	return result;
-}
-
-/* this is helper for prepare_write_common and prepare_write_unix_file
- */
-int
-do_prepare_write(struct file *file, struct page *page, unsigned from,
+/* this is helper for plugin->write_begin() */
+int do_prepare_write(struct file *file, struct page *page, unsigned from,
 		 unsigned to)
 {
 	int result;
diff -puN /dev/null /dev/null
diff -puN fs/reiser4/plugin/object.c~reiser4-adjust-to-the-new-aops fs/reiser4/plugin/object.c
--- a/fs/reiser4/plugin/object.c~reiser4-adjust-to-the-new-aops
+++ a/fs/reiser4/plugin/object.c
@@ -114,8 +114,8 @@ static struct address_space_operations r
 	.writepages = reiser4_writepages,
 	.set_page_dirty = reiser4_set_page_dirty,
 	.readpages = reiser4_readpages,
-	.prepare_write = reiser4_prepare_write,
-	.commit_write =	reiser4_commit_write,
+	.write_begin = reiser4_write_begin_careful,
+	.write_end = reiser4_write_end_careful,
 	.bmap = reiser4_bmap_careful,
 	.invalidatepage = reiser4_invalidatepage,
 	.releasepage = reiser4_releasepage
@@ -165,8 +165,8 @@ static struct address_space_operations d
 	.writepages = dummyop,
 	.set_page_dirty = bugop,
 	.readpages = bugop,
-	.prepare_write = bugop,
-	.commit_write = bugop,
+	.write_begin = bugop,
+	.write_end = bugop,
 	.bmap = bugop,
 	.invalidatepage = bugop,
 	.releasepage = bugop
@@ -209,8 +209,8 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		.readpage = readpage_unix_file,
 		.readpages = readpages_unix_file,
 		.writepages = writepages_unix_file,
-		.prepare_write = prepare_write_unix_file,
-		.commit_write = commit_write_unix_file,
+		.write_begin = write_begin_unix_file,
+		.write_end = write_end_unix_file,
 		/*
 		 * private a_ops
 		 */
@@ -403,8 +403,8 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		.readpage = readpage_cryptcompress,
 		.readpages = readpages_cryptcompress,
 		.writepages = writepages_cryptcompress,
-		.prepare_write = prepare_write_cryptcompress,
-		.commit_write = commit_write_cryptcompress,
+		.write_begin = write_begin_cryptcompress,
+		.write_end = write_end_cryptcompress,
 
 		.bmap = bmap_cryptcompress,
 
diff -puN /dev/null /dev/null
diff -puN fs/reiser4/plugin/object.h~reiser4-adjust-to-the-new-aops fs/reiser4/plugin/object.h
--- a/fs/reiser4/plugin/object.h~reiser4-adjust-to-the-new-aops
+++ a/fs/reiser4/plugin/object.h
@@ -36,9 +36,6 @@ int reiser4_readdir_common(struct file *
 int reiser4_release_dir_common(struct inode *, struct file *);
 int reiser4_sync_common(struct file *, struct dentry *, int datasync);
 
-/* common implementations of address space operations */
-int prepare_write_common(struct file *, struct page *, unsigned from,
-			 unsigned to);
 
 /* file plugin operations: common implementations */
 int write_sd_by_inode_common(struct inode *);
diff -puN /dev/null /dev/null
diff -puN fs/reiser4/plugin/plugin.h~reiser4-adjust-to-the-new-aops fs/reiser4/plugin/plugin.h
--- a/fs/reiser4/plugin/plugin.h~reiser4-adjust-to-the-new-aops
+++ a/fs/reiser4/plugin/plugin.h
@@ -248,10 +248,10 @@ typedef struct file_plugin {
 			  struct list_head *pages, unsigned nr_pages);
 	int (*writepages)(struct address_space *mapping,
 			  struct writeback_control *wbc);
-	int (*prepare_write)(struct file *file, struct page *page,
-			     unsigned from, unsigned to);
-	int (*commit_write)(struct file *file, struct page *page,
-			    unsigned from, unsigned to);
+	int (*write_begin)(struct file *file, struct page *page,
+			  unsigned from, unsigned to);
+	int (*write_end)(struct file *file, struct page *page,
+			  unsigned from, unsigned to);
 	sector_t (*bmap) (struct address_space * mapping, sector_t lblock);
 	/* other private methods */
 	/* save inode cached stat-data onto disk. It was called
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

reiser4-vfs-add-super_operationssync_inodes-2.patch
reiser4.patch
reiser4-fix-handling-enospc-cryptcompress.patch
reiser4-fix-handling-enospc-unix_file.patch
reiser4-fix-kill_hook_internal.patch
reiser4-semaphore-fix.patch
reiser4-compile-warning-cleanups.patch
reiser4-use-wake_up_process-instead-of-wake_up-when-possible.patch
reiser4-track-upstream-changes.patch
reiser4-adjust-to-the-new-aops.patch


From: akpm@linux-foundation.org
Subject: - reiser4-use-generic-file-read.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:02 -0800
Message-ID: <200703060200.l26204Hc008697@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46617 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965678AbXCFCAX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:00:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zam@namesys.com, reiser@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: use generic file read
has been removed from the -mm tree.  Its filename was
     reiser4-use-generic-file-read.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: use generic file read
From: Alexaner Zarochentsev <zam@namesys.com>

Use generic file read routine for reiser4 unix files build of extent items. 
For packed files and partially converted files the old read code is used.

Signed-off-by: Alexander Zarochentsev <zam@namesys.com>
Cc: Hans Reiser <reiser@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/file/file.c            |  206 ++++++++++++++++-----
 fs/reiser4/plugin/file/file.h            |    1 
 fs/reiser4/plugin/item/extent.h          |    1 
 fs/reiser4/plugin/item/extent_file_ops.c |   20 +-
 fs/reiser4/plugin/object.c               |    3 
 5 files changed, 177 insertions(+), 54 deletions(-)

diff -puN fs/reiser4/plugin/file/file.c~reiser4-use-generic-file-read fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-use-generic-file-read
+++ a/fs/reiser4/plugin/file/file.c
@@ -24,6 +24,7 @@
 
 
 static int unpack(struct file *file, struct inode *inode, int forever);
+static void drop_access(unix_file_info_t *);
 
 /* get unix file plugin specific portion of inode */
 unix_file_info_t *unix_file_inode_data(const struct inode *inode)
@@ -1582,6 +1583,115 @@ int readpage_unix_file_nolock(struct fil
 	return result;
 }
 
+struct uf_readpages_context {
+	lock_handle lh;
+	coord_t coord;
+};
+
+/* A callback function for readpages_unix_file/read_cache_pages.
+ * It assumes that the file is build of extents.
+ *
+ * @data -- a pointer to reiser4_readpages_context object,
+ *            to save the twig lock and the coord between
+ *            read_cache_page iterations.
+ * @page -- page to start read.
+ */
+static int uf_readpages_filler(void * data, struct page * page)
+{
+	struct uf_readpages_context *rc = data;
+	jnode * node;
+	int ret = 0;
+	reiser4_extent *ext;
+	__u64 ext_index;
+	int cbk_done = 0;
+	struct address_space * mapping = page->mapping;
+
+	if (PageUptodate(page)) {
+		unlock_page(page);
+		return 0;
+	}
+	node = jnode_of_page(page);
+	if (unlikely(IS_ERR(node))) {
+		ret = PTR_ERR(node);
+		goto err;
+	}
+	if (rc->lh.node == 0) {
+		/* no twig lock  - have to do tree search. */
+		reiser4_key key;
+	repeat:
+		unlock_page(page);
+		key_by_inode_and_offset_common(
+			mapping->host, page_offset(page), &key);
+		ret = coord_by_key(
+			&get_super_private(mapping->host->i_sb)->tree,
+			&key, &rc->coord, &rc->lh,
+			ZNODE_READ_LOCK, FIND_EXACT,
+			TWIG_LEVEL, TWIG_LEVEL, CBK_UNIQUE, NULL);
+		lock_page(page);
+		cbk_done = 1;
+		if (ret != 0)
+			goto err;
+	}
+	ret = zload(rc->coord.node);
+	if (ret)
+		goto err;
+	if (!coord_is_existing_item(&rc->coord) ||
+	    !item_is_extent(&rc->coord)) {
+		zrelse(rc->coord.node);
+		ret = RETERR(-EIO);
+		goto err;
+	}
+	ext = extent_by_coord(&rc->coord);
+	ext_index = extent_unit_index(&rc->coord);
+	if (page->index < ext_index || page->index >= ext_index + extent_get_width(ext))
+	{
+		/* the page index doesn't belong to the extent unit which the coord points to,
+		 *  -- release the lock and repeat with tree search. */
+		zrelse(rc->coord.node);
+		done_lh(&rc->lh);
+		/* we can be here after a CBK call only in case of corruption of the tree
+		 * or the tree lookup algorithm bug. */
+		if (unlikely(cbk_done)) {
+			ret = RETERR(-EIO);
+			goto err;
+		}
+		goto repeat;
+	}
+	ret = reiser4_do_readpage_extent(ext, page->index - ext_index, page);
+	zrelse(rc->coord.node);
+	if (ret) {
+err:
+		unlock_page(page);
+	}
+	jput(node);
+	return ret;
+}
+
+/**
+ * readpages_unix_file - called by the readahead code, starts reading for each
+ * page of given list of pages
+ */
+int readpages_unix_file(
+	struct file *file, struct address_space *mapping,
+	struct list_head *pages, unsigned nr_pages)
+{
+	reiser4_context *ctx;
+	struct uf_readpages_context rc;
+	int ret;
+
+	ctx = reiser4_init_context(mapping->host->i_sb);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	init_lh(&rc.lh);
+	ret = read_cache_pages(mapping, pages,  uf_readpages_filler, &rc);
+	done_lh(&rc.lh);
+	context_set_commit_async(ctx);
+	/* close the transaction to protect further page allocation from deadlocks */
+	reiser4_txn_restart(ctx);
+	reiser4_exit_context(ctx);
+	return ret;
+}
+
 /**
  * readpage_unix_file - readpage of struct address_space_operations
  * @file: file @page belongs to
@@ -1673,6 +1783,8 @@ static ssize_t read_file(hint_t *hint, s
 	return (count - flow.length) ? (count - flow.length) : result;
 }
 
+static ssize_t read_unix_file_container_tails(struct file*, char __user*, size_t, loff_t*);
+
 /**
  * read_unix_file - read of struct file_operations
  * @file: file to read from
@@ -1687,14 +1799,9 @@ ssize_t read_unix_file(struct file *file
 		       loff_t *off)
 {
 	reiser4_context *ctx;
-	int result;
+	ssize_t result;
 	struct inode *inode;
-	hint_t *hint;
 	unix_file_info_t *uf_info;
-	size_t count, left;
-	ssize_t read;
-	reiser4_block_nr needed;
-	loff_t size;
 
 	if (unlikely(read_amount == 0))
 		return 0;
@@ -1707,19 +1814,57 @@ ssize_t read_unix_file(struct file *file
 	ctx = reiser4_init_context(inode->i_sb);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
+	uf_info = unix_file_inode_data(inode);
+	if (uf_info->container == UF_CONTAINER_UNKNOWN) {
+		get_exclusive_access(uf_info);
+		result = find_file_state(inode, uf_info);
+		if (unlikely(result != 0))
+			goto out;
+	} else
+		get_nonexclusive_access(uf_info);
+	result = reiser4_grab_space_force(unix_file_estimate_read(inode, read_amount),
+					  BA_CAN_COMMIT);
+	if (unlikely(result != 0))
+		goto out;
+	if (uf_info->container == UF_CONTAINER_EXTENTS){
+		result = do_sync_read(file, buf, read_amount, off);
+	} else if (uf_info->container == UF_CONTAINER_TAILS ||
+		   reiser4_inode_get_flag(inode, REISER4_PART_IN_CONV) ||
+		   reiser4_inode_get_flag(inode, REISER4_PART_MIXED)) {
+		result = read_unix_file_container_tails(file, buf, read_amount, off);
+	} else {
+		assert("zam-1085", uf_info->container == UF_CONTAINER_EMPTY);
+		result = 0;
+	}
+out:
+       drop_access(uf_info);
+       context_set_commit_async(ctx);
+       reiser4_exit_context(ctx);
+       return result;
+}
+
+static ssize_t read_unix_file_container_tails(
+	struct file *file, char __user *buf, size_t read_amount, loff_t *off)
+{
+	int result;
+	struct inode *inode;
+	hint_t *hint;
+	unix_file_info_t *uf_info;
+	size_t count, read, left;
+	loff_t size;
+
+	assert("umka-072", file != NULL);
+	assert("umka-074", off != NULL);
+	inode = file->f_dentry->d_inode;
+	assert("vs-972", !reiser4_inode_get_flag(inode, REISER4_NO_SD));
 
 	hint = kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
-	if (hint == NULL) {
-		context_set_commit_async(ctx);
-		reiser4_exit_context(ctx);
+	if (hint == NULL)
 		return RETERR(-ENOMEM);
-	}
 
 	result = load_file_hint(file, hint);
 	if (result) {
 		kfree(hint);
-		context_set_commit_async(ctx);
-		reiser4_exit_context(ctx);
 		return result;
 	}
 
@@ -1728,31 +1873,20 @@ ssize_t read_unix_file(struct file *file
 	uf_info = unix_file_inode_data(inode);
 	while (left > 0) {
 		reiser4_txn_restart_current();
-
-		get_nonexclusive_access(uf_info);
-
 		size = i_size_read(inode);
-		if (*off >= size) {
+		if (*off >= size)
 			/* position to read from is past the end of file */
-			drop_nonexclusive_access(uf_info);
 			break;
-		}
 		if (*off + left > size)
 			left = size - *off;
-
 		/* faultin user page */
 		result = fault_in_pages_writeable(buf, left > PAGE_CACHE_SIZE ? PAGE_CACHE_SIZE : left);
-		if (result) {
-			drop_nonexclusive_access(uf_info);
-			break;
-		}
+		if (result)
+			return RETERR(-EFAULT);
 
 		read = read_file(hint, file, buf,
 				 left > PAGE_CACHE_SIZE ? PAGE_CACHE_SIZE : left,
 				 off);
-
- 		drop_nonexclusive_access(uf_info);
-
 		if (read < 0) {
 			result = read;
 			break;
@@ -1765,25 +1899,11 @@ ssize_t read_unix_file(struct file *file
 		/* total number of read bytes */
 		count += read;
 	}
+	done_lh(&hint->lh);
 	save_file_hint(file, hint);
 	kfree(hint);
-
-	if (count) {
-		/*
-		 * something was read. Grab space for stat data update and
-		 * update atime
-		 */
-		needed = unix_file_estimate_read(inode, read_amount);
-		result = reiser4_grab_space_force(needed, BA_CAN_COMMIT);
-		if (result == 0)
-			file_accessed(file);
-		else
-			warning("", "failed to grab space for atime update");
-	}
-
-	context_set_commit_async(ctx);
-	reiser4_exit_context(ctx);
-
+	if (count)
+		file_accessed(file);
 	/* return number of read bytes or error code if nothing is read */
 	return count ? count : result;
 }
diff -puN fs/reiser4/plugin/file/file.h~reiser4-use-generic-file-read fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~reiser4-use-generic-file-read
+++ a/fs/reiser4/plugin/file/file.h
@@ -29,6 +29,7 @@ ssize_t sendfile_unix_file(struct file *
 /* address space operations */
 int readpage_unix_file(struct file *, struct page *);
 int readpage_unix_file_nolock(struct file *, struct page *);
+int readpages_unix_file(struct file*, struct address_space*, struct list_head*, unsigned);
 int writepages_unix_file(struct address_space *, struct writeback_control *);
 int prepare_write_unix_file(struct file *, struct page *, unsigned from,
 			    unsigned to);
diff -puN fs/reiser4/plugin/item/extent.h~reiser4-use-generic-file-read fs/reiser4/plugin/item/extent.h
--- a/fs/reiser4/plugin/item/extent.h~reiser4-use-generic-file-read
+++ a/fs/reiser4/plugin/item/extent.h
@@ -137,6 +137,7 @@ int reiser4_read_extent(struct file *, f
 int reiser4_readpage_extent(void *, struct page *);
 void reiser4_readpages_extent(void *, struct address_space *,
 			      struct list_head *pages);
+int reiser4_do_readpage_extent(reiser4_extent*, reiser4_block_nr, struct page*);
 reiser4_key *append_key_extent(const coord_t *, reiser4_key *);
 void init_coord_extension_extent(uf_coord_t *, loff_t offset);
 int get_block_address_extent(const coord_t *, sector_t block,
diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-use-generic-file-read fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-use-generic-file-read
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -1118,9 +1118,8 @@ static inline void zero_page(struct page
 	unlock_page(page);
 }
 
-static int
-do_readpage_extent(reiser4_extent * ext, reiser4_block_nr pos,
-		   struct page *page)
+int reiser4_do_readpage_extent(reiser4_extent * ext, reiser4_block_nr pos,
+			       struct page *page)
 {
 	jnode *j;
 	struct address_space *mapping;
@@ -1263,8 +1262,8 @@ static int readahead_readpage_extent(voi
 
 	assert("vs-1281", page->index == ext_coord->expected_page);
 	result =
-	    do_readpage_extent(ext_by_ext_coord(uf_coord),
-			       ext_coord->pos_in_unit, page);
+	    reiser4_do_readpage_extent(ext_by_ext_coord(uf_coord),
+				       ext_coord->pos_in_unit, page);
 	if (!result)
 		move_coord_pages(coord, ext_coord, 1);
 	return result;
@@ -1351,9 +1350,9 @@ static int extent_readpage_filler(void *
 
 	lock_page(page);
 	if (!PageUptodate(page)) {
-		result = do_readpage_extent(ext_by_ext_coord(ext_coord),
-					    ext_coord->extension.extent.
-					    pos_in_unit, page);
+		result = reiser4_do_readpage_extent(ext_by_ext_coord(ext_coord),
+						    ext_coord->extension.extent.
+						    pos_in_unit, page);
 		if (result)
 			unlock_page(page);
 	} else {
@@ -1607,8 +1606,9 @@ int reiser4_readpage_extent(void *vp, st
 	       get_key_objectid(item_key_by_coord(coord, &key)));
 	check_uf_coord(uf_coord, NULL);
 
-	return do_readpage_extent(ext_by_ext_coord(uf_coord),
-				  uf_coord->extension.extent.pos_in_unit, page);
+	return reiser4_do_readpage_extent(
+		ext_by_ext_coord(uf_coord),
+		uf_coord->extension.extent.pos_in_unit, page);
 }
 
 /**
diff -puN fs/reiser4/plugin/object.c~reiser4-use-generic-file-read fs/reiser4/plugin/object.c
--- a/fs/reiser4/plugin/object.c~reiser4-use-generic-file-read
+++ a/fs/reiser4/plugin/object.c
@@ -101,6 +101,7 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.llseek = generic_file_llseek,
 			.read = read_unix_file,
 			.write = write_unix_file,
+			.aio_read = generic_file_aio_read,
 			.ioctl = ioctl_unix_file,
 			.mmap = mmap_unix_file,
 			.open = open_unix_file,
@@ -114,7 +115,7 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.sync_page = block_sync_page,
 			.writepages = writepages_unix_file,
 			.set_page_dirty = reiser4_set_page_dirty,
-			.readpages = reiser4_readpages,
+			.readpages = readpages_unix_file,
 			.prepare_write = prepare_write_unix_file,
 			.commit_write =	commit_write_unix_file,
 			.bmap = bmap_unix_file,
_

Patches currently in -mm which might be from zam@namesys.com are

reiser4.patch
reiser4-use-generic-file-read.patch
reiser4-use-generic-file-read-fix-readpages-unix-file.patch
reiser4-simplify-reading-of-partially-converted-files.patch
reiser4-use-page_offset.patch
reiser4-use-reiser4_gfp_mask_get-in-reiser4-inode-allocation.patch
reiser4-re-add-page_count-check-to-reiser4_releasepage.patch
reiser4-restore-fibmap-ioctl-support-for-packed-files.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch

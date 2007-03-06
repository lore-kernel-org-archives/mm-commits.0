From: akpm@linux-foundation.org
Subject: - reiser4-simplify-reading-of-partially-converted-files.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:09 -0800
Message-ID: <200703060200.l26209Nj008708@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46624 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965688AbXCFCA0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:00:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zam@namesys.com, reiser@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: simplify reading of partially converted files
has been removed from the -mm tree.  Its filename was
     reiser4-simplify-reading-of-partially-converted-files.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: simplify reading of partially converted files
From: Alexaner Zarochentsev <zam@namesys.com>

reading of partially converted files simplified a lot by removing support for
readahead.  related functions are cleaned up.

Signed-off-by: Alexander Zarochentsev <zam@namesys.com>
Cc: Hans Reiser <reiser@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/as_ops.c                      |   58 ----
 fs/reiser4/fsdata.h                      |    9 
 fs/reiser4/plugin/file/cryptcompress.c   |   36 +-
 fs/reiser4/plugin/file/cryptcompress.h   |    1 
 fs/reiser4/plugin/file/file.c            |   26 -
 fs/reiser4/plugin/file/file.h            |    1 
 fs/reiser4/plugin/file/tail_conversion.c |    9 
 fs/reiser4/plugin/item/ctail.c           |    8 
 fs/reiser4/plugin/item/ctail.h           |    2 
 fs/reiser4/plugin/item/extent.h          |    2 
 fs/reiser4/plugin/item/extent_file_ops.c |  294 ---------------------
 fs/reiser4/plugin/item/item.c            |    3 
 fs/reiser4/plugin/item/item.h            |    2 
 fs/reiser4/plugin/object.c               |    2 
 fs/reiser4/vfs_ops.h                     |    2 
 15 files changed, 42 insertions(+), 413 deletions(-)

diff -puN fs/reiser4/as_ops.c~reiser4-simplify-reading-of-partially-converted-files fs/reiser4/as_ops.c
--- a/fs/reiser4/as_ops.c~reiser4-simplify-reading-of-partially-converted-files
+++ a/fs/reiser4/as_ops.c
@@ -96,64 +96,6 @@ int reiser4_set_page_dirty(struct page *
 	return 0;
 }
 
-static int filler(void *vp, struct page *page)
-{
-	return page->mapping->a_ops->readpage(vp, page);
-}
-
-/**
- * reiser4_readpages - submit read for a set of pages
- * @file: file to read
- * @mapping: address space
- * @pages: list of pages to submit read for
- * @nr_pages: number of pages no the list
- *
- * Operation of struct address_space_operations. This implementation is used by
- * unix and cryptcompress file plugins.
- *
- * Calls read_cache_pages or readpages hook if it is set.
- */
-int
-reiser4_readpages(struct file *file, struct address_space *mapping,
-		  struct list_head *pages, unsigned nr_pages)
-{
-	reiser4_context *ctx;
-	reiser4_file_fsdata *fsdata;
-
-	ctx = reiser4_init_context(mapping->host->i_sb);
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
-
-	fsdata = reiser4_get_file_fsdata(file);
-	if (IS_ERR(fsdata)) {
-		reiser4_exit_context(ctx);
-		return PTR_ERR(fsdata);
-	}
-
-	if (fsdata->ra2.readpages)
-		fsdata->ra2.readpages(mapping, pages, fsdata->ra2.data);
-	else {
-		/*
-		 * filler (reiser4 readpage method) may involve tree search
-		 * which is not allowed when lock stack is not clean. If lock
-		 * stack is not clean - do nothing.
-		 */
-		if (lock_stack_isclean(get_current_lock_stack()))
-			read_cache_pages(mapping, pages, filler, file);
-		else {
-			while (!list_empty(pages)) {
-				struct page *victim;
-
-				victim = list_entry(pages->prev, struct page, lru);
-				list_del(&victim->lru);
-				page_cache_release(victim);
-			}
-		}
-	}
-	reiser4_exit_context(ctx);
-	return 0;
-}
-
 /* ->invalidatepage method for reiser4 */
 
 /*
diff -puN fs/reiser4/fsdata.h~reiser4-simplify-reading-of-partially-converted-files fs/reiser4/fsdata.h
--- a/fs/reiser4/fsdata.h~reiser4-simplify-reading-of-partially-converted-files
+++ a/fs/reiser4/fsdata.h
@@ -118,15 +118,6 @@ typedef struct reiser4_file_fsdata {
 	struct {
 		hint_t hint;
 	} reg;
-	/* */
-	struct {
-		/* this is called by reiser4_readpages if set */
-		void (*readpages) (struct address_space *,
-				   struct list_head * pages, void *data);
-		/* This is set by reiser4_read_extent before
-		   calling page_cache_readahead */
-		void *data;
-	} ra2;
 	struct reiser4_file_ra_state ra1;
 
 } reiser4_file_fsdata;
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-simplify-reading-of-partially-converted-files fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-simplify-reading-of-partially-converted-files
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -2810,23 +2810,25 @@ ssize_t write_cryptcompress(struct file 
 	return result;
 }
 
-static void readpages_cryptcompress(struct address_space *mapping,
-				    struct list_head *pages,
-				    void *data)
+int readpages_cryptcompress(struct file *file, struct address_space *mapping,
+			    struct list_head *pages, unsigned nr_pages)
 {
-	file_plugin *fplug;
-	item_plugin *iplug;
-
-	assert("edward-1112", mapping != NULL);
-	assert("edward-1113", mapping->host != NULL);
-
-	fplug = inode_file_plugin(mapping->host);
-	assert("edward-1114", fplug == file_plugin_by_id(CRC_FILE_PLUGIN_ID));
-	iplug = item_plugin_by_id(CTAIL_ID);
-
-	iplug->s.file.readpages(data, mapping, pages);
+	reiser4_context * ctx;
+	int ret;
 
-	return;
+	ctx = reiser4_init_context(mapping->host->i_sb);
+	if (IS_ERR(ctx)) {
+		ret = PTR_ERR(ctx);
+		goto err;
+	}
+	/* crc files can be built of ctail items only */
+	ret = readpages_ctail(file, mapping, pages);
+	reiser4_exit_context(ctx);
+	if (ret) {
+err:
+		put_pages_list(pages);
+	}
+	return ret;
 }
 
 static reiser4_block_nr cryptcompress_estimate_read(struct inode *inode)
@@ -2854,7 +2856,6 @@ ssize_t read_cryptcompress(struct file *
 	ssize_t result;
 	struct inode *inode;
 	reiser4_context *ctx;
-	reiser4_file_fsdata *fsdata;
 	cryptcompress_info_t *info;
 	reiser4_block_nr needed;
 
@@ -2875,9 +2876,6 @@ ssize_t read_cryptcompress(struct file *
 		reiser4_exit_context(ctx);
 		return result;
 	}
-	fsdata = reiser4_get_file_fsdata(file);
-	fsdata->ra2.data = file;
-	fsdata->ra2.readpages = readpages_cryptcompress;
 
 	down_read(&info->lock);
 	LOCK_CNT_INC(inode_sem_r);
diff -puN fs/reiser4/plugin/file/cryptcompress.h~reiser4-simplify-reading-of-partially-converted-files fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~reiser4-simplify-reading-of-partially-converted-files
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -464,6 +464,7 @@ extern int do_readpage_ctail(struct inod
 			     struct page * page);
 extern int ctail_insert_unprepped_cluster(reiser4_cluster_t * clust,
 					  struct inode * inode);
+extern int readpages_cryptcompress(struct file*, struct address_space*, struct list_head*, unsigned);
 int bind_cryptcompress(struct inode *child, struct inode *parent);
 void destroy_inode_cryptcompress(struct inode * inode);
 crypto_stat_t * inode_crypto_stat (struct inode * inode);
diff -puN fs/reiser4/plugin/file/file.c~reiser4-simplify-reading-of-partially-converted-files fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-simplify-reading-of-partially-converted-files
+++ a/fs/reiser4/plugin/file/file.c
@@ -423,11 +423,6 @@ cut_file_items(struct inode *inode, loff
 
 int find_or_create_extent(struct page *page);
 
-static int filler(void *vp, struct page *page)
-{
-	return readpage_unix_file_nolock(vp, page);
-}
-
 /* part of truncate_file_body: it is called when truncate is used to make file
    shorter */
 static int shorten_file(struct inode *inode, loff_t new_size)
@@ -480,7 +475,7 @@ static int shorten_file(struct inode *in
 
 	/* last page is partially truncated - zero its content */
 	index = (inode->i_size >> PAGE_CACHE_SHIFT);
-	page = read_cache_page(inode->i_mapping, index, filler, NULL);
+	page = read_mapping_page(inode->i_mapping, index, NULL);
 	if (IS_ERR(page)) {
 		/*
 		 * the below does up(sbinfo->delete_mutex). Do not get
@@ -1418,7 +1413,7 @@ int sync_unix_file(struct file *file, st
  * Compose a key and search for item containing information about @page
  * data. If item is found - its readpage method is called.
  */
-int readpage_unix_file_nolock(struct file *file, struct page *page)
+int readpage_unix_file(struct file *file, struct page *page)
 {
 	reiser4_context *ctx;
 	int result;
@@ -1682,8 +1677,10 @@ int readpages_unix_file(
 	int ret;
 
 	ctx = reiser4_init_context(mapping->host->i_sb);
-	if (IS_ERR(ctx))
+	if (IS_ERR(ctx)) {
+		put_pages_list(pages);
 		return PTR_ERR(ctx);
+	}
 	init_lh(&rc.lh);
 	ret = read_cache_pages(mapping, pages,  uf_readpages_filler, &rc);
 	done_lh(&rc.lh);
@@ -1694,19 +1691,6 @@ int readpages_unix_file(
 	return ret;
 }
 
-/**
- * readpage_unix_file - readpage of struct address_space_operations
- * @file: file @page belongs to
- * @page: page to read
- *
- * Get non exclusive access to a file to avoid races with truncate. If page is
- * out of file - return error. Call readpage_unix_file_nolock to do the rest.
- */
-int readpage_unix_file(struct file *file, struct page *page)
-{
-	return readpage_unix_file_nolock(file, page);
-}
-
 static reiser4_block_nr unix_file_estimate_read(struct inode *inode,
 						loff_t count UNUSED_ARG)
 {
diff -puN fs/reiser4/plugin/file/file.h~reiser4-simplify-reading-of-partially-converted-files fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~reiser4-simplify-reading-of-partially-converted-files
+++ a/fs/reiser4/plugin/file/file.h
@@ -28,7 +28,6 @@ ssize_t sendfile_unix_file(struct file *
 
 /* address space operations */
 int readpage_unix_file(struct file *, struct page *);
-int readpage_unix_file_nolock(struct file *, struct page *);
 int readpages_unix_file(struct file*, struct address_space*, struct list_head*, unsigned);
 int writepages_unix_file(struct address_space *, struct writeback_control *);
 int prepare_write_unix_file(struct file *, struct page *, unsigned from,
diff -puN fs/reiser4/plugin/file/tail_conversion.c~reiser4-simplify-reading-of-partially-converted-files fs/reiser4/plugin/file/tail_conversion.c
--- a/fs/reiser4/plugin/file/tail_conversion.c~reiser4-simplify-reading-of-partially-converted-files
+++ a/fs/reiser4/plugin/file/tail_conversion.c
@@ -544,11 +544,6 @@ static int reserve_extent2tail_iteration
 	     inode_file_plugin(inode)->estimate.update(inode), BA_CAN_COMMIT);
 }
 
-static int filler(void *vp, struct page *page)
-{
-	return readpage_unix_file_nolock(vp, page);
-}
-
 /* for every page of file: read page, cut part of extent pointing to this page,
    put data of page tree by tail item */
 int extent2tail(unix_file_info_t *uf_info)
@@ -609,8 +604,8 @@ int extent2tail(unix_file_info_t *uf_inf
 			reiser4_update_sd(inode);
 		}
 
-		page = read_cache_page(inode->i_mapping,
-				       (unsigned)(i + start_page), filler, NULL);
+		page = read_mapping_page(inode->i_mapping,
+					 (unsigned)(i + start_page), NULL);
 		if (IS_ERR(page)) {
 			result = PTR_ERR(page);
 			break;
diff -puN fs/reiser4/plugin/item/ctail.c~reiser4-simplify-reading-of-partially-converted-files fs/reiser4/plugin/item/ctail.c
--- a/fs/reiser4/plugin/item/ctail.c~reiser4-simplify-reading-of-partially-converted-files
+++ a/fs/reiser4/plugin/item/ctail.c
@@ -736,8 +736,7 @@ assert("edward-214", ergo(!list_empty(pa
    and start reads against them.
    FIXME-EDWARD: this function should return errors?
 */
-void
-readpages_ctail(void *vp, struct address_space *mapping,
+int readpages_ctail(struct file *file, struct address_space *mapping,
 		struct list_head *pages)
 {
 	int ret = 0;
@@ -754,10 +753,11 @@ readpages_ctail(void *vp, struct address
 				  list_to_next_page(pages)->index));
 	pagevec_init(&lru_pvec, 0);
 	cluster_init_read(&clust, NULL);
-	clust.file = vp;
+	clust.file = file;
 	hint = kmalloc(sizeof(*hint), GFP_KERNEL);
 	if (hint == NULL) {
 		warning("vs-28", "failed to allocate hint");
+		ret = RETERR(-ENOMEM);
 		goto exit1;
 	}
 	clust.hint = hint;
@@ -824,7 +824,7 @@ readpages_ctail(void *vp, struct address
 	}
 	put_cluster_handle(&clust);
 	pagevec_lru_add(&lru_pvec);
-	return;
+	return ret;
 }
 
 /*
diff -puN fs/reiser4/plugin/item/ctail.h~reiser4-simplify-reading-of-partially-converted-files fs/reiser4/plugin/item/ctail.h
--- a/fs/reiser4/plugin/item/ctail.h~reiser4-simplify-reading-of-partially-converted-files
+++ a/fs/reiser4/plugin/item/ctail.h
@@ -62,7 +62,7 @@ int check_ctail(const coord_t * coord, c
 /* plugin->u.item.s.* */
 int read_ctail(struct file *, flow_t *, hint_t *);
 int readpage_ctail(void *, struct page *);
-void readpages_ctail(void *, struct address_space *, struct list_head *);
+int readpages_ctail(struct file *, struct address_space *, struct list_head *);
 reiser4_key *append_key_ctail(const coord_t *, reiser4_key *);
 int create_hook_ctail(const coord_t * coord, void *arg);
 int kill_hook_ctail(const coord_t *, pos_in_node_t, pos_in_node_t,
diff -puN fs/reiser4/plugin/item/extent.h~reiser4-simplify-reading-of-partially-converted-files fs/reiser4/plugin/item/extent.h
--- a/fs/reiser4/plugin/item/extent.h~reiser4-simplify-reading-of-partially-converted-files
+++ a/fs/reiser4/plugin/item/extent.h
@@ -135,8 +135,6 @@ ssize_t reiser4_write_extent(struct file
 			     size_t, loff_t *);
 int reiser4_read_extent(struct file *, flow_t *, hint_t *);
 int reiser4_readpage_extent(void *, struct page *);
-void reiser4_readpages_extent(void *, struct address_space *,
-			      struct list_head *pages);
 int reiser4_do_readpage_extent(reiser4_extent*, reiser4_block_nr, struct page*);
 reiser4_key *append_key_extent(const coord_t *, reiser4_key *);
 void init_coord_extension_extent(uf_coord_t *, loff_t offset);
diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-simplify-reading-of-partially-converted-files fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-simplify-reading-of-partially-converted-files
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -1193,235 +1193,6 @@ int reiser4_do_readpage_extent(reiser4_e
 	return 0;
 }
 
-static int
-move_coord_pages(coord_t * coord, extent_coord_extension_t * ext_coord,
-		 unsigned count)
-{
-	reiser4_extent *ext;
-
-	ext_coord->expected_page += count;
-
-	ext = ext_by_offset(coord->node, ext_coord->ext_offset);
-
-	do {
-		if (ext_coord->pos_in_unit + count < ext_coord->width) {
-			ext_coord->pos_in_unit += count;
-			break;
-		}
-
-		if (coord->unit_pos == ext_coord->nr_units - 1) {
-			coord->between = AFTER_UNIT;
-			return 1;
-		}
-
-		/* shift to next unit */
-		count -= (ext_coord->width - ext_coord->pos_in_unit);
-		coord->unit_pos++;
-		ext_coord->pos_in_unit = 0;
-		ext_coord->ext_offset += sizeof(reiser4_extent);
-		ext++;
-		ON_DEBUG(ext_coord->extent = *ext);
-		ext_coord->width = extent_get_width(ext);
-	} while (1);
-
-	return 0;
-}
-
-static int readahead_readpage_extent(void *vp, struct page *page)
-{
-	int result;
-	uf_coord_t *uf_coord;
-	coord_t *coord;
-	extent_coord_extension_t *ext_coord;
-
-	uf_coord = vp;
-	coord = &uf_coord->coord;
-
-	if (coord->between != AT_UNIT) {
-		unlock_page(page);
-		return RETERR(-EINVAL);
-	}
-
-	ext_coord = &uf_coord->extension.extent;
-	if (ext_coord->expected_page != page->index) {
-		/* read_cache_pages skipped few pages. Try to adjust coord to page */
-		assert("vs-1269", page->index > ext_coord->expected_page);
-		if (move_coord_pages
-		    (coord, ext_coord,
-		     page->index - ext_coord->expected_page)) {
-			/* extent pointing to this page is not here */
-			unlock_page(page);
-			return RETERR(-EINVAL);
-		}
-
-		assert("vs-1274", offset_is_in_unit(coord,
-						    (loff_t) page->
-						    index << PAGE_CACHE_SHIFT));
-		ext_coord->expected_page = page->index;
-	}
-
-	assert("vs-1281", page->index == ext_coord->expected_page);
-	result =
-	    reiser4_do_readpage_extent(ext_by_ext_coord(uf_coord),
-				       ext_coord->pos_in_unit, page);
-	if (!result)
-		move_coord_pages(coord, ext_coord, 1);
-	return result;
-}
-
-static int move_coord_forward(uf_coord_t *ext_coord)
-{
-	coord_t *coord;
-	extent_coord_extension_t *extension;
-
-	check_uf_coord(ext_coord, NULL);
-
-	extension = &ext_coord->extension.extent;
-	extension->pos_in_unit++;
-	if (extension->pos_in_unit < extension->width)
-		/* stay within the same extent unit */
-		return 0;
-
-	coord = &ext_coord->coord;
-
-	/* try to move to the next extent unit */
-	coord->unit_pos++;
-	if (coord->unit_pos < extension->nr_units) {
-		/* went to the next extent unit */
-		reiser4_extent *ext;
-
-		extension->pos_in_unit = 0;
-		extension->ext_offset += sizeof(reiser4_extent);
-		ext = ext_by_offset(coord->node, extension->ext_offset);
-		ON_DEBUG(extension->extent = *ext);
-		extension->width = extent_get_width(ext);
-		return 0;
-	}
-
-	/* there is no units in the item anymore */
-	return 1;
-}
-
-/* this is called by read_cache_pages for each of readahead pages */
-static int extent_readpage_filler(void *data, struct page *page)
-{
-	hint_t *hint;
-	loff_t offset;
-	reiser4_key key;
-	uf_coord_t *ext_coord;
-	int result;
-
-	offset = (loff_t) page->index << PAGE_CACHE_SHIFT;
-	key_by_inode_and_offset_common(page->mapping->host, offset, &key);
-
-	hint = (hint_t *) data;
-	ext_coord = &hint->ext_coord;
-
-	BUG_ON(PageUptodate(page));
-	unlock_page(page);
-
-	if (hint_validate(hint, &key, 1 /* check key */ , ZNODE_READ_LOCK) != 0) {
-		result = coord_by_key(current_tree, &key, &ext_coord->coord,
-				      ext_coord->lh, ZNODE_READ_LOCK,
-				      FIND_EXACT, TWIG_LEVEL,
-				      TWIG_LEVEL, CBK_UNIQUE, NULL);
-		if (result != CBK_COORD_FOUND) {
-			reiser4_unset_hint(hint);
-			return result;
-		}
-		ext_coord->valid = 0;
-	}
-
-	if (zload(ext_coord->coord.node)) {
-		reiser4_unset_hint(hint);
-		return RETERR(-EIO);
-	}
-	if (!item_is_extent(&ext_coord->coord)) {
-		/* tail conversion is running in parallel */
-		zrelse(ext_coord->coord.node);
-		reiser4_unset_hint(hint);
-		return RETERR(-EIO);
-	}
-
-	if (ext_coord->valid == 0)
-		init_coord_extension_extent(ext_coord, offset);
-
-	check_uf_coord(ext_coord, &key);
-
-	lock_page(page);
-	if (!PageUptodate(page)) {
-		result = reiser4_do_readpage_extent(ext_by_ext_coord(ext_coord),
-						    ext_coord->extension.extent.
-						    pos_in_unit, page);
-		if (result)
-			unlock_page(page);
-	} else {
-		unlock_page(page);
-		result = 0;
-	}
-	if (!result && move_coord_forward(ext_coord) == 0) {
-		set_key_offset(&key, offset + PAGE_CACHE_SIZE);
-		reiser4_set_hint(hint, &key, ZNODE_READ_LOCK);
-	} else
-		reiser4_unset_hint(hint);
-	zrelse(ext_coord->coord.node);
-	return result;
-}
-
-/* this is called by reiser4_readpages */
-static void
-extent_readpages_hook(struct address_space *mapping, struct list_head *pages,
-		      void *data)
-{
-	/* FIXME: try whether having reiser4_read_cache_pages improves anything */
-	read_cache_pages(mapping, pages, extent_readpage_filler, data);
-}
-
-static int
-call_page_cache_readahead(struct address_space *mapping, struct file *file,
-			  hint_t * hint,
-			  unsigned long page_nr,
-			  unsigned long ra_pages, struct file_ra_state *ra)
-{
-	reiser4_file_fsdata *fsdata;
-	int result;
-
-	fsdata = reiser4_get_file_fsdata(file);
-	if (IS_ERR(fsdata))
-		return page_nr;
-	fsdata->ra2.data = hint;
-	fsdata->ra2.readpages = extent_readpages_hook;
-
-	result = page_cache_readahead(mapping, ra, file, page_nr, ra_pages);
-	fsdata->ra2.readpages = NULL;
-	return result;
-}
-
-/* this is called when readahead did not */
-static int call_readpage(struct file *file, struct page *page)
-{
-	int result;
-
-	result = readpage_unix_file_nolock(file, page);
-	if (result)
-		return result;
-
-	lock_page(page);
-	if (!PageUptodate(page)) {
-		unlock_page(page);
-		page_detach_jnode(page, page->mapping, page->index);
-		warning("jmacd-97178", "page is not up to date");
-		return RETERR(-EIO);
-	}
-	unlock_page(page);
-	return 0;
-}
-
-static int filler(void *vp, struct page *page)
-{
-	return readpage_unix_file_nolock(vp, page);
-}
-
 /* Implements plugin->u.item.s.file.read operation for extent items. */
 int reiser4_read_extent(struct file *file, flow_t *flow, hint_t *hint)
 {
@@ -1434,8 +1205,7 @@ int reiser4_read_extent(struct file *fil
 	uf_coord_t *uf_coord;
 	coord_t *coord;
 	extent_coord_extension_t *ext_coord;
-	unsigned long nr_pages, prev_page;
-	struct file_ra_state ra;
+	unsigned long nr_pages;
 	char *kaddr;
 
 	assert("vs-1353", current_blocksize == PAGE_CACHE_SIZE);
@@ -1476,50 +1246,20 @@ int reiser4_read_extent(struct file *fil
 	reiser4_set_hint(hint, &flow->key, ZNODE_READ_LOCK);
 	/* &hint->lh is done-ed */
 
-	ra = file->f_ra;
-	prev_page = ra.prev_page;
 	do {
 		reiser4_txn_restart_current();
-		if (next_page == cur_page)
-			next_page =
-			    call_page_cache_readahead(mapping, file, hint,
-						      cur_page, nr_pages, &ra);
-
-		page = find_get_page(mapping, cur_page);
-		if (unlikely(page == NULL)) {
-			handle_ra_miss(mapping, &ra, cur_page);
-			page = read_cache_page(mapping, cur_page, filler, file);
-			if (IS_ERR(page))
-				return PTR_ERR(page);
-			lock_page(page);
-			if (!PageUptodate(page)) {
-				unlock_page(page);
-				page_detach_jnode(page, mapping, cur_page);
-				page_cache_release(page);
-				warning("jmacd-97178",
-					"extent_read: page is not up to date");
-				return RETERR(-EIO);
-			}
+		page = read_mapping_page(mapping, cur_page, file);
+		if (IS_ERR(page))
+			return PTR_ERR(page);
+		lock_page(page);
+		if (!PageUptodate(page)) {
 			unlock_page(page);
-		} else {
-			if (!PageUptodate(page)) {
-				lock_page(page);
-
-				assert("", page->mapping == mapping);
-				if (PageUptodate(page))
-					unlock_page(page);
-				else {
-					result = call_readpage(file, page);
-					if (result) {
-						page_cache_release(page);
-						return RETERR(result);
-					}
-				}
-			}
-			if (prev_page != cur_page)
-				mark_page_accessed(page);
-			prev_page = cur_page;
+			page_cache_release(page);
+			warning("jmacd-97178", "extent_read: page is not up to date");
+			return RETERR(-EIO);
 		}
+		mark_page_accessed(page);
+		unlock_page(page);
 
 		/* If users can be writing to this page using arbitrary virtual
 		   addresses, take care about potential aliasing before reading
@@ -1563,22 +1303,10 @@ int reiser4_read_extent(struct file *fil
 		nr_pages--;
 	} while (flow->length);
 
-	file->f_ra = ra;
 	return 0;
 }
 
 /*
-  plugin->u.item.s.file.readpages
-*/
-void reiser4_readpages_extent(void *vp, struct address_space *mapping,
-			      struct list_head *pages)
-{
-	assert("vs-1739", 0);
-	if (vp)
-		read_cache_pages(mapping, pages, readahead_readpage_extent, vp);
-}
-
-/*
    plugin->s.file.readpage
    reiser4_read->unix_file_read->page_cache_readahead->reiser4_readpage->unix_file_readpage->extent_readpage
    or
diff -puN fs/reiser4/plugin/item/item.c~reiser4-simplify-reading-of-partially-converted-files fs/reiser4/plugin/item/item.c
--- a/fs/reiser4/plugin/item/item.c~reiser4-simplify-reading-of-partially-converted-files
+++ a/fs/reiser4/plugin/item/item.c
@@ -562,7 +562,6 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 				.read = reiser4_read_extent,
 				.readpage = reiser4_readpage_extent,
 				.get_block = get_block_address_extent,
-				.readpages = reiser4_readpages_extent,
 				.append_key = append_key_extent,
 				.init_coord_extension =
 				init_coord_extension_extent
@@ -616,7 +615,6 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 				.read = reiser4_read_tail,
 				.readpage = readpage_tail,
 				.get_block = NULL,
-				.readpages = NULL,
 				.append_key = append_key_tail,
 				.init_coord_extension =
 				init_coord_extension_tail
@@ -671,7 +669,6 @@ item_plugin item_plugins[LAST_ITEM_ID] =
 				.read = read_ctail,
 				.readpage = readpage_ctail,
 				.get_block = get_block_address_tail,
-				.readpages = readpages_ctail,
 				.append_key = append_key_ctail,
 				.init_coord_extension =
 				init_coord_extension_tail
diff -puN fs/reiser4/plugin/item/item.h~reiser4-simplify-reading-of-partially-converted-files fs/reiser4/plugin/item/item.h
--- a/fs/reiser4/plugin/item/item.h~reiser4-simplify-reading-of-partially-converted-files
+++ a/fs/reiser4/plugin/item/item.h
@@ -235,8 +235,6 @@ typedef struct {
 	int (*read) (struct file *, flow_t *, hint_t *);
 	int (*readpage) (void *, struct page *);
 	int (*get_block) (const coord_t *, sector_t, sector_t *);
-	void (*readpages) (void *, struct address_space *,
-			   struct list_head * pages);
 	/*
 	 * key of first byte which is not addressed by the item @coord is set
 	 * to.
diff -puN fs/reiser4/plugin/object.c~reiser4-simplify-reading-of-partially-converted-files fs/reiser4/plugin/object.c
--- a/fs/reiser4/plugin/object.c~reiser4-simplify-reading-of-partially-converted-files
+++ a/fs/reiser4/plugin/object.c
@@ -318,7 +318,7 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.sync_page = block_sync_page,
 			.writepages = writepages_cryptcompress,
 			.set_page_dirty = reiser4_set_page_dirty,
-			.readpages = reiser4_readpages,
+			.readpages = readpages_cryptcompress,
 			.prepare_write = prepare_write_common,
 			.invalidatepage = reiser4_invalidatepage,
 			.releasepage = reiser4_releasepage
diff -puN fs/reiser4/vfs_ops.h~reiser4-simplify-reading-of-partially-converted-files fs/reiser4/vfs_ops.h
--- a/fs/reiser4/vfs_ops.h~reiser4-simplify-reading-of-partially-converted-files
+++ a/fs/reiser4/vfs_ops.h
@@ -22,8 +22,6 @@
 /* address space operations */
 int reiser4_writepage(struct page *, struct writeback_control *);
 int reiser4_set_page_dirty(struct page *);
-int reiser4_readpages(struct file *, struct address_space *,
-		      struct list_head *pages, unsigned nr_pages);
 void reiser4_invalidatepage(struct page *, unsigned long offset);
 int reiser4_releasepage(struct page *, gfp_t);
 
_

Patches currently in -mm which might be from zam@namesys.com are

reiser4.patch
reiser4-simplify-reading-of-partially-converted-files.patch
reiser4-use-page_offset.patch
reiser4-use-reiser4_gfp_mask_get-in-reiser4-inode-allocation.patch
reiser4-re-add-page_count-check-to-reiser4_releasepage.patch
reiser4-restore-fibmap-ioctl-support-for-packed-files.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch

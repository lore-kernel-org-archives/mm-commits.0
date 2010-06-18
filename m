From: akpm@linux-foundation.org
Subject: + gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:31:31 -0700
Message-ID: <201006182331.o5INVV3C029544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab0FRXbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:31:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, chris.mason@oracle.com


The patch titled
     gcc-4.6: btrfs: clean up unused variables -- nonbugs
has been added to the -mm tree.  Its filename is
     gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch

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
Subject: gcc-4.6: btrfs: clean up unused variables -- nonbugs
From: Andi Kleen <andi@firstfloor.org>

These are all the cases where a variable is set, but not read which are
not bugs as far as I can see, but simply leftovers.

Still needs more review.

Found by gcc 4.6's new warnings

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/compression.c  |    2 --
 fs/btrfs/ctree.c        |   20 ++------------------
 fs/btrfs/disk-io.c      |   11 -----------
 fs/btrfs/extent-tree.c  |    2 --
 fs/btrfs/extent_io.c    |    9 ---------
 fs/btrfs/inode.c        |   14 --------------
 fs/btrfs/ioctl.c        |    2 --
 fs/btrfs/ordered-data.c |    2 --
 fs/btrfs/root-tree.c    |    2 --
 fs/btrfs/super.c        |    6 ++----
 fs/btrfs/tree-defrag.c  |    2 --
 fs/btrfs/tree-log.c     |   15 ---------------
 fs/btrfs/volumes.c      |    4 ----
 fs/btrfs/xattr.c        |    2 --
 fs/btrfs/zlib.c         |    5 -----
 15 files changed, 4 insertions(+), 94 deletions(-)

diff -puN fs/btrfs/compression.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs fs/btrfs/compression.c
--- a/fs/btrfs/compression.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs
+++ a/fs/btrfs/compression.c
@@ -163,7 +163,6 @@ fail:
  */
 static void end_compressed_bio_read(struct bio *bio, int err)
 {
-	struct extent_io_tree *tree;
 	struct compressed_bio *cb = bio->bi_private;
 	struct inode *inode;
 	struct page *page;
@@ -187,7 +186,6 @@ static void end_compressed_bio_read(stru
 	/* ok, we're the last bio for this extent, lets start
 	 * the decompression.
 	 */
-	tree = &BTRFS_I(inode)->io_tree;
 	ret = btrfs_zlib_decompress_biovec(cb->compressed_pages,
 					cb->start,
 					cb->orig_bio->bi_io_vec,
diff -puN fs/btrfs/ctree.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs fs/btrfs/ctree.c
--- a/fs/btrfs/ctree.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs
+++ a/fs/btrfs/ctree.c
@@ -200,7 +200,6 @@ int btrfs_copy_root(struct btrfs_trans_h
 		      struct extent_buffer **cow_ret, u64 new_root_objectid)
 {
 	struct extent_buffer *cow;
-	u32 nritems;
 	int ret = 0;
 	int level;
 	struct btrfs_disk_key disk_key;
@@ -210,7 +209,6 @@ int btrfs_copy_root(struct btrfs_trans_h
 	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
 
 	level = btrfs_header_level(buf);
-	nritems = btrfs_header_nritems(buf);
 	if (level == 0)
 		btrfs_item_key(buf, &disk_key, 0);
 	else
@@ -1008,7 +1006,6 @@ static noinline int balance_level(struct
 	int wret;
 	int pslot;
 	int orig_slot = path->slots[level];
-	int err_on_enospc = 0;
 	u64 orig_ptr;
 
 	if (level == 0)
@@ -1071,8 +1068,7 @@ static noinline int balance_level(struct
 	    BTRFS_NODEPTRS_PER_BLOCK(root) / 4)
 		return 0;
 
-	if (btrfs_header_nritems(mid) < 2)
-		err_on_enospc = 1;
+	btrfs_header_nritems(mid);
 
 	left = read_node_slot(root, parent, pslot - 1);
 	if (left) {
@@ -1103,8 +1099,7 @@ static noinline int balance_level(struct
 		wret = push_node_left(trans, root, left, mid, 1);
 		if (wret < 0)
 			ret = wret;
-		if (btrfs_header_nritems(mid) < 2)
-			err_on_enospc = 1;
+		btrfs_header_nritems(mid);
 	}
 
 	/*
@@ -1224,14 +1219,12 @@ static noinline int push_nodes_for_inser
 	int wret;
 	int pslot;
 	int orig_slot = path->slots[level];
-	u64 orig_ptr;
 
 	if (level == 0)
 		return 1;
 
 	mid = path->nodes[level];
 	WARN_ON(btrfs_header_generation(mid) != trans->transid);
-	orig_ptr = btrfs_node_blockptr(mid, orig_slot);
 
 	if (level < BTRFS_MAX_LEVEL - 1)
 		parent = path->nodes[level + 1];
@@ -2534,7 +2527,6 @@ static noinline int __push_leaf_left(str
 {
 	struct btrfs_disk_key disk_key;
 	struct extent_buffer *right = path->nodes[0];
-	int slot;
 	int i;
 	int push_space = 0;
 	int push_items = 0;
@@ -2546,8 +2538,6 @@ static noinline int __push_leaf_left(str
 	u32 this_item_size;
 	u32 old_left_item_size;
 
-	slot = path->slots[1];
-
 	if (empty)
 		nr = right_nritems;
 	else
@@ -3239,7 +3229,6 @@ int btrfs_truncate_item(struct btrfs_tra
 {
 	int ret = 0;
 	int slot;
-	int slot_orig;
 	struct extent_buffer *leaf;
 	struct btrfs_item *item;
 	u32 nritems;
@@ -3249,7 +3238,6 @@ int btrfs_truncate_item(struct btrfs_tra
 	unsigned int size_diff;
 	int i;
 
-	slot_orig = path->slots[0];
 	leaf = path->nodes[0];
 	slot = path->slots[0];
 
@@ -3354,7 +3342,6 @@ int btrfs_extend_item(struct btrfs_trans
 {
 	int ret = 0;
 	int slot;
-	int slot_orig;
 	struct extent_buffer *leaf;
 	struct btrfs_item *item;
 	u32 nritems;
@@ -3363,7 +3350,6 @@ int btrfs_extend_item(struct btrfs_trans
 	unsigned int old_size;
 	int i;
 
-	slot_orig = path->slots[0];
 	leaf = path->nodes[0];
 
 	nritems = btrfs_header_nritems(leaf);
@@ -3696,7 +3682,6 @@ int btrfs_insert_empty_items(struct btrf
 			    struct btrfs_key *cpu_key, u32 *data_size,
 			    int nr)
 {
-	struct extent_buffer *leaf;
 	int ret = 0;
 	int slot;
 	int i;
@@ -3713,7 +3698,6 @@ int btrfs_insert_empty_items(struct btrf
 	if (ret < 0)
 		goto out;
 
-	leaf = path->nodes[0];
 	slot = path->slots[0];
 	BUG_ON(slot < 0);
 
diff -puN fs/btrfs/disk-io.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs fs/btrfs/disk-io.c
--- a/fs/btrfs/disk-io.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs
+++ a/fs/btrfs/disk-io.c
@@ -338,7 +338,6 @@ static int csum_dirty_buffer(struct btrf
 	struct extent_io_tree *tree;
 	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
 	u64 found_start;
-	int found_level;
 	unsigned long len;
 	struct extent_buffer *eb;
 	int ret;
@@ -369,8 +368,6 @@ static int csum_dirty_buffer(struct btrf
 		WARN_ON(1);
 		goto err;
 	}
-	found_level = btrfs_header_level(eb);
-
 	csum_tree_block(root, eb, 0);
 err:
 	free_extent_buffer(eb);
@@ -533,11 +530,9 @@ int btrfs_congested_async(struct btrfs_f
 
 static void run_one_async_start(struct btrfs_work *work)
 {
-	struct btrfs_fs_info *fs_info;
 	struct async_submit_bio *async;
 
 	async = container_of(work, struct  async_submit_bio, work);
-	fs_info = BTRFS_I(async->inode)->root->fs_info;
 	async->submit_bio_start(async->inode, async->rw, async->bio,
 			       async->mirror_num, async->bio_flags,
 			       async->bio_offset);
@@ -850,12 +845,8 @@ struct extent_buffer *read_tree_block(st
 				      u32 blocksize, u64 parent_transid)
 {
 	struct extent_buffer *buf = NULL;
-	struct inode *btree_inode = root->fs_info->btree_inode;
-	struct extent_io_tree *io_tree;
 	int ret;
 
-	io_tree = &BTRFS_I(btree_inode)->io_tree;
-
 	buf = btrfs_find_create_tree_block(root, bytenr, blocksize);
 	if (!buf)
 		return NULL;
@@ -1377,7 +1368,6 @@ static int bio_ready_for_csum(struct bio
 	u64 start = 0;
 	struct page *page;
 	struct extent_io_tree *io_tree = NULL;
-	struct btrfs_fs_info *info = NULL;
 	struct bio_vec *bvec;
 	int i;
 	int ret;
@@ -1396,7 +1386,6 @@ static int bio_ready_for_csum(struct bio
 		buf_len = page->private >> 2;
 		start = page_offset(page) + bvec->bv_offset;
 		io_tree = &BTRFS_I(page->mapping->host)->io_tree;
-		info = BTRFS_I(page->mapping->host)->root->fs_info;
 	}
 	/* are we fully contained in this bio? */
 	if (buf_len <= length)
diff -puN fs/btrfs/extent-tree.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs fs/btrfs/extent-tree.c
--- a/fs/btrfs/extent-tree.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs
+++ a/fs/btrfs/extent-tree.c
@@ -5421,7 +5421,6 @@ static noinline void reada_walk_down(str
 	u64 generation;
 	u64 refs;
 	u64 flags;
-	u64 last = 0;
 	u32 nritems;
 	u32 blocksize;
 	struct btrfs_key key;
@@ -5489,7 +5488,6 @@ reada:
 					   generation);
 		if (ret)
 			break;
-		last = bytenr + blocksize;
 		nread++;
 	}
 	wc->reada_slot = slot;
diff -puN fs/btrfs/extent_io.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs fs/btrfs/extent_io.c
--- a/fs/btrfs/extent_io.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs
+++ a/fs/btrfs/extent_io.c
@@ -1901,10 +1901,8 @@ static int submit_one_bio(int rw, struct
 	struct page *page = bvec->bv_page;
 	struct extent_io_tree *tree = bio->bi_private;
 	u64 start;
-	u64 end;
 
 	start = ((u64)page->index << PAGE_CACHE_SHIFT) + bvec->bv_offset;
-	end = start + bvec->bv_len - 1;
 
 	bio->bi_private = NULL;
 
@@ -2204,7 +2202,6 @@ static int __extent_writepage(struct pag
 	u64 last_byte = i_size_read(inode);
 	u64 block_start;
 	u64 iosize;
-	u64 unlock_start;
 	sector_t sector;
 	struct extent_state *cached_state = NULL;
 	struct extent_map *em;
@@ -2329,7 +2326,6 @@ static int __extent_writepage(struct pag
 		if (tree->ops && tree->ops->writepage_end_io_hook)
 			tree->ops->writepage_end_io_hook(page, start,
 							 page_end, NULL, 1);
-		unlock_start = page_end + 1;
 		goto done;
 	}
 
@@ -2340,7 +2336,6 @@ static int __extent_writepage(struct pag
 			if (tree->ops && tree->ops->writepage_end_io_hook)
 				tree->ops->writepage_end_io_hook(page, cur,
 							 page_end, NULL, 1);
-			unlock_start = page_end + 1;
 			break;
 		}
 		em = epd->get_extent(inode, page, pg_offset, cur,
@@ -2387,7 +2382,6 @@ static int __extent_writepage(struct pag
 
 			cur += iosize;
 			pg_offset += iosize;
-			unlock_start = cur;
 			continue;
 		}
 		/* leave this out until we have a page_mkwrite call */
@@ -2473,7 +2467,6 @@ static int extent_write_cache_pages(stru
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	int scanned = 0;
-	int range_whole = 0;
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
@@ -2482,8 +2475,6 @@ static int extent_write_cache_pages(stru
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
-		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
-			range_whole = 1;
 		scanned = 1;
 	}
 retry:
diff -puN fs/btrfs/inode.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs
+++ a/fs/btrfs/inode.c
@@ -319,8 +319,6 @@ static noinline int compress_file_range(
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
 	u64 num_bytes;
-	u64 orig_start;
-	u64 disk_num_bytes;
 	u64 blocksize = root->sectorsize;
 	u64 actual_end;
 	u64 isize = i_size_read(inode);
@@ -335,8 +333,6 @@ static noinline int compress_file_range(
 	int i;
 	int will_compress;
 
-	orig_start = start;
-
 	actual_end = min_t(u64, isize, end + 1);
 again:
 	will_compress = 0;
@@ -371,7 +367,6 @@ again:
 	total_compressed = min(total_compressed, max_uncompressed);
 	num_bytes = (end - start + blocksize) & ~(blocksize - 1);
 	num_bytes = max(blocksize,  num_bytes);
-	disk_num_bytes = num_bytes;
 	total_in = 0;
 	ret = 0;
 
@@ -467,7 +462,6 @@ again:
 		if (total_compressed >= total_in) {
 			will_compress = 0;
 		} else {
-			disk_num_bytes = total_compressed;
 			num_bytes = total_in;
 		}
 	}
@@ -757,8 +751,6 @@ static noinline int cow_file_range(struc
 	u64 disk_num_bytes;
 	u64 cur_alloc_size;
 	u64 blocksize = root->sectorsize;
-	u64 actual_end;
-	u64 isize = i_size_read(inode);
 	struct btrfs_key ins;
 	struct extent_map *em;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
@@ -769,8 +761,6 @@ static noinline int cow_file_range(struc
 	btrfs_set_trans_block_group(trans, inode);
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
-	actual_end = min_t(u64, isize, end + 1);
-
 	num_bytes = (end - start + blocksize) & ~(blocksize - 1);
 	num_bytes = max(blocksize,  num_bytes);
 	disk_num_bytes = num_bytes;
@@ -2237,7 +2227,6 @@ void btrfs_orphan_cleanup(struct btrfs_r
 {
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
-	struct btrfs_item *item;
 	struct btrfs_key key, found_key;
 	struct btrfs_trans_handle *trans;
 	struct inode *inode;
@@ -2275,7 +2264,6 @@ void btrfs_orphan_cleanup(struct btrfs_r
 
 		/* pull out the item */
 		leaf = path->nodes[0];
-		item = btrfs_item_nr(leaf, path->slots[0]);
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 
 		/* make sure the item matches what we want */
@@ -5641,7 +5629,6 @@ static void btrfs_submit_direct(int rw, 
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_dio_private *dip;
 	struct bio_vec *bvec = bio->bi_io_vec;
-	u64 start;
 	int skip_sum;
 	int write = rw & (1 << BIO_RW);
 	int ret = 0;
@@ -5667,7 +5654,6 @@ static void btrfs_submit_direct(int rw, 
 	dip->inode = inode;
 	dip->logical_offset = file_offset;
 
-	start = dip->logical_offset;
 	dip->bytes = 0;
 	do {
 		dip->bytes += bvec->bv_len;
diff -puN fs/btrfs/ioctl.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs fs/btrfs/ioctl.c
--- a/fs/btrfs/ioctl.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs
+++ a/fs/btrfs/ioctl.c
@@ -708,7 +708,6 @@ static noinline int btrfs_ioctl_resize(s
 	char *sizestr;
 	char *devstr = NULL;
 	int ret = 0;
-	int namelen;
 	int mod = 0;
 
 	if (root->fs_info->sb->s_flags & MS_RDONLY)
@@ -722,7 +721,6 @@ static noinline int btrfs_ioctl_resize(s
 		return PTR_ERR(vol_args);
 
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
-	namelen = strlen(vol_args->name);
 
 	mutex_lock(&root->fs_info->volume_mutex);
 	sizestr = vol_args->name;
diff -puN fs/btrfs/ordered-data.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs fs/btrfs/ordered-data.c
--- a/fs/btrfs/ordered-data.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs
+++ a/fs/btrfs/ordered-data.c
@@ -526,7 +526,6 @@ int btrfs_wait_ordered_range(struct inod
 {
 	u64 end;
 	u64 orig_end;
-	u64 wait_end;
 	struct btrfs_ordered_extent *ordered;
 	int found;
 
@@ -537,7 +536,6 @@ int btrfs_wait_ordered_range(struct inod
 		if (orig_end > INT_LIMIT(loff_t))
 			orig_end = INT_LIMIT(loff_t);
 	}
-	wait_end = orig_end;
 again:
 	/* start IO across the range first to instantiate any delalloc
 	 * extents
diff -puN fs/btrfs/root-tree.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs fs/btrfs/root-tree.c
--- a/fs/btrfs/root-tree.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs
+++ a/fs/btrfs/root-tree.c
@@ -181,7 +181,6 @@ int btrfs_insert_root(struct btrfs_trans
 int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid)
 {
 	struct btrfs_root *dead_root;
-	struct btrfs_item *item;
 	struct btrfs_root_item *ri;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
@@ -214,7 +213,6 @@ again:
 			nritems = btrfs_header_nritems(leaf);
 			slot = path->slots[0];
 		}
-		item = btrfs_item_nr(leaf, slot);
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (btrfs_key_type(&key) != BTRFS_ROOT_ITEM_KEY)
 			goto next;
diff -puN fs/btrfs/super.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs fs/btrfs/super.c
--- a/fs/btrfs/super.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs
+++ a/fs/btrfs/super.c
@@ -61,6 +61,8 @@ static void btrfs_put_super(struct super
 
 	ret = close_ctree(root);
 	sb->s_fs_info = NULL;
+
+	(void)ret; /* FIXME: need to fix VFS to return error? */
 }
 
 enum {
@@ -436,7 +438,6 @@ static int btrfs_fill_super(struct super
 {
 	struct inode *inode;
 	struct dentry *root_dentry;
-	struct btrfs_super_block *disk_super;
 	struct btrfs_root *tree_root;
 	struct btrfs_key key;
 	int err;
@@ -458,7 +459,6 @@ static int btrfs_fill_super(struct super
 		return PTR_ERR(tree_root);
 	}
 	sb->s_fs_info = tree_root;
-	disk_super = &tree_root->fs_info->super_copy;
 
 	key.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	key.type = BTRFS_INODE_ITEM_KEY;
@@ -571,7 +571,6 @@ static int btrfs_get_sb(struct file_syst
 	char *subvol_name = NULL;
 	u64 subvol_objectid = 0;
 	int error = 0;
-	int found = 0;
 
 	if (!(flags & MS_RDONLY))
 		mode |= FMODE_WRITE;
@@ -607,7 +606,6 @@ static int btrfs_get_sb(struct file_syst
 			goto error_close_devices;
 		}
 
-		found = 1;
 		btrfs_close_devices(fs_devices);
 	} else {
 		char b[BDEVNAME_SIZE];
diff -puN fs/btrfs/tree-defrag.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs fs/btrfs/tree-defrag.c
--- a/fs/btrfs/tree-defrag.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs
+++ a/fs/btrfs/tree-defrag.c
@@ -36,7 +36,6 @@ int btrfs_defrag_leaves(struct btrfs_tra
 	int ret = 0;
 	int wret;
 	int level;
-	int orig_level;
 	int is_extent = 0;
 	int next_key_ret = 0;
 	u64 last_ret = 0;
@@ -64,7 +63,6 @@ int btrfs_defrag_leaves(struct btrfs_tra
 		return -ENOMEM;
 
 	level = btrfs_header_level(root->node);
-	orig_level = level;
 
 	if (level == 0)
 		goto out;
diff -puN fs/btrfs/tree-log.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs fs/btrfs/tree-log.c
--- a/fs/btrfs/tree-log.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs
+++ a/fs/btrfs/tree-log.c
@@ -786,7 +786,6 @@ static noinline int add_inode_ref(struct
 {
 	struct inode *dir;
 	int ret;
-	struct btrfs_key location;
 	struct btrfs_inode_ref *ref;
 	struct btrfs_dir_item *di;
 	struct inode *inode;
@@ -795,10 +794,6 @@ static noinline int add_inode_ref(struct
 	unsigned long ref_ptr;
 	unsigned long ref_end;
 
-	location.objectid = key->objectid;
-	location.type = BTRFS_INODE_ITEM_KEY;
-	location.offset = 0;
-
 	/*
 	 * it is possible that we didn't log all the parent directories
 	 * for a given inode.  If we don't find the dir, just don't
@@ -1583,7 +1578,6 @@ static int replay_one_buffer(struct btrf
 	struct btrfs_path *path;
 	struct btrfs_root *root = wc->replay_dest;
 	struct btrfs_key key;
-	u32 item_size;
 	int level;
 	int i;
 	int ret;
@@ -1601,7 +1595,6 @@ static int replay_one_buffer(struct btrf
 	nritems = btrfs_header_nritems(eb);
 	for (i = 0; i < nritems; i++) {
 		btrfs_item_key_to_cpu(eb, &key, i);
-		item_size = btrfs_item_size_nr(eb, i);
 
 		/* inode keys are done during the first stage */
 		if (key.type == BTRFS_INODE_ITEM_KEY &&
@@ -1668,7 +1661,6 @@ static noinline int walk_down_log_tree(s
 				   struct walk_control *wc)
 {
 	u64 root_owner;
-	u64 root_gen;
 	u64 bytenr;
 	u64 ptr_gen;
 	struct extent_buffer *next;
@@ -1698,7 +1690,6 @@ static noinline int walk_down_log_tree(s
 
 		parent = path->nodes[*level];
 		root_owner = btrfs_header_owner(parent);
-		root_gen = btrfs_header_generation(parent);
 
 		next = btrfs_find_create_tree_block(root, bytenr, blocksize);
 
@@ -1749,7 +1740,6 @@ static noinline int walk_up_log_tree(str
 				 struct walk_control *wc)
 {
 	u64 root_owner;
-	u64 root_gen;
 	int i;
 	int slot;
 	int ret;
@@ -1757,8 +1747,6 @@ static noinline int walk_up_log_tree(str
 	for (i = *level; i < BTRFS_MAX_LEVEL - 1 && path->nodes[i]; i++) {
 		slot = path->slots[i];
 		if (slot + 1 < btrfs_header_nritems(path->nodes[i])) {
-			struct extent_buffer *node;
-			node = path->nodes[i];
 			path->slots[i]++;
 			*level = i;
 			WARN_ON(*level == 0);
@@ -1771,7 +1759,6 @@ static noinline int walk_up_log_tree(str
 				parent = path->nodes[*level + 1];
 
 			root_owner = btrfs_header_owner(parent);
-			root_gen = btrfs_header_generation(parent);
 			wc->process_func(root, path->nodes[*level], wc,
 				 btrfs_header_generation(path->nodes[*level]));
 			if (wc->free) {
@@ -2729,7 +2716,6 @@ static int btrfs_log_inode(struct btrfs_
 	struct btrfs_key max_key;
 	struct btrfs_root *log = root->log_root;
 	struct extent_buffer *src = NULL;
-	u32 size;
 	int err = 0;
 	int ret;
 	int nritems;
@@ -2793,7 +2779,6 @@ again:
 			break;
 
 		src = path->nodes[0];
-		size = btrfs_item_size_nr(src, path->slots[0]);
 		if (ins_nr && ins_start_slot + ins_nr == path->slots[0]) {
 			ins_nr++;
 			goto next_slot;
diff -puN fs/btrfs/volumes.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs fs/btrfs/volumes.c
--- a/fs/btrfs/volumes.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs
+++ a/fs/btrfs/volumes.c
@@ -1901,7 +1901,6 @@ int btrfs_balance(struct btrfs_root *dev
 	u64 size_to_free;
 	struct btrfs_path *path;
 	struct btrfs_key key;
-	struct btrfs_chunk *chunk;
 	struct btrfs_root *chunk_root = dev_root->fs_info->chunk_root;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key found_key;
@@ -1965,9 +1964,6 @@ int btrfs_balance(struct btrfs_root *dev
 		if (found_key.objectid != key.objectid)
 			break;
 
-		chunk = btrfs_item_ptr(path->nodes[0],
-				       path->slots[0],
-				       struct btrfs_chunk);
 		/* chunk zero is special */
 		if (found_key.offset == 0)
 			break;
diff -puN fs/btrfs/xattr.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs fs/btrfs/xattr.c
--- a/fs/btrfs/xattr.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs
+++ a/fs/btrfs/xattr.c
@@ -178,7 +178,6 @@ ssize_t btrfs_listxattr(struct dentry *d
 	struct inode *inode = dentry->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_path *path;
-	struct btrfs_item *item;
 	struct extent_buffer *leaf;
 	struct btrfs_dir_item *di;
 	int ret = 0, slot, advance;
@@ -234,7 +233,6 @@ ssize_t btrfs_listxattr(struct dentry *d
 		}
 		advance = 1;
 
-		item = btrfs_item_nr(leaf, slot);
 		btrfs_item_key_to_cpu(leaf, &found_key, slot);
 
 		/* check to make sure this item is what we want */
diff -puN fs/btrfs/zlib.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs fs/btrfs/zlib.c
--- a/fs/btrfs/zlib.c~gcc-46-btrfs-clean-up-unused-variables-nonbugs
+++ a/fs/btrfs/zlib.c
@@ -199,8 +199,6 @@ int btrfs_zlib_compress_pages(struct add
 	int nr_pages = 0;
 	struct page *in_page = NULL;
 	struct page *out_page = NULL;
-	int out_written = 0;
-	int in_read = 0;
 	unsigned long bytes_left;
 
 	*out_pages = 0;
@@ -233,9 +231,6 @@ int btrfs_zlib_compress_pages(struct add
 	workspace->def_strm.avail_out = PAGE_CACHE_SIZE;
 	workspace->def_strm.avail_in = min(len, PAGE_CACHE_SIZE);
 
-	out_written = 0;
-	in_read = 0;
-
 	while (workspace->def_strm.total_in < len) {
 		ret = zlib_deflate(&workspace->def_strm, Z_SYNC_FLUSH);
 		if (ret != Z_OK) {
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
modpost-support-objects-with-more-than-64k-sections.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch
gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch
gcc-46-x86-avoid-unused-by-set-variables-in-rdmsr.patch
gcc-46-pagemap-avoid-unused-but-set-variable.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
gcc-46-x86-fix-set-but-not-read-variables.patch
gcc-46-kgdb-remove-set-but-unused-newpc.patch
gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
gcc-46-nfsd-fix-initialized-but-not-read-warnings.patch
gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch
gcc-46-mm-fix-unused-but-set-warnings.patch
gcc-46-kernel-fix-unused-but-set-warnings.patch
gcc-46-block-fix-unused-but-set-variables-in-blk-merge.patch
gcc-46-fs-fix-unused-but-set-warnings.patch


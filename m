From: akpm@linux-foundation.org
Subject: + reiser4-cryptcompress-misc-fixups.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:38:53 -0700
Message-ID: <200707290738.l6T7crdZ014111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35531 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756844AbXG2Hj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:39:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward@namesys.com, vs@namesys.com


The patch titled
     reiser4: cryptcompress misc fixups
has been added to the -mm tree.  Its filename is
     reiser4-cryptcompress-misc-fixups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiser4: cryptcompress misc fixups
From: Edward Shishkin <edward@namesys.com>

.  Fix a race (reproducible by fsx + sync (1)) between
  checkin_page_cluster operations: serialize them via special per-inode
  checkin_mutex (usual i_mutex is not suitable for this purpose, as
  ->writepages() also calls checkin_page_cluster();

.  Add comments for checkin/checkout technique for synchronization of
  primary and secondary caches with proof of correctness;

.  Fix missed right neighbor when updating disk clusters by
  handle_pos_on_leaf() during squalloc (should use upper levels to get
  expected non-connected neighbor);

.  Resolve a race between read and truncate (when read finds partially
  truncated and, hence, unrecoverable disk cluster) via keeping a track of
  leftmost truncated disk clusters in cryptcompress-specific part of inode;

. Introduce size translators and size modulators for
  common needs;

. Update comments;

. Rename badly sounding function names;

. Fix coding style;

. Add my part of credits.

Signed-off-by: Edward Shishkin <edward@namesys.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/README                        |    3 
 fs/reiser4/flush.c                       |   57 
 fs/reiser4/flush.h                       |   22 
 fs/reiser4/inode.h                       |   11 
 fs/reiser4/jnode.c                       |    2 
 fs/reiser4/jnode.h                       |    3 
 fs/reiser4/page_cache.c                  |   24 
 fs/reiser4/plugin/cluster.h              |  170 +
 fs/reiser4/plugin/file/cryptcompress.c   | 1837 ++++++++++-----------
 fs/reiser4/plugin/file/cryptcompress.h   |  177 +-
 fs/reiser4/plugin/file/file.c            |    7 
 fs/reiser4/plugin/file/file_conversion.c |   43 
 fs/reiser4/plugin/item/ctail.c           |  223 +-
 13 files changed, 1424 insertions(+), 1155 deletions(-)

diff -puN fs/reiser4/README~reiser4-cryptcompress-misc-fixups fs/reiser4/README
--- a/fs/reiser4/README~reiser4-cryptcompress-misc-fixups
+++ a/fs/reiser4/README
@@ -123,3 +123,6 @@ and Jeff) make it possible for the entir
 focus on Reiser4, and he fixed a whole lot of Reiser4 bugs also.  It
 is just amazing to watch his talent for spotting bugs in action.
 
+Edward Shishkin wrote cryptcompress file plugin (which manages files
+built of encrypted and(or) compressed bodies) and other plugins related
+to transparent encryption and compression support.
diff -puN fs/reiser4/flush.c~reiser4-cryptcompress-misc-fixups fs/reiser4/flush.c
--- a/fs/reiser4/flush.c~reiser4-cryptcompress-misc-fixups
+++ a/fs/reiser4/flush.c
@@ -415,7 +415,7 @@ static int jnode_lock_parent_coord(jnode
 				   load_count * parent_zh,
 				   znode_lock_mode mode, int try);
 static int neighbor_in_slum(znode * node, lock_handle * right_lock, sideof side,
-			    znode_lock_mode mode, int check_dirty);
+			    znode_lock_mode mode, int check_dirty, int expected);
 static int znode_same_parents(znode * a, znode * b);
 
 static int znode_check_flushprepped(znode * node)
@@ -1888,14 +1888,17 @@ static int handle_pos_on_formatted(flush
 	}
 
 	while (1) {
-		ret =
-		    neighbor_in_slum(pos->lock.node, &right_lock, RIGHT_SIDE,
-				     ZNODE_WRITE_LOCK,
-				     !should_convert_next_node(pos,
-							       right_lock.
-							       node));
-		if (ret)
+		int expected;
+		expected = should_convert_next_node(pos);
+		ret = neighbor_in_slum(pos->lock.node, &right_lock, RIGHT_SIDE,
+				       ZNODE_WRITE_LOCK, !expected, expected);
+		if (ret) {
+			if (expected)
+				warning("edward-1495",
+				"Expected neighbor not found (ret = %d). Fsck?",
+					ret);
 			break;
+		}
 
 		/* we don't prep(allocate) nodes for flushing twice.  This can be suboptimal, or it
 		 * can be optimal.  For now we choose to live with the risk that it will
@@ -1903,8 +1906,7 @@ static int handle_pos_on_formatted(flush
 		 * smarter. */
 		if (znode_check_flushprepped(right_lock.node)
 		    && !znode_convertible(right_lock.node)) {
-			assert("edward-1005",
-			       !should_convert_next_node(pos, right_lock.node));
+			assert("edward-1005", !should_convert_next_node(pos));
 			pos_stop(pos);
 			break;
 		}
@@ -1912,7 +1914,6 @@ static int handle_pos_on_formatted(flush
 		ret = incr_load_count_znode(&right_load, right_lock.node);
 		if (ret)
 			break;
-
 		if (should_convert_node(pos, right_lock.node)) {
 			ret = convert_node(pos, right_lock.node);
 			if (ret)
@@ -1933,7 +1934,7 @@ static int handle_pos_on_formatted(flush
 			break;
 
 		if (znode_check_flushprepped(right_lock.node)) {
-			if (should_convert_next_node(pos, right_lock.node)) {
+			if (should_convert_next_node(pos)) {
 				/* in spite of flushprepped status of the node,
 				   its right slum neighbor should be converted */
 				assert("edward-953", convert_data(pos));
@@ -1969,7 +1970,6 @@ static int handle_pos_on_formatted(flush
 		ret = lock_parent_and_allocate_znode(right_lock.node, pos);
 		if (ret)
 			break;
-
 		if (should_terminate_squalloc(pos)) {
 			set_item_convert_count(pos, 0);
 			break;
@@ -1982,9 +1982,7 @@ static int handle_pos_on_formatted(flush
 		if (ret)
 			break;
 	}
-
-	assert("edward-1006", !convert_data(pos) || !item_convert_data(pos));
-
+	check_convert_info(pos);
 	done_load_count(&right_load);
 	done_lh(&right_lock);
 
@@ -2977,24 +2975,26 @@ static int neighbor_in_slum(znode * node
 			    lock_handle * lock,	/* lock on starting point */
 			    sideof side,	/* left or right direction we seek the next node in */
 			    znode_lock_mode mode,	/* kind of lock we want */
-			    int check_dirty)
-{				/* true if the neighbor should be dirty */
+			    int check_dirty, /* true if the neighbor should be dirty */
+			    int use_upper_levels /* get neighbor by going though
+						    upper levels */)
+{
 	int ret;
+	int flags;
 
 	assert("jmacd-6334", znode_is_connected(node));
 
-	ret =
-	    reiser4_get_neighbor(lock, node, mode,
-				 GN_SAME_ATOM | (side ==
-						 LEFT_SIDE ? GN_GO_LEFT : 0));
+	flags =  GN_SAME_ATOM | (side == LEFT_SIDE ? GN_GO_LEFT : 0);
+	if (use_upper_levels)
+		flags |= GN_CAN_USE_UPPER_LEVELS;
 
+	ret = reiser4_get_neighbor(lock, node, mode, flags);
 	if (ret) {
 		/* May return -ENOENT or -E_NO_NEIGHBOR. */
 		/* FIXME(C): check EINVAL, E_DEADLOCK */
 		if (ret == -ENOENT) {
 			ret = RETERR(-E_NO_NEIGHBOR);
 		}
-
 		return ret;
 	}
 	if (!check_dirty)
@@ -3458,10 +3458,13 @@ static int scan_by_coord(flush_scan * sc
 		if (coord_is_after_sideof_unit(&next_coord, scan->direction)) {
 			/* We take the write lock because we may start flushing from this
 			 * coordinate. */
-			ret =
-			    neighbor_in_slum(next_coord.node, &next_lock,
-					     scan->direction, ZNODE_WRITE_LOCK,
-					     1 /* check dirty */ );
+			ret = neighbor_in_slum(next_coord.node,
+					       &next_lock,
+					       scan->direction,
+					       ZNODE_WRITE_LOCK,
+					       1 /* check dirty */,
+					       0 /* don't go though upper
+						    levels */);
 			if (ret == -E_NO_NEIGHBOR) {
 				scan->stop = 1;
 				ret = 0;
diff -puN fs/reiser4/flush.h~reiser4-cryptcompress-misc-fixups fs/reiser4/flush.h
--- a/fs/reiser4/flush.h~reiser4-cryptcompress-misc-fixups
+++ a/fs/reiser4/flush.h
@@ -219,7 +219,7 @@ static inline int should_convert_node(fl
 }
 
 /* true if there is attached convert item info */
-static inline int should_convert_next_node(flush_pos_t * pos, znode * node)
+static inline int should_convert_next_node(flush_pos_t * pos)
 {
 	return convert_data(pos) && item_convert_data(pos);
 }
@@ -233,6 +233,26 @@ static inline int should_terminate_squal
 	    item_convert_count(pos) >= SQUALLOC_THRESHOLD;
 }
 
+#if 1
+#define check_convert_info(pos)						\
+do {							        	\
+	if (unlikely(should_convert_next_node(pos))){			\
+		warning("edward-1006", "unprocessed chained data");	\
+		printk("d_cur = %d, d_next = %d, flow.len = %llu\n",	\
+		       item_convert_data(pos)->d_cur,			\
+		       item_convert_data(pos)->d_next,			\
+		       item_convert_data(pos)->flow.length);		\
+		printk("inode %llu, size = %llu, cluster %lu\n",	\
+		       (unsigned long long)get_inode_oid		\
+		       (item_convert_data(pos)->inode),			\
+		       i_size_read(item_convert_data(pos)->inode),	\
+		       convert_data(pos)->clust.index);			\
+	}								\
+} while (0)
+#else
+#define check_convert_info(pos)
+#endif /* REISER4_DEBUG */
+
 void free_convert_data(flush_pos_t * pos);
 /* used in extent.c */
 int scan_set_current(flush_scan * scan, jnode * node, unsigned add_size,
diff -puN fs/reiser4/inode.h~reiser4-cryptcompress-misc-fixups fs/reiser4/inode.h
--- a/fs/reiser4/inode.h~reiser4-cryptcompress-misc-fixups
+++ a/fs/reiser4/inode.h
@@ -366,6 +366,17 @@ extern void inode_clr_extension(struct i
 extern void inode_check_scale(struct inode *inode, __u64 old, __u64 new);
 extern void inode_check_scale_nolock(struct inode * inode, __u64 old, __u64 new);
 
+#define INODE_SET_SIZE(i, value)			\
+({							\
+	struct inode *__i;				\
+	typeof(value) __v;				\
+							\
+	__i = (i);					\
+	__v = (value);					\
+	inode_check_scale(__i, __i->i_size, __v);	\
+	i_size_write(__i, __v);				\
+})
+
 /*
  * update field @field in inode @i to contain value @value.
  */
diff -puN fs/reiser4/jnode.c~reiser4-cryptcompress-misc-fixups fs/reiser4/jnode.c
--- a/fs/reiser4/jnode.c~reiser4-cryptcompress-misc-fixups
+++ a/fs/reiser4/jnode.c
@@ -1067,8 +1067,6 @@ void jput_final(jnode * node)
 		rcu_read_unlock();
 		return;
 	}
-	assert("edward-1432", node->page_count == 0);
-
 	r_i_p = !JF_TEST_AND_SET(node, JNODE_RIP);
 	/*
 	 * if r_i_p is true, we were first to set JNODE_RIP on this node. In
diff -puN fs/reiser4/jnode.h~reiser4-cryptcompress-misc-fixups fs/reiser4/jnode.h
--- a/fs/reiser4/jnode.h~reiser4-cryptcompress-misc-fixups
+++ a/fs/reiser4/jnode.h
@@ -170,9 +170,6 @@ struct jnode {
 	/*   88 */ reiser4_plugin_id parent_item_id;
 	/*   92 */
 #if REISER4_DEBUG
-	/* number of pages referenced by the jnode (meaningful while capturing of
-	   page clusters) */
-	int page_count;
 	/* list of all jnodes for debugging purposes. */
 	struct list_head jnodes;
 	/* how many times this jnode was written in one transaction */
diff -puN fs/reiser4/page_cache.c~reiser4-cryptcompress-misc-fixups fs/reiser4/page_cache.c
--- a/fs/reiser4/page_cache.c~reiser4-cryptcompress-misc-fixups
+++ a/fs/reiser4/page_cache.c
@@ -495,13 +495,7 @@ int reiser4_set_page_dirty_internal(stru
 	return 0;
 }
 
-#if REISER4_DEBUG
-
-/**
- * can_hit_entd
- *
- * This is used on
- */
+#if 0
 static int can_hit_entd(reiser4_context *ctx, struct super_block *s)
 {
 	if (ctx == NULL || ((unsigned long)ctx->magic) != context_magic)
@@ -516,7 +510,6 @@ static int can_hit_entd(reiser4_context 
 		return 0;
 	return 1;
 }
-
 #endif
 
 /**
@@ -538,8 +531,7 @@ int reiser4_writepage(struct page *page,
 	s = page->mapping->host->i_sb;
 	ctx = get_current_context_check();
 
-	assert("", can_hit_entd(ctx, s));
-
+	//assert("", can_hit_entd(ctx, s));
 	return write_page_by_ent(page, wbc);
 }
 
@@ -626,11 +618,13 @@ truncate_jnodes_range(struct inode *inod
 
 	if (inode_file_plugin(inode) ==
 	    file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID))
-		/* No need to get rid of jnodes here: if the single jnode of
-		   page cluster did not have page, then it was found and killed
-		   before in
-		   truncate_page_cluster_cryptcompress()->jput()->jput_final(),
-		   otherwise it will be dropped by reiser4_invalidatepage() */
+		/*
+		 * No need to get rid of jnodes here: if the single jnode of
+		 * page cluster did not have page, then it was found and killed
+		 * before in
+		 * truncate_complete_page_cluster()->jput()->jput_final(),
+		 * otherwise it will be dropped by reiser4_invalidatepage()
+		 */
 		return 0;
 	truncated_jnodes = 0;
 
diff -puN fs/reiser4/plugin/cluster.h~reiser4-cryptcompress-misc-fixups fs/reiser4/plugin/cluster.h
--- a/fs/reiser4/plugin/cluster.h~reiser4-cryptcompress-misc-fixups
+++ a/fs/reiser4/plugin/cluster.h
@@ -1,7 +1,7 @@
 /* Copyright 2002, 2003 by Hans Reiser, licensing governed by reiser4/README */
 
-/* This file contains page/cluster index translators and offset modulators
-   See http://www.namesys.com/cryptcompress_design.html for details */
+/* This file contains size/offset translators, modulators
+   and other helper functions. */
 
 #if !defined( __FS_REISER4_CLUSTER_H__ )
 #define __FS_REISER4_CLUSTER_H__
@@ -69,47 +69,43 @@ static inline loff_t clust_to_off(cloff_
 	return (loff_t) idx << inode_cluster_shift(inode);
 }
 
-static inline unsigned long count_to_nr(loff_t count, unsigned shift)
+static inline loff_t off_to_clust_to_off(loff_t off, struct inode *inode)
 {
-	return (count + (1UL << shift) - 1) >> shift;
+	return clust_to_off(off_to_clust(off, inode), inode);
 }
 
-/* number of pages occupied by @count bytes */
-static inline pgoff_t count_to_nrpages(loff_t count)
+static inline pgoff_t off_to_clust_to_pg(loff_t off, struct inode *inode)
 {
-	return count_to_nr(count, PAGE_CACHE_SHIFT);
+	return clust_to_pg(off_to_clust(off, inode), inode);
 }
 
-/* number of clusters occupied by @count bytes */
-static inline cloff_t count_to_nrclust(loff_t count, struct inode *inode)
+static inline unsigned off_to_pgoff(loff_t off)
 {
-	return count_to_nr(count, inode_cluster_shift(inode));
+	return off & (PAGE_CACHE_SIZE - 1);
 }
 
-/* number of clusters occupied by @count pages */
-static inline cloff_t pgcount_to_nrclust(pgoff_t count, struct inode *inode)
+static inline unsigned off_to_cloff(loff_t off, struct inode *inode)
 {
-	return count_to_nr(count, cluster_nrpages_shift(inode));
+	return off & ((loff_t) (inode_cluster_size(inode)) - 1);
 }
 
-static inline loff_t off_to_clust_to_off(loff_t off, struct inode *inode)
+static inline  pgoff_t offset_in_clust(struct page * page)
 {
-	return clust_to_off(off_to_clust(off, inode), inode);
-}
+	assert("edward-1488", page != NULL);
+	assert("edward-1489", page->mapping != NULL);
 
-static inline pgoff_t off_to_clust_to_pg(loff_t off, struct inode *inode)
-{
-	return clust_to_pg(off_to_clust(off, inode), inode);
+	return page_index(page) & ((cluster_nrpages(page->mapping->host)) - 1);
 }
 
-static inline unsigned off_to_pgoff(loff_t off)
+static inline int first_page_in_cluster(struct page * page)
 {
-	return off & (PAGE_CACHE_SIZE - 1);
+	return offset_in_clust(page) == 0;
 }
 
-static inline unsigned off_to_cloff(loff_t off, struct inode *inode)
+static inline int last_page_in_cluster(struct page * page)
 {
-	return off & ((loff_t) (inode_cluster_size(inode)) - 1);
+	return offset_in_clust(page) ==
+		cluster_nrpages(page->mapping->host) - 1;
 }
 
 static inline unsigned
@@ -118,50 +114,97 @@ pg_to_off_to_cloff(unsigned long idx, st
 	return off_to_cloff(pg_to_off(idx), inode);
 }
 
-/* if @size != 0, returns index of the page
-   which contains the last byte of the file */
-static inline pgoff_t size_to_pg(loff_t size)
+/*********************** Size translators **************************/
+
+/* Translate linear size.
+ * New units are (1 << @blk_shift) times larger, then old ones.
+ * In other words, calculate number of logical blocks, occupied
+ * by @count elements
+ */
+static inline unsigned long size_in_blocks(loff_t count, unsigned blkbits)
 {
-	return (size ? off_to_pg(size - 1) : 0);
+	return (count + (1UL << blkbits) - 1) >> blkbits;
 }
 
-/* minimal index of the page which doesn't contain
-   file data */
-static inline pgoff_t size_to_next_pg(loff_t size)
+/* size in pages */
+static inline pgoff_t size_in_pages(loff_t size)
 {
-	return (size ? off_to_pg(size - 1) + 1 : 0);
+	return size_in_blocks(size, PAGE_CACHE_SHIFT);
 }
 
-/* how many bytes of file of size @cnt can be contained
-   in page of index @idx */
-static inline unsigned cnt_to_pgcnt(loff_t cnt, pgoff_t idx)
+/* size in logical clusters */
+static inline cloff_t size_in_lc(loff_t size, struct inode *inode)
 {
-	if (idx > off_to_pg(cnt))
-		return 0;
-	if (idx < off_to_pg(cnt))
-		return PAGE_CACHE_SIZE;
-	return off_to_pgoff(cnt);
+	return size_in_blocks(size, inode_cluster_shift(inode));
 }
 
-/* how many bytes of file of size @cnt can be contained
-   in logical cluster of index @idx */
-static inline unsigned cnt_to_clcnt(loff_t cnt, cloff_t idx,
-				    struct inode *inode)
+/* size in pages to the size in page clusters */
+static inline cloff_t sp_to_spcl(pgoff_t size, struct inode *inode)
+{
+	return size_in_blocks(size, cluster_nrpages_shift(inode));
+}
+
+/*********************** Size modulators ***************************/
+
+/*
+  Modulate linear size by nominated block size and offset.
+
+  The "finite" function (which is zero almost everywhere).
+  How much is a height of the figure at a position @pos,
+  when trying to construct rectangle of height (1 << @blkbits),
+  and square @size.
+
+  ******
+  *******
+  *******
+  *******
+  ----------> pos
+*/
+static inline unsigned __mbb(loff_t size, unsigned long pos, int blkbits)
 {
-	if (idx > off_to_clust(cnt, inode))
+	unsigned end = size >> blkbits;
+	if (pos < end)
+		return 1U << blkbits;
+	if (unlikely(pos > end))
 		return 0;
-	if (idx < off_to_clust(cnt, inode))
-		return inode_cluster_size(inode);
-	return off_to_cloff(cnt, inode);
+	return size & ~(~0ull << blkbits);
 }
 
-static inline unsigned fsize_to_count(struct cluster_handle * clust,
-				      struct inode * inode)
+/* the same as above, but block size is page size */
+static inline unsigned __mbp(loff_t size, pgoff_t pos)
 {
-	assert("edward-288", clust != NULL);
-	assert("edward-289", inode != NULL);
+	return __mbb(size, pos, PAGE_CACHE_SHIFT);
+}
+
+/* number of file's bytes in the nominated logical cluster */
+static inline unsigned lbytes(cloff_t index, struct inode * inode)
+{
+	return __mbb(i_size_read(inode), index, inode_cluster_shift(inode));
+}
 
-	return cnt_to_clcnt(inode->i_size, clust->index, inode);
+/* number of file's bytes in the nominated page */
+static inline unsigned pbytes(pgoff_t index, struct inode * inode)
+{
+	return __mbp(i_size_read(inode), index);
+}
+
+/* return true, if logical cluster is not occupied by the file */
+static inline int new_logical_cluster(struct cluster_handle * clust,
+				      struct inode *inode)
+{
+	return clust_to_off(clust->index, inode) >= i_size_read(inode);
+}
+
+/* return true, if pages @p1 and @p2 are of the same page cluster */
+static inline int same_page_cluster(struct page * p1, struct page * p2)
+{
+	assert("edward-1490", p1 != NULL);
+	assert("edward-1491", p2 != NULL);
+	assert("edward-1492", p1->mapping != NULL);
+	assert("edward-1493", p2->mapping != NULL);
+
+	return (pg_to_clust(page_index(p1), p1->mapping->host) ==
+		pg_to_clust(page_index(p2), p2->mapping->host));
 }
 
 static inline int cluster_is_complete(struct cluster_handle * clust,
@@ -213,6 +256,15 @@ static inline void cluster_init_write(st
 	cluster_init_act (clust, TFMA_WRITE, window);
 }
 
+/* true if @p1 and @p2 are items of the same disk cluster */
+static inline int same_disk_cluster(const coord_t * p1, const coord_t * p2)
+{
+	/* drop this if you have other items to aggregate */
+	assert("edward-1494", item_id_by_coord(p1) == CTAIL_ID);
+
+	return item_plugin_by_coord(p1)->b.mergeable(p1, p2);
+}
+
 static inline int dclust_get_extension_dsize(hint_t * hint)
 {
 	return hint->ext_coord.extension.ctail.dsize;
@@ -269,9 +321,9 @@ static inline void coord_set_between_clu
 int reiser4_inflate_cluster(struct cluster_handle *, struct inode *);
 int find_disk_cluster(struct cluster_handle *, struct inode *, int read,
 		      znode_lock_mode mode);
-int flush_cluster_pages(struct cluster_handle *, jnode *, struct inode *);
+int checkout_logical_cluster(struct cluster_handle *, jnode *, struct inode *);
 int reiser4_deflate_cluster(struct cluster_handle *, struct inode *);
-void truncate_page_cluster_cryptcompress(struct inode *inode, cloff_t start,
+void truncate_complete_page_cluster(struct inode *inode, cloff_t start,
 					 int even_cows);
 void invalidate_hint_cluster(struct cluster_handle * clust);
 void put_hint_cluster(struct cluster_handle * clust, struct inode *inode,
@@ -282,8 +334,11 @@ void reset_cluster_params(struct cluster
 int set_cluster_by_page(struct cluster_handle * clust, struct page * page,
 			int count);
 int prepare_page_cluster(struct inode *inode, struct cluster_handle * clust,
-			 int capture);
-void reiser4_release_cluster_pages(struct cluster_handle *);
+			 rw_op rw);
+void __put_page_cluster(int from, int to, struct page ** pages,
+			struct inode * inode);
+void put_page_cluster(struct cluster_handle * clust,
+		      struct inode  * inode, rw_op rw);
 void put_cluster_handle(struct cluster_handle * clust);
 int grab_tfm_stream(struct inode *inode, struct tfm_cluster * tc, tfm_stream_id id);
 int tfm_cluster_is_uptodate(struct tfm_cluster * tc);
@@ -291,8 +346,7 @@ void tfm_cluster_set_uptodate(struct tfm
 void tfm_cluster_clr_uptodate(struct tfm_cluster * tc);
 
 /* move cluster handle to the target position
-   specified by the page of index @pgidx
-*/
+   specified by the page of index @pgidx */
 static inline void move_cluster_forward(struct cluster_handle * clust,
 					struct inode *inode,
 					pgoff_t pgidx)
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-cryptcompress-misc-fixups fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-cryptcompress-misc-fixups
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -1,10 +1,12 @@
 /* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
    reiser4/README */
-
-/* This file contains implementations of inode/file/address_space/file plugin
- * operations specific for cryptcompress file plugin which manages files with
- * compressed and encrypted bodies. "Cryptcompress file" is built of items of
- * CTAIL_ID (see http://www.namesys.com/cryptcompress_design.html for details).
+/*
+ * Written by Edward Shishkin.
+ *
+ * Implementations of inode/file/address_space operations
+ * specific for cryptcompress file plugin which manages
+ * regular files built of compressed and(or) encrypted bodies.
+ * See http://dev.namesys.com/CryptcompressPlugin for details.
  */
 
 #include "../../inode.h"
@@ -20,6 +22,35 @@
 #include <linux/writeback.h>
 #include <linux/random.h>
 
+/*
+               Managing primary and secondary caches by Reiser4
+               cryptcompress file plugin. Synchronization scheme.
+
+
+                                             +------------------+
+                        +------------------->|    tfm stream    |
+                        |                    | (compressed data)|
+                  flush |                    +------------------+
+                        +-----------------+           |
+                        |(->)longterm lock|           V
+--+        writepages() |                 |        +-***-+  reiser4        +---+
+  |                     |                 +--+     | *** |  storage tree   |   |
+  |                     |                    |     +-***-+  (primary cache)|   |
+u | write()   (secondary| cache)             V    /   |   \                |   |
+s | ---->  +----+ +----+ +----+ +----+     +-***** ******* **----+  ---->  | d |
+e |        |    | |page cluster |    |     | **disk cluster**    |         | i |
+r | <----  +----+ +----+ +----+ +----+     +-***** **********----+  <----  | s |
+  | read()              ^                      ^      |                    | k |
+  |                     |     (->)longterm lock|      |           page_io()|   |
+  |                     |                      +------+                    |   |
+--+         readpages() |                             |                    +---+
+                        |                             V
+                        |                    +------------------+
+                        +--------------------|    tfm stream    |
+                                             |   (plain text)   |
+                                             +------------------+
+*/
+
 /* get cryptcompress specific portion of inode */
 struct cryptcompress_info *cryptcompress_inode_data(const struct inode *inode)
 {
@@ -38,22 +69,13 @@ void init_inode_data_cryptcompress(struc
 
 	memset(data, 0, sizeof(*data));
 
+	mutex_init(&data->checkin_mutex);
+	data->trunc_index = ULONG_MAX;
 	turn_on_compression(data);
 	set_lattice_factor(data, MIN_LATTICE_FACTOR);
 	init_inode_ordering(inode, crd, create);
 }
 
-#if REISER4_DEBUG
-int cryptcompress_inode_ok(struct inode *inode)
-{
-	if (!(reiser4_inode_data(inode)->plugin_mask & (1 << PSET_FILE)))
-		return 0;
-	if (!cluster_shift_ok(inode_cluster_shift(inode)))
-		return 0;
-	return 1;
-}
-#endif
-
 /* The following is a part of reiser4 cipher key manager
    which is called when opening/creating a cryptcompress file */
 
@@ -297,7 +319,7 @@ struct reiser4_crypto_info * create_cryp
 				      data->keysize);
 	if (ret) {
 		warning("edward-1379",
-			"setkey failed flags=%x\n",
+			"setkey failed flags=%x",
 			crypto_blkcipher_get_flags(info_get_cipher(info)));
 		goto err;
 	}
@@ -378,7 +400,9 @@ static void reiser4_detach_crypto_info(s
 static int keyid_eq(struct reiser4_crypto_info * child,
 		    struct reiser4_crypto_info * parent)
 {
-	return !memcmp(child->keyid, parent->keyid, info_digest_plugin(parent)->fipsize);
+	return !memcmp(child->keyid,
+		       parent->keyid,
+		       info_digest_plugin(parent)->fipsize);
 }
 
 /* check if a crypto-stat (which is bound to @parent) can be inherited */
@@ -394,7 +418,8 @@ int can_inherit_crypto_cryptcompress(str
 		return 0;
 	return (inode_cipher_plugin(child) == inode_cipher_plugin(parent) &&
 		inode_digest_plugin(child) == inode_digest_plugin(parent) &&
-		inode_crypto_info(child)->keysize == inode_crypto_info(parent)->keysize &&
+		inode_crypto_info(child)->keysize ==
+		inode_crypto_info(parent)->keysize &&
 		keyid_eq(inode_crypto_info(child), inode_crypto_info(parent)));
 }
 #endif
@@ -427,19 +452,25 @@ static int inode_check_cluster(struct in
 {
 	assert("edward-696", object != NULL);
 
-	if (inode_cluster_size(object) < PAGE_CACHE_SIZE) {
+	if (unlikely(inode_cluster_size(object) < PAGE_CACHE_SIZE)) {
 		warning("edward-1320", "Can not support '%s' "
 			"logical clusters (less then page size)",
 			inode_cluster_plugin(object)->h.label);
 		return RETERR(-EINVAL);
 	}
+	if (unlikely(inode_cluster_shift(object)) >= BITS_PER_BYTE*sizeof(int)){
+		warning("edward-1463", "Can not support '%s' "
+			"logical clusters (too big for transform)",
+			inode_cluster_plugin(object)->h.label);
+		return RETERR(-EINVAL);
+	}
 	return 0;
 }
 
 /* ->destroy_inode() method of the cryptcompress plugin */
 void destroy_inode_cryptcompress(struct inode * inode)
 {
-	assert("edward-23", cryptcompress_inode_data(inode)->pgcount == 0);
+	assert("edward-1464", INODE_PGCOUNT(inode) == 0);
 	reiser4_detach_crypto_info(inode);
 	return;
 }
@@ -451,9 +482,8 @@ void destroy_inode_cryptcompress(struct 
 . attach compression info if specified
 . attach cluster info
 */
-int
-create_cryptcompress(struct inode *object, struct inode *parent,
-		     reiser4_object_create_data * data)
+int create_cryptcompress(struct inode *object, struct inode *parent,
+			 reiser4_object_create_data * data)
 {
 	int result;
 	reiser4_inode *info;
@@ -493,7 +523,7 @@ create_cryptcompress(struct inode *objec
 	return result;
 }
 
-/* ->open() method of the cryptcompress plugin */
+/* ->open_object() method of the cryptcompress plugin */
 int open_object_cryptcompress(struct inode * inode, struct file * file)
 {
 	int result;
@@ -557,11 +587,6 @@ size_t inode_scaled_cluster_size(struct 
 	return inode_scaled_offset(inode, inode_cluster_size(inode));
 }
 
-static int new_cluster(struct cluster_handle * clust, struct inode *inode)
-{
-	return (clust_to_off(clust->index, inode) >= inode->i_size);
-}
-
 /* set number of cluster pages */
 static void set_cluster_nrpages(struct cluster_handle * clust,
 				struct inode *inode)
@@ -571,73 +596,64 @@ static void set_cluster_nrpages(struct c
 	assert("edward-180", clust != NULL);
 	assert("edward-1040", inode != NULL);
 
+	clust->old_nrpages = size_in_pages(lbytes(clust->index, inode));
 	win = clust->win;
 	if (!win) {
-		/* NOTE-EDWARD: i_size should be protected */
-		clust->nr_pages =
-		    count_to_nrpages(fsize_to_count(clust, inode));
+		clust->nr_pages = size_in_pages(lbytes(clust->index, inode));
 		return;
 	}
-	assert("edward-1176", clust->op != PCL_UNKNOWN);
+	assert("edward-1176", clust->op != LC_INVAL);
 	assert("edward-1064", win->off + win->count + win->delta != 0);
 
 	if (win->stat == HOLE_WINDOW &&
 	    win->off == 0 && win->count == inode_cluster_size(inode)) {
-		/* special case: we start write hole from fake cluster */
+		/* special case: writing a "fake" logical cluster */
 		clust->nr_pages = 0;
 		return;
 	}
-	clust->nr_pages =
-	    count_to_nrpages(max_count(win->off + win->count + win->delta,
-				       fsize_to_count(clust, inode)));
+	clust->nr_pages = size_in_pages(max(win->off + win->count + win->delta,
+					    lbytes(clust->index, inode)));
 	return;
 }
 
-/* ->key_by_inode() method of the cryptcompress plugin */
-/* see plugin/plugin.h for details */
-int
-key_by_inode_cryptcompress(struct inode *inode, loff_t off, reiser4_key * key)
+/* plugin->key_by_inode()
+   build key of a disk cluster */
+int key_by_inode_cryptcompress(struct inode *inode, loff_t off,
+			       reiser4_key * key)
 {
-	loff_t clust_off;
-
 	assert("edward-64", inode != 0);
-	//      assert("edward-112", ergo(off != get_key_offset(reiser4_max_key()), !off_to_cloff(off, inode)));
-	/* don't come here with other offsets */
 
-	clust_off =
-	    (off ==
-	     get_key_offset(reiser4_max_key())? get_key_offset(reiser4_max_key()) :
-	     off_to_clust_to_off(off, inode));
+	if (likely(off != get_key_offset(reiser4_max_key())))
+		off = off_to_clust_to_off(off, inode);
+	if (inode_crypto_info(inode))
+		off = inode_scaled_offset(inode, off);
 
 	key_by_inode_and_offset_common(inode, 0, key);
-	set_key_offset(key,
-		       (__u64) (!inode_crypto_info(inode) ? clust_off :
-				inode_scaled_offset(inode, clust_off)));
+	set_key_offset(key, (__u64)off);
 	return 0;
 }
 
-/* plugin->flow_by_inode */
-int
-flow_by_inode_cryptcompress(struct inode *inode /* file to build flow for */ ,
-			    const char __user *buf /* user level buffer */ ,
-			    int user	/* 1 if @buf is of user space, 0 - if it is
-					   kernel space */ ,
-			    loff_t size /* buffer size */ ,
-			    loff_t off /* offset to start io from */ ,
-			    rw_op op /* READ or WRITE */ ,
-			    flow_t * f /* resulting flow */ )
+/* plugin->flow_by_inode() */
+/* flow is used to read/write disk clusters */
+int flow_by_inode_cryptcompress(struct inode *inode, const char __user * buf,
+				int user,       /* 1: @buf is of user space,
+					           0: kernel space */
+				loff_t size,    /* @buf size */
+				loff_t off,     /* offset to start io from */
+				rw_op op,       /* READ or WRITE */
+				flow_t * f      /* resulting flow */)
 {
 	assert("edward-436", f != NULL);
 	assert("edward-149", inode != NULL);
 	assert("edward-150", inode_file_plugin(inode) != NULL);
-
+	assert("edward-1465", user == 0); /* we use flow to read/write
+					    disk clusters located in
+					    kernel space */
 	f->length = size;
 	memcpy(&f->data, &buf, sizeof(buf));
 	f->user = user;
 	f->op = op;
 
-	if (op == WRITE_OP && user == 1)
-		return 0;
 	return key_by_inode_cryptcompress(inode, off, &f->key);
 }
 
@@ -681,7 +697,7 @@ static int reserve4cluster(struct inode 
 	if (clust->nr_pages == 0) {
 		assert("edward-1152", clust->win != NULL);
 		assert("edward-1153", clust->win->stat == HOLE_WINDOW);
-		/* don't reserve space for fake disk clusteer */
+		/* don't reserve disk space for fake logical cluster */
 		return 0;
 	}
 	assert("edward-442", jprivate(clust->pages[0]) != NULL);
@@ -776,7 +792,7 @@ static int find_cluster_item(hint_t * hi
 		dclust_inc_extension_ncount(hint);
 	return CBK_COORD_FOUND;
 
-      not_found:
+ not_found:
 	assert("edward-1220", coord->item_pos > 0);
 	//coord->item_pos--;
 	/* roll back */
@@ -784,7 +800,7 @@ static int find_cluster_item(hint_t * hi
 	ON_DEBUG(coord_update_v(coord));
 	return CBK_COORD_NOTFOUND;
 
-      traverse_tree:
+ traverse_tree:
 	assert("edward-713", hint->lh.owner == NULL);
 	assert("edward-714", reiser4_schedulable());
 
@@ -856,10 +872,7 @@ static void align_or_cut_overhead(struct
 	return;
 }
 
-/* the following two functions are to evaluate results
-   of compression transform */
-static unsigned
-max_cipher_overhead(struct inode * inode)
+static unsigned max_cipher_overhead(struct inode * inode)
 {
 	if (!need_cipher(inode) || !inode_cipher_plugin(inode)->align_stream)
 		return 0;
@@ -1069,9 +1082,9 @@ int reiser4_deflate_cluster(struct clust
 		}
 		else {
 			/* bad result, discard */
-#if REISER4_DEBUG
+#if 0
 			if (cluster_is_complete(clust, inode))
-			      warning("edward-1338",
+			      warning("edward-1496",
 				      "incompressible cluster %lu (inode %llu)",
 				      clust->index,
 				      (unsigned long long)get_inode_oid(inode));
@@ -1248,33 +1261,33 @@ int readpage_cryptcompress(struct file *
 	}
 	result = iplug->s.file.readpage(&clust, page);
 
-	assert("edward-1459", !PageLocked(page));
-	assert("edward-64", ergo(result == 0, PageUptodate(page)));
 	put_cluster_handle(&clust);
+	reiser4_txn_restart(ctx);
 	reiser4_exit_context(ctx);
 	return result;
 }
 
-/* how much pages will be captured */
-static int cluster_nrpages_to_capture(struct cluster_handle * clust)
+/* number of pages to check in */
+static int get_new_nrpages(struct cluster_handle * clust)
 {
 	switch (clust->op) {
-	case PCL_APPEND:
+	case LC_APPOV:
 		return clust->nr_pages;
-	case PCL_TRUNCATE:
+	case LC_TRUNC:
 		assert("edward-1179", clust->win != NULL);
-		return count_to_nrpages(clust->win->off + clust->win->count);
+		return size_in_pages(clust->win->off + clust->win->count);
 	default:
 		impossible("edward-1180", "bad page cluster option");
 		return 0;
 	}
 }
 
-static void set_cluster_pages_dirty(struct cluster_handle * clust)
+static void set_cluster_pages_dirty(struct cluster_handle * clust,
+				    struct inode * inode)
 {
 	int i;
 	struct page *pg;
-	int nrpages = cluster_nrpages_to_capture(clust);
+	int nrpages = get_new_nrpages(clust);
 
 	for (i = 0; i < nrpages; i++) {
 
@@ -1288,176 +1301,17 @@ static void set_cluster_pages_dirty(stru
 	}
 }
 
-static void clear_cluster_pages_dirty(struct cluster_handle * clust)
-{
-	int i;
-	assert("edward-1275", clust != NULL);
-
-	for (i = 0; i < clust->nr_pages; i++) {
-		assert("edward-1276", clust->pages[i] != NULL);
-
-		lock_page(clust->pages[i]);
-		if (PageDirty(clust->pages[i])) {
-			assert("edward-1277", PageUptodate(clust->pages[i]));
-			cancel_dirty_page(clust->pages[i], PAGE_CACHE_SIZE);
-		}
-#if REISER4_DEBUG
-		else
-			/* Race between flush and write:
-			   some pages became clean when write() (or another
-			   process which modifies data) capture the cluster. */
-			warning("edward-985", "Page of index %lu (inode %llu)"
-				" is not dirty\n", clust->pages[i]->index,
-				(unsigned long long)get_inode_oid(clust->
-								  pages[i]->
-								  mapping->
-								  host));
-#endif
-		unlock_page(clust->pages[i]);
-	}
-}
-
-/* update i_size by window */
-static void inode_set_new_size(struct cluster_handle * clust,
-			       struct inode * inode)
-{
-	loff_t size;
-	struct reiser4_slide * win;
-
-	assert("edward-1181", clust != NULL);
-	assert("edward-1182", inode != NULL);
-
-	win = clust->win;
-	assert("edward-1183", win != NULL);
-	assert("edward-1183", win->count != 0);
-
-	size = clust_to_off(clust->index, inode) + win->off;
-
-	switch (clust->op) {
-	case PCL_APPEND:
-		if (size + win->count <= inode->i_size)
-			/* overwrite only */
-			return;
-		size += win->count;
-		break;
-	case PCL_TRUNCATE:
-		break;
-	default:
-		impossible("edward-1184", "bad page cluster option");
-		break;
-	}
-	inode_check_scale_nolock(inode, inode->i_size, size);
-	inode->i_size = size;
-	return;
-}
-
-/* Check in page cluster modifications.
-   . Make jnode dirty, if it wasn't;
-   . Reserve space for a disk cluster update by flush algorithm, if needed;
-   . Clean up old references (if any).
-   . Put pages (grabbed in this thread) which will be truncated
-*/
-static void make_cluster_jnode_dirty_locked(struct cluster_handle * clust,
-					    jnode * node, loff_t * old_isize,
-					    struct inode * inode)
-{
-	int i;
-	int old_nrpages;
-	int new_nrpages = cluster_nrpages_to_capture(clust);
-
-	assert("edward-973", new_nrpages > 0);
-	assert("edward-221", node != NULL);
-	assert("edward-971", clust->reserved == 1);
-	assert_spin_locked(&(node->guard));
-	assert("edward-972", node->page_count <= cluster_nrpages(inode));
-	assert("edward-1263",
-	       clust->reserved_prepped == estimate_update_cluster(inode));
-	assert("edward-1264", clust->reserved_unprepped == 0);
-
-	if (JF_ISSET(node, JNODE_DIRTY)) {
-		/* someone has modified this cluster, but
-		   the modifications are not committed yet */
-		old_nrpages =
-			count_to_nrpages(cnt_to_clcnt(*old_isize,
-						      clust->index, inode));
-		/* free space which is already reserved */
-		free_reserved4cluster(inode, clust,
-				      estimate_update_cluster(inode));
-		/* put old references */
-		for (i = 0; i < old_nrpages; i++) {
-			assert("edward-975", clust->pages[i]);
-			assert("edward-1185", PageUptodate(clust->pages[i]));
-
-			page_cache_release(clust->pages[i]);
-#if REISER4_DEBUG
-			cryptcompress_inode_data(inode)->pgcount --;
-#endif
-		}
-	} else {
-		/* no captured pages */
-		assert("edward-1043", node->page_count == 0);
-		jnode_make_dirty_locked(node);
-		clust->reserved = 0;
-	}
-	/* put pages that will be truncated (if any) */
-	for (i = new_nrpages; i < clust->nr_pages; i++) {
-		assert("edward-1433", clust->pages[i]);
-		assert("edward-1434", PageUptodate(clust->pages[i]));
-		page_cache_release(clust->pages[i]);
-#if REISER4_DEBUG
-		cryptcompress_inode_data(inode)->pgcount --;
-#endif
-	}
-#if REISER4_DEBUG
-	clust->reserved_prepped -= estimate_update_cluster(inode);
-	node->page_count = new_nrpages;
-#endif
-	return;
-}
-
-/* This function spawns a transaction and
-   is called by any thread as a final step in page cluster modification.
+/* Grab a page cluster for read/write operations.
+   Attach a jnode for write operations (when preparing for modifications, which
+   are supposed to be committed).
+
+   We allocate only one jnode per page cluster; this jnode is binded to the
+   first page of this cluster, so we have an extra-reference that will be put
+   as soon as jnode is evicted from memory), other references will be cleaned
+   up in flush time (assume that check in page cluster was successful).
 */
-static int try_capture_cluster(struct cluster_handle * clust,
-			       struct inode *inode)
-{
-	int result = 0;
-	loff_t old_size;
-	jnode *node;
-
-	assert("edward-1029", clust != NULL);
-	assert("edward-1030", clust->reserved == 1);
-	assert("edward-1031", clust->nr_pages != 0);
-	assert("edward-1032", clust->pages != NULL);
-	assert("edward-1033", clust->pages[0] != NULL);
-
-	node = jprivate(clust->pages[0]);
-	assert("edward-1035", node != NULL);
-	assert("edward-1446", jnode_is_cluster_page(node));
-
-	spin_lock_jnode(node);
-
-	old_size = inode->i_size;
-	if (clust->win)
-		inode_set_new_size(clust, inode);
-
-	result = reiser4_try_capture(node, ZNODE_WRITE_LOCK, 0);
-	if (result)
-		goto exit;
-	make_cluster_jnode_dirty_locked(clust, node, &old_size, inode);
-      exit:
-	spin_unlock_jnode(node);
-	jput(node);
-	return result;
-}
-
-/* Collect unlocked cluster pages for any modifications and attach a jnode.
-   We allocate only one jnode per cluster, this jnode is binded to the first
-   page of this cluster, so we have an extra-reference that will exist with
-   this jnode, other references will be cleaned up in flush time.
-*/
-static int grab_cluster_pages_jnode(struct inode * inode,
-				    struct cluster_handle * clust)
+int grab_page_cluster(struct inode * inode,
+		      struct cluster_handle * clust, rw_op rw)
 {
 	int i;
 	int result = 0;
@@ -1465,6 +1319,9 @@ static int grab_cluster_pages_jnode(stru
 
 	assert("edward-182", clust != NULL);
 	assert("edward-183", clust->pages != NULL);
+	assert("edward-1466", clust->node == NULL);
+	assert("edward-1428", inode != NULL);
+	assert("edward-1429", inode->i_mapping != NULL);
 	assert("edward-184", clust->nr_pages <= cluster_nrpages(inode));
 
 	if (clust->nr_pages == 0)
@@ -1475,14 +1332,14 @@ static int grab_cluster_pages_jnode(stru
 		assert("edward-1044", clust->pages[i] == NULL);
 
 		clust->pages[i] =
-			find_or_create_page(inode->i_mapping,
-					    clust_to_pg(clust->index, inode) + i,
-					    reiser4_ctx_gfp_mask_get());
+		       find_or_create_page(inode->i_mapping,
+					   clust_to_pg(clust->index, inode) + i,
+					   reiser4_ctx_gfp_mask_get());
 		if (!clust->pages[i]) {
 			result = RETERR(-ENOMEM);
 			break;
 		}
-		if (i == 0) {
+		if (i == 0 && rw == WRITE_OP) {
 			node = jnode_of_page(clust->pages[i]);
 			if (IS_ERR(node)) {
 				result = PTR_ERR(node);
@@ -1490,120 +1347,89 @@ static int grab_cluster_pages_jnode(stru
 				break;
 			}
 			JF_SET(node, JNODE_CLUSTER_PAGE);
-			unlock_page(clust->pages[i]);
-			assert("edward-919", node);
-			continue;
+			assert("edward-920", jprivate(clust->pages[0]));
 		}
+		INODE_PGCOUNT_INC(inode);
 		unlock_page(clust->pages[i]);
 	}
-	if (result) {
-		while (i)
-			page_cache_release(clust->pages[--i]);
+	if (unlikely(result)) {
+		while (i) {
+			put_cluster_page(clust->pages[--i]);
+			INODE_PGCOUNT_DEC(inode);
+		}
 		if (node && !IS_ERR(node))
 			jput(node);
 		return result;
 	}
-	assert("edward-920", jprivate(clust->pages[0]));
-#if REISER4_DEBUG
-	cryptcompress_inode_data(inode)->pgcount += clust->nr_pages;
-#endif
+	clust->node = node;
 	return 0;
 }
 
-/* Collect unlocked cluster pages only for read (not to modify) */
-int grab_cluster_pages(struct inode *inode, struct cluster_handle * clust)
+static void truncate_page_cluster_range(struct inode * inode,
+					struct page ** pages,
+					cloff_t index,
+					int from, int count,
+					int even_cows)
 {
-	int i;
-	int result = 0;
-
-	assert("edward-1428", inode != NULL);
-	assert("edward-1429", inode->i_mapping != NULL);
-	assert("edward-787", clust != NULL);
-	assert("edward-788", clust->pages != NULL);
-	assert("edward-789", clust->nr_pages != 0);
-	assert("edward-790", clust->nr_pages <= cluster_nrpages(inode));
-
-	for (i = 0; i < clust->nr_pages; i++) {
-		clust->pages[i] =
-		       find_or_create_page(inode->i_mapping,
-					   clust_to_pg(clust->index, inode) + i,
-					   reiser4_ctx_gfp_mask_get());
-		if (!clust->pages[i]) {
-			result = RETERR(-ENOMEM);
-			break;
-		}
-		unlock_page(clust->pages[i]);
-	}
-	if (result)
-		while (i)
-			page_cache_release(clust->pages[--i]);
-	return result;
-}
-
-/* @node might be attached by reiser4_writepage(), not by
-   cryptcompress plugin code, but emergency flush should
-   understand that pages of cryptcompress files are not
-   flushable.
-*/
-#if 0
-int jnode_of_cluster(const jnode * node, struct page * page)
-{
-	assert("edward-1339", node != NULL);
-	assert("edward-1340", page != NULL);
-	assert("edward-1341", page->mapping != NULL);
-	assert("edward-1342", page->mapping->host != NULL);
-	assert("edward-1343",
-	       ergo(jnode_is_unformatted(node),
-		    get_inode_oid(page->mapping->host) ==
-		    node->key.j.objectid));
-	if (inode_file_plugin(page->mapping->host) ==
-	    file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID)) {
-#if REISER4_DEBUG
-		if (!jnode_is_cluster_page(node))
-			warning("edward-1345",
-			"inode %llu: cluster page of index %lu became private",
-			(unsigned long long)get_inode_oid(page->mapping->host),
-			page->index);
-#endif
-		return 1;
-	}
-	return 0;
+	assert("edward-1467", count > 0);
+	reiser4_invalidate_pages(inode->i_mapping,
+				 clust_to_pg(index, inode) + from,
+				 count, even_cows);
 }
-#endif  /*  0  */
 
-/* put cluster pages */
-void reiser4_release_cluster_pages(struct cluster_handle * clust)
+/* Put @count pages starting from @from offset */
+void __put_page_cluster(int from, int count,
+			struct page ** pages, struct inode  * inode)
 {
 	int i;
+	assert("edward-1468", pages != NULL);
+	assert("edward-1469", inode != NULL);
+	assert("edward-1470", from >= 0 && count >= 0);
+
+	for (i = 0; i < count; i++) {
+		assert("edward-1471", pages[from + i] != NULL);
+		assert("edward-1472",
+		       pages[from + i]->index == pages[from]->index + i);
 
-	assert("edward-447", clust != NULL);
-	for (i = 0; i < clust->nr_pages; i++) {
-
-		assert("edward-449", clust->pages[i] != NULL);
-
-		page_cache_release(clust->pages[i]);
+		put_cluster_page(pages[from + i]);
+		INODE_PGCOUNT_DEC(inode);
 	}
 }
 
-/* this is called when something is failed */
-static void
-reiser4_release_cluster_pages_and_jnode(struct cluster_handle * clust)
+/*
+ * This is dual to grab_page_cluster,
+ * however if @rw == WRITE_OP, then we call this function
+ * only if something is failed before checkin page cluster.
+ */
+void put_page_cluster(struct cluster_handle * clust,
+		      struct inode * inode, rw_op rw)
 {
-	jnode *node;
-
 	assert("edward-445", clust != NULL);
 	assert("edward-922", clust->pages != NULL);
-	assert("edward-446", clust->pages[0] != NULL);
-
-	node = jprivate(clust->pages[0]);
-
-	assert("edward-447", node != NULL);
+	assert("edward-446",
+	       ergo(clust->nr_pages != 0, clust->pages[0] != NULL));
 
-	reiser4_release_cluster_pages(clust);
-	jput(node);
+	__put_page_cluster(0, clust->nr_pages, clust->pages, inode);
+	if (rw == WRITE_OP) {
+		if (unlikely(clust->node)) {
+			assert("edward-447",
+			       clust->node == jprivate(clust->pages[0]));
+			jput(clust->node);
+			clust->node = NULL;
+		}
+	}
 }
 
 #if REISER4_DEBUG
+int cryptcompress_inode_ok(struct inode *inode)
+{
+	if (!(reiser4_inode_data(inode)->plugin_mask & (1 << PSET_FILE)))
+		return 0;
+	if (!cluster_shift_ok(inode_cluster_shift(inode)))
+		return 0;
+	return 1;
+}
+
 static int window_ok(struct reiser4_slide * win, struct inode *inode)
 {
 	assert("edward-1115", win != NULL);
@@ -1621,6 +1447,42 @@ static int cluster_ok(struct cluster_han
 		return 0;
 	return (clust->win ? window_ok(clust->win, inode) : 1);
 }
+#if 0
+static int pages_truncate_ok(struct inode *inode, pgoff_t start)
+{
+	int found;
+	struct page * page;
+
+	found = find_get_pages(inode->i_mapping, start, 1, &page);
+	if (found)
+		put_cluster_page(page);
+	return !found;
+}
+#else
+#define pages_truncate_ok(inode, start) 1
+#endif
+
+static int jnode_truncate_ok(struct inode *inode, cloff_t index)
+{
+	jnode *node;
+	node = jlookup(current_tree, get_inode_oid(inode),
+		       clust_to_pg(index, inode));
+	if (likely(!node))
+		return 1;
+	jput(node);
+	return 0;
+}
+
+static int find_fake_appended(struct inode *inode, cloff_t * index);
+
+static int body_truncate_ok(struct inode *inode, cloff_t aidx)
+{
+	int result;
+	cloff_t raidx;
+
+	result = find_fake_appended(inode, &raidx);
+	return !result && (aidx == raidx);
+}
 #endif
 
 /* guess next window stat */
@@ -1631,9 +1493,10 @@ static inline window_stat next_window_st
 		HOLE_WINDOW : DATA_WINDOW);
 }
 
-/* guess next cluster index and window params */
-static void update_cluster(struct inode * inode, struct cluster_handle * clust,
-			   loff_t file_off, loff_t to_file)
+/* guess and set next cluster index and window params */
+static void move_update_window(struct inode * inode,
+			       struct cluster_handle * clust,
+			       loff_t file_off, loff_t to_file)
 {
 	struct reiser4_slide * win;
 
@@ -1647,28 +1510,27 @@ static void update_cluster(struct inode 
 
 	switch (win->stat) {
 	case DATA_WINDOW:
-		/* increment window position */
+		/* increment */
 		clust->index++;
 		win->stat = DATA_WINDOW;
 		win->off = 0;
-		win->count = min_count(inode_cluster_size(inode), to_file);
+		win->count = min((loff_t)inode_cluster_size(inode), to_file);
 		break;
 	case HOLE_WINDOW:
 		switch (next_window_stat(win)) {
 		case HOLE_WINDOW:
-			/* set window to fit the offset we start write from */
+			/* skip */
 			clust->index = off_to_clust(file_off, inode);
 			win->stat = HOLE_WINDOW;
 			win->off = 0;
 			win->count = off_to_cloff(file_off, inode);
-			win->delta =
-			    min_count(inode_cluster_size(inode) - win->count,
-				      to_file);
+			win->delta = min((loff_t)(inode_cluster_size(inode) -
+						  win->count), to_file);
 			break;
 		case DATA_WINDOW:
-			/* do not move the window, just change its state,
-			   off+count+delta=inv */
+			/* stay */
 			win->stat = DATA_WINDOW;
+			/* off+count+delta=inv */
 			win->off = win->off + win->count;
 			win->count = win->delta;
 			win->delta = 0;
@@ -1689,9 +1551,9 @@ static int update_sd_cryptcompress(struc
 
 	assert("edward-978", reiser4_schedulable());
 
-	result = reiser4_grab_space_force(	/* one for stat data update */
-						 estimate_update_common(inode),
-						 BA_CAN_COMMIT);
+	result = reiser4_grab_space_force(/* one for stat data update */
+					  estimate_update_common(inode),
+					  BA_CAN_COMMIT);
 	if (result)
 		return result;
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
@@ -1700,49 +1562,360 @@ static int update_sd_cryptcompress(struc
 	return result;
 }
 
-/* NOTE-Edward: this is too similar to reiser4/txnmgr.c:uncapture_jnode() */
-static void uncapture_cluster_jnode(jnode * node)
+static void uncapture_cluster_jnode(jnode * node)
+{
+	txn_atom *atom;
+
+	assert_spin_locked(&(node->guard));
+
+	atom = jnode_get_atom(node);
+	if (atom == NULL) {
+		assert("jmacd-7111", !JF_ISSET(node, JNODE_DIRTY));
+		spin_unlock_jnode(node);
+		return;
+	}
+	reiser4_uncapture_block(node);
+	spin_unlock_atom(atom);
+	jput(node);
+}
+
+static void put_found_pages(struct page **pages, int nr)
+{
+	int i;
+	for (i = 0; i < nr; i++) {
+		assert("edward-1045", pages[i] != NULL);
+		put_cluster_page(pages[i]);
+	}
+}
+
+/*             Lifecycle of a logical cluster in the system.
+ *
+ *
+ * Logical cluster of a cryptcompress file is represented in the system by
+ * . page cluster (in memory, primary cache, contains plain text);
+ * . disk cluster (in memory, secondary cache, contains transformed text).
+ * Primary cache is to reduce number of transform operations (compression,
+ * encryption), i.e. to implement transform-caching strategy.
+ * Secondary cache is to reduce number of I/O operations, i.e. for usual
+ * write-caching strategy. Page cluster is a set of pages, i.e. mapping of
+ * a logical cluster to the primary cache. Disk cluster is a set of items
+ * of the same type defined by some reiser4 item plugin id.
+ *
+ *              1. Performing modifications
+ *
+ * Every modification of a cryptcompress file is considered as a set of
+ * operations performed on file's logical clusters. Every such "atomic"
+ * modification is truncate, append and(or) overwrite some bytes of a
+ * logical cluster performed in the primary cache with the following
+ * synchronization with the secondary cache (in flush time). Disk clusters,
+ * which live in the secondary cache, are supposed to be synchronized with
+ * disk. The mechanism of synchronization of primary and secondary caches
+ * includes so-called checkin/checkout technique described below.
+ *
+ *              2. Submitting modifications
+ *
+ * Each page cluster has associated jnode (a special in-memory header to
+ * keep a track of transactions in reiser4), which is attached to its first
+ * page when grabbing page cluster for modifications (see grab_page_cluster).
+ * Submitting modifications (see checkin_logical_cluster) is going per logical
+ * cluster and includes:
+ * . checkin_cluster_size;
+ * . checkin_page_cluster.
+ * checkin_cluster_size() is resolved to file size update (which completely
+ * defines new size of logical cluster (number of file's bytes in a logical
+ * cluster).
+ * checkin_page_cluster() captures jnode of a page cluster and installs
+ * jnode's dirty flag (if needed) to indicate that modifications are
+ * successfully checked in.
+ *
+ *              3. Checking out modifications
+ *
+ * Is going per logical cluster in flush time (see checkout_logical_cluster).
+ * This is the time of synchronizing primary and secondary caches.
+ * checkout_logical_cluster() includes:
+ * . checkout_page_cluster (retrieving checked in pages).
+ * . uncapture jnode (including clear dirty flag and unlock)
+ *
+ *              4. Committing modifications
+ *
+ * Proceeding a synchronization of primary and secondary caches. When checking
+ * out page cluster (the phase above) pages are locked/flushed/unlocked
+ * one-by-one in ascending order of their indexes to contiguous stream, which
+ * is supposed to be transformed (compressed, encrypted), chopped up into items
+ * and committed to disk as a disk cluster.
+ *
+ *              5. Managing page references
+ *
+ * Every checked in page have a special additional "control" reference,
+ * which is dropped at checkout. We need this to avoid unexpected evicting
+ * pages from memory before checkout. Control references are managed so
+ * they are not accumulated with every checkin:
+ *
+ *            0
+ * checkin -> 1
+ *            0 -> checkout
+ * checkin -> 1
+ * checkin -> 1
+ * checkin -> 1
+ *            0 -> checkout
+ *           ...
+ *
+ * Every page cluster has its own unique "cluster lock". Update/drop
+ * references are serialized via this lock. Number of checked in cluster
+ * pages is calculated by i_size under cluster lock. File size is updated
+ * at every checkin action also under cluster lock (except cases of
+ * appending/truncating fake logical clusters).
+ *
+ * Proof of correctness:
+ *
+ * Since we update file size under cluster lock, in the case of non-fake
+ * logical cluster with its lock held we do have expected number of checked
+ * in pages. On the other hand, append/truncate of fake logical clusters
+ * doesn't change number of checked in pages of any cluster.
+ *
+ * NOTE-EDWARD: As cluster lock we use guard (spinlock_t) of its jnode.
+ * Currently, I don't see any reason to create a special lock for those
+ * needs.
+ */
+
+static inline void lock_cluster(jnode * node)
+{
+	spin_lock_jnode(node);
+}
+
+static inline void unlock_cluster(jnode * node)
+{
+	spin_unlock_jnode(node);
+}
+
+static inline void unlock_cluster_uncapture(jnode * node)
+{
+	uncapture_cluster_jnode(node);
+}
+
+/* Set new file size by window. Cluster lock is required. */
+static void checkin_file_size(struct cluster_handle * clust,
+			      struct inode * inode)
+{
+	loff_t new_size;
+	struct reiser4_slide * win;
+
+	assert("edward-1181", clust != NULL);
+	assert("edward-1182", inode != NULL);
+	assert("edward-1473", clust->pages != NULL);
+	assert("edward-1474", clust->pages[0] != NULL);
+	assert("edward-1475", jprivate(clust->pages[0]) != NULL);
+	assert_spin_locked(&(jprivate(clust->pages[0])->guard));
+
+
+	win = clust->win;
+	assert("edward-1183", win != NULL);
+
+	new_size = clust_to_off(clust->index, inode) + win->off;
+
+	switch (clust->op) {
+	case LC_APPOV:
+		if (new_size + win->count <= i_size_read(inode))
+			/* overwrite only */
+			return;
+		new_size += win->count;
+		break;
+	case LC_TRUNC:
+		break;
+	default:
+		impossible("edward-1184", "bad page cluster option");
+		break;
+	}
+	inode_check_scale_nolock(inode, i_size_read(inode), new_size);
+	i_size_write(inode, new_size);
+	return;
+}
+
+static inline void checkin_cluster_size(struct cluster_handle * clust,
+					struct inode * inode)
+{
+	if (clust->win)
+		checkin_file_size(clust, inode);
+}
+
+static int checkin_page_cluster(struct cluster_handle * clust,
+				struct inode * inode)
+{
+	int result;
+	jnode * node;
+	int old_nrpages = clust->old_nrpages;
+	int new_nrpages = get_new_nrpages(clust);
+
+	node = clust->node;
+
+	assert("edward-221", node != NULL);
+	assert("edward-971", clust->reserved == 1);
+	assert("edward-1263",
+	       clust->reserved_prepped == estimate_update_cluster(inode));
+	assert("edward-1264", clust->reserved_unprepped == 0);
+
+	if (JF_ISSET(node, JNODE_DIRTY)) {
+		/*
+		 * page cluster was checked in, but not yet
+		 * checked out, so release related resources
+		 */
+		free_reserved4cluster(inode, clust,
+				      estimate_update_cluster(inode));
+		__put_page_cluster(0, clust->old_nrpages,
+				   clust->pages, inode);
+	} else {
+		result = capture_cluster_jnode(node);
+		if (unlikely(result)) {
+			unlock_cluster(node);
+			return result;
+		}
+		jnode_make_dirty_locked(node);
+		clust->reserved = 0;
+	}
+	unlock_cluster(node);
+
+	if (new_nrpages < old_nrpages) {
+		/* truncate >= 1 complete pages */
+		__put_page_cluster(new_nrpages,
+				   old_nrpages - new_nrpages,
+				   clust->pages, inode);
+		truncate_page_cluster_range(inode,
+					    clust->pages, clust->index,
+					    new_nrpages,
+					    old_nrpages - new_nrpages,
+					    0);
+	}
+#if REISER4_DEBUG
+	clust->reserved_prepped -= estimate_update_cluster(inode);
+#endif
+	return 0;
+}
+
+/* Submit modifications of a logical cluster */
+static int checkin_logical_cluster(struct cluster_handle * clust,
+				   struct inode *inode)
+{
+	int result = 0;
+	jnode * node;
+
+	node = clust->node;
+
+	assert("edward-1035", node != NULL);
+	assert("edward-1029", clust != NULL);
+	assert("edward-1030", clust->reserved == 1);
+	assert("edward-1031", clust->nr_pages != 0);
+	assert("edward-1032", clust->pages != NULL);
+	assert("edward-1033", clust->pages[0] != NULL);
+	assert("edward-1446", jnode_is_cluster_page(node));
+	assert("edward-1476", node == jprivate(clust->pages[0]));
+
+	lock_cluster(node);
+	checkin_cluster_size(clust, inode);
+	/* this will unlock cluster */
+	result = checkin_page_cluster(clust, inode);
+	jput(node);
+	clust->node = NULL;
+	return result;
+}
+
+/*
+ * Retrieve size of logical cluster that was checked in at
+ * the latest modifying session (cluster lock is required)
+ */
+static inline void checkout_cluster_size(struct cluster_handle * clust,
+					 struct inode * inode)
 {
-	txn_atom *atom;
-
-	assert_spin_locked(&(node->guard));
-
-	/*jnode_make_clean(node); */
-	atom = jnode_get_atom(node);
-	if (atom == NULL) {
-		assert("jmacd-7111", !JF_ISSET(node, JNODE_DIRTY));
-		spin_unlock_jnode(node);
-		return;
-	}
+	struct tfm_cluster *tc = &clust->tc;
 
-	reiser4_uncapture_block(node);
-	spin_unlock_atom(atom);
-	jput(node);
+	tc->len = lbytes(clust->index, inode);
+	assert("edward-1478", tc->len != 0);
 }
 
-static void forget_cluster_pages(struct page **pages, int nr)
+/*
+ * Retrieve a page cluster with the latest submitted modifications
+ * and flush its pages to previously allocated contiguous stream.
+ */
+static void checkout_page_cluster(struct cluster_handle * clust,
+				  jnode * node, struct inode * inode)
 {
 	int i;
-	for (i = 0; i < nr; i++) {
+	int found;
+	int to_put;
+	struct tfm_cluster *tc = &clust->tc;
 
-		assert("edward-1045", pages[i] != NULL);
-		page_cache_release(pages[i]);
+	/* find and put checked in pages: cluster is locked,
+	 * so we must get expected number (to_put) of pages
+	 */
+	to_put = size_in_pages(lbytes(clust->index, inode));
+	found = find_get_pages(inode->i_mapping,
+			       clust_to_pg(clust->index, inode),
+			       to_put, clust->pages);
+	BUG_ON(found != to_put);
+
+	__put_page_cluster(0, to_put, clust->pages, inode);
+	unlock_cluster_uncapture(node);
+
+	/* Flush found pages.
+	 *
+	 * Note, that we don't disable modifications while flushing,
+	 * moreover, some found pages can be truncated, as we have
+	 * released cluster lock.
+	 */
+	for (i = 0; i < found; i++) {
+		int in_page;
+		char * data;
+		assert("edward-1479",
+		       clust->pages[i]->index == clust->pages[0]->index + i);
+
+		lock_page(clust->pages[i]);
+		if (!PageUptodate(clust->pages[i])) {
+			/* page was truncated */
+			assert("edward-1480",
+			       i_size_read(inode) <= page_offset(clust->pages[i]));
+			assert("edward-1481",
+			       clust->pages[i]->mapping != inode->i_mapping);
+			unlock_page(clust->pages[i]);
+			break;
+		}
+		/* Update the number of bytes in the logical cluster,
+		 * as it could be partially truncated. Note, that only
+		 * partial truncate is possible (complete truncate can
+		 * not go here, as it is performed via ->kill_hook()
+                 * called by cut_file_items(), and the last one must
+                 * wait for znode locked with parent coord).
+		 */
+		checkout_cluster_size(clust, inode);
+
+		/* this can be zero, as new file size is
+		   checked in before truncating pages */
+		in_page = __mbp(tc->len, i);
+
+		data = kmap(clust->pages[i]);
+		memcpy(tfm_stream_data(tc, INPUT_STREAM) + pg_to_off(i),
+		       data, in_page);
+		kunmap(clust->pages[i]);
+
+		if (PageDirty(clust->pages[i]))
+			cancel_dirty_page(clust->pages[i], PAGE_CACHE_SIZE);
+
+		unlock_page(clust->pages[i]);
+
+		if (in_page < PAGE_CACHE_SIZE)
+			/* end of the file */
+			break;
 	}
+	put_found_pages(clust->pages, found); /* find_get_pages */
+	tc->lsize = tc->len;
+	return;
 }
 
-/* Check out last modifications we are about to commit,
-   and prepare input stream for transform operations.
-*/
-int flush_cluster_pages(struct cluster_handle * clust, jnode * node,
-			struct inode *inode)
+/* Check out modifications of a logical cluster */
+int checkout_logical_cluster(struct cluster_handle * clust,
+			     jnode * node, struct inode *inode)
 {
-	int result = 0;
-	int i;
-	int nr_pages = 0;
+	int result;
 	struct tfm_cluster *tc = &clust->tc;
-#if REISER4_DEBUG
-	int node_pgcount;
-#endif
+
 	assert("edward-980", node != NULL);
 	assert("edward-236", inode != NULL);
 	assert("edward-237", clust != NULL);
@@ -1752,85 +1925,26 @@ int flush_cluster_pages(struct cluster_h
 
 	result = grab_tfm_stream(inode, tc, INPUT_STREAM);
 	if (result) {
-		warning("edward-1430",
-			"alloc stream failed with ret=%d", result);
-		return result;
+		warning("edward-1430", "alloc stream failed with ret=%d",
+			result);
+		return RETERR(-E_REPEAT);
 	}
-	spin_lock_jnode(node);
-#if REISER4_DEBUG
- 	node_pgcount = node->page_count;
-#endif
- 	if (!JF_ISSET(node, JNODE_DIRTY)) {
- 		/* race with another flush */
-#if REISER4_DEBUG
- 		assert("edward-981", node_pgcount == 0);
- 		warning("edward-982", "flush_cluster_pages: jnode is not dirty "
- 			"clust %lu, inode %llu\n",
- 			clust->index, (unsigned long long)get_inode_oid(inode));
-#endif
- 		spin_unlock_jnode(node);
+	lock_cluster(node);
+
+ 	if (unlikely(!JF_ISSET(node, JNODE_DIRTY))) {
+		/* race with another flush */
+ 		warning("edward-982",
+			"checking out logical cluster %lu of inode %llu: "
+			"jnode is not dirty", clust->index,
+			(unsigned long long)get_inode_oid(inode));
+ 		unlock_cluster(node);
  		return RETERR(-E_REPEAT);
  	}
-	/* Check out a size of logical cluster and
-	   set a number of cluster pages to commit. */
-	tc->len = tc->lsize = fsize_to_count(clust, inode);
-	clust->nr_pages = count_to_nrpages(tc->len);
-
-#if REISER4_DEBUG
-	node->page_count = 0;
-#endif
 	cluster_reserved2grabbed(estimate_update_cluster(inode));
-	uncapture_cluster_jnode(node);
 
-	assert("edward-1224", reiser4_schedulable());
-	/* Check out page cluster for commit */
-	nr_pages =
-	      find_get_pages(inode->i_mapping, clust_to_pg(clust->index, inode),
-			     clust->nr_pages, clust->pages);
- 	if (nr_pages != clust->nr_pages)
- 		goto checkout_failed;
-
-	/* Try to construct input stream from the checked out pages */
-	for (i = 0; i < clust->nr_pages; i++) {
-		char *data;
-
-		assert("edward-242", clust->pages[i] != NULL);
- 		if (clust->pages[i]->index !=
- 		    clust_to_pg(clust->index, inode) + i)
- 			goto checkout_failed;
- 		BUG_ON(!PageUptodate(clust->pages[i]));
-
- 		/* flush the page into input transform stream */
-		lock_page(clust->pages[i]);
-		data = kmap(clust->pages[i]);
-
-		assert("edward-986", cnt_to_pgcnt(tc->len, i) != 0);
-
-		memcpy(tfm_stream_data(tc, INPUT_STREAM) + pg_to_off(i),
-		       data, cnt_to_pgcnt(tc->len, i));
-		kunmap(clust->pages[i]);
-		unlock_page(clust->pages[i]);
-	}
-	/* page cluster flushed successfully */
-
-	clear_cluster_pages_dirty(clust);
-      	reiser4_release_cluster_pages(clust);
-#if REISER4_DEBUG
-	cryptcompress_inode_data(inode)->pgcount -= clust->nr_pages;
-#endif
-	goto out;
- checkout_failed:
-#if REISER4_DEBUG
-	assert("edward-1282", node_pgcount == 0);
-	warning("edward-1435", "Inode %llu : checkout page cluster"
-		"of index %lu failed\n",
-			(unsigned long long)get_inode_oid(inode), clust->index);
-#endif /* REISER4_DEBUG */
-	result = RETERR(-E_REPEAT);
- out:
-	/* put pages that were found here */
-	forget_cluster_pages(clust->pages, nr_pages);
-	return result;
+	/* this will unlock cluster */
+	checkout_page_cluster(clust, node, inode);
+	return 0;
 }
 
 /* set hint for the cluster of the index @index */
@@ -1876,19 +1990,23 @@ static int balance_dirty_page_cluster(st
 				      loff_t to_file)
 {
 	int result;
+	struct cryptcompress_info * info;
 
 	assert("edward-724", inode != NULL);
 	assert("edward-725", cryptcompress_inode_ok(inode));
 
 	/* set next window params */
-	update_cluster(inode, clust, off, to_file);
+	move_update_window(inode, clust, off, to_file);
 
 	result = update_sd_cryptcompress(inode);
 	if (result)
 		return result;
 	assert("edward-726", clust->hint->lh.owner == NULL);
+	info = cryptcompress_inode_data(inode);
 
+	mutex_unlock(&info->checkin_mutex);
 	reiser4_throttle_write(inode);
+	mutex_lock(&info->checkin_mutex);
 	return 0;
 }
 
@@ -1917,8 +2035,13 @@ static int write_hole(struct inode *inod
 	assert("edward-192", cluster_ok(clust, inode));
 
 	if (win->off == 0 && win->count == inode_cluster_size(inode)) {
-		/* the hole will be represented by fake disk cluster */
-		update_cluster(inode, clust, file_off, to_file);
+		/* This part of the hole will be represented by "fake"
+		 * logical cluster, i.e. which doesn't have appropriate
+		 * disk cluster until someone modify this logical cluster
+		 * and make it dirty.
+		 * So go forward here..
+		 */
+		move_update_window(inode, clust, file_off, to_file);
 		return 0;
 	}
 	cl_count = win->count;	/* number of zeroes to write */
@@ -1931,10 +2054,12 @@ static int write_hole(struct inode *inod
 
 		assert("edward-284", page != NULL);
 
-		to_pg = min_count(PAGE_CACHE_SIZE - pg_off, cl_count);
+		to_pg = min((typeof(pg_off))PAGE_CACHE_SIZE - pg_off, cl_count);
 		lock_page(page);
 		zero_user_page(page, pg_off, to_pg, KM_USER0);
 		SetPageUptodate(page);
+		reiser4_set_page_dirty_internal(page);
+		mark_page_accessed(page);
 		unlock_page(page);
 
 		cl_off += to_pg;
@@ -1942,17 +2067,16 @@ static int write_hole(struct inode *inod
 		pg_off = 0;
 	}
 	if (!win->delta) {
-		/* only zeroes, try to capture */
-
-		set_cluster_pages_dirty(clust);
-		result = try_capture_cluster(clust, inode);
+		/* only zeroes in this window, try to capture
+		 */
+		result = checkin_logical_cluster(clust, inode);
 		if (result)
 			return result;
 		put_hint_cluster(clust, inode, ZNODE_WRITE_LOCK);
 		result =
 		    balance_dirty_page_cluster(clust, inode, file_off, to_file);
 	} else
-		update_cluster(inode, clust, file_off, to_file);
+		move_update_window(inode, clust, file_off, to_file);
 	return result;
 }
 
@@ -1971,12 +2095,12 @@ int find_disk_cluster(struct cluster_han
 	flow_t f;
 	hint_t *hint;
 	int result = 0;
-	unsigned long cl_idx;
+	int was_grabbed;
 	ra_info_t ra_info;
 	file_plugin *fplug;
 	item_plugin *iplug;
 	struct tfm_cluster *tc;
-	int was_grabbed;
+	struct cryptcompress_info * info;
 
 	assert("edward-138", clust != NULL);
 	assert("edward-728", clust->hint != NULL);
@@ -1985,9 +2109,9 @@ int find_disk_cluster(struct cluster_han
 	assert("edward-729", cryptcompress_inode_ok(inode));
 
 	hint = clust->hint;
-	cl_idx = clust->index;
 	fplug = inode_file_plugin(inode);
 	was_grabbed = get_current_context()->grabbed_blocks;
+	info = cryptcompress_inode_data(inode);
 	tc = &clust->tc;
 
 	assert("edward-462", !tfm_cluster_is_uptodate(tc));
@@ -2000,7 +2124,7 @@ int find_disk_cluster(struct cluster_han
 			     (read ? (char __user *)tfm_stream_data(tc, INPUT_STREAM) : NULL),
 			     0 /* kernel space */ ,
 			     inode_scaled_cluster_size(inode),
-			     clust_to_off(cl_idx, inode), READ_OP, &f);
+			     clust_to_off(clust->index, inode), READ_OP, &f);
 	if (mode == ZNODE_WRITE_LOCK) {
 		/* reserve for flush to make dirty all the leaf nodes
 		   which contain disk cluster */
@@ -2023,9 +2147,8 @@ int find_disk_cluster(struct cluster_han
 		case CBK_COORD_NOTFOUND:
 			result = 0;
 			if (inode_scaled_offset
-			    (inode,
-			     clust_to_off(cl_idx,
-					  inode)) == get_key_offset(&f.key)) {
+			    (inode, clust_to_off(clust->index, inode)) ==
+			    get_key_offset(&f.key)) {
 				/* first item not found, this is treated
 				   as disk cluster is absent */
 				clust->dstat = FAKE_DISK_CLUSTER;
@@ -2079,15 +2202,17 @@ int find_disk_cluster(struct cluster_han
 	/* NOTE-EDWARD: Callers should handle the case
 	   when disk cluster is incomplete (-EIO) */
 	tc->len = inode_scaled_cluster_size(inode) - f.length;
-	tc->lsize = fsize_to_count(clust, inode);
+	tc->lsize = lbytes(clust->index, inode);
 	assert("edward-1196", tc->len > 0);
 	assert("edward-1406", tc->lsize > 0);
 
-	if (hint_is_unprepped_dclust(clust->hint))
+	if (hint_is_unprepped_dclust(clust->hint)) {
 		clust->dstat = UNPR_DISK_CLUSTER;
-	else {
-		dclust_set_extension_dsize(clust->hint, tc->len);
+	} else if (clust->index == info->trunc_index) {
+		clust->dstat = TRNC_DISK_CLUSTER;
+	} else {
 		clust->dstat = PREP_DISK_CLUSTER;
+		dclust_set_extension_dsize(clust->hint, tc->len);
 	}
  out:
 	assert("edward-1339",
@@ -2150,10 +2275,10 @@ static int read_some_cluster_pages(struc
 		/* start write hole from fake disk cluster */
 		assert("edward-1117", win != NULL);
 		assert("edward-1118", win->stat == HOLE_WINDOW);
-		assert("edward-1119", new_cluster(clust, inode));
+		assert("edward-1119", new_logical_cluster(clust, inode));
 	}
 #endif
-	if (new_cluster(clust, inode)) {
+	if (new_logical_cluster(clust, inode)) {
 		/*
 		   new page cluster is about to be written, nothing to read,
 		 */
@@ -2197,7 +2322,7 @@ static int read_some_cluster_pages(struc
 		unlock_page(pg);
 
 		if (win &&
-		    i >= count_to_nrpages(win->off) &&
+		    i >= size_in_pages(win->off) &&
 		    i < off_to_pg(win->off + win->count + win->delta))
 			/* page will be completely overwritten */
 			continue;
@@ -2206,14 +2331,14 @@ static int read_some_cluster_pages(struc
 		    /* the last page is
 		       partially modified,
 		       not uptodate .. */
-		    (count_to_nrpages(inode->i_size) <= pg->index)) {
+		    (size_in_pages(i_size_read(inode)) <= pg->index)) {
 			/* .. and appended,
 			   so set zeroes to the rest */
 			int offset;
 			lock_page(pg);
 			assert("edward-1260",
-			       count_to_nrpages(win->off + win->count +
-						win->delta) - 1 == i);
+			       size_in_pages(win->off + win->count +
+					     win->delta) - 1 == i);
 
 			offset =
 			    off_to_pgoff(win->off + win->count + win->delta);
@@ -2223,26 +2348,22 @@ static int read_some_cluster_pages(struc
 			/* still not uptodate */
 			break;
 		}
-		if (!tfm_cluster_is_uptodate(&clust->tc)) {
-			result = ctail_read_disk_cluster(clust, inode, mode);
-			if (result)
-				goto out;
-			assert("edward-925",
-			       tfm_cluster_is_uptodate(&clust->tc));
-		}
 		lock_page(pg);
 		result = do_readpage_ctail(inode, clust, pg, mode);
+
+		assert("edward-1526", ergo(!result, PageUptodate(pg)));
 		unlock_page(pg);
 		if (result) {
-			impossible("edward-219",
-				   "do_readpage_ctail returned crap");
+			warning("edward-219", "do_readpage_ctail failed");
 			goto out;
 		}
 	}
 	if (!tfm_cluster_is_uptodate(&clust->tc)) {
 		/* disk cluster unclaimed, but we need to make its znodes dirty
-		   to make flush update convert its content */
-		result = find_disk_cluster(clust, inode, 0 /* do not read items */,
+		 * to make flush update convert its content
+		 */
+		result = find_disk_cluster(clust, inode,
+					   0 /* do not read items */,
 					   mode);
 	}
  out:
@@ -2262,7 +2383,8 @@ static int should_create_unprepped_clust
 	case FAKE_DISK_CLUSTER:
 		if (clust->win &&
 		    clust->win->stat == HOLE_WINDOW && clust->nr_pages == 0) {
-			assert("edward-1172", new_cluster(clust, inode));
+			assert("edward-1172",
+			       new_logical_cluster(clust, inode));
 			return 0;
 		}
 		return 1;
@@ -2316,26 +2438,11 @@ static int cryptcompress_make_unprepped_
 	return 0;
 }
 
-#if REISER4_DEBUG
-static int jnode_truncate_ok(struct inode *inode, cloff_t index)
-{
-	jnode *node;
-	node =
-	    jlookup(current_tree, get_inode_oid(inode),
-		    clust_to_pg(index, inode));
-	if (likely(!node))
-		return 1;
-	/* someone got this jnode */
-	warning("edward-1315", "jnode %p is untruncated\n", node);
-	jput(node);
-	return (atomic_read(&node->x_count));
-}
-#endif
-
-/* Collect unlocked cluster pages and jnode (the last is in the
-   case when the page cluster will be modified and captured) */
+/* . Grab page cluster for read, write, setattr, etc. operations;
+ * . Truncate its complete pages, if needed;
+ */
 int prepare_page_cluster(struct inode * inode, struct cluster_handle * clust,
-			 int capture)
+			 rw_op rw)
 {
 	assert("edward-177", inode != NULL);
 	assert("edward-741", cryptcompress_inode_ok(inode));
@@ -2343,81 +2450,69 @@ int prepare_page_cluster(struct inode * 
 
 	set_cluster_nrpages(clust, inode);
 	reset_cluster_pgset(clust, cluster_nrpages(inode));
-	return (capture ?
-		grab_cluster_pages_jnode(inode, clust) :
-		grab_cluster_pages(inode, clust));
+	return grab_page_cluster(inode, clust, rw);
 }
 
-/* Truncate all pages of the cluster of index @index.
-   This is called by ->kill_hook() method of item plugin */
-void truncate_page_cluster_cryptcompress(struct inode *inode, cloff_t index,
-					 int even_cows)
+/* Truncate complete page cluster of index @index.
+ * This is called by ->kill_hook() method of item
+ * plugin when deleting a disk cluster of such index.
+ */
+void truncate_complete_page_cluster(struct inode *inode, cloff_t index,
+				    int even_cows)
 {
-	int i;
-	int found = 0;
+	int found;
 	int nr_pages;
 	jnode *node;
 	struct page *pages[MAX_CLUSTER_NRPAGES];
 
-	node =
-	    jlookup(current_tree, get_inode_oid(inode),
-		    clust_to_pg(index, inode));
-	/* jnode is absent, just drop pages which can not
-	   acquire jnode because of exclusive access */
+	node = jlookup(current_tree, get_inode_oid(inode),
+		       clust_to_pg(index, inode));
+	nr_pages = size_in_pages(lbytes(index, inode));
+	assert("edward-1483", nr_pages != 0);
 	if (!node)
 		goto truncate;
-	/* jnode is present and may be dirty */
-	nr_pages = count_to_nrpages(cnt_to_clcnt(inode->i_size, index, inode));
-
-	found = find_get_pages(inode->i_mapping, clust_to_pg(index, inode),
-			       nr_pages, pages);
-	spin_lock_jnode(node);
+	found = find_get_pages(inode->i_mapping,
+			       clust_to_pg(index, inode),
+			       cluster_nrpages(inode), pages);
+	if (!found) {
+		assert("edward-1484", jnode_truncate_ok(inode, index));
+		return;
+	}
+	lock_cluster(node);
 
 	if (reiser4_inode_get_flag(inode, REISER4_FILE_CONV_IN_PROGRESS)
 	    && index == 0)
-		/* converting to unix_file in progress */
+		/* converting to unix_file is in progress */
 		JF_CLR(node, JNODE_CLUSTER_PAGE);
 	if (JF_ISSET(node, JNODE_DIRTY)) {
-		/* someone has done modifications which are not
-		   yet committed, so we need to release some resources */
+		/*
+		 * @nr_pages were checked in, but not yet checked out -
+		 * we need to release them. (also there can be pages
+		 * attached to page cache by read(), etc. - don't take
+		 * them into account).
+		 */
+		assert("edward-1198", found >= nr_pages);
 
 		/* free disk space grabbed for disk cluster converting */
 		cluster_reserved2grabbed(estimate_update_cluster(inode));
 		grabbed2free(get_current_context(),
 			     get_current_super_private(),
 			     estimate_update_cluster(inode));
+		__put_page_cluster(0, nr_pages, pages, inode);
 
-		assert("edward-1198", found == nr_pages);
-		assert("edward-1199", node->page_count == nr_pages);
-#if REISER4_DEBUG
-		node->page_count = 0;
-#endif
-		/* This will clear dirty bit */
-		uncapture_cluster_jnode(node);
-
-		/* put pages grabbed for last uncommitted modifications */
-		for (i = 0; i < nr_pages; i++) {
-			assert("edward-1200", PageUptodate(pages[i]));
-			page_cache_release(pages[i]);
-#if REISER4_DEBUG
-			cryptcompress_inode_data(inode)->pgcount --;
-#endif
-		}
+		/* This will clear dirty bit, uncapture and unlock jnode */
+		unlock_cluster_uncapture(node);
 	} else
-		spin_unlock_jnode(node);
-	/* FIXME-EDWARD: Use truncate_complete_page in the loop above instead */
-
-	jput(node);
-	/* put pages found here */
-	forget_cluster_pages(pages, found);
+		unlock_cluster(node);
+	jput(node);                         /* jlookup */
+	put_found_pages(pages, found); /* find_get_pages */
  truncate:
 	if (reiser4_inode_get_flag(inode, REISER4_FILE_CONV_IN_PROGRESS) &&
 	    index == 0)
 		return;
-	reiser4_invalidate_pages(inode->i_mapping,
-				 clust_to_pg(index, inode),
-				 cluster_nrpages(inode),
-				 even_cows);
+	truncate_page_cluster_range(inode, pages, index, 0,
+				    cluster_nrpages(inode),
+				    even_cows);
 	assert("edward-1201",
 	       ergo(!reiser4_inode_get_flag(inode,
 					    REISER4_FILE_CONV_IN_PROGRESS),
@@ -2425,21 +2520,23 @@ void truncate_page_cluster_cryptcompress
 	return;
 }
 
-/* Prepare cluster handle @clust before(after) modifications
-   which are supposed to be committed.
-
-   . grab cluster pages;
-   . reserve disk space;
-   . maybe read pages from disk and set the disk cluster dirty;
-   . maybe write hole;
-   . maybe create 'unprepped' disk cluster if the last one is fake
-     (i.e. is not represenred by any items)
-*/
-
-static int prepare_cluster(struct inode *inode,
-			   loff_t file_off, /* write position in the file */
-			   loff_t to_file, /* bytes of users data to write to the file */
-			   struct cluster_handle * clust, page_cluster_op op)
+/*
+ * Set cluster handle @clust of a logical cluster before
+ * modifications which are supposed to be committed.
+ *
+ * . grab cluster pages;
+ * . reserve disk space;
+ * . maybe read pages from disk and set the disk cluster dirty;
+ * . maybe write hole and check in (partially zeroed) logical cluster;
+ * . create 'unprepped' disk cluster for new or fake logical one.
+ */
+static int prepare_logical_cluster(struct inode *inode,
+				   loff_t file_off, /* write position
+						       in the file */
+				   loff_t to_file, /* bytes of users data
+						      to write to the file */
+				   struct cluster_handle * clust,
+				   logical_cluster_op op)
 {
 	int result = 0;
 	struct reiser4_slide * win = clust->win;
@@ -2449,11 +2546,11 @@ static int prepare_cluster(struct inode 
 #if REISER4_DEBUG
 	clust->ctx = get_current_context();
 #endif
-	assert("edward-1190", op != PCL_UNKNOWN);
+	assert("edward-1190", op != LC_INVAL);
 
 	clust->op = op;
 
-	result = prepare_page_cluster(inode, clust, 1);
+	result = prepare_page_cluster(inode, clust, WRITE_OP);
 	if (result)
 		return result;
 	assert("edward-1447",
@@ -2484,11 +2581,11 @@ static int prepare_cluster(struct inode 
 			goto err2;
 	}
 	return 0;
-      err2:
+ err2:
 	free_reserved4cluster(inode, clust,
 			      estimate_update_cluster(inode));
-      err1:
-	reiser4_release_cluster_pages_and_jnode(clust);
+ err1:
+	put_page_cluster(clust, inode, WRITE_OP);
 	assert("edward-1125", result == -ENOSPC);
 	return result;
 }
@@ -2506,7 +2603,8 @@ static void set_window(struct cluster_ha
 	clust->index = off_to_clust(o1, inode);
 
 	win->off = off_to_cloff(o1, inode);
-	win->count = min_count(inode_cluster_size(inode) - win->off, o2 - o1);
+	win->count = min((loff_t)(inode_cluster_size(inode) - win->off),
+			 o2 - o1);
 	win->delta = 0;
 
 	clust->win = win;
@@ -2514,7 +2612,7 @@ static void set_window(struct cluster_ha
 
 static int set_cluster_by_window(struct inode *inode,
 				 struct cluster_handle * clust,
-				 struct reiser4_slide * win, flow_t * f,
+				 struct reiser4_slide * win, size_t length,
 				 loff_t file_off)
 {
 	int result;
@@ -2527,7 +2625,7 @@ static int set_cluster_by_window(struct 
 	if (result)
 		return result;
 
-	if (file_off > inode->i_size) {
+	if (file_off > i_size_read(inode)) {
 		/* Uhmm, hole in cryptcompress file... */
 		loff_t hole_size;
 		hole_size = file_off - inode->i_size;
@@ -2536,12 +2634,11 @@ static int set_cluster_by_window(struct 
 		win->stat = HOLE_WINDOW;
 		if (win->off + hole_size < inode_cluster_size(inode))
 			/* there is also user's data to append to the hole */
-			win->delta =
-			    min_count(inode_cluster_size(inode) -
-				      (win->off + win->count), f->length);
+			win->delta = min(inode_cluster_size(inode) -
+					 (win->off + win->count), length);
 		return 0;
 	}
-	set_window(clust, win, inode, file_off, file_off + f->length);
+	set_window(clust, win, inode, file_off, file_off + length);
 	win->stat = DATA_WINDOW;
 	return 0;
 }
@@ -2574,25 +2671,17 @@ void reset_cluster_params(struct cluster
 	clust->tc.len = 0;
 }
 
-/* Core write procedure of cryptcompress plugin, which slices user's
-   flow into logical clusters, maps the last ones to the appropriate
-   page clusters, and tries to capture them.
-   If @buf != NULL, returns number of successfully written bytes,
-   otherwise returns error
-*/
-static loff_t
-write_cryptcompress_flow(struct file *file, struct inode *inode,
-			 const char __user *buf, size_t count, loff_t pos,
-			 int *conv_occured)
+static loff_t do_write_cryptcompress(struct file *file, struct inode *inode,
+				     const char __user *buf, size_t to_write,
+				     loff_t pos, int *conv_occured)
 {
 	int i;
-	flow_t f;
 	hint_t *hint;
 	int result = 0;
-	size_t to_write = 0;
-	loff_t file_off;
+	size_t count;
 	struct reiser4_slide win;
 	struct cluster_handle clust;
+	struct cryptcompress_info * info;
 
 	assert("edward-161", reiser4_schedulable());
 	assert("edward-748", cryptcompress_inode_ok(inode));
@@ -2608,47 +2697,47 @@ write_cryptcompress_flow(struct file *fi
 		kfree(hint);
 		return result;
 	}
+	count = to_write;
 
-	result =
-	    flow_by_inode_cryptcompress(inode, buf, 1 /* user space */ ,
-					count, pos, WRITE_OP, &f);
-	if (result)
-		goto out;
-	to_write = f.length;
-
-	/* current write position in file */
-	file_off = pos;
 	reiser4_slide_init(&win);
 	cluster_init_read(&clust, &win);
 	clust.hint = hint;
+	info = cryptcompress_inode_data(inode);
+
+	mutex_lock(&info->checkin_mutex);
 
-	result = set_cluster_by_window(inode, &clust, &win, &f, file_off);
+	result = set_cluster_by_window(inode, &clust, &win, to_write, pos);
 	if (result)
 		goto out;
 
 	if (next_window_stat(&win) == HOLE_WINDOW) {
-		result = write_conversion_hook(file, inode, pos, &clust, NULL);
+		/* write hole in this iteration
+		   separated from the loop below */
+		result = write_conversion_hook(file, inode,
+					       pos,
+					       &clust,
+					       NULL);
 		if (result)
 			goto out;
-		result =
-		    prepare_cluster(inode, file_off, f.length, &clust,
-				    PCL_APPEND);
+		result = prepare_logical_cluster(inode, pos, count, &clust,
+						 LC_APPOV);
 		if (result)
 			goto out;
 	}
 	do {
-		char *src;
-		unsigned page_off, page_count;
+		const char __user * src;
+		unsigned page_off, to_page;
 
 		assert("edward-750", reiser4_schedulable());
 
-		result = write_conversion_hook(file, inode, pos, &clust,
+		result = write_conversion_hook(file, inode,
+					       pos + to_write - count,
+					       &clust,
 					       conv_occured);
 		if (result || *conv_occured)
 			goto out;
-		result =
-		    prepare_cluster(inode, file_off, f.length, &clust,
-				    PCL_APPEND);
+		result = prepare_logical_cluster(inode, pos, count, &clust,
+						 LC_APPOV);
 		if (result)
 			goto out;
 
@@ -2657,27 +2746,26 @@ write_cryptcompress_flow(struct file *fi
 		assert("edward-1288", hint_is_valid(clust.hint));
 		assert("edward-752",
 		       znode_is_write_locked(hint->ext_coord.coord.node));
-
 		put_hint_cluster(&clust, inode, ZNODE_WRITE_LOCK);
 
 		/* set write position in page */
 		page_off = off_to_pgoff(win.off);
 
 		/* copy user's data to cluster pages */
-		for (i = off_to_pg(win.off), src = f.data;
-		     i < count_to_nrpages(win.off + win.count);
-		     i++, src += page_count) {
-			page_count =
-			    cnt_to_pgcnt(win.off + win.count, i) - page_off;
-
+		for (i = off_to_pg(win.off), src = buf;
+		     i < size_in_pages(win.off + win.count);
+		     i++, src += to_page) {
+			to_page = __mbp(win.off + win.count, i) - page_off;
 			assert("edward-1039",
-			       page_off + page_count <= PAGE_CACHE_SIZE);
+			       page_off + to_page <= PAGE_CACHE_SIZE);
 			assert("edward-287", clust.pages[i] != NULL);
 
+			fault_in_pages_readable(src, to_page);
+
 			lock_page(clust.pages[i]);
 			result =
 			    __copy_from_user((char *)kmap(clust.pages[i]) +
-					     page_off, (char __user *)src, page_count);
+					     page_off, src, to_page);
 			kunmap(clust.pages[i]);
 			if (unlikely(result)) {
 				unlock_page(clust.pages[i]);
@@ -2685,45 +2773,41 @@ write_cryptcompress_flow(struct file *fi
 				goto err2;
 			}
 			SetPageUptodate(clust.pages[i]);
+			reiser4_set_page_dirty_internal(clust.pages[i]);
+			flush_dcache_page(clust.pages[i]);
+			mark_page_accessed(clust.pages[i]);
 			unlock_page(clust.pages[i]);
 			page_off = 0;
 		}
 		assert("edward-753", cryptcompress_inode_ok(inode));
 
-		set_cluster_pages_dirty(&clust);
-
-		result = try_capture_cluster(&clust, inode);
+		result = checkin_logical_cluster(&clust, inode);
 		if (result)
 			goto err2;
 
-		assert("edward-998", f.user == 1);
+		buf   += win.count;
+		count -= win.count;
 
-		move_flow_forward(&f, win.count);
-
-		/* disk cluster may be already clean at this point */
-
-		/* . update cluster
-		   . set hint for new offset
-		   . unlock znode
-		   . update inode
-		   . balance dirty pages
-		 */
-		result = balance_dirty_page_cluster(&clust, inode, 0, f.length);
+		result = balance_dirty_page_cluster(&clust, inode, 0, count);
 		if (result)
 			goto err1;
 		assert("edward-755", hint->lh.owner == NULL);
 		reset_cluster_params(&clust);
 		continue;
-	      err2:
-		reiser4_release_cluster_pages_and_jnode(&clust);
-	      err1:
+	err2:
+		put_page_cluster(&clust, inode, WRITE_OP);
+	err1:
 		if (clust.reserved)
 			free_reserved4cluster(inode,
 					      &clust,
 					      estimate_update_cluster(inode));
 		break;
-	} while (f.length);
-      out:
+	} while (count);
+ out:
+	/*
+	 * NOTE: at this point file may have
+	 * another (unix-file) plugin installed
+	 */
 	done_lh(&hint->lh);
 	if (result == -EEXIST)
 		warning("edward-1407", "write returns EEXIST!\n");
@@ -2731,11 +2815,17 @@ write_cryptcompress_flow(struct file *fi
 	put_cluster_handle(&clust);
 	save_file_hint(file, hint);
 	kfree(hint);
+	/*
+	 * don't release cryptcompress-specific
+	 * checkin_mutex, if conversion occured
+	 */
+	if (*conv_occured == 0)
+		mutex_unlock(&info->checkin_mutex);
 	if (buf) {
 		/* if nothing were written - there must be an error */
-		assert("edward-195", ergo((to_write == f.length),
+		assert("edward-195", ergo((to_write == count),
 					  (result < 0 || *conv_occured)));
-		return (to_write - f.length) ? (to_write - f.length) : result;
+		return (to_write - count) ? (to_write - count) : result;
 	}
 	return result;
 }
@@ -2783,7 +2873,7 @@ ssize_t write_cryptcompress(struct file 
 	/* remove_suid might create a transaction */
 	reiser4_txn_restart(ctx);
 
-	result = write_cryptcompress_flow(file, inode, buf, count, pos, conv);
+	result = do_write_cryptcompress(file, inode, buf, count, pos, conv);
 
   	if (result < 0)
 		goto out;
@@ -2808,8 +2898,9 @@ int readpages_cryptcompress(struct file 
 		ret = PTR_ERR(ctx);
 		goto err;
 	}
-	/* crc files can be built of ctail items only */
+	/* cryptcompress file can be built of ctail items only */
 	ret = readpages_ctail(file, mapping, pages);
+	reiser4_txn_restart(ctx);
 	reiser4_exit_context(ctx);
 	if (ret) {
 err:
@@ -2861,30 +2952,23 @@ ssize_t read_cryptcompress(struct file *
 		reiser4_exit_context(ctx);
 		return result;
 	}
-
-	LOCK_CNT_INC(inode_sem_r);
-
 	result = do_sync_read(file, buf, size, off);
 
-	LOCK_CNT_DEC(inode_sem_r);
-
 	context_set_commit_async(ctx);
 	reiser4_exit_context(ctx);
 
 	return result;
 }
 
-/* If @index > 0, find real disk cluster of the index (@index - 1),
-   If @index == 0 find the real disk cluster of the object of maximal index.
-   Keep incremented index of the result in @found.
-   It succes was returned:
-   (@index == 0 && @found == 0) means that the object doesn't have real disk
-   clusters.
-   (@index != 0 && @found == 0) means that disk cluster of (@index -1) doesn't
-   exist.
-*/
-static int
-find_real_disk_cluster(struct inode *inode, cloff_t * found, cloff_t index)
+/* Look for a disk cluster and keep lookup result in @found.
+ * If @index > 0, then find disk cluster of the index (@index - 1);
+ * If @index == 0, then find the rightmost disk cluster.
+ * Keep incremented index of the found disk cluster in @found.
+ * @found == 0 means that disk cluster was not found (in the last
+ * case (@index == 0) it means that file doesn't have disk clusters).
+ */
+static int lookup_disk_cluster(struct inode *inode, cloff_t * found,
+			       cloff_t index)
 {
 	int result;
 	reiser4_key key;
@@ -2953,8 +3037,8 @@ find_real_disk_cluster(struct inode *ino
 
 static int find_fake_appended(struct inode *inode, cloff_t * index)
 {
-	return find_real_disk_cluster(inode, index,
-				      0 /* find last real one */ );
+	return lookup_disk_cluster(inode, index,
+				   0 /* find last real one */ );
 }
 
 /* Set left coord when unit is not found after node_lookup()
@@ -2976,11 +3060,11 @@ static void adjust_left_coord(coord_t * 
 }
 
 #define CRC_CUT_TREE_MIN_ITERATIONS 64
-int
-cut_tree_worker_cryptcompress(tap_t * tap, const reiser4_key * from_key,
-			      const reiser4_key * to_key,
-			      reiser4_key * smallest_removed,
-			      struct inode *object, int truncate, int *progress)
+int cut_tree_worker_cryptcompress(tap_t * tap, const reiser4_key * from_key,
+				  const reiser4_key * to_key,
+				  reiser4_key * smallest_removed,
+				  struct inode *object, int truncate,
+				  int *progress)
 {
 	lock_handle next_node_lock;
 	coord_t left_coord;
@@ -3056,9 +3140,6 @@ cut_tree_worker_cryptcompress(tap_t * ta
 					   smallest_removed,
 					   next_node_lock.node,
 					   object, truncate);
-#if REISER4_DEBUG
-		/*node_check(node, ~0U); */
-#endif
 		reiser4_tap_relse(tap);
 
 		if (result)
@@ -3092,12 +3173,13 @@ cut_tree_worker_cryptcompress(tap_t * ta
 	return result;
 }
 
-/* Append or expand hole in two steps (exclusive access should be aquired!)
-   1) write zeroes to the current real cluster,
-   2) expand hole via fake clusters (just increase i_size) */
-static int
-cryptcompress_append_hole(struct inode *inode /*contains old i_size */ ,
-			  loff_t new_size)
+/* Append or expand hole in two steps:
+ * 1) set zeroes to the rightmost page of the rightmost non-fake
+ *    logical cluster;
+ * 2) expand hole via fake logical clusters (just increase i_size)
+ */
+static int cryptcompress_append_hole(struct inode *inode /* with old size */,
+				     loff_t new_size)
 {
 	int result = 0;
 	hint_t *hint;
@@ -3127,7 +3209,7 @@ cryptcompress_append_hole(struct inode *
 	if (result)
 		goto out;
 	if (off_to_cloff(inode->i_size, inode) == 0)
-		goto fake_append;
+		goto append_fake;
 	hole_size = new_size - inode->i_size;
 	nr_zeroes =
 		inode_cluster_size(inode) - off_to_cloff(inode->i_size, inode);
@@ -3140,7 +3222,7 @@ cryptcompress_append_hole(struct inode *
 	assert("edward-1137",
 	       clust.index == off_to_clust(inode->i_size, inode));
 
-	result = prepare_cluster(inode, 0, 0, &clust, PCL_APPEND);
+	result = prepare_logical_cluster(inode, 0, 0, &clust, LC_APPOV);
 
 	assert("edward-1271", !result || result == -ENOSPC);
 	if (result)
@@ -3153,58 +3235,15 @@ cryptcompress_append_hole(struct inode *
 	if (hole_size == nr_zeroes)
 	/* nothing to append anymore */
 		goto out;
-      fake_append:
-	INODE_SET_FIELD(inode, i_size, new_size);
-      out:
+ append_fake:
+	INODE_SET_SIZE(inode, new_size);
+ out:
 	done_lh(lh);
 	kfree(hint);
 	put_cluster_handle(&clust);
 	return result;
 }
 
-#if REISER4_DEBUG
-static int
-pages_truncate_ok(struct inode *inode, loff_t old_size, pgoff_t start)
-{
-	struct pagevec pvec;
-	int i;
-	int count;
-	int rest;
-
-	rest = count_to_nrpages(old_size) - start;
-
-	pagevec_init(&pvec, 0);
-	count = min_count(pagevec_space(&pvec), rest);
-
-	while (rest) {
-		count = min_count(pagevec_space(&pvec), rest);
-		pvec.nr = find_get_pages(inode->i_mapping, start,
-					 count, pvec.pages);
-		for (i = 0; i < pagevec_count(&pvec); i++) {
-			if (PageUptodate(pvec.pages[i])) {
-				warning("edward-1205",
-					"truncated page of index %lu is uptodate",
-					pvec.pages[i]->index);
-				return 0;
-			}
-		}
-		start += count;
-		rest -= count;
-		pagevec_release(&pvec);
-	}
-	return 1;
-}
-
-static int body_truncate_ok(struct inode *inode, cloff_t aidx)
-{
-	int result;
-	cloff_t raidx;
-
-	result = find_fake_appended(inode, &raidx);
-	return !result && (aidx == raidx);
-}
-#endif
-
 static int
 update_cryptcompress_size(struct inode *inode, reiser4_key * key, int update_sd)
 {
@@ -3212,11 +3251,14 @@ update_cryptcompress_size(struct inode *
 		? 0 : reiser4_update_file_size(inode, key, update_sd));
 }
 
-/* prune cryptcompress file in two steps (exclusive access should be acquired!)
-   1) cut all disk clusters but the last one partially truncated,
-   2) set zeroes and capture last partially truncated page cluster if the last
-      one exists, otherwise truncate via prune fake cluster (just decrease i_size)
-*/
+/* Prune cryptcompress file in two steps:
+ * 1) cut all nominated logical clusters except the leftmost one which
+ *    is to be partially truncated. Note, that there can be "holes"
+ *    represented by fake logical clusters.
+ * 2) set zeroes and capture leftmost partially truncated logical
+ *    cluster, if it is not fake; otherwise prune fake logical cluster
+ *    (just decrease i_size).
+ */
 static int prune_cryptcompress(struct inode *inode, loff_t new_size,
 			       int update_sd, cloff_t aidx)
 {
@@ -3248,42 +3290,55 @@ static int prune_cryptcompress(struct in
 	cluster_init_read(&clust, &win);
 	clust.hint = hint;
 
-	/* rightmost completely truncated cluster */
-	ridx = count_to_nrclust(new_size, inode);
+	/* calculate index of the rightmost logical cluster
+	   that will be completely truncated */
+	ridx = size_in_lc(new_size, inode);
 
+	/* truncate all disk clusters starting from @ridx */
 	assert("edward-1174", ridx <= aidx);
 	old_size = inode->i_size;
 	if (ridx != aidx) {
+		struct cryptcompress_info * info;
+		info = cryptcompress_inode_data(inode);
 		result = cut_file_items(inode,
 					clust_to_off(ridx, inode),
 					update_sd,
 					clust_to_off(aidx, inode),
 					update_cryptcompress_size);
+		info->trunc_index = ULONG_MAX;
 		if (result)
 			goto out;
 	}
+	/*
+	 * there can be pages of fake logical clusters, truncate them
+	 */
+	truncate_inode_pages(inode->i_mapping, clust_to_off(ridx, inode));
+	assert("edward-1524",
+	       pages_truncate_ok(inode, clust_to_pg(ridx, inode)));
+	/*
+	 * now perform partial truncate of last logical cluster
+	 */
 	if (!off_to_cloff(new_size, inode)) {
-		/* no partially truncated clusters */
+		/* no partial truncate is needed */
 		assert("edward-1145", inode->i_size == new_size);
-		goto finish;
+		goto truncate_fake;
 	}
 	assert("edward-1146", new_size < inode->i_size);
 
 	to_prune = inode->i_size - new_size;
 
-	/* partial truncate of leftmost cluster,
-	   first check if it is fake */
-	result = find_real_disk_cluster(inode, &aidx, ridx);
+	/* check if the last logical cluster is fake */
+	result = lookup_disk_cluster(inode, &aidx, ridx);
 	if (result)
 		goto out;
 	if (!aidx)
 		/* yup, this is fake one */
-		goto finish;
+		goto truncate_fake;
 
 	assert("edward-1148", aidx == ridx);
 
-	/* do partial truncate of the leftmost page cluster,
-	   then try to capture this one */
+	/* do partial truncate of the last page cluster,
+	   and try to capture this one */
 	result = alloc_cluster_pgset(&clust, cluster_nrpages(inode));
 	if (result)
 		goto out;
@@ -3294,7 +3349,7 @@ static int prune_cryptcompress(struct in
 
 	assert("edward-1149", clust.index == ridx - 1);
 
-	result = prepare_cluster(inode, 0, 0, &clust, PCL_TRUNCATE);
+	result = prepare_logical_cluster(inode, 0, 0, &clust, LC_TRUNC);
 	if (result)
 		goto out;
 	assert("edward-1151",
@@ -3303,18 +3358,19 @@ static int prune_cryptcompress(struct in
 
 	assert("edward-1191", inode->i_size == new_size);
 	assert("edward-1206", body_truncate_ok(inode, ridx));
-      finish:
+ truncate_fake:
 	/* drop all the pages that don't have jnodes (i.e. pages
 	   which can not be truncated by cut_file_items() because
 	   of holes represented by fake disk clusters) including
 	   the pages of partially truncated cluster which was
-	   released by prepare_cluster() */
+	   released by prepare_logical_cluster() */
+	INODE_SET_SIZE(inode, new_size);
 	truncate_inode_pages(inode->i_mapping, new_size);
-	INODE_SET_FIELD(inode, i_size, new_size);
-      out:
+ out:
 	assert("edward-1334", !result || result == -ENOSPC);
-	assert("edward-1209",
-	       pages_truncate_ok(inode, old_size, count_to_nrpages(new_size)));
+	assert("edward-1497",
+	       pages_truncate_ok(inode, size_in_pages(new_size)));
+
 	done_lh(lh);
 	kfree(hint);
 	put_cluster_handle(&clust);
@@ -3322,11 +3378,10 @@ static int prune_cryptcompress(struct in
 }
 
 /* Prepare cryptcompress file for truncate:
-   prune or append rightmost fake logical clusters (if any)
-*/
-static int
-start_truncate_fake(struct inode *inode, cloff_t aidx, loff_t new_size,
-		    int update_sd)
+ * prune or append rightmost fake logical clusters (if any)
+ */
+static int start_truncate_fake(struct inode *inode, cloff_t aidx,
+			       loff_t new_size, int update_sd)
 {
 	int result = 0;
 	int bytes;
@@ -3337,18 +3392,17 @@ start_truncate_fake(struct inode *inode,
 			/* no fake bytes */
 			return 0;
 		bytes = new_size - inode->i_size;
-		INODE_SET_FIELD(inode, i_size, inode->i_size + bytes);
+		INODE_SET_SIZE(inode, inode->i_size + bytes);
 	} else {
 		/* prune */
 		if (inode->i_size <= clust_to_off(aidx, inode))
 			/* no fake bytes */
 			return 0;
-		bytes =
-		    inode->i_size - max_count(new_size,
-					      clust_to_off(aidx, inode));
+		bytes = inode->i_size -
+			max(new_size, clust_to_off(aidx, inode));
 		if (!bytes)
 			return 0;
-		INODE_SET_FIELD(inode, i_size, inode->i_size - bytes);
+		INODE_SET_SIZE(inode, inode->i_size - bytes);
 		/* In the case of fake prune we need to drop page cluster.
 		   There are only 2 cases for partially truncated page:
 		   1. If is is dirty, therefore it is anonymous
@@ -3366,7 +3420,7 @@ start_truncate_fake(struct inode *inode,
 }
 
 /* This is called in setattr_cryptcompress when it is used to truncate,
-   and in delete_cryptcompress */
+ * and in delete_cryptcompress */
 static int cryptcompress_truncate(struct inode *inode,	/* old size */
 				  loff_t new_size,	/* new size */
 				  int update_sd)
@@ -3394,26 +3448,11 @@ static int cryptcompress_truncate(struct
 	return result;
 }
 
-static void clear_moved_tag_cluster(struct address_space * mapping,
-				    struct cluster_handle * clust)
-{
-	int i;
-	void * ret;
-	read_lock_irq(&mapping->tree_lock);
-	for (i = 0; i < clust->nr_pages; i++) {
-		assert("edward-1438", clust->pages[i] != NULL);
-		ret = radix_tree_tag_clear(&mapping->page_tree,
-					   clust->pages[i]->index,
-					   PAGECACHE_TAG_REISER4_MOVED);
-		assert("edward-1439", ret == clust->pages[i]);
-	}
-	read_unlock_irq(&mapping->tree_lock);
-}
-
 /* Capture an anonymous pager cluster. (Page cluser is
-   anonymous if it contains at least one anonymous page */
-static int capture_page_cluster(struct cluster_handle * clust,
-				struct inode * inode)
+ * anonymous if it contains at least one anonymous page
+ */
+static int capture_anon_page_cluster(struct cluster_handle * clust,
+				     struct inode * inode)
 {
 	int result;
 
@@ -3421,45 +3460,71 @@ static int capture_page_cluster(struct c
 	assert("edward-1074", inode != NULL);
 	assert("edward-1075", clust->dstat == INVAL_DISK_CLUSTER);
 
-	result = prepare_cluster(inode, 0, 0, clust, PCL_APPEND);
+	result = prepare_logical_cluster(inode, 0, 0, clust, LC_APPOV);
 	if (result)
 		return result;
-	set_cluster_pages_dirty(clust);
-	clear_moved_tag_cluster(inode->i_mapping, clust);
-
-	result = try_capture_cluster(clust, inode);
+	set_cluster_pages_dirty(clust, inode);
+	result = checkin_logical_cluster(clust, inode);
 	put_hint_cluster(clust, inode, ZNODE_WRITE_LOCK);
-	if (unlikely(result)) {
-		/* set cleared tag back, so it will be
-		   possible to capture it again later */
-		read_lock_irq(&inode->i_mapping->tree_lock);
-		radix_tree_tag_set(&inode->i_mapping->page_tree,
-				   clust_to_pg(clust->index, inode),
-				   PAGECACHE_TAG_REISER4_MOVED);
-		read_unlock_irq(&inode->i_mapping->tree_lock);
-
-		reiser4_release_cluster_pages_and_jnode(clust);
-	}
+	if (unlikely(result))
+		put_page_cluster(clust, inode, WRITE_OP);
 	return result;
 }
 
-#define MAX_CLUSTERS_TO_CAPTURE(inode)    (1024 >> cluster_nrpages_shift(inode))
+/* Starting from @index find tagged pages of the same page cluster.
+ * Clear the tag for each of them. Return number of found pages.
+ */
+static int find_anon_page_cluster(struct address_space * mapping,
+				  pgoff_t * index, struct page ** pages)
+{
+	int i = 0;
+	int found;
+	write_lock_irq(&mapping->tree_lock);
+	do {
+		/* looking for one page */
+		found = radix_tree_gang_lookup_tag(&mapping->page_tree,
+						   (void **)&pages[i],
+						   *index, 1,
+						   PAGECACHE_TAG_REISER4_MOVED);
+		if (!found)
+			break;
+		if (!same_page_cluster(pages[0], pages[i]))
+			break;
+
+		/* found */
+		page_cache_get(pages[i]);
+		*index = pages[i]->index + 1;
+
+		radix_tree_tag_clear(&mapping->page_tree,
+				     pages[i]->index,
+				     PAGECACHE_TAG_REISER4_MOVED);
+		if (last_page_in_cluster(pages[i++]))
+			break;
+	} while (1);
+	write_unlock_irq(&mapping->tree_lock);
+	return i;
+}
+
+#define MAX_PAGES_TO_CAPTURE  (1024)
 
 /* Capture anonymous page clusters */
-static int capture_anonymous_clusters(struct address_space * mapping,
-				      pgoff_t * index, int to_capture)
+static int capture_anon_pages(struct address_space * mapping, pgoff_t * index,
+			      int to_capture)
 {
+	int count = 0;
+	int found = 0;
 	int result = 0;
-	int found;
-	struct page *page = NULL;
 	hint_t *hint;
 	lock_handle *lh;
+	struct inode * inode;
 	struct cluster_handle clust;
+	struct page * pages[MAX_CLUSTER_NRPAGES];
 
 	assert("edward-1127", mapping != NULL);
 	assert("edward-1128", mapping->host != NULL);
-	assert("edward-1440",  mapping->host->i_mapping == mapping);
+	assert("edward-1440", mapping->host->i_mapping == mapping);
 
+	inode = mapping->host;
 	hint = kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
 	if (hint == NULL)
 		return RETERR(-ENOMEM);
@@ -3469,40 +3534,35 @@ static int capture_anonymous_clusters(st
 	cluster_init_read(&clust, NULL);
 	clust.hint = hint;
 
-	result = alloc_cluster_pgset(&clust, cluster_nrpages(mapping->host));
+	result = alloc_cluster_pgset(&clust, cluster_nrpages(inode));
 	if (result)
 		goto out;
 
 	while (to_capture > 0) {
-		found =
-		    find_get_pages_tag(mapping, index,
-				       PAGECACHE_TAG_REISER4_MOVED, 1, &page);
+		found = find_anon_page_cluster(mapping, index, pages);
 		if (!found) {
 			*index = (pgoff_t) - 1;
 			break;
 		}
-		assert("edward-1109", page != NULL);
+		move_cluster_forward(&clust, inode, pages[0]->index);
+		result = capture_anon_page_cluster(&clust, inode);
 
-		move_cluster_forward(&clust, mapping->host, page->index);
-		result = capture_page_cluster(&clust, mapping->host);
-		page_cache_release(page);
+		put_found_pages(pages, found); /* find_anon_page_cluster */
 		if (result)
 			break;
 		to_capture -= clust.nr_pages;
+		count += clust.nr_pages;
 	}
 	if (result) {
 		warning("edward-1077",
-			"Cannot capture anon pages: result=%i (captured=%d)\n",
-			result,
-			((__u32) MAX_CLUSTERS_TO_CAPTURE(mapping->host)) -
-			to_capture);
+			"Capture failed (inode %llu, result=%i, captured=%d)\n",
+			(unsigned long long)get_inode_oid(inode), result, count);
 	} else {
-		/* something had to be found */
-		assert("edward-1078",
-		       to_capture <= MAX_CLUSTERS_TO_CAPTURE(mapping->host));
+		assert("edward-1078", ergo(found > 0, count > 0));
 		if (to_capture <= 0)
 			/* there may be left more pages */
-			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+			__mark_inode_dirty(inode, I_DIRTY_PAGES);
+		result = count;
 	}
       out:
 	done_lh(lh);
@@ -3511,41 +3571,40 @@ static int capture_anonymous_clusters(st
 	return result;
 }
 
-/* Check mapping for existence of not captured dirty pages.
-   This returns !0 if either page tree contains pages tagged
-   PAGECACHE_TAG_REISER4_MOVED */
+/* Returns true if inode's mapping has dirty pages
+   which do not belong to any atom */
 static int cryptcompress_inode_has_anon_pages(struct inode *inode)
 {
-	return mapping_tagged(inode->i_mapping, PAGECACHE_TAG_REISER4_MOVED);
+	int result;
+	read_lock_irq(&inode->i_mapping->tree_lock);
+	result = radix_tree_tagged(&inode->i_mapping->page_tree,
+				   PAGECACHE_TAG_REISER4_MOVED);
+	read_unlock_irq(&inode->i_mapping->tree_lock);
+	return result;
 }
 
-/* this is implementation of vfs's writepages method of struct
+/* This is implementation of vfs's writepages method of struct
    address_space_operations */
-int
-writepages_cryptcompress(struct address_space *mapping,
-			 struct writeback_control *wbc)
+int writepages_cryptcompress(struct address_space *mapping,
+			     struct writeback_control *wbc)
 {
-	int result;
-	int to_capture;
+	int result = 0;
+	long to_capture;
 	pgoff_t nrpages;
 	pgoff_t index = 0;
-	struct cryptcompress_info *info;
 	struct inode *inode;
+	struct cryptcompress_info *info;
 
 	inode = mapping->host;
-	if (!cryptcompress_inode_has_anon_pages(inode)) {
-		result = 0;
+	if (!cryptcompress_inode_has_anon_pages(inode))
 		goto end;
-	}
-
 	info = cryptcompress_inode_data(inode);
-	nrpages = count_to_nrpages(i_size_read(inode));
+	nrpages = size_in_pages(i_size_read(inode));
 
 	if (wbc->sync_mode != WB_SYNC_ALL)
-		to_capture =
-		    min_count(wbc->nr_to_write, MAX_CLUSTERS_TO_CAPTURE(inode));
+		to_capture = min(wbc->nr_to_write, (long)MAX_PAGES_TO_CAPTURE);
 	else
-		to_capture = MAX_CLUSTERS_TO_CAPTURE(inode);
+		to_capture = MAX_PAGES_TO_CAPTURE;
 	do {
 		reiser4_context *ctx;
 
@@ -3554,30 +3613,47 @@ writepages_cryptcompress(struct address_
 			result = PTR_ERR(ctx);
 			break;
 		}
+		/* avoid recursive calls to ->sync_inodes */
 		ctx->nobalance = 1;
 
 		assert("edward-1079",
 		       lock_stack_isclean(get_current_lock_stack()));
 
-		LOCK_CNT_INC(inode_sem_r);
+		reiser4_txn_restart_current();
 
-		result =
-		    capture_anonymous_clusters(inode->i_mapping, &index,
-					       to_capture);
+		if (get_current_context()->entd) {
+			if (mutex_trylock(&info->checkin_mutex) == 0) {
+				/* the mutex might be occupied by
+				   entd caller */
+				result = RETERR(-EBUSY);
+				reiser4_exit_context(ctx);
+				break;
+			}
+		} else
+			mutex_lock(&info->checkin_mutex);
+
+		result = capture_anon_pages(inode->i_mapping, &index,
+					    to_capture);
+		mutex_unlock(&info->checkin_mutex);
 
-		if (result != 0 || wbc->sync_mode != WB_SYNC_ALL) {
+		if (result < 0) {
+			reiser4_exit_context(ctx);
+			break;
+		}
+		wbc->nr_to_write -= result;
+		if (wbc->sync_mode != WB_SYNC_ALL) {
 			reiser4_exit_context(ctx);
 			break;
 		}
 		result = txnmgr_force_commit_all(inode->i_sb, 0);
 		reiser4_exit_context(ctx);
-	} while (result == 0 && index < nrpages);
+	} while (result >= 0 && index < nrpages);
 
-      end:
+ end:
 	if (is_in_reiser4_context()) {
 		if (get_current_context()->nr_captured >= CAPTURE_APAGE_BURST) {
-			/* there are already pages to flush, flush them out, do
-			   not delay until end of reiser4_sync_inodes */
+			/* there are already pages to flush, flush them out,
+			   do not delay until end of reiser4_sync_inodes */
 			reiser4_writeout(inode->i_sb, wbc);
 			get_current_context()->nr_captured = 0;
 		}
@@ -3616,16 +3692,22 @@ int mmap_cryptcompress(struct file *file
 /* plugin->u.file.get_block */
 
 /* this is implementation of delete method of file plugin for
-   cryptcompress objects */
+ * cryptcompress objects
+ */
 int delete_object_cryptcompress(struct inode *inode)
 {
 	int result;
+	struct cryptcompress_info * info;
 
 	assert("edward-429", inode->i_nlink == 0);
 
 	reiser4_txn_restart_current();
+	info = cryptcompress_inode_data(inode);
 
+	mutex_lock(&info->checkin_mutex);
 	result = cryptcompress_truncate(inode, 0, 0);
+	mutex_unlock(&info->checkin_mutex);
+
 	if (result) {
 		warning("edward-430",
 			"cannot truncate cryptcompress file  %lli: %i",
@@ -3633,6 +3715,7 @@ int delete_object_cryptcompress(struct i
 			result);
 	}
 	truncate_inode_pages(inode->i_mapping, 0);
+	assert("edward-1487", pages_truncate_ok(inode, 0));
 	/* and remove stat data */
 	return reiser4_delete_object_common(inode);
 }
@@ -3643,10 +3726,13 @@ int setattr_cryptcompress(struct dentry 
 {
 	int result;
 	struct inode *inode;
+	struct cryptcompress_info * info;
 
 	inode = dentry->d_inode;
+	info = cryptcompress_inode_data(inode);
+
 	if (attr->ia_valid & ATTR_SIZE) {
-		if (inode->i_size != attr->ia_size) {
+		if (i_size_read(inode) != attr->ia_size) {
 			reiser4_context *ctx;
 			loff_t old_size;
 
@@ -3654,20 +3740,21 @@ int setattr_cryptcompress(struct dentry 
 			if (IS_ERR(ctx))
 				return PTR_ERR(ctx);
 
-			inode_check_scale(inode, inode->i_size, attr->ia_size);
+			old_size = i_size_read(inode);
+			inode_check_scale(inode, old_size, attr->ia_size);
 
-			old_size = inode->i_size;
-
-			result =
-			    cryptcompress_truncate(inode, attr->ia_size,
-						   1 /* update stat data */ );
+			mutex_lock(&info->checkin_mutex);
+			result = cryptcompress_truncate(inode,
+							attr->ia_size,
+							1/* update sd */);
+			mutex_unlock(&info->checkin_mutex);
 			if (result) {
-				warning("edward-1192",
-					"truncate_cryptcompress failed: oid %lli, "
-					"old size %lld, new size %lld, retval %d",
-					(unsigned long long)
-					get_inode_oid(inode), old_size,
-					attr->ia_size, result);
+			     warning("edward-1192",
+				     "truncate_cryptcompress failed: oid %lli, "
+				     "old size %lld, new size %lld, retval %d",
+				     (unsigned long long)
+				     get_inode_oid(inode), old_size,
+				     attr->ia_size, result);
 			}
 			context_set_commit_async(ctx);
 			reiser4_exit_context(ctx);
diff -puN fs/reiser4/plugin/file/cryptcompress.h~reiser4-cryptcompress-misc-fixups fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~reiser4-cryptcompress-misc-fixups
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -29,16 +29,6 @@
 	 (1 << PSET_COMPRESSION) |			\
 	 (1 << PSET_COMPRESSION_MODE))
 
-static inline loff_t min_count(loff_t a, loff_t b)
-{
-	return (a < b ? a : b);
-}
-
-static inline loff_t max_count(loff_t a, loff_t b)
-{
-	return (a > b ? a : b);
-}
-
 #if REISER4_DEBUG
 static inline int cluster_shift_ok(int shift)
 {
@@ -46,6 +36,19 @@ static inline int cluster_shift_ok(int s
 }
 #endif
 
+#if REISER4_DEBUG
+#define INODE_PGCOUNT(inode)						\
+	(atomic_read(&cryptcompress_inode_data(inode)->pgcount))
+#define INODE_PGCOUNT_INC(inode)					\
+	(atomic_inc(&cryptcompress_inode_data(inode)->pgcount))
+#define INODE_PGCOUNT_DEC(inode)					\
+	(atomic_dec(&cryptcompress_inode_data(inode)->pgcount))
+#else
+#define INODE_PGCOUNT(inode) (0)
+#define INODE_PGCOUNT_INC(inode)
+#define INODE_PGCOUNT_DEC(inode)
+#endif /* REISER4_DEBUG */
+
 struct tfm_stream {
 	__u8 *data;
 	size_t size;
@@ -128,23 +131,21 @@ typedef enum {
 } cryptcompress_write_mode_t;
 
 typedef enum {
-	PCL_UNKNOWN = 0,	/* invalid option */
-	PCL_APPEND = 1,		/* append and/or overwrite */
-	PCL_TRUNCATE = 2	/* truncate */
-} page_cluster_op;
-
-/* Reiser4 file write/read transforms page cluster into disk cluster (and back)
-   using crypto/compression transforms implemented by reiser4 transform plugins.
-   Before each transform we allocate a pair of streams (tfm_unit) and assemble
-   page cluster into the input one. After transform we split output stream into
-   a set of items (disk cluster).
-*/
+	LC_INVAL  = 0,   /* invalid value */
+	LC_APPOV = 1,    /* append and/or overwrite */
+	LC_TRUNC = 2	 /* truncate */
+} logical_cluster_op;
+
+/* Transform cluster.
+ * Intermediate state between page cluster and disk cluster
+ * Is used for data transform (compression/encryption)
+ */
 struct tfm_cluster {
-	coa_set coa;
-	tfm_unit tun;
+	coa_set coa;      /* compression algorithms info */
+	tfm_unit tun;     /* plain and transformed streams */
 	tfm_action act;
 	int uptodate;
-	int lsize;        /* size of the logical cluster */
+	int lsize;        /* number of bytes in logical cluster */
 	int len;          /* length of the transform stream */
 };
 
@@ -328,54 +329,74 @@ static inline void alternate_streams(str
 	set_tfm_stream(tc, OUTPUT_STREAM, tmp);
 }
 
-/* a kind of data that we can write to the window */
+/* Set of states to indicate a kind of data
+ * that will be written to the window */
 typedef enum {
-	DATA_WINDOW,		/* the data we copy form user space */
-	HOLE_WINDOW		/* zeroes if we write hole */
+	DATA_WINDOW,		/* user's data */
+	HOLE_WINDOW		/* zeroes (such kind of data can be written
+				 * if we start to write from offset > i_size) */
 } window_stat;
 
-/* Sliding window of cluster size which should be set to the approprite position
-   (defined by cluster index) in a file before page cluster modification by
-   file_write. Then we translate file size, offset to write from, number of
-   bytes to write, etc.. to the following configuration needed to estimate
-   number of pages to read before write, etc...
-*/
+/* Window (of logical cluster size) discretely sliding along a file.
+ * Is used to locate hole region in a logical cluster to be properly
+ * represented on disk.
+ * We split a write to cryptcompress file into writes to its logical
+ * clusters. Before writing to a logical cluster we set a window, i.e.
+ * calculate values of the following fields:
+ */
 struct reiser4_slide {
-	unsigned off;		/* offset we start to write/truncate from */
-	unsigned count;		/* number of bytes (zeroes) to write/truncate */
+	unsigned off;		/* offset to write from */
+	unsigned count;		/* number of bytes to write */
 	unsigned delta;		/* number of bytes to append to the hole */
-	window_stat stat;	/* a kind of data to write to the window */
+	window_stat stat;	/* what kind of data will be written starting
+				   from @off */
 };
 
-/* The following is a set of possible disk cluster states */
+/* Possible states of a disk cluster */
 typedef enum {
 	INVAL_DISK_CLUSTER,	/* unknown state */
 	PREP_DISK_CLUSTER,	/* disk cluster got converted by flush
-				   at least 1 time */
+				 * at least 1 time */
 	UNPR_DISK_CLUSTER,	/* disk cluster just created and should be
-				   converted by flush */
-	FAKE_DISK_CLUSTER	/* disk cluster doesn't exist neither in memory
-				   nor on disk */
+				 * converted by flush */
+	FAKE_DISK_CLUSTER,	/* disk cluster doesn't exist neither in memory
+				 * nor on disk */
+	TRNC_DISK_CLUSTER       /* disk cluster is partially truncated */
 } disk_cluster_stat;
 
-/*
-   While implementing all transforms (from page to disk cluster, and back)
-   reiser4 cluster manager fills the following structure incapsulating pointers
-   to all the clusters for the same index including the sliding window above
-*/
+/* The following structure represents various stages of the same logical
+ * cluster of index @index:
+ * . fixed slide
+ * . page cluster         (stage in primary cache)
+ * . transform cluster    (transition stage)
+ * . disk cluster         (stage in secondary cache)
+ * This structure is used in transition and synchronizing operations, e.g.
+ * transform cluster is a transition state when synchronizing page cluster
+ * and disk cluster.
+ * FIXME: Encapsulate page cluster, disk cluster.
+ */
 struct cluster_handle {
-	struct tfm_cluster tc;	/* transform info */
-	int nr_pages;		/* number of pages */
-	struct page **pages;	/* page cluster */
-	page_cluster_op op;	/* page cluster operation */
-	struct file *file;
-	hint_t *hint;		/* disk cluster item for traversal */
-	disk_cluster_stat dstat;	/* state of the current disk cluster */
-	cloff_t index;		/* offset in the units of cluster size */
-	int index_valid;        /* to validate the index above, if needed */
-	struct reiser4_slide *win;	/* sliding window of cluster size */
-	int reserved;		/* this indicates that space for disk
-				   cluster modification is reserved */
+	cloff_t index;		 /* offset in a file (unit is a cluster size) */
+	int index_valid;         /* for validating the index above, if needed */
+	struct file *file;       /* host file */
+
+	/* logical cluster */
+	struct reiser4_slide *win; /* sliding window to locate holes */
+	logical_cluster_op op;	 /* logical cluster operation (truncate or
+				    append/overwrite) */
+	/* transform cluster */
+	struct tfm_cluster tc;	 /* contains all needed info to synchronize
+				    page cluster and disk cluster) */
+        /* page cluster */
+	int nr_pages;		 /* number of pages of current checkin action */
+ 	int old_nrpages;         /* number of pages of last checkin action */
+	struct page **pages;	 /* attached pages */
+	jnode * node;            /* jnode for capture */
+
+	/* disk cluster */
+	hint_t *hint;		 /* current position in the tree */
+	disk_cluster_stat dstat; /* state of the current disk cluster */
+	int reserved;		 /* is space for disk cluster reserved */
 #if REISER4_DEBUG
 	reiser4_context *ctx;
 	int reserved_prepped;
@@ -409,12 +430,10 @@ static inline int alloc_cluster_pgset(st
 	assert("edward-1362", clust->pages == NULL);
 	assert("edward-950", nrpages != 0 && nrpages <= MAX_CLUSTER_NRPAGES);
 
-	clust->pages =
-		kmalloc(sizeof(*clust->pages) * nrpages,
-			reiser4_ctx_gfp_mask_get());
+	clust->pages = kzalloc(sizeof(*clust->pages) * nrpages,
+			       reiser4_ctx_gfp_mask_get());
 	if (!clust->pages)
 		return RETERR(-ENOMEM);
-	reset_cluster_pgset(clust, nrpages);
 	return 0;
 }
 
@@ -448,15 +467,27 @@ static inline void dec_keyload_count(str
  	data->keyload_count--;
 }
 
+static inline int capture_cluster_jnode(jnode * node)
+{
+	return reiser4_try_capture(node, ZNODE_WRITE_LOCK, 0);
+}
+
 /* cryptcompress specific part of reiser4_inode */
 struct cryptcompress_info {
+	struct mutex checkin_mutex;  /* This is to serialize
+				      * checkin_logical_cluster operations */
+	cloff_t trunc_index;         /* Index of the leftmost truncated disk
+				      * cluster (to resolve races with read) */
 	struct reiser4_crypto_info *crypt;
-	/* the following 2 fields are controlled by compression mode plugin */
-	int compress_toggle; /* current status of compressibility */
-	int lattice_factor;  /* factor of dynamic lattice. FIXME: Have a
-				compression_toggle to keep the factor */
+	/*
+	 * the following 2 fields are controlled by compression mode plugin
+	 */
+	int compress_toggle;          /* Current status of compressibility */
+	int lattice_factor;           /* Factor of dynamic lattice. FIXME: Have
+				       * a compression_toggle to keep the factor
+				       */
 #if REISER4_DEBUG
-	int pgcount;              /* number of captured pages */
+	atomic_t pgcount;             /* number of grabbed pages */
 #endif
 };
 
@@ -501,7 +532,7 @@ int goto_right_neighbor(coord_t *, lock_
 int cryptcompress_inode_ok(struct inode *inode);
 int coord_is_unprepped_ctail(const coord_t * coord);
 extern int ctail_read_disk_cluster (struct cluster_handle *, struct inode *,
-				    znode_lock_mode mode);
+				    struct page *, znode_lock_mode mode);
 extern int do_readpage_ctail(struct inode *, struct cluster_handle *,
 			     struct page * page, znode_lock_mode mode);
 extern int ctail_insert_unprepped_cluster(struct cluster_handle * clust,
@@ -510,7 +541,8 @@ extern int readpages_cryptcompress(struc
 				   struct list_head*, unsigned);
 int bind_cryptcompress(struct inode *child, struct inode *parent);
 void destroy_inode_cryptcompress(struct inode * inode);
-int grab_cluster_pages(struct inode *inode, struct cluster_handle * clust);
+int grab_page_cluster(struct inode *inode, struct cluster_handle * clust,
+		      rw_op rw);
 int write_conversion_hook(struct file *file, struct inode * inode, loff_t pos,
  			  struct cluster_handle * clust, int * progress);
 struct reiser4_crypto_info * inode_crypto_info(struct inode * inode);
@@ -544,7 +576,12 @@ static inline void info_set_digest(struc
 	info->digest = tfm;
 }
 
-#endif				/* __FS_REISER4_CRYPTCOMPRESS_H__ */
+static inline void put_cluster_page(struct page * page)
+{
+	page_cache_release(page);
+}
+
+#endif /* __FS_REISER4_CRYPTCOMPRESS_H__ */
 
 /* Make Linus happy.
    Local variables:
diff -puN fs/reiser4/plugin/file/file.c~reiser4-cryptcompress-misc-fixups fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-cryptcompress-misc-fixups
+++ a/fs/reiser4/plugin/file/file.c
@@ -16,6 +16,7 @@
 #include "../../page_cache.h"
 #include "../../ioctl.h"
 #include "../object.h"
+#include "../cluster.h"
 #include "../../safe_link.h"
 
 #include <linux/writeback.h>
@@ -359,7 +360,7 @@ int reiser4_update_file_size(struct inod
 {
 	int result = 0;
 
-	INODE_SET_FIELD(inode, i_size, get_key_offset(key));
+	INODE_SET_SIZE(inode, get_key_offset(key));
 	if (update_sd) {
 		inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 		result = reiser4_update_sd(inode);
@@ -1256,8 +1257,8 @@ int writepages_unix_file(struct address_
 	}
 	jindex = pindex = wbc->range_start >> PAGE_CACHE_SHIFT;
 	result = 0;
-	nr_pages =
-	    (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	nr_pages = size_in_pages(i_size_read(inode));
+
 	uf_info = unix_file_inode_data(inode);
 
 	do {
diff -puN fs/reiser4/plugin/file/file_conversion.c~reiser4-cryptcompress-misc-fixups fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~reiser4-cryptcompress-misc-fixups
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -201,21 +201,34 @@ static int disable_conversion(struct ino
 }
 
 static int check_position(struct inode * inode,
-			  loff_t pos /* initial position in the file */,
+			  loff_t pos /* position in the file to write from */,
 			  struct cluster_handle * clust,
 			  int * check_compress)
 {
 	assert("edward-1505", conversion_enabled(inode));
+	/*
+	 * if file size is more then cluster size, then compressible
+	 * status must be figured out (i.e. compression was disabled,
+	 * or file plugin was converted to unix_file)
+	 */
 	assert("edward-1506", inode->i_size <= inode_cluster_size(inode));
-	/* if file size is more then cluster size, then compressible
-	   status must be figured out (i.e. compression was disabled,
-	   or file plugin was converted to unix_file) */
 
 	if (pos > inode->i_size)
 		/* first logical cluster will contain a (partial) hole */
 		return disable_conversion(inode);
-	if (inode->i_size == inode_cluster_size(inode))
-		*check_compress = 1;
+	if (pos < inode_cluster_size(inode))
+		/* writing to the first logical cluster */
+		return 0;
+	/*
+	 * here we have:
+	 * cluster_size <= pos <= i_size <= cluster_size,
+	 * and, hence,  pos == i_size == cluster_size
+	 */
+	assert("edward-1498",
+	       pos == inode->i_size &&
+	       pos == inode_cluster_size(inode));
+
+	*check_compress = 1;
 	return 0;
 }
 
@@ -230,10 +243,10 @@ static void start_check_compressibility(
 	hint_init_zero(hint);
 	clust->hint = hint;
 	clust->index --;
-	clust->nr_pages = count_to_nrpages(fsize_to_count(clust, inode));
+	clust->nr_pages = size_in_pages(lbytes(clust->index, inode));
 
 	/* first logical cluster (of index #0) must be complete */
-	assert("edward-1510", fsize_to_count(clust, inode) ==
+	assert("edward-1510", lbytes(clust->index, inode) ==
 	       inode_cluster_size(inode));
 }
 
@@ -280,7 +293,8 @@ static int read_check_compressibility(st
 
 	start_check_compressibility(inode, clust, &tmp_hint);
 
-	result = grab_cluster_pages(inode, clust);
+	reset_cluster_pgset(clust, cluster_nrpages(inode));
+	result = grab_page_cluster(inode, clust, READ_OP);
 	if (result)
 		return result;
 	/* Read page cluster here */
@@ -300,7 +314,7 @@ static int read_check_compressibility(st
 	if (hint_is_valid(&tmp_hint) && !hint_is_unprepped_dclust(&tmp_hint)) {
 		/* lenght of compressed data is known, no need to compress */
 		assert("edward-1511",
-		       znode_is_write_locked(tmp_hint.ext_coord.coord.node));
+		       znode_is_any_locked(tmp_hint.lh.node));
 		assert("edward-1512",
 		       WITH_DATA(tmp_hint.ext_coord.coord.node,
 				 prepped_dclust_ok(&tmp_hint)));
@@ -328,7 +342,7 @@ static int read_check_compressibility(st
 		result = grab_coa(tc, cplug);
 		if (result)
 			goto error;
-		tc->len = tc->lsize = fsize_to_count(clust, inode);
+		tc->len = tc->lsize = lbytes(clust->index, inode);
 		assert("edward-1513", tc->len == inode_cluster_size(inode));
 		dst_len = tfm_stream_size(tc, OUTPUT_STREAM);
 		cplug->compress(get_coa(tc, cplug->h.id, tc->act),
@@ -342,7 +356,7 @@ static int read_check_compressibility(st
 					     inode_cluster_size(inode));
 	return 0;
  error:
-	reiser4_release_cluster_pages(clust);
+	put_page_cluster(clust, inode, READ_OP);
 	return result;
 }
 
@@ -468,7 +482,7 @@ static int cryptcompress2unixfile(struct
  out:
 	all_grabbed2free();
 	if (result)
-		warning("edward-1453", "Failed to convert file %llu: %i",
+		warning("edward-1453", "Failed to convert file %llu: ret=%i",
 			(unsigned long long)get_inode_oid(inode), result);
 	return result;
 }
@@ -499,7 +513,8 @@ int write_conversion_hook(struct file * 
 	else
 		result = disable_conversion(inode);
 
-	reiser4_release_cluster_pages(clust);
+	reiser4_txn_restart_current();
+	put_page_cluster(clust, inode, READ_OP);
 	return result;
 }
 
diff -puN fs/reiser4/plugin/item/ctail.c~reiser4-cryptcompress-misc-fixups fs/reiser4/plugin/item/ctail.c
--- a/fs/reiser4/plugin/item/ctail.c~reiser4-cryptcompress-misc-fixups
+++ a/fs/reiser4/plugin/item/ctail.c
@@ -143,8 +143,7 @@ can_contain_key_ctail(const coord_t * co
 	return 1;
 }
 
-/* plugin->u.item.b.mergeable
-   c-tails of different clusters are not mergeable */
+/* plugin->u.item.b.mergeable */
 int mergeable_ctail(const coord_t * p1, const coord_t * p2)
 {
 	reiser4_key key1, key2;
@@ -362,9 +361,8 @@ int create_hook_ctail(const coord_t * co
 }
 
 /* plugin->u.item.b.kill_hook */
-int
-kill_hook_ctail(const coord_t * coord, pos_in_node_t from, pos_in_node_t count,
-		carry_kill_data * kdata)
+int kill_hook_ctail(const coord_t * coord, pos_in_node_t from,
+		    pos_in_node_t count, carry_kill_data * kdata)
 {
 	struct inode *inode;
 
@@ -374,15 +372,24 @@ kill_hook_ctail(const coord_t * coord, p
 	inode = kdata->inode;
 	if (inode) {
 		reiser4_key key;
+		struct cryptcompress_info * info;
+		cloff_t index;
+
 		item_key_by_coord(coord, &key);
+		info = cryptcompress_inode_data(inode);
+		index = off_to_clust(get_key_offset(&key), inode);
 
-		if (from == 0 && is_disk_cluster_key(&key, coord)) {
-			/* disk cluster is killed */
-			cloff_t start =
-			    off_to_clust(get_key_offset(&key), inode);
-			truncate_page_cluster_cryptcompress(inode, start,
-							kdata->params.truncate);
-			inode_sub_bytes(inode, inode_cluster_size(inode));
+		if (from == 0) {
+			info->trunc_index = index;
+			if (is_disk_cluster_key(&key, coord)) {
+				/*
+				 * first item of disk cluster is to be killed
+				 */
+				truncate_complete_page_cluster(
+				        inode, index, kdata->params.truncate);
+				inode_sub_bytes(inode,
+						inode_cluster_size(inode));
+			}
 		}
 	}
 	return 0;
@@ -540,107 +547,150 @@ int read_ctail(struct file *file UNUSED_
 	return 0;
 }
 
-/* Reads a disk cluster consists of ctail items,
-   attaches a transform stream with plain text */
+/**
+ * Prepare transform stream with plain text for page
+ * @page taking into account synchronization issues.
+ */
 int ctail_read_disk_cluster(struct cluster_handle * clust, struct inode * inode,
-			    znode_lock_mode mode)
+			    struct page * page, znode_lock_mode mode)
 {
 	int result;
+
 	assert("edward-1450", mode == ZNODE_READ_LOCK || ZNODE_WRITE_LOCK);
 	assert("edward-671", clust->hint != NULL);
 	assert("edward-140", clust->dstat == INVAL_DISK_CLUSTER);
 	assert("edward-672", cryptcompress_inode_ok(inode));
+	assert("edward-1527", PageLocked(page));
+
+	unlock_page(page);
 
 	/* set input stream */
 	result = grab_tfm_stream(inode, &clust->tc, INPUT_STREAM);
-	if (result)
+	if (result) {
+		lock_page(page);
 		return result;
-
+	}
 	result = find_disk_cluster(clust, inode, 1 /* read items */, mode);
-	assert("edward-1340", !result);
+	lock_page(page);
 	if (result)
 		return result;
-	if (mode == ZNODE_READ_LOCK)
-		/* write still need the lock to insert unprepped
-		   items, etc... */
-		put_hint_cluster(clust, inode, ZNODE_READ_LOCK);
-
+	/*
+	 * at this point we have locked position in the tree
+	 */
+	assert("edward-1528", znode_is_any_locked(clust->hint->lh.node));
+
+	if (page->mapping != inode->i_mapping) {
+		/* page was truncated */
+		reiser4_unset_hint(clust->hint);
+		reset_cluster_params(clust);
+		return AOP_TRUNCATED_PAGE;
+	}
+	if (PageUptodate(page)) {
+		/* disk cluster can be obsolete, don't use it! */
+		reiser4_unset_hint(clust->hint);
+		reset_cluster_params(clust);
+		return 0;
+	}
 	if (clust->dstat == FAKE_DISK_CLUSTER ||
-	    clust->dstat == UNPR_DISK_CLUSTER) {
+	    clust->dstat == UNPR_DISK_CLUSTER ||
+	    clust->dstat == TRNC_DISK_CLUSTER) {
+		/*
+		 * this information about disk cluster will be valid
+		 * as long as we keep the position in the tree locked
+		 */
 		tfm_cluster_set_uptodate(&clust->tc);
 		return 0;
 	}
+	/* now prepare output stream.. */
 	result = grab_coa(&clust->tc, inode_compression_plugin(inode));
 	if (result)
 		return result;
+	/* ..and fill this with plain text */
 	result = reiser4_inflate_cluster(clust, inode);
 	if (result)
 		return result;
+	/*
+	 * The stream is ready! It won't be obsolete as
+	 * long as we keep last disk cluster item locked.
+	 */
 	tfm_cluster_set_uptodate(&clust->tc);
 	return 0;
 }
 
-/* read one locked page */
+/*
+ * fill one page with plain text.
+ */
 int do_readpage_ctail(struct inode * inode, struct cluster_handle * clust,
 		      struct page *page, znode_lock_mode mode)
 {
 	int ret;
 	unsigned cloff;
 	char *data;
-	size_t pgcnt;
+	size_t to_page;
 	struct tfm_cluster * tc = &clust->tc;
 
 	assert("edward-212", PageLocked(page));
 
+	if (unlikely(page->mapping != inode->i_mapping))
+		return AOP_TRUNCATED_PAGE;
 	if (PageUptodate(page))
 		goto exit;
-
+	to_page = pbytes(page_index(page), inode);
+	if (to_page == 0) {
+		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		SetPageUptodate(page);
+		goto exit;
+	}
 	if (!tfm_cluster_is_uptodate(&clust->tc)) {
 		clust->index = pg_to_clust(page->index, inode);
-		unlock_page(page);
-		ret = ctail_read_disk_cluster(clust, inode, mode);
-		lock_page(page);
+
+		/* this will unlock/lock the page */
+		ret = ctail_read_disk_cluster(clust, inode, page, mode);
+
+		assert("edward-212", PageLocked(page));
 		if (ret)
 			return ret;
+
+		/* refresh bytes */
+		to_page = pbytes(page_index(page), inode);
+		if (to_page == 0) {
+			zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+			SetPageUptodate(page);
+			goto exit;
+		}
 	}
 	if (PageUptodate(page))
-		/* races with another read/write */
+		/* somebody else fill it already */
 		goto exit;
 
-	/* bytes in the page */
-	pgcnt = cnt_to_pgcnt(i_size_read(inode), page->index);
-
-	if (pgcnt == 0) {
-		assert("edward-1290", 0);
-		return RETERR(-EINVAL);
-	}
 	assert("edward-119", tfm_cluster_is_uptodate(tc));
+	assert("edward-1529", znode_is_any_locked(clust->hint->lh.node));
 
 	switch (clust->dstat) {
 	case UNPR_DISK_CLUSTER:
-		assert("edward-1285", 0);
-#if REISER4_DEBUG
-		warning("edward-1168",
-			"page %lu is not uptodate and disk cluster %lu (inode %llu) is unprepped\n",
-			page->index, clust->index,
-			(unsigned long long)get_inode_oid(inode));
-#endif
+		BUG_ON(1);
+	case TRNC_DISK_CLUSTER:
+		/*
+		 * Race with truncate!
+		 * We resolve it in favour of the last one (the only way,
+                 * as in this case plain text is unrecoverable)
+		 */
 	case FAKE_DISK_CLUSTER:
 		/* fill the page by zeroes */
 		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 		SetPageUptodate(page);
 		break;
 	case PREP_DISK_CLUSTER:
-		/* fill the page by transformed data */
+		/* fill page by transformed stream with plain text */
 		assert("edward-1058", !PageUptodate(page));
 		assert("edward-120", tc->len <= inode_cluster_size(inode));
 
-		/* start page offset in the cluster */
+		/* page index in this logical cluster */
 		cloff = pg_to_off_to_cloff(page->index, inode);
 
 		data = kmap(page);
-		memcpy(data, tfm_stream_data(tc, OUTPUT_STREAM) + cloff, pgcnt);
-		memset(data + pgcnt, 0, (size_t) PAGE_CACHE_SIZE - pgcnt);
+		memcpy(data, tfm_stream_data(tc, OUTPUT_STREAM) + cloff, to_page);
+		memset(data + to_page, 0, (size_t) PAGE_CACHE_SIZE - to_page);
 		flush_dcache_page(page);
 		kunmap(page);
 		SetPageUptodate(page);
@@ -662,7 +712,6 @@ int readpage_ctail(void *vp, struct page
 	assert("edward-114", clust != NULL);
 	assert("edward-115", PageLocked(page));
 	assert("edward-116", !PageUptodate(page));
-	assert("edward-117", !jprivate(page) && !PagePrivate(page));
 	assert("edward-118", page->mapping && page->mapping->host);
 	assert("edward-867", !tfm_cluster_is_uptodate(&clust->tc));
 
@@ -679,13 +728,11 @@ int readpage_ctail(void *vp, struct page
 		return result;
 	}
 	assert("vs-25", hint->ext_coord.lh == &hint->lh);
+
 	result = do_readpage_ctail(page->mapping->host, clust, page,
 				   ZNODE_READ_LOCK);
-
 	assert("edward-213", PageLocked(page));
 	assert("edward-1163", ergo(!result, PageUptodate(page)));
-	assert("edward-868",
-	       ergo(!result, tfm_cluster_is_uptodate(&clust->tc)));
 
 	unlock_page(page);
 	done_lh(&hint->lh);
@@ -707,14 +754,11 @@ static int ctail_read_page_cluster(struc
 	assert("edward-1059", clust->win == NULL);
 	assert("edward-780", inode != NULL);
 
-	result = prepare_page_cluster(inode, clust, 0 /* do not capture */ );
+	result = prepare_page_cluster(inode, clust, READ_OP);
 	if (result)
 		return result;
-	result = ctail_read_disk_cluster(clust, inode, ZNODE_READ_LOCK);
-	if (result)
-		goto out;
-	/* at this point stream with valid plain text is attached */
-	assert("edward-781", tfm_cluster_is_uptodate(&clust->tc));
+
+	assert("edward-781", !tfm_cluster_is_uptodate(&clust->tc));
 
 	for (i = 0; i < clust->nr_pages; i++) {
 		struct page *page = clust->pages[i];
@@ -725,8 +769,7 @@ static int ctail_read_page_cluster(struc
 			break;
 	}
 	tfm_cluster_clr_uptodate(&clust->tc);
-      out:
-	reiser4_release_cluster_pages(clust);
+	put_page_cluster(clust, inode, READ_OP);
 	return result;
 }
 
@@ -737,28 +780,34 @@ static int ctail_readpages_filler(void *
 	struct cluster_handle * clust = data;
 	struct inode * inode = clust->file->f_dentry->d_inode;
 
+	assert("edward-1525", page->mapping == inode->i_mapping);
+
 	if (PageUptodate(page)) {
 		unlock_page(page);
 		return 0;
 	}
-	unlock_page(page);
+	if (pbytes(page_index(page), inode) == 0) {
+		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		SetPageUptodate(page);
+		unlock_page(page);
+		return 0;
+	}
 	move_cluster_forward(clust, inode, page->index);
-	ret = ctail_read_page_cluster(clust, inode);
-	if (ret)
-		return ret;
-	assert("edward-869", !tfm_cluster_is_uptodate(&clust->tc));
-
-	lock_page(page);
-	ret = do_readpage_ctail(inode, clust, page, ZNODE_READ_LOCK);
-	assert("edward-1061", ergo(!ret, PageUptodate(page)));
 	unlock_page(page);
+	/*
+	 * read the whole page cluster
+	 */
+	ret = ctail_read_page_cluster(clust, inode);
 
+	assert("edward-869", !tfm_cluster_is_uptodate(&clust->tc));
 	return ret;
 }
 
-/* We populate a bit more then upper readahead suggests:
-   with each nominated page we read the whole page cluster
-   this page belongs to. */
+/*
+ * We populate a bit more then upper readahead suggests:
+ * with each nominated page we read the whole page cluster
+ * this page belongs to.
+ */
 int readpages_ctail(struct file *file, struct address_space *mapping,
 		    struct list_head *pages)
 {
@@ -1237,14 +1286,14 @@ static int attach_convert_idata(flush_po
 		goto err;
 	info = item_convert_data(pos);
 
-	ret = flush_cluster_pages(clust, pos->child, inode);
+	ret = checkout_logical_cluster(clust, pos->child, inode);
 	if (ret)
 		goto err;
 
 	reiser4_deflate_cluster(clust, inode);
 	inc_item_convert_count(pos);
 
-	/* make flow by transformed stream */
+	/* prepare flow for insertion */
 	fplug->flow_by_inode(info->inode,
 			     (const char __user *)tfm_stream_data(&clust->tc, OUTPUT_STREAM),
 			     0 /* kernel space */ ,
@@ -1310,18 +1359,14 @@ int utmost_child_ctail(const coord_t * c
    Disk cluster is a set of items. If ->clustered() != NULL,
    with each item the whole disk cluster should be read/modified
 */
-static int clustered_ctail(const coord_t * p1, const coord_t * p2)
-{
-	return mergeable_ctail(p1, p2);
-}
 
 /* Go rightward and check for next disk cluster item, set
-   d_next to DC_CHAINED_ITEM, if the last one exists.
-   If the current position is last item, go to right neighbor.
-   Skip empty nodes. Note, that right neighbors may be not in
-   the slum because of races. If so, make it dirty and
-   convertible.
-*/
+ * d_next to DC_CHAINED_ITEM, if the last one exists.
+ * If the current position is last item, go to right neighbor.
+ * Skip empty nodes. Note, that right neighbors may be not in
+ * the slum because of races. If so, make it dirty and
+ * convertible.
+ */
 static int next_item_dc_stat(flush_pos_t * pos)
 {
 	int ret = 0;
@@ -1345,7 +1390,10 @@ static int next_item_dc_stat(flush_pos_t
 	if (pos->coord.item_pos < coord_num_items(&pos->coord) - 1)
 		return ret;
 
-	/* check next slum item */
+	/* Check next slum item.
+	 * Note, that it can not be killed by concurrent truncate,
+	 * as the last one will want the lock held by us.
+	 */
 	init_lh(&right_lock);
 	cur = pos->coord.node;
 
@@ -1368,7 +1416,7 @@ static int next_item_dc_stat(flush_pos_t
 			znode_make_dirty(lh.node);
 			znode_set_convertible(lh.node);
 			stop = 0;
-		} else if (clustered_ctail(&pos->coord, &coord)) {
+		} else if (same_disk_cluster(&pos->coord, &coord)) {
 
 			item_convert_data(pos)->d_next = DC_CHAINED_ITEM;
 
@@ -1508,6 +1556,7 @@ int convert_ctail(flush_pos_t * pos)
 	assert("edward-1022",
 	       pos->coord.item_pos < coord_num_items(&pos->coord));
 
+	/* check if next item is of current disk cluster */
 	result = next_item_dc_stat(pos);
 	if (result) {
 		detach_convert_idata(pos->sq);
_

Patches currently in -mm which might be from edward@namesys.com are

lzo-add-some-missing-casts.patch
reiser4.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
reiser4-fix-extent2tail.patch
reiser4-fix-read_tail.patch
reiser4-fix-unix-file-readpages-filler.patch
reiser4-fix-for-new-aops-patches.patch
git-block-vs-reiser4.patch
reiser4-cryptcompress-misc-fixups.patch
reiser4-change-error-code-base.patch

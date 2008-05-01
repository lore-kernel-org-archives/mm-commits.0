From: akpm@linux-foundation.org
Subject: - reiser4-fix-disk-cluster-synchronization.patch removed from -mm tree
Date: Thu, 01 May 2008 02:23:29 -0700
Message-ID: <200805010923.m419NTu5030097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755250AbYEAJYA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:24:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix disk cluster synchronization
has been removed from the -mm tree.  Its filename was
     reiser4-fix-disk-cluster-synchronization.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: fix disk cluster synchronization
From: Edward Shishkin <edward.shishkin@gmail.com>

Problem:
(2.6.24-rc3-mm2) BUG: unable to handle kernel NULL
pointer dereference at virtual address 00000024
EIP is at convert_ctail+0x14e/0x166

Bug: When updating disk clusters convert_ctail()
looks at inode which is already evicted from memory
or reused for other needs.

Fixup: Keep all needed file-specific info in
convert_item_info before disk cluster update
(when inode is pinned), then forget about inode.

Cleanups in plugin/file/file_conversion.c

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/flush.h                       |    9 ----
 fs/reiser4/plugin/file/file_conversion.c |   42 +++++---------------
 fs/reiser4/plugin/item/ctail.c           |   44 ++++++++++-----------
 3 files changed, 35 insertions(+), 60 deletions(-)

diff -puN fs/reiser4/flush.h~reiser4-fix-disk-cluster-synchronization fs/reiser4/flush.h
--- a/fs/reiser4/flush.h~reiser4-fix-disk-cluster-synchronization
+++ a/fs/reiser4/flush.h
@@ -59,8 +59,8 @@ struct flush_scan {
 struct convert_item_info {
 	dc_item_stat d_cur;	/* disk cluster state of the current item */
 	dc_item_stat d_next;	/* disk cluster state of the next slum item */
-	struct inode *inode;
-	flow_t flow;
+	int cluster_shift;      /* disk cluster shift */
+	flow_t flow;            /* disk cluster data */
 };
 
 struct convert_info {
@@ -242,11 +242,6 @@ do {							        	\
 		       item_convert_data(pos)->d_cur,			\
 		       item_convert_data(pos)->d_next,			\
 		       item_convert_data(pos)->flow.length);		\
-		printk("inode %llu, size = %llu, cluster %lu\n",	\
-		       (unsigned long long)get_inode_oid		\
-		       (item_convert_data(pos)->inode),			\
-		       i_size_read(item_convert_data(pos)->inode),	\
-		       convert_data(pos)->clust.index);			\
 	}								\
 } while (0)
 #else
diff -puN fs/reiser4/plugin/file/file_conversion.c~reiser4-fix-disk-cluster-synchronization fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~reiser4-fix-disk-cluster-synchronization
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -430,27 +430,6 @@ static int reserve_cryptcompress2unixfil
 		 BA_CAN_COMMIT);
 }
 
-/* clear flag that indicated conversion and update
-   stat-data with new (unix-file - specific) info */
-static int complete_file_conversion(struct inode *inode)
-{
-	int result;
-
-	grab_space_enable();
-	result =
-	    reiser4_grab_space(inode_file_plugin(inode)->estimate.update(inode),
-			       BA_CAN_COMMIT);
-	if (result == 0) {
-		reiser4_inode_clr_flag(inode, REISER4_FILE_CONV_IN_PROGRESS);
-		result = reiser4_update_sd(inode);
-	}
-	if (result)
-		warning("edward-1452",
-			"Converting %llu to unix-file: update sd failed (%i)",
-			(unsigned long long)get_inode_oid(inode), result);
-	return 0;
-}
-
 /**
  * Convert cryptcompress file plugin to unix_file plugin.
  */
@@ -468,6 +447,7 @@ static int cryptcompress2unixfile(struct
 	result = reserve_cryptcompress2unixfile(inode);
 	if (result)
 		goto out;
+	/* tell kill_hook to not truncate pages */
 	reiser4_inode_set_flag(inode, REISER4_FILE_CONV_IN_PROGRESS);
 	result = cut_disk_cluster(inode, 0);
 	if (result)
@@ -494,18 +474,17 @@ static int cryptcompress2unixfile(struct
 		if (result)
 			break;
 	}
-	if (!result) {
-		uf_info->container = UF_CONTAINER_EXTENTS;
-		complete_file_conversion(inode);
-	}
+	if (unlikely(result))
+		goto out;
+	uf_info->container = UF_CONTAINER_EXTENTS;
+	result = reiser4_update_sd(inode);
  out:
 	all_grabbed2free();
-	if (result)
-		warning("edward-1453", "Failed to convert file %llu: ret=%i",
-			(unsigned long long)get_inode_oid(inode), result);
 	return result;
 }
 
+#define convert_file_plugin cryptcompress2unixfile
+
 /**
  * This is called by ->write() method of a cryptcompress file plugin.
  * Make a decision about the most reasonable file plugin id to manage
@@ -611,10 +590,13 @@ ssize_t reiser4_write_careful(struct fil
 	 * Perform conversion to the new plugin.
 	 */
 	down_read(&reiser4_inode_data(inode)->conv_sem);
-	result = cryptcompress2unixfile(file, inode, &cont);
+	result = convert_file_plugin(file, inode, &cont);
 	up_read(&reiser4_inode_data(inode)->conv_sem);
 	if (result) {
-		warning("edward-1544", "file conversion failed: %d", result);
+		warning("edward-1544",
+			"Inode %llu: file plugin conversion failed (%d)",
+			(unsigned long long)get_inode_oid(inode),
+			result);
 		context_set_commit_async(ctx);
 		goto exit;
 	}
diff -puN fs/reiser4/plugin/item/ctail.c~reiser4-fix-disk-cluster-synchronization fs/reiser4/plugin/item/ctail.c
--- a/fs/reiser4/plugin/item/ctail.c~reiser4-fix-disk-cluster-synchronization
+++ a/fs/reiser4/plugin/item/ctail.c
@@ -896,14 +896,13 @@ static int insert_unprepped_ctail(struct
 
 static int
 insert_cryptcompress_flow(coord_t * coord, lock_handle * lh, flow_t * f,
-			  struct inode *inode)
+			  int cluster_shift)
 {
 	int result;
 	carry_pool *pool;
 	carry_level *lowest_level;
 	reiser4_item_data *data;
 	carry_op *op;
-	int cluster_shift = inode_cluster_shift(inode);
 
 	pool =
 	    init_carry_pool(sizeof(*pool) + 3 * sizeof(*lowest_level) +
@@ -954,15 +953,14 @@ insert_cryptcompress_flow(coord_t * coor
 /* Implementation of CRC_APPEND_ITEM mode of ctail conversion */
 static int insert_cryptcompress_flow_in_place(coord_t * coord,
 					      lock_handle * lh, flow_t * f,
-					      struct inode *inode)
+					      int cluster_shift)
 {
 	int ret;
 	coord_t pos;
 	lock_handle lock;
 
-	assert("edward-674", f->length <= inode_scaled_cluster_size(inode));
-	assert("edward-484", coord->between == AT_UNIT
-	       || coord->between == AFTER_ITEM);
+	assert("edward-484",
+	       coord->between == AT_UNIT || coord->between == AFTER_ITEM);
 	assert("edward-485", item_id_by_coord(coord) == CTAIL_ID);
 
 	coord_dup(&pos, coord);
@@ -972,7 +970,7 @@ static int insert_cryptcompress_flow_in_
 	init_lh(&lock);
 	copy_lh(&lock, lh);
 
-	ret = insert_cryptcompress_flow(&pos, &lock, f, inode);
+	ret = insert_cryptcompress_flow(&pos, &lock, f, cluster_shift);
 	done_lh(&lock);
 	assert("edward-1347", znode_is_write_locked(lh->node));
 	assert("edward-1228", !ret);
@@ -1079,7 +1077,7 @@ static int do_convert_ctail(flush_pos_t 
 		    insert_cryptcompress_flow_in_place(&pos->coord,
 						       &pos->lock,
 						       &info->flow,
-						       info->inode);
+						       info->cluster_shift);
 		break;
 	case CRC_OVERWRITE_ITEM:
 		assert("edward-1230", info->flow.length != 0);
@@ -1157,14 +1155,18 @@ static int should_attach_convert_idata(f
 	return result;
 }
 
-/* plugin->init_convert_data() */
-static int
-init_convert_data_ctail(struct convert_item_info * idata, struct inode *inode)
+/**
+ * Collect all needed information about the object here,
+ * as in-memory inode can be evicted from memory before
+ * disk update completion.
+ */
+static int init_convert_data_ctail(struct convert_item_info * idata,
+				   struct inode *inode)
 {
 	assert("edward-813", idata != NULL);
 	assert("edward-814", inode != NULL);
 
-	idata->inode = inode;
+	idata->cluster_shift = inode_cluster_shift(inode);
 	idata->d_cur = DC_FIRST_ITEM;
 	idata->d_next = DC_INVALID_STATE;
 
@@ -1295,15 +1297,13 @@ static int attach_convert_idata(flush_po
 	inc_item_convert_count(pos);
 
 	/* prepare flow for insertion */
-	fplug->flow_by_inode(info->inode,
+	fplug->flow_by_inode(inode,
 			     (const char __user *)tfm_stream_data(&clust->tc, OUTPUT_STREAM),
 			     0 /* kernel space */ ,
 			     clust->tc.len,
 			     clust_to_off(clust->index, inode),
 			     WRITE_OP, &info->flow);
 	jput(pos->child);
-
-	assert("edward-683", cryptcompress_inode_ok(inode));
 	return 0;
       err:
 	jput(pos->child);
@@ -1320,7 +1320,6 @@ static void detach_convert_idata(struct 
 	assert("edward-840", sq->itm != NULL);
 
 	info = sq->itm;
-	assert("edward-255", info->inode != NULL);
 	assert("edward-1212", info->flow.length == 0);
 
 	free_item_convert_data(sq);
@@ -1591,13 +1590,12 @@ int convert_ctail(flush_pos_t * pos)
 	case CRC_OVERWRITE_ITEM:
 		if (coord_is_unprepped_ctail(&pos->coord)) {
 			/* convert unpprepped ctail to prepped one */
-			int shift;
-			shift =
-			    inode_cluster_shift(item_convert_data(pos)->inode);
-			assert("edward-1259", cluster_shift_ok(shift));
-			put_unaligned((d8)shift,
-				&ctail_formatted_at(&pos->coord)->
-				cluster_shift);
+			assert("edward-1259",
+			       cluster_shift_ok(item_convert_data(pos)->
+						cluster_shift));
+			put_unaligned((d8)item_convert_data(pos)->cluster_shift,
+				      &ctail_formatted_at(&pos->coord)->
+				      cluster_shift);
 		}
 		break;
 	}
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

origin.patch
reiser4.patch
reiser4-fix-disk-cluster-synchronization.patch
reiser4-use-balance_dirty_pages_ratelimited_nr.patch
reiser4-correct-references-to-filemap_nopage.patch
reiser4-fix-null-pointer-dereference-in-reiser4_write_extent.patch
reiser4-code-cleanups.patch


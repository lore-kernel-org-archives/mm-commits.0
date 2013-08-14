From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-null-pointer-dereference-in-ocfs2_duplicate_clusters_by_page.patch removed from -mm tree
Date: Wed, 14 Aug 2013 12:35:42 -0700
Message-ID: <520bdc0e.3EwlkUWBAo3gq8Xm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120Ab3HNTfn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 15:35:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wb@munzinger.de, tm@tao.ma, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, tiger.yang@oracle.com

Subject: [merged] ocfs2-fix-null-pointer-dereference-in-ocfs2_duplicate_clusters_by_page.patch removed from -mm tree
To: tiger.yang@oracle.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,tm@tao.ma,wb@munzinger.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 12:35:42 -0700


The patch titled
     Subject: ocfs2: fix NULL pointer dereference in ocfs2_duplicate_clusters_by_page
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-null-pointer-dereference-in-ocfs2_duplicate_clusters_by_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tiger Yang <tiger.yang@oracle.com>
Subject: ocfs2: fix NULL pointer dereference in ocfs2_duplicate_clusters_by_page

Since ocfs2_cow_file_pos will invoke ocfs2_refcount_icow with a NULL as
the struct file pointer, it finally result in a null pointer dereference
in ocfs2_duplicate_clusters_by_page.

This patch replace file pointer with inode pointer in
cow_duplicate_clusters to fix this issue.

[jeff.liu@oracle.com: rebased patch against linux-next tree]
Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Tao Ma <tm@tao.ma>
Tested-by: David Weber <wb@munzinger.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c         |    2 -
 fs/ocfs2/file.c         |    6 ++--
 fs/ocfs2/move_extents.c |    2 -
 fs/ocfs2/refcounttree.c |   53 +++++---------------------------------
 fs/ocfs2/refcounttree.h |    6 ++--
 5 files changed, 16 insertions(+), 53 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_duplicate_clusters_by_page fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_duplicate_clusters_by_page
+++ a/fs/ocfs2/aops.c
@@ -1757,7 +1757,7 @@ try_again:
 		goto out;
 	} else if (ret == 1) {
 		clusters_need = wc->w_clen;
-		ret = ocfs2_refcount_cow(inode, filp, di_bh,
+		ret = ocfs2_refcount_cow(inode, di_bh,
 					 wc->w_cpos, wc->w_clen, UINT_MAX);
 		if (ret) {
 			mlog_errno(ret);
diff -puN fs/ocfs2/file.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_duplicate_clusters_by_page fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_duplicate_clusters_by_page
+++ a/fs/ocfs2/file.c
@@ -370,7 +370,7 @@ static int ocfs2_cow_file_pos(struct ino
 	if (!(ext_flags & OCFS2_EXT_REFCOUNTED))
 		goto out;
 
-	return ocfs2_refcount_cow(inode, NULL, fe_bh, cpos, 1, cpos+1);
+	return ocfs2_refcount_cow(inode, fe_bh, cpos, 1, cpos+1);
 
 out:
 	return status;
@@ -899,7 +899,7 @@ static int ocfs2_zero_extend_get_range(s
 		zero_clusters = last_cpos - zero_cpos;
 
 	if (needs_cow) {
-		rc = ocfs2_refcount_cow(inode, NULL, di_bh, zero_cpos,
+		rc = ocfs2_refcount_cow(inode, di_bh, zero_cpos,
 					zero_clusters, UINT_MAX);
 		if (rc) {
 			mlog_errno(rc);
@@ -2078,7 +2078,7 @@ static int ocfs2_prepare_inode_for_refco
 
 	*meta_level = 1;
 
-	ret = ocfs2_refcount_cow(inode, file, di_bh, cpos, clusters, UINT_MAX);
+	ret = ocfs2_refcount_cow(inode, di_bh, cpos, clusters, UINT_MAX);
 	if (ret)
 		mlog_errno(ret);
 out:
diff -puN fs/ocfs2/move_extents.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_duplicate_clusters_by_page fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_duplicate_clusters_by_page
+++ a/fs/ocfs2/move_extents.c
@@ -69,7 +69,7 @@ static int __ocfs2_move_extent(handle_t
 	u64 ino = ocfs2_metadata_cache_owner(context->et.et_ci);
 	u64 old_blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cpos);
 
-	ret = ocfs2_duplicate_clusters_by_page(handle, context->file, cpos,
+	ret = ocfs2_duplicate_clusters_by_page(handle, inode, cpos,
 					       p_cpos, new_p_cpos, len);
 	if (ret) {
 		mlog_errno(ret);
diff -puN fs/ocfs2/refcounttree.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_duplicate_clusters_by_page fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_duplicate_clusters_by_page
+++ a/fs/ocfs2/refcounttree.c
@@ -49,7 +49,6 @@
 
 struct ocfs2_cow_context {
 	struct inode *inode;
-	struct file *file;
 	u32 cow_start;
 	u32 cow_len;
 	struct ocfs2_extent_tree data_et;
@@ -66,7 +65,7 @@ struct ocfs2_cow_context {
 			    u32 *num_clusters,
 			    unsigned int *extent_flags);
 	int (*cow_duplicate_clusters)(handle_t *handle,
-				      struct file *file,
+				      struct inode *inode,
 				      u32 cpos, u32 old_cluster,
 				      u32 new_cluster, u32 new_len);
 };
@@ -2922,14 +2921,12 @@ static int ocfs2_clear_cow_buffer(handle
 }
 
 int ocfs2_duplicate_clusters_by_page(handle_t *handle,
-				     struct file *file,
+				     struct inode *inode,
 				     u32 cpos, u32 old_cluster,
 				     u32 new_cluster, u32 new_len)
 {
 	int ret = 0, partial;
-	struct inode *inode = file_inode(file);
-	struct ocfs2_caching_info *ci = INODE_CACHE(inode);
-	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
+	struct super_block *sb = inode->i_sb;
 	u64 new_block = ocfs2_clusters_to_blocks(sb, new_cluster);
 	struct page *page;
 	pgoff_t page_index;
@@ -2978,13 +2975,6 @@ int ocfs2_duplicate_clusters_by_page(han
 		if (PAGE_CACHE_SIZE <= OCFS2_SB(sb)->s_clustersize)
 			BUG_ON(PageDirty(page));
 
-		if (PageReadahead(page)) {
-			page_cache_async_readahead(mapping,
-						   &file->f_ra, file,
-						   page, page_index,
-						   readahead_pages);
-		}
-
 		if (!PageUptodate(page)) {
 			ret = block_read_full_page(page, ocfs2_get_block);
 			if (ret) {
@@ -3004,7 +2994,8 @@ int ocfs2_duplicate_clusters_by_page(han
 			}
 		}
 
-		ocfs2_map_and_dirty_page(inode, handle, from, to,
+		ocfs2_map_and_dirty_page(inode,
+					 handle, from, to,
 					 page, 0, &new_block);
 		mark_page_accessed(page);
 unlock:
@@ -3020,12 +3011,11 @@ unlock:
 }
 
 int ocfs2_duplicate_clusters_by_jbd(handle_t *handle,
-				    struct file *file,
+				    struct inode *inode,
 				    u32 cpos, u32 old_cluster,
 				    u32 new_cluster, u32 new_len)
 {
 	int ret = 0;
-	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	struct ocfs2_caching_info *ci = INODE_CACHE(inode);
 	int i, blocks = ocfs2_clusters_to_blocks(sb, new_len);
@@ -3150,7 +3140,7 @@ static int ocfs2_replace_clusters(handle
 
 	/*If the old clusters is unwritten, no need to duplicate. */
 	if (!(ext_flags & OCFS2_EXT_UNWRITTEN)) {
-		ret = context->cow_duplicate_clusters(handle, context->file,
+		ret = context->cow_duplicate_clusters(handle, context->inode,
 						      cpos, old, new, len);
 		if (ret) {
 			mlog_errno(ret);
@@ -3428,35 +3418,12 @@ static int ocfs2_replace_cow(struct ocfs
 	return ret;
 }
 
-static void ocfs2_readahead_for_cow(struct inode *inode,
-				    struct file *file,
-				    u32 start, u32 len)
-{
-	struct address_space *mapping;
-	pgoff_t index;
-	unsigned long num_pages;
-	int cs_bits = OCFS2_SB(inode->i_sb)->s_clustersize_bits;
-
-	if (!file)
-		return;
-
-	mapping = file->f_mapping;
-	num_pages = (len << cs_bits) >> PAGE_CACHE_SHIFT;
-	if (!num_pages)
-		num_pages = 1;
-
-	index = ((loff_t)start << cs_bits) >> PAGE_CACHE_SHIFT;
-	page_cache_sync_readahead(mapping, &file->f_ra, file,
-				  index, num_pages);
-}
-
 /*
  * Starting at cpos, try to CoW write_len clusters.  Don't CoW
  * past max_cpos.  This will stop when it runs into a hole or an
  * unrefcounted extent.
  */
 static int ocfs2_refcount_cow_hunk(struct inode *inode,
-				   struct file *file,
 				   struct buffer_head *di_bh,
 				   u32 cpos, u32 write_len, u32 max_cpos)
 {
@@ -3485,8 +3452,6 @@ static int ocfs2_refcount_cow_hunk(struc
 
 	BUG_ON(cow_len == 0);
 
-	ocfs2_readahead_for_cow(inode, file, cow_start, cow_len);
-
 	context = kzalloc(sizeof(struct ocfs2_cow_context), GFP_NOFS);
 	if (!context) {
 		ret = -ENOMEM;
@@ -3508,7 +3473,6 @@ static int ocfs2_refcount_cow_hunk(struc
 	context->ref_root_bh = ref_root_bh;
 	context->cow_duplicate_clusters = ocfs2_duplicate_clusters_by_page;
 	context->get_clusters = ocfs2_di_get_clusters;
-	context->file = file;
 
 	ocfs2_init_dinode_extent_tree(&context->data_et,
 				      INODE_CACHE(inode), di_bh);
@@ -3537,7 +3501,6 @@ out:
  * clusters between cpos and cpos+write_len are safe to modify.
  */
 int ocfs2_refcount_cow(struct inode *inode,
-		       struct file *file,
 		       struct buffer_head *di_bh,
 		       u32 cpos, u32 write_len, u32 max_cpos)
 {
@@ -3557,7 +3520,7 @@ int ocfs2_refcount_cow(struct inode *ino
 			num_clusters = write_len;
 
 		if (ext_flags & OCFS2_EXT_REFCOUNTED) {
-			ret = ocfs2_refcount_cow_hunk(inode, file, di_bh, cpos,
+			ret = ocfs2_refcount_cow_hunk(inode, di_bh, cpos,
 						      num_clusters, max_cpos);
 			if (ret) {
 				mlog_errno(ret);
diff -puN fs/ocfs2/refcounttree.h~ocfs2-fix-null-pointer-dereference-in-ocfs2_duplicate_clusters_by_page fs/ocfs2/refcounttree.h
--- a/fs/ocfs2/refcounttree.h~ocfs2-fix-null-pointer-dereference-in-ocfs2_duplicate_clusters_by_page
+++ a/fs/ocfs2/refcounttree.h
@@ -53,7 +53,7 @@ int ocfs2_prepare_refcount_change_for_de
 					  int *credits,
 					  int *ref_blocks);
 int ocfs2_refcount_cow(struct inode *inode,
-		       struct file *filep, struct buffer_head *di_bh,
+		       struct buffer_head *di_bh,
 		       u32 cpos, u32 write_len, u32 max_cpos);
 
 typedef int (ocfs2_post_refcount_func)(struct inode *inode,
@@ -85,11 +85,11 @@ int ocfs2_refcount_cow_xattr(struct inod
 			     u32 cpos, u32 write_len,
 			     struct ocfs2_post_refcount *post);
 int ocfs2_duplicate_clusters_by_page(handle_t *handle,
-				     struct file *file,
+				     struct inode *inode,
 				     u32 cpos, u32 old_cluster,
 				     u32 new_cluster, u32 new_len);
 int ocfs2_duplicate_clusters_by_jbd(handle_t *handle,
-				    struct file *file,
+				    struct inode *inode,
 				    u32 cpos, u32 old_cluster,
 				    u32 new_cluster, u32 new_len);
 int ocfs2_cow_sync_writeback(struct super_block *sb,
_

Patches currently in -mm which might be from tiger.yang@oracle.com are

origin.patch


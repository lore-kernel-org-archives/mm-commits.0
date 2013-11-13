From: akpm@linux-foundation.org
Subject: [merged] ocfs2-return-enomem-when-sb_getblk-fails.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:37:12 -0800
Message-ID: <5283e2f8.zPi78KJcIFxtpi8I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3KMUhN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.de, joseph.qi@huawei.com, jlbec@evilplan.org, jeff.liu@oracle.com, rui.xiang@huawei.com

Subject: [merged] ocfs2-return-enomem-when-sb_getblk-fails.patch removed from -mm tree
To: rui.xiang@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:12 -0800


The patch titled
     Subject: ocfs2: return ENOMEM when sb_getblk() fails
has been removed from the -mm tree.  Its filename was
     ocfs2-return-enomem-when-sb_getblk-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rui Xiang <rui.xiang@huawei.com>
Subject: ocfs2: return ENOMEM when sb_getblk() fails

The only reason for sb_getblk() failing is if it can't allocate the
buffer_head.  So return ENOMEM instead when it fails.

[joseph.qi@huawei.com: ocfs2_symlink_get_block() and ocfs2_read_blocks_sync() and ocfs2_read_blocks() need the same change]
Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c          |    2 +-
 fs/ocfs2/aops.c           |    2 ++
 fs/ocfs2/buffer_head_io.c |    4 ++--
 fs/ocfs2/dir.c            |    8 ++++----
 fs/ocfs2/namei.c          |    2 +-
 fs/ocfs2/refcounttree.c   |    6 +++---
 fs/ocfs2/suballoc.c       |    4 ++--
 fs/ocfs2/super.c          |    4 ++--
 fs/ocfs2/xattr.c          |    2 +-
 9 files changed, 18 insertions(+), 16 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-return-enomem-when-sb_getblk-fails fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-return-enomem-when-sb_getblk-fails
+++ a/fs/ocfs2/alloc.c
@@ -1025,7 +1025,7 @@ static int ocfs2_create_new_meta_bhs(han
 		for(i = count;  i < (num_got + count); i++) {
 			bhs[i] = sb_getblk(osb->sb, first_blkno);
 			if (bhs[i] == NULL) {
-				status = -EIO;
+				status = -ENOMEM;
 				mlog_errno(status);
 				goto bail;
 			}
diff -puN fs/ocfs2/aops.c~ocfs2-return-enomem-when-sb_getblk-fails fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-return-enomem-when-sb_getblk-fails
+++ a/fs/ocfs2/aops.c
@@ -80,6 +80,7 @@ static int ocfs2_symlink_get_block(struc
 
 	if ((u64)iblock >= ocfs2_clusters_to_blocks(inode->i_sb,
 						    le32_to_cpu(fe->i_clusters))) {
+		err = -ENOMEM;
 		mlog(ML_ERROR, "block offset is outside the allocated size: "
 		     "%llu\n", (unsigned long long)iblock);
 		goto bail;
@@ -92,6 +93,7 @@ static int ocfs2_symlink_get_block(struc
 			    iblock;
 		buffer_cache_bh = sb_getblk(osb->sb, blkno);
 		if (!buffer_cache_bh) {
+			err = -ENOMEM;
 			mlog(ML_ERROR, "couldn't getblock for symlink!\n");
 			goto bail;
 		}
diff -puN fs/ocfs2/buffer_head_io.c~ocfs2-return-enomem-when-sb_getblk-fails fs/ocfs2/buffer_head_io.c
--- a/fs/ocfs2/buffer_head_io.c~ocfs2-return-enomem-when-sb_getblk-fails
+++ a/fs/ocfs2/buffer_head_io.c
@@ -115,7 +115,7 @@ int ocfs2_read_blocks_sync(struct ocfs2_
 		if (bhs[i] == NULL) {
 			bhs[i] = sb_getblk(osb->sb, block++);
 			if (bhs[i] == NULL) {
-				status = -EIO;
+				status = -ENOMEM;
 				mlog_errno(status);
 				goto bail;
 			}
@@ -214,7 +214,7 @@ int ocfs2_read_blocks(struct ocfs2_cachi
 			bhs[i] = sb_getblk(sb, block++);
 			if (bhs[i] == NULL) {
 				ocfs2_metadata_cache_io_unlock(ci);
-				status = -EIO;
+				status = -ENOMEM;
 				mlog_errno(status);
 				goto bail;
 			}
diff -puN fs/ocfs2/dir.c~ocfs2-return-enomem-when-sb_getblk-fails fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-return-enomem-when-sb_getblk-fails
+++ a/fs/ocfs2/dir.c
@@ -2349,7 +2349,7 @@ static int ocfs2_dx_dir_attach_index(str
 
 	dx_root_bh = sb_getblk(osb->sb, dr_blkno);
 	if (dx_root_bh == NULL) {
-		ret = -EIO;
+		ret = -ENOMEM;
 		goto out;
 	}
 	ocfs2_set_new_buffer_uptodate(INODE_CACHE(dir), dx_root_bh);
@@ -2422,7 +2422,7 @@ static int ocfs2_dx_dir_format_cluster(s
 	for (i = 0; i < num_dx_leaves; i++) {
 		bh = sb_getblk(osb->sb, start_blk + i);
 		if (bh == NULL) {
-			ret = -EIO;
+			ret = -ENOMEM;
 			goto out;
 		}
 		dx_leaves[i] = bh;
@@ -2929,7 +2929,7 @@ static int ocfs2_expand_inline_dir(struc
 	blkno = ocfs2_clusters_to_blocks(dir->i_sb, bit_off);
 	dirdata_bh = sb_getblk(sb, blkno);
 	if (!dirdata_bh) {
-		ret = -EIO;
+		ret = -ENOMEM;
 		mlog_errno(ret);
 		goto out_commit;
 	}
@@ -3159,7 +3159,7 @@ static int ocfs2_do_extend_dir(struct su
 
 	*new_bh = sb_getblk(sb, p_blkno);
 	if (!*new_bh) {
-		status = -EIO;
+		status = -ENOMEM;
 		mlog_errno(status);
 		goto bail;
 	}
diff -puN fs/ocfs2/namei.c~ocfs2-return-enomem-when-sb_getblk-fails fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-return-enomem-when-sb_getblk-fails
+++ a/fs/ocfs2/namei.c
@@ -489,7 +489,7 @@ static int __ocfs2_mknod_locked(struct i
 
 	*new_fe_bh = sb_getblk(osb->sb, fe_blkno);
 	if (!*new_fe_bh) {
-		status = -EIO;
+		status = -ENOMEM;
 		mlog_errno(status);
 		goto leave;
 	}
diff -puN fs/ocfs2/refcounttree.c~ocfs2-return-enomem-when-sb_getblk-fails fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-return-enomem-when-sb_getblk-fails
+++ a/fs/ocfs2/refcounttree.c
@@ -1310,7 +1310,7 @@ static int ocfs2_expand_inline_ref_root(
 
 	new_bh = sb_getblk(sb, blkno);
 	if (new_bh == NULL) {
-		ret = -EIO;
+		ret = -ENOMEM;
 		mlog_errno(ret);
 		goto out;
 	}
@@ -1561,7 +1561,7 @@ static int ocfs2_new_leaf_refcount_block
 
 	new_bh = sb_getblk(sb, blkno);
 	if (new_bh == NULL) {
-		ret = -EIO;
+		ret = -ENOMEM;
 		mlog_errno(ret);
 		goto out;
 	}
@@ -3029,7 +3029,7 @@ int ocfs2_duplicate_clusters_by_jbd(hand
 	for (i = 0; i < blocks; i++, old_block++, new_block++) {
 		new_bh = sb_getblk(osb->sb, new_block);
 		if (new_bh == NULL) {
-			ret = -EIO;
+			ret = -ENOMEM;
 			mlog_errno(ret);
 			break;
 		}
diff -puN fs/ocfs2/suballoc.c~ocfs2-return-enomem-when-sb_getblk-fails fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-return-enomem-when-sb_getblk-fails
+++ a/fs/ocfs2/suballoc.c
@@ -481,7 +481,7 @@ ocfs2_block_group_alloc_contig(struct oc
 
 	bg_bh = sb_getblk(osb->sb, bg_blkno);
 	if (!bg_bh) {
-		status = -EIO;
+		status = -ENOMEM;
 		mlog_errno(status);
 		goto bail;
 	}
@@ -661,7 +661,7 @@ ocfs2_block_group_alloc_discontig(handle
 
 	bg_bh = sb_getblk(osb->sb, bg_blkno);
 	if (!bg_bh) {
-		status = -EIO;
+		status = -ENOMEM;
 		mlog_errno(status);
 		goto bail;
 	}
diff -puN fs/ocfs2/super.c~ocfs2-return-enomem-when-sb_getblk-fails fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-return-enomem-when-sb_getblk-fails
+++ a/fs/ocfs2/super.c
@@ -1848,8 +1848,8 @@ static int ocfs2_get_sector(struct super
 
 	*bh = sb_getblk(sb, block);
 	if (!*bh) {
-		mlog_errno(-EIO);
-		return -EIO;
+		mlog_errno(-ENOMEM);
+		return -ENOMEM;
 	}
 	lock_buffer(*bh);
 	if (!buffer_dirty(*bh))
diff -puN fs/ocfs2/xattr.c~ocfs2-return-enomem-when-sb_getblk-fails fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-return-enomem-when-sb_getblk-fails
+++ a/fs/ocfs2/xattr.c
@@ -377,7 +377,7 @@ static int ocfs2_init_xattr_bucket(struc
 		bucket->bu_bhs[i] = sb_getblk(bucket->bu_inode->i_sb,
 					      xb_blkno + i);
 		if (!bucket->bu_bhs[i]) {
-			rc = -EIO;
+			rc = -ENOMEM;
 			mlog_errno(rc);
 			break;
 		}
_

Patches currently in -mm which might be from rui.xiang@huawei.com are

origin.patch


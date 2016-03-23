From: akpm@linux-foundation.org
Subject: [merged] ocfs2-check-fix-inode-block-for-online-file-check.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:40:21 -0700
Message-ID: <56f2d505.NjswEEBmep1ueaSk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453AbcCWRkW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: check/fix inode block for online file check
has been removed from the -mm tree.  Its filename was
     ocfs2-check-fix-inode-block-for-online-file-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: check/fix inode block for online file check

Implement online check or fix inode block during reading a inode block to
memory.

Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c       |  225 +++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/ocfs2_trace.h |    2 
 2 files changed, 218 insertions(+), 9 deletions(-)

diff -puN fs/ocfs2/inode.c~ocfs2-check-fix-inode-block-for-online-file-check fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-check-fix-inode-block-for-online-file-check
+++ a/fs/ocfs2/inode.c
@@ -53,6 +53,7 @@
 #include "xattr.h"
 #include "refcounttree.h"
 #include "ocfs2_trace.h"
+#include "filecheck.h"
 
 #include "buffer_head_io.h"
 
@@ -74,6 +75,14 @@ static int ocfs2_truncate_for_delete(str
 				    struct inode *inode,
 				    struct buffer_head *fe_bh);
 
+static int ocfs2_filecheck_read_inode_block_full(struct inode *inode,
+						 struct buffer_head **bh,
+						 int flags, int type);
+static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
+						struct buffer_head *bh);
+static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
+					      struct buffer_head *bh);
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -127,6 +136,7 @@ struct inode *ocfs2_ilookup(struct super
 struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 			 int sysfile_type)
 {
+	int rc = 0;
 	struct inode *inode = NULL;
 	struct super_block *sb = osb->sb;
 	struct ocfs2_find_inode_args args;
@@ -161,12 +171,17 @@ struct inode *ocfs2_iget(struct ocfs2_su
 	}
 	trace_ocfs2_iget5_locked(inode->i_state);
 	if (inode->i_state & I_NEW) {
-		ocfs2_read_locked_inode(inode, &args);
+		rc = ocfs2_read_locked_inode(inode, &args);
 		unlock_new_inode(inode);
 	}
 	if (is_bad_inode(inode)) {
 		iput(inode);
-		inode = ERR_PTR(-ESTALE);
+		if ((flags & OCFS2_FI_FLAG_FILECHECK_CHK) ||
+		    (flags & OCFS2_FI_FLAG_FILECHECK_FIX))
+			/* Return OCFS2_FILECHECK_ERR_XXX related errno */
+			inode = ERR_PTR(rc);
+		else
+			inode = ERR_PTR(-ESTALE);
 		goto bail;
 	}
 
@@ -410,7 +425,7 @@ static int ocfs2_read_locked_inode(struc
 	struct ocfs2_super *osb;
 	struct ocfs2_dinode *fe;
 	struct buffer_head *bh = NULL;
-	int status, can_lock;
+	int status, can_lock, lock_level = 0;
 	u32 generation = 0;
 
 	status = -EINVAL;
@@ -478,7 +493,7 @@ static int ocfs2_read_locked_inode(struc
 			mlog_errno(status);
 			return status;
 		}
-		status = ocfs2_inode_lock(inode, NULL, 0);
+		status = ocfs2_inode_lock(inode, NULL, lock_level);
 		if (status) {
 			make_bad_inode(inode);
 			mlog_errno(status);
@@ -495,16 +510,32 @@ static int ocfs2_read_locked_inode(struc
 	}
 
 	if (can_lock) {
-		status = ocfs2_read_inode_block_full(inode, &bh,
-						     OCFS2_BH_IGNORE_CACHE);
+		if (args->fi_flags & OCFS2_FI_FLAG_FILECHECK_CHK)
+			status = ocfs2_filecheck_read_inode_block_full(inode,
+						&bh, OCFS2_BH_IGNORE_CACHE, 0);
+		else if (args->fi_flags & OCFS2_FI_FLAG_FILECHECK_FIX)
+			status = ocfs2_filecheck_read_inode_block_full(inode,
+						&bh, OCFS2_BH_IGNORE_CACHE, 1);
+		else
+			status = ocfs2_read_inode_block_full(inode,
+						&bh, OCFS2_BH_IGNORE_CACHE);
 	} else {
 		status = ocfs2_read_blocks_sync(osb, args->fi_blkno, 1, &bh);
 		/*
 		 * If buffer is in jbd, then its checksum may not have been
 		 * computed as yet.
 		 */
-		if (!status && !buffer_jbd(bh))
-			status = ocfs2_validate_inode_block(osb->sb, bh);
+		if (!status && !buffer_jbd(bh)) {
+			if (args->fi_flags & OCFS2_FI_FLAG_FILECHECK_CHK)
+				status = ocfs2_filecheck_validate_inode_block(
+								osb->sb, bh);
+			else if (args->fi_flags & OCFS2_FI_FLAG_FILECHECK_FIX)
+				status = ocfs2_filecheck_repair_inode_block(
+								osb->sb, bh);
+			else
+				status = ocfs2_validate_inode_block(
+								osb->sb, bh);
+		}
 	}
 	if (status < 0) {
 		mlog_errno(status);
@@ -532,11 +563,24 @@ static int ocfs2_read_locked_inode(struc
 
 	BUG_ON(args->fi_blkno != le64_to_cpu(fe->i_blkno));
 
+	if (buffer_dirty(bh) && !buffer_jbd(bh)) {
+		if (can_lock) {
+			ocfs2_inode_unlock(inode, lock_level);
+			lock_level = 1;
+			ocfs2_inode_lock(inode, NULL, lock_level);
+		}
+		status = ocfs2_write_block(osb, bh, INODE_CACHE(inode));
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
+	}
+
 	status = 0;
 
 bail:
 	if (can_lock)
-		ocfs2_inode_unlock(inode, 0);
+		ocfs2_inode_unlock(inode, lock_level);
 
 	if (status < 0)
 		make_bad_inode(inode);
@@ -1397,6 +1441,169 @@ bail:
 	return rc;
 }
 
+static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
+						struct buffer_head *bh)
+{
+	int rc = 0;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
+
+	trace_ocfs2_filecheck_validate_inode_block(
+		(unsigned long long)bh->b_blocknr);
+
+	BUG_ON(!buffer_uptodate(bh));
+
+	/*
+	 * Call ocfs2_validate_meta_ecc() first since it has ecc repair
+	 * function, but we should not return error immediately when ecc
+	 * validation fails, because the reason is quite likely the invalid
+	 * inode number inputed.
+	 */
+	rc = ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check);
+	if (rc) {
+		mlog(ML_ERROR,
+		     "Filecheck: checksum failed for dinode %llu\n",
+		     (unsigned long long)bh->b_blocknr);
+		rc = -OCFS2_FILECHECK_ERR_BLOCKECC;
+	}
+
+	if (!OCFS2_IS_VALID_DINODE(di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: signature = %.*s\n",
+		     (unsigned long long)bh->b_blocknr, 7, di->i_signature);
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	} else if (rc)
+		goto bail;
+
+	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: i_blkno is %llu\n",
+		     (unsigned long long)bh->b_blocknr,
+		     (unsigned long long)le64_to_cpu(di->i_blkno));
+		rc = -OCFS2_FILECHECK_ERR_BLOCKNO;
+		goto bail;
+	}
+
+	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: OCFS2_VALID_FL "
+		     "not set\n",
+		     (unsigned long long)bh->b_blocknr);
+		rc = -OCFS2_FILECHECK_ERR_VALIDFLAG;
+		goto bail;
+	}
+
+	if (le32_to_cpu(di->i_fs_generation) !=
+	    OCFS2_SB(sb)->fs_generation) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: fs_generation is %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le32_to_cpu(di->i_fs_generation));
+		rc = -OCFS2_FILECHECK_ERR_GENERATION;
+		goto bail;
+	}
+
+bail:
+	return rc;
+}
+
+static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
+					      struct buffer_head *bh)
+{
+	int changed = 0;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
+
+	if (!ocfs2_filecheck_validate_inode_block(sb, bh))
+		return 0;
+
+	trace_ocfs2_filecheck_repair_inode_block(
+		(unsigned long long)bh->b_blocknr);
+
+	if (ocfs2_is_hard_readonly(OCFS2_SB(sb)) ||
+	    ocfs2_is_soft_readonly(OCFS2_SB(sb))) {
+		mlog(ML_ERROR,
+		     "Filecheck: cannot repair dinode #%llu "
+		     "on readonly filesystem\n",
+		     (unsigned long long)bh->b_blocknr);
+		return -OCFS2_FILECHECK_ERR_READONLY;
+	}
+
+	if (buffer_jbd(bh)) {
+		mlog(ML_ERROR,
+		     "Filecheck: cannot repair dinode #%llu, "
+		     "its buffer is in jbd\n",
+		     (unsigned long long)bh->b_blocknr);
+		return -OCFS2_FILECHECK_ERR_INJBD;
+	}
+
+	if (!OCFS2_IS_VALID_DINODE(di)) {
+		/* Cannot fix invalid inode block */
+		return -OCFS2_FILECHECK_ERR_INVALIDINO;
+	}
+
+	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
+		/* Cannot just add VALID_FL flag back as a fix,
+		 * need more things to check here.
+		 */
+		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
+	}
+
+	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+		di->i_blkno = cpu_to_le64(bh->b_blocknr);
+		changed = 1;
+		mlog(ML_ERROR,
+		     "Filecheck: reset dinode #%llu: i_blkno to %llu\n",
+		     (unsigned long long)bh->b_blocknr,
+		     (unsigned long long)le64_to_cpu(di->i_blkno));
+	}
+
+	if (le32_to_cpu(di->i_fs_generation) !=
+	    OCFS2_SB(sb)->fs_generation) {
+		di->i_fs_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
+		changed = 1;
+		mlog(ML_ERROR,
+		     "Filecheck: reset dinode #%llu: fs_generation to %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le32_to_cpu(di->i_fs_generation));
+	}
+
+	if (changed || ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check)) {
+		ocfs2_compute_meta_ecc(sb, bh->b_data, &di->i_check);
+		mark_buffer_dirty(bh);
+		mlog(ML_ERROR,
+		     "Filecheck: reset dinode #%llu: compute meta ecc\n",
+		     (unsigned long long)bh->b_blocknr);
+	}
+
+	return 0;
+}
+
+static int
+ocfs2_filecheck_read_inode_block_full(struct inode *inode,
+				      struct buffer_head **bh,
+				      int flags, int type)
+{
+	int rc;
+	struct buffer_head *tmp = *bh;
+
+	if (!type) /* Check inode block */
+		rc = ocfs2_read_blocks(INODE_CACHE(inode),
+				OCFS2_I(inode)->ip_blkno,
+				1, &tmp, flags,
+				ocfs2_filecheck_validate_inode_block);
+	else /* Repair inode block */
+		rc = ocfs2_read_blocks(INODE_CACHE(inode),
+				OCFS2_I(inode)->ip_blkno,
+				1, &tmp, flags,
+				ocfs2_filecheck_repair_inode_block);
+
+	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
+	if (!rc && !*bh)
+		*bh = tmp;
+
+	return rc;
+}
+
 int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
 				int flags)
 {
diff -puN fs/ocfs2/ocfs2_trace.h~ocfs2-check-fix-inode-block-for-online-file-check fs/ocfs2/ocfs2_trace.h
--- a/fs/ocfs2/ocfs2_trace.h~ocfs2-check-fix-inode-block-for-online-file-check
+++ a/fs/ocfs2/ocfs2_trace.h
@@ -1540,6 +1540,8 @@ DEFINE_OCFS2_ULL_INT_EVENT(ocfs2_read_lo
 DEFINE_OCFS2_INT_INT_EVENT(ocfs2_check_orphan_recovery_state);
 
 DEFINE_OCFS2_ULL_EVENT(ocfs2_validate_inode_block);
+DEFINE_OCFS2_ULL_EVENT(ocfs2_filecheck_validate_inode_block);
+DEFINE_OCFS2_ULL_EVENT(ocfs2_filecheck_repair_inode_block);
 
 TRACE_EVENT(ocfs2_inode_is_valid_to_delete,
 	TP_PROTO(void *task, void *dc_task, unsigned long long ino,
_

Patches currently in -mm which might be from ghe@suse.com are



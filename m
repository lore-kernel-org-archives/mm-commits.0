From: akpm@linux-foundation.org
Subject: + ocfs2-use-osb-instead-of-ocfs2_sb.patch added to -mm tree
Date: Thu, 08 Feb 2018 16:13:18 -0800
Message-ID: <5a7ce79e.EyRUY3cLmPECCUIi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37948 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752132AbeBIANT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Feb 2018 19:13:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, akpm@linux-foundation.org, ge.changwei@h3c.com, jiangqi903@gmail.com, jiangyiwen@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use 'osb' instead of 'OCFS2_SB()'
has been added to the -mm tree.  Its filename is
     ocfs2-use-osb-instead-of-ocfs2_sb.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-use-osb-instead-of-ocfs2_sb.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-use-osb-instead-of-ocfs2_sb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2: use 'osb' instead of 'OCFS2_SB()'

We could use 'osb' instead of 'OCFS2_SB()' to make code more elegant.

Link: http://lkml.kernel.org/r/5A702111.7090907@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c         |    2 +-
 fs/ocfs2/dir.c          |    2 +-
 fs/ocfs2/dlmglue.c      |   21 ++++++++-------------
 fs/ocfs2/file.c         |    2 +-
 fs/ocfs2/inode.c        |    6 +++---
 fs/ocfs2/refcounttree.c |    4 ++--
 fs/ocfs2/suballoc.c     |    4 ++--
 fs/ocfs2/super.c        |    4 ++--
 fs/ocfs2/xattr.c        |    2 +-
 9 files changed, 21 insertions(+), 26 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-use-osb-instead-of-ocfs2_sb fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-use-osb-instead-of-ocfs2_sb
+++ a/fs/ocfs2/aops.c
@@ -2213,7 +2213,7 @@ static int ocfs2_dio_wr_get_block(struct
 	down_write(&oi->ip_alloc_sem);
 
 	if (first_get_block) {
-		if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+		if (ocfs2_sparse_alloc(osb))
 			ret = ocfs2_zero_tail(inode, di_bh, pos);
 		else
 			ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos,
diff -puN fs/ocfs2/dir.c~ocfs2-use-osb-instead-of-ocfs2_sb fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-use-osb-instead-of-ocfs2_sb
+++ a/fs/ocfs2/dir.c
@@ -3072,7 +3072,7 @@ static int ocfs2_expand_inline_dir(struc
 			 * We need to return the correct block within the
 			 * cluster which should hold our entry.
 			 */
-			off = ocfs2_dx_dir_hash_idx(OCFS2_SB(dir->i_sb),
+			off = ocfs2_dx_dir_hash_idx(osb,
 						    &lookup->dl_hinfo);
 			get_bh(dx_leaves[off]);
 			lookup->dl_dx_leaf_bh = dx_leaves[off];
diff -puN fs/ocfs2/dlmglue.c~ocfs2-use-osb-instead-of-ocfs2_sb fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-use-osb-instead-of-ocfs2_sb
+++ a/fs/ocfs2/dlmglue.c
@@ -1756,8 +1756,7 @@ int ocfs2_rw_lock(struct inode *inode, i
 
 	level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
 
-	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres, level, 0,
-				    0);
+	status = ocfs2_cluster_lock(osb, lockres, level, 0, 0);
 	if (status < 0)
 		mlog_errno(status);
 
@@ -1796,7 +1795,7 @@ void ocfs2_rw_unlock(struct inode *inode
 	     write ? "EXMODE" : "PRMODE");
 
 	if (!ocfs2_mount_local(osb))
-		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres, level);
+		ocfs2_cluster_unlock(osb, lockres, level);
 }
 
 /*
@@ -1816,8 +1815,7 @@ int ocfs2_open_lock(struct inode *inode)
 
 	lockres = &OCFS2_I(inode)->ip_open_lockres;
 
-	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres,
-				    DLM_LOCK_PR, 0, 0);
+	status = ocfs2_cluster_lock(osb, lockres, DLM_LOCK_PR, 0, 0);
 	if (status < 0)
 		mlog_errno(status);
 
@@ -1854,8 +1852,7 @@ int ocfs2_try_open_lock(struct inode *in
 	 * other nodes and the -EAGAIN will indicate to the caller that
 	 * this inode is still in use.
 	 */
-	status = ocfs2_cluster_lock(OCFS2_SB(inode->i_sb), lockres,
-				    level, DLM_LKF_NOQUEUE, 0);
+	status = ocfs2_cluster_lock(osb, lockres, level, DLM_LKF_NOQUEUE, 0);
 
 out:
 	return status;
@@ -1876,11 +1873,9 @@ void ocfs2_open_unlock(struct inode *ino
 		goto out;
 
 	if(lockres->l_ro_holders)
-		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres,
-				     DLM_LOCK_PR);
+		ocfs2_cluster_unlock(osb, lockres, DLM_LOCK_PR);
 	if(lockres->l_ex_holders)
-		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres,
-				     DLM_LOCK_EX);
+		ocfs2_cluster_unlock(osb, lockres, DLM_LOCK_EX);
 
 out:
 	return;
@@ -2601,9 +2596,9 @@ void ocfs2_inode_unlock(struct inode *in
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     ex ? "EXMODE" : "PRMODE");
 
-	if (!ocfs2_is_hard_readonly(OCFS2_SB(inode->i_sb)) &&
+	if (!ocfs2_is_hard_readonly(osb) &&
 	    !ocfs2_mount_local(osb))
-		ocfs2_cluster_unlock(OCFS2_SB(inode->i_sb), lockres, level);
+		ocfs2_cluster_unlock(osb, lockres, level);
 }
 
 /*
diff -puN fs/ocfs2/file.c~ocfs2-use-osb-instead-of-ocfs2_sb fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-use-osb-instead-of-ocfs2_sb
+++ a/fs/ocfs2/file.c
@@ -296,7 +296,7 @@ int ocfs2_update_inode_atime(struct inod
 	ocfs2_journal_dirty(handle, bh);
 
 out_commit:
-	ocfs2_commit_trans(OCFS2_SB(inode->i_sb), handle);
+	ocfs2_commit_trans(osb, handle);
 out:
 	return ret;
 }
diff -puN fs/ocfs2/inode.c~ocfs2-use-osb-instead-of-ocfs2_sb fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-use-osb-instead-of-ocfs2_sb
+++ a/fs/ocfs2/inode.c
@@ -1135,7 +1135,7 @@ static void ocfs2_clear_inode(struct ino
 	trace_ocfs2_clear_inode((unsigned long long)oi->ip_blkno,
 				inode->i_nlink);
 
-	mlog_bug_on_msg(OCFS2_SB(inode->i_sb) == NULL,
+	mlog_bug_on_msg(osb == NULL,
 			"Inode=%lu\n", inode->i_ino);
 
 	dquot_drop(inode);
@@ -1150,7 +1150,7 @@ static void ocfs2_clear_inode(struct ino
 	ocfs2_mark_lockres_freeing(osb, &oi->ip_inode_lockres);
 	ocfs2_mark_lockres_freeing(osb, &oi->ip_open_lockres);
 
-	ocfs2_resv_discard(&OCFS2_SB(inode->i_sb)->osb_la_resmap,
+	ocfs2_resv_discard(&osb->osb_la_resmap,
 			   &oi->ip_la_data_resv);
 	ocfs2_resv_init_once(&oi->ip_la_data_resv);
 
@@ -1223,7 +1223,7 @@ static void ocfs2_clear_inode(struct ino
 	 * the journal is flushed before journal shutdown. Thus it is safe to
 	 * have inodes get cleaned up after journal shutdown.
 	 */
-	jbd2_journal_release_jbd_inode(OCFS2_SB(inode->i_sb)->journal->j_journal,
+	jbd2_journal_release_jbd_inode(osb->journal->j_journal,
 				       &oi->ip_jinode);
 }
 
diff -puN fs/ocfs2/refcounttree.c~ocfs2-use-osb-instead-of-ocfs2_sb fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-use-osb-instead-of-ocfs2_sb
+++ a/fs/ocfs2/refcounttree.c
@@ -3359,7 +3359,7 @@ static int ocfs2_replace_cow(struct ocfs
 	unsigned int ext_flags;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
+	if (!ocfs2_refcount_tree(osb)) {
 		return ocfs2_error(inode->i_sb, "Inode %lu want to use refcount tree, but the feature bit is not set in the super block\n",
 				   inode->i_ino);
 	}
@@ -3707,7 +3707,7 @@ int ocfs2_add_refcount_flag(struct inode
 	trace_ocfs2_add_refcount_flag(ref_blocks, credits);
 
 	if (ref_blocks) {
-		ret = ocfs2_reserve_new_metadata_blocks(OCFS2_SB(inode->i_sb),
+		ret = ocfs2_reserve_new_metadata_blocks(osb,
 							ref_blocks, &meta_ac);
 		if (ret) {
 			mlog_errno(ret);
diff -puN fs/ocfs2/suballoc.c~ocfs2-use-osb-instead-of-ocfs2_sb fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-use-osb-instead-of-ocfs2_sb
+++ a/fs/ocfs2/suballoc.c
@@ -387,7 +387,7 @@ static int ocfs2_block_group_fill(handle
 
 	memset(bg, 0, sb->s_blocksize);
 	strcpy(bg->bg_signature, OCFS2_GROUP_DESC_SIGNATURE);
-	bg->bg_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
+	bg->bg_generation = cpu_to_le32(osb->fs_generation);
 	bg->bg_size = cpu_to_le16(ocfs2_group_bitmap_size(sb, 1,
 						osb->s_feature_incompat));
 	bg->bg_chain = cpu_to_le16(my_chain);
@@ -1521,7 +1521,7 @@ static int ocfs2_cluster_group_search(st
 				OCFS2_I(inode)->ip_clusters, max_bits);
 		}
 
-		ret = ocfs2_block_group_find_clear_bits(OCFS2_SB(inode->i_sb),
+		ret = ocfs2_block_group_find_clear_bits(osb,
 							group_bh, bits_wanted,
 							max_bits, res);
 		if (ret)
diff -puN fs/ocfs2/super.c~ocfs2-use-osb-instead-of-ocfs2_sb fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-use-osb-instead-of-ocfs2_sb
+++ a/fs/ocfs2/super.c
@@ -423,10 +423,10 @@ static int ocfs2_sync_fs(struct super_bl
 		ocfs2_schedule_truncate_log_flush(osb, 0);
 	}
 
-	if (jbd2_journal_start_commit(OCFS2_SB(sb)->journal->j_journal,
+	if (jbd2_journal_start_commit(osb->journal->j_journal,
 				      &target)) {
 		if (wait)
-			jbd2_log_wait_commit(OCFS2_SB(sb)->journal->j_journal,
+			jbd2_log_wait_commit(osb->journal->j_journal,
 					     target);
 	}
 	return 0;
diff -puN fs/ocfs2/xattr.c~ocfs2-use-osb-instead-of-ocfs2_sb fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-use-osb-instead-of-ocfs2_sb
+++ a/fs/ocfs2/xattr.c
@@ -3564,7 +3564,7 @@ int ocfs2_xattr_set(struct inode *inode,
 		.not_found = -ENODATA,
 	};
 
-	if (!ocfs2_supports_xattr(OCFS2_SB(inode->i_sb)))
+	if (!ocfs2_supports_xattr(osb))
 		return -EOPNOTSUPP;
 
 	/*
_

Patches currently in -mm which might be from piaojun@huawei.com are

ocfs2-use-osb-instead-of-ocfs2_sb.patch


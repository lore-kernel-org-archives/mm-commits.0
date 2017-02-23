From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-deadlock-issue-when-taking-inode-lock-at-vfs-entry-points.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:11:56 -0800
Message-ID: <58af501c.VoYG4IyUeksxBGbu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39180 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdBWVMM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:12:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zren@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix deadlock issue when taking inode lock at vfs entry points
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-deadlock-issue-when-taking-inode-lock-at-vfs-entry-points.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Ren <zren@suse.com>
Subject: ocfs2: fix deadlock issue when taking inode lock at vfs entry points

Commit 743b5f1434f5 ("ocfs2: take inode lock in ocfs2_iop_set/get_acl()")
results in a deadlock, as the author "Tariq Saeed" realized shortly after
the patch was merged.  The discussion happened here
(https://oss.oracle.com/pipermail/ocfs2-devel/2015-September/011085.html).

The reason why taking cluster inode lock at vfs entry points opens up a
self deadlock window, is explained in the previous patch of this series.

So far, we have seen two different code paths that have this issue.
1. do_sys_open
     may_open
      inode_permission
       ocfs2_permission
        ocfs2_inode_lock() <=== take PR
         generic_permission
          get_acl
           ocfs2_iop_get_acl
            ocfs2_inode_lock() <=== take PR
2. fchmod|fchmodat
    chmod_common
     notify_change
      ocfs2_setattr <=== take EX
       posix_acl_chmod
        get_acl
         ocfs2_iop_get_acl <=== take PR
        ocfs2_iop_set_acl <=== take EX

Fixes them by adding the tracking logic (in the previous patch) for these
funcs above, ocfs2_permission(), ocfs2_iop_[set|get]_acl(),
ocfs2_setattr().

Link: http://lkml.kernel.org/r/20170117100948.11657-3-zren@suse.com
Signed-off-by: Eric Ren <zren@suse.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/acl.c  |   29 ++++++++++-------------
 fs/ocfs2/file.c |   58 +++++++++++++++++++++++++++++++++++-----------
 2 files changed, 58 insertions(+), 29 deletions(-)

diff -puN fs/ocfs2/acl.c~ocfs2-fix-deadlock-issue-when-taking-inode-lock-at-vfs-entry-points fs/ocfs2/acl.c
--- a/fs/ocfs2/acl.c~ocfs2-fix-deadlock-issue-when-taking-inode-lock-at-vfs-entry-points
+++ a/fs/ocfs2/acl.c
@@ -283,16 +283,14 @@ int ocfs2_set_acl(handle_t *handle,
 int ocfs2_iop_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	struct buffer_head *bh = NULL;
-	int status = 0;
+	int status, had_lock;
+	struct ocfs2_lock_holder oh;
 
-	status = ocfs2_inode_lock(inode, &bh, 1);
-	if (status < 0) {
-		if (status != -ENOENT)
-			mlog_errno(status);
-		return status;
-	}
+	had_lock = ocfs2_inode_lock_tracker(inode, &bh, 1, &oh);
+	if (had_lock < 0)
+		return had_lock;
 	status = ocfs2_set_acl(NULL, inode, bh, type, acl, NULL, NULL);
-	ocfs2_inode_unlock(inode, 1);
+	ocfs2_inode_unlock_tracker(inode, 1, &oh, had_lock);
 	brelse(bh);
 	return status;
 }
@@ -302,21 +300,20 @@ struct posix_acl *ocfs2_iop_get_acl(stru
 	struct ocfs2_super *osb;
 	struct buffer_head *di_bh = NULL;
 	struct posix_acl *acl;
-	int ret;
+	int had_lock;
+	struct ocfs2_lock_holder oh;
 
 	osb = OCFS2_SB(inode->i_sb);
 	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
 		return NULL;
-	ret = ocfs2_inode_lock(inode, &di_bh, 0);
-	if (ret < 0) {
-		if (ret != -ENOENT)
-			mlog_errno(ret);
-		return ERR_PTR(ret);
-	}
+
+	had_lock = ocfs2_inode_lock_tracker(inode, &di_bh, 0, &oh);
+	if (had_lock < 0)
+		return ERR_PTR(had_lock);
 
 	acl = ocfs2_get_acl_nolock(inode, type, di_bh);
 
-	ocfs2_inode_unlock(inode, 0);
+	ocfs2_inode_unlock_tracker(inode, 0, &oh, had_lock);
 	brelse(di_bh);
 	return acl;
 }
diff -puN fs/ocfs2/file.c~ocfs2-fix-deadlock-issue-when-taking-inode-lock-at-vfs-entry-points fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-deadlock-issue-when-taking-inode-lock-at-vfs-entry-points
+++ a/fs/ocfs2/file.c
@@ -1138,6 +1138,8 @@ int ocfs2_setattr(struct dentry *dentry,
 	handle_t *handle = NULL;
 	struct dquot *transfer_to[MAXQUOTAS] = { };
 	int qtype;
+	int had_lock;
+	struct ocfs2_lock_holder oh;
 
 	trace_ocfs2_setattr(inode, dentry,
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -1173,11 +1175,30 @@ int ocfs2_setattr(struct dentry *dentry,
 		}
 	}
 
-	status = ocfs2_inode_lock(inode, &bh, 1);
-	if (status < 0) {
-		if (status != -ENOENT)
-			mlog_errno(status);
+	had_lock = ocfs2_inode_lock_tracker(inode, &bh, 1, &oh);
+	if (had_lock < 0) {
+		status = had_lock;
 		goto bail_unlock_rw;
+	} else if (had_lock) {
+		/*
+		 * As far as we know, ocfs2_setattr() could only be the first
+		 * VFS entry point in the call chain of recursive cluster
+		 * locking issue.
+		 *
+		 * For instance:
+		 * chmod_common()
+		 *  notify_change()
+		 *   ocfs2_setattr()
+		 *    posix_acl_chmod()
+		 *     ocfs2_iop_get_acl()
+		 *
+		 * But, we're not 100% sure if it's always true, because the
+		 * ordering of the VFS entry points in the call chain is out
+		 * of our control. So, we'd better dump the stack here to
+		 * catch the other cases of recursive locking.
+		 */
+		mlog(ML_ERROR, "Another case of recursive locking:\n");
+		dump_stack();
 	}
 	inode_locked = 1;
 
@@ -1260,8 +1281,8 @@ int ocfs2_setattr(struct dentry *dentry,
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
 bail_unlock:
-	if (status) {
-		ocfs2_inode_unlock(inode, 1);
+	if (status && inode_locked) {
+		ocfs2_inode_unlock_tracker(inode, 1, &oh, had_lock);
 		inode_locked = 0;
 	}
 bail_unlock_rw:
@@ -1279,7 +1300,7 @@ bail:
 			mlog_errno(status);
 	}
 	if (inode_locked)
-		ocfs2_inode_unlock(inode, 1);
+		ocfs2_inode_unlock_tracker(inode, 1, &oh, had_lock);
 
 	brelse(bh);
 	return status;
@@ -1320,21 +1341,32 @@ bail:
 
 int ocfs2_permission(struct inode *inode, int mask)
 {
-	int ret;
+	int ret, had_lock;
+	struct ocfs2_lock_holder oh;
 
 	if (mask & MAY_NOT_BLOCK)
 		return -ECHILD;
 
-	ret = ocfs2_inode_lock(inode, NULL, 0);
-	if (ret) {
-		if (ret != -ENOENT)
-			mlog_errno(ret);
+	had_lock = ocfs2_inode_lock_tracker(inode, NULL, 0, &oh);
+	if (had_lock < 0) {
+		ret = had_lock;
 		goto out;
+	} else if (had_lock) {
+		/* See comments in ocfs2_setattr() for details.
+		 * The call chain of this case could be:
+		 * do_sys_open()
+		 *  may_open()
+		 *   inode_permission()
+		 *    ocfs2_permission()
+		 *     ocfs2_iop_get_acl()
+		 */
+		mlog(ML_ERROR, "Another case of recursive locking:\n");
+		dump_stack();
 	}
 
 	ret = generic_permission(inode, mask);
 
-	ocfs2_inode_unlock(inode, 0);
+	ocfs2_inode_unlock_tracker(inode, 0, &oh, had_lock);
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from zren@suse.com are



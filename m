From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-deadlocks-when-taking-inode-lock-at-vfs-entry-points.patch added
 to -mm tree
Date: Thu, 05 Jan 2017 15:01:47 -0800
Message-ID: <586ed05b.lOdcS++YpLwubQa5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50374 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763737AbdAEXMD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 18:12:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zren@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix deadlocks when taking inode lock at vfs entry points
has been added to the -mm tree.  Its filename is
     ocfs2-fix-deadlocks-when-taking-inode-lock-at-vfs-entry-points.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-deadlocks-when-taking-inode-lock-at-vfs-entry-points.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-deadlocks-when-taking-inode-lock-at-vfs-entry-points.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Ren <zren@suse.com>
Subject: ocfs2: fix deadlocks when taking inode lock at vfs entry points

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

Link: http://lkml.kernel.org/r/1483630262-22227-3-git-send-email-zren@suse.com
Signed-off-by: Eric Ren <zren@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/acl.c  |   39 ++++++++++++++++++++++++++++++++++-----
 fs/ocfs2/file.c |   44 ++++++++++++++++++++++++++++++++++----------
 2 files changed, 68 insertions(+), 15 deletions(-)

diff -puN fs/ocfs2/acl.c~ocfs2-fix-deadlocks-when-taking-inode-lock-at-vfs-entry-points fs/ocfs2/acl.c
--- a/fs/ocfs2/acl.c~ocfs2-fix-deadlocks-when-taking-inode-lock-at-vfs-entry-points
+++ a/fs/ocfs2/acl.c
@@ -284,16 +284,31 @@ int ocfs2_iop_set_acl(struct inode *inod
 {
 	struct buffer_head *bh = NULL;
 	int status = 0;
-
-	status = ocfs2_inode_lock(inode, &bh, 1);
+	int arg_flags = 0, has_locked;
+	struct ocfs2_holder oh;
+	struct ocfs2_lock_res *lockres;
+
+	lockres = &OCFS2_I(inode)->ip_inode_lockres;
+	has_locked = (ocfs2_is_locked_by_me(lockres) != NULL);
+	if (has_locked)
+		arg_flags = OCFS2_META_LOCK_GETBH;
+	status = ocfs2_inode_lock_full(inode, &bh, 1, arg_flags);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
 		return status;
 	}
+	if (!has_locked)
+		ocfs2_add_holder(lockres, &oh);
+
 	status = ocfs2_set_acl(NULL, inode, bh, type, acl, NULL, NULL);
-	ocfs2_inode_unlock(inode, 1);
+
+	if (!has_locked) {
+		ocfs2_remove_holder(lockres, &oh);
+		ocfs2_inode_unlock(inode, 1);
+	}
 	brelse(bh);
+
 	return status;
 }
 
@@ -303,21 +318,35 @@ struct posix_acl *ocfs2_iop_get_acl(stru
 	struct buffer_head *di_bh = NULL;
 	struct posix_acl *acl;
 	int ret;
+	int arg_flags = 0, has_locked;
+	struct ocfs2_holder oh;
+	struct ocfs2_lock_res *lockres;
 
 	osb = OCFS2_SB(inode->i_sb);
 	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
 		return NULL;
-	ret = ocfs2_inode_lock(inode, &di_bh, 0);
+
+	lockres = &OCFS2_I(inode)->ip_inode_lockres;
+	has_locked = (ocfs2_is_locked_by_me(lockres) != NULL);
+	if (has_locked)
+		arg_flags = OCFS2_META_LOCK_GETBH;
+	ret = ocfs2_inode_lock_full(inode, &di_bh, 0, arg_flags);
 	if (ret < 0) {
 		if (ret != -ENOENT)
 			mlog_errno(ret);
 		return ERR_PTR(ret);
 	}
+	if (!has_locked)
+		ocfs2_add_holder(lockres, &oh);
 
 	acl = ocfs2_get_acl_nolock(inode, type, di_bh);
 
-	ocfs2_inode_unlock(inode, 0);
+	if (!has_locked) {
+		ocfs2_remove_holder(lockres, &oh);
+		ocfs2_inode_unlock(inode, 0);
+	}
 	brelse(di_bh);
+
 	return acl;
 }
 
diff -puN fs/ocfs2/file.c~ocfs2-fix-deadlocks-when-taking-inode-lock-at-vfs-entry-points fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-deadlocks-when-taking-inode-lock-at-vfs-entry-points
+++ a/fs/ocfs2/file.c
@@ -1138,6 +1138,9 @@ int ocfs2_setattr(struct dentry *dentry,
 	handle_t *handle = NULL;
 	struct dquot *transfer_to[MAXQUOTAS] = { };
 	int qtype;
+	int arg_flags = 0, had_lock;
+	struct ocfs2_holder oh;
+	struct ocfs2_lock_res *lockres;
 
 	trace_ocfs2_setattr(inode, dentry,
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -1173,13 +1176,20 @@ int ocfs2_setattr(struct dentry *dentry,
 		}
 	}
 
-	status = ocfs2_inode_lock(inode, &bh, 1);
+	lockres = &OCFS2_I(inode)->ip_inode_lockres;
+	had_lock = (ocfs2_is_locked_by_me(lockres) != NULL);
+	if (had_lock)
+		arg_flags = OCFS2_META_LOCK_GETBH;
+	status = ocfs2_inode_lock_full(inode, &bh, 1, arg_flags);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
 		goto bail_unlock_rw;
 	}
-	inode_locked = 1;
+	if (!had_lock) {
+		ocfs2_add_holder(lockres, &oh);
+		inode_locked = 1;
+	}
 
 	if (size_change) {
 		status = inode_newsize_ok(inode, attr->ia_size);
@@ -1260,7 +1270,8 @@ int ocfs2_setattr(struct dentry *dentry,
 bail_commit:
 	ocfs2_commit_trans(osb, handle);
 bail_unlock:
-	if (status) {
+	if (status && inode_locked) {
+		ocfs2_remove_holder(lockres, &oh);
 		ocfs2_inode_unlock(inode, 1);
 		inode_locked = 0;
 	}
@@ -1278,8 +1289,10 @@ bail:
 		if (status < 0)
 			mlog_errno(status);
 	}
-	if (inode_locked)
+	if (inode_locked) {
+		ocfs2_remove_holder(lockres, &oh);
 		ocfs2_inode_unlock(inode, 1);
+	}
 
 	brelse(bh);
 	return status;
@@ -1321,20 +1334,31 @@ bail:
 int ocfs2_permission(struct inode *inode, int mask)
 {
 	int ret;
+	int has_locked;
+	struct ocfs2_holder oh;
+	struct ocfs2_lock_res *lockres;
 
 	if (mask & MAY_NOT_BLOCK)
 		return -ECHILD;
 
-	ret = ocfs2_inode_lock(inode, NULL, 0);
-	if (ret) {
-		if (ret != -ENOENT)
-			mlog_errno(ret);
-		goto out;
+	lockres = &OCFS2_I(inode)->ip_inode_lockres;
+	has_locked = (ocfs2_is_locked_by_me(lockres) != NULL);
+	if (!has_locked) {
+		ret = ocfs2_inode_lock(inode, NULL, 0);
+		if (ret) {
+			if (ret != -ENOENT)
+				mlog_errno(ret);
+			goto out;
+		}
+		ocfs2_add_holder(lockres, &oh);
 	}
 
 	ret = generic_permission(inode, mask);
 
-	ocfs2_inode_unlock(inode, 0);
+	if (!has_locked) {
+		ocfs2_remove_holder(lockres, &oh);
+		ocfs2_inode_unlock(inode, 0);
+	}
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from zren@suse.com are

ocfs2-fix-crash-caused-by-stale-lvb-with-fsdlm-plugin.patch
ocfs2-dlmglue-prepare-tracking-logic-to-avoid-recursive-cluster-lock.patch
ocfs2-fix-deadlocks-when-taking-inode-lock-at-vfs-entry-points.patch


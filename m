From: akpm@linux-foundation.org
Subject: + ocfs2-mknod-fix-recursive-locking-hung.patch added to -mm tree
Date: Wed, 18 Oct 2017 15:18:26 -0700
Message-ID: <59e7d332.MFYSWAjFGg13ERT2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37826 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750920AbdJRWS3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2017 18:18:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, mfasheh@versity.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: mknod: fix recursive locking hung
has been added to the -mm tree.  Its filename is
     ocfs2-mknod-fix-recursive-locking-hung.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-mknod-fix-recursive-locking-hung.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-mknod-fix-recursive-locking-hung.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: mknod: fix recursive locking hung

Here another recursive lock caught and it caused a cluster hung.

 #0 [ffff88008e3935a8] __schedule at ffffffff816e4722
 #1 [ffff88008e393600] schedule at ffffffff816e4dee
 #2 [ffff88008e393620] schedule_timeout at ffffffff816e7cd5
 #3 [ffff88008e3936c0] wait_for_completion at ffffffff816e631f
 #4 [ffff88008e393740] __ocfs2_cluster_lock at ffffffffa05a9111 [ocfs2]
 #5 [ffff88008e393890] ocfs2_inode_lock_full_nested at ffffffffa05aec14 [ocfs2]
 #6 [ffff88008e393910] ocfs2_inode_lock_tracker at ffffffffa05af02f [ocfs2]
 #7 [ffff88008e393970] ocfs2_iop_get_acl at ffffffffa0620c92 [ocfs2]
 #8 [ffff88008e3939d0] get_acl at ffffffff8126ae79
 #9 [ffff88008e3939f0] posix_acl_create at ffffffff8126b27a
 #10 [ffff88008e393a20] ocfs2_mknod at ffffffffa05cedcc [ocfs2]
 #11 [ffff88008e393b60] ocfs2_create at ffffffffa05cfb13 [ocfs2]
 #12 [ffff88008e393bd0] vfs_create at ffffffff81217338
 #13 [ffff88008e393c10] lookup_open at ffffffff81217a85
 #14 [ffff88008e393ca0] do_last at ffffffff8121ac6d
 #15 [ffff88008e393d30] path_openat at ffffffff8121b112
 #16 [ffff88008e393df0] do_filp_open at ffffffff8121b53a
 #17 [ffff88008e393ed0] do_sys_open at ffffffff81209a5a
 #18 [ffff88008e393f40] sys_open at ffffffff81209bae
 #19 [ffff88008e393f50] system_call_fastpath at ffffffff816e902e

inode lock is got by ocfs2_mknod() before call into posix_acl_create().

Link: http://lkml.kernel.org/r/1508300302-5155-1-git-send-email-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Gang He <ghe@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-mknod-fix-recursive-locking-hung fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-mknod-fix-recursive-locking-hung
+++ a/fs/ocfs2/namei.c
@@ -260,6 +260,8 @@ static int ocfs2_mknod(struct inode *dir
 	sigset_t oldset;
 	int did_block_signals = 0;
 	struct ocfs2_dentry_lock *dl = NULL;
+	int locked;
+	struct ocfs2_lock_holder oh;
 
 	trace_ocfs2_mknod(dir, dentry, dentry->d_name.len, dentry->d_name.name,
 			  (unsigned long long)OCFS2_I(dir)->ip_blkno,
@@ -274,11 +276,11 @@ static int ocfs2_mknod(struct inode *dir
 	/* get our super block */
 	osb = OCFS2_SB(dir->i_sb);
 
-	status = ocfs2_inode_lock(dir, &parent_fe_bh, 1);
-	if (status < 0) {
-		if (status != -ENOENT)
-			mlog_errno(status);
-		return status;
+	locked = ocfs2_inode_lock_tracker(dir, &parent_fe_bh, 1, &oh);
+	if (locked < 0) {
+		if (locked != -ENOENT)
+			mlog_errno(locked);
+		return locked;
 	}
 
 	if (S_ISDIR(mode) && (dir->i_nlink >= ocfs2_link_max(osb))) {
@@ -462,7 +464,7 @@ leave:
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
 
-	ocfs2_inode_unlock(dir, 1);
+	ocfs2_inode_unlock_tracker(dir, 1, &oh, locked);
 	if (did_block_signals)
 		ocfs2_unblock_signals(&oldset);
 
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-mknod-fix-recursive-locking-hung.patch


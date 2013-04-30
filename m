From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-error-handling-in-ocfs2_ioctl_move_extents.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:06 -0700
Message-ID: <20130430184406.82AF45A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:57013 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab3D3SoH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:07 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so84625vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, jeff.liu@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix error handling in ocfs2_ioctl_move_extents()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-error-handling-in-ocfs2_ioctl_move_extents.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: fix error handling in ocfs2_ioctl_move_extents()

Smatch complains that if we hit an error (for example if the file is
immutable) then "range" has uninitialized stack data and we copy it to the
user.

I've re-written the error handling to avoid this problem and make it a
little cleaner as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff -puN fs/ocfs2/move_extents.c~ocfs2-fix-error-handling-in-ocfs2_ioctl_move_extents fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~ocfs2-fix-error-handling-in-ocfs2_ioctl_move_extents
+++ a/fs/ocfs2/move_extents.c
@@ -1057,42 +1057,40 @@ int ocfs2_ioctl_move_extents(struct file
 
 	struct inode *inode = file_inode(filp);
 	struct ocfs2_move_extents range;
-	struct ocfs2_move_extents_context *context = NULL;
+	struct ocfs2_move_extents_context *context;
+
+	if (!argp)
+		return -EINVAL;
 
 	status = mnt_want_write_file(filp);
 	if (status)
 		return status;
 
 	if ((!S_ISREG(inode->i_mode)) || !(filp->f_mode & FMODE_WRITE))
-		goto out;
+		goto out_drop;
 
 	if (inode->i_flags & (S_IMMUTABLE|S_APPEND)) {
 		status = -EPERM;
-		goto out;
+		goto out_drop;
 	}
 
 	context = kzalloc(sizeof(struct ocfs2_move_extents_context), GFP_NOFS);
 	if (!context) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto out;
+		goto out_drop;
 	}
 
 	context->inode = inode;
 	context->file = filp;
 
-	if (argp) {
-		if (copy_from_user(&range, argp, sizeof(range))) {
-			status = -EFAULT;
-			goto out;
-		}
-	} else {
-		status = -EINVAL;
-		goto out;
+	if (copy_from_user(&range, argp, sizeof(range))) {
+		status = -EFAULT;
+		goto out_free;
 	}
 
 	if (range.me_start > i_size_read(inode))
-		goto out;
+		goto out_free;
 
 	if (range.me_start + range.me_len > i_size_read(inode))
 			range.me_len = i_size_read(inode) - range.me_start;
@@ -1124,25 +1122,24 @@ int ocfs2_ioctl_move_extents(struct file
 
 		status = ocfs2_validate_and_adjust_move_goal(inode, &range);
 		if (status)
-			goto out;
+			goto out_copy;
 	}
 
 	status = ocfs2_move_extents(context);
 	if (status)
 		mlog_errno(status);
-out:
+out_copy:
 	/*
 	 * movement/defragmentation may end up being partially completed,
 	 * that's the reason why we need to return userspace the finished
 	 * length and new_offset even if failure happens somewhere.
 	 */
-	if (argp) {
-		if (copy_to_user(argp, &range, sizeof(range)))
-			status = -EFAULT;
-	}
+	if (copy_to_user(argp, &range, sizeof(range)))
+		status = -EFAULT;
 
+out_free:
 	kfree(context);

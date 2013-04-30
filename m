From: akpm@linux-foundation.org
Subject: [merged] ocfs2-delay-inode-update-transactions-after-verifying-the-input-flags.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:00 -0700
Message-ID: <20130430184400.7DBA531C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:43210 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab3D3SoB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:01 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so84533vcb.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff.liu@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: delay inode update transactions after verifying the input flags
has been removed from the -mm tree.  Its filename was
     ocfs2-delay-inode-update-transactions-after-verifying-the-input-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Liu <jeff.liu@oracle.com>
Subject: ocfs2: delay inode update transactions after verifying the input flags

There is no need to start the inode update transactions before/while
verifying the input flags.  As a refinement, this patch delay the
transactions utill the pre-check up is ok.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ioctl.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/ocfs2/ioctl.c~ocfs2-delay-inode-update-transactions-after-verifying-the-input-flags fs/ocfs2/ioctl.c
--- a/fs/ocfs2/ioctl.c~ocfs2-delay-inode-update-transactions-after-verifying-the-input-flags
+++ a/fs/ocfs2/ioctl.c
@@ -101,13 +101,6 @@ static int ocfs2_set_inode_attr(struct i
 	if (!S_ISDIR(inode->i_mode))
 		flags &= ~OCFS2_DIRSYNC_FL;
 
-	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (IS_ERR(handle)) {
-		status = PTR_ERR(handle);
-		mlog_errno(status);
-		goto bail_unlock;
-	}
-
 	oldflags = ocfs2_inode->ip_attr;
 	flags = flags & mask;
 	flags |= oldflags & ~mask;
@@ -120,7 +113,14 @@ static int ocfs2_set_inode_attr(struct i
 	if ((oldflags & OCFS2_IMMUTABLE_FL) || ((flags ^ oldflags) &
 		(OCFS2_APPEND_FL | OCFS2_IMMUTABLE_FL))) {
 		if (!capable(CAP_LINUX_IMMUTABLE))
-			goto bail_commit;
+			goto bail_unlock;
+	}
+
+	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		mlog_errno(status);
+		goto bail_unlock;
 	}
 
 	ocfs2_inode->ip_attr = flags;
@@ -130,8 +130,8 @@ static int ocfs2_set_inode_attr(struct i
 	if (status < 0)
 		mlog_errno(status);
 
-bail_commit:
 	ocfs2_commit_trans(osb, handle);
+
 bail_unlock:
 	ocfs2_inode_unlock(inode, 1);
 bail:
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

origin.patch
linux-next.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch


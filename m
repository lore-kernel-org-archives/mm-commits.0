From: akpm@linux-foundation.org
Subject: + ocfs2-delay-inode-update-transactions-after-verifying-the-input-flags.patch added to -mm tree
Date: Mon, 11 Mar 2013 15:17:13 -0700
Message-ID: <20130311221713.768615A42C2@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:43116 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab3CKWRO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 18:17:14 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so435804ghb.5
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 15:17:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff.liu@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: ocfs2: delay inode update transactions after verifying the input flags
has been added to the -mm tree.  Its filename is
     ocfs2-delay-inode-update-transactions-after-verifying-the-input-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-delay-inode-update-transactions-after-verifying-the-input-flags.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch


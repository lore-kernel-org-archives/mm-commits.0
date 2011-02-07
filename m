From: akpm@linux-foundation.org
Subject: + fs-devpts_pty_new-return-enomem-if-dentry-allocation-failed.patch added to -mm tree
Date: Mon, 07 Feb 2011 15:05:51 -0800
Message-ID: <201102072305.p17N5pcP001000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755130Ab1BGXGC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2011 18:06:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avagin@openvz.org, bfields@fieldses.org, tj@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     fs: devpts_pty_new() return -ENOMEM if dentry allocation failed
has been added to the -mm tree.  Its filename is
     fs-devpts_pty_new-return-enomem-if-dentry-allocation-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: devpts_pty_new() return -ENOMEM if dentry allocation failed
From: Andrey Vagin <avagin@openvz.org>

In this case nobody can open a slave point, so will be better return from
devpts_pty_new()

Now we should not check error code from d_find_alias() in
devpts_pty_kill(), because the dentry exists all times.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN fs/devpts/inode.c~fs-devpts_pty_new-return-enomem-if-dentry-allocation-failed fs/devpts/inode.c
--- a/fs/devpts/inode.c~fs-devpts_pty_new-return-enomem-if-dentry-allocation-failed
+++ a/fs/devpts/inode.c
@@ -479,6 +479,7 @@ int devpts_pty_new(struct inode *ptmx_in
 	struct dentry *root = sb->s_root;
 	struct pts_fs_info *fsi = DEVPTS_SB(sb);
 	struct pts_mount_opts *opts = &fsi->mount_opts;
+	int ret = 0;
 	char s[12];
 
 	/* We're supposed to be given the slave end of a pty */
@@ -504,11 +505,14 @@ int devpts_pty_new(struct inode *ptmx_in
 	if (dentry) {
 		d_add(dentry, inode);
 		fsnotify_create(root->d_inode, dentry);
+	} else {
+		iput(inode);
+		ret = -ENOMEM;
 	}
 
 	mutex_unlock(&root->d_inode->i_mutex);
 
-	return 0;
+	return ret;
 }
 
 struct tty_struct *devpts_get_tty(struct inode *pts_inode, int number)
@@ -544,17 +548,12 @@ void devpts_pty_kill(struct tty_struct *
 	mutex_lock(&root->d_inode->i_mutex);
 
 	dentry = d_find_alias(inode);
-	if (IS_ERR(dentry))
-		goto out;

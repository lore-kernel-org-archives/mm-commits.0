From: akpm@linux-foundation.org
Subject: [merged] fs-devpts_pty_new-return-enomem-if-dentry-allocation-failed.patch removed from -mm tree
Date: Mon, 21 Mar 2011 12:16:44 -0700
Message-ID: <201103211919.p2LJJwH1020245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468Ab1CUTUl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Mar 2011 15:20:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, bfields@fieldses.org, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: devpts_pty_new() return -ENOMEM if dentry allocation failed
has been removed from the -mm tree.  Its filename was
     fs-devpts_pty_new-return-enomem-if-dentry-allocation-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
-
-	if (dentry) {
-		inode->i_nlink--;
-		d_delete(dentry);
-		dput(dentry);	/* d_alloc_name() in devpts_pty_new() */
-	}
 
+	inode->i_nlink--;
+	d_delete(dentry);
+	dput(dentry);	/* d_alloc_name() in devpts_pty_new() */
 	dput(dentry);		/* d_find_alias above */
-out:
+
 	mutex_unlock(&root->d_inode->i_mutex);
 }
 
_

Patches currently in -mm which might be from avagin@openvz.org are

origin.patch
oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch
oom-skip-zombies-when-iterating-tasklist.patch
oom-avoid-deferring-oom-killer-if-exiting-task-is-being-traced.patch
fs-devpts-inodec-correctly-check-d_alloc_name-return-code-in-devpts_pty_new.patch


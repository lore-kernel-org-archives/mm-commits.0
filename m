From: akpm@linux-foundation.org
Subject: - anon-inodes-use-open-coded-atomic_inc-for-the-shared-inode.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:28 -0700
Message-ID: <200710180701.l9I71SHM031179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49188 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbXJRHTn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:19:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, yanzheng@21cn.com, mm-commits@vger.kernel.org


The patch titled
     anon-inodes use open coded atomic_inc for the shared inode
has been removed from the -mm tree.  Its filename was
     anon-inodes-use-open-coded-atomic_inc-for-the-shared-inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: anon-inodes use open coded atomic_inc for the shared inode
From: Davide Libenzi <davidel@xmailserver.org>

Since we know the shared inode count is always >0, we can avoid igrab()
and use an open coded atomic_inc().

This also fixes a bug noticed by Yan Zheng <yanzheng@21cn.com>: were checking
for an IS_ERR() return from igrab(), but it actually returns NULL on error.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Yan Zheng <yanzheng@21cn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/anon_inodes.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN fs/anon_inodes.c~anon-inodes-use-open-coded-atomic_inc-for-the-shared-inode fs/anon_inodes.c
--- a/fs/anon_inodes.c~anon-inodes-use-open-coded-atomic_inc-for-the-shared-inode
+++ a/fs/anon_inodes.c
@@ -76,7 +76,6 @@ int anon_inode_getfd(int *pfd, struct in
 {
 	struct qstr this;
 	struct dentry *dentry;
-	struct inode *inode;
 	struct file *file;
 	int error, fd;
 
@@ -86,15 +85,9 @@ int anon_inode_getfd(int *pfd, struct in
 	if (!file)
 		return -ENFILE;
 
-	inode = igrab(anon_inode_inode);
-	if (IS_ERR(inode)) {
-		error = PTR_ERR(inode);
-		goto err_put_filp;
-	}
-
 	error = get_unused_fd();
 	if (error < 0)
-		goto err_iput;
+		goto err_put_filp;
 	fd = error;
 
 	/*
@@ -108,14 +101,22 @@ int anon_inode_getfd(int *pfd, struct in
 	dentry = d_alloc(anon_inode_mnt->mnt_sb->s_root, &this);
 	if (!dentry)
 		goto err_put_unused_fd;
+
+	/*
+	 * We know the anon_inode inode count is always greater than zero,
+	 * so we can avoid doing an igrab() and we can use an open-coded
+	 * atomic_inc().
+	 */
+	atomic_inc(&anon_inode_inode->i_count);
+
 	dentry->d_op = &anon_inodefs_dentry_operations;
 	/* Do not publish this dentry inside the global dentry hash table */
 	dentry->d_flags &= ~DCACHE_UNHASHED;
-	d_instantiate(dentry, inode);
+	d_instantiate(dentry, anon_inode_inode);
 
 	file->f_path.mnt = mntget(anon_inode_mnt);
 	file->f_path.dentry = dentry;
-	file->f_mapping = inode->i_mapping;
+	file->f_mapping = anon_inode_inode->i_mapping;
 
 	file->f_pos = 0;
 	file->f_flags = O_RDWR;
@@ -127,14 +128,12 @@ int anon_inode_getfd(int *pfd, struct in
 	fd_install(fd, file);
 
 	*pfd = fd;
-	*pinode = inode;
+	*pinode = anon_inode_inode;
 	*pfile = file;
 	return 0;
 
 err_put_unused_fd:
 	put_unused_fd(fd);
-err_iput:
-	iput(inode);
 err_put_filp:
 	put_filp(file);
 	return error;
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
git-kvm.patch
sparse-pointer-use-of-zero-as-null.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch

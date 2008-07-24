From: akpm@linux-foundation.org
Subject: - autofs4-cleanup-redundant-readir-code.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:39 -0700
Message-ID: <200807242329.m6ONTdHS011397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756406AbYGXXaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     autofs4: cleanup redundant readir code
has been removed from the -mm tree.  Its filename was
     autofs4-cleanup-redundant-readir-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: cleanup redundant readir code
From: Ian Kent <raven@themaw.net>

The mount triggering functionality of readdir and related functions is no
longer used (and is quite broken as well).  The unused portions have been
removed.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |  149 ++++----------------------------------------
 1 file changed, 16 insertions(+), 133 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-cleanup-redundant-readir-code fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-cleanup-redundant-readir-code
+++ a/fs/autofs4/root.c
@@ -25,8 +25,6 @@ static int autofs4_dir_rmdir(struct inod
 static int autofs4_dir_mkdir(struct inode *,struct dentry *,int);
 static int autofs4_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
 static int autofs4_dir_open(struct inode *inode, struct file *file);
-static int autofs4_dir_close(struct inode *inode, struct file *file);
-static int autofs4_dir_readdir(struct file * filp, void * dirent, filldir_t filldir);
 static int autofs4_root_readdir(struct file * filp, void * dirent, filldir_t filldir);
 static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
 static void *autofs4_follow_link(struct dentry *, struct nameidata *);
@@ -44,9 +42,9 @@ const struct file_operations autofs4_roo
 
 const struct file_operations autofs4_dir_operations = {
 	.open		= autofs4_dir_open,
-	.release	= autofs4_dir_close,
+	.release	= dcache_dir_close,
 	.read		= generic_read_dir,
-	.readdir	= autofs4_dir_readdir,
+	.readdir	= dcache_readdir,
 };
 
 const struct inode_operations autofs4_indirect_root_inode_operations = {
@@ -98,17 +96,7 @@ static int autofs4_root_readdir(struct f
 static int autofs4_dir_open(struct inode *inode, struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
-	struct vfsmount *mnt = file->f_path.mnt;
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct dentry *cursor;
-	int status;
-
-	status = dcache_dir_open(inode, file);
-	if (status)
-		goto out;
-
-	cursor = file->private_data;
-	cursor->d_fsdata = NULL;
 
 	DPRINTK("file=%p dentry=%p %.*s",
 		file, dentry, dentry->d_name.len, dentry->d_name.name);
@@ -116,129 +104,24 @@ static int autofs4_dir_open(struct inode
 	if (autofs4_oz_mode(sbi))
 		goto out;
 
-	if (autofs4_ispending(dentry)) {
-		DPRINTK("dentry busy");
-		dcache_dir_close(inode, file);
-		status = -EBUSY;
-		goto out;
-	}
-
-	status = -ENOENT;
-	if (!d_mountpoint(dentry) && dentry->d_op && dentry->d_op->d_revalidate) {
-		struct nameidata nd;
-		int empty, ret;
-
-		/* In case there are stale directory dentrys from a failed mount */
-		spin_lock(&dcache_lock);
-		empty = list_empty(&dentry->d_subdirs);
+	/*
+	 * An empty directory in an autofs file system is always a
+	 * mount point. The daemon must have failed to mount this
+	 * during lookup so it doesn't exist. This can happen, for
+	 * example, if user space returns an incorrect status for a
+	 * mount request. Otherwise we're doing a readdir on the
+	 * autofs file system so just let the libfs routines handle
+	 * it.
+	 */
+	spin_lock(&dcache_lock);
+	if (!d_mountpoint(dentry) && __simple_empty(dentry)) {
 		spin_unlock(&dcache_lock);
-
-		if (!empty)
-			d_invalidate(dentry);
-
-		nd.flags = LOOKUP_DIRECTORY;
-		ret = (dentry->d_op->d_revalidate)(dentry, &nd);
-
-		if (ret <= 0) {
-			if (ret < 0)
-				status = ret;
-			dcache_dir_close(inode, file);
-			goto out;
-		}
-	}
-
-	if (d_mountpoint(dentry)) {
-		struct file *fp = NULL;
-		struct path fp_path = { .dentry = dentry, .mnt = mnt };
-
-		path_get(&fp_path);
-
-		if (!autofs4_follow_mount(&fp_path.mnt, &fp_path.dentry)) {
-			path_put(&fp_path);
-			dcache_dir_close(inode, file);
-			goto out;
-		}
-
-		fp = dentry_open(fp_path.dentry, fp_path.mnt, file->f_flags);
-		status = PTR_ERR(fp);
-		if (IS_ERR(fp)) {
-			dcache_dir_close(inode, file);
-			goto out;
-		}
-		cursor->d_fsdata = fp;
-	}
-	return 0;
-out:
-	return status;
-}
-
-static int autofs4_dir_close(struct inode *inode, struct file *file)
-{
-	struct dentry *dentry = file->f_path.dentry;
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct dentry *cursor = file->private_data;
-	int status = 0;
-
-	DPRINTK("file=%p dentry=%p %.*s",
-		file, dentry, dentry->d_name.len, dentry->d_name.name);
-
-	if (autofs4_oz_mode(sbi))
-		goto out;
-
-	if (autofs4_ispending(dentry)) {
-		DPRINTK("dentry busy");
-		status = -EBUSY;
-		goto out;
-	}
-
-	if (d_mountpoint(dentry)) {
-		struct file *fp = cursor->d_fsdata;
-		if (!fp) {
-			status = -ENOENT;
-			goto out;
-		}
-		filp_close(fp, current->files);
+		return -ENOENT;
 	}
-out:
-	dcache_dir_close(inode, file);
-	return status;
-}
-
-static int autofs4_dir_readdir(struct file *file, void *dirent, filldir_t filldir)
-{
-	struct dentry *dentry = file->f_path.dentry;
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct dentry *cursor = file->private_data;
-	int status;
-
-	DPRINTK("file=%p dentry=%p %.*s",
-		file, dentry, dentry->d_name.len, dentry->d_name.name);
-
-	if (autofs4_oz_mode(sbi))
-		goto out;
-
-	if (autofs4_ispending(dentry)) {
-		DPRINTK("dentry busy");
-		return -EBUSY;
-	}
-
-	if (d_mountpoint(dentry)) {
-		struct file *fp = cursor->d_fsdata;
-
-		if (!fp)
-			return -ENOENT;

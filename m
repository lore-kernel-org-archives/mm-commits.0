From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:40:52 -0700
Message-ID: <200803261840.m2QIeqFT028710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012AbYCZSql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:46:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@lst.de, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: elevate write count for chmod/chown callers
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: elevate write count for chmod/chown callers
From: Dave Hansen <haveblue@us.ibm.com>

chown/chmod,etc...  don't call permission in the same way that the normal
"open for write" calls do.  They still write to the filesystem, so bump the
write count during these operations.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |   39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff -puN fs/open.c~r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers fs/open.c
--- a/fs/open.c~r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers
+++ a/fs/open.c
@@ -567,12 +567,12 @@ asmlinkage long sys_fchmod(unsigned int 
 
 	audit_inode(NULL, dentry);
 
-	err = -EROFS;
-	if (IS_RDONLY(inode))
+	err = mnt_want_write(file->f_vfsmnt);
+	if (err)
 		goto out_putf;
 	err = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out_putf;
+		goto out_drop_write;
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
@@ -581,6 +581,8 @@ asmlinkage long sys_fchmod(unsigned int 
 	err = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
+out_drop_write:
+	mnt_drop_write(file->f_vfsmnt);
 out_putf:
 	fput(file);
 out:
@@ -600,13 +602,13 @@ asmlinkage long sys_fchmodat(int dfd, co
 		goto out;
 	inode = nd.path.dentry->d_inode;
 
-	error = -EROFS;
-	if (IS_RDONLY(inode))
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
 		goto dput_and_out;
 
 	error = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto dput_and_out;
+		goto out_drop_write;
 
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
@@ -616,6 +618,8 @@ asmlinkage long sys_fchmodat(int dfd, co
 	error = notify_change(nd.path.dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
+out_drop_write:
+	mnt_drop_write(nd.path.mnt);
 dput_and_out:
 	path_put(&nd.path);
 out:
@@ -638,9 +642,6 @@ static int chown_common(struct dentry * 
 		printk(KERN_ERR "chown_common: NULL inode\n");
 		goto out;
 	}
-	error = -EROFS;
-	if (IS_RDONLY(inode))
-		goto out;
 	error = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		goto out;
@@ -671,7 +672,12 @@ asmlinkage long sys_chown(const char __u
 	error = user_path_walk(filename, &nd);
 	if (error)
 		goto out;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_release;
 	error = chown_common(nd.path.dentry, user, group);
+	mnt_drop_write(nd.path.mnt);
+out_release:
 	path_put(&nd.path);
 out:
 	return error;
@@ -691,7 +697,12 @@ asmlinkage long sys_fchownat(int dfd, co
 	error = __user_walk_fd(dfd, filename, follow, &nd);
 	if (error)
 		goto out;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_release;
 	error = chown_common(nd.path.dentry, user, group);
+	mnt_drop_write(nd.path.mnt);
+out_release:
 	path_put(&nd.path);
 out:
 	return error;
@@ -705,7 +716,12 @@ asmlinkage long sys_lchown(const char __
 	error = user_path_walk_link(filename, &nd);
 	if (error)
 		goto out;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_release;
 	error = chown_common(nd.path.dentry, user, group);
+	mnt_drop_write(nd.path.mnt);
+out_release:
 	path_put(&nd.path);
 out:
 	return error;
@@ -722,9 +738,14 @@ asmlinkage long sys_fchown(unsigned int 
 	if (!file)
 		goto out;
 
+	error = mnt_want_write(file->f_vfsmnt);
+	if (error)
+		goto out_fput;
 	dentry = file->f_path.dentry;
 	audit_inode(NULL, dentry);
 	error = chown_common(dentry, user, group);
+	mnt_drop_write(file->f_vfsmnt);
+out_fput:
 	fput(file);
 out:
 	return error;
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

git-vfs.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
mm-make-mem_map-allocation-continuous.patch
vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
kprobes-prevent-probing-of-preempt_schedule.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
reiser4.patch
page-owner-tracking-leak-detector.patch


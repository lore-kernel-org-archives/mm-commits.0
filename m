From: akpm@linux-foundation.org
Subject: - vfs-immutable-inode-checking-cleanup.patch removed from -mm tree
Date: Sat, 31 May 2008 00:42:44 -0700
Message-ID: <200805310742.m4V7gi2n000931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421AbYEaHrL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 31 May 2008 03:47:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, drepper@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: immutable inode checking cleanup
has been removed from the -mm tree.  Its filename was
     vfs-immutable-inode-checking-cleanup.patch

This patch was dropped because it's more controversial than was first thought, and it was sent off-list

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: immutable inode checking cleanup
From: Miklos Szeredi <mszeredi@suse.cz>

Move the immutable and append-only checks from chmod, chown and utimes
into notify_change().  Checks for immutable and append-only files are
always performed by the VFS and not by the filesystem (see
permission() and may_...() in namei.c), so these belong in
notify_change(), and not in inode_change_ok().

This causes the following semantic changes in sys_utimensat(), if both
times are either UTIME_NOW or UTIME_OMIT:

 - if inode is immutable, then -EACCESS is returned instead of -EPERM
 - if inode is append-only, then success is returned instead of -EPERM

This should be OK, becuase this makes the UTIME_NOW on both behave
exactly the same as times == NULL.  If one of the times is UTIME_OMIT,
and the other is UTIME_NOW, it also makes no sense to return a

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Ulrich Drepper <drepper@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/attr.c   |    6 ++++++
 fs/open.c   |   24 ++----------------------
 fs/utimes.c |    4 ----
 3 files changed, 8 insertions(+), 26 deletions(-)

diff -puN fs/attr.c~vfs-immutable-inode-checking-cleanup fs/attr.c
--- a/fs/attr.c~vfs-immutable-inode-checking-cleanup
+++ a/fs/attr.c
@@ -108,6 +108,12 @@ int notify_change(struct dentry * dentry
 	struct timespec now;
 	unsigned int ia_valid = attr->ia_valid;
 
+	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
+			ATTR_ATIME_SET | ATTR_MTIME_SET)) {
+		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
+			return -EPERM;
+	}
+
 	now = current_fs_time(inode->i_sb);
 
 	attr->ia_ctime = now;
diff -puN fs/open.c~vfs-immutable-inode-checking-cleanup fs/open.c
--- a/fs/open.c~vfs-immutable-inode-checking-cleanup
+++ a/fs/open.c
@@ -582,9 +582,6 @@ asmlinkage long sys_fchmod(unsigned int 
 	err = mnt_want_write(file->f_path.mnt);
 	if (err)
 		goto out_putf;
-	err = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out_drop_write;
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
@@ -592,8 +589,6 @@ asmlinkage long sys_fchmod(unsigned int 
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
 	err = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-
-out_drop_write:
 	mnt_drop_write(file->f_path.mnt);
 out_putf:
 	fput(file);
@@ -617,11 +612,6 @@ asmlinkage long sys_fchmodat(int dfd, co
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto dput_and_out;
-
-	error = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out_drop_write;
-
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
@@ -629,8 +619,6 @@ asmlinkage long sys_fchmodat(int dfd, co
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
 	error = notify_change(nd.path.dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-
-out_drop_write:
 	mnt_drop_write(nd.path.mnt);
 dput_and_out:
 	path_put(&nd.path);
@@ -645,18 +633,10 @@ asmlinkage long sys_chmod(const char __u
 
 static int chown_common(struct dentry * dentry, uid_t user, gid_t group)
 {
-	struct inode * inode;
+	struct inode *inode = dentry->d_inode;
 	int error;
 	struct iattr newattrs;
 
-	error = -ENOENT;
-	if (!(inode = dentry->d_inode)) {
-		printk(KERN_ERR "chown_common: NULL inode\n");
-		goto out;
-	}
-	error = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out;
 	newattrs.ia_valid =  ATTR_CTIME;
 	if (user != (uid_t) -1) {
 		newattrs.ia_valid |= ATTR_UID;
@@ -672,7 +652,7 @@ static int chown_common(struct dentry * 
 	mutex_lock(&inode->i_mutex);
 	error = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-out:
+
 	return error;
 }
 
diff -puN fs/utimes.c~vfs-immutable-inode-checking-cleanup fs/utimes.c
--- a/fs/utimes.c~vfs-immutable-inode-checking-cleanup
+++ a/fs/utimes.c
@@ -105,10 +105,6 @@ long do_utimes(int dfd, char __user *fil
 	/* Don't worry, the checks are done in inode_change_ok() */
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
 	if (times) {
-		error = -EPERM;
-                if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-			goto mnt_drop_write_and_out;
-
 		if (times[0].tv_nsec == UTIME_OMIT)
 			newattrs.ia_valid &= ~ATTR_ATIME;
 		else if (times[0].tv_nsec != UTIME_NOW) {
_

Patches currently in -mm which might be from mszeredi@suse.cz are

vfs-immutable-inode-checking-cleanup.patch
vfs-truncate-dont-check-immutable-twice.patch
vfs-create-file_truncate-helper.patch
vfs-utimes-immutable-fix.patch
vfs-utimes-cleanup.patch
vfs-dcache-cleanups.patch
vfs-fix-sys_getcwd-for-detached-mounts.patch
git-unprivileged-mounts.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch


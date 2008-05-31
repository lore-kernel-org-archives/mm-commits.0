From: akpm@linux-foundation.org
Subject: - vfs-utimes-cleanup.patch removed from -mm tree
Date: Sat, 31 May 2008 00:42:53 -0700
Message-ID: <200805310742.m4V7gr59000943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbYEaHnu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 31 May 2008 03:43:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, drepper@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: utimes cleanup
has been removed from the -mm tree.  Its filename was
     vfs-utimes-cleanup.patch

This patch was dropped because it's more controversial than was first thought, and it was sent off-list

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: utimes cleanup
From: Miklos Szeredi <mszeredi@suse.cz>

Untange the mess that is do_utimes()

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/utimes.c          |  179 ++++++++++++++++++++++++-----------------
 include/linux/time.h |    3 
 2 files changed, 108 insertions(+), 74 deletions(-)

diff -puN fs/utimes.c~vfs-utimes-cleanup fs/utimes.c
--- a/fs/utimes.c~vfs-utimes-cleanup
+++ a/fs/utimes.c
@@ -53,54 +53,10 @@ static bool nsec_valid(long nsec)
 	return nsec >= 0 && nsec <= 999999999;
 }
 
-/* If times==NULL, set access and modification to current time,
- * must be owner or have write permission.
- * Else, update from *times, must be owner or super user.
- */
-long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags)
+static int utimes_common(struct path *path, struct timespec *times)
 {
 	int error;
-	struct nameidata nd;
-	struct dentry *dentry;
-	struct inode *inode;
 	struct iattr newattrs;
-	struct file *f = NULL;
-	struct vfsmount *mnt;
-
-	error = -EINVAL;
-	if (times && (!nsec_valid(times[0].tv_nsec) ||
-		      !nsec_valid(times[1].tv_nsec))) {
-		goto out;
-	}
-
-	if (flags & ~AT_SYMLINK_NOFOLLOW)
-		goto out;
-
-	if (filename == NULL && dfd != AT_FDCWD) {
-		error = -EINVAL;
-		if (flags & AT_SYMLINK_NOFOLLOW)
-			goto out;
-
-		error = -EBADF;
-		f = fget(dfd);
-		if (!f)
-			goto out;
-		dentry = f->f_path.dentry;
-		mnt = f->f_path.mnt;
-	} else {
-		error = __user_walk_fd(dfd, filename, (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW, &nd);
-		if (error)
-			goto out;
-
-		dentry = nd.path.dentry;
-		mnt = nd.path.mnt;
-	}
-
-	inode = dentry->d_inode;
-
-	error = mnt_want_write(mnt);
-	if (error)
-		goto dput_and_out;
 
 	/* Don't worry, the checks are done in inode_change_ok() */
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
@@ -121,41 +77,118 @@ long do_utimes(int dfd, char __user *fil
 			newattrs.ia_valid |= ATTR_MTIME_SET;
 		}
 	}
+	mutex_lock(&path->dentry->d_inode->i_mutex);
+	error = mnt_want_write(path->mnt);
+	if (!error) {
+		error = notify_change(path->dentry, &newattrs);
+		mnt_drop_write(path->mnt);
+	}
+	mutex_unlock(&path->dentry->d_inode->i_mutex);
+
+	return error;
+}
+
+/*
+ * If times is NULL or both times are either UTIME_OMIT or UTIME_NOW, then
+ * need to check permissions, because inode_change_ok() won't do it.
+ */
+static bool utimes_need_permission(struct timespec *times)
+{
+	return !times || (nsec_special(times[0].tv_nsec) &&
+			  nsec_special(times[1].tv_nsec));
+}
+
+static int do_futimes(int fd, struct timespec *times)
+{
+	int error;
+	struct file *file = fget(fd);
+
+	if (!file)
+		return -EBADF;
+
+	if (utimes_need_permission(times)) {
+		struct inode *inode = file->f_path.dentry->d_inode;
+
+		error = -EACCES;
+		if (!is_owner_or_cap(inode) && !(file->f_mode & FMODE_WRITE))
+			goto out_fput;
+	}
+	error = utimes_common(&file->f_path, times);
+
+ out_fput:
+	fput(file);
+
+	return error;
+}
+
+static int do_utimes_name(int dfd, char __user *filename,
+			  struct timespec *times, int flags)
+{
+	int error;
+	struct nameidata nd;
+	int lookup_flags;
+
+	if (flags & ~AT_SYMLINK_NOFOLLOW)
+		return -EINVAL;
+
+	lookup_flags = (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
+	error = __user_walk_fd(dfd, filename, lookup_flags, &nd);
+	if (error)
+		return error;
+
+
+	if (utimes_need_permission(times)) {
+		struct inode *inode = nd.path.dentry->d_inode;
 
-	/*
-	 * If times is NULL or both times are either UTIME_OMIT or
-	 * UTIME_NOW, then need to check permissions, because
-	 * inode_change_ok() won't do it.
-	 */
-	if (!times || (nsec_special(times[0].tv_nsec) &&
-		       nsec_special(times[1].tv_nsec))) {
 		error = -EACCES;
-		if (!f && IS_IMMUTABLE(inode))
-			goto mnt_drop_write_and_out;
+		if (IS_IMMUTABLE(inode))
+			goto out_path_put;
 
 		if (!is_owner_or_cap(inode)) {
-			if (f) {
-				if (!(f->f_mode & FMODE_WRITE))
-					goto mnt_drop_write_and_out;
-			} else {
-				error = vfs_permission(&nd, MAY_WRITE);
-				if (error)
-					goto mnt_drop_write_and_out;
-			}
+			error = vfs_permission(&nd, MAY_WRITE);
+			if (error)
+				goto out_path_put;
 		}
 	}
-	mutex_lock(&inode->i_mutex);
-	error = notify_change(dentry, &newattrs);
-	mutex_unlock(&inode->i_mutex);
-mnt_drop_write_and_out:
-	mnt_drop_write(mnt);
-dput_and_out:
-	if (f)
-		fput(f);
-	else
-		path_put(&nd.path);
-out:
+	error = utimes_common(&nd.path, times);
+
+ out_path_put:
+	path_put(&nd.path);
+
 	return error;
+
+}
+
+/*
+ * do_utimes - change times on filename or file descriptor
+ * @dfd: open file descriptor, -1 or AT_FDCWD
+ * @filename: path name or NULL
+ * @times: new times or NULL
+ * @flags: zero or more flags (only AT_SYMLINK_NOFOLLOW for the moment)
+ *
+ * If filename is NULL and dfd refers to an open file, then operate on
+ * the file.  Otherwise look up filename, possibly using dfd as a
+ * starting point.
+ *
+ * If times==NULL, set access and modification to current time,
+ * must be owner or have write permission.
+ * Else, update from *times, must be owner or super user.
+ */
+int do_utimes(int dfd, char __user *filename, struct timespec *times, int flags)
+{
+	if (times && (!nsec_valid(times[0].tv_nsec) ||
+		      !nsec_valid(times[1].tv_nsec))) {
+		return -EINVAL;
+	}
+
+	if (filename == NULL && dfd != AT_FDCWD) {
+		if (flags)
+			return -EINVAL;
+
+		return do_futimes(dfd, times);
+	} else {
+		return do_utimes_name(dfd, filename, times, flags);
+	}
 }
 
 asmlinkage long sys_utimensat(int dfd, char __user *filename, struct timespec __user *utimes, int flags)
diff -puN include/linux/time.h~vfs-utimes-cleanup include/linux/time.h
--- a/include/linux/time.h~vfs-utimes-cleanup
+++ a/include/linux/time.h
@@ -110,7 +110,8 @@ extern void do_gettimeofday(struct timev
 extern int do_settimeofday(struct timespec *tv);
 extern int do_sys_settimeofday(struct timespec *tv, struct timezone *tz);
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
-extern long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags);
+extern int do_utimes(int dfd, char __user *filename, struct timespec *times,
+		     int flags);
 struct itimerval;
 extern int do_setitimer(int which, struct itimerval *value,
 			struct itimerval *ovalue);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

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


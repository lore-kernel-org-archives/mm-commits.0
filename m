From: akpm@linux-foundation.org
Subject: [merged] vfs-kill-vfs_stat_fd-vfs_lstat_fd.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:31:14 -0700
Message-ID: <200904221831.n3MIVEjF006652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824AbZDVSfQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:35:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@infradead.org, green@linuxhacker.ru, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: kill vfs_stat_fd / vfs_lstat_fd
has been removed from the -mm tree.  Its filename was
     vfs-kill-vfs_stat_fd-vfs_lstat_fd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: kill vfs_stat_fd / vfs_lstat_fd
From: Christoph Hellwig <hch@infradead.org>

There's really no reason to keep vfs_stat_fd and vfs_lstat_fd with Oleg's
vfs_fstatat.  Use vfs_fstatat for the few cases having the directory fd,
and switch all others to vfs_stat / vfs_lstat.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Oleg Drokin <green@linuxhacker.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c        |   18 ++++---
 fs/stat.c          |  105 +++++++++++++++++--------------------------
 include/linux/fs.h |    2 
 3 files changed, 52 insertions(+), 73 deletions(-)

diff -puN fs/compat.c~vfs-kill-vfs_stat_fd-vfs_lstat_fd fs/compat.c
--- a/fs/compat.c~vfs-kill-vfs_stat_fd-vfs_lstat_fd
+++ a/fs/compat.c
@@ -181,22 +181,24 @@ asmlinkage long compat_sys_newstat(char 
 		struct compat_stat __user *statbuf)
 {
 	struct kstat stat;
-	int error = vfs_stat_fd(AT_FDCWD, filename, &stat);
+	int error;
 
-	if (!error)
-		error = cp_compat_stat(&stat, statbuf);
-	return error;
+	error = = vfs_stat(filename, &stat);
+	if (error)
+		return error;
+	return cp_compat_stat(&stat, statbuf);
 }
 
 asmlinkage long compat_sys_newlstat(char __user * filename,
 		struct compat_stat __user *statbuf)
 {
 	struct kstat stat;
-	int error = vfs_lstat_fd(AT_FDCWD, filename, &stat);
+	int error;
 
-	if (!error)
-		error = cp_compat_stat(&stat, statbuf);
-	return error;
+	error = vfs_lstat(filename, &stat);
+	if (error)
+		return error;
+	return cp_compat_stat(&stat, statbuf);
 }
 
 #ifndef __ARCH_WANT_STAT64
diff -puN fs/stat.c~vfs-kill-vfs_stat_fd-vfs_lstat_fd fs/stat.c
--- a/fs/stat.c~vfs-kill-vfs_stat_fd-vfs_lstat_fd
+++ a/fs/stat.c
@@ -55,46 +55,6 @@ int vfs_getattr(struct vfsmount *mnt, st
 
 EXPORT_SYMBOL(vfs_getattr);
 
-int vfs_stat_fd(int dfd, char __user *name, struct kstat *stat)
-{
-	struct path path;
-	int error;
-
-	error = user_path_at(dfd, name, LOOKUP_FOLLOW, &path);
-	if (!error) {
-		error = vfs_getattr(path.mnt, path.dentry, stat);
-		path_put(&path);
-	}
-	return error;
-}
-
-int vfs_stat(char __user *name, struct kstat *stat)
-{
-	return vfs_stat_fd(AT_FDCWD, name, stat);
-}
-
-EXPORT_SYMBOL(vfs_stat);
-
-int vfs_lstat_fd(int dfd, char __user *name, struct kstat *stat)
-{
-	struct path path;
-	int error;
-
-	error = user_path_at(dfd, name, 0, &path);
-	if (!error) {
-		error = vfs_getattr(path.mnt, path.dentry, stat);
-		path_put(&path);
-	}
-	return error;
-}
-
-int vfs_lstat(char __user *name, struct kstat *stat)
-{
-	return vfs_lstat_fd(AT_FDCWD, name, stat);
-}
-
-EXPORT_SYMBOL(vfs_lstat);
-
 int vfs_fstat(unsigned int fd, struct kstat *stat)
 {
 	struct file *f = fget(fd);
@@ -106,26 +66,43 @@ int vfs_fstat(unsigned int fd, struct ks
 	}
 	return error;
 }
-
 EXPORT_SYMBOL(vfs_fstat);
 
 int vfs_fstatat(int dfd, char __user *filename, struct kstat *stat, int flag)
 {
+	struct path path;
 	int error = -EINVAL;
+	int lookup_flags = 0;
 
 	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
 		goto out;
 
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, stat);
-	else
-		error = vfs_stat_fd(dfd, filename, stat);
+	if (!(flag & AT_SYMLINK_NOFOLLOW))
+		lookup_flags |= LOOKUP_FOLLOW;
+
+	error = user_path_at(dfd, filename, lookup_flags, &path);
+	if (error)
+		goto out;
+
+	error = vfs_getattr(path.mnt, path.dentry, stat);
+	path_put(&path);
 out:
 	return error;
 }
-
 EXPORT_SYMBOL(vfs_fstatat);
 
+int vfs_stat(char __user *name, struct kstat *stat)
+{
+	return vfs_fstatat(AT_FDCWD, name, stat, 0);
+}
+EXPORT_SYMBOL(vfs_stat);
+
+int vfs_lstat(char __user *name, struct kstat *stat)
+{
+	return vfs_fstatat(AT_FDCWD, name, stat, AT_SYMLINK_NOFOLLOW);
+}
+EXPORT_SYMBOL(vfs_lstat);
+
 
 #ifdef __ARCH_WANT_OLD_STAT
 
@@ -173,23 +150,25 @@ static int cp_old_stat(struct kstat *sta
 SYSCALL_DEFINE2(stat, char __user *, filename, struct __old_kernel_stat __user *, statbuf)
 {
 	struct kstat stat;
-	int error = vfs_stat_fd(AT_FDCWD, filename, &stat);
+	int error;
 
-	if (!error)
-		error = cp_old_stat(&stat, statbuf);
+	error = vfs_stat(filename, &stat);
+	if (error)
+		return error;
 
-	return error;
+	return cp_old_stat(&stat, statbuf);
 }
 
 SYSCALL_DEFINE2(lstat, char __user *, filename, struct __old_kernel_stat __user *, statbuf)
 {
 	struct kstat stat;
-	int error = vfs_lstat_fd(AT_FDCWD, filename, &stat);
+	int error;
 
-	if (!error)
-		error = cp_old_stat(&stat, statbuf);
+	error = vfs_lstat(filename, &stat);
+	if (error)
+		return error;
 
-	return error;
+	return cp_old_stat(&stat, statbuf);
 }
 
 SYSCALL_DEFINE2(fstat, unsigned int, fd, struct __old_kernel_stat __user *, statbuf)
@@ -258,23 +237,23 @@ static int cp_new_stat(struct kstat *sta
 SYSCALL_DEFINE2(newstat, char __user *, filename, struct stat __user *, statbuf)
 {
 	struct kstat stat;
-	int error = vfs_stat_fd(AT_FDCWD, filename, &stat);
-
-	if (!error)
-		error = cp_new_stat(&stat, statbuf);
+	int error = vfs_stat(filename, &stat);
 
-	return error;
+	if (error)
+		return error;
+	return cp_new_stat(&stat, statbuf);
 }
 
 SYSCALL_DEFINE2(newlstat, char __user *, filename, struct stat __user *, statbuf)
 {
 	struct kstat stat;
-	int error = vfs_lstat_fd(AT_FDCWD, filename, &stat);
+	int error;
 
-	if (!error)
-		error = cp_new_stat(&stat, statbuf);
+	error = vfs_lstat(filename, &stat);
+	if (error)
+		return error;
 
-	return error;
+	return cp_new_stat(&stat, statbuf);
 }
 
 #if !defined(__ARCH_WANT_STAT64) || defined(__ARCH_WANT_SYS_NEWFSTATAT)
diff -puN include/linux/fs.h~vfs-kill-vfs_stat_fd-vfs_lstat_fd include/linux/fs.h
--- a/include/linux/fs.h~vfs-kill-vfs_stat_fd-vfs_lstat_fd
+++ a/include/linux/fs.h
@@ -2299,8 +2299,6 @@ extern int vfs_readdir(struct file *, fi
 
 extern int vfs_stat(char __user *, struct kstat *);
 extern int vfs_lstat(char __user *, struct kstat *);
-extern int vfs_stat_fd(int dfd, char __user *, struct kstat *);
-extern int vfs_lstat_fd(int dfd, char __user *, struct kstat *);
 extern int vfs_fstat(unsigned int, struct kstat *);
 extern int vfs_fstatat(int , char __user *, struct kstat *, int);
 
_

Patches currently in -mm which might be from hch@infradead.org are

linux-next.patch
linuxpps-core-support.patch


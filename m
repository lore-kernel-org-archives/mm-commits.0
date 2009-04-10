From: akpm@linux-foundation.org
Subject: + vfs-consolidate-common-fstatat-code-into-vfs_fstatat.patch added to -mm tree
Date: Fri, 10 Apr 2009 14:39:46 -0700
Message-ID: <200904102139.n3ALdkwY003150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756293AbZDJVm0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 17:42:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: green@linuxhacker.ru, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: consolidate common fstatat code into vfs_fstatat
has been added to the -mm tree.  Its filename is
     vfs-consolidate-common-fstatat-code-into-vfs_fstatat.patch

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
Subject: vfs: consolidate common fstatat code into vfs_fstatat
From: Oleg Drokin <green@linuxhacker.ru>

Separate out common *fstatat functionality into a single function
instead of duplicating it all over the code.

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/sys_oabi-compat.c |   19 ++-------
 arch/s390/kernel/compat_linux.c   |   18 ++-------
 arch/sparc/kernel/sys_sparc32.c   |   19 ++-------
 arch/x86/ia32/sys_ia32.c          |   19 ++-------
 fs/compat.c                       |   19 ++-------
 fs/stat.c                         |   56 ++++++++++++++--------------
 include/linux/fs.h                |    1 
 7 files changed, 54 insertions(+), 97 deletions(-)

diff -puN arch/arm/kernel/sys_oabi-compat.c~vfs-consolidate-common-fstatat-code-into-vfs_fstatat arch/arm/kernel/sys_oabi-compat.c
--- a/arch/arm/kernel/sys_oabi-compat.c~vfs-consolidate-common-fstatat-code-into-vfs_fstatat
+++ a/arch/arm/kernel/sys_oabi-compat.c
@@ -176,21 +176,12 @@ asmlinkage long sys_oabi_fstatat64(int d
 				   int flag)
 {
 	struct kstat stat;
-	int error = -EINVAL;
+	int error;
 
-	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
-		goto out;
-
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, &stat);
-	else
-		error = vfs_stat_fd(dfd, filename, &stat);
-
-	if (!error)
-	error = cp_oldabi_stat64(&stat, statbuf);
-
-out:
-	return error;
+	error = vfs_fstatat(dfd, filename, &stat, flag);
+	if (error)
+		return error;
+	return cp_oldabi_stat64(&stat, statbuf);
 }
 
 struct oabi_flock64 {
diff -puN arch/s390/kernel/compat_linux.c~vfs-consolidate-common-fstatat-code-into-vfs_fstatat arch/s390/kernel/compat_linux.c
--- a/arch/s390/kernel/compat_linux.c~vfs-consolidate-common-fstatat-code-into-vfs_fstatat
+++ a/arch/s390/kernel/compat_linux.c
@@ -702,20 +702,12 @@ asmlinkage long sys32_fstatat64(unsigned
 				struct stat64_emu31 __user* statbuf, int flag)
 {
 	struct kstat stat;
-	int error = -EINVAL;
+	int error;
 
-	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
-		goto out;
-
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, &stat);
-	else
-		error = vfs_stat_fd(dfd, filename, &stat);
-
-	if (!error)
-		error = cp_stat64(statbuf, &stat);
-out:
-	return error;
+	error = vfs_fstatat(dfd, filename, &stat, flag);
+	if (error)
+		return error;
+	return cp_stat64(statbuf, &stat);
 }
 
 /*
diff -puN arch/sparc/kernel/sys_sparc32.c~vfs-consolidate-common-fstatat-code-into-vfs_fstatat arch/sparc/kernel/sys_sparc32.c
--- a/arch/sparc/kernel/sys_sparc32.c~vfs-consolidate-common-fstatat-code-into-vfs_fstatat
+++ a/arch/sparc/kernel/sys_sparc32.c
@@ -206,21 +206,12 @@ asmlinkage long compat_sys_fstatat64(uns
 		struct compat_stat64 __user * statbuf, int flag)
 {
 	struct kstat stat;
-	int error = -EINVAL;
-
-	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
-		goto out;
-
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, &stat);
-	else
-		error = vfs_stat_fd(dfd, filename, &stat);
-
-	if (!error)
-		error = cp_compat_stat64(&stat, statbuf);
+	int error;
 
-out:
-	return error;
+	error = vfs_fstatat(dfd, filename, &stat, flag);
+	if (error)
+		return error;
+	return cp_compat_stat64(&stat, statbuf);
 }
 
 asmlinkage long compat_sys_sysfs(int option, u32 arg1, u32 arg2)
diff -puN arch/x86/ia32/sys_ia32.c~vfs-consolidate-common-fstatat-code-into-vfs_fstatat arch/x86/ia32/sys_ia32.c
--- a/arch/x86/ia32/sys_ia32.c~vfs-consolidate-common-fstatat-code-into-vfs_fstatat
+++ a/arch/x86/ia32/sys_ia32.c
@@ -129,21 +129,12 @@ asmlinkage long sys32_fstatat(unsigned i
 			      struct stat64 __user *statbuf, int flag)
 {
 	struct kstat stat;
-	int error = -EINVAL;
+	int error;
 
-	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
-		goto out;
-
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, &stat);
-	else
-		error = vfs_stat_fd(dfd, filename, &stat);
-
-	if (!error)
-		error = cp_stat64(statbuf, &stat);
-
-out:
-	return error;
+	error = vfs_fstatat(dfd, filename, &stat, flag);
+	if (error)
+		return error;
+	return cp_stat64(statbuf, &stat);
 }
 
 /*
diff -puN fs/compat.c~vfs-consolidate-common-fstatat-code-into-vfs_fstatat fs/compat.c
--- a/fs/compat.c~vfs-consolidate-common-fstatat-code-into-vfs_fstatat
+++ a/fs/compat.c
@@ -204,21 +204,12 @@ asmlinkage long compat_sys_newfstatat(un
 		struct compat_stat __user *statbuf, int flag)
 {
 	struct kstat stat;
-	int error = -EINVAL;
-
-	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
-		goto out;
-
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, &stat);
-	else
-		error = vfs_stat_fd(dfd, filename, &stat);
-
-	if (!error)
-		error = cp_compat_stat(&stat, statbuf);
+	int error;
 
-out:
-	return error;
+	error = vfs_fstatat(dfd, filename, &stat, flag);
+	if (error)
+		return error;
+	return cp_compat_stat(&stat, statbuf);
 }
 #endif
 
diff -puN fs/stat.c~vfs-consolidate-common-fstatat-code-into-vfs_fstatat fs/stat.c
--- a/fs/stat.c~vfs-consolidate-common-fstatat-code-into-vfs_fstatat
+++ a/fs/stat.c
@@ -109,6 +109,24 @@ int vfs_fstat(unsigned int fd, struct ks
 
 EXPORT_SYMBOL(vfs_fstat);
 
+int vfs_fstatat(int dfd, char __user *filename, struct kstat *stat, int flag)
+{
+	int error = -EINVAL;
+
+	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
+		goto out;
+
+	if (flag & AT_SYMLINK_NOFOLLOW)
+		error = vfs_lstat_fd(dfd, filename, stat);
+	else
+		error = vfs_stat_fd(dfd, filename, stat);
+out:
+	return error;
+}
+
+EXPORT_SYMBOL(vfs_fstatat);
+
+
 #ifdef __ARCH_WANT_OLD_STAT
 
 /*
@@ -264,21 +282,12 @@ SYSCALL_DEFINE4(newfstatat, int, dfd, ch
 		struct stat __user *, statbuf, int, flag)
 {
 	struct kstat stat;
-	int error = -EINVAL;
-
-	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
-		goto out;
-
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, &stat);
-	else
-		error = vfs_stat_fd(dfd, filename, &stat);
-
-	if (!error)
-		error = cp_new_stat(&stat, statbuf);
+	int error;
 
-out:
-	return error;
+	error = vfs_fstatat(dfd, filename, &stat, flag);
+	if (error)
+		return error;
+	return cp_new_stat(&stat, statbuf);
 }
 #endif
 
@@ -404,21 +413,12 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, cha
 		struct stat64 __user *, statbuf, int, flag)
 {
 	struct kstat stat;
-	int error = -EINVAL;
-
-	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
-		goto out;
-
-	if (flag & AT_SYMLINK_NOFOLLOW)
-		error = vfs_lstat_fd(dfd, filename, &stat);
-	else
-		error = vfs_stat_fd(dfd, filename, &stat);
-
-	if (!error)
-		error = cp_new_stat64(&stat, statbuf);
+	int error;
 
-out:
-	return error;
+	error = vfs_fstatat(dfd, filename, &stat, flag);
+	if (error)
+		return error;
+	return cp_new_stat64(&stat, statbuf);
 }
 #endif /* __ARCH_WANT_STAT64 */
 
diff -puN include/linux/fs.h~vfs-consolidate-common-fstatat-code-into-vfs_fstatat include/linux/fs.h
--- a/include/linux/fs.h~vfs-consolidate-common-fstatat-code-into-vfs_fstatat
+++ a/include/linux/fs.h
@@ -2248,6 +2248,7 @@ extern int vfs_lstat(char __user *, stru
 extern int vfs_stat_fd(int dfd, char __user *, struct kstat *);
 extern int vfs_lstat_fd(int dfd, char __user *, struct kstat *);
 extern int vfs_fstat(unsigned int, struct kstat *);
+extern int vfs_fstatat(int , char __user *, struct kstat *, int);
 
 extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
_

Patches currently in -mm which might be from green@linuxhacker.ru are

vfs-consolidate-common-fstatat-code-into-vfs_fstatat.patch


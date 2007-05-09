From: akpm@linux-foundation.org
Subject: - utimensat-implementation.patch removed from -mm tree
Date: Tue, 08 May 2007 19:53:55 -0700
Message-ID: <200705090253.l492rtjk009751@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032237AbXEICyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:54:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, adobriyan@openvz.org, linux-arch@vger.kernel.org, mtk-manpages@gmx.net, mm-commits@vger.kernel.org


The patch titled
     utimensat implementation
has been removed from the -mm tree.  Its filename was
     utimensat-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: utimensat implementation
From: Ulrich Drepper <drepper@redhat.com>

Implement utimensat(2) which is an extension to futimesat(2) in that it

a) supports nano-second resolution for the timestamps
b) allows to selectively ignore the atime/mtime value
c) allows to selectively use the current time for either atime or mtime
d) supports changing the atime/mtime of a symlink itself along the lines
   of the BSD lutimes(3) functions

For this change the internally used do_utimes() functions was changed to
accept a timespec time value and an additional flags parameter.

Additionally the sys_utime function was changed to match compat_sys_utime
which already use do_utimes instead of duplicating the work.

Also, the completely missing futimensat() functionality is added.  We have
such a function in glibc but we have to resort to using /proc/self/fd/* which
not everybody likes (chroot etc).


Test application (the syscall number will need per-arch editing):


#include <errno.h>
#include <fcntl.h>
#include <time.h>
#include <sys/time.h>
#include <stddef.h>
#include <syscall.h>

#define __NR_utimensat 280

#define UTIME_NOW       ((1l << 30) - 1l)
#define UTIME_OMIT      ((1l << 30) - 2l)


int
main(void)
{
  int status = 0;

  int fd = open("ttt", O_RDWR|O_CREAT|O_EXCL, 0666);
  if (fd == -1)
    error (1, errno, "failed to create test file \"ttt\"");

  struct stat64 st1;
  if (fstat64 (fd, &st1) != 0)
    error (1, errno, "fstat failed");

  struct timespec t[2];
  t[0].tv_sec = 0;
  t[0].tv_nsec = 0;
  t[1].tv_sec = 0;
  t[1].tv_nsec = 0;
  if (syscall(__NR_utimensat, AT_FDCWD, "ttt", t, 0) != 0)
    error (1, errno, "utimensat failed");

  struct stat64 st2;
  if (fstat64 (fd, &st2) != 0)
    error (1, errno, "fstat failed");
  
  if (st2.st_atim.tv_sec != 0 || st2.st_atim.tv_nsec != 0)
    {
      puts ("atim not reset to zero");
      status = 1;
    }
  if (st2.st_mtim.tv_sec != 0 || st2.st_mtim.tv_nsec != 0)
    {
      puts ("mtim not reset to zero");
      status = 1;
    }
  if (status != 0)
    goto out;

  t[0] = st1.st_atim;
  t[1].tv_sec = 0;
  t[1].tv_nsec = UTIME_OMIT;
  if (syscall(__NR_utimensat, AT_FDCWD, "ttt", t, 0) != 0)
    error (1, errno, "utimensat failed");

  if (fstat64 (fd, &st2) != 0)
    error (1, errno, "fstat failed");
  
  if (st2.st_atim.tv_sec != st1.st_atim.tv_sec
      || st2.st_atim.tv_nsec != st1.st_atim.tv_nsec)
    {
      puts ("atim not set");
      status = 1;
    }
  if (st2.st_mtim.tv_sec != 0 || st2.st_mtim.tv_nsec != 0)
    {
      puts ("mtim changed from zero");
      status = 1;
    }
  if (status != 0)
    goto out;

  t[0].tv_sec = 0;
  t[0].tv_nsec = UTIME_OMIT;
  t[1] = st1.st_mtim;
  if (syscall(__NR_utimensat, AT_FDCWD, "ttt", t, 0) != 0)
    error (1, errno, "utimensat failed");

  if (fstat64 (fd, &st2) != 0)
    error (1, errno, "fstat failed");
  
  if (st2.st_atim.tv_sec != st1.st_atim.tv_sec
      || st2.st_atim.tv_nsec != st1.st_atim.tv_nsec)
    {
      puts ("mtim changed from original time");
      status = 1;
    }
  if (st2.st_mtim.tv_sec != st1.st_mtim.tv_sec
      || st2.st_mtim.tv_nsec != st1.st_mtim.tv_nsec)
    {
      puts ("mtim not set");
      status = 1;
    }
  if (status != 0)
    goto out;

  sleep (2);

  t[0].tv_sec = 0;
  t[0].tv_nsec = UTIME_NOW;
  t[1].tv_sec = 0;
  t[1].tv_nsec = UTIME_NOW;
  if (syscall(__NR_utimensat, AT_FDCWD, "ttt", t, 0) != 0)
    error (1, errno, "utimensat failed");

  if (fstat64 (fd, &st2) != 0)
    error (1, errno, "fstat failed");

  struct timeval tv;
  gettimeofday(&tv,NULL);

  if (st2.st_atim.tv_sec <= st1.st_atim.tv_sec
      || st2.st_atim.tv_sec > tv.tv_sec)
    {
      puts ("atim not set to NOW");
      status = 1;
    }
  if (st2.st_mtim.tv_sec <= st1.st_mtim.tv_sec
      || st2.st_mtim.tv_sec > tv.tv_sec)
    {
      puts ("mtim not set to NOW");
      status = 1;
    }

  if (symlink ("ttt", "tttsym") != 0)
    error (1, errno, "cannot create symlink");

  t[0].tv_sec = 0;
  t[0].tv_nsec = 0;
  t[1].tv_sec = 0;
  t[1].tv_nsec = 0;
  if (syscall(__NR_utimensat, AT_FDCWD, "tttsym", t, AT_SYMLINK_NOFOLLOW) != 0)
    error (1, errno, "utimensat failed");

  if (lstat64 ("tttsym", &st2) != 0)
    error (1, errno, "lstat failed");

  if (st2.st_atim.tv_sec != 0 || st2.st_atim.tv_nsec != 0)
    {
      puts ("symlink atim not reset to zero");
      status = 1;
    }
  if (st2.st_mtim.tv_sec != 0 || st2.st_mtim.tv_nsec != 0)
    {
      puts ("symlink mtim not reset to zero");
      status = 1;
    }
  if (status != 0)
    goto out;

  t[0].tv_sec = 1;
  t[0].tv_nsec = 0;
  t[1].tv_sec = 1;
  t[1].tv_nsec = 0;
  if (syscall(__NR_utimensat, fd, NULL, t, 0) != 0)
    error (1, errno, "utimensat failed");

  if (fstat64 (fd, &st2) != 0)
    error (1, errno, "fstat failed");
  
  if (st2.st_atim.tv_sec != 1 || st2.st_atim.tv_nsec != 0)
    {
      puts ("atim not reset to one");
      status = 1;
    }
  if (st2.st_mtim.tv_sec != 1 || st2.st_mtim.tv_nsec != 0)
    {
      puts ("mtim not reset to one");
      status = 1;
    }

  if (status == 0)
     puts ("all OK");

 out:
  close (fd);
  unlink ("ttt");
  unlink ("tttsym");

  return status;
}


[akpm@linux-foundation.org: add missing i386 syscall table entry]
Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/osf_sys.c       |   14 ++
 arch/i386/kernel/syscall_table.S  |    1 
 arch/sparc64/kernel/sys_sparc32.c |   14 ++
 arch/x86_64/ia32/ia32entry.S      |    3 
 fs/compat.c                       |   43 ++++++-
 fs/utimes.c                       |  162 +++++++++++++++++-----------
 include/asm-i386/unistd.h         |    3 
 include/asm-x86_64/unistd.h       |    2 
 include/linux/stat.h              |    3 
 include/linux/time.h              |    2 
 10 files changed, 172 insertions(+), 75 deletions(-)

diff -puN arch/alpha/kernel/osf_sys.c~utimensat-implementation arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~utimensat-implementation
+++ a/arch/alpha/kernel/osf_sys.c
@@ -953,15 +953,25 @@ osf_setitimer(int which, struct itimerva
 asmlinkage int
 osf_utimes(char __user *filename, struct timeval32 __user *tvs)
 {
-	struct timeval ktvs[2];
+	struct timespec tv[2];
 
 	if (tvs) {
+		struct timeval ktvs[2];
 		if (get_tv32(&ktvs[0], &tvs[0]) ||
 		    get_tv32(&ktvs[1], &tvs[1]))
 			return -EFAULT;
+
+		if (ktvs[0].tv_usec < 0 || ktvs[0].tv_usec >= 1000000 ||
+		    ktvs[1].tv_usec < 0 || ktvs[1].tv_usec >= 1000000)
+			return -EINVAL;
+
+		tv[0].tv_sec = ktvs[0].tv_sec;
+		tv[0].tv_nsec = 1000 * ktvs[0].tv_usec;
+		tv[1].tv_sec = ktvs[1].tv_sec;
+		tv[1].tv_nsec = 1000 * ktvs[1].tv_usec;
 	}
 
-	return do_utimes(AT_FDCWD, filename, tvs ? ktvs : NULL);
+	return do_utimes(AT_FDCWD, filename, tvs ? tv : NULL, 0);
 }
 
 #define MAX_SELECT_SECONDS \
diff -puN arch/i386/kernel/syscall_table.S~utimensat-implementation arch/i386/kernel/syscall_table.S
--- a/arch/i386/kernel/syscall_table.S~utimensat-implementation
+++ a/arch/i386/kernel/syscall_table.S
@@ -319,3 +319,4 @@ ENTRY(sys_call_table)
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_utimensat		/* 320 */
diff -puN arch/sparc64/kernel/sys_sparc32.c~utimensat-implementation arch/sparc64/kernel/sys_sparc32.c
--- a/arch/sparc64/kernel/sys_sparc32.c~utimensat-implementation
+++ a/arch/sparc64/kernel/sys_sparc32.c
@@ -775,15 +775,25 @@ asmlinkage long sys32_settimeofday(struc
 asmlinkage long sys32_utimes(char __user *filename,
 			     struct compat_timeval __user *tvs)
 {
-	struct timeval ktvs[2];
+	struct timespec tv[2];
 
 	if (tvs) {
+		struct timeval ktvs[2];
 		if (get_tv32(&ktvs[0], tvs) ||
 		    get_tv32(&ktvs[1], 1+tvs))
 			return -EFAULT;
+
+		if (ktvs[0].tv_usec < 0 || ktvs[0].tv_usec >= 1000000 ||
+		    ktvs[1].tv_usec < 0 || ktvs[1].tv_usec >= 1000000)
+			return -EINVAL;
+
+		tv[0].tv_sec = ktvs[0].tv_sec;
+		tv[0].tv_nsec = 1000 * ktvs[0].tv_usec;
+		tv[1].tv_sec = ktvs[1].tv_sec;
+		tv[1].tv_nsec = 1000 * ktvs[1].tv_usec;
 	}
 
-	return do_utimes(AT_FDCWD, filename, (tvs ? &ktvs[0] : NULL));
+	return do_utimes(AT_FDCWD, filename, tvs ? tv : NULL);
 }
 
 /* These are here just in case some old sparc32 binary calls it. */
diff -puN arch/x86_64/ia32/ia32entry.S~utimensat-implementation arch/x86_64/ia32/ia32entry.S
--- a/arch/x86_64/ia32/ia32entry.S~utimensat-implementation
+++ a/arch/x86_64/ia32/ia32entry.S
@@ -710,9 +710,10 @@ ia32_sys_call_table:
 	.quad compat_sys_get_robust_list
 	.quad sys_splice
 	.quad sys_sync_file_range
-	.quad sys_tee
+	.quad sys_tee			/* 315 */
 	.quad compat_sys_vmsplice
 	.quad compat_sys_move_pages
 	.quad sys_getcpu
 	.quad sys_epoll_pwait
+	.quad compat_sys_utimensat	/* 320 */
 ia32_syscall_end:		
diff -puN fs/compat.c~utimensat-implementation fs/compat.c
--- a/fs/compat.c~utimensat-implementation
+++ a/fs/compat.c
@@ -77,30 +77,57 @@ int compat_printk(const char *fmt, ...)
  */
 asmlinkage long compat_sys_utime(char __user *filename, struct compat_utimbuf __user *t)
 {
-	struct timeval tv[2];
+	struct timespec tv[2];
 
 	if (t) {
 		if (get_user(tv[0].tv_sec, &t->actime) ||
 		    get_user(tv[1].tv_sec, &t->modtime))
 			return -EFAULT;
-		tv[0].tv_usec = 0;
-		tv[1].tv_usec = 0;
+		tv[0].tv_nsec = 0;
+		tv[1].tv_nsec = 0;
 	}
-	return do_utimes(AT_FDCWD, filename, t ? tv : NULL);
+	return do_utimes(AT_FDCWD, filename, t ? tv : NULL, 0);
+}
+
+asmlinkage long compat_sys_utimensat(unsigned int dfd, char __user *filename, struct compat_timespec __user *t, int flags)
+{
+	struct timespec tv[2];
+
+	if  (t) {
+		if (get_compat_timespec(&tv[0], &t[0]) ||
+		    get_compat_timespec(&tv[1], &t[1]))
+			return -EFAULT;
+
+		if ((tv[0].tv_nsec == UTIME_OMIT || tv[0].tv_nsec == UTIME_NOW)
+		    && tv[0].tv_sec != 0)
+			return -EINVAL;
+		if ((tv[1].tv_nsec == UTIME_OMIT || tv[1].tv_nsec == UTIME_NOW)
+		    && tv[1].tv_sec != 0)
+			return -EINVAL;
+
+		if (tv[0].tv_nsec == UTIME_OMIT && tv[1].tv_nsec == UTIME_OMIT)
+			return 0;
+	}
+	return do_utimes(dfd, filename, t ? tv : NULL, flags);
 }
 
 asmlinkage long compat_sys_futimesat(unsigned int dfd, char __user *filename, struct compat_timeval __user *t)
 {
-	struct timeval tv[2];
+	struct timespec tv[2];
 
 	if (t) {
 		if (get_user(tv[0].tv_sec, &t[0].tv_sec) ||
-		    get_user(tv[0].tv_usec, &t[0].tv_usec) ||
+		    get_user(tv[0].tv_nsec, &t[0].tv_usec) ||
 		    get_user(tv[1].tv_sec, &t[1].tv_sec) ||
-		    get_user(tv[1].tv_usec, &t[1].tv_usec))
+		    get_user(tv[1].tv_nsec, &t[1].tv_usec))
 			return -EFAULT;
+		if (tv[0].tv_nsec >= 1000000 || tv[0].tv_nsec < 0 ||
+		    tv[1].tv_nsec >= 1000000 || tv[1].tv_nsec < 0)
+			return -EINVAL;
+		tv[0].tv_nsec *= 1000;
+		tv[1].tv_nsec *= 1000;
 	}
-	return do_utimes(dfd, filename, t ? tv : NULL);
+	return do_utimes(dfd, filename, t ? tv : NULL, 0);
 }
 
 asmlinkage long compat_sys_utimes(char __user *filename, struct compat_timeval __user *t)
diff -puN fs/utimes.c~utimensat-implementation fs/utimes.c
--- a/fs/utimes.c~utimensat-implementation
+++ a/fs/utimes.c
@@ -1,8 +1,10 @@
 #include <linux/compiler.h>
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/linkage.h>
 #include <linux/namei.h>
 #include <linux/sched.h>
+#include <linux/stat.h>
 #include <linux/utime.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -20,54 +22,18 @@
  * must be owner or have write permission.
  * Else, update from *times, must be owner or super user.
  */
-asmlinkage long sys_utime(char __user * filename, struct utimbuf __user * times)
+asmlinkage long sys_utime(char __user *filename, struct utimbuf __user *times)
 {
-	int error;
-	struct nameidata nd;
-	struct inode * inode;
-	struct iattr newattrs;
+	struct timespec tv[2];
 
-	error = user_path_walk(filename, &nd);
-	if (error)
-		goto out;
-	inode = nd.dentry->d_inode;
-
-	error = -EROFS;
-	if (IS_RDONLY(inode))
-		goto dput_and_out;
-
-	/* Don't worry, the checks are done in inode_change_ok() */
-	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
 	if (times) {
-		error = -EPERM;
-		if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-			goto dput_and_out;
-
-		error = get_user(newattrs.ia_atime.tv_sec, &times->actime);
-		newattrs.ia_atime.tv_nsec = 0;
-		if (!error)
-			error = get_user(newattrs.ia_mtime.tv_sec, &times->modtime);
-		newattrs.ia_mtime.tv_nsec = 0;
-		if (error)
-			goto dput_and_out;
-
-		newattrs.ia_valid |= ATTR_ATIME_SET | ATTR_MTIME_SET;
-	} else {
-                error = -EACCES;
-                if (IS_IMMUTABLE(inode))
-                        goto dput_and_out;
-
-		if (current->fsuid != inode->i_uid &&
-		    (error = vfs_permission(&nd, MAY_WRITE)) != 0)
-			goto dput_and_out;
+		if (get_user(tv[0].tv_sec, &times->actime) ||
+		    get_user(tv[1].tv_sec, &times->modtime))
+			return -EFAULT;
+		tv[0].tv_nsec = 0;
+		tv[1].tv_nsec = 0;
 	}
-	mutex_lock(&inode->i_mutex);
-	error = notify_change(nd.dentry, &newattrs);
-	mutex_unlock(&inode->i_mutex);
-dput_and_out:
-	path_release(&nd);
-out:
-	return error;
+	return do_utimes(AT_FDCWD, filename, times ? tv : NULL, 0);
 }
 
 #endif
@@ -76,18 +42,38 @@ out:
  * must be owner or have write permission.
  * Else, update from *times, must be owner or super user.
  */
-long do_utimes(int dfd, char __user *filename, struct timeval *times)
+long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags)
 {
 	int error;
 	struct nameidata nd;
-	struct inode * inode;
+	struct dentry *dentry;
+	struct inode *inode;
 	struct iattr newattrs;
+	struct file *f = NULL;
 
-	error = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW, &nd);
-
-	if (error)
+	error = -EINVAL;
+	if (flags & ~AT_SYMLINK_NOFOLLOW)
 		goto out;
-	inode = nd.dentry->d_inode;
+
+	if (filename == NULL && dfd != AT_FDCWD) {
+		error = -EINVAL;
+		if (flags & AT_SYMLINK_NOFOLLOW)
+			goto out;
+
+		error = -EBADF;
+		f = fget(dfd);
+		if (!f)
+			goto out;
+		dentry = f->f_path.dentry;
+	} else {
+		error = __user_walk_fd(dfd, filename, (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW, &nd);
+		if (error)
+			goto out;
+
+		dentry = nd.dentry;
+	}
+
+	inode = dentry->d_inode;
 
 	error = -EROFS;
 	if (IS_RDONLY(inode))
@@ -100,11 +86,21 @@ long do_utimes(int dfd, char __user *fil
                 if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
                         goto dput_and_out;
 
-		newattrs.ia_atime.tv_sec = times[0].tv_sec;
-		newattrs.ia_atime.tv_nsec = times[0].tv_usec * 1000;
-		newattrs.ia_mtime.tv_sec = times[1].tv_sec;
-		newattrs.ia_mtime.tv_nsec = times[1].tv_usec * 1000;
-		newattrs.ia_valid |= ATTR_ATIME_SET | ATTR_MTIME_SET;
+		if (times[0].tv_nsec == UTIME_OMIT)
+			newattrs.ia_valid &= ~ATTR_ATIME;
+		else if (times[0].tv_nsec != UTIME_NOW) {
+			newattrs.ia_atime.tv_sec = times[0].tv_sec;
+			newattrs.ia_atime.tv_nsec = times[0].tv_nsec;
+			newattrs.ia_valid |= ATTR_ATIME_SET;
+		}
+
+		if (times[1].tv_nsec == UTIME_OMIT)
+			newattrs.ia_valid &= ~ATTR_MTIME;
+		else if (times[1].tv_nsec != UTIME_NOW) {
+			newattrs.ia_mtime.tv_sec = times[1].tv_sec;
+			newattrs.ia_mtime.tv_nsec = times[1].tv_nsec;
+			newattrs.ia_valid |= ATTR_MTIME_SET;
+		}
 	} else {
 		error = -EACCES;
                 if (IS_IMMUTABLE(inode))
@@ -115,21 +111,67 @@ long do_utimes(int dfd, char __user *fil
 			goto dput_and_out;
 	}
 	mutex_lock(&inode->i_mutex);
-	error = notify_change(nd.dentry, &newattrs);
+	error = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 dput_and_out:
-	path_release(&nd);
+	if (f)
+		fput(f);
+	else
+		path_release(&nd);
 out:
 	return error;
 }
 
+asmlinkage long sys_utimensat(int dfd, char __user *filename, struct timespec __user *utimes, int flags)
+{
+	struct timespec tstimes[2];
+
+	if (utimes) {
+		if (copy_from_user(&tstimes, utimes, sizeof(tstimes)))
+			return -EFAULT;
+		if ((tstimes[0].tv_nsec == UTIME_OMIT ||
+		     tstimes[0].tv_nsec == UTIME_NOW) &&
+		    tstimes[0].tv_sec != 0)
+			return -EINVAL;
+		if ((tstimes[1].tv_nsec == UTIME_OMIT ||
+		     tstimes[1].tv_nsec == UTIME_NOW) &&
+		    tstimes[1].tv_sec != 0)
+			return -EINVAL;
+
+		/* Nothing to do, we must not even check the path.  */
+		if (tstimes[0].tv_nsec == UTIME_OMIT &&
+		    tstimes[1].tv_nsec == UTIME_OMIT)
+			return 0;
+	}
+
+	return do_utimes(dfd, filename, utimes ? tstimes : NULL, flags);
+}
+
 asmlinkage long sys_futimesat(int dfd, char __user *filename, struct timeval __user *utimes)
 {
 	struct timeval times[2];
+	struct timespec tstimes[2];
+
+	if (utimes) {
+		if (copy_from_user(&times, utimes, sizeof(times)))
+			return -EFAULT;
+
+		/* This test is needed to catch all invalid values.  If we
+		   would test only in do_utimes we would miss those invalid
+		   values truncated by the multiplication with 1000.  Note
+		   that we also catch UTIME_{NOW,OMIT} here which are only
+		   valid for utimensat.  */
+		if (times[0].tv_usec >= 1000000 || times[0].tv_usec < 0 ||
+		    times[1].tv_usec >= 1000000 || times[1].tv_usec < 0)
+			return -EINVAL;
+
+		tstimes[0].tv_sec = times[0].tv_sec;
+		tstimes[0].tv_nsec = 1000 * times[0].tv_usec;
+		tstimes[1].tv_sec = times[1].tv_sec;
+		tstimes[1].tv_nsec = 1000 * times[1].tv_usec;
+	}
 
-	if (utimes && copy_from_user(&times, utimes, sizeof(times)))
-		return -EFAULT;
-	return do_utimes(dfd, filename, utimes ? times : NULL);
+	return do_utimes(dfd, filename, utimes ? tstimes : NULL, 0);
 }
 
 asmlinkage long sys_utimes(char __user *filename, struct timeval __user *utimes)
diff -puN include/asm-i386/unistd.h~utimensat-implementation include/asm-i386/unistd.h
--- a/include/asm-i386/unistd.h~utimensat-implementation
+++ a/include/asm-i386/unistd.h
@@ -325,10 +325,11 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_utimensat		320
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 321
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff -puN include/asm-x86_64/unistd.h~utimensat-implementation include/asm-x86_64/unistd.h
--- a/include/asm-x86_64/unistd.h~utimensat-implementation
+++ a/include/asm-x86_64/unistd.h
@@ -619,6 +619,8 @@ __SYSCALL(__NR_sync_file_range, sys_sync
 __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages		279
 __SYSCALL(__NR_move_pages, sys_move_pages)
+#define __NR_utimensat		280
+__SYSCALL(__NR_utimensat, sys_utimensat)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff -puN include/linux/stat.h~utimensat-implementation include/linux/stat.h
--- a/include/linux/stat.h~utimensat-implementation
+++ a/include/linux/stat.h
@@ -53,6 +53,9 @@
 #define S_IWUGO		(S_IWUSR|S_IWGRP|S_IWOTH)
 #define S_IXUGO		(S_IXUSR|S_IXGRP|S_IXOTH)
 
+#define UTIME_NOW	((1l << 30) - 1l)
+#define UTIME_OMIT	((1l << 30) - 2l)
+
 #include <linux/types.h>
 #include <linux/time.h>
 
diff -puN include/linux/time.h~utimensat-implementation include/linux/time.h
--- a/include/linux/time.h~utimensat-implementation
+++ a/include/linux/time.h
@@ -109,7 +109,7 @@ extern void do_gettimeofday(struct timev
 extern int do_settimeofday(struct timespec *tv);
 extern int do_sys_settimeofday(struct timespec *tv, struct timezone *tz);
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
-extern long do_utimes(int dfd, char __user *filename, struct timeval *times);
+extern long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags);
 struct itimerval;
 extern int do_setitimer(int which, struct itimerval *value,
 			struct itimerval *ovalue);
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
aio-is-unlikely.patch
futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
futex_requeue_pi-optimization.patch

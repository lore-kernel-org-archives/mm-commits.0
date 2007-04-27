From: akpm@linux-foundation.org
Subject: - lutimesat-extend-do_utimes-with-flags.patch removed from -mm tree
Date: Fri, 27 Apr 2007 14:08:17 -0700
Message-ID: <200704272108.l3RL8H5G007795@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757304AbXD0VJJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 17:09:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@openvz.org, ak@suse.de, arnd@arndb.de, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     lutimesat: extend do_utimes() with flags
has been removed from the -mm tree.  Its filename was
     lutimesat-extend-do_utimes-with-flags.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: lutimesat: extend do_utimes() with flags
From: Alexey Dobriyan <adobriyan@openvz.org>

Passing AT_SYMLINK_NOFOLLOW will stop following symlinks.  Pass 0 to get
usual behaviour.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/osf_sys.c       |    2 +-
 arch/sparc64/kernel/sys_sparc32.c |    2 +-
 fs/compat.c                       |    4 ++--
 fs/utimes.c                       |   15 ++++++++++-----
 include/linux/time.h              |    2 +-
 5 files changed, 15 insertions(+), 10 deletions(-)

diff -puN arch/alpha/kernel/osf_sys.c~lutimesat-extend-do_utimes-with-flags arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~lutimesat-extend-do_utimes-with-flags
+++ a/arch/alpha/kernel/osf_sys.c
@@ -961,7 +961,7 @@ osf_utimes(char __user *filename, struct
 			return -EFAULT;
 	}
 
-	return do_utimes(AT_FDCWD, filename, tvs ? ktvs : NULL);
+	return do_utimes(AT_FDCWD, filename, tvs ? ktvs : NULL, 0);
 }
 
 #define MAX_SELECT_SECONDS \
diff -puN arch/sparc64/kernel/sys_sparc32.c~lutimesat-extend-do_utimes-with-flags arch/sparc64/kernel/sys_sparc32.c
--- a/arch/sparc64/kernel/sys_sparc32.c~lutimesat-extend-do_utimes-with-flags
+++ a/arch/sparc64/kernel/sys_sparc32.c
@@ -783,7 +783,7 @@ asmlinkage long sys32_utimes(char __user
 			return -EFAULT;
 	}
 
-	return do_utimes(AT_FDCWD, filename, (tvs ? &ktvs[0] : NULL));
+	return do_utimes(AT_FDCWD, filename, (tvs ? &ktvs[0] : NULL), 0);
 }
 
 /* These are here just in case some old sparc32 binary calls it. */
diff -puN fs/compat.c~lutimesat-extend-do_utimes-with-flags fs/compat.c
--- a/fs/compat.c~lutimesat-extend-do_utimes-with-flags
+++ a/fs/compat.c
@@ -86,7 +86,7 @@ asmlinkage long compat_sys_utime(char __
 		tv[0].tv_usec = 0;
 		tv[1].tv_usec = 0;
 	}
-	return do_utimes(AT_FDCWD, filename, t ? tv : NULL);
+	return do_utimes(AT_FDCWD, filename, t ? tv : NULL, 0);
 }
 
 asmlinkage long compat_sys_futimesat(unsigned int dfd, char __user *filename, struct compat_timeval __user *t)
@@ -100,7 +100,7 @@ asmlinkage long compat_sys_futimesat(uns
 		    get_user(tv[1].tv_usec, &t[1].tv_usec))
 			return -EFAULT;
 	}
-	return do_utimes(dfd, filename, t ? tv : NULL);
+	return do_utimes(dfd, filename, t ? tv : NULL, 0);
 }
 
 asmlinkage long compat_sys_utimes(char __user *filename, struct compat_timeval __user *t)
diff -puN fs/utimes.c~lutimesat-extend-do_utimes-with-flags fs/utimes.c
--- a/fs/utimes.c~lutimesat-extend-do_utimes-with-flags
+++ a/fs/utimes.c
@@ -31,7 +31,7 @@ asmlinkage long sys_utime(char __user * 
 		tv[0].tv_usec = 0;
 		tv[1].tv_usec = 0;
 	}
-	return do_utimes(AT_FDCWD, filename, times ? tv : NULL);
+	return do_utimes(AT_FDCWD, filename, times ? tv : NULL, 0);
 }
 
 #endif
@@ -40,14 +40,19 @@ asmlinkage long sys_utime(char __user * 
  * must be owner or have write permission.
  * Else, update from *times, must be owner or super user.
  */
-long do_utimes(int dfd, char __user *filename, struct timeval *times)
+long do_utimes(int dfd, char __user *filename, struct timeval *times, int flags)
 {
-	int error;
+	int error = -EINVAL;
 	struct nameidata nd;
 	struct inode * inode;
 	struct iattr newattrs;
+	int follow;
 
-	error = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW, &nd);
+	if ((flags & ~AT_SYMLINK_NOFOLLOW) != 0)
+		goto out;
+
+	follow = (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
+	error = __user_walk_fd(dfd, filename, follow, &nd);
 
 	if (error)
 		goto out;
@@ -93,7 +98,7 @@ asmlinkage long sys_futimesat(int dfd, c
 
 	if (utimes && copy_from_user(&times, utimes, sizeof(times)))
 		return -EFAULT;
-	return do_utimes(dfd, filename, utimes ? times : NULL);
+	return do_utimes(dfd, filename, utimes ? times : NULL, 0);
 }
 
 asmlinkage long sys_utimes(char __user *filename, struct timeval __user *utimes)
diff -puN include/linux/time.h~lutimesat-extend-do_utimes-with-flags include/linux/time.h
--- a/include/linux/time.h~lutimesat-extend-do_utimes-with-flags
+++ a/include/linux/time.h
@@ -109,7 +109,7 @@ extern void do_gettimeofday(struct timev
 extern int do_settimeofday(struct timespec *tv);
 extern int do_sys_settimeofday(struct timespec *tv, struct timezone *tz);
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
-extern long do_utimes(int dfd, char __user *filename, struct timeval *times);
+extern long do_utimes(int dfd, char __user *filename, struct timeval *times, int flags);
 struct itimerval;
 extern int do_setitimer(int which, struct itimerval *value,
 			struct itimerval *ovalue);
_

Patches currently in -mm which might be from adobriyan@openvz.org are

git-parisc.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
utimensat-implementation.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch

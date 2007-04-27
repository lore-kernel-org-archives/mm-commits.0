From: akpm@linux-foundation.org
Subject: - lutimesat-compat-syscall-and-wire-up-on-x86_64.patch removed from -mm tree
Date: Fri, 27 Apr 2007 14:08:27 -0700
Message-ID: <200704272108.l3RL8Rlw007803@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757300AbXD0VIh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 17:08:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@openvz.org, ak@suse.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     lutimesat: compat syscall and wire up on x86_64
has been removed from the -mm tree.  Its filename was
     lutimesat-compat-syscall-and-wire-up-on-x86_64.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: lutimesat: compat syscall and wire up on x86_64
From: Alexey Dobriyan <adobriyan@openvz.org>

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32entry.S |    1 +
 fs/compat.c                  |   14 ++++++++++++++
 fs/utimes.c                  |    2 +-
 include/linux/time.h         |    1 +
 4 files changed, 17 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/ia32/ia32entry.S~lutimesat-compat-syscall-and-wire-up-on-x86_64 arch/x86_64/ia32/ia32entry.S
--- a/arch/x86_64/ia32/ia32entry.S~lutimesat-compat-syscall-and-wire-up-on-x86_64
+++ a/arch/x86_64/ia32/ia32entry.S
@@ -715,4 +715,5 @@ ia32_sys_call_table:
 	.quad compat_sys_move_pages
 	.quad sys_getcpu
 	.quad sys_epoll_pwait
+	.quad compat_sys_lutimesat
 ia32_syscall_end:		
diff -puN fs/compat.c~lutimesat-compat-syscall-and-wire-up-on-x86_64 fs/compat.c
--- a/fs/compat.c~lutimesat-compat-syscall-and-wire-up-on-x86_64
+++ a/fs/compat.c
@@ -108,6 +108,20 @@ asmlinkage long compat_sys_utimes(char _
 	return compat_sys_futimesat(AT_FDCWD, filename, t);
 }
 
+asmlinkage long compat_sys_lutimesat(int dfd, char __user *filename,
+				struct compat_timespec __user *utimes)
+{
+	struct timespec ts[2];
+
+	if (utimes) {
+		if (get_compat_timespec(&ts[0], &utimes[0]) ||
+		    get_compat_timespec(&ts[1], &utimes[1]))
+			return -EFAULT;
+	}
+	return do_utimes_nsec(dfd, filename,
+			utimes ? ts : NULL, AT_SYMLINK_NOFOLLOW);
+}
+
 asmlinkage long compat_sys_newstat(char __user * filename,
 		struct compat_stat __user *statbuf)
 {
diff -puN fs/utimes.c~lutimesat-compat-syscall-and-wire-up-on-x86_64 fs/utimes.c
--- a/fs/utimes.c~lutimesat-compat-syscall-and-wire-up-on-x86_64
+++ a/fs/utimes.c
@@ -40,7 +40,7 @@ asmlinkage long sys_utime(char __user * 
  * must be owner or have write permission.
  * Else, update from *times, must be owner or super user.
  */
-static long do_utimes_nsec(int dfd, char __user *filename, struct timespec *times, int flags)
+long do_utimes_nsec(int dfd, char __user *filename, struct timespec *times, int flags)
 {
 	int error = -EINVAL;
 	struct nameidata nd;
diff -puN include/linux/time.h~lutimesat-compat-syscall-and-wire-up-on-x86_64 include/linux/time.h
--- a/include/linux/time.h~lutimesat-compat-syscall-and-wire-up-on-x86_64
+++ a/include/linux/time.h
@@ -110,6 +110,7 @@ extern int do_settimeofday(struct timesp
 extern int do_sys_settimeofday(struct timespec *tv, struct timezone *tz);
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
 extern long do_utimes(int dfd, char __user *filename, struct timeval *times, int flags);
+extern long do_utimes_nsec(int dfd, char __user *filename, struct timespec *times, int flags);
 struct itimerval;
 extern int do_setitimer(int which, struct itimerval *value,
 			struct itimerval *ovalue);
_

Patches currently in -mm which might be from adobriyan@openvz.org are

git-parisc.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
utimensat-implementation.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch

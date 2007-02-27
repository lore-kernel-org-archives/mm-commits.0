From: akpm@linux-foundation.org
Subject: + lutimesat-compat-syscall-and-wire-up-on-x86_64.patch added to -mm tree
Date: Tue, 27 Feb 2007 13:02:18 -0800
Message-ID: <200702272102.l1RL2M3O028532@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52091 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbXB0VCf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:02:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@openvz.org, ak@suse.de, sfr@canb.auug.org.au


The patch titled
     lutimesat: compat syscall and wire up on x86_64
has been added to the -mm tree.  Its filename is
     lutimesat-compat-syscall-and-wire-up-on-x86_64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lutimesat: compat syscall and wire up on x86_64
From: Alexey Dobriyan <adobriyan@openvz.org>

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32entry.S |    1 +
 fs/compat.c                  |   16 ++++++++++++++++
 fs/utimes.c                  |    2 +-
 include/linux/time.h         |    1 +
 4 files changed, 19 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/ia32/ia32entry.S~lutimesat-compat-syscall-and-wire-up-on-x86_64 arch/x86_64/ia32/ia32entry.S
--- a/arch/x86_64/ia32/ia32entry.S~lutimesat-compat-syscall-and-wire-up-on-x86_64
+++ a/arch/x86_64/ia32/ia32entry.S
@@ -720,4 +720,5 @@ ia32_sys_call_table:
 	.quad sys_getcpu
 	.quad sys_epoll_pwait
 	.quad compat_sys_lio_submit	/* 320 */
+	.quad compat_sys_lutimesat
 ia32_syscall_end:
diff -puN fs/compat.c~lutimesat-compat-syscall-and-wire-up-on-x86_64 fs/compat.c
--- a/fs/compat.c~lutimesat-compat-syscall-and-wire-up-on-x86_64
+++ a/fs/compat.c
@@ -110,6 +110,22 @@ asmlinkage long compat_sys_utimes(char _
 	return compat_sys_futimesat(AT_FDCWD, filename, t);
 }
 
+asmlinkage long compat_sys_lutimesat(int dfd, char __user *filename,
+				struct compat_timespec __user *utimes)
+{
+	struct timespec ts[2];
+
+	if (utimes) {
+		if (get_user(ts[0].tv_sec, &utimes[0].tv_sec) ||
+		    get_user(ts[0].tv_nsec, &utimes[0].tv_nsec) ||
+		    get_user(ts[1].tv_sec, &utimes[1].tv_sec) ||
+		    get_user(ts[1].tv_nsec, &utimes[1].tv_nsec))
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

git-cpufreq.patch
ia64-sync-compat-getdents-on-ia64-and-parisc.patch
parisc-sync-compat-getdents-on-ia64-and-parisc.patch
x86_64-wire-up-compat-sched_rr_get_interval2.patch
fix-rmmod-read-write-races-in-proc-entries.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
lutimesat-simplify-utime2.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch

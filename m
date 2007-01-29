From: akpm@osdl.org
Subject: + lutimesat-actual-syscall-and-wire-up-on-i386.patch added to -mm tree
Date: Mon, 29 Jan 2007 15:37:09 -0800
Message-ID: <200701292337.l0TNb9H6002675@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33853 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965005AbXA2Xh1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 18:37:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@openvz.org, ak@suse.de, arnd@arndb.de, drepper@redhat.com, mtk-manpages@gmx.net


The patch titled
     lutimesat: actual syscall and wire-up on i386
has been added to the -mm tree.  Its filename is
     lutimesat-actual-syscall-and-wire-up-on-i386.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lutimesat: actual syscall and wire-up on i386
From: Alexey Dobriyan <adobriyan@openvz.org>

lutimesat(2) does everything futimesat(2) does except it doesn't follow
symlinks. It could be used by tar(1) and cp(1).

FreeBSD and NetBSD have lutimes(2) which can be emulated by C library.

lutimesat(2) accepts "struct timespec" which means timestamps with nanosecond
granularity. Tested on XFS which has nanosecond timestamps on-disk.

Changes to do_utimes() which is used by all existing utime* syscalls pass
LTP utime tests.

Closes http://bugme.osdl.org/show_bug.cgi?id=4433

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/syscall_table.S |    1 
 fs/utimes.c                      |   30 ++++++++++++++++++++++++-----
 include/asm-i386/unistd.h        |    3 +-
 3 files changed, 28 insertions(+), 6 deletions(-)

diff -puN arch/i386/kernel/syscall_table.S~lutimesat-actual-syscall-and-wire-up-on-i386 arch/i386/kernel/syscall_table.S
--- a/arch/i386/kernel/syscall_table.S~lutimesat-actual-syscall-and-wire-up-on-i386
+++ a/arch/i386/kernel/syscall_table.S
@@ -319,3 +319,4 @@ ENTRY(sys_call_table)
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_lutimesat		/* 320 */
diff -puN fs/utimes.c~lutimesat-actual-syscall-and-wire-up-on-i386 fs/utimes.c
--- a/fs/utimes.c~lutimesat-actual-syscall-and-wire-up-on-i386
+++ a/fs/utimes.c
@@ -40,7 +40,7 @@ asmlinkage long sys_utime(char __user * 
  * must be owner or have write permission.
  * Else, update from *times, must be owner or super user.
  */
-long do_utimes(int dfd, char __user *filename, struct timeval *times, int flags)
+static long do_utimes_nsec(int dfd, char __user *filename, struct timespec *times, int flags)
 {
 	int error = -EINVAL;
 	struct nameidata nd;
@@ -69,10 +69,8 @@ long do_utimes(int dfd, char __user *fil
                 if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
                         goto dput_and_out;
 
-		newattrs.ia_atime.tv_sec = times[0].tv_sec;
-		newattrs.ia_atime.tv_nsec = times[0].tv_usec * 1000;
-		newattrs.ia_mtime.tv_sec = times[1].tv_sec;
-		newattrs.ia_mtime.tv_nsec = times[1].tv_usec * 1000;
+		newattrs.ia_atime = times[0];
+		newattrs.ia_mtime = times[1];
 		newattrs.ia_valid |= ATTR_ATIME_SET | ATTR_MTIME_SET;
 	} else {
 		error = -EACCES;
@@ -92,6 +90,19 @@ out:
 	return error;
 }
 
+long do_utimes(int dfd, char __user *filename, struct timeval *times, int flags)
+{
+	struct timespec ts[2];
+
+	if (times) {
+		ts[0].tv_sec = times[0].tv_sec;
+		ts[0].tv_nsec = times[0].tv_usec * 1000;
+		ts[1].tv_sec = times[1].tv_sec;
+		ts[1].tv_nsec = times[1].tv_usec * 1000;
+	}
+	return do_utimes_nsec(dfd, filename, times ? ts : NULL, flags);
+}
+
 asmlinkage long sys_futimesat(int dfd, char __user *filename, struct timeval __user *utimes)
 {
 	struct timeval times[2];
@@ -105,3 +116,12 @@ asmlinkage long sys_utimes(char __user *
 {
 	return sys_futimesat(AT_FDCWD, filename, utimes);
 }
+
+asmlinkage long sys_lutimesat(int dfd, char __user *filename, struct timespec __user *utimes)
+{
+	struct timespec times[2];
+
+	if (utimes && copy_from_user(&times, utimes, sizeof(times)))
+		return -EFAULT;
+	return do_utimes_nsec(dfd, filename, utimes ? times : NULL, AT_SYMLINK_NOFOLLOW);
+}
diff -puN include/asm-i386/unistd.h~lutimesat-actual-syscall-and-wire-up-on-i386 include/asm-i386/unistd.h
--- a/include/asm-i386/unistd.h~lutimesat-actual-syscall-and-wire-up-on-i386
+++ a/include/asm-i386/unistd.h
@@ -325,10 +325,11 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_lutimesat		320
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 321
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
_

Patches currently in -mm which might be from adobriyan@openvz.org are

origin.patch
revert-x86_64-mm-msr-on-cpu.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
consolidate-default-sched_clock.patch
fix-rmmod-read-write-races-in-proc-entries.patch
consolidate-bust_spinlocks.patch
extract-and-use-wake_up_klogd.patch
introduce-and-use-get_task_mnt_ns.patch
introduce-and-use-get_task_mnt_ns-tweaks.patch
lutimesat-simplify-utime2.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch

From: akpm@linux-foundation.org
Subject: [merged] compat-generic-compat_sys_sched_rr_get_interval-implementation.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:06:39 -0800
Message-ID: <20121218200639.D61E3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:48109 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab2LRUGl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:06:41 -0500
Received: by mail-qa0-f73.google.com with SMTP id a19so157686qad.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:06:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, arnd@arndb.de, benh@kernel.crashing.org, cmetcalf@tilera.com, davem@davemloft.net, paulus@samba.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: compat: generic compat_sys_sched_rr_get_interval() implementation
has been removed from the -mm tree.  Its filename was
     compat-generic-compat_sys_sched_rr_get_interval-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: compat: generic compat_sys_sched_rr_get_interval() implementation

This function is used by sparc, powerpc tile and arm64 for compat support.
 The patch adds a generic implementation with a wrapper for PowerPC to do
the u32->int sign extension.

The reason for a single patch covering powerpc, tile, sparc and arm64 is
to keep it bisectable, otherwise kernel building may fail with mismatched
function declarations.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>  [for tile]
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/unistd.h   |    1 +
 arch/arm64/kernel/sys_compat.c    |   15 ---------------
 arch/powerpc/include/asm/systbl.h |    2 +-
 arch/powerpc/include/asm/unistd.h |    1 +
 arch/powerpc/kernel/sys_ppc32.c   |   15 +++------------
 arch/sparc/include/asm/unistd.h   |    1 +
 arch/sparc/kernel/sys_sparc32.c   |   14 --------------
 arch/tile/include/asm/compat.h    |    2 --
 arch/tile/include/asm/unistd.h    |    1 +
 arch/tile/kernel/compat.c         |   18 ------------------
 include/linux/compat.h            |    3 +++
 kernel/compat.c                   |   17 +++++++++++++++++
 12 files changed, 28 insertions(+), 62 deletions(-)

diff -puN arch/arm64/include/asm/unistd.h~compat-generic-compat_sys_sched_rr_get_interval-implementation arch/arm64/include/asm/unistd.h
--- a/arch/arm64/include/asm/unistd.h~compat-generic-compat_sys_sched_rr_get_interval-implementation
+++ a/arch/arm64/include/asm/unistd.h
@@ -20,6 +20,7 @@
 #define __ARCH_WANT_SYS_GETPGRP
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
+#define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
diff -puN arch/arm64/kernel/sys_compat.c~compat-generic-compat_sys_sched_rr_get_interval-implementation arch/arm64/kernel/sys_compat.c
--- a/arch/arm64/kernel/sys_compat.c~compat-generic-compat_sys_sched_rr_get_interval-implementation
+++ a/arch/arm64/kernel/sys_compat.c
@@ -28,21 +28,6 @@
 #include <asm/cacheflush.h>
 #include <asm/unistd32.h>
 
-asmlinkage int compat_sys_sched_rr_get_interval(compat_pid_t pid,
-						struct compat_timespec __user *interval)
-{
-	struct timespec t;
-	int ret;
-	mm_segment_t old_fs = get_fs();
-
-	set_fs(KERNEL_DS);
-	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *)&t);
-	set_fs(old_fs);
-	if (put_compat_timespec(&t, interval))
-		return -EFAULT;
-	return ret;
-}
-
 static inline void
 do_compat_cache_op(unsigned long start, unsigned long end, int flags)
 {
diff -puN arch/powerpc/include/asm/systbl.h~compat-generic-compat_sys_sched_rr_get_interval-implementation arch/powerpc/include/asm/systbl.h
--- a/arch/powerpc/include/asm/systbl.h~compat-generic-compat_sys_sched_rr_get_interval-implementation
+++ a/arch/powerpc/include/asm/systbl.h
@@ -164,7 +164,7 @@ COMPAT_SYS_SPU(sched_getscheduler)
 SYSCALL_SPU(sched_yield)
 COMPAT_SYS_SPU(sched_get_priority_max)
 COMPAT_SYS_SPU(sched_get_priority_min)
-COMPAT_SYS_SPU(sched_rr_get_interval)
+SYSX_SPU(sys_sched_rr_get_interval,compat_sys_sched_rr_get_interval_wrapper,sys_sched_rr_get_interval)
 COMPAT_SYS_SPU(nanosleep)
 SYSCALL_SPU(mremap)
 SYSCALL_SPU(setresuid)
diff -puN arch/powerpc/include/asm/unistd.h~compat-generic-compat_sys_sched_rr_get_interval-implementation arch/powerpc/include/asm/unistd.h
--- a/arch/powerpc/include/asm/unistd.h~compat-generic-compat_sys_sched_rr_get_interval-implementation
+++ a/arch/powerpc/include/asm/unistd.h
@@ -54,6 +54,7 @@
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_SYS_NEWFSTATAT
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
+#define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
 #endif
 #define __ARCH_WANT_SYS_EXECVE
 #define __ARCH_WANT_SYS_FORK
diff -puN arch/powerpc/kernel/sys_ppc32.c~compat-generic-compat_sys_sched_rr_get_interval-implementation arch/powerpc/kernel/sys_ppc32.c
--- a/arch/powerpc/kernel/sys_ppc32.c~compat-generic-compat_sys_sched_rr_get_interval-implementation
+++ a/arch/powerpc/kernel/sys_ppc32.c
@@ -175,19 +175,10 @@ asmlinkage long compat_sys_prctl(u32 opt
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_sched_rr_get_interval(u32 pid, struct compat_timespec __user *interval)
+asmlinkage long compat_sys_sched_rr_get_interval_wrapper(u32 pid,
+							 struct compat_timespec __user *interval)
 {
-	struct timespec t;
-	int ret;
-	mm_segment_t old_fs = get_fs ();
-
-	/* The __user pointer cast is valid because of the set_fs() */
-	set_fs (KERNEL_DS);
-	ret = sys_sched_rr_get_interval((int)pid, (struct timespec __user *) &t);
-	set_fs (old_fs);
-	if (put_compat_timespec(&t, interval))
-		return -EFAULT;
-	return ret;
+	return compat_sys_sched_rr_get_interval((int)pid, interval);
 }
 
 /* Note: it is necessary to treat mode as an unsigned int,
diff -puN arch/sparc/include/asm/unistd.h~compat-generic-compat_sys_sched_rr_get_interval-implementation arch/sparc/include/asm/unistd.h
--- a/arch/sparc/include/asm/unistd.h~compat-generic-compat_sys_sched_rr_get_interval-implementation
+++ a/arch/sparc/include/asm/unistd.h
@@ -45,6 +45,7 @@
 #define __ARCH_WANT_COMPAT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_COMPAT_SYS_SENDFILE
+#define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
 #endif
 #define __ARCH_WANT_SYS_EXECVE
 
diff -puN arch/sparc/kernel/sys_sparc32.c~compat-generic-compat_sys_sched_rr_get_interval-implementation arch/sparc/kernel/sys_sparc32.c
--- a/arch/sparc/kernel/sys_sparc32.c~compat-generic-compat_sys_sched_rr_get_interval-implementation
+++ a/arch/sparc/kernel/sys_sparc32.c
@@ -211,20 +211,6 @@ asmlinkage long compat_sys_sysfs(int opt
 	return sys_sysfs(option, arg1, arg2);
 }
 
-asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid, struct compat_timespec __user *interval)
-{
-	struct timespec t;
-	int ret;
-	mm_segment_t old_fs = get_fs ();
-	
-	set_fs (KERNEL_DS);
-	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *) &t);
-	set_fs (old_fs);
-	if (put_compat_timespec(&t, interval))
-		return -EFAULT;
-	return ret;
-}
-
 asmlinkage long compat_sys_rt_sigprocmask(int how,
 					  compat_sigset_t __user *set,
 					  compat_sigset_t __user *oset,
diff -puN arch/tile/include/asm/compat.h~compat-generic-compat_sys_sched_rr_get_interval-implementation arch/tile/include/asm/compat.h
--- a/arch/tile/include/asm/compat.h~compat-generic-compat_sys_sched_rr_get_interval-implementation
+++ a/arch/tile/include/asm/compat.h
@@ -296,8 +296,6 @@ long compat_sys_sync_file_range2(int fd,
 long compat_sys_fallocate(int fd, int mode,
 			  u32 offset_lo, u32 offset_hi,
 			  u32 len_lo, u32 len_hi);
-long compat_sys_sched_rr_get_interval(compat_pid_t pid,
-				      struct compat_timespec __user *interval);
 
 /* Assembly trampoline to avoid clobbering r0. */
 long _compat_sys_rt_sigreturn(void);
diff -puN arch/tile/include/asm/unistd.h~compat-generic-compat_sys_sched_rr_get_interval-implementation arch/tile/include/asm/unistd.h
--- a/arch/tile/include/asm/unistd.h~compat-generic-compat_sys_sched_rr_get_interval-implementation
+++ a/arch/tile/include/asm/unistd.h
@@ -14,6 +14,7 @@
 /* In compat mode, we use sys_llseek() for compat_sys_llseek(). */
 #ifdef CONFIG_COMPAT
 #define __ARCH_WANT_SYS_LLSEEK
+#define __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
 #endif
 #define __ARCH_WANT_SYS_NEWFSTATAT
 #define __ARCH_WANT_SYS_EXECVE
diff -puN arch/tile/kernel/compat.c~compat-generic-compat_sys_sched_rr_get_interval-implementation arch/tile/kernel/compat.c
--- a/arch/tile/kernel/compat.c~compat-generic-compat_sys_sched_rr_get_interval-implementation
+++ a/arch/tile/kernel/compat.c
@@ -76,24 +76,6 @@ long compat_sys_fallocate(int fd, int mo
 			     ((loff_t)len_hi << 32) | len_lo);
 }
 
-
-
-long compat_sys_sched_rr_get_interval(compat_pid_t pid,
-				      struct compat_timespec __user *interval)
-{
-	struct timespec t;
-	int ret;
-	mm_segment_t old_fs = get_fs();
-
-	set_fs(KERNEL_DS);
-	ret = sys_sched_rr_get_interval(pid,
-					(struct timespec __force __user *)&t);
-	set_fs(old_fs);
-	if (put_compat_timespec(&t, interval))
-		return -EFAULT;
-	return ret;
-}
-
 /* Provide the compat syscall number to call mapping. */
 #undef __SYSCALL
 #define __SYSCALL(nr, call) [nr] = (call),
diff -puN include/linux/compat.h~compat-generic-compat_sys_sched_rr_get_interval-implementation include/linux/compat.h
--- a/include/linux/compat.h~compat-generic-compat_sys_sched_rr_get_interval-implementation
+++ a/include/linux/compat.h
@@ -588,6 +588,9 @@ asmlinkage ssize_t compat_sys_process_vm
 asmlinkage long compat_sys_sendfile(int out_fd, int in_fd,
 				    compat_off_t __user *offset, compat_size_t count);
 
+asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid,
+						 struct compat_timespec __user *interval);
+
 #else
 
 #define is_compat_task() (0)
diff -puN kernel/compat.c~compat-generic-compat_sys_sched_rr_get_interval-implementation kernel/compat.c
--- a/kernel/compat.c~compat-generic-compat_sys_sched_rr_get_interval-implementation
+++ a/kernel/compat.c
@@ -1215,6 +1215,23 @@ compat_sys_sysinfo(struct compat_sysinfo
 	return 0;
 }
 
+#ifdef __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL
+asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid,
+						 struct compat_timespec __user *interval)
+{
+	struct timespec t;
+	int ret;
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(KERNEL_DS);
+	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *)&t);
+	set_fs(old_fs);
+	if (put_compat_timespec(&t, interval))
+		return -EFAULT;
+	return ret;
+}
+#endif /* __ARCH_WANT_COMPAT_SYS_SCHED_RR_GET_INTERVAL */
+
 /*
  * Allocate user-space memory for the duration of a single system call,
  * in order to marshall parameters inside a compat thunk.
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
mm-kmemleakc-remove-obsolete-simple_strtoul.patch


From: akpm@linux-foundation.org
Subject: [merged] add-generic-sys_old_select.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:55:19 -0400
Message-ID: <201003150655.o2F6tqLc016176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935715Ab0COG6i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, arnd@arndb.de, benh@kernel.crashing.org, dhowells@redhat.com, gerg@uclinux.org, heiko.carstens@de.ibm.com, hpa@zytor.com, jdike@addtoit.com, jmorris@namei.org, lethal@linu


The patch titled
     Add generic sys_old_select()
has been removed from the -mm tree.  Its filename was
     add-generic-sys_old_select.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add generic sys_old_select()
From: Christoph Hellwig <hch@lst.de>

Add a generic implementation of the old select() syscall, which expects
its argument in a memory block and switch all architectures over to use
it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: James Morris <jmorris@namei.org>
Acked-by: Andreas Schwab <schwab@linux-m68k.org>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/unistd.h        |    1 +
 arch/arm/kernel/calls.S              |    2 +-
 arch/arm/kernel/sys_arm.c            |   21 ---------------------
 arch/h8300/include/asm/unistd.h      |    1 +
 arch/h8300/kernel/sys_h8300.c        |   16 ----------------
 arch/h8300/kernel/syscalls.S         |    2 +-
 arch/m68k/include/asm/unistd.h       |    1 +
 arch/m68k/kernel/entry.S             |    2 +-
 arch/m68k/kernel/sys_m68k.c          |   16 ----------------
 arch/m68knommu/kernel/sys_m68k.c     |   16 ----------------
 arch/m68knommu/kernel/syscalltable.S |    2 +-
 arch/mn10300/include/asm/unistd.h    |    1 +
 arch/mn10300/kernel/entry.S          |    2 +-
 arch/mn10300/kernel/sys_mn10300.c    |   18 ------------------
 arch/s390/kernel/entry.h             |    1 -
 arch/um/sys-i386/syscalls.c          |   18 ------------------
 arch/x86/ia32/ia32entry.S            |    2 +-
 arch/x86/ia32/sys_ia32.c             |   18 ------------------
 arch/x86/include/asm/sys_ia32.h      |    2 --
 arch/x86/include/asm/syscalls.h      |    2 --
 arch/x86/include/asm/unistd_32.h     |    1 +
 arch/x86/kernel/sys_i386_32.c        |   17 -----------------
 arch/x86/kernel/syscall_table_32.S   |    2 +-
 fs/compat.c                          |   18 ++++++++++++++++++
 fs/select.c                          |   17 +++++++++++++++++
 include/linux/compat.h               |    3 +++
 include/linux/syscalls.h             |    2 ++
 27 files changed, 52 insertions(+), 152 deletions(-)

diff -puN arch/arm/include/asm/unistd.h~add-generic-sys_old_select arch/arm/include/asm/unistd.h
--- a/arch/arm/include/asm/unistd.h~add-generic-sys_old_select
+++ a/arch/arm/include/asm/unistd.h
@@ -443,6 +443,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_OLD_SELECT
 
 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
 #define __ARCH_WANT_SYS_TIME
diff -puN arch/arm/kernel/calls.S~add-generic-sys_old_select arch/arm/kernel/calls.S
--- a/arch/arm/kernel/calls.S~add-generic-sys_old_select
+++ a/arch/arm/kernel/calls.S
@@ -91,7 +91,7 @@
 		CALL(sys_settimeofday)
 /* 80 */	CALL(sys_getgroups16)
 		CALL(sys_setgroups16)
-		CALL(OBSOLETE(old_select))	/* used by libc4 */
+		CALL(OBSOLETE(sys_old_select))	/* used by libc4 */
 		CALL(sys_symlink)
 		CALL(sys_ni_syscall)		/* was sys_lstat */
 /* 85 */	CALL(sys_readlink)
diff -puN arch/arm/kernel/sys_arm.c~add-generic-sys_old_select arch/arm/kernel/sys_arm.c
--- a/arch/arm/kernel/sys_arm.c~add-generic-sys_old_select
+++ a/arch/arm/kernel/sys_arm.c
@@ -54,27 +54,6 @@ out:
 	return error;
 }
 
-/*
- * Perform the select(nd, in, out, ex, tv) and mmap() system
- * calls.
- */
-
-struct sel_arg_struct {
-	unsigned long n;
-	fd_set __user *inp, *outp, *exp;
-	struct timeval __user *tvp;
-};
-
-asmlinkage int old_select(struct sel_arg_struct __user *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	/* sys_select() does the appropriate kernel locking */
-	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
-}
-
 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
diff -puN arch/h8300/include/asm/unistd.h~add-generic-sys_old_select arch/h8300/include/asm/unistd.h
--- a/arch/h8300/include/asm/unistd.h~add-generic-sys_old_select
+++ a/arch/h8300/include/asm/unistd.h
@@ -348,6 +348,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
diff -puN arch/h8300/kernel/sys_h8300.c~add-generic-sys_old_select arch/h8300/kernel/sys_h8300.c
--- a/arch/h8300/kernel/sys_h8300.c~add-generic-sys_old_select
+++ a/arch/h8300/kernel/sys_h8300.c
@@ -60,22 +60,6 @@ out:
 	return error;
 }
 
-struct sel_arg_struct {
-	unsigned long n;
-	fd_set *inp, *outp, *exp;
-	struct timeval *tvp;
-};
-
-asmlinkage int old_select(struct sel_arg_struct *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	/* sys_select() does the appropriate kernel locking */
-	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
-}
-
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
diff -puN arch/h8300/kernel/syscalls.S~add-generic-sys_old_select arch/h8300/kernel/syscalls.S
--- a/arch/h8300/kernel/syscalls.S~add-generic-sys_old_select
+++ a/arch/h8300/kernel/syscalls.S
@@ -96,7 +96,7 @@ SYMBOL_NAME_LABEL(sys_call_table)	
 	.long SYMBOL_NAME(sys_settimeofday)
 	.long SYMBOL_NAME(sys_getgroups16)	/* 80 */
 	.long SYMBOL_NAME(sys_setgroups16)
-	.long SYMBOL_NAME(old_select)
+	.long SYMBOL_NAME(sys_old_select)
 	.long SYMBOL_NAME(sys_symlink)
 	.long SYMBOL_NAME(sys_lstat)
 	.long SYMBOL_NAME(sys_readlink)		/* 85 */
diff -puN arch/m68k/include/asm/unistd.h~add-generic-sys_old_select arch/m68k/include/asm/unistd.h
--- a/arch/m68k/include/asm/unistd.h~add-generic-sys_old_select
+++ a/arch/m68k/include/asm/unistd.h
@@ -363,6 +363,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
diff -puN arch/m68k/kernel/entry.S~add-generic-sys_old_select arch/m68k/kernel/entry.S
--- a/arch/m68k/kernel/entry.S~add-generic-sys_old_select
+++ a/arch/m68k/kernel/entry.S
@@ -510,7 +510,7 @@ sys_call_table:
 	.long sys_settimeofday
 	.long sys_getgroups16	/* 80 */
 	.long sys_setgroups16
-	.long old_select
+	.long sys_old_select
 	.long sys_symlink
 	.long sys_lstat
 	.long sys_readlink	/* 85 */
diff -puN arch/m68k/kernel/sys_m68k.c~add-generic-sys_old_select arch/m68k/kernel/sys_m68k.c
--- a/arch/m68k/kernel/sys_m68k.c~add-generic-sys_old_select
+++ a/arch/m68k/kernel/sys_m68k.c
@@ -80,22 +80,6 @@ out:
 	return error;
 }
 
-struct sel_arg_struct {
-	unsigned long n;
-	fd_set __user *inp, *outp, *exp;
-	struct timeval __user *tvp;
-};
-
-asmlinkage int old_select(struct sel_arg_struct __user *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	/* sys_select() does the appropriate kernel locking */
-	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
-}
-
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
diff -puN arch/m68knommu/kernel/sys_m68k.c~add-generic-sys_old_select arch/m68knommu/kernel/sys_m68k.c
--- a/arch/m68knommu/kernel/sys_m68k.c~add-generic-sys_old_select
+++ a/arch/m68knommu/kernel/sys_m68k.c
@@ -61,22 +61,6 @@ out:
 	return error;
 }
 
-struct sel_arg_struct {
-	unsigned long n;
-	fd_set *inp, *outp, *exp;
-	struct timeval *tvp;
-};
-
-asmlinkage int old_select(struct sel_arg_struct *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	/* sys_select() does the appropriate kernel locking */
-	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
-}
-
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
diff -puN arch/m68knommu/kernel/syscalltable.S~add-generic-sys_old_select arch/m68knommu/kernel/syscalltable.S
--- a/arch/m68knommu/kernel/syscalltable.S~add-generic-sys_old_select
+++ a/arch/m68knommu/kernel/syscalltable.S
@@ -100,7 +100,7 @@ ENTRY(sys_call_table)
 	.long sys_settimeofday
 	.long sys_getgroups16	/* 80 */
 	.long sys_setgroups16
-	.long old_select
+	.long sys_old_select
 	.long sys_symlink
 	.long sys_lstat
 	.long sys_readlink	/* 85 */
diff -puN arch/mn10300/include/asm/unistd.h~add-generic-sys_old_select arch/mn10300/include/asm/unistd.h
--- a/arch/mn10300/include/asm/unistd.h~add-generic-sys_old_select
+++ a/arch/mn10300/include/asm/unistd.h
@@ -375,6 +375,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
diff -puN arch/mn10300/kernel/entry.S~add-generic-sys_old_select arch/mn10300/kernel/entry.S
--- a/arch/mn10300/kernel/entry.S~add-generic-sys_old_select
+++ a/arch/mn10300/kernel/entry.S
@@ -468,7 +468,7 @@ ENTRY(sys_call_table)
 	.long sys_settimeofday
 	.long sys_getgroups16	/* 80 */
 	.long sys_setgroups16
-	.long old_select
+	.long sys_old_select
 	.long sys_symlink
 	.long sys_lstat
 	.long sys_readlink	/* 85 */
diff -puN arch/mn10300/kernel/sys_mn10300.c~add-generic-sys_old_select arch/mn10300/kernel/sys_mn10300.c
--- a/arch/mn10300/kernel/sys_mn10300.c~add-generic-sys_old_select
+++ a/arch/mn10300/kernel/sys_mn10300.c
@@ -32,24 +32,6 @@ asmlinkage long old_mmap(unsigned long a
 	return sys_mmap_pgoff(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
 }
 
-struct sel_arg_struct {
-	unsigned long n;
-	fd_set *inp;
-	fd_set *outp;
-	fd_set *exp;
-	struct timeval *tvp;
-};
-
-asmlinkage int old_select(struct sel_arg_struct __user *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	/* sys_select() does the appropriate kernel locking */
-	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
-}
-
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
diff -puN arch/s390/kernel/entry.h~add-generic-sys_old_select arch/s390/kernel/entry.h
--- a/arch/s390/kernel/entry.h~add-generic-sys_old_select
+++ a/arch/s390/kernel/entry.h
@@ -28,7 +28,6 @@ struct new_utsname;
 struct mmap_arg_struct;
 struct fadvise64_64_args;
 struct old_sigaction;
-struct sel_arg_struct;
 
 long sys_mmap2(struct mmap_arg_struct __user  *arg);
 long sys_s390_old_mmap(struct mmap_arg_struct __user *arg);
diff -puN arch/um/sys-i386/syscalls.c~add-generic-sys_old_select arch/um/sys-i386/syscalls.c
--- a/arch/um/sys-i386/syscalls.c~add-generic-sys_old_select
+++ a/arch/um/sys-i386/syscalls.c
@@ -44,24 +44,6 @@ long old_mmap_i386(struct mmap_arg_struc
 	return err;
 }
 
-struct sel_arg_struct {
-	unsigned long n;
-	fd_set __user *inp;
-	fd_set __user *outp;
-	fd_set __user *exp;
-	struct timeval __user *tvp;
-};
-
-long old_select(struct sel_arg_struct __user *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	/* sys_select() does the appropriate kernel locking */
-	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
-}
-
 /*
  * The prototype on i386 is:
  *
diff -puN arch/x86/ia32/ia32entry.S~add-generic-sys_old_select arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~add-generic-sys_old_select
+++ a/arch/x86/ia32/ia32entry.S
@@ -586,7 +586,7 @@ ia32_sys_call_table:
 	.quad compat_sys_settimeofday
 	.quad sys_getgroups16	/* 80 */
 	.quad sys_setgroups16
-	.quad sys32_old_select
+	.quad compat_sys_old_select
 	.quad sys_symlink
 	.quad sys_lstat
 	.quad sys_readlink		/* 85 */
diff -puN arch/x86/ia32/sys_ia32.c~add-generic-sys_old_select arch/x86/ia32/sys_ia32.c
--- a/arch/x86/ia32/sys_ia32.c~add-generic-sys_old_select
+++ a/arch/x86/ia32/sys_ia32.c
@@ -332,24 +332,6 @@ asmlinkage long sys32_alarm(unsigned int
 	return alarm_setitimer(seconds);
 }
 
-struct sel_arg_struct {
-	unsigned int n;
-	unsigned int inp;
-	unsigned int outp;
-	unsigned int exp;
-	unsigned int tvp;
-};
-
-asmlinkage long sys32_old_select(struct sel_arg_struct __user *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	return compat_sys_select(a.n, compat_ptr(a.inp), compat_ptr(a.outp),
-				 compat_ptr(a.exp), compat_ptr(a.tvp));
-}
-
 asmlinkage long sys32_waitpid(compat_pid_t pid, unsigned int *stat_addr,
 			      int options)
 {
diff -puN arch/x86/include/asm/sys_ia32.h~add-generic-sys_old_select arch/x86/include/asm/sys_ia32.h
--- a/arch/x86/include/asm/sys_ia32.h~add-generic-sys_old_select
+++ a/arch/x86/include/asm/sys_ia32.h
@@ -40,8 +40,6 @@ asmlinkage long sys32_rt_sigprocmask(int
 				     compat_sigset_t __user *, unsigned int);
 asmlinkage long sys32_alarm(unsigned int);
 
-struct sel_arg_struct;
-asmlinkage long sys32_old_select(struct sel_arg_struct __user *);
 asmlinkage long sys32_waitpid(compat_pid_t, unsigned int *, int);
 asmlinkage long sys32_sysfs(int, u32, u32);
 
diff -puN arch/x86/include/asm/syscalls.h~add-generic-sys_old_select arch/x86/include/asm/syscalls.h
--- a/arch/x86/include/asm/syscalls.h~add-generic-sys_old_select
+++ a/arch/x86/include/asm/syscalls.h
@@ -52,12 +52,10 @@ unsigned long sys_sigreturn(struct pt_re
 
 /* kernel/sys_i386_32.c */
 struct mmap_arg_struct;
-struct sel_arg_struct;
 struct oldold_utsname;
 struct old_utsname;
 
 asmlinkage int old_mmap(struct mmap_arg_struct __user *);
-asmlinkage int old_select(struct sel_arg_struct __user *);
 asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
 asmlinkage int sys_uname(struct old_utsname __user *);
 asmlinkage int sys_olduname(struct oldold_utsname __user *);
diff -puN arch/x86/include/asm/unistd_32.h~add-generic-sys_old_select arch/x86/include/asm/unistd_32.h
--- a/arch/x86/include/asm/unistd_32.h~add-generic-sys_old_select
+++ a/arch/x86/include/asm/unistd_32.h
@@ -366,6 +366,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
diff -puN arch/x86/kernel/sys_i386_32.c~add-generic-sys_old_select arch/x86/kernel/sys_i386_32.c
--- a/arch/x86/kernel/sys_i386_32.c~add-generic-sys_old_select
+++ a/arch/x86/kernel/sys_i386_32.c
@@ -58,23 +58,6 @@ out:
 	return err;
 }
 
-
-struct sel_arg_struct {
-	unsigned long n;
-	fd_set __user *inp, *outp, *exp;
-	struct timeval __user *tvp;
-};
-
-asmlinkage int old_select(struct sel_arg_struct __user *arg)
-{
-	struct sel_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		return -EFAULT;
-	/* sys_select() does the appropriate kernel locking */
-	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
-}
-
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
diff -puN arch/x86/kernel/syscall_table_32.S~add-generic-sys_old_select arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~add-generic-sys_old_select
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -81,7 +81,7 @@ ENTRY(sys_call_table)
 	.long sys_settimeofday
 	.long sys_getgroups16	/* 80 */
 	.long sys_setgroups16
-	.long old_select
+	.long sys_old_select
 	.long sys_symlink
 	.long sys_lstat
 	.long sys_readlink	/* 85 */
diff -puN fs/compat.c~add-generic-sys_old_select fs/compat.c
--- a/fs/compat.c~add-generic-sys_old_select
+++ a/fs/compat.c
@@ -1795,6 +1795,24 @@ asmlinkage long compat_sys_select(int n,
 	return ret;
 }
 
+struct compat_sel_arg_struct {
+	compat_ulong_t n;
+	compat_uptr_t inp;
+	compat_uptr_t outp;
+	compat_uptr_t exp;
+	compat_uptr_t tvp;
+};
+
+asmlinkage long compat_sys_old_select(struct compat_sel_arg_struct __user *arg)
+{
+	struct compat_sel_arg_struct a;
+
+	if (copy_from_user(&a, arg, sizeof(a)))
+		return -EFAULT;
+	return compat_sys_select(a.n, compat_ptr(a.inp), compat_ptr(a.outp),
+				 compat_ptr(a.exp), compat_ptr(a.tvp));
+}
+
 #ifdef HAVE_SET_RESTORE_SIGMASK
 static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
diff -puN fs/select.c~add-generic-sys_old_select fs/select.c
--- a/fs/select.c~add-generic-sys_old_select
+++ a/fs/select.c
@@ -691,6 +691,23 @@ SYSCALL_DEFINE6(pselect6, int, n, fd_set
 }
 #endif /* HAVE_SET_RESTORE_SIGMASK */
 
+#ifdef __ARCH_WANT_SYS_OLD_SELECT
+struct sel_arg_struct {
+	unsigned long n;
+	fd_set __user *inp, *outp, *exp;
+	struct timeval __user *tvp;
+};
+
+SYSCALL_DEFINE1(old_select, struct sel_arg_struct __user *, arg)
+{
+	struct sel_arg_struct a;
+
+	if (copy_from_user(&a, arg, sizeof(a)))
+		return -EFAULT;
+	return sys_select(a.n, a.inp, a.outp, a.exp, a.tvp);
+}
+#endif
+
 struct poll_list {
 	struct poll_list *next;
 	int len;
diff -puN include/linux/compat.h~add-generic-sys_old_select include/linux/compat.h
--- a/include/linux/compat.h~add-generic-sys_old_select
+++ a/include/linux/compat.h
@@ -23,6 +23,7 @@
 typedef __compat_uid32_t	compat_uid_t;
 typedef __compat_gid32_t	compat_gid_t;
 
+struct compat_sel_arg_struct;
 struct rusage;
 
 struct compat_itimerspec { 
@@ -249,6 +250,8 @@ asmlinkage long compat_sys_select(int n,
 		compat_ulong_t __user *outp, compat_ulong_t __user *exp,
 		struct compat_timeval __user *tvp);
 
+asmlinkage long compat_sys_old_select(struct compat_sel_arg_struct __user *arg);
+
 asmlinkage long compat_sys_wait4(compat_pid_t pid,
 				 compat_uint_t __user *stat_addr, int options,
 				 struct compat_rusage __user *ru);
diff -puN include/linux/syscalls.h~add-generic-sys_old_select include/linux/syscalls.h
--- a/include/linux/syscalls.h~add-generic-sys_old_select
+++ a/include/linux/syscalls.h
@@ -34,6 +34,7 @@ struct pollfd;
 struct rlimit;
 struct rusage;
 struct sched_param;
+struct sel_arg_struct;
 struct semaphore;
 struct sembuf;
 struct shmid_ds;
@@ -638,6 +639,7 @@ asmlinkage long sys_poll(struct pollfd _
 				long timeout);
 asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 			fd_set __user *exp, struct timeval __user *tvp);
+asmlinkage long sys_old_select(struct sel_arg_struct __user *arg);
 asmlinkage long sys_epoll_create(int size);
 asmlinkage long sys_epoll_create1(int flags);
 asmlinkage long sys_epoll_ctl(int epfd, int op, int fd,
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
xtensa-convert-to-asm-generic-hardirqh.patch
improve-sys_personality-for-compat-architectures.patch


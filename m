From: akpm@linux-foundation.org
Subject: [merged] add-generic-sys_olduname.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:55:40 -0400
Message-ID: <201003150656.o2F6uDmS016270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934876Ab0COG7I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:59:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, arnd@arndb.de, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, hpa@zytor.com, jdike@addtoit.com, jmorris@namei.org, lethal@linux-sh.org, mingo@elte.hu, ralf@linux-mip


The patch titled
     Add generic sys_olduname()
has been removed from the -mm tree.  Its filename was
     add-generic-sys_olduname.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add generic sys_olduname()
From: Christoph Hellwig <hch@lst.de>

Add generic implementations of the old and really old uname system calls. 
Note that sh only implements sys_olduname but not sys_oldolduname, but I'm
not going to bother with another ifdef for that special case.

m32r implemented an old uname but never wired it up, so kill it, too.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/sys_m32r.c       |   11 -----
 arch/mips/include/asm/unistd.h    |    1 
 arch/mips/kernel/syscall.c        |   42 --------------------
 arch/powerpc/include/asm/unistd.h |    1 
 arch/powerpc/kernel/syscalls.c    |   57 ----------------------------
 arch/sh/include/asm/syscalls.h    |    3 -
 arch/sh/include/asm/unistd_32.h   |    1 
 arch/sh/include/asm/unistd_64.h   |    1 
 arch/sh/kernel/sys_sh.c           |   11 -----
 arch/um/kernel/syscall.c          |   45 ----------------------
 arch/x86/ia32/ia32entry.S         |    4 -
 arch/x86/ia32/sys_ia32.c          |   52 -------------------------
 arch/x86/include/asm/sys_ia32.h   |    5 --
 arch/x86/include/asm/syscalls.h   |    7 ---
 arch/x86/include/asm/unistd_32.h  |    1 
 arch/x86/include/asm/unistd_64.h  |    1 
 arch/x86/kernel/sys_i386_32.c     |   49 ------------------------
 include/linux/syscalls.h          |    4 +
 kernel/sys.c                      |   54 ++++++++++++++++++++++++++
 19 files changed, 66 insertions(+), 284 deletions(-)

diff -puN arch/m32r/kernel/sys_m32r.c~add-generic-sys_olduname arch/m32r/kernel/sys_m32r.c
--- a/arch/m32r/kernel/sys_m32r.c~add-generic-sys_olduname
+++ a/arch/m32r/kernel/sys_m32r.c
@@ -76,17 +76,6 @@ asmlinkage int sys_tas(int __user *addr)
 	return oldval;
 }
 
-asmlinkage int sys_uname(struct old_utsname __user * name)
-{
-	int err;
-	if (!name)
-		return -EFAULT;
-	down_read(&uts_sem);
-	err = copy_to_user(name, utsname(), sizeof (*name));
-	up_read(&uts_sem);
-	return err?-EFAULT:0;
-}
-
 asmlinkage int sys_cacheflush(void *addr, int bytes, int cache)
 {
 	/* This should flush more selectively ...  */
diff -puN arch/mips/include/asm/unistd.h~add-generic-sys_olduname arch/mips/include/asm/unistd.h
--- a/arch/mips/include/asm/unistd.h~add-generic-sys_olduname
+++ a/arch/mips/include/asm/unistd.h
@@ -1014,6 +1014,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_UNAME
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
diff -puN arch/mips/kernel/syscall.c~add-generic-sys_olduname arch/mips/kernel/syscall.c
--- a/arch/mips/kernel/syscall.c~add-generic-sys_olduname
+++ a/arch/mips/kernel/syscall.c
@@ -215,48 +215,6 @@ out:
 	return error;
 }
 
-/*
- * Compacrapability ...
- */
-SYSCALL_DEFINE1(uname, struct old_utsname __user *, name)
-{
-	if (name && !copy_to_user(name, utsname(), sizeof (*name)))
-		return 0;
-	return -EFAULT;
-}
-
-/*
- * Compacrapability ...
- */
-SYSCALL_DEFINE1(olduname, struct oldold_utsname __user *, name)
-{
-	int error;
-
-	if (!name)
-		return -EFAULT;
-	if (!access_ok(VERIFY_WRITE, name, sizeof(struct oldold_utsname)))
-		return -EFAULT;
-
-	error = __copy_to_user(&name->sysname, &utsname()->sysname,
-			       __OLD_UTS_LEN);
-	error -= __put_user(0, name->sysname + __OLD_UTS_LEN);
-	error -= __copy_to_user(&name->nodename, &utsname()->nodename,
-				__OLD_UTS_LEN);
-	error -= __put_user(0, name->nodename + __OLD_UTS_LEN);
-	error -= __copy_to_user(&name->release, &utsname()->release,
-				__OLD_UTS_LEN);
-	error -= __put_user(0, name->release + __OLD_UTS_LEN);
-	error -= __copy_to_user(&name->version, &utsname()->version,
-				__OLD_UTS_LEN);
-	error -= __put_user(0, name->version + __OLD_UTS_LEN);
-	error -= __copy_to_user(&name->machine, &utsname()->machine,
-				__OLD_UTS_LEN);
-	error = __put_user(0, name->machine + __OLD_UTS_LEN);
-	error = error ? -EFAULT : 0;
-
-	return error;
-}
-
 SYSCALL_DEFINE1(set_thread_area, unsigned long, addr)
 {
 	struct thread_info *ti = task_thread_info(current);
diff -puN arch/powerpc/include/asm/unistd.h~add-generic-sys_olduname arch/powerpc/include/asm/unistd.h
--- a/arch/powerpc/include/asm/unistd.h~add-generic-sys_olduname
+++ a/arch/powerpc/include/asm/unistd.h
@@ -377,6 +377,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_UNAME
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
diff -puN arch/powerpc/kernel/syscalls.c~add-generic-sys_olduname arch/powerpc/kernel/syscalls.c
--- a/arch/powerpc/kernel/syscalls.c~add-generic-sys_olduname
+++ a/arch/powerpc/kernel/syscalls.c
@@ -116,63 +116,6 @@ long ppc64_personality(unsigned long per
 }
 #endif
 
-#ifdef CONFIG_PPC64
-#define OVERRIDE_MACHINE    (personality(current->personality) == PER_LINUX32)
-#else
-#define OVERRIDE_MACHINE    0
-#endif
-
-static inline int override_machine(char __user *mach)
-{
-	if (OVERRIDE_MACHINE) {
-		/* change ppc64 to ppc */
-		if (__put_user(0, mach+3) || __put_user(0, mach+4))
-			return -EFAULT;
-	}
-	return 0;
-}
-
-int sys_uname(struct old_utsname __user *name)
-{
-	int err = 0;
-	
-	down_read(&uts_sem);
-	if (copy_to_user(name, utsname(), sizeof(*name)))
-		err = -EFAULT;
-	up_read(&uts_sem);
-	if (!err)
-		err = override_machine(name->machine);
-	return err;
-}
-
-int sys_olduname(struct oldold_utsname __user *name)
-{
-	int error;
-
-	if (!access_ok(VERIFY_WRITE, name, sizeof(struct oldold_utsname)))
-		return -EFAULT;
-  
-	down_read(&uts_sem);
-	error = __copy_to_user(&name->sysname, &utsname()->sysname,
-			       __OLD_UTS_LEN);
-	error |= __put_user(0, name->sysname + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->nodename, &utsname()->nodename,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->nodename + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->release, &utsname()->release,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->release + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->version, &utsname()->version,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->version + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->machine, &utsname()->machine,
-				__OLD_UTS_LEN);
-	error |= override_machine(name->machine);
-	up_read(&uts_sem);
-
-	return error? -EFAULT: 0;
-}
-
 long ppc_fadvise64_64(int fd, int advice, u32 offset_high, u32 offset_low,
 		      u32 len_high, u32 len_low)
 {
diff -puN arch/sh/include/asm/syscalls.h~add-generic-sys_olduname arch/sh/include/asm/syscalls.h
--- a/arch/sh/include/asm/syscalls.h~add-generic-sys_olduname
+++ a/arch/sh/include/asm/syscalls.h
@@ -3,15 +3,12 @@
 
 #ifdef __KERNEL__
 
-struct old_utsname;
-
 asmlinkage int old_mmap(unsigned long addr, unsigned long len,
 			unsigned long prot, unsigned long flags,
 			int fd, unsigned long off);
 asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 			  unsigned long prot, unsigned long flags,
 			  unsigned long fd, unsigned long pgoff);
-asmlinkage int sys_uname(struct old_utsname __user *name);
 
 #ifdef CONFIG_SUPERH32
 # include "syscalls_32.h"
diff -puN arch/sh/include/asm/unistd_32.h~add-generic-sys_olduname arch/sh/include/asm/unistd_32.h
--- a/arch/sh/include/asm/unistd_32.h~add-generic-sys_olduname
+++ a/arch/sh/include/asm/unistd_32.h
@@ -371,6 +371,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_UNAME
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
diff -puN arch/sh/include/asm/unistd_64.h~add-generic-sys_olduname arch/sh/include/asm/unistd_64.h
--- a/arch/sh/include/asm/unistd_64.h~add-generic-sys_olduname
+++ a/arch/sh/include/asm/unistd_64.h
@@ -411,6 +411,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_UNAME
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
diff -puN arch/sh/kernel/sys_sh.c~add-generic-sys_olduname arch/sh/kernel/sys_sh.c
--- a/arch/sh/kernel/sys_sh.c~add-generic-sys_olduname
+++ a/arch/sh/kernel/sys_sh.c
@@ -93,14 +93,3 @@ asmlinkage int sys_cacheflush(unsigned l
 	up_read(&current->mm->mmap_sem);
 	return 0;
 }
-
-asmlinkage int sys_uname(struct old_utsname __user *name)
-{
-	int err;
-	if (!name)
-		return -EFAULT;
-	down_read(&uts_sem);
-	err = copy_to_user(name, utsname(), sizeof(*name));
-	up_read(&uts_sem);
-	return err?-EFAULT:0;
-}
diff -puN arch/um/kernel/syscall.c~add-generic-sys_olduname arch/um/kernel/syscall.c
--- a/arch/um/kernel/syscall.c~add-generic-sys_olduname
+++ a/arch/um/kernel/syscall.c
@@ -51,51 +51,6 @@ long old_mmap(unsigned long addr, unsign
 	return err;
 }
 
-long sys_uname(struct old_utsname __user * name)
-{
-	long err;
-	if (!name)
-		return -EFAULT;
-	down_read(&uts_sem);
-	err = copy_to_user(name, utsname(), sizeof (*name));
-	up_read(&uts_sem);
-	return err?-EFAULT:0;
-}
-
-long sys_olduname(struct oldold_utsname __user * name)
-{
-	long error;
-
-	if (!name)
-		return -EFAULT;
-	if (!access_ok(VERIFY_WRITE,name,sizeof(struct oldold_utsname)))
-		return -EFAULT;
-
-	down_read(&uts_sem);
-
-	error = __copy_to_user(&name->sysname, &utsname()->sysname,
-			       __OLD_UTS_LEN);
-	error |= __put_user(0, name->sysname + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->nodename, &utsname()->nodename,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->nodename + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->release, &utsname()->release,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->release + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->version, &utsname()->version,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->version + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->machine, &utsname()->machine,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->machine + __OLD_UTS_LEN);
-
-	up_read(&uts_sem);
-
-	error = error ? -EFAULT : 0;
-
-	return error;
-}
-
 int kernel_execve(const char *filename, char *const argv[], char *const envp[])
 {
 	mm_segment_t fs;
diff -puN arch/x86/ia32/ia32entry.S~add-generic-sys_olduname arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~add-generic-sys_olduname
+++ a/arch/x86/ia32/ia32entry.S
@@ -563,7 +563,7 @@ ia32_sys_call_table:
 	.quad quiet_ni_syscall			/* old mpx syscall holder */
 	.quad sys_setpgid
 	.quad quiet_ni_syscall			/* old ulimit syscall holder */
-	.quad sys32_olduname
+	.quad sys_olduname
 	.quad sys_umask		/* 60 */
 	.quad sys_chroot
 	.quad compat_sys_ustat
@@ -613,7 +613,7 @@ ia32_sys_call_table:
 	.quad compat_sys_newstat
 	.quad compat_sys_newlstat
 	.quad compat_sys_newfstat
-	.quad sys32_uname
+	.quad sys_uname
 	.quad stub32_iopl		/* 110 */
 	.quad sys_vhangup
 	.quad quiet_ni_syscall	/* old "idle" system call */
diff -puN arch/x86/ia32/sys_ia32.c~add-generic-sys_olduname arch/x86/ia32/sys_ia32.c
--- a/arch/x86/ia32/sys_ia32.c~add-generic-sys_olduname
+++ a/arch/x86/ia32/sys_ia32.c
@@ -448,58 +448,6 @@ asmlinkage long sys32_sendfile(int out_f
 	return ret;
 }
 
-asmlinkage long sys32_olduname(struct oldold_utsname __user *name)
-{
-	char *arch = "x86_64";
-	int err;
-
-	if (!name)
-		return -EFAULT;
-	if (!access_ok(VERIFY_WRITE, name, sizeof(struct oldold_utsname)))
-		return -EFAULT;
-
-	down_read(&uts_sem);
-
-	err = __copy_to_user(&name->sysname, &utsname()->sysname,
-			     __OLD_UTS_LEN);
-	err |= __put_user(0, name->sysname+__OLD_UTS_LEN);
-	err |= __copy_to_user(&name->nodename, &utsname()->nodename,
-			      __OLD_UTS_LEN);
-	err |= __put_user(0, name->nodename+__OLD_UTS_LEN);
-	err |= __copy_to_user(&name->release, &utsname()->release,
-			      __OLD_UTS_LEN);
-	err |= __put_user(0, name->release+__OLD_UTS_LEN);
-	err |= __copy_to_user(&name->version, &utsname()->version,
-			      __OLD_UTS_LEN);
-	err |= __put_user(0, name->version+__OLD_UTS_LEN);
-
-	if (personality(current->personality) == PER_LINUX32)
-		arch = "i686";
-
-	err |= __copy_to_user(&name->machine, arch, strlen(arch) + 1);
-
-	up_read(&uts_sem);
-
-	err = err ? -EFAULT : 0;
-
-	return err;
-}
-
-long sys32_uname(struct old_utsname __user *name)
-{
-	int err;
-
-	if (!name)
-		return -EFAULT;
-	down_read(&uts_sem);
-	err = copy_to_user(name, utsname(), sizeof(*name));
-	up_read(&uts_sem);
-	if (personality(current->personality) == PER_LINUX32)
-		err |= copy_to_user(&name->machine, "i686", 5);
-
-	return err ? -EFAULT : 0;
-}
-
 asmlinkage long sys32_execve(char __user *name, compat_uptr_t __user *argv,
 			     compat_uptr_t __user *envp, struct pt_regs *regs)
 {
diff -puN arch/x86/include/asm/sys_ia32.h~add-generic-sys_olduname arch/x86/include/asm/sys_ia32.h
--- a/arch/x86/include/asm/sys_ia32.h~add-generic-sys_olduname
+++ a/arch/x86/include/asm/sys_ia32.h
@@ -54,11 +54,6 @@ asmlinkage long sys32_pwrite(unsigned in
 asmlinkage long sys32_personality(unsigned long);
 asmlinkage long sys32_sendfile(int, int, compat_off_t __user *, s32);
 
-struct oldold_utsname;
-struct old_utsname;
-asmlinkage long sys32_olduname(struct oldold_utsname __user *);
-long sys32_uname(struct old_utsname __user *);
-
 asmlinkage long sys32_execve(char __user *, compat_uptr_t __user *,
 			     compat_uptr_t __user *, struct pt_regs *);
 asmlinkage long sys32_clone(unsigned int, unsigned int, struct pt_regs *);
diff -puN arch/x86/include/asm/syscalls.h~add-generic-sys_olduname arch/x86/include/asm/syscalls.h
--- a/arch/x86/include/asm/syscalls.h~add-generic-sys_olduname
+++ a/arch/x86/include/asm/syscalls.h
@@ -50,13 +50,6 @@ asmlinkage int sys_sigaction(int, const 
 			     struct old_sigaction __user *);
 unsigned long sys_sigreturn(struct pt_regs *);
 
-/* kernel/sys_i386_32.c */
-struct oldold_utsname;
-struct old_utsname;
-
-asmlinkage int sys_uname(struct old_utsname __user *);
-asmlinkage int sys_olduname(struct oldold_utsname __user *);
-
 /* kernel/vm86_32.c */
 int sys_vm86old(struct vm86_struct __user *, struct pt_regs *);
 int sys_vm86(unsigned long, unsigned long, struct pt_regs *);
diff -puN arch/x86/include/asm/unistd_32.h~add-generic-sys_olduname arch/x86/include/asm/unistd_32.h
--- a/arch/x86/include/asm/unistd_32.h~add-generic-sys_olduname
+++ a/arch/x86/include/asm/unistd_32.h
@@ -367,6 +367,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_UNAME
 #define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
diff -puN arch/x86/include/asm/unistd_64.h~add-generic-sys_olduname arch/x86/include/asm/unistd_64.h
--- a/arch/x86/include/asm/unistd_64.h~add-generic-sys_olduname
+++ a/arch/x86/include/asm/unistd_64.h
@@ -680,6 +680,7 @@ __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_UNAME
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
diff -puN arch/x86/kernel/sys_i386_32.c~add-generic-sys_olduname arch/x86/kernel/sys_i386_32.c
--- a/arch/x86/kernel/sys_i386_32.c~add-generic-sys_olduname
+++ a/arch/x86/kernel/sys_i386_32.c
@@ -25,55 +25,6 @@
 #include <asm/syscalls.h>
 
 /*
- * Old cruft
- */
-asmlinkage int sys_uname(struct old_utsname __user *name)
-{
-	int err;
-	if (!name)
-		return -EFAULT;
-	down_read(&uts_sem);
-	err = copy_to_user(name, utsname(), sizeof(*name));
-	up_read(&uts_sem);
-	return err? -EFAULT:0;
-}
-
-asmlinkage int sys_olduname(struct oldold_utsname __user *name)
-{
-	int error;
-
-	if (!name)
-		return -EFAULT;
-	if (!access_ok(VERIFY_WRITE, name, sizeof(struct oldold_utsname)))
-		return -EFAULT;
-
-	down_read(&uts_sem);
-
-	error = __copy_to_user(&name->sysname, &utsname()->sysname,
-			       __OLD_UTS_LEN);
-	error |= __put_user(0, name->sysname + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->nodename, &utsname()->nodename,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->nodename + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->release, &utsname()->release,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->release + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->version, &utsname()->version,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->version + __OLD_UTS_LEN);
-	error |= __copy_to_user(&name->machine, &utsname()->machine,
-				__OLD_UTS_LEN);
-	error |= __put_user(0, name->machine + __OLD_UTS_LEN);
-
-	up_read(&uts_sem);
-
-	error = error ? -EFAULT : 0;
-
-	return error;
-}
-
-
-/*
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
diff -puN include/linux/syscalls.h~add-generic-sys_olduname include/linux/syscalls.h
--- a/include/linux/syscalls.h~add-generic-sys_olduname
+++ a/include/linux/syscalls.h
@@ -31,6 +31,8 @@ struct msqid_ds;
 struct new_utsname;
 struct nfsctl_arg;
 struct __old_kernel_stat;
+struct oldold_utsname;
+struct old_utsname;
 struct pollfd;
 struct rlimit;
 struct rusage;
@@ -655,6 +657,8 @@ asmlinkage long sys_gethostname(char __u
 asmlinkage long sys_sethostname(char __user *name, int len);
 asmlinkage long sys_setdomainname(char __user *name, int len);
 asmlinkage long sys_newuname(struct new_utsname __user *name);
+asmlinkage long sys_uname(struct old_utsname __user *);
+asmlinkage long sys_olduname(struct oldold_utsname __user *);
 
 asmlinkage long sys_getrlimit(unsigned int resource,
 				struct rlimit __user *rlim);
diff -puN kernel/sys.c~add-generic-sys_olduname kernel/sys.c
--- a/kernel/sys.c~add-generic-sys_olduname
+++ a/kernel/sys.c
@@ -1138,6 +1138,60 @@ SYSCALL_DEFINE1(newuname, struct new_uts
 	return errno;
 }
 
+#ifdef __ARCH_WANT_SYS_OLD_UNAME
+/*
+ * Old cruft
+ */
+SYSCALL_DEFINE1(uname, struct old_utsname __user *, name)
+{
+	int error = 0;
+
+	if (!name)
+		return -EFAULT;
+
+	down_read(&uts_sem);
+	if (copy_to_user(name, utsname(), sizeof(*name)))
+		error = -EFAULT;
+	up_read(&uts_sem);
+
+	if (!error && override_architecture(name))
+		error = -EFAULT;
+	return error;
+}
+
+SYSCALL_DEFINE1(olduname, struct oldold_utsname __user *, name)
+{
+	int error;
+
+	if (!name)
+		return -EFAULT;
+	if (!access_ok(VERIFY_WRITE, name, sizeof(struct oldold_utsname)))
+		return -EFAULT;
+
+	down_read(&uts_sem);
+	error = __copy_to_user(&name->sysname, &utsname()->sysname,
+			       __OLD_UTS_LEN);
+	error |= __put_user(0, name->sysname + __OLD_UTS_LEN);
+	error |= __copy_to_user(&name->nodename, &utsname()->nodename,
+				__OLD_UTS_LEN);
+	error |= __put_user(0, name->nodename + __OLD_UTS_LEN);
+	error |= __copy_to_user(&name->release, &utsname()->release,
+				__OLD_UTS_LEN);
+	error |= __put_user(0, name->release + __OLD_UTS_LEN);
+	error |= __copy_to_user(&name->version, &utsname()->version,
+				__OLD_UTS_LEN);
+	error |= __put_user(0, name->version + __OLD_UTS_LEN);
+	error |= __copy_to_user(&name->machine, &utsname()->machine,
+				__OLD_UTS_LEN);
+	error |= __put_user(0, name->machine + __OLD_UTS_LEN);
+	up_read(&uts_sem);
+
+	if (!error && override_architecture(name))
+		error = -EFAULT;
+	return error ? -EFAULT : 0;
+}
+#endif
+
 SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
 {
 	int errno;
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
xtensa-convert-to-asm-generic-hardirqh.patch
improve-sys_personality-for-compat-architectures.patch


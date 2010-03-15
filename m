From: akpm@linux-foundation.org
Subject: [merged] add-generic-sys_old_mmap.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:55:27 -0400
Message-ID: <201003150656.o2F6u0RA016179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935633Ab0COG6j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, arnd@arndb.de, benh@kernel.crashing.org, dhowells@redhat.com, gerg@uclinux.org, heiko.carstens@de.ibm.com, hpa@zytor.com, jdike@addtoit.com, jesper.nilsson@axis.com, jmorr


The patch titled
     Add generic sys_old_mmap()
has been removed from the -mm tree.  Its filename was
     add-generic-sys_old_mmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add generic sys_old_mmap()
From: Christoph Hellwig <hch@lst.de>

Add a generic implementation of the old mmap() syscall, which expects its
argument in a memory block and switch all architectures over to use it.

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
Cc: Andreas Schwab <schwab@linux-m68k.org>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/unistd.h             |    1 
 arch/arm/kernel/calls.S                   |    2 -
 arch/arm/kernel/sys_arm.c                 |   26 ---------------
 arch/cris/arch-v10/kernel/entry.S         |    2 -
 arch/cris/arch-v32/kernel/entry.S         |    2 -
 arch/cris/include/asm/unistd.h            |    1 
 arch/cris/kernel/sys_cris.c               |   18 ----------
 arch/h8300/include/asm/unistd.h           |    1 
 arch/h8300/kernel/sys_h8300.c             |   34 --------------------
 arch/h8300/kernel/syscalls.S              |    2 -
 arch/m68k/include/asm/unistd.h            |    1 
 arch/m68k/kernel/entry.S                  |    2 -
 arch/m68k/kernel/sys_m68k.c               |   34 --------------------
 arch/m68knommu/kernel/sys_m68k.c          |   34 --------------------
 arch/m68knommu/kernel/syscalltable.S      |    2 -
 arch/s390/include/asm/unistd.h            |    1 
 arch/s390/kernel/entry.h                  |    5 +-
 arch/s390/kernel/sys_s390.c               |   30 +++--------------
 arch/s390/kernel/syscalls.S               |    2 -
 arch/um/sys-i386/shared/sysdep/syscalls.h |    2 -
 arch/um/sys-i386/sys_call_table.S         |    2 -
 arch/um/sys-i386/syscalls.c               |   33 -------------------
 arch/x86/ia32/sys_ia32.c                  |    6 +--
 arch/x86/include/asm/sys_ia32.h           |    4 +-
 arch/x86/include/asm/syscalls.h           |    2 -
 arch/x86/include/asm/unistd_32.h          |    1 
 arch/x86/kernel/sys_i386_32.c             |   34 --------------------
 arch/x86/kernel/syscall_table_32.S        |    2 -
 include/linux/syscalls.h                  |    3 +
 mm/mmap.c                                 |   24 ++++++++++++++
 mm/nommu.c                                |   24 ++++++++++++++
 31 files changed, 79 insertions(+), 258 deletions(-)

diff -puN arch/arm/include/asm/unistd.h~add-generic-sys_old_mmap arch/arm/include/asm/unistd.h
--- a/arch/arm/include/asm/unistd.h~add-generic-sys_old_mmap
+++ a/arch/arm/include/asm/unistd.h
@@ -443,6 +443,7 @@
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLD_SELECT
 
 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
diff -puN arch/arm/kernel/calls.S~add-generic-sys_old_mmap arch/arm/kernel/calls.S
--- a/arch/arm/kernel/calls.S~add-generic-sys_old_mmap
+++ a/arch/arm/kernel/calls.S
@@ -99,7 +99,7 @@
 		CALL(sys_swapon)
 		CALL(sys_reboot)
 		CALL(OBSOLETE(sys_old_readdir))	/* used by libc4 */
-/* 90 */	CALL(OBSOLETE(old_mmap))	/* used by libc4 */
+/* 90 */	CALL(OBSOLETE(sys_old_mmap))	/* used by libc4 */
 		CALL(sys_munmap)
 		CALL(sys_truncate)
 		CALL(sys_ftruncate)
diff -puN arch/arm/kernel/sys_arm.c~add-generic-sys_old_mmap arch/arm/kernel/sys_arm.c
--- a/arch/arm/kernel/sys_arm.c~add-generic-sys_old_mmap
+++ a/arch/arm/kernel/sys_arm.c
@@ -28,32 +28,6 @@
 #include <linux/ipc.h>
 #include <linux/uaccess.h>
 
-struct mmap_arg_struct {
-	unsigned long addr;
-	unsigned long len;
-	unsigned long prot;
-	unsigned long flags;
-	unsigned long fd;
-	unsigned long offset;
-};
-
-asmlinkage int old_mmap(struct mmap_arg_struct __user *arg)
-{
-	int error = -EFAULT;
-	struct mmap_arg_struct a;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		goto out;
-
-	error = -EINVAL;
-	if (a.offset & ~PAGE_MASK)
-		goto out;
-
-	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd, a.offset >> PAGE_SHIFT);
-out:
-	return error;
-}
-
 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
diff -puN arch/cris/arch-v10/kernel/entry.S~add-generic-sys_old_mmap arch/cris/arch-v10/kernel/entry.S
--- a/arch/cris/arch-v10/kernel/entry.S~add-generic-sys_old_mmap
+++ a/arch/cris/arch-v10/kernel/entry.S
@@ -692,7 +692,7 @@ sys_call_table:	
 	.long sys_swapon
 	.long sys_reboot
 	.long sys_old_readdir
-	.long old_mmap		/* 90 */
+	.long sys_old_mmap	/* 90 */
 	.long sys_munmap
 	.long sys_truncate
 	.long sys_ftruncate
diff -puN arch/cris/arch-v32/kernel/entry.S~add-generic-sys_old_mmap arch/cris/arch-v32/kernel/entry.S
--- a/arch/cris/arch-v32/kernel/entry.S~add-generic-sys_old_mmap
+++ a/arch/cris/arch-v32/kernel/entry.S
@@ -615,7 +615,7 @@ sys_call_table:
 	.long sys_swapon
 	.long sys_reboot
 	.long sys_old_readdir
-	.long old_mmap		/* 90 */
+	.long sys_old_mmap	/* 90 */
 	.long sys_munmap
 	.long sys_truncate
 	.long sys_ftruncate
diff -puN arch/cris/include/asm/unistd.h~add-generic-sys_old_mmap arch/cris/include/asm/unistd.h
--- a/arch/cris/include/asm/unistd.h~add-generic-sys_old_mmap
+++ a/arch/cris/include/asm/unistd.h
@@ -364,6 +364,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
diff -puN arch/cris/kernel/sys_cris.c~add-generic-sys_old_mmap arch/cris/kernel/sys_cris.c
--- a/arch/cris/kernel/sys_cris.c~add-generic-sys_old_mmap
+++ a/arch/cris/kernel/sys_cris.c
@@ -26,24 +26,6 @@
 #include <asm/uaccess.h>
 #include <asm/segment.h>
 
-asmlinkage unsigned long old_mmap(unsigned long __user *args)
-{        
-	unsigned long buffer[6];
-	int err = -EFAULT;
-
-	if (copy_from_user(&buffer, args, sizeof(buffer)))
-		goto out;
-
-	err = -EINVAL;
-	if (buffer[5] & ~PAGE_MASK) /* verify that offset is on page boundary */
-		goto out;
-
-	err = sys_mmap_pgoff(buffer[0], buffer[1], buffer[2], buffer[3],
-                       buffer[4], buffer[5] >> PAGE_SHIFT);
-out:
-	return err;
-}
-
 asmlinkage long
 sys_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
           unsigned long flags, unsigned long fd, unsigned long pgoff)
diff -puN arch/h8300/include/asm/unistd.h~add-generic-sys_old_mmap arch/h8300/include/asm/unistd.h
--- a/arch/h8300/include/asm/unistd.h~add-generic-sys_old_mmap
+++ a/arch/h8300/include/asm/unistd.h
@@ -348,6 +348,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
diff -puN arch/h8300/kernel/sys_h8300.c~add-generic-sys_old_mmap arch/h8300/kernel/sys_h8300.c
--- a/arch/h8300/kernel/sys_h8300.c~add-generic-sys_old_mmap
+++ a/arch/h8300/kernel/sys_h8300.c
@@ -27,40 +27,6 @@
 #include <asm/unistd.h>
 
 /*
- * Perform the select(nd, in, out, ex, tv) and mmap() system
- * calls. Linux/m68k cloned Linux/i386, which didn't use to be able to
- * handle more than 4 system call parameters, so these system calls
- * used a memory block for parameter passing..
- */
-
-struct mmap_arg_struct {
-	unsigned long addr;
-	unsigned long len;
-	unsigned long prot;
-	unsigned long flags;
-	unsigned long fd;
-	unsigned long offset;
-};
-
-asmlinkage int old_mmap(struct mmap_arg_struct *arg)
-{
-	struct mmap_arg_struct a;
-	int error = -EFAULT;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		goto out;
-
-	error = -EINVAL;
-	if (a.offset & ~PAGE_MASK)
-		goto out;
-
-	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
-			       a.offset >> PAGE_SHIFT);
-out:
-	return error;
-}
-
-/*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
  * This is really horribly ugly.
diff -puN arch/h8300/kernel/syscalls.S~add-generic-sys_old_mmap arch/h8300/kernel/syscalls.S
--- a/arch/h8300/kernel/syscalls.S~add-generic-sys_old_mmap
+++ a/arch/h8300/kernel/syscalls.S
@@ -104,7 +104,7 @@ SYMBOL_NAME_LABEL(sys_call_table)	
 	.long SYMBOL_NAME(sys_swapon)
 	.long SYMBOL_NAME(sys_reboot)
 	.long SYMBOL_NAME(sys_old_readdir)
-	.long SYMBOL_NAME(old_mmap)		/* 90 */
+	.long SYMBOL_NAME(sys_old_mmap)		/* 90 */
 	.long SYMBOL_NAME(sys_munmap)
 	.long SYMBOL_NAME(sys_truncate)
 	.long SYMBOL_NAME(sys_ftruncate)
diff -puN arch/m68k/include/asm/unistd.h~add-generic-sys_old_mmap arch/m68k/include/asm/unistd.h
--- a/arch/m68k/include/asm/unistd.h~add-generic-sys_old_mmap
+++ a/arch/m68k/include/asm/unistd.h
@@ -363,6 +363,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
diff -puN arch/m68k/kernel/entry.S~add-generic-sys_old_mmap arch/m68k/kernel/entry.S
--- a/arch/m68k/kernel/entry.S~add-generic-sys_old_mmap
+++ a/arch/m68k/kernel/entry.S
@@ -518,7 +518,7 @@ sys_call_table:
 	.long sys_swapon
 	.long sys_reboot
 	.long sys_old_readdir
-	.long old_mmap		/* 90 */
+	.long sys_old_mmap	/* 90 */
 	.long sys_munmap
 	.long sys_truncate
 	.long sys_ftruncate
diff -puN arch/m68k/kernel/sys_m68k.c~add-generic-sys_old_mmap arch/m68k/kernel/sys_m68k.c
--- a/arch/m68k/kernel/sys_m68k.c~add-generic-sys_old_mmap
+++ a/arch/m68k/kernel/sys_m68k.c
@@ -47,40 +47,6 @@ asmlinkage long sys_mmap2(unsigned long 
 }
 
 /*
- * Perform the select(nd, in, out, ex, tv) and mmap() system
- * calls. Linux/m68k cloned Linux/i386, which didn't use to be able to
- * handle more than 4 system call parameters, so these system calls
- * used a memory block for parameter passing..
- */
-
-struct mmap_arg_struct {
-	unsigned long addr;
-	unsigned long len;
-	unsigned long prot;
-	unsigned long flags;
-	unsigned long fd;
-	unsigned long offset;
-};
-
-asmlinkage int old_mmap(struct mmap_arg_struct __user *arg)
-{
-	struct mmap_arg_struct a;
-	int error = -EFAULT;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		goto out;
-
-	error = -EINVAL;
-	if (a.offset & ~PAGE_MASK)
-		goto out;
-
-	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
-			       a.offset >> PAGE_SHIFT);
-out:
-	return error;
-}
-
-/*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
  * This is really horribly ugly.
diff -puN arch/m68knommu/kernel/sys_m68k.c~add-generic-sys_old_mmap arch/m68knommu/kernel/sys_m68k.c
--- a/arch/m68knommu/kernel/sys_m68k.c~add-generic-sys_old_mmap
+++ a/arch/m68knommu/kernel/sys_m68k.c
@@ -28,40 +28,6 @@
 #include <asm/unistd.h>
 
 /*
- * Perform the select(nd, in, out, ex, tv) and mmap() system
- * calls. Linux/m68k cloned Linux/i386, which didn't use to be able to
- * handle more than 4 system call parameters, so these system calls
- * used a memory block for parameter passing..
- */
-
-struct mmap_arg_struct {
-	unsigned long addr;
-	unsigned long len;
-	unsigned long prot;
-	unsigned long flags;
-	unsigned long fd;
-	unsigned long offset;
-};
-
-asmlinkage int old_mmap(struct mmap_arg_struct *arg)
-{
-	struct mmap_arg_struct a;
-	int error = -EFAULT;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		goto out;
-
-	error = -EINVAL;
-	if (a.offset & ~PAGE_MASK)
-		goto out;
-
-	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
-				a.offset >> PAGE_SHIFT);
-out:
-	return error;
-}
-
-/*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
  * This is really horribly ugly.
diff -puN arch/m68knommu/kernel/syscalltable.S~add-generic-sys_old_mmap arch/m68knommu/kernel/syscalltable.S
--- a/arch/m68knommu/kernel/syscalltable.S~add-generic-sys_old_mmap
+++ a/arch/m68knommu/kernel/syscalltable.S
@@ -108,7 +108,7 @@ ENTRY(sys_call_table)
 	.long sys_ni_syscall	/* sys_swapon */
 	.long sys_reboot
 	.long sys_old_readdir
-	.long old_mmap		/* 90 */
+	.long sys_old_mmap	/* 90 */
 	.long sys_munmap
 	.long sys_truncate
 	.long sys_ftruncate
diff -puN arch/s390/include/asm/unistd.h~add-generic-sys_old_mmap arch/s390/include/asm/unistd.h
--- a/arch/s390/include/asm/unistd.h~add-generic-sys_old_mmap
+++ a/arch/s390/include/asm/unistd.h
@@ -392,6 +392,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
diff -puN arch/s390/kernel/entry.h~add-generic-sys_old_mmap arch/s390/kernel/entry.h
--- a/arch/s390/kernel/entry.h~add-generic-sys_old_mmap
+++ a/arch/s390/kernel/entry.h
@@ -25,12 +25,11 @@ void __init startup_init(void);
 void die(const char * str, struct pt_regs * regs, long err);
 
 struct new_utsname;
-struct mmap_arg_struct;
+struct s390_mmap_arg_struct;
 struct fadvise64_64_args;
 struct old_sigaction;
 
-long sys_mmap2(struct mmap_arg_struct __user  *arg);
-long sys_s390_old_mmap(struct mmap_arg_struct __user *arg);
+long sys_mmap2(struct s390_mmap_arg_struct __user  *arg);
 long sys_ipc(uint call, int first, unsigned long second,
 	     unsigned long third, void __user *ptr);
 long sys_s390_newuname(struct new_utsname __user *name);
diff -puN arch/s390/kernel/sys_s390.c~add-generic-sys_old_mmap arch/s390/kernel/sys_s390.c
--- a/arch/s390/kernel/sys_s390.c~add-generic-sys_old_mmap
+++ a/arch/s390/kernel/sys_s390.c
@@ -33,13 +33,12 @@
 #include "entry.h"
 
 /*
- * Perform the select(nd, in, out, ex, tv) and mmap() system
- * calls. Linux for S/390 isn't able to handle more than 5
- * system call parameters, so these system calls used a memory
- * block for parameter passing..
+ * Perform the mmap() system call. Linux for S/390 isn't able to handle more
+ * than 5 system call parameters, so this system call uses a memory block
+ * for parameter passing.
  */
 
-struct mmap_arg_struct {
+struct s390_mmap_arg_struct {
 	unsigned long addr;
 	unsigned long len;
 	unsigned long prot;
@@ -48,9 +47,9 @@ struct mmap_arg_struct {
 	unsigned long offset;
 };
 
-SYSCALL_DEFINE1(mmap2, struct mmap_arg_struct __user *, arg)
+SYSCALL_DEFINE1(mmap2, struct s390_mmap_arg_struct __user *, arg)
 {
-	struct mmap_arg_struct a;
+	struct s390_mmap_arg_struct a;
 	int error = -EFAULT;
 
 	if (copy_from_user(&a, arg, sizeof(a)))
@@ -60,23 +59,6 @@ out:
 	return error;
 }
 
-SYSCALL_DEFINE1(s390_old_mmap, struct mmap_arg_struct __user *, arg)
-{
-	struct mmap_arg_struct a;
-	long error = -EFAULT;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		goto out;
-
-	error = -EINVAL;
-	if (a.offset & ~PAGE_MASK)
-		goto out;
-
-	error = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd, a.offset >> PAGE_SHIFT);
-out:
-	return error;
-}
-
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
diff -puN arch/s390/kernel/syscalls.S~add-generic-sys_old_mmap arch/s390/kernel/syscalls.S
--- a/arch/s390/kernel/syscalls.S~add-generic-sys_old_mmap
+++ a/arch/s390/kernel/syscalls.S
@@ -98,7 +98,7 @@ SYSCALL(sys_uselib,sys_uselib,sys32_usel
 SYSCALL(sys_swapon,sys_swapon,sys32_swapon_wrapper)
 SYSCALL(sys_reboot,sys_reboot,sys32_reboot_wrapper)
 SYSCALL(sys_ni_syscall,sys_ni_syscall,old32_readdir_wrapper)	/* old readdir syscall */
-SYSCALL(sys_s390_old_mmap,sys_s390_old_mmap,old32_mmap_wrapper)	/* 90 */
+SYSCALL(sys_old_mmap,sys_old_mmap,old32_mmap_wrapper)		/* 90 */
 SYSCALL(sys_munmap,sys_munmap,sys32_munmap_wrapper)
 SYSCALL(sys_truncate,sys_truncate,sys32_truncate_wrapper)
 SYSCALL(sys_ftruncate,sys_ftruncate,sys32_ftruncate_wrapper)
diff -puN arch/um/sys-i386/shared/sysdep/syscalls.h~add-generic-sys_old_mmap arch/um/sys-i386/shared/sysdep/syscalls.h
--- a/arch/um/sys-i386/shared/sysdep/syscalls.h~add-generic-sys_old_mmap
+++ a/arch/um/sys-i386/shared/sysdep/syscalls.h
@@ -13,8 +13,6 @@ typedef long syscall_handler_t(struct pt
  */
 extern syscall_handler_t sys_rt_sigaction;
 
-extern syscall_handler_t old_mmap_i386;
-
 extern syscall_handler_t *sys_call_table[];
 
 #define EXECUTE_SYSCALL(syscall, regs) \
diff -puN arch/um/sys-i386/sys_call_table.S~add-generic-sys_old_mmap arch/um/sys-i386/sys_call_table.S
--- a/arch/um/sys-i386/sys_call_table.S~add-generic-sys_old_mmap
+++ a/arch/um/sys-i386/sys_call_table.S
@@ -7,7 +7,7 @@
 #define sys_vm86old sys_ni_syscall
 #define sys_vm86 sys_ni_syscall
 
-#define old_mmap old_mmap_i386
+#define old_mmap sys_old_mmap
 
 #define ptregs_fork sys_fork
 #define ptregs_execve sys_execve
diff -puN arch/um/sys-i386/syscalls.c~add-generic-sys_old_mmap arch/um/sys-i386/syscalls.c
--- a/arch/um/sys-i386/syscalls.c~add-generic-sys_old_mmap
+++ a/arch/um/sys-i386/syscalls.c
@@ -12,39 +12,6 @@
 #include "asm/unistd.h"
 
 /*
- * Perform the select(nd, in, out, ex, tv) and mmap() system
- * calls. Linux/i386 didn't use to be able to handle more than
- * 4 system call parameters, so these system calls used a memory
- * block for parameter passing..
- */
-
-struct mmap_arg_struct {
-	unsigned long addr;
-	unsigned long len;
-	unsigned long prot;
-	unsigned long flags;
-	unsigned long fd;
-	unsigned long offset;
-};
-
-extern int old_mmap(unsigned long addr, unsigned long len,
-		    unsigned long prot, unsigned long flags,
-		    unsigned long fd, unsigned long offset);
-
-long old_mmap_i386(struct mmap_arg_struct __user *arg)
-{
-	struct mmap_arg_struct a;
-	int err = -EFAULT;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		goto out;
-
-	err = old_mmap(a.addr, a.len, a.prot, a.flags, a.fd, a.offset);
- out:
-	return err;
-}
-
-/*
  * The prototype on i386 is:
  *
  *     int clone(int flags, void * child_stack, int * parent_tidptr, struct user_desc * newtls, int * child_tidptr)
diff -puN arch/x86/ia32/sys_ia32.c~add-generic-sys_old_mmap arch/x86/ia32/sys_ia32.c
--- a/arch/x86/ia32/sys_ia32.c~add-generic-sys_old_mmap
+++ a/arch/x86/ia32/sys_ia32.c
@@ -143,7 +143,7 @@ asmlinkage long sys32_fstatat(unsigned i
  * block for parameter passing..
  */
 
-struct mmap_arg_struct {
+struct mmap_arg_struct32 {
 	unsigned int addr;
 	unsigned int len;
 	unsigned int prot;
@@ -152,9 +152,9 @@ struct mmap_arg_struct {
 	unsigned int offset;
 };
 
-asmlinkage long sys32_mmap(struct mmap_arg_struct __user *arg)
+asmlinkage long sys32_mmap(struct mmap_arg_struct32 __user *arg)
 {
-	struct mmap_arg_struct a;
+	struct mmap_arg_struct32 a;
 
 	if (copy_from_user(&a, arg, sizeof(a)))
 		return -EFAULT;
diff -puN arch/x86/include/asm/sys_ia32.h~add-generic-sys_old_mmap arch/x86/include/asm/sys_ia32.h
--- a/arch/x86/include/asm/sys_ia32.h~add-generic-sys_old_mmap
+++ a/arch/x86/include/asm/sys_ia32.h
@@ -26,8 +26,8 @@ asmlinkage long sys32_lstat64(char __use
 asmlinkage long sys32_fstat64(unsigned int, struct stat64 __user *);
 asmlinkage long sys32_fstatat(unsigned int, char __user *,
 			      struct stat64 __user *, int);
-struct mmap_arg_struct;
-asmlinkage long sys32_mmap(struct mmap_arg_struct __user *);
+struct mmap_arg_struct32;
+asmlinkage long sys32_mmap(struct mmap_arg_struct32 __user *);
 asmlinkage long sys32_mprotect(unsigned long, size_t, unsigned long);
 
 struct sigaction32;
diff -puN arch/x86/include/asm/syscalls.h~add-generic-sys_old_mmap arch/x86/include/asm/syscalls.h
--- a/arch/x86/include/asm/syscalls.h~add-generic-sys_old_mmap
+++ a/arch/x86/include/asm/syscalls.h
@@ -51,11 +51,9 @@ asmlinkage int sys_sigaction(int, const 
 unsigned long sys_sigreturn(struct pt_regs *);
 
 /* kernel/sys_i386_32.c */
-struct mmap_arg_struct;
 struct oldold_utsname;
 struct old_utsname;
 
-asmlinkage int old_mmap(struct mmap_arg_struct __user *);
 asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
 asmlinkage int sys_uname(struct old_utsname __user *);
 asmlinkage int sys_olduname(struct oldold_utsname __user *);
diff -puN arch/x86/include/asm/unistd_32.h~add-generic-sys_old_mmap arch/x86/include/asm/unistd_32.h
--- a/arch/x86/include/asm/unistd_32.h~add-generic-sys_old_mmap
+++ a/arch/x86/include/asm/unistd_32.h
@@ -366,6 +366,7 @@
 #define __ARCH_WANT_SYS_LLSEEK
 #define __ARCH_WANT_SYS_NICE
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
+#define __ARCH_WANT_SYS_OLD_MMAP
 #define __ARCH_WANT_SYS_OLD_SELECT
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_SIGPENDING
diff -puN arch/x86/kernel/sys_i386_32.c~add-generic-sys_old_mmap arch/x86/kernel/sys_i386_32.c
--- a/arch/x86/kernel/sys_i386_32.c~add-generic-sys_old_mmap
+++ a/arch/x86/kernel/sys_i386_32.c
@@ -25,40 +25,6 @@
 #include <asm/syscalls.h>
 
 /*
- * Perform the select(nd, in, out, ex, tv) and mmap() system
- * calls. Linux/i386 didn't use to be able to handle more than
- * 4 system call parameters, so these system calls used a memory
- * block for parameter passing..
- */
-
-struct mmap_arg_struct {
-	unsigned long addr;
-	unsigned long len;
-	unsigned long prot;
-	unsigned long flags;
-	unsigned long fd;
-	unsigned long offset;
-};
-
-asmlinkage int old_mmap(struct mmap_arg_struct __user *arg)
-{
-	struct mmap_arg_struct a;
-	int err = -EFAULT;
-
-	if (copy_from_user(&a, arg, sizeof(a)))
-		goto out;
-
-	err = -EINVAL;
-	if (a.offset & ~PAGE_MASK)
-		goto out;
-
-	err = sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags,
-			a.fd, a.offset >> PAGE_SHIFT);
-out:
-	return err;
-}
-
-/*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
  *
  * This is really horribly ugly.
diff -puN arch/x86/kernel/syscall_table_32.S~add-generic-sys_old_mmap arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~add-generic-sys_old_mmap
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -89,7 +89,7 @@ ENTRY(sys_call_table)
 	.long sys_swapon
 	.long sys_reboot
 	.long sys_old_readdir
-	.long old_mmap		/* 90 */
+	.long sys_old_mmap	/* 90 */
 	.long sys_munmap
 	.long sys_truncate
 	.long sys_ftruncate
diff -puN include/linux/syscalls.h~add-generic-sys_old_mmap include/linux/syscalls.h
--- a/include/linux/syscalls.h~add-generic-sys_old_mmap
+++ a/include/linux/syscalls.h
@@ -23,6 +23,7 @@ struct kexec_segment;
 struct linux_dirent;
 struct linux_dirent64;
 struct list_head;
+struct mmap_arg_struct;
 struct msgbuf;
 struct msghdr;
 struct mmsghdr;
@@ -838,4 +839,6 @@ asmlinkage long sys_perf_event_open(
 asmlinkage long sys_mmap_pgoff(unsigned long addr, unsigned long len,
 			unsigned long prot, unsigned long flags,
 			unsigned long fd, unsigned long pgoff);
+asmlinkage long sys_old_mmap(struct mmap_arg_struct __user *arg);
+
 #endif
diff -puN mm/mmap.c~add-generic-sys_old_mmap mm/mmap.c
--- a/mm/mmap.c~add-generic-sys_old_mmap
+++ a/mm/mmap.c
@@ -1088,6 +1088,30 @@ out:
 	return retval;
 }
 
+#ifdef __ARCH_WANT_SYS_OLD_MMAP
+struct mmap_arg_struct {
+	unsigned long addr;
+	unsigned long len;
+	unsigned long prot;
+	unsigned long flags;
+	unsigned long fd;
+	unsigned long offset;
+};
+
+SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
+{
+	struct mmap_arg_struct a;
+
+	if (copy_from_user(&a, arg, sizeof(a)))
+		return -EFAULT;
+	if (a.offset & ~PAGE_MASK)
+		return -EINVAL;
+
+	return sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
+			      a.offset >> PAGE_SHIFT);
+}
+#endif /* __ARCH_WANT_SYS_OLD_MMAP */
+
 /*
  * Some shared mappigns will want the pages marked read-only
  * to track write events. If so, we'll downgrade vm_page_prot
diff -puN mm/nommu.c~add-generic-sys_old_mmap mm/nommu.c
--- a/mm/nommu.c~add-generic-sys_old_mmap
+++ a/mm/nommu.c
@@ -1428,6 +1428,30 @@ out:
 	return retval;
 }
 
+#ifdef __ARCH_WANT_SYS_OLD_MMAP
+struct mmap_arg_struct {
+	unsigned long addr;
+	unsigned long len;
+	unsigned long prot;
+	unsigned long flags;
+	unsigned long fd;
+	unsigned long offset;
+};
+
+SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
+{
+	struct mmap_arg_struct a;
+
+	if (copy_from_user(&a, arg, sizeof(a)))
+		return -EFAULT;
+	if (a.offset & ~PAGE_MASK)
+		return -EINVAL;
+
+	return sys_mmap_pgoff(a.addr, a.len, a.prot, a.flags, a.fd,
+			      a.offset >> PAGE_SHIFT);
+}
+#endif /* __ARCH_WANT_SYS_OLD_MMAP */
+
 /*
  * split a vma into two pieces at address 'addr', a new vma is allocated either
  * for the first part or the tail.
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
xtensa-convert-to-asm-generic-hardirqh.patch
improve-sys_personality-for-compat-architectures.patch


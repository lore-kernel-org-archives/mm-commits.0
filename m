From: akpm@linux-foundation.org
Subject: [merged] improve-sys_newuname-for-compat-architectures.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:55:36 -0400
Message-ID: <201003150656.o2F6u94I016192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935695Ab0COG63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, arnd@arndb.de, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, hpa@zytor.com, jdike@addtoit.com, jmorris@namei.org, lethal@linux-sh.org, mingo@elte.hu, ralf@linux-mip


The patch titled
     improve sys_newuname() for compat architectures
has been removed from the -mm tree.  Its filename was
     improve-sys_newuname-for-compat-architectures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: improve sys_newuname() for compat architectures
From: Christoph Hellwig <hch@lst.de>

On an architecture that supports 32-bit compat we need to override the
reported machine in uname with the 32-bit value.  Instead of doing this
separately in every architecture introduce a COMPAT_UTS_MACHINE define in
<asm/compat.h> and apply it directly in sys_newuname().

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

 arch/ia64/include/asm/compat.h      |    3 ++-
 arch/mips/include/asm/compat.h      |    3 ++-
 arch/mips/kernel/linux32.c          |   16 ----------------
 arch/mips/kernel/scall64-n32.S      |    2 +-
 arch/mips/kernel/scall64-o32.S      |    2 +-
 arch/parisc/include/asm/compat.h    |    3 ++-
 arch/parisc/kernel/sys_parisc.c     |   15 ---------------
 arch/parisc/kernel/syscall_table.S  |    2 +-
 arch/powerpc/include/asm/compat.h   |    3 ++-
 arch/powerpc/include/asm/syscalls.h |    2 --
 arch/powerpc/include/asm/systbl.h   |    2 +-
 arch/powerpc/kernel/syscalls.c      |   13 -------------
 arch/s390/include/asm/compat.h      |    3 ++-
 arch/s390/kernel/compat_wrapper.S   |    2 +-
 arch/s390/kernel/entry.h            |    2 --
 arch/s390/kernel/sys_s390.c         |   11 -----------
 arch/s390/kernel/syscalls.S         |    2 +-
 arch/sparc/include/asm/compat.h     |    3 ++-
 arch/sparc/kernel/sys_sparc_64.c    |   11 -----------
 arch/sparc/kernel/systbls.h         |    3 ---
 arch/sparc/kernel/systbls_64.S      |    4 ++--
 arch/um/sys-x86_64/syscall_table.c  |    5 -----
 arch/um/sys-x86_64/syscalls.c       |   14 --------------
 arch/x86/include/asm/compat.h       |    3 ++-
 arch/x86/include/asm/syscalls.h     |    3 ---
 arch/x86/include/asm/unistd_64.h    |    2 +-
 arch/x86/kernel/sys_x86_64.c        |   12 ------------
 kernel/sys.c                        |   13 +++++++++++++
 28 files changed, 36 insertions(+), 123 deletions(-)

diff -puN arch/ia64/include/asm/compat.h~improve-sys_newuname-for-compat-architectures arch/ia64/include/asm/compat.h
--- a/arch/ia64/include/asm/compat.h~improve-sys_newuname-for-compat-architectures
+++ a/arch/ia64/include/asm/compat.h
@@ -5,7 +5,8 @@
  */
 #include <linux/types.h>
 
-#define COMPAT_USER_HZ	100
+#define COMPAT_USER_HZ		100
+#define COMPAT_UTS_MACHINE	"i686\0\0\0"
 
 typedef u32		compat_size_t;
 typedef s32		compat_ssize_t;
diff -puN arch/mips/include/asm/compat.h~improve-sys_newuname-for-compat-architectures arch/mips/include/asm/compat.h
--- a/arch/mips/include/asm/compat.h~improve-sys_newuname-for-compat-architectures
+++ a/arch/mips/include/asm/compat.h
@@ -8,7 +8,8 @@
 #include <asm/page.h>
 #include <asm/ptrace.h>
 
-#define COMPAT_USER_HZ	100
+#define COMPAT_USER_HZ		100
+#define COMPAT_UTS_MACHINE	"mips\0\0\0"
 
 typedef u32		compat_size_t;
 typedef s32		compat_ssize_t;
diff -puN arch/mips/kernel/linux32.c~improve-sys_newuname-for-compat-architectures arch/mips/kernel/linux32.c
--- a/arch/mips/kernel/linux32.c~improve-sys_newuname-for-compat-architectures
+++ a/arch/mips/kernel/linux32.c
@@ -249,22 +249,6 @@ SYSCALL_DEFINE5(n32_msgrcv, int, msqid, 
 }
 #endif
 
-SYSCALL_DEFINE1(32_newuname, struct new_utsname __user *, name)
-{
-	int ret = 0;
-
-	down_read(&uts_sem);
-	if (copy_to_user(name, utsname(), sizeof *name))
-		ret = -EFAULT;
-	up_read(&uts_sem);
-
-	if (current->personality == PER_LINUX32 && !ret)
-		if (copy_to_user(name->machine, "mips\0\0\0", 8))
-			ret = -EFAULT;
-
-	return ret;
-}
-
 SYSCALL_DEFINE1(32_personality, unsigned long, personality)
 {
 	int ret;
diff -puN arch/mips/kernel/scall64-n32.S~improve-sys_newuname-for-compat-architectures arch/mips/kernel/scall64-n32.S
--- a/arch/mips/kernel/scall64-n32.S~improve-sys_newuname-for-compat-architectures
+++ a/arch/mips/kernel/scall64-n32.S
@@ -181,7 +181,7 @@ EXPORT(sysn32_call_table)
 	PTR	sys_exit
 	PTR	compat_sys_wait4
 	PTR	sys_kill			/* 6060 */
-	PTR	sys_32_newuname
+	PTR	sys_newuname
 	PTR	sys_semget
 	PTR	sys_semop
 	PTR	sys_n32_semctl
diff -puN arch/mips/kernel/scall64-o32.S~improve-sys_newuname-for-compat-architectures arch/mips/kernel/scall64-o32.S
--- a/arch/mips/kernel/scall64-o32.S~improve-sys_newuname-for-compat-architectures
+++ a/arch/mips/kernel/scall64-o32.S
@@ -325,7 +325,7 @@ sys_call_table:
 	PTR	sys32_sigreturn
 	PTR	sys32_clone			/* 4120 */
 	PTR	sys_setdomainname
-	PTR	sys_32_newuname
+	PTR	sys_newuname
 	PTR	sys_ni_syscall			/* sys_modify_ldt */
 	PTR	compat_sys_adjtimex
 	PTR	sys_mprotect			/* 4125 */
diff -puN arch/parisc/include/asm/compat.h~improve-sys_newuname-for-compat-architectures arch/parisc/include/asm/compat.h
--- a/arch/parisc/include/asm/compat.h~improve-sys_newuname-for-compat-architectures
+++ a/arch/parisc/include/asm/compat.h
@@ -7,7 +7,8 @@
 #include <linux/sched.h>
 #include <linux/thread_info.h>
 
-#define COMPAT_USER_HZ 100
+#define COMPAT_USER_HZ 		100
+#define COMPAT_UTS_MACHINE	"parisc\0\0"
 
 typedef u32	compat_size_t;
 typedef s32	compat_ssize_t;
diff -puN arch/parisc/kernel/sys_parisc.c~improve-sys_newuname-for-compat-architectures arch/parisc/kernel/sys_parisc.c
--- a/arch/parisc/kernel/sys_parisc.c~improve-sys_newuname-for-compat-architectures
+++ a/arch/parisc/kernel/sys_parisc.c
@@ -234,18 +234,3 @@ long parisc_personality(unsigned long pe
 
 	return err;
 }
-
-long parisc_newuname(struct new_utsname __user *name)
-{
-	int err = sys_newuname(name);
-
-#ifdef CONFIG_COMPAT
-	if (!err && personality(current->personality) == PER_LINUX32) {
-		if (__put_user(0, name->machine + 6) ||
-		    __put_user(0, name->machine + 7))
-			err = -EFAULT;
-	}
-#endif
-
-	return err;
-}
diff -puN arch/parisc/kernel/syscall_table.S~improve-sys_newuname-for-compat-architectures arch/parisc/kernel/syscall_table.S
--- a/arch/parisc/kernel/syscall_table.S~improve-sys_newuname-for-compat-architectures
+++ a/arch/parisc/kernel/syscall_table.S
@@ -127,7 +127,7 @@
 	ENTRY_SAME(socketpair)
 	ENTRY_SAME(setpgid)
 	ENTRY_SAME(send)
-	ENTRY_OURS(newuname)
+	ENTRY_SAME(newuname)
 	ENTRY_SAME(umask)		/* 60 */
 	ENTRY_SAME(chroot)
 	ENTRY_COMP(ustat)
diff -puN arch/powerpc/include/asm/compat.h~improve-sys_newuname-for-compat-architectures arch/powerpc/include/asm/compat.h
--- a/arch/powerpc/include/asm/compat.h~improve-sys_newuname-for-compat-architectures
+++ a/arch/powerpc/include/asm/compat.h
@@ -7,7 +7,8 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 
-#define COMPAT_USER_HZ	100
+#define COMPAT_USER_HZ		100
+#define COMPAT_UTS_MACHINE	"ppc\0\0"
 
 typedef u32		compat_size_t;
 typedef s32		compat_ssize_t;
diff -puN arch/powerpc/include/asm/syscalls.h~improve-sys_newuname-for-compat-architectures arch/powerpc/include/asm/syscalls.h
--- a/arch/powerpc/include/asm/syscalls.h~improve-sys_newuname-for-compat-architectures
+++ a/arch/powerpc/include/asm/syscalls.h
@@ -7,7 +7,6 @@
 #include <linux/types.h>
 #include <asm/signal.h>
 
-struct new_utsname;
 struct pt_regs;
 struct rtas_args;
 struct sigaction;
@@ -38,7 +37,6 @@ asmlinkage long sys_rt_sigaction(int sig
 asmlinkage long ppc64_personality(unsigned long personality);
 asmlinkage int ppc_rtas(struct rtas_args __user *uargs);
 asmlinkage time_t sys64_time(time_t __user * tloc);
-asmlinkage long ppc_newuname(struct new_utsname __user * name);
 
 asmlinkage long sys_rt_sigsuspend(sigset_t __user *unewset,
 		size_t sigsetsize);
diff -puN arch/powerpc/include/asm/systbl.h~improve-sys_newuname-for-compat-architectures arch/powerpc/include/asm/systbl.h
--- a/arch/powerpc/include/asm/systbl.h~improve-sys_newuname-for-compat-architectures
+++ a/arch/powerpc/include/asm/systbl.h
@@ -125,7 +125,7 @@ SYSCALL_SPU(fsync)
 SYS32ONLY(sigreturn)
 PPC_SYS(clone)
 COMPAT_SYS_SPU(setdomainname)
-PPC_SYS_SPU(newuname)
+SYSCALL_SPU(newuname)
 SYSCALL(ni_syscall)
 COMPAT_SYS_SPU(adjtimex)
 SYSCALL_SPU(mprotect)
diff -puN arch/powerpc/kernel/syscalls.c~improve-sys_newuname-for-compat-architectures arch/powerpc/kernel/syscalls.c
--- a/arch/powerpc/kernel/syscalls.c~improve-sys_newuname-for-compat-architectures
+++ a/arch/powerpc/kernel/syscalls.c
@@ -132,19 +132,6 @@ static inline int override_machine(char 
 	return 0;
 }
 
-long ppc_newuname(struct new_utsname __user * name)
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
 int sys_uname(struct old_utsname __user *name)
 {
 	int err = 0;
diff -puN arch/s390/include/asm/compat.h~improve-sys_newuname-for-compat-architectures arch/s390/include/asm/compat.h
--- a/arch/s390/include/asm/compat.h~improve-sys_newuname-for-compat-architectures
+++ a/arch/s390/include/asm/compat.h
@@ -35,7 +35,8 @@
 
 extern long psw32_user_bits;
 
-#define COMPAT_USER_HZ	100
+#define COMPAT_USER_HZ		100
+#define COMPAT_UTS_MACHINE	"s390\0\0\0\0"
 
 typedef u32		compat_size_t;
 typedef s32		compat_ssize_t;
diff -puN arch/s390/kernel/compat_wrapper.S~improve-sys_newuname-for-compat-architectures arch/s390/kernel/compat_wrapper.S
--- a/arch/s390/kernel/compat_wrapper.S~improve-sys_newuname-for-compat-architectures
+++ a/arch/s390/kernel/compat_wrapper.S
@@ -547,7 +547,7 @@ sys32_setdomainname_wrapper:
 	.globl	sys32_newuname_wrapper
 sys32_newuname_wrapper:
 	llgtr	%r2,%r2			# struct new_utsname *
-	jg	sys_s390_newuname	# branch to system call
+	jg	sys_newuname		# branch to system call
 
 	.globl	compat_sys_adjtimex_wrapper
 compat_sys_adjtimex_wrapper:
diff -puN arch/s390/kernel/entry.h~improve-sys_newuname-for-compat-architectures arch/s390/kernel/entry.h
--- a/arch/s390/kernel/entry.h~improve-sys_newuname-for-compat-architectures
+++ a/arch/s390/kernel/entry.h
@@ -24,7 +24,6 @@ int __cpuinit start_secondary(void *cpuv
 void __init startup_init(void);
 void die(const char * str, struct pt_regs * regs, long err);
 
-struct new_utsname;
 struct s390_mmap_arg_struct;
 struct fadvise64_64_args;
 struct old_sigaction;
@@ -32,7 +31,6 @@ struct old_sigaction;
 long sys_mmap2(struct s390_mmap_arg_struct __user  *arg);
 long sys_s390_ipc(uint call, int first, unsigned long second,
 	     unsigned long third, void __user *ptr);
-long sys_s390_newuname(struct new_utsname __user *name);
 long sys_s390_personality(unsigned long personality);
 long sys_s390_fadvise64(int fd, u32 offset_high, u32 offset_low,
 		    size_t len, int advice);
diff -puN arch/s390/kernel/sys_s390.c~improve-sys_newuname-for-compat-architectures arch/s390/kernel/sys_s390.c
--- a/arch/s390/kernel/sys_s390.c~improve-sys_newuname-for-compat-architectures
+++ a/arch/s390/kernel/sys_s390.c
@@ -131,17 +131,6 @@ SYSCALL_DEFINE5(s390_ipc, uint, call, in
 }
 
 #ifdef CONFIG_64BIT
-SYSCALL_DEFINE1(s390_newuname, struct new_utsname __user *, name)
-{
-	int ret = sys_newuname(name);
-
-	if (personality(current->personality) == PER_LINUX32 && !ret) {
-		ret = copy_to_user(name->machine, "s390\0\0\0\0", 8);
-		if (ret) ret = -EFAULT;
-	}
-	return ret;
-}
-
 SYSCALL_DEFINE1(s390_personality, unsigned long, personality)
 {
 	int ret;
diff -puN arch/s390/kernel/syscalls.S~improve-sys_newuname-for-compat-architectures arch/s390/kernel/syscalls.S
--- a/arch/s390/kernel/syscalls.S~improve-sys_newuname-for-compat-architectures
+++ a/arch/s390/kernel/syscalls.S
@@ -130,7 +130,7 @@ SYSCALL(sys_fsync,sys_fsync,sys32_fsync_
 SYSCALL(sys_sigreturn,sys_sigreturn,sys32_sigreturn)
 SYSCALL(sys_clone,sys_clone,sys_clone_wrapper)			/* 120 */
 SYSCALL(sys_setdomainname,sys_setdomainname,sys32_setdomainname_wrapper)
-SYSCALL(sys_newuname,sys_s390_newuname,sys32_newuname_wrapper)
+SYSCALL(sys_newuname,sys_newuname,sys32_newuname_wrapper)
 NI_SYSCALL							/* modify_ldt for i386 */
 SYSCALL(sys_adjtimex,sys_adjtimex,compat_sys_adjtimex_wrapper)
 SYSCALL(sys_mprotect,sys_mprotect,sys32_mprotect_wrapper)	/* 125 */
diff -puN arch/sparc/include/asm/compat.h~improve-sys_newuname-for-compat-architectures arch/sparc/include/asm/compat.h
--- a/arch/sparc/include/asm/compat.h~improve-sys_newuname-for-compat-architectures
+++ a/arch/sparc/include/asm/compat.h
@@ -5,7 +5,8 @@
  */
 #include <linux/types.h>
 
-#define COMPAT_USER_HZ	100
+#define COMPAT_USER_HZ		100
+#define COMPAT_UTS_MACHINE	"sparc\0\0"
 
 typedef u32		compat_size_t;
 typedef s32		compat_ssize_t;
diff -puN arch/sparc/kernel/sys_sparc_64.c~improve-sys_newuname-for-compat-architectures arch/sparc/kernel/sys_sparc_64.c
--- a/arch/sparc/kernel/sys_sparc_64.c~improve-sys_newuname-for-compat-architectures
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -510,17 +510,6 @@ out:
 	return err;
 }
 
-SYSCALL_DEFINE1(sparc64_newuname, struct new_utsname __user *, name)
-{
-	int ret = sys_newuname(name);
-	
-	if (current->personality == PER_LINUX32 && !ret) {
-		ret = (copy_to_user(name->machine, "sparc\0\0", 8)
-		       ? -EFAULT : 0);
-	}
-	return ret;
-}
-
 SYSCALL_DEFINE1(sparc64_personality, unsigned long, personality)
 {
 	int ret;
diff -puN arch/sparc/kernel/systbls.h~improve-sys_newuname-for-compat-architectures arch/sparc/kernel/systbls.h
--- a/arch/sparc/kernel/systbls.h~improve-sys_newuname-for-compat-architectures
+++ a/arch/sparc/kernel/systbls.h
@@ -6,15 +6,12 @@
 #include <asm/utrap.h>
 #include <asm/signal.h>
 
-struct new_utsname;
-
 extern asmlinkage unsigned long sys_getpagesize(void);
 extern asmlinkage long sparc_pipe(struct pt_regs *regs);
 extern asmlinkage long sys_sparc_ipc(unsigned int call, int first,
 			       unsigned long second,
 			       unsigned long third,
 			       void __user *ptr, long fifth);
-extern asmlinkage long sparc64_newuname(struct new_utsname __user *name);
 extern asmlinkage long sparc64_personality(unsigned long personality);
 extern asmlinkage long sys64_munmap(unsigned long addr, size_t len);
 extern asmlinkage unsigned long sys64_mremap(unsigned long addr,
diff -puN arch/sparc/kernel/systbls_64.S~improve-sys_newuname-for-compat-architectures arch/sparc/kernel/systbls_64.S
--- a/arch/sparc/kernel/systbls_64.S~improve-sys_newuname-for-compat-architectures
+++ a/arch/sparc/kernel/systbls_64.S
@@ -55,7 +55,7 @@ sys_call_table32:
 /*170*/	.word sys32_lsetxattr, sys32_fsetxattr, sys_getxattr, sys_lgetxattr, compat_sys_getdents
 	.word sys_setsid, sys_fchdir, sys32_fgetxattr, sys_listxattr, sys_llistxattr
 /*180*/	.word sys32_flistxattr, sys_removexattr, sys_lremovexattr, compat_sys_sigpending, sys_ni_syscall
-	.word sys32_setpgid, sys32_fremovexattr, sys32_tkill, sys32_exit_group, sys_sparc64_newuname
+	.word sys32_setpgid, sys32_fremovexattr, sys32_tkill, sys32_exit_group, sys_newuname
 /*190*/	.word sys32_init_module, sys_sparc64_personality, sys_remap_file_pages, sys32_epoll_create, sys32_epoll_ctl
 	.word sys32_epoll_wait, sys32_ioprio_set, sys_getppid, sys32_sigaction, sys_sgetmask
 /*200*/	.word sys32_ssetmask, sys_sigsuspend, compat_sys_newlstat, sys_uselib, compat_sys_old_readdir
@@ -130,7 +130,7 @@ sys_call_table:
 /*170*/	.word sys_lsetxattr, sys_fsetxattr, sys_getxattr, sys_lgetxattr, sys_getdents
 	.word sys_setsid, sys_fchdir, sys_fgetxattr, sys_listxattr, sys_llistxattr
 /*180*/	.word sys_flistxattr, sys_removexattr, sys_lremovexattr, sys_nis_syscall, sys_ni_syscall
-	.word sys_setpgid, sys_fremovexattr, sys_tkill, sys_exit_group, sys_sparc64_newuname
+	.word sys_setpgid, sys_fremovexattr, sys_tkill, sys_exit_group, sys_newuname
 /*190*/	.word sys_init_module, sys_sparc64_personality, sys_remap_file_pages, sys_epoll_create, sys_epoll_ctl
 	.word sys_epoll_wait, sys_ioprio_set, sys_getppid, sys_nis_syscall, sys_sgetmask
 /*200*/	.word sys_ssetmask, sys_nis_syscall, sys_newlstat, sys_uselib, sys_nis_syscall
diff -puN arch/um/sys-x86_64/syscall_table.c~improve-sys_newuname-for-compat-architectures arch/um/sys-x86_64/syscall_table.c
--- a/arch/um/sys-x86_64/syscall_table.c~improve-sys_newuname-for-compat-architectures
+++ a/arch/um/sys-x86_64/syscall_table.c
@@ -26,11 +26,6 @@
 
 /* On UML we call it this way ("old" means it's not mmap2) */
 #define sys_mmap old_mmap
-/*
- * On x86-64 sys_uname is actually sys_newuname plus a compatibility trick.
- * See arch/x86_64/kernel/sys_x86_64.c
- */
-#define sys_uname sys_uname64
 
 #define stub_clone sys_clone
 #define stub_fork sys_fork
diff -puN arch/um/sys-x86_64/syscalls.c~improve-sys_newuname-for-compat-architectures arch/um/sys-x86_64/syscalls.c
--- a/arch/um/sys-x86_64/syscalls.c~improve-sys_newuname-for-compat-architectures
+++ a/arch/um/sys-x86_64/syscalls.c
@@ -12,20 +12,6 @@
 #include "asm/uaccess.h"
 #include "os.h"
 
-asmlinkage long sys_uname64(struct new_utsname __user * name)
-{
-	int err;
-
-	down_read(&uts_sem);
-	err = copy_to_user(name, utsname(), sizeof (*name));
-	up_read(&uts_sem);
-
-	if (personality(current->personality) == PER_LINUX32)
-		err |= copy_to_user(&name->machine, "i686", 5);
-
-	return err ? -EFAULT : 0;
-}
-
 long arch_prctl(struct task_struct *task, int code, unsigned long __user *addr)
 {
 	unsigned long *ptr = addr, tmp;
diff -puN arch/x86/include/asm/compat.h~improve-sys_newuname-for-compat-architectures arch/x86/include/asm/compat.h
--- a/arch/x86/include/asm/compat.h~improve-sys_newuname-for-compat-architectures
+++ a/arch/x86/include/asm/compat.h
@@ -8,7 +8,8 @@
 #include <linux/sched.h>
 #include <asm/user32.h>
 
-#define COMPAT_USER_HZ	100
+#define COMPAT_USER_HZ		100
+#define COMPAT_UTS_MACHINE	"i686\0\0"
 
 typedef u32		compat_size_t;
 typedef s32		compat_ssize_t;
diff -puN arch/x86/include/asm/syscalls.h~improve-sys_newuname-for-compat-architectures arch/x86/include/asm/syscalls.h
--- a/arch/x86/include/asm/syscalls.h~improve-sys_newuname-for-compat-architectures
+++ a/arch/x86/include/asm/syscalls.h
@@ -68,11 +68,8 @@ int sys_vm86(unsigned long, unsigned lon
 long sys_arch_prctl(int, unsigned long);
 
 /* kernel/sys_x86_64.c */
-struct new_utsname;
-
 asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
 			 unsigned long, unsigned long, unsigned long);
-asmlinkage long sys_uname(struct new_utsname __user *);
 
 #endif /* CONFIG_X86_32 */
 #endif /* _ASM_X86_SYSCALLS_H */
diff -puN arch/x86/include/asm/unistd_64.h~improve-sys_newuname-for-compat-architectures arch/x86/include/asm/unistd_64.h
--- a/arch/x86/include/asm/unistd_64.h~improve-sys_newuname-for-compat-architectures
+++ a/arch/x86/include/asm/unistd_64.h
@@ -146,7 +146,7 @@ __SYSCALL(__NR_wait4, sys_wait4)
 #define __NR_kill				62
 __SYSCALL(__NR_kill, sys_kill)
 #define __NR_uname				63
-__SYSCALL(__NR_uname, sys_uname)
+__SYSCALL(__NR_uname, sys_newuname)
 
 #define __NR_semget				64
 __SYSCALL(__NR_semget, sys_semget)
diff -puN arch/x86/kernel/sys_x86_64.c~improve-sys_newuname-for-compat-architectures arch/x86/kernel/sys_x86_64.c
--- a/arch/x86/kernel/sys_x86_64.c~improve-sys_newuname-for-compat-architectures
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -209,15 +209,3 @@ bottomup:
 
 	return addr;
 }
-
-
-SYSCALL_DEFINE1(uname, struct new_utsname __user *, name)
-{
-	int err;
-	down_read(&uts_sem);
-	err = copy_to_user(name, utsname(), sizeof(*name));
-	up_read(&uts_sem);
-	if (personality(current->personality) == PER_LINUX32)
-		err |= copy_to_user(&name->machine, "i686", 5);
-	return err ? -EFAULT : 0;
-}
diff -puN kernel/sys.c~improve-sys_newuname-for-compat-architectures kernel/sys.c
--- a/kernel/sys.c~improve-sys_newuname-for-compat-architectures
+++ a/kernel/sys.c
@@ -33,6 +33,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/seccomp.h>
 #include <linux/cpu.h>
+#include <linux/personality.h>
 #include <linux/ptrace.h>
 #include <linux/fs_struct.h>
 
@@ -1114,6 +1115,15 @@ out:
 
 DECLARE_RWSEM(uts_sem);
 
+#ifdef COMPAT_UTS_MACHINE
+#define override_architecture(name) \
+	(current->personality == PER_LINUX32 && \
+	 copy_to_user(name->machine, COMPAT_UTS_MACHINE, \
+		      sizeof(COMPAT_UTS_MACHINE)))
+#else
+#define override_architecture(name)	0
+#endif
+
 SYSCALL_DEFINE1(newuname, struct new_utsname __user *, name)
 {
 	int errno = 0;
@@ -1122,6 +1132,9 @@ SYSCALL_DEFINE1(newuname, struct new_uts
 	if (copy_to_user(name, utsname(), sizeof *name))
 		errno = -EFAULT;
 	up_read(&uts_sem);
+
+	if (!errno && override_architecture(name))
+		errno = -EFAULT;
 	return errno;
 }
 
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
xtensa-convert-to-asm-generic-hardirqh.patch
improve-sys_personality-for-compat-architectures.patch


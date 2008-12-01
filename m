From: akpm@linux-foundation.org
Subject: - remove-__arch_want_compat_sys_ptrace.patch removed from -mm tree
Date: Mon, 01 Dec 2008 11:49:33 -0800
Message-ID: <200812011949.mB1JnXd8025329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752737AbYLATud (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 14:50:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, davem@davemloft.net, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     remove __ARCH_WANT_COMPAT_SYS_PTRACE
has been removed from the -mm tree.  Its filename was
     remove-__arch_want_compat_sys_ptrace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove __ARCH_WANT_COMPAT_SYS_PTRACE
From: Christoph Hellwig <hch@lst.de>

All architectures now use the generic compat_sys_ptrace, as should every
new architecture that needs 32bit compat (if we'll ever get another).

Remove the now superflous __ARCH_WANT_COMPAT_SYS_PTRACE define, and also
kill a comment about __ARCH_SYS_PTRACE that was added after
__ARCH_SYS_PTRACE was already gone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                       |    2 --
 arch/ia64/include/asm/ptrace.h     |    2 --
 arch/mips/include/asm/ptrace.h     |    4 ----
 arch/parisc/include/asm/ptrace.h   |    2 --
 arch/powerpc/include/asm/ptrace.h  |    2 --
 arch/s390/include/asm/ptrace.h     |    2 --
 arch/sparc/include/asm/ptrace_64.h |    2 --
 arch/x86/include/asm/ptrace.h      |    2 --
 include/linux/compat.h             |    2 --
 kernel/ptrace.c                    |    4 ++--
 10 files changed, 2 insertions(+), 22 deletions(-)

diff -puN arch/Kconfig~remove-__arch_want_compat_sys_ptrace arch/Kconfig
--- a/arch/Kconfig~remove-__arch_want_compat_sys_ptrace
+++ a/arch/Kconfig
@@ -79,8 +79,6 @@ config HAVE_KRETPROBES
 #	task_pt_regs()		in asm/processor.h or asm/ptrace.h
 #	arch_has_single_step()	if there is hardware single-step support
 #	arch_has_block_step()	if there is hardware block-step support
-#	arch_ptrace()		and not #define __ARCH_SYS_PTRACE
-#	compat_arch_ptrace()	and #define __ARCH_WANT_COMPAT_SYS_PTRACE
 #	asm/syscall.h		supplying asm-generic/syscall.h interface
 #	linux/regset.h		user_regset interfaces
 #	CORE_DUMP_USE_REGSET	#define'd in linux/elf.h
diff -puN arch/ia64/include/asm/ptrace.h~remove-__arch_want_compat_sys_ptrace arch/ia64/include/asm/ptrace.h
--- a/arch/ia64/include/asm/ptrace.h~remove-__arch_want_compat_sys_ptrace
+++ a/arch/ia64/include/asm/ptrace.h
@@ -325,8 +325,6 @@ static inline unsigned long user_stack_p
   #define arch_has_block_step()   (1)
   extern void user_enable_block_step(struct task_struct *);
 
-#define __ARCH_WANT_COMPAT_SYS_PTRACE
-
 #endif /* !__KERNEL__ */
 
 /* pt_all_user_regs is used for PTRACE_GETREGS PTRACE_SETREGS */
diff -puN arch/mips/include/asm/ptrace.h~remove-__arch_want_compat_sys_ptrace arch/mips/include/asm/ptrace.h
--- a/arch/mips/include/asm/ptrace.h~remove-__arch_want_compat_sys_ptrace
+++ a/arch/mips/include/asm/ptrace.h
@@ -9,10 +9,6 @@
 #ifndef _ASM_PTRACE_H
 #define _ASM_PTRACE_H
 
-#ifdef CONFIG_64BIT
-#define __ARCH_WANT_COMPAT_SYS_PTRACE
-#endif
-
 /* 0 - 31 are integer registers, 32 - 63 are fp registers.  */
 #define FPR_BASE	32
 #define PC		64
diff -puN arch/parisc/include/asm/ptrace.h~remove-__arch_want_compat_sys_ptrace arch/parisc/include/asm/ptrace.h
--- a/arch/parisc/include/asm/ptrace.h~remove-__arch_want_compat_sys_ptrace
+++ a/arch/parisc/include/asm/ptrace.h
@@ -47,8 +47,6 @@ struct pt_regs {
 
 #define task_regs(task) ((struct pt_regs *) ((char *)(task) + TASK_REGS))
 
-#define __ARCH_WANT_COMPAT_SYS_PTRACE
-
 struct task_struct;
 #define arch_has_single_step()	1
 void user_disable_single_step(struct task_struct *task);
diff -puN arch/powerpc/include/asm/ptrace.h~remove-__arch_want_compat_sys_ptrace arch/powerpc/include/asm/ptrace.h
--- a/arch/powerpc/include/asm/ptrace.h~remove-__arch_want_compat_sys_ptrace
+++ a/arch/powerpc/include/asm/ptrace.h
@@ -55,8 +55,6 @@ struct pt_regs {
 
 #ifdef __powerpc64__
 
-#define __ARCH_WANT_COMPAT_SYS_PTRACE
-
 #define STACK_FRAME_OVERHEAD	112	/* size of minimum stack frame */
 #define STACK_FRAME_LR_SAVE	2	/* Location of LR in stack frame */
 #define STACK_FRAME_REGS_MARKER	ASM_CONST(0x7265677368657265)
diff -puN arch/s390/include/asm/ptrace.h~remove-__arch_want_compat_sys_ptrace arch/s390/include/asm/ptrace.h
--- a/arch/s390/include/asm/ptrace.h~remove-__arch_want_compat_sys_ptrace
+++ a/arch/s390/include/asm/ptrace.h
@@ -486,8 +486,6 @@ struct task_struct;
 extern void user_enable_single_step(struct task_struct *);
 extern void user_disable_single_step(struct task_struct *);
 
-#define __ARCH_WANT_COMPAT_SYS_PTRACE
-
 #define user_mode(regs) (((regs)->psw.mask & PSW_MASK_PSTATE) != 0)
 #define instruction_pointer(regs) ((regs)->psw.addr & PSW_ADDR_INSN)
 #define user_stack_pointer(regs)((regs)->gprs[15])
diff -puN arch/sparc/include/asm/ptrace_64.h~remove-__arch_want_compat_sys_ptrace arch/sparc/include/asm/ptrace_64.h
--- a/arch/sparc/include/asm/ptrace_64.h~remove-__arch_want_compat_sys_ptrace
+++ a/arch/sparc/include/asm/ptrace_64.h
@@ -142,8 +142,6 @@ struct global_reg_snapshot {
 };
 extern struct global_reg_snapshot global_reg_snapshot[NR_CPUS];
 
-#define __ARCH_WANT_COMPAT_SYS_PTRACE
-
 #define force_successful_syscall_return()	    \
 do {	current_thread_info()->syscall_noerror = 1; \
 } while (0)
diff -puN arch/x86/include/asm/ptrace.h~remove-__arch_want_compat_sys_ptrace arch/x86/include/asm/ptrace.h
--- a/arch/x86/include/asm/ptrace.h~remove-__arch_want_compat_sys_ptrace
+++ a/arch/x86/include/asm/ptrace.h
@@ -271,8 +271,6 @@ extern int do_get_thread_area(struct tas
 extern int do_set_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info, int can_allocate);
 
-#define __ARCH_WANT_COMPAT_SYS_PTRACE
-
 #endif /* __KERNEL__ */
 
 #endif /* !__ASSEMBLY__ */
diff -puN include/linux/compat.h~remove-__arch_want_compat_sys_ptrace include/linux/compat.h
--- a/include/linux/compat.h~remove-__arch_want_compat_sys_ptrace
+++ a/include/linux/compat.h
@@ -252,12 +252,10 @@ extern int compat_ptrace_request(struct 
 				 compat_long_t request,
 				 compat_ulong_t addr, compat_ulong_t data);
 
-#ifdef __ARCH_WANT_COMPAT_SYS_PTRACE
 extern long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 			       compat_ulong_t addr, compat_ulong_t data);
 asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 				  compat_long_t addr, compat_long_t data);
-#endif	/* __ARCH_WANT_COMPAT_SYS_PTRACE */
 
 /*
  * epoll (fs/eventpoll.c) compat bits follow ...
diff -puN kernel/ptrace.c~remove-__arch_want_compat_sys_ptrace kernel/ptrace.c
--- a/kernel/ptrace.c~remove-__arch_want_compat_sys_ptrace
+++ a/kernel/ptrace.c
@@ -629,7 +629,7 @@ int generic_ptrace_pokedata(struct task_
 	return (copied == sizeof(data)) ? 0 : -EIO;
 }
 
-#if defined CONFIG_COMPAT && defined __ARCH_WANT_COMPAT_SYS_PTRACE
+#if defined CONFIG_COMPAT
 #include <linux/compat.h>
 
 int compat_ptrace_request(struct task_struct *child, compat_long_t request,
@@ -726,4 +726,4 @@ asmlinkage long compat_sys_ptrace(compat
 	unlock_kernel();
 	return ret;
 }
-#endif	/* CONFIG_COMPAT && __ARCH_WANT_COMPAT_SYS_PTRACE */
+#endif	/* CONFIG_COMPAT */
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
x86-remove-init_mm-export-as-planned-for-2626.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
fs-namespacec-drop-code-after-return.patch
introduce-new-lsm-hooks-where-vfsmount-is-available.patch
vfs-kill-fmode_ndelay_now.patch
vfs-document-fmode_-constants.patch
vfs-expand-some-comments-d_path-seq_path.patch
vfs-lseekfd-0-seek_cur-race-condition.patch
vfs-lseekfd-0-seek_cur-race-condition-fix.patch
block-do_mounts-add-device-info-to-mount-message.patch
loop-add-ioctl-to-resize-a-loop-device.patch
filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs.patch
filesystem-freeze-implement-generic-freeze-feature.patch
filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature.patch


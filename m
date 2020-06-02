From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 02 Jun 2020 11:28:34 -0700
Message-ID: <20200602182834.itiOjis0k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgFBS2h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 14:28:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/syscalls/syscall.tbl      |    3 
 arch/arm/tools/syscall.tbl                  |    3 
 arch/arm64/include/asm/ptrace.h             |    4 
 arch/arm64/include/asm/unistd.h             |    4 
 arch/arm64/include/asm/unistd32.h           |    3 
 arch/arm64/kvm/reset.c                      |    7 -
 arch/ia64/kernel/syscalls/syscall.tbl       |    3 
 arch/m68k/kernel/syscalls/syscall.tbl       |    3 
 arch/microblaze/kernel/syscalls/syscall.tbl |    3 
 arch/mips/kernel/syscalls/syscall_n32.tbl   |    3 
 arch/mips/kernel/syscalls/syscall_n64.tbl   |    3 
 arch/mips/kernel/syscalls/syscall_o32.tbl   |    3 
 arch/parisc/kernel/syscalls/syscall.tbl     |    3 
 arch/powerpc/kernel/syscalls/syscall.tbl    |    3 
 arch/powerpc/kernel/traps.c                 |   11 --
 arch/s390/kernel/syscalls/syscall.tbl       |    3 
 arch/sh/kernel/syscalls/syscall.tbl         |    3 
 arch/sparc/kernel/syscalls/syscall.tbl      |    3 
 arch/x86/entry/entry_32.S                   |   66 ------------
 arch/x86/entry/syscalls/syscall_32.tbl      |    3 
 arch/x86/entry/syscalls/syscall_64.tbl      |    3 
 arch/x86/include/asm/traps.h                |   93 ------------------
 arch/x86/kernel/cpu/mce/core.c              |   30 -----
 arch/x86/kernel/cpu/mce/p5.c                |   10 -
 arch/x86/kernel/cpu/mce/winchip.c           |    9 -
 arch/x86/kernel/traps.c                     |   77 --------------
 arch/xtensa/kernel/syscalls/syscall.tbl     |    3 
 fs/mount.h                                  |    3 
 include/linux/capability.h                  |    3 
 include/linux/hardirq.h                     |    8 -
 include/linux/sched.h                       |    4 
 include/uapi/asm-generic/unistd.h           |    6 -
 include/uapi/linux/capability.h             |    5 
 kernel/Makefile                             |    3 
 security/selinux/include/classmap.h         |    6 -
 35 files changed, 400 deletions(-)

--- a/arch/alpha/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/alpha/kernel/syscalls/syscall.tbl
@@ -478,9 +478,6 @@
 547	common	openat2				sys_openat2
 548	common	pidfd_getfd			sys_pidfd_getfd
 549	common	faccessat2			sys_faccessat2
-<<<<<<< HEAD
-=======
 550	common	watch_mount			sys_watch_mount
 551	common	watch_sb			sys_watch_sb
 552	common	fsinfo				sys_fsinfo
->>>>>>> linux-next/akpm-base
--- a/arch/arm64/include/asm/ptrace.h~linux-next-git-rejects
+++ a/arch/arm64/include/asm/ptrace.h
@@ -35,11 +35,7 @@
 #define GIC_PRIO_PSR_I_SET		(1 << 4)
 
 /* Additional SPSR bits not exposed in the UABI */
-<<<<<<< HEAD
-
-=======
 #define PSR_MODE_THREAD_BIT	(1 << 0)
->>>>>>> linux-next/akpm-base
 #define PSR_IL_BIT		(1 << 20)
 
 /* AArch32-specific ptrace requests */
--- a/arch/arm64/include/asm/unistd32.h~linux-next-git-rejects
+++ a/arch/arm64/include/asm/unistd32.h
@@ -885,15 +885,12 @@ __SYSCALL(__NR_openat2, sys_openat2)
 __SYSCALL(__NR_pidfd_getfd, sys_pidfd_getfd)
 #define __NR_faccessat2 439
 __SYSCALL(__NR_faccessat2, sys_faccessat2)
-<<<<<<< HEAD
-=======
 #define __NR_watch_mount 440
 __SYSCALL(__NR_watch_mount, sys_watch_mount)
 #define __NR_watch_sb 441
 __SYSCALL(__NR_watch_sb, sys_watch_sb)
 #define __NR_fsinfo 442
 __SYSCALL(__NR_fsinfo, sys_fsinfo)
->>>>>>> linux-next/akpm-base
 
 /*
  * Please add new compat syscalls above this comment and update
--- a/arch/arm64/include/asm/unistd.h~linux-next-git-rejects
+++ a/arch/arm64/include/asm/unistd.h
@@ -38,11 +38,7 @@
 #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE + 5)
 #define __ARM_NR_COMPAT_END		(__ARM_NR_COMPAT_BASE + 0x800)
 
-<<<<<<< HEAD
-#define __NR_compat_syscalls		440
-=======
 #define __NR_compat_syscalls		443
->>>>>>> linux-next/akpm-base
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
--- a/arch/arm64/kvm/reset.c~linux-next-git-rejects
+++ a/arch/arm64/kvm/reset.c
@@ -39,15 +39,8 @@ static u32 kvm_ipa_limit;
 #define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
 				 PSR_F_BIT | PSR_D_BIT)
 
-<<<<<<< HEAD
-static const struct kvm_regs default_regs_reset32 = {
-	.regs.pstate = (PSR_AA32_MODE_SVC | PSR_AA32_A_BIT |
-			PSR_AA32_I_BIT | PSR_AA32_F_BIT),
-};
-=======
 #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
 				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
->>>>>>> linux-next/akpm-base
 
 /**
  * kvm_arch_vm_ioctl_check_extension
--- a/arch/arm/tools/syscall.tbl~linux-next-git-rejects
+++ a/arch/arm/tools/syscall.tbl
@@ -452,9 +452,6 @@
 437	common	openat2				sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
-<<<<<<< HEAD
-=======
 440	common	watch_mount			sys_watch_mount
 441	common	watch_sb			sys_watch_sb
 442	common	fsinfo				sys_fsinfo
->>>>>>> linux-next/akpm-base
--- a/arch/ia64/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/ia64/kernel/syscalls/syscall.tbl
@@ -359,9 +359,6 @@
 437	common	openat2				sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
-<<<<<<< HEAD
-=======
 440	common	watch_mount			sys_watch_mount
 441	common	watch_sb			sys_watch_sb
 442	common	fsinfo				sys_fsinfo
->>>>>>> linux-next/akpm-base
--- a/arch/m68k/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/m68k/kernel/syscalls/syscall.tbl
@@ -438,9 +438,6 @@
 437	common	openat2				sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
-<<<<<<< HEAD
-=======
 440	common	watch_mount			sys_watch_mount
 441	common	watch_sb			sys_watch_sb
 442	common	fsinfo				sys_fsinfo
->>>>>>> linux-next/akpm-base
--- a/arch/microblaze/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -444,9 +444,6 @@
 437	common	openat2				sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
-<<<<<<< HEAD
-=======
 440	common	watch_mount			sys_watch_mount
 441	common	watch_sb			sys_watch_sb
 442	common	fsinfo				sys_fsinfo
->>>>>>> linux-next/akpm-base
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl~linux-next-git-rejects
+++ a/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -377,9 +377,6 @@
 437	n32	openat2				sys_openat2
 438	n32	pidfd_getfd			sys_pidfd_getfd
 439	n32	faccessat2			sys_faccessat2
-<<<<<<< HEAD
-=======
 440	n32	watch_mount			sys_watch_mount
 441	n32	watch_sb			sys_watch_sb
 442	n32	fsinfo				sys_fsinfo
->>>>>>> linux-next/akpm-base
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl~linux-next-git-rejects
+++ a/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -353,9 +353,6 @@
 437	n64	openat2				sys_openat2
 438	n64	pidfd_getfd			sys_pidfd_getfd
 439	n64	faccessat2			sys_faccessat2
-<<<<<<< HEAD
-=======
 440	n64	watch_mount			sys_watch_mount
 441	n64	watch_sb			sys_watch_sb
 442	n64	fsinfo				sys_fsinfo
->>>>>>> linux-next/akpm-base
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl~linux-next-git-rejects
+++ a/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -426,9 +426,6 @@
 437	o32	openat2				sys_openat2
 438	o32	pidfd_getfd			sys_pidfd_getfd
 439	o32	faccessat2			sys_faccessat2
-<<<<<<< HEAD
-=======
 440	o32	watch_mount			sys_watch_mount
 441	o32	watch_sb			sys_watch_sb
 442	o32	fsinfo				sys_fsinfo
->>>>>>> linux-next/akpm-base
--- a/arch/parisc/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/parisc/kernel/syscalls/syscall.tbl
@@ -436,9 +436,6 @@
 437	common	openat2				sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
-<<<<<<< HEAD
-=======
 440	common	watch_mount			sys_watch_mount
 441	common	watch_sb			sys_watch_sb
 442	common	fsinfo				sys_fsinfo
->>>>>>> linux-next/akpm-base
--- a/arch/powerpc/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -528,9 +528,6 @@
 437	common	openat2				sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
-<<<<<<< HEAD
-=======
 440	common	watch_mount			sys_watch_mount
 441	common	watch_sb			sys_watch_sb
 442	common	fsinfo				sys_fsinfo
->>>>>>> linux-next/akpm-base
--- a/arch/powerpc/kernel/traps.c~linux-next-git-rejects
+++ a/arch/powerpc/kernel/traps.c
@@ -444,11 +444,8 @@ void system_reset_exception(struct pt_re
 	bool saved_hsrrs = false;
 	u8 ftrace_enabled = this_cpu_get_ftrace_enabled();
 
-<<<<<<< HEAD
-=======
 	this_cpu_set_ftrace_enabled(0);
 
->>>>>>> linux-next/akpm-base
 	nmi_enter();
 
 	/*
@@ -522,11 +519,8 @@ out:
 	}
 
 	nmi_exit();
-<<<<<<< HEAD
-=======
 
 	this_cpu_set_ftrace_enabled(ftrace_enabled);
->>>>>>> linux-next/akpm-base
 
 	/* What should we do here? We could issue a shutdown or hard reset. */
 }
@@ -833,10 +827,6 @@ int machine_check_generic(struct pt_regs
 void machine_check_exception(struct pt_regs *regs)
 {
 	int recover = 0;
-<<<<<<< HEAD
-
-	nmi_enter();
-=======
 	bool nested;
 
 	/*
@@ -852,7 +842,6 @@ void machine_check_exception(struct pt_r
 		nested = false;
 	if (!nested)
 		nmi_enter();
->>>>>>> linux-next/akpm-base
 
 	__this_cpu_inc(irq_stat.mce_exceptions);
 
--- a/arch/s390/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/s390/kernel/syscalls/syscall.tbl
@@ -441,9 +441,6 @@
 437  common	openat2			sys_openat2			sys_openat2
 438  common	pidfd_getfd		sys_pidfd_getfd			sys_pidfd_getfd
 439  common	faccessat2		sys_faccessat2			sys_faccessat2
-<<<<<<< HEAD
-=======
 440	common	watch_mount		sys_watch_mount			sys_watch_mount
 441	common	watch_sb		sys_watch_sb			sys_watch_sb
 442  common	fsinfo			sys_fsinfo			sys_fsinfo
->>>>>>> linux-next/akpm-base
--- a/arch/sh/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/sh/kernel/syscalls/syscall.tbl
@@ -441,9 +441,6 @@
 437	common	openat2				sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
-<<<<<<< HEAD
-=======
 440	common	watch_mount			sys_watch_mount
 441	common	watch_sb			sys_watch_sb
 442	common	fsinfo				sys_fsinfo
->>>>>>> linux-next/akpm-base
--- a/arch/sparc/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/sparc/kernel/syscalls/syscall.tbl
@@ -484,9 +484,6 @@
 437	common	openat2			sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
-<<<<<<< HEAD
-=======
 440	common	watch_mount			sys_watch_mount
 441	common	watch_sb			sys_watch_sb
 442	common	fsinfo				sys_fsinfo
->>>>>>> linux-next/akpm-base
--- a/arch/x86/entry/entry_32.S~linux-next-git-rejects
+++ a/arch/x86/entry/entry_32.S
@@ -1243,60 +1243,7 @@ SYM_FUNC_START(xen_failsafe_callback)
 SYM_FUNC_END(xen_failsafe_callback)
 #endif /* CONFIG_XEN_PV */
 
-<<<<<<< HEAD
-#ifdef CONFIG_XEN_PVHVM
-BUILD_INTERRUPT3(xen_hvm_callback_vector, HYPERVISOR_CALLBACK_VECTOR,
-		 xen_evtchn_do_upcall)
-#endif
-
-
-#if IS_ENABLED(CONFIG_HYPERV)
-
-BUILD_INTERRUPT3(hyperv_callback_vector, HYPERVISOR_CALLBACK_VECTOR,
-		 hyperv_vector_handler)
-
-BUILD_INTERRUPT3(hyperv_reenlightenment_vector, HYPERV_REENLIGHTENMENT_VECTOR,
-		 hyperv_reenlightenment_intr)
-
-BUILD_INTERRUPT3(hv_stimer0_callback_vector, HYPERV_STIMER0_VECTOR,
-		 hv_stimer0_vector_handler)
-
-#endif /* CONFIG_HYPERV */
-
-SYM_CODE_START(page_fault)
-	ASM_CLAC
-	pushl	$do_page_fault
-	jmp	common_exception_read_cr2
-SYM_CODE_END(page_fault)
-
-SYM_CODE_START_LOCAL_NOALIGN(common_exception_read_cr2)
-	/* the function address is in %gs's slot on the stack */
-	SAVE_ALL switch_stacks=1 skip_gs=1 unwind_espfix=1
-
-	ENCODE_FRAME_POINTER
-
-	/* fixup %gs */
-	GS_TO_REG %ecx
-	movl	PT_GS(%esp), %edi
-	REG_TO_PTGS %ecx
-	SET_KERNEL_GS %ecx
-
-	GET_CR2_INTO(%ecx)			# might clobber %eax
-
-	/* fixup orig %eax */
-	movl	PT_ORIG_EAX(%esp), %edx		# get the error code
-	movl	$-1, PT_ORIG_EAX(%esp)		# no syscall to restart
-
-	TRACE_IRQS_OFF
-	movl	%esp, %eax			# pt_regs pointer
-	CALL_NOSPEC edi
-	jmp	ret_from_exception
-SYM_CODE_END(common_exception_read_cr2)
-
-SYM_CODE_START_LOCAL_NOALIGN(common_exception)
-=======
 SYM_CODE_START_LOCAL_NOALIGN(handle_exception)
->>>>>>> linux-next/akpm-base
 	/* the function address is in %gs's slot on the stack */
 	SAVE_ALL switch_stacks=1 skip_gs=1 unwind_espfix=1
 	ENCODE_FRAME_POINTER
@@ -1313,11 +1260,6 @@ SYM_CODE_START_LOCAL_NOALIGN(handle_exce
 
 	movl	%esp, %eax			# pt_regs pointer
 	CALL_NOSPEC edi
-<<<<<<< HEAD
-	jmp	ret_from_exception
-SYM_CODE_END(common_exception)
-=======
->>>>>>> linux-next/akpm-base
 
 handle_exception_return:
 #ifdef CONFIG_VM86
@@ -1334,9 +1276,6 @@ handle_exception_return:
 	cmpl	$USER_RPL, %eax			# returning to v8086 or userspace ?
 	jnb	ret_to_user
 
-<<<<<<< HEAD
-SYM_CODE_START(double_fault)
-=======
 	PARANOID_EXIT_TO_KERNEL_MODE
 	BUG_IF_WRONG_CR3
 	RESTORE_REGS 4
@@ -1348,7 +1287,6 @@ ret_to_user:
 SYM_CODE_END(handle_exception)
 
 SYM_CODE_START(asm_exc_double_fault)
->>>>>>> linux-next/akpm-base
 1:
 	/*
 	 * This is a task gate handler, not an interrupt gate handler.
@@ -1386,11 +1324,7 @@ SYM_CODE_START(asm_exc_double_fault)
 1:
 	hlt
 	jmp 1b
-<<<<<<< HEAD
-SYM_CODE_END(double_fault)
-=======
 SYM_CODE_END(asm_exc_double_fault)
->>>>>>> linux-next/akpm-base
 
 /*
  * NMI is doubly nasty.  It can happen on the first instruction of
--- a/arch/x86/entry/syscalls/syscall_32.tbl~linux-next-git-rejects
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -443,9 +443,6 @@
 437	i386	openat2			sys_openat2
 438	i386	pidfd_getfd		sys_pidfd_getfd
 439	i386	faccessat2		sys_faccessat2
-<<<<<<< HEAD
-=======
 440	i386	watch_mount		sys_watch_mount
 441	i386	watch_sb		sys_watch_sb
 442	i386	fsinfo			sys_fsinfo
->>>>>>> linux-next/akpm-base
--- a/arch/x86/entry/syscalls/syscall_64.tbl~linux-next-git-rejects
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -360,12 +360,9 @@
 437	common	openat2			sys_openat2
 438	common	pidfd_getfd		sys_pidfd_getfd
 439	common	faccessat2		sys_faccessat2
-<<<<<<< HEAD
-=======
 440	common	watch_mount		sys_watch_mount
 441	common	watch_sb		sys_watch_sb
 442	common	fsinfo			sys_fsinfo
->>>>>>> linux-next/akpm-base
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
--- a/arch/x86/include/asm/traps.h~linux-next-git-rejects
+++ a/arch/x86/include/asm/traps.h
@@ -9,86 +9,6 @@
 #include <asm/idtentry.h>
 #include <asm/siginfo.h>			/* TRAP_TRACE, ... */
 
-<<<<<<< HEAD
-#define dotraplinkage __visible
-
-asmlinkage void divide_error(void);
-asmlinkage void debug(void);
-asmlinkage void nmi(void);
-asmlinkage void int3(void);
-asmlinkage void overflow(void);
-asmlinkage void bounds(void);
-asmlinkage void invalid_op(void);
-asmlinkage void device_not_available(void);
-#ifdef CONFIG_X86_64
-asmlinkage void double_fault(void);
-#endif
-asmlinkage void coprocessor_segment_overrun(void);
-asmlinkage void invalid_TSS(void);
-asmlinkage void segment_not_present(void);
-asmlinkage void stack_segment(void);
-asmlinkage void general_protection(void);
-asmlinkage void page_fault(void);
-asmlinkage void async_page_fault(void);
-asmlinkage void spurious_interrupt_bug(void);
-asmlinkage void coprocessor_error(void);
-asmlinkage void alignment_check(void);
-#ifdef CONFIG_X86_MCE
-asmlinkage void machine_check(void);
-#endif /* CONFIG_X86_MCE */
-asmlinkage void simd_coprocessor_error(void);
-
-#if defined(CONFIG_X86_64) && defined(CONFIG_XEN_PV)
-asmlinkage void xen_divide_error(void);
-asmlinkage void xen_xennmi(void);
-asmlinkage void xen_xendebug(void);
-asmlinkage void xen_int3(void);
-asmlinkage void xen_overflow(void);
-asmlinkage void xen_bounds(void);
-asmlinkage void xen_invalid_op(void);
-asmlinkage void xen_device_not_available(void);
-asmlinkage void xen_double_fault(void);
-asmlinkage void xen_coprocessor_segment_overrun(void);
-asmlinkage void xen_invalid_TSS(void);
-asmlinkage void xen_segment_not_present(void);
-asmlinkage void xen_stack_segment(void);
-asmlinkage void xen_general_protection(void);
-asmlinkage void xen_page_fault(void);
-asmlinkage void xen_spurious_interrupt_bug(void);
-asmlinkage void xen_coprocessor_error(void);
-asmlinkage void xen_alignment_check(void);
-#ifdef CONFIG_X86_MCE
-asmlinkage void xen_machine_check(void);
-#endif /* CONFIG_X86_MCE */
-asmlinkage void xen_simd_coprocessor_error(void);
-#endif
-
-dotraplinkage void do_divide_error(struct pt_regs *regs, long error_code);
-dotraplinkage void do_debug(struct pt_regs *regs, long error_code);
-dotraplinkage void do_nmi(struct pt_regs *regs, long error_code);
-dotraplinkage void do_int3(struct pt_regs *regs, long error_code);
-dotraplinkage void do_overflow(struct pt_regs *regs, long error_code);
-dotraplinkage void do_bounds(struct pt_regs *regs, long error_code);
-dotraplinkage void do_invalid_op(struct pt_regs *regs, long error_code);
-dotraplinkage void do_device_not_available(struct pt_regs *regs, long error_code);
-dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code, unsigned long cr2);
-dotraplinkage void do_coprocessor_segment_overrun(struct pt_regs *regs, long error_code);
-dotraplinkage void do_invalid_TSS(struct pt_regs *regs, long error_code);
-dotraplinkage void do_segment_not_present(struct pt_regs *regs, long error_code);
-dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code);
-dotraplinkage void do_general_protection(struct pt_regs *regs, long error_code);
-dotraplinkage void do_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned long address);
-dotraplinkage void do_spurious_interrupt_bug(struct pt_regs *regs, long error_code);
-dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code);
-dotraplinkage void do_alignment_check(struct pt_regs *regs, long error_code);
-dotraplinkage void do_simd_coprocessor_error(struct pt_regs *regs, long error_code);
-#ifdef CONFIG_X86_32
-dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code);
-#endif
-dotraplinkage void do_mce(struct pt_regs *regs, long error_code);
-
-=======
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_X86_64
 asmlinkage __visible notrace struct pt_regs *sync_regs(struct pt_regs *eregs);
 asmlinkage __visible notrace
@@ -114,19 +34,6 @@ static inline int get_si_code(unsigned l
 extern int panic_on_unrecovered_nmi;
 
 void math_emulate(struct math_emu_info *);
-<<<<<<< HEAD
-#ifndef CONFIG_X86_32
-asmlinkage void smp_thermal_interrupt(struct pt_regs *regs);
-asmlinkage void smp_threshold_interrupt(struct pt_regs *regs);
-asmlinkage void smp_deferred_error_interrupt(struct pt_regs *regs);
-#endif
-
-void smp_apic_timer_interrupt(struct pt_regs *regs);
-void smp_spurious_interrupt(struct pt_regs *regs);
-void smp_error_interrupt(struct pt_regs *regs);
-asmlinkage void smp_irq_move_cleanup_interrupt(void);
-=======
->>>>>>> linux-next/akpm-base
 
 #ifdef CONFIG_VMAP_STACK
 void __noreturn handle_stack_overflow(const char *message,
--- a/arch/x86/kernel/cpu/mce/core.c~linux-next-git-rejects
+++ a/arch/x86/kernel/cpu/mce/core.c
@@ -1181,20 +1181,12 @@ static void kill_me_maybe(struct callbac
 	int flags = MF_ACTION_REQUIRED;
 
 	pr_err("Uncorrected hardware memory error in user-access at %llx", p->mce_addr);
-<<<<<<< HEAD
-	if (!(p->mce_status & MCG_STATUS_RIPV))
-		flags |= MF_MUST_KILL;
-
-	if (!memory_failure(p->mce_addr >> PAGE_SHIFT, flags)) {
-		set_mce_nospec(p->mce_addr >> PAGE_SHIFT);
-=======
 
 	if (!p->mce_ripv)
 		flags |= MF_MUST_KILL;
 
 	if (!memory_failure(p->mce_addr >> PAGE_SHIFT, flags)) {
 		set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
->>>>>>> linux-next/akpm-base
 		return;
 	}
 
@@ -1220,11 +1212,7 @@ static void kill_me_maybe(struct callbac
  * backing the user stack, tracing that reads the user stack will cause
  * potentially infinite recursion.
  */
-<<<<<<< HEAD
-void noinstr do_machine_check(struct pt_regs *regs, long error_code)
-=======
 void noinstr do_machine_check(struct pt_regs *regs)
->>>>>>> linux-next/akpm-base
 {
 	DECLARE_BITMAP(valid_banks, MAX_NR_BANKS);
 	DECLARE_BITMAP(toclear, MAX_NR_BANKS);
@@ -1257,14 +1245,6 @@ void noinstr do_machine_check(struct pt_
 	 */
 	int lmce = 1;
 
-<<<<<<< HEAD
-	if (__mc_check_crashing_cpu(cpu))
-		return;
-
-	nmi_enter();
-
-=======
->>>>>>> linux-next/akpm-base
 	this_cpu_inc(mce_exception_count);
 
 	mce_gather_info(&m, regs);
@@ -1360,12 +1340,8 @@ void noinstr do_machine_check(struct pt_
 		BUG_ON(!on_thread_stack() || !user_mode(regs));
 
 		current->mce_addr = m.addr;
-<<<<<<< HEAD
-		current->mce_status = m.mcgstatus;
-=======
 		current->mce_ripv = !!(m.mcgstatus & MCG_STATUS_RIPV);
 		current->mce_whole_page = whole_page(&m);
->>>>>>> linux-next/akpm-base
 		current->mce_kill_me.func = kill_me_maybe;
 		if (kill_it)
 			current->mce_kill_me.func = kill_me_now;
@@ -1385,12 +1361,6 @@ void noinstr do_machine_check(struct pt_
 				mce_panic("Failed kernel mode recovery", &m, msg);
 		}
 	}
-<<<<<<< HEAD
-
-out_ist:
-	nmi_exit();
-=======
->>>>>>> linux-next/akpm-base
 }
 EXPORT_SYMBOL_GPL(do_machine_check);
 
--- a/arch/x86/kernel/cpu/mce/p5.c~linux-next-git-rejects
+++ a/arch/x86/kernel/cpu/mce/p5.c
@@ -25,12 +25,7 @@ static noinstr void pentium_machine_chec
 {
 	u32 loaddr, hi, lotype;
 
-<<<<<<< HEAD
-	nmi_enter();
-
-=======
 	instrumentation_begin();
->>>>>>> linux-next/akpm-base
 	rdmsr(MSR_IA32_P5_MC_ADDR, loaddr, hi);
 	rdmsr(MSR_IA32_P5_MC_TYPE, lotype, hi);
 
@@ -43,12 +38,7 @@ static noinstr void pentium_machine_chec
 	}
 
 	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_NOW_UNRELIABLE);
-<<<<<<< HEAD
-
-	nmi_exit();
-=======
 	instrumentation_end();
->>>>>>> linux-next/akpm-base
 }
 
 /* Set up machine check reporting for processors with Intel style MCE: */
--- a/arch/x86/kernel/cpu/mce/winchip.c~linux-next-git-rejects
+++ a/arch/x86/kernel/cpu/mce/winchip.c
@@ -19,19 +19,10 @@
 /* Machine check handler for WinChip C6: */
 static noinstr void winchip_machine_check(struct pt_regs *regs)
 {
-<<<<<<< HEAD
-	nmi_enter();
-
-	pr_emerg("CPU0: Machine Check Exception.\n");
-	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_NOW_UNRELIABLE);
-
-	nmi_exit();
-=======
 	instrumentation_begin();
 	pr_emerg("CPU0: Machine Check Exception.\n");
 	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_NOW_UNRELIABLE);
 	instrumentation_end();
->>>>>>> linux-next/akpm-base
 }
 
 /* Set up machine check reporting on the Winchip C6 series */
--- a/arch/x86/kernel/traps.c~linux-next-git-rejects
+++ a/arch/x86/kernel/traps.c
@@ -388,10 +388,7 @@ DEFINE_IDTENTRY_DF(exc_double_fault)
 #endif
 
 	nmi_enter();
-<<<<<<< HEAD
-=======
 	instrumentation_begin();
->>>>>>> linux-next/akpm-base
 	notify_die(DIE_TRAP, str, regs, error_code, X86_TRAP_DF, SIGSEGV);
 
 	tsk->thread.error_code = error_code;
@@ -584,21 +581,7 @@ exit:
 
 static bool do_int3(struct pt_regs *regs)
 {
-<<<<<<< HEAD
-	if (poke_int3_handler(regs))
-		return;
-
-	/*
-	 * Unlike any other non-IST entry, we can be called from pretty much
-	 * any location in the kernel through kprobes -- text_poke() will most
-	 * likely be handled by poke_int3_handler() above. This means this
-	 * handler is effectively NMI-like.
-	 */
-	if (!user_mode(regs))
-		nmi_enter();
-=======
 	int res;
->>>>>>> linux-next/akpm-base
 
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, 0, X86_TRAP_BP,
@@ -625,11 +608,6 @@ static void do_int3_user(struct pt_regs
 	cond_local_irq_disable(regs);
 }
 
-<<<<<<< HEAD
-exit:
-	if (!user_mode(regs))
-		nmi_exit();
-=======
 DEFINE_IDTENTRY_RAW(exc_int3)
 {
 	/*
@@ -664,7 +642,6 @@ DEFINE_IDTENTRY_RAW(exc_int3)
 		instrumentation_end();
 		nmi_exit();
 	}
->>>>>>> linux-next/akpm-base
 }
 
 #ifdef CONFIG_X86_64
@@ -804,55 +781,6 @@ static void noinstr handle_debug(struct
 	struct task_struct *tsk = current;
 	int si_code;
 
-<<<<<<< HEAD
-	nmi_enter();
-
-	get_debugreg(dr6, 6);
-	/*
-	 * The Intel SDM says:
-	 *
-	 *   Certain debug exceptions may clear bits 0-3. The remaining
-	 *   contents of the DR6 register are never cleared by the
-	 *   processor. To avoid confusion in identifying debug
-	 *   exceptions, debug handlers should clear the register before
-	 *   returning to the interrupted task.
-	 *
-	 * Keep it simple: clear DR6 immediately.
-	 */
-	set_debugreg(0, 6);
-
-	/* Filter out all the reserved bits which are preset to 1 */
-	dr6 &= ~DR6_RESERVED;
-
-	/*
-	 * The SDM says "The processor clears the BTF flag when it
-	 * generates a debug exception."  Clear TIF_BLOCKSTEP to keep
-	 * TIF_BLOCKSTEP in sync with the hardware BTF flag.
-	 */
-	clear_tsk_thread_flag(tsk, TIF_BLOCKSTEP);
-
-	if (unlikely(!user_mode(regs) && (dr6 & DR_STEP) &&
-		     is_sysenter_singlestep(regs))) {
-		dr6 &= ~DR_STEP;
-		if (!dr6)
-			goto exit;
-		/*
-		 * else we might have gotten a single-step trap and hit a
-		 * watchpoint at the same time, in which case we should fall
-		 * through and handle the watchpoint.
-		 */
-	}
-
-	/*
-	 * If dr6 has no reason to give us about the origin of this trap,
-	 * then it's very likely the result of an icebp/int01 trap.
-	 * User wants a sigtrap for that.
-	 */
-	if (!dr6 && user_mode(regs))
-		user_icebp = 1;
-
-=======
->>>>>>> linux-next/akpm-base
 	/* Store the virtualized DR6 value */
 	tsk->thread.debugreg6 = dr6;
 
@@ -900,10 +828,6 @@ out:
 	instrumentation_end();
 }
 
-<<<<<<< HEAD
-exit:
-	nmi_exit();
-=======
 static __always_inline void exc_debug_kernel(struct pt_regs *regs,
 					     unsigned long dr6)
 {
@@ -974,7 +898,6 @@ DEFINE_IDTENTRY_DEBUG_USER(exc_debug)
 	debug_enter(&dr6, &dr7);
 	exc_debug_user(regs, dr6);
 	debug_exit(dr7);
->>>>>>> linux-next/akpm-base
 }
 #else
 /* 32 bit does not have separate entry points. */
--- a/arch/xtensa/kernel/syscalls/syscall.tbl~linux-next-git-rejects
+++ a/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -409,9 +409,6 @@
 437	common	openat2				sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
-<<<<<<< HEAD
-=======
 440	common	watch_mount			sys_watch_mount
 441	common	watch_sb			sys_watch_sb
 442	common	fsinfo				sys_fsinfo
->>>>>>> linux-next/akpm-base
--- a/fs/mount.h~linux-next-git-rejects
+++ a/fs/mount.h
@@ -169,8 +169,6 @@ static inline bool is_anon_ns(struct mnt
 }
 
 extern void mnt_cursor_del(struct mnt_namespace *ns, struct mount *cursor);
-<<<<<<< HEAD
-=======
 
 #ifdef CONFIG_MOUNT_NOTIFICATIONS
 extern void notify_mount(struct mount *triggered,
@@ -185,4 +183,3 @@ static inline void notify_mount(struct m
 {
 }
 #endif
->>>>>>> linux-next/akpm-base
--- a/include/linux/capability.h~linux-next-git-rejects
+++ a/include/linux/capability.h
@@ -255,14 +255,11 @@ static inline bool perfmon_capable(void)
 {
 	return capable(CAP_PERFMON) || capable(CAP_SYS_ADMIN);
 }
-<<<<<<< HEAD
-=======
 
 static inline bool bpf_capable(void)
 {
 	return capable(CAP_BPF) || capable(CAP_SYS_ADMIN);
 }
->>>>>>> linux-next/akpm-base
 
 /* audit system wants to get cap info from files as well */
 extern int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps);
--- a/include/linux/hardirq.h~linux-next-git-rejects
+++ a/include/linux/hardirq.h
@@ -116,10 +116,6 @@ extern void rcu_nmi_exit(void);
 		arch_nmi_enter();				\
 		printk_nmi_enter();				\
 		lockdep_off();					\
-<<<<<<< HEAD
-		ftrace_nmi_enter();				\
-=======
->>>>>>> linux-next/akpm-base
 		BUG_ON(in_nmi() == NMI_MASK);			\
 		__preempt_count_add(NMI_OFFSET + HARDIRQ_OFFSET);	\
 		rcu_nmi_enter();				\
@@ -138,10 +134,6 @@ extern void rcu_nmi_exit(void);
 		rcu_nmi_exit();					\
 		BUG_ON(!in_nmi());				\
 		__preempt_count_sub(NMI_OFFSET + HARDIRQ_OFFSET);	\
-<<<<<<< HEAD
-		ftrace_nmi_exit();				\
-=======
->>>>>>> linux-next/akpm-base
 		lockdep_on();					\
 		printk_nmi_exit();				\
 		arch_nmi_exit();				\
--- a/include/linux/sched.h~linux-next-git-rejects
+++ a/include/linux/sched.h
@@ -1309,13 +1309,9 @@ struct task_struct {
 
 #ifdef CONFIG_X86_MCE
 	u64				mce_addr;
-<<<<<<< HEAD
-	u64				mce_status;
-=======
 	__u64				mce_ripv : 1,
 					mce_whole_page : 1,
 					__mce_reserved : 62;
->>>>>>> linux-next/akpm-base
 	struct callback_head		mce_kill_me;
 #endif
 
--- a/include/uapi/asm-generic/unistd.h~linux-next-git-rejects
+++ a/include/uapi/asm-generic/unistd.h
@@ -857,11 +857,6 @@ __SYSCALL(__NR_openat2, sys_openat2)
 __SYSCALL(__NR_pidfd_getfd, sys_pidfd_getfd)
 #define __NR_faccessat2 439
 __SYSCALL(__NR_faccessat2, sys_faccessat2)
-<<<<<<< HEAD
-
-#undef __NR_syscalls
-#define __NR_syscalls 440
-=======
 #define __NR_watch_mount 440
 __SYSCALL(__NR_watch_mount, sys_watch_mount)
 #define __NR_watch_sb 441
@@ -871,7 +866,6 @@ __SYSCALL(__NR_fsinfo, sys_fsinfo)
 
 #undef __NR_syscalls
 #define __NR_syscalls 443
->>>>>>> linux-next/akpm-base
 
 /*
  * 32 bit systems traditionally used different
--- a/include/uapi/linux/capability.h~linux-next-git-rejects
+++ a/include/uapi/linux/capability.h
@@ -374,10 +374,6 @@ struct vfs_ns_cap_data {
  */
 
 #define CAP_PERFMON		38
-<<<<<<< HEAD
-
-#define CAP_LAST_CAP         CAP_PERFMON
-=======
 
 /*
  * CAP_BPF allows the following BPF operations:
@@ -411,7 +407,6 @@ struct vfs_ns_cap_data {
 #define CAP_BPF			39
 
 #define CAP_LAST_CAP         CAP_BPF
->>>>>>> linux-next/akpm-base
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
--- a/kernel/Makefile~linux-next-git-rejects
+++ a/kernel/Makefile
@@ -108,10 +108,7 @@ obj-$(CONFIG_IRQ_WORK) += irq_work.o
 obj-$(CONFIG_CPU_PM) += cpu_pm.o
 obj-$(CONFIG_BPF) += bpf/
 obj-$(CONFIG_SHADOW_CALL_STACK) += scs.o
-<<<<<<< HEAD
-=======
 obj-$(CONFIG_KCSAN) += kcsan/
->>>>>>> linux-next/akpm-base
 
 obj-$(CONFIG_PERF_EVENTS) += events/
 
--- a/security/selinux/include/classmap.h~linux-next-git-rejects
+++ a/security/selinux/include/classmap.h
@@ -27,15 +27,9 @@
 	    "audit_control", "setfcap"
 
 #define COMMON_CAP2_PERMS  "mac_override", "mac_admin", "syslog", \
-<<<<<<< HEAD
-		"wake_alarm", "block_suspend", "audit_read", "perfmon"
-
-#if CAP_LAST_CAP > CAP_PERFMON
-=======
 		"wake_alarm", "block_suspend", "audit_read", "perfmon", "bpf"
 
 #if CAP_LAST_CAP > CAP_BPF
->>>>>>> linux-next/akpm-base
 #error New capability defined, please update COMMON_CAP2_PERMS.
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix.patch
mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
lib-make-a-test-module-with-get_count_order-long-fix.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-pre.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
linux-next-post.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better-fix.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

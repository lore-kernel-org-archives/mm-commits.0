From: akpm@linux-foundation.org
Subject: + x86-64-slightly-streamline-32-bit-syscall-entry-code.patch added to -mm tree
Date: Tue, 02 Sep 2008 15:09:07 -0700
Message-ID: <200809022209.m82M97eI015282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732AbYIBWKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 18:10:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86-64: slightly streamline 32-bit syscall entry code
has been added to the -mm tree.  Its filename is
     x86-64-slightly-streamline-32-bit-syscall-entry-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-64: slightly streamline 32-bit syscall entry code
From: Jan Beulich <jbeulich@novell.com>

Avoid updating registers or memory twice as well as needlessly loading
or copying registers.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32entry.S |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff -puN arch/x86/ia32/ia32entry.S~x86-64-slightly-streamline-32-bit-syscall-entry-code arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~x86-64-slightly-streamline-32-bit-syscall-entry-code
+++ a/arch/x86/ia32/ia32entry.S
@@ -39,11 +39,11 @@
 	.endm 
 
 	/* clobbers %eax */	
-	.macro  CLEAR_RREGS
+	.macro  CLEAR_RREGS _r9=rax
 	xorl 	%eax,%eax
 	movq	%rax,R11(%rsp)
 	movq	%rax,R10(%rsp)
-	movq	%rax,R9(%rsp)
+	movq	%\_r9,R9(%rsp)
 	movq	%rax,R8(%rsp)
 	.endm
 
@@ -52,11 +52,10 @@
 	 * We don't reload %eax because syscall_trace_enter() returned
 	 * the value it wants us to use in the table lookup.
 	 */
-	.macro LOAD_ARGS32 offset
-	movl \offset(%rsp),%r11d
-	movl \offset+8(%rsp),%r10d
+	.macro LOAD_ARGS32 offset, _r9=0
+	.if \_r9
 	movl \offset+16(%rsp),%r9d
-	movl \offset+24(%rsp),%r8d
+	.endif
 	movl \offset+40(%rsp),%ecx
 	movl \offset+48(%rsp),%edx
 	movl \offset+56(%rsp),%esi
@@ -145,7 +144,7 @@ ENTRY(ia32_sysenter_target)
 	SAVE_ARGS 0,0,1
  	/* no need to do an access_ok check here because rbp has been
  	   32bit zero extended */ 
-1:	movl	(%rbp),%r9d
+1:	movl	(%rbp),%ebp
  	.section __ex_table,"a"
  	.quad 1b,ia32_badarg
  	.previous	
@@ -157,7 +156,7 @@ ENTRY(ia32_sysenter_target)
 	cmpl	$(IA32_NR_syscalls-1),%eax
 	ja	ia32_badsys
 sysenter_do_call:
-	IA32_ARG_FIXUP 1
+	IA32_ARG_FIXUP
 sysenter_dispatch:
 	call	*ia32_sys_call_table(,%rax,8)
 	movq	%rax,RAX-ARGOFFSET(%rsp)
@@ -234,20 +233,17 @@ sysexit_audit:
 #endif
 
 sysenter_tracesys:
-	xchgl	%r9d,%ebp
 #ifdef CONFIG_AUDITSYSCALL
 	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
 	jz	sysenter_auditsys
 #endif
 	SAVE_REST
 	CLEAR_RREGS
-	movq	%r9,R9(%rsp)
 	movq	$-ENOSYS,RAX(%rsp)/* ptrace can change this for a bad syscall */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	xchgl	%ebp,%r9d
 	cmpl	$(IA32_NR_syscalls-1),%eax
 	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
 	jmp	sysenter_do_call
@@ -314,9 +310,9 @@ ENTRY(ia32_cstar_target)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
-cstar_do_call:	
 	cmpl $IA32_NR_syscalls-1,%eax
 	ja  ia32_badsys
+cstar_do_call:
 	IA32_ARG_FIXUP 1
 cstar_dispatch:
 	call *ia32_sys_call_table(,%rax,8)
@@ -357,15 +353,13 @@ cstar_tracesys:
 #endif
 	xchgl %r9d,%ebp
 	SAVE_REST
-	CLEAR_RREGS
-	movq %r9,R9(%rsp)
+	CLEAR_RREGS r9
 	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
-	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	LOAD_ARGS32 ARGOFFSET, 1  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	xchgl %ebp,%r9d
-	movl RSP-ARGOFFSET(%rsp), %r8d
 	cmpl $(IA32_NR_syscalls-1),%eax
 	ja int_ret_from_sys_call /* cstar_tracesys has set RAX(%rsp) */
 	jmp cstar_do_call
_

Patches currently in -mm which might be from jbeulich@novell.com are

linux-next.patch
x86-init-annotations-in-early_printk-setup.patch
x86-adjust-dependencies-for-config_x86_cmov.patch
x86-pgd_cdtor-cleanup.patch
x86-x86_physvirt_bits-field-also-for-i386.patch
x86-adjust-vmalloc_sync_all-for-xen-2nd-try.patch
x86-fix-ticket-spin-lock-asm-constraints.patch
x86-64-reduce-boot-fixmap-space.patch
x86-64-add-two-__cpuinit-annotations.patch
x86-64-eliminate-dead-code.patch
x86-64-slightly-streamline-32-bit-syscall-entry-code.patch
adjust-init-section-definitions.patch
kconfig-eliminate-def_bool-n-constructs.patch


From: akpm@linux-foundation.org
Subject: - x86-32-bit-ptrace-emulation-mishandles-6th-arg.patch removed from -mm tree
Date: Mon, 12 Nov 2007 20:08:02 -0800
Message-ID: <200711130408.lAD482kf025276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58465 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756498AbXKMER0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 23:17:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 76306.1226@compuserve.com, jdike@linux.intel.com, mingo@elte.hu, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: 32-bit ptrace emulation mishandles 6th arg
has been removed from the -mm tree.  Its filename was
     x86-32-bit-ptrace-emulation-mishandles-6th-arg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: 32-bit ptrace emulation mishandles 6th arg
From: Chuck Ebbert <76306.1226@compuserve.com>

[ jdike - Pushing Chuck's patch - see
http://lkml.org/lkml/2005/9/16/261 for some history and a test
program.  UML is also broken without this patch - its processes get
SIGBUS from the corrupt 6th argument to mmap being interpretted as a
file offset ]

When the 32-bit vDSO is used to make a system call, the %ebp register for
the 6th syscall arg has to be loaded from the user stack (where it's pushed
by the vDSO user code).  The native i386 kernel always does this before
stopping for syscall tracing, so %ebp can be seen and modified via ptrace
to access the 6th syscall argument.  The x86-64 kernel fails to do this,
presenting the stack address to ptrace instead.  This makes the %rbp value
seen by 64-bit ptrace of a 32-bit process, and the %ebp value seen by a
32-bit caller of ptrace, both differ from the native i386 behavior.

This patch fixes the problem by putting the word loaded from the user stack
into %rbp before calling syscall_trace_enter, and reloading the 6th syscall
argument from there afterwards (so ptrace can change it).  This makes the
behavior match that of i386 kernels.

Signed-off-by: Chuck Ebbert <76306.1226@compuserve.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Original-Patch-By: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32entry.S |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff -puN arch/x86/ia32/ia32entry.S~x86-32-bit-ptrace-emulation-mishandles-6th-arg arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~x86-32-bit-ptrace-emulation-mishandles-6th-arg
+++ a/arch/x86/ia32/ia32entry.S
@@ -159,20 +159,16 @@ sysenter_do_call:	
 
 sysenter_tracesys:
 	CFI_RESTORE_STATE
+	xchgl	%r9d,%ebp
 	SAVE_REST
 	CLEAR_RREGS
+	movq	%r9,R9(%rsp)
 	movq	$-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	movl	%ebp, %ebp
-	/* no need to do an access_ok check here because rbp has been
-	   32bit zero extended */ 
-1:	movl	(%rbp),%r9d
-	.section __ex_table,"a"
-	.quad 1b,ia32_badarg
-	.previous
+	xchgl	%ebp,%r9d
 	jmp	sysenter_do_call
 	CFI_ENDPROC
 ENDPROC(ia32_sysenter_target)
@@ -262,20 +258,17 @@ cstar_do_call:	
 	
 cstar_tracesys:	
 	CFI_RESTORE_STATE
+	xchgl %r9d,%ebp
 	SAVE_REST
 	CLEAR_RREGS
+	movq %r9,R9(%rsp)
 	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
+	xchgl %ebp,%r9d
 	movl RSP-ARGOFFSET(%rsp), %r8d
-	/* no need to do an access_ok check here because r8 has been
-	   32bit zero extended */ 
-1:	movl	(%r8),%r9d
-	.section __ex_table,"a"
-	.quad 1b,ia32_badarg
-	.previous
 	jmp cstar_do_call
 END(ia32_cstar_target)
 				
_

Patches currently in -mm which might be from 76306.1226@compuserve.com are

origin.patch

From: akpm@linux-foundation.org
Subject: - arch-x86_64-kernel-trapsc-ptrace_singlestep-oops.patch removed from -mm tree
Date: Wed, 09 May 2007 15:25:45 -0700
Message-ID: <200705092225.l49MPjdf004241@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759037AbXEIWZy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:25:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john.blackwood@ccur.com, mm-commits@vger.kernel.org


The patch titled
     arch/x86_64/kernel/traps.c PTRACE_SINGLESTEP oops
has been removed from the -mm tree.  Its filename was
     arch-x86_64-kernel-trapsc-ptrace_singlestep-oops.patch

This patch was dropped because I'm cleaning old stuff out of my patches directory

------------------------------------------------------
Subject: arch/x86_64/kernel/traps.c PTRACE_SINGLESTEP oops
From: John Blackwood <john.blackwood@ccur.com>


We found a problem with x86_64 kernels with preemption enabled, where
having multiple tasks doing ptrace singlesteps around the same time will
cause the system to 'oops'.  The problem seems that a task can get
preempted out of the do_debug() processing while it is running on the
DEBUG_STACK stack.  If another task on that same cpu then enters do_debug()
and uses the same per-cpu DEBUG_STACK stack, the previous preempted tasks's
stack contents can be corrupted, and the system will oops when the
preempted task is context switched back in again.

The typical oops looks like the following:
-----------------------------------------------------------------------------
Unable to handle kernel paging request at ffffffffffffffae RIP:
<ffffffff805452a1>{thread_return+34}
PGD 103027 PUD 102429067 PMD 0
Oops: 0002 [1] PREEMPT SMP
CPU 0
Modules linked in:
Pid: 3786, comm: ssdd Not tainted 2.6.15.2 #1
RIP: 0010:[<ffffffff805452a1>] <ffffffff805452a1>{thread_return+34}
RSP: 0018:ffffffff80824058  EFLAGS: 000136c2
RAX: ffff81017e12cea0 RBX: 0000000000000000 RCX: 00000000c0000100
RDX: 0000000000000000 RSI: ffff8100f7856e20 RDI: ffff81017e12cea0
RBP: 0000000000000046 R08: ffff8100f68a6000 R09: 0000000000000000
R10: 0000000000000000 R11: ffff81017e12cea0 R12: ffff81000c2d53e8
R13: ffff81017f5b3be8 R14: ffff81000c0036e0 R15: 000001056cbfc899
FS:  00002aaaaaad9b00(0000) GS:ffffffff80883800(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffffffffae CR3: 00000000f6fcf000 CR4: 00000000000006e0
Process ssdd (pid: 3786, threadinfo ffff8100f68a6000, task ffff8100f7856e20)
Stack: ffffffff808240d8 ffffffff8012a84a ffff8100055f6c00 0000000000000020
        0000000000000001 ffff81000c0036e0 ffffffff808240b8 0000000000000000
        0000000000000000 0000000000000000
Call Trace: <#DB> <ffffffff8012a84a>{try_to_wake_up+985}
<ffffffff8012c0d3>{kick_process+87}
        <ffffffff8013b262>{signal_wake_up+48}
<ffffffff8013b5ce>{specific_send_sig_info+179}
        <ffffffff80546abc>{_spin_unlock_irqrestore+27}
<ffffffff8013b67c>{force_sig_info+159}
        <ffffffff801103a0>{do_debug+289} <ffffffff80110278>{sync_regs+103}
        <ffffffff8010ed9a>{paranoid_userspace+35}  <EOE> <1>Unable to
handle kernel paging request at 00007fffffb7d000 RIP:
<ffffffff8010f2e4>{show_trace+465}
PGD f6f25067 PUD f6fcc067 PMD f6957067 PTE 0
Oops: 0000 [2] PREEMPT SMP

This patch disables preemptions for the task upon entry to do_debug(), before
interrupts are reenabled, and then disables preemption before exiting
do_debug(), after disabling interrupts.  I've noticed that the task can be
preempted either at the end of an interrupt, or on the call to
force_sig_info() on the spin_unlock_irqrestore() processing.  It might be
better to attempt to code a fix in entry.S around the code that calls
do_debug().


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/traps.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/traps.c~arch-x86_64-kernel-trapsc-ptrace_singlestep-oops arch/x86_64/kernel/traps.c
--- devel/arch/x86_64/kernel/traps.c~arch-x86_64-kernel-trapsc-ptrace_singlestep-oops	2006-02-12 13:57:18.000000000 -0800
+++ devel-akpm/arch/x86_64/kernel/traps.c	2006-02-12 13:57:18.000000000 -0800
@@ -90,6 +90,20 @@ static inline void conditional_sti(struc
 		local_irq_enable();
 }
 
+static inline void preempt_conditional_sti(struct pt_regs *regs)
+{
+	preempt_disable();
+	if (regs->eflags & X86_EFLAGS_IF)
+		local_irq_enable();
+}
+
+static inline void preempt_conditional_cli(struct pt_regs *regs)
+{
+	if (regs->eflags & X86_EFLAGS_IF)
+		local_irq_disable();
+	preempt_enable_no_resched();
+}
+
 static int kstack_depth_to_print = 10;
 
 #ifdef CONFIG_KALLSYMS
@@ -693,7 +707,7 @@ asmlinkage void __kprobes do_debug(struc
 						SIGTRAP) == NOTIFY_STOP)
 		return;
 
-	conditional_sti(regs);
+	preempt_conditional_sti(regs);
 
 	/* Mask out spurious debug traps due to lazy DR7 setting */
 	if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) {
@@ -738,11 +752,13 @@ asmlinkage void __kprobes do_debug(struc
 
 clear_dr7:
 	set_debugreg(0UL, 7);
+	preempt_conditional_cli(regs);
 	return;
 
 clear_TF_reenable:
 	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
 	regs->eflags &= ~TF_MASK;
+	preempt_conditional_cli(regs);
 }
 
 static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
_

Patches currently in -mm which might be from john.blackwood@ccur.com are

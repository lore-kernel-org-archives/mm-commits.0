From: akpm@linux-foundation.org
Subject: [merged] dump_stack-unify-debug-information-printed-by-show_regs.patch removed from -mm tree
Date: Tue, 07 May 2013 10:47:16 -0700
Message-ID: <20130507174716.E213E5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:63931 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab3EGRrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:47:18 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so85052qec.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:47:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, bhelgaas@google.com, cmetcalf@tilera.com, davem@davemloft.net, fengguang.wu@intel.com, heiko.carstens@de.ibm.com, jesper.nilsson@axis.com, rkuo@codeaurora.org, sam@ravnborg.org, schwidefsky@de.ibm.com, vapier@gentoo.org, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dump_stack: unify debug information printed by show_regs()
has been removed from the -mm tree.  Its filename was
     dump_stack-unify-debug-information-printed-by-show_regs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: dump_stack: unify debug information printed by show_regs()

show_regs() is inherently arch-dependent but it does make sense to print
generic debug information and some archs already do albeit in slightly
different forms.  This patch introduces a generic function to print debug
information from show_regs() so that different archs print out the same
information and it's much easier to modify what's printed.

show_regs_print_info() prints out the same debug info as dump_stack()
does plus task and thread_info pointers.

* Archs which didn't print debug info now do.

  alpha, arc, blackfin, c6x, cris, frv, h8300, hexagon, ia64, m32r,
  metag, microblaze, mn10300, openrisc, parisc, score, sh64, sparc,
  um, xtensa

* Already prints debug info.  Replaced with show_regs_print_info().
  The printed information is superset of what used to be there.

  arm, arm64, avr32, mips, powerpc, sh32, tile, unicore32, x86

* s390 is special in that it used to print arch-specific information
  along with generic debug info.  Heiko and Martin think that the
  arch-specific extra isn't worth keeping s390 specfic implementation.
  Converted to use the generic version.

Note that now all archs print the debug info before actual register
dumps.

An example BUG() dump follows.

 kernel BUG at /work/os/work/kernel/workqueue.c:4841!
 invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 Modules linked in:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0-rc1-work+ #7
 Hardware name: empty empty/S3992, BIOS 080011  10/26/2007
 task: ffff88007c85e040 ti: ffff88007c860000 task.ti: ffff88007c860000
 RIP: 0010:[<ffffffff8234a07e>]  [<ffffffff8234a07e>] init_workqueues+0x4/0x6
 RSP: 0000:ffff88007c861ec8  EFLAGS: 00010246
 RAX: ffff88007c861fd8 RBX: ffffffff824466a8 RCX: 0000000000000001
 RDX: 0000000000000046 RSI: 0000000000000001 RDI: ffffffff8234a07a
 RBP: ffff88007c861ec8 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff8234a07a
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: ffff88015f7ff000 CR3: 00000000021f1000 CR4: 00000000000007f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Stack:
  ffff88007c861ef8 ffffffff81000312 ffffffff824466a8 ffff88007c85e650
  0000000000000003 0000000000000000 ffff88007c861f38 ffffffff82335e5d
  ffff88007c862080 ffffffff8223d8c0 ffff88007c862080 ffffffff81c47760
 Call Trace:
  [<ffffffff81000312>] do_one_initcall+0x122/0x170
  [<ffffffff82335e5d>] kernel_init_freeable+0x9b/0x1c8
  [<ffffffff81c47760>] ? rest_init+0x140/0x140
  [<ffffffff81c4776e>] kernel_init+0xe/0xf0
  [<ffffffff81c6be9c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81c47760>] ? rest_init+0x140/0x140
  ...

v2: Typo fix in x86-32.

v3: CPU number dropped from show_regs_print_info() as
    dump_stack_print_info() has been updated to print it.  s390
    specific implementation dropped as requested by s390 maintainers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>		[tile bits]
Acked-by: Richard Kuo <rkuo@codeaurora.org>		[hexagon bits]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/process.c         |    1 +
 arch/arc/kernel/troubleshoot.c      |    1 +
 arch/arm/kernel/process.c           |    8 ++------
 arch/arm64/kernel/process.c         |    7 +------
 arch/avr32/kernel/process.c         |    5 ++---
 arch/blackfin/kernel/trace.c        |    2 ++
 arch/c6x/kernel/traps.c             |    1 +
 arch/cris/arch-v10/kernel/process.c |    3 +++
 arch/cris/arch-v32/kernel/process.c |    3 +++
 arch/frv/kernel/traps.c             |    3 +--
 arch/h8300/kernel/process.c         |    2 ++
 arch/hexagon/kernel/vm_events.c     |    2 ++
 arch/ia64/kernel/process.c          |    4 ++--
 arch/m32r/kernel/process.c          |    2 ++
 arch/metag/kernel/process.c         |    2 ++
 arch/microblaze/kernel/process.c    |    2 ++
 arch/mips/kernel/traps.c            |    2 +-
 arch/mn10300/kernel/process.c       |    1 +
 arch/openrisc/kernel/process.c      |    1 +
 arch/parisc/kernel/traps.c          |    2 ++
 arch/powerpc/kernel/process.c       |    8 ++------
 arch/s390/kernel/dumpstack.c        |    9 +--------
 arch/score/kernel/traps.c           |    2 ++
 arch/sh/kernel/process_32.c         |    6 +-----
 arch/sh/kernel/process_64.c         |    1 +
 arch/sparc/kernel/process_32.c      |    2 ++
 arch/sparc/kernel/process_64.c      |    2 ++
 arch/tile/kernel/process.c          |    3 +--
 arch/um/sys-ppc/sysrq.c             |    2 ++
 arch/unicore32/kernel/process.c     |    6 +-----
 arch/x86/include/asm/bug.h          |    3 ---
 arch/x86/kernel/dumpstack_32.c      |    4 +---
 arch/x86/kernel/dumpstack_64.c      |    6 +-----
 arch/x86/kernel/process.c           |   24 ------------------------
 arch/x86/kernel/process_32.c        |    2 --
 arch/x86/kernel/process_64.c        |    1 -
 arch/xtensa/kernel/traps.c          |    2 ++
 include/linux/printk.h              |    5 +++++
 kernel/printk.c                     |   16 ++++++++++++++++
 39 files changed, 74 insertions(+), 84 deletions(-)

diff -puN arch/alpha/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/alpha/kernel/process.c
--- a/arch/alpha/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/alpha/kernel/process.c
@@ -175,6 +175,7 @@ machine_power_off(void)
 void
 show_regs(struct pt_regs *regs)
 {
+	show_regs_print_info(KERN_DEFAULT);
 	dik_show_regs(regs, NULL);
 }
 
diff -puN arch/arc/kernel/troubleshoot.c~dump_stack-unify-debug-information-printed-by-show_regs arch/arc/kernel/troubleshoot.c
--- a/arch/arc/kernel/troubleshoot.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/arc/kernel/troubleshoot.c
@@ -163,6 +163,7 @@ void show_regs(struct pt_regs *regs)
 		return;
 
 	print_task_path_n_nm(tsk, buf);
+	show_regs_print_info(KERN_INFO);
 
 	if (current->thread.cause_code)
 		show_ecr_verbose(regs);
diff -puN arch/arm/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/arm/kernel/process.c
@@ -225,11 +225,8 @@ void __show_regs(struct pt_regs *regs)
 	unsigned long flags;
 	char buf[64];
 
-	printk("CPU: %d    %s  (%s %.*s)\n",
-		raw_smp_processor_id(), print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+	show_regs_print_info(KERN_DEFAULT);
+
 	print_symbol("PC is at %s\n", instruction_pointer(regs));
 	print_symbol("LR is at %s\n", regs->ARM_lr);
 	printk("pc : [<%08lx>]    lr : [<%08lx>]    psr: %08lx\n"
@@ -284,7 +281,6 @@ void __show_regs(struct pt_regs *regs)
 void show_regs(struct pt_regs * regs)
 {
 	printk("\n");
-	printk("Pid: %d, comm: %20s\n", task_pid_nr(current), current->comm);
 	__show_regs(regs);
 	dump_stack();
 }
diff -puN arch/arm64/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/arm64/kernel/process.c
--- a/arch/arm64/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/arm64/kernel/process.c
@@ -145,11 +145,7 @@ void __show_regs(struct pt_regs *regs)
 {
 	int i;
 
-	printk("CPU: %d    %s  (%s %.*s)\n",
-		raw_smp_processor_id(), print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+	show_regs_print_info(KERN_DEFAULT);
 	print_symbol("PC is at %s\n", instruction_pointer(regs));
 	print_symbol("LR is at %s\n", regs->regs[30]);
 	printk("pc : [<%016llx>] lr : [<%016llx>] pstate: %08llx\n",
@@ -166,7 +162,6 @@ void __show_regs(struct pt_regs *regs)
 void show_regs(struct pt_regs * regs)
 {
 	printk("\n");
-	printk("Pid: %d, comm: %20s\n", task_pid_nr(current), current->comm);
 	__show_regs(regs);
 }
 
diff -puN arch/avr32/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/avr32/kernel/process.c
--- a/arch/avr32/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/avr32/kernel/process.c
@@ -215,6 +215,8 @@ void show_regs_log_lvl(struct pt_regs *r
 	unsigned long lr = regs->lr;
 	unsigned long mode = (regs->sr & MODE_MASK) >> MODE_SHIFT;
 
+	show_regs_print_info(log_lvl);
+
 	if (!user_mode(regs)) {
 		sp = (unsigned long)regs + FRAME_SIZE_FULL;
 
@@ -252,9 +254,6 @@ void show_regs_log_lvl(struct pt_regs *r
 	       regs->sr & SR_I0M ? '0' : '.',
 	       regs->sr & SR_GM ? 'G' : 'g');
 	printk("%sCPU Mode: %s\n", log_lvl, cpu_modes[mode]);
-	printk("%sProcess: %s [%d] (task: %p thread: %p)\n",
-	       log_lvl, current->comm, current->pid, current,
-	       task_thread_info(current));
 }
 
 void show_regs(struct pt_regs *regs)
diff -puN arch/blackfin/kernel/trace.c~dump_stack-unify-debug-information-printed-by-show_regs arch/blackfin/kernel/trace.c
--- a/arch/blackfin/kernel/trace.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/blackfin/kernel/trace.c
@@ -853,6 +853,8 @@ void show_regs(struct pt_regs *fp)
 	unsigned char in_atomic = (bfin_read_IPEND() & 0x10) || in_atomic();
 
 	pr_notice("\n");
+	show_regs_print_info(KERN_NOTICE);
+
 	if (CPUID != bfin_cpuid())
 		pr_notice("Compiled for cpu family 0x%04x (Rev %d), "
 			"but running on:0x%04x (Rev %d)\n",
diff -puN arch/c6x/kernel/traps.c~dump_stack-unify-debug-information-printed-by-show_regs arch/c6x/kernel/traps.c
--- a/arch/c6x/kernel/traps.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/c6x/kernel/traps.c
@@ -31,6 +31,7 @@ void __init trap_init(void)
 void show_regs(struct pt_regs *regs)
 {
 	pr_err("\n");
+	show_regs_print_info(KERN_ERR);
 	pr_err("PC: %08lx SP: %08lx\n", regs->pc, regs->sp);
 	pr_err("Status: %08lx ORIG_A4: %08lx\n", regs->csr, regs->orig_a4);
 	pr_err("A0: %08lx  B0: %08lx\n", regs->a0, regs->b0);
diff -puN arch/cris/arch-v10/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/cris/arch-v10/kernel/process.c
--- a/arch/cris/arch-v10/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/cris/arch-v10/kernel/process.c
@@ -176,6 +176,9 @@ unsigned long get_wchan(struct task_stru
 void show_regs(struct pt_regs * regs)
 {
 	unsigned long usp = rdusp();
+
+	show_regs_print_info(KERN_DEFAULT);
+
 	printk("IRP: %08lx SRP: %08lx DCCR: %08lx USP: %08lx MOF: %08lx\n",
 	       regs->irp, regs->srp, regs->dccr, usp, regs->mof );
 	printk(" r0: %08lx  r1: %08lx   r2: %08lx  r3: %08lx\n",
diff -puN arch/cris/arch-v32/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/cris/arch-v32/kernel/process.c
--- a/arch/cris/arch-v32/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/cris/arch-v32/kernel/process.c
@@ -164,6 +164,9 @@ get_wchan(struct task_struct *p)
 void show_regs(struct pt_regs * regs)
 {
 	unsigned long usp = rdusp();
+
+	show_regs_print_info(KERN_DEFAULT);
+
         printk("ERP: %08lx SRP: %08lx  CCS: %08lx USP: %08lx MOF: %08lx\n",
 		regs->erp, regs->srp, regs->ccs, usp, regs->mof);
 
diff -puN arch/frv/kernel/traps.c~dump_stack-unify-debug-information-printed-by-show_regs arch/frv/kernel/traps.c
--- a/arch/frv/kernel/traps.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/frv/kernel/traps.c
@@ -497,6 +497,7 @@ void show_regs(struct pt_regs *regs)
 	int loop;
 
 	printk("\n");
+	show_regs_print_info(KERN_DEFAULT);
 
 	printk("Frame: @%08lx [%s]\n",
 	       (unsigned long) regs,
@@ -511,8 +512,6 @@ void show_regs(struct pt_regs *regs)
 		else
 			printk(" | ");
 	}
-
-	printk("Process %s (pid: %d)\n", current->comm, current->pid);
 }
 
 void die_if_kernel(const char *str, ...)
diff -puN arch/h8300/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/h8300/kernel/process.c
--- a/arch/h8300/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/h8300/kernel/process.c
@@ -83,6 +83,8 @@ void machine_power_off(void)
 
 void show_regs(struct pt_regs * regs)
 {
+	show_regs_print_info(KERN_DEFAULT);
+
 	printk("\nPC: %08lx  Status: %02x",
 	       regs->pc, regs->ccr);
 	printk("\nORIG_ER0: %08lx ER0: %08lx ER1: %08lx",
diff -puN arch/hexagon/kernel/vm_events.c~dump_stack-unify-debug-information-printed-by-show_regs arch/hexagon/kernel/vm_events.c
--- a/arch/hexagon/kernel/vm_events.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/hexagon/kernel/vm_events.c
@@ -33,6 +33,8 @@
  */
 void show_regs(struct pt_regs *regs)
 {
+	show_regs_print_info(KERN_EMERG);
+
 	printk(KERN_EMERG "restart_r0: \t0x%08lx   syscall_nr: %ld\n",
 	       regs->restart_r0, regs->syscall_nr);
 	printk(KERN_EMERG "preds: \t\t0x%08lx\n", regs->preds);
diff -puN arch/ia64/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/ia64/kernel/process.c
--- a/arch/ia64/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/ia64/kernel/process.c
@@ -101,8 +101,8 @@ show_regs (struct pt_regs *regs)
 	unsigned long ip = regs->cr_iip + ia64_psr(regs)->ri;
 
 	print_modules();
-	printk("\nPid: %d, CPU %d, comm: %20s\n", task_pid_nr(current),
-			smp_processor_id(), current->comm);
+	printk("\n");
+	show_regs_print_info(KERN_DEFAULT);
 	printk("psr : %016lx ifs : %016lx ip  : [<%016lx>]    %s (%s)\n",
 	       regs->cr_ipsr, regs->cr_ifs, ip, print_tainted(),
 	       init_utsname()->release);
diff -puN arch/m32r/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/m32r/kernel/process.c
--- a/arch/m32r/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/m32r/kernel/process.c
@@ -73,6 +73,8 @@ void machine_power_off(void)
 void show_regs(struct pt_regs * regs)
 {
 	printk("\n");
+	show_regs_print_info(KERN_DEFAULT);
+
 	printk("BPC[%08lx]:PSW[%08lx]:LR [%08lx]:FP [%08lx]\n", \
 	  regs->bpc, regs->psw, regs->lr, regs->fp);
 	printk("BBPC[%08lx]:BBPSW[%08lx]:SPU[%08lx]:SPI[%08lx]\n", \
diff -puN arch/metag/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/metag/kernel/process.c
--- a/arch/metag/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/metag/kernel/process.c
@@ -129,6 +129,8 @@ void show_regs(struct pt_regs *regs)
 		"D1.7 "
 	};
 
+	show_regs_print_info(KERN_INFO);
+
 	pr_info(" pt_regs @ %p\n", regs);
 	pr_info(" SaveMask = 0x%04hx\n", regs->ctx.SaveMask);
 	pr_info(" Flags = 0x%04hx (%c%c%c%c)\n", regs->ctx.Flags,
diff -puN arch/microblaze/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/microblaze/kernel/process.c
--- a/arch/microblaze/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/microblaze/kernel/process.c
@@ -20,6 +20,8 @@
 
 void show_regs(struct pt_regs *regs)
 {
+	show_regs_print_info(KERN_INFO);
+
 	pr_info(" Registers dump: mode=%X\r\n", regs->pt_mode);
 	pr_info(" r1=%08lX, r2=%08lX, r3=%08lX, r4=%08lX\n",
 				regs->r1, regs->r2, regs->r3, regs->r4);
diff -puN arch/mips/kernel/traps.c~dump_stack-unify-debug-information-printed-by-show_regs arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/mips/kernel/traps.c
@@ -231,7 +231,7 @@ static void __show_regs(const struct pt_
 	unsigned int cause = regs->cp0_cause;
 	int i;
 
-	printk("Cpu %d\n", smp_processor_id());
+	show_regs_print_info(KERN_DEFAULT);
 
 	/*
 	 * Saved main processor registers
diff -puN arch/mn10300/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/mn10300/kernel/process.c
--- a/arch/mn10300/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/mn10300/kernel/process.c
@@ -97,6 +97,7 @@ void machine_power_off(void)
 
 void show_regs(struct pt_regs *regs)
 {
+	show_regs_print_info(KERN_DEFAULT);
 }
 
 /*
diff -puN arch/openrisc/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/openrisc/kernel/process.c
--- a/arch/openrisc/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/openrisc/kernel/process.c
@@ -90,6 +90,7 @@ void show_regs(struct pt_regs *regs)
 {
 	extern void show_registers(struct pt_regs *regs);
 
+	show_regs_print_info(KERN_DEFAULT);
 	/* __PHX__ cleanup this mess */
 	show_registers(regs);
 }
diff -puN arch/parisc/kernel/traps.c~dump_stack-unify-debug-information-printed-by-show_regs arch/parisc/kernel/traps.c
--- a/arch/parisc/kernel/traps.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/parisc/kernel/traps.c
@@ -126,6 +126,8 @@ void show_regs(struct pt_regs *regs)
 	user = user_mode(regs);
 	level = user ? KERN_DEBUG : KERN_CRIT;
 
+	show_regs_print_info(level);
+
 	print_gr(level, regs);
 
 	for (i = 0; i < 8; i += 4)
diff -puN arch/powerpc/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/powerpc/kernel/process.c
--- a/arch/powerpc/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/powerpc/kernel/process.c
@@ -831,6 +831,8 @@ void show_regs(struct pt_regs * regs)
 {
 	int i, trap;
 
+	show_regs_print_info(KERN_DEFAULT);
+
 	printk("NIP: "REG" LR: "REG" CTR: "REG"\n",
 	       regs->nip, regs->link, regs->ctr);
 	printk("REGS: %p TRAP: %04lx   %s  (%s)\n",
@@ -850,12 +852,6 @@ void show_regs(struct pt_regs * regs)
 #else
 		printk("DAR: "REG", DSISR: %08lx\n", regs->dar, regs->dsisr);
 #endif
-	printk("TASK = %p[%d] '%s' THREAD: %p",
-	       current, task_pid_nr(current), current->comm, task_thread_info(current));
-
-#ifdef CONFIG_SMP
-	printk(" CPU: %d", raw_smp_processor_id());
-#endif /* CONFIG_SMP */
 
 	for (i = 0;  i < 32;  i++) {
 		if ((i % REGS_PER_LINE) == 0)
diff -puN arch/s390/kernel/dumpstack.c~dump_stack-unify-debug-information-printed-by-show_regs arch/s390/kernel/dumpstack.c
--- a/arch/s390/kernel/dumpstack.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/s390/kernel/dumpstack.c
@@ -166,14 +166,7 @@ void show_registers(struct pt_regs *regs
 
 void show_regs(struct pt_regs *regs)
 {
-	printk("CPU: %d %s %s %.*s\n",
-	       task_thread_info(current)->cpu, print_tainted(),
-	       init_utsname()->release,
-	       (int)strcspn(init_utsname()->version, " "),
-	       init_utsname()->version);
-	printk("Process %s (pid: %d, task: %p, ksp: %p)\n",
-	       current->comm, current->pid, current,
-	       (void *) current->thread.ksp);
+	show_regs_print_info(KERN_DEFAULT);
 	show_registers(regs);
 	/* Show stack backtrace if pt_regs is from kernel mode */
 	if (!user_mode(regs))
diff -puN arch/score/kernel/traps.c~dump_stack-unify-debug-information-printed-by-show_regs arch/score/kernel/traps.c
--- a/arch/score/kernel/traps.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/score/kernel/traps.c
@@ -117,6 +117,8 @@ static void show_code(unsigned int *pc)
  */
 void show_regs(struct pt_regs *regs)
 {
+	show_regs_print_info(KERN_DEFAULT);
+
 	printk("r0 : %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
 		regs->regs[0], regs->regs[1], regs->regs[2], regs->regs[3],
 		regs->regs[4], regs->regs[5], regs->regs[6], regs->regs[7]);
diff -puN arch/sh/kernel/process_32.c~dump_stack-unify-debug-information-printed-by-show_regs arch/sh/kernel/process_32.c
--- a/arch/sh/kernel/process_32.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/sh/kernel/process_32.c
@@ -32,11 +32,7 @@
 void show_regs(struct pt_regs * regs)
 {
 	printk("\n");
-	printk("Pid : %d, Comm: \t\t%s\n", task_pid_nr(current), current->comm);
-	printk("CPU : %d        \t\t%s  (%s %.*s)\n\n",
-	       smp_processor_id(), print_tainted(), init_utsname()->release,
-	       (int)strcspn(init_utsname()->version, " "),
-	       init_utsname()->version);
+	show_regs_print_info(KERN_DEFAULT);
 
 	print_symbol("PC is at %s\n", instruction_pointer(regs));
 	print_symbol("PR is at %s\n", regs->pr);
diff -puN arch/sh/kernel/process_64.c~dump_stack-unify-debug-information-printed-by-show_regs arch/sh/kernel/process_64.c
--- a/arch/sh/kernel/process_64.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/sh/kernel/process_64.c
@@ -40,6 +40,7 @@ void show_regs(struct pt_regs *regs)
 	unsigned long long ah, al, bh, bl, ch, cl;
 
 	printk("\n");
+	show_regs_print_info(KERN_DEFAULT);
 
 	ah = (regs->pc) >> 32;
 	al = (regs->pc) & 0xffffffff;
diff -puN arch/sparc/kernel/process_32.c~dump_stack-unify-debug-information-printed-by-show_regs arch/sparc/kernel/process_32.c
--- a/arch/sparc/kernel/process_32.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/sparc/kernel/process_32.c
@@ -112,6 +112,8 @@ void show_regs(struct pt_regs *r)
 {
 	struct reg_window32 *rw = (struct reg_window32 *) r->u_regs[14];
 
+	show_regs_print_info(KERN_DEFAULT);
+
         printk("PSR: %08lx PC: %08lx NPC: %08lx Y: %08lx    %s\n",
 	       r->psr, r->pc, r->npc, r->y, print_tainted());
 	printk("PC: <%pS>\n", (void *) r->pc);
diff -puN arch/sparc/kernel/process_64.c~dump_stack-unify-debug-information-printed-by-show_regs arch/sparc/kernel/process_64.c
--- a/arch/sparc/kernel/process_64.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/sparc/kernel/process_64.c
@@ -163,6 +163,8 @@ static void show_regwindow(struct pt_reg
 
 void show_regs(struct pt_regs *regs)
 {
+	show_regs_print_info(KERN_DEFAULT);
+
 	printk("TSTATE: %016lx TPC: %016lx TNPC: %016lx Y: %08x    %s\n", regs->tstate,
 	       regs->tpc, regs->tnpc, regs->y, print_tainted());
 	printk("TPC: <%pS>\n", (void *) regs->tpc);
diff -puN arch/tile/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/tile/kernel/process.c
--- a/arch/tile/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/tile/kernel/process.c
@@ -573,8 +573,7 @@ void show_regs(struct pt_regs *regs)
 	int i;
 
 	pr_err("\n");
-	pr_err(" Pid: %d, comm: %20s, CPU: %d\n",
-	       tsk->pid, tsk->comm, smp_processor_id());
+	show_regs_print_info(KERN_ERR);
 #ifdef __tilegx__
 	for (i = 0; i < 51; i += 3)
 		pr_err(" r%-2d: "REGFMT" r%-2d: "REGFMT" r%-2d: "REGFMT"\n",
diff -puN arch/um/sys-ppc/sysrq.c~dump_stack-unify-debug-information-printed-by-show_regs arch/um/sys-ppc/sysrq.c
--- a/arch/um/sys-ppc/sysrq.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/um/sys-ppc/sysrq.c
@@ -11,6 +11,8 @@
 void show_regs(struct pt_regs_subarch *regs)
 {
 	printk("\n");
+	show_regs_print_info(KERN_DEFAULT);
+
 	printk("show_regs(): insert regs here.\n");
 #if 0
         printk("\n");
diff -puN arch/unicore32/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/unicore32/kernel/process.c
--- a/arch/unicore32/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/unicore32/kernel/process.c
@@ -144,11 +144,7 @@ void __show_regs(struct pt_regs *regs)
 	unsigned long flags;
 	char buf[64];
 
-	printk(KERN_DEFAULT "CPU: %d    %s  (%s %.*s)\n",
-		raw_smp_processor_id(), print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+	show_regs_print_info(KERN_DEFAULT);
 	print_symbol("PC is at %s\n", instruction_pointer(regs));
 	print_symbol("LR is at %s\n", regs->UCreg_lr);
 	printk(KERN_DEFAULT "pc : [<%08lx>]    lr : [<%08lx>]    psr: %08lx\n"
diff -puN arch/x86/include/asm/bug.h~dump_stack-unify-debug-information-printed-by-show_regs arch/x86/include/asm/bug.h
--- a/arch/x86/include/asm/bug.h~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/x86/include/asm/bug.h
@@ -37,7 +37,4 @@ do {								\
 
 #include <asm-generic/bug.h>
 
-
-extern void show_regs_common(void);
-
 #endif /* _ASM_X86_BUG_H */
diff -puN arch/x86/kernel/dumpstack_32.c~dump_stack-unify-debug-information-printed-by-show_regs arch/x86/kernel/dumpstack_32.c
--- a/arch/x86/kernel/dumpstack_32.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/x86/kernel/dumpstack_32.c
@@ -86,11 +86,9 @@ void show_regs(struct pt_regs *regs)
 {
 	int i;
 
+	show_regs_print_info(KERN_EMERG);
 	__show_regs(regs, !user_mode_vm(regs));
 
-	pr_emerg("Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)\n",
-		 TASK_COMM_LEN, current->comm, task_pid_nr(current),
-		 current_thread_info(), current, task_thread_info(current));
 	/*
 	 * When in-kernel, we also print out the stack and code at the
 	 * time of the fault..
diff -puN arch/x86/kernel/dumpstack_64.c~dump_stack-unify-debug-information-printed-by-show_regs arch/x86/kernel/dumpstack_64.c
--- a/arch/x86/kernel/dumpstack_64.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/x86/kernel/dumpstack_64.c
@@ -249,14 +249,10 @@ void show_regs(struct pt_regs *regs)
 {
 	int i;
 	unsigned long sp;
-	const int cpu = smp_processor_id();
-	struct task_struct *cur = current;
 
 	sp = regs->sp;
-	printk("CPU %d ", cpu);
+	show_regs_print_info(KERN_DEFAULT);
 	__show_regs(regs, 1);
-	printk(KERN_DEFAULT "Process %s (pid: %d, threadinfo %p, task %p)\n",
-	       cur->comm, cur->pid, task_thread_info(cur), cur);
 
 	/*
 	 * When in-kernel, we also print out the stack and code at the
diff -puN arch/x86/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs arch/x86/kernel/process.c
--- a/arch/x86/kernel/process.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/x86/kernel/process.c
@@ -121,30 +121,6 @@ void exit_thread(void)
 	drop_fpu(me);
 }
 
-void show_regs_common(void)
-{
-	const char *vendor, *product, *board;
-
-	vendor = dmi_get_system_info(DMI_SYS_VENDOR);
-	if (!vendor)
-		vendor = "";
-	product = dmi_get_system_info(DMI_PRODUCT_NAME);
-	if (!product)
-		product = "";
-
-	/* Board Name is optional */
-	board = dmi_get_system_info(DMI_BOARD_NAME);
-
-	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s %s %s%s%s\n",
-	       current->pid, current->comm, print_tainted(),
-	       init_utsname()->release,
-	       (int)strcspn(init_utsname()->version, " "),
-	       init_utsname()->version,
-	       vendor, product,
-	       board ? "/" : "",
-	       board ? board : "");
-}
-
 void flush_thread(void)
 {
 	struct task_struct *tsk = current;
diff -puN arch/x86/kernel/process_32.c~dump_stack-unify-debug-information-printed-by-show_regs arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/x86/kernel/process_32.c
@@ -84,8 +84,6 @@ void __show_regs(struct pt_regs *regs, i
 		savesegment(gs, gs);
 	}
 
-	show_regs_common();
-
 	printk(KERN_DEFAULT "EIP: %04x:[<%08lx>] EFLAGS: %08lx CPU: %d\n",
 			(u16)regs->cs, regs->ip, regs->flags,
 			smp_processor_id());
diff -puN arch/x86/kernel/process_64.c~dump_stack-unify-debug-information-printed-by-show_regs arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/x86/kernel/process_64.c
@@ -62,7 +62,6 @@ void __show_regs(struct pt_regs *regs, i
 	unsigned int fsindex, gsindex;
 	unsigned int ds, cs, es;
 
-	show_regs_common();
 	printk(KERN_DEFAULT "RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->ip);
 	printk_address(regs->ip, 1);
 	printk(KERN_DEFAULT "RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss,
diff -puN arch/xtensa/kernel/traps.c~dump_stack-unify-debug-information-printed-by-show_regs arch/xtensa/kernel/traps.c
--- a/arch/xtensa/kernel/traps.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/arch/xtensa/kernel/traps.c
@@ -383,6 +383,8 @@ void show_regs(struct pt_regs * regs)
 {
 	int i, wmask;
 
+	show_regs_print_info(KERN_DEFAULT);
+
 	wmask = regs->wmask & ~1;
 
 	for (i = 0; i < 16; i++) {
diff -puN include/linux/printk.h~dump_stack-unify-debug-information-printed-by-show_regs include/linux/printk.h
--- a/include/linux/printk.h~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/include/linux/printk.h
@@ -147,6 +147,7 @@ void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
 void dump_stack_set_arch_desc(const char *fmt, ...);
 void dump_stack_print_info(const char *log_lvl);
+void show_regs_print_info(const char *log_lvl);
 #else
 static inline __printf(1, 0)
 int vprintk(const char *s, va_list args)
@@ -192,6 +193,10 @@ static inline void dump_stack_set_arch_d
 static inline void dump_stack_print_info(const char *log_lvl)
 {
 }
+
+static inline void show_regs_print_info(const char *log_lvl)
+{
+}
 #endif
 
 extern void dump_stack(void) __cold;
diff -puN kernel/printk.c~dump_stack-unify-debug-information-printed-by-show_regs kernel/printk.c
--- a/kernel/printk.c~dump_stack-unify-debug-information-printed-by-show_regs
+++ a/kernel/printk.c
@@ -2893,4 +2893,20 @@ void dump_stack_print_info(const char *l
 		       log_lvl, dump_stack_arch_desc_str);
 }
 
+/**
+ * show_regs_print_info - print generic debug info for show_regs()
+ * @log_lvl: log level
+ *
+ * show_regs() implementations can use this function to print out generic
+ * debug information.
+ */
+void show_regs_print_info(const char *log_lvl)
+{
+	dump_stack_print_info(log_lvl);
+
+	printk("%stask: %p ti: %p task.ti: %p\n",
+	       log_lvl, current, current_thread_info(),
+	       task_thread_info(current));
+}
+
 #endif
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch


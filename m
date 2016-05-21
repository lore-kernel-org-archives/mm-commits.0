From: akpm@linux-foundation.org
Subject: [patch 078/162] exit_thread: accept a task parameter to be exited
Date: Fri, 20 May 2016 17:00:20 -0700
Message-ID: <573fa514.HbCN4aFiWoN/bJj5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbcEUAAZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:00:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jslaby@suse.cz, a-jacquiot@ti.com, benh@kernel.crashing.org, catalin.marinas@arm.com, chris@zankel.net, cmetcalf@mellanox.com, dalias@libc.org, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, egtvedt@samfundet.no, fenghua.yu@intel.com, geert@linux-m68k.org, gxt@mprc.pku.edu.cn, heiko.carstens@de.ibm.com, hpa@zytor.com, hskinnemoen@gmail.com, ink@jurassic.park.msu.ru, james.hogan@imgtec.com, jcmvbkbc@gmail.com, jdike@addtoit.com, jejb@parisc-linux.org, jesper.nilsson@axis.com, jonas@southpole.se, lennox.wu@gmail.com, lftan@altera.com, linux@arm.linux.org.uk, liqin.linux@gmail.com, mattst88@gmail.com, mingo@redhat.com, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, realmz6@gmail.com, richard@nod.at, rkuo@cod

From: Jiri Slaby <jslaby@suse.cz>
Subject: exit_thread: accept a task parameter to be exited

We need to call exit_thread from copy_process in a fail path.  So make it
accept task_struct as a parameter.

[v2]
* s390: exit_thread_runtime_instr doesn't make sense to be called for
  non-current tasks.
* arm: fix the comment in vfp_thread_copy
* change 'me' to 'tsk' for task_struct
* now we can change only archs that actually have exit_thread

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Howells <dhowells@redhat.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Ley Foon Tan <lftan@altera.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/process.c           |    4 ++--
 arch/arm/vfp/vfpmodule.c            |    4 ----
 arch/avr32/kernel/process.c         |    4 ++--
 arch/cris/arch-v32/kernel/process.c |    4 ++--
 arch/ia64/kernel/perfmon.c          |    4 ++--
 arch/ia64/kernel/process.c          |   14 +++++++-------
 arch/metag/kernel/process.c         |    6 +++---
 arch/mn10300/kernel/process.c       |    4 ++--
 arch/s390/kernel/process.c          |    5 +++--
 arch/sh/kernel/process_64.c         |    5 ++---
 arch/sparc/kernel/process_32.c      |   12 ++++++------
 arch/sparc/kernel/process_64.c      |    4 ++--
 arch/tile/kernel/process.c          |    4 ++--
 arch/x86/kernel/process.c           |    5 ++---
 arch/xtensa/kernel/process.c        |    4 ++--
 include/linux/sched.h               |    4 ++--
 kernel/exit.c                       |    2 +-
 17 files changed, 42 insertions(+), 47 deletions(-)

diff -puN arch/arm/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/arch/arm/kernel/process.c
@@ -193,9 +193,9 @@ EXPORT_SYMBOL_GPL(thread_notify_head);
 /*
  * Free current thread data structures etc..
  */
-void exit_thread(void)
+void exit_thread(struct task_struct *tsk)
 {
-	thread_notify(THREAD_NOTIFY_EXIT, current_thread_info());
+	thread_notify(THREAD_NOTIFY_EXIT, task_thread_info(tsk));
 }
 
 void flush_thread(void)
diff -puN arch/arm/vfp/vfpmodule.c~exit_thread-accept-a-task-parameter-to-be-exited arch/arm/vfp/vfpmodule.c
--- a/arch/arm/vfp/vfpmodule.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/arch/arm/vfp/vfpmodule.c
@@ -156,10 +156,6 @@ static void vfp_thread_copy(struct threa
  *   - we could be preempted if tree preempt rcu is enabled, so
  *	it is unsafe to use thread->cpu.
  *  THREAD_NOTIFY_EXIT
- *   - the thread (v) will be running on the local CPU, so
- *	v === current_thread_info()
- *   - thread->cpu is the local CPU number at the time it is accessed,
- *	but may change at any time.
  *   - we could be preempted if tree preempt rcu is enabled, so
  *	it is unsafe to use thread->cpu.
  */
diff -puN arch/avr32/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited arch/avr32/kernel/process.c
--- a/arch/avr32/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/arch/avr32/kernel/process.c
@@ -62,9 +62,9 @@ void machine_restart(char *cmd)
 /*
  * Free current thread data structures etc
  */
-void exit_thread(void)
+void exit_thread(struct task_struct *tsk)
 {
-	ocd_disable(current);
+	ocd_disable(tsk);
 }
 
 void flush_thread(void)
diff -puN arch/cris/arch-v32/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited arch/cris/arch-v32/kernel/process.c
--- a/arch/cris/arch-v32/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/arch/cris/arch-v32/kernel/process.c
@@ -33,9 +33,9 @@ void default_idle(void)
  */
 
 extern void deconfigure_bp(long pid);
-void exit_thread(void)
+void exit_thread(struct task_struct *tsk)
 {
-	deconfigure_bp(current->pid);
+	deconfigure_bp(tsk->pid);
 }
 
 /*
diff -puN arch/ia64/kernel/perfmon.c~exit_thread-accept-a-task-parameter-to-be-exited arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/arch/ia64/kernel/perfmon.c
@@ -4542,8 +4542,8 @@ pfm_context_unload(pfm_context_t *ctx, v
 
 
 /*
- * called only from exit_thread(): task == current
- * we come here only if current has a context attached (loaded or masked)
+ * called only from exit_thread()
+ * we come here only if the task has a context attached (loaded or masked)
  */
 void
 pfm_exit_thread(struct task_struct *task)
diff -puN arch/ia64/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited arch/ia64/kernel/process.c
--- a/arch/ia64/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/arch/ia64/kernel/process.c
@@ -570,22 +570,22 @@ flush_thread (void)
 }
 
 /*
- * Clean up state associated with current thread.  This is called when
+ * Clean up state associated with a thread.  This is called when
  * the thread calls exit().
  */
 void
-exit_thread (void)
+exit_thread (struct task_struct *tsk)
 {
 
-	ia64_drop_fpu(current);
+	ia64_drop_fpu(tsk);
 #ifdef CONFIG_PERFMON
        /* if needed, stop monitoring and flush state to perfmon context */
-	if (current->thread.pfm_context)
-		pfm_exit_thread(current);
+	if (tsk->thread.pfm_context)
+		pfm_exit_thread(tsk);
 
 	/* free debug register resources */
-	if (current->thread.flags & IA64_THREAD_DBG_VALID)
-		pfm_release_debug_registers(current);
+	if (tsk->thread.flags & IA64_THREAD_DBG_VALID)
+		pfm_release_debug_registers(tsk);
 #endif
 }
 
diff -puN arch/metag/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited arch/metag/kernel/process.c
--- a/arch/metag/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/arch/metag/kernel/process.c
@@ -345,10 +345,10 @@ void flush_thread(void)
 /*
  * Free current thread data structures etc.
  */
-void exit_thread(void)
+void exit_thread(struct task_struct *tsk)
 {
-	clear_fpu(&current->thread);
-	clear_dsp(&current->thread);
+	clear_fpu(&tsk->thread);
+	clear_dsp(&tsk->thread);
 }
 
 /* TODO: figure out how to unwind the kernel stack here to figure out
diff -puN arch/mn10300/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited arch/mn10300/kernel/process.c
--- a/arch/mn10300/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/arch/mn10300/kernel/process.c
@@ -103,9 +103,9 @@ void show_regs(struct pt_regs *regs)
 /*
  * free current thread data structures etc..
  */
-void exit_thread(void)
+void exit_thread(struct task_struct *tsk)
 {
-	exit_fpu(current);
+	exit_fpu(tsk);
 }
 
 void flush_thread(void)
diff -puN arch/s390/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited arch/s390/kernel/process.c
--- a/arch/s390/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/arch/s390/kernel/process.c
@@ -68,9 +68,10 @@ extern void kernel_thread_starter(void);
 /*
  * Free current thread data structures etc..
  */
-void exit_thread(void)
+void exit_thread(struct task_struct *tsk)
 {
-	exit_thread_runtime_instr();
+	if (tsk == current)
+		exit_thread_runtime_instr();
 }
 
 void flush_thread(void)
diff -puN arch/sh/kernel/process_64.c~exit_thread-accept-a-task-parameter-to-be-exited arch/sh/kernel/process_64.c
--- a/arch/sh/kernel/process_64.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/arch/sh/kernel/process_64.c
@@ -288,7 +288,7 @@ void show_regs(struct pt_regs *regs)
 /*
  * Free current thread data structures etc..
  */
-void exit_thread(void)
+void exit_thread(struct task_struct *tsk)
 {
 	/*
 	 * See arch/sparc/kernel/process.c for the precedent for doing
@@ -307,9 +307,8 @@ void exit_thread(void)
 	 * which it would get safely nulled.
 	 */
 #ifdef CONFIG_SH_FPU
-	if (last_task_used_math == current) {
+	if (last_task_used_math == tsk)
 		last_task_used_math = NULL;
-	}
 #endif
 }
 
diff -puN arch/sparc/kernel/process_32.c~exit_thread-accept-a-task-parameter-to-be-exited arch/sparc/kernel/process_32.c
--- a/arch/sparc/kernel/process_32.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/arch/sparc/kernel/process_32.c
@@ -184,21 +184,21 @@ unsigned long thread_saved_pc(struct tas
 /*
  * Free current thread data structures etc..
  */
-void exit_thread(void)
+void exit_thread(struct task_struct *tsk)
 {
 #ifndef CONFIG_SMP
-	if(last_task_used_math == current) {
+	if (last_task_used_math == tsk) {
 #else
-	if (test_thread_flag(TIF_USEDFPU)) {
+	if (test_ti_thread_flag(task_thread_info(tsk), TIF_USEDFPU)) {
 #endif
 		/* Keep process from leaving FPU in a bogon state. */
 		put_psr(get_psr() | PSR_EF);
-		fpsave(&current->thread.float_regs[0], &current->thread.fsr,
-		       &current->thread.fpqueue[0], &current->thread.fpqdepth);
+		fpsave(&tsk->thread.float_regs[0], &tsk->thread.fsr,
+		       &tsk->thread.fpqueue[0], &tsk->thread.fpqdepth);
 #ifndef CONFIG_SMP
 		last_task_used_math = NULL;
 #else
-		clear_thread_flag(TIF_USEDFPU);
+		clear_ti_thread_flag(task_thread_info(tsk), TIF_USEDFPU);
 #endif
 	}
 }
diff -puN arch/sparc/kernel/process_64.c~exit_thread-accept-a-task-parameter-to-be-exited arch/sparc/kernel/process_64.c
--- a/arch/sparc/kernel/process_64.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/arch/sparc/kernel/process_64.c
@@ -417,9 +417,9 @@ unsigned long thread_saved_pc(struct tas
 }
 
 /* Free current thread data structures etc.. */
-void exit_thread(void)
+void exit_thread(struct task_struct *tsk)
 {
-	struct thread_info *t = current_thread_info();
+	struct thread_info *t = task_thread_info(tsk);
 
 	if (t->utraps) {
 		if (t->utraps[0] < 2)
diff -puN arch/tile/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited arch/tile/kernel/process.c
--- a/arch/tile/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/arch/tile/kernel/process.c
@@ -541,7 +541,7 @@ void flush_thread(void)
 /*
  * Free current thread data structures etc..
  */
-void exit_thread(void)
+void exit_thread(struct task_struct *tsk)
 {
 #ifdef CONFIG_HARDWALL
 	/*
@@ -550,7 +550,7 @@ void exit_thread(void)
 	 * the last reference to a hardwall fd, it would already have
 	 * been released and deactivated at this point.)
 	 */
-	hardwall_deactivate_all(current);
+	hardwall_deactivate_all(tsk);
 #endif
 }
 
diff -puN arch/x86/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited arch/x86/kernel/process.c
--- a/arch/x86/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/arch/x86/kernel/process.c
@@ -97,10 +97,9 @@ int arch_dup_task_struct(struct task_str
 /*
  * Free current thread data structures etc..
  */
-void exit_thread(void)
+void exit_thread(struct task_struct *tsk)
 {
-	struct task_struct *me = current;
-	struct thread_struct *t = &me->thread;
+	struct thread_struct *t = &tsk->thread;
 	unsigned long *bp = t->io_bitmap_ptr;
 	struct fpu *fpu = &t->fpu;
 
diff -puN arch/xtensa/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited arch/xtensa/kernel/process.c
--- a/arch/xtensa/kernel/process.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/arch/xtensa/kernel/process.c
@@ -115,10 +115,10 @@ void arch_cpu_idle(void)
 /*
  * This is called when the thread calls exit().
  */
-void exit_thread(void)
+void exit_thread(struct task_struct *tsk)
 {
 #if XTENSA_HAVE_COPROCESSORS
-	coprocessor_release_all(current_thread_info());
+	coprocessor_release_all(task_thread_info(tsk));
 #endif
 }
 
diff -puN include/linux/sched.h~exit_thread-accept-a-task-parameter-to-be-exited include/linux/sched.h
--- a/include/linux/sched.h~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/include/linux/sched.h
@@ -2771,9 +2771,9 @@ static inline int copy_thread_tls(
 extern void flush_thread(void);
 
 #ifdef CONFIG_HAVE_EXIT_THREAD
-extern void exit_thread(void);
+extern void exit_thread(struct task_struct *tsk);
 #else
-static inline void exit_thread(void)
+static inline void exit_thread(struct task_struct *tsk)
 {
 }
 #endif
diff -puN kernel/exit.c~exit_thread-accept-a-task-parameter-to-be-exited kernel/exit.c
--- a/kernel/exit.c~exit_thread-accept-a-task-parameter-to-be-exited
+++ a/kernel/exit.c
@@ -746,7 +746,7 @@ void do_exit(long code)
 		disassociate_ctty(1);
 	exit_task_namespaces(tsk);
 	exit_task_work(tsk);
-	exit_thread();
+	exit_thread(tsk);
 
 	/*
 	 * Flush inherited counters to the parent - before the parent
_

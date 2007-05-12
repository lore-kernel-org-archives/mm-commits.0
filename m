From: akpm@linux-foundation.org
Subject: - uml-tidy-irq-code.patch removed from -mm tree
Date: Fri, 11 May 2007 22:33:27 -0700
Message-ID: <200705120533.l4C5XRVR002105@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754538AbXELFda (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:33:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: tidy IRQ code
has been removed from the -mm tree.  Its filename was
     uml-tidy-irq-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: tidy IRQ code
From: Jeff Dike <jdike@addtoit.com>

Some tidying of the irq code before introducing irq stacks.  Mostly
style fixes, but the timer handler calls the timer code directly
rather than going through the generic sig_handler_common_skas.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/init_task.c      |   11 -----------
 arch/um/kernel/irq.c            |    4 ++--
 arch/um/os-Linux/signal.c       |   10 +++++++---
 arch/um/os-Linux/skas/process.c |    6 ++++--
 4 files changed, 13 insertions(+), 18 deletions(-)

diff -puN arch/um/kernel/init_task.c~uml-tidy-irq-code arch/um/kernel/init_task.c
--- a/arch/um/kernel/init_task.c~uml-tidy-irq-code
+++ a/arch/um/kernel/init_task.c
@@ -46,14 +46,3 @@ void unprotect_stack(unsigned long stack
 {
 	os_protect_memory((void *) stack, THREAD_SIZE, 1, 1, 0);
 }
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/irq.c~uml-tidy-irq-code arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~uml-tidy-irq-code
+++ a/arch/um/kernel/irq.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  * Derived (i.e. mostly copied) from arch/i386/kernel/irq.c:
@@ -53,7 +53,7 @@ int show_interrupts(struct seq_file *p, 
 	if (i < NR_IRQS) {
 		spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
-		if (!action) 
+		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
 #ifndef CONFIG_SMP
diff -puN arch/um/os-Linux/signal.c~uml-tidy-irq-code arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-tidy-irq-code
+++ a/arch/um/os-Linux/signal.c
@@ -61,15 +61,19 @@ void sig_handler(int sig, struct sigcont
 
 static void real_alarm_handler(int sig, struct sigcontext *sc)
 {
+	union uml_pt_regs regs;
+
 	if(sig == SIGALRM)
 		switch_timers(0);
 
-	CHOOSE_MODE_PROC(sig_handler_common_tt, sig_handler_common_skas,
-			 sig, sc);
+	if(sc != NULL)
+		copy_sc(&regs, sc);
+	regs.skas.is_user = 0;
+	unblock_signals();
+	timer_handler(sig, &regs);
 
 	if(sig == SIGALRM)
 		switch_timers(1);
-
 }
 
 void alarm_handler(int sig, struct sigcontext *sc)
diff -puN arch/um/os-Linux/skas/process.c~uml-tidy-irq-code arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-tidy-irq-code
+++ a/arch/um/os-Linux/skas/process.c
@@ -288,7 +288,8 @@ int start_userspace(unsigned long stub_s
 void userspace(union uml_pt_regs *regs)
 {
 	int err, status, op, pid = userspace_pid[0];
-	int local_using_sysemu; /*To prevent races if using_sysemu changes under us.*/
+	/* To prevent races if using_sysemu changes under us.*/
+	int local_using_sysemu;
 
 	while(1){
 		restore_registers(pid, regs);
@@ -296,7 +297,8 @@ void userspace(union uml_pt_regs *regs)
 		/* Now we set local_using_sysemu to be used for one loop */
 		local_using_sysemu = get_using_sysemu();
 
-		op = SELECT_PTRACE_OPERATION(local_using_sysemu, singlestepping(NULL));
+		op = SELECT_PTRACE_OPERATION(local_using_sysemu,
+					     singlestepping(NULL));
 
 		err = ptrace(op, pid, 0, 0);
 		if(err)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch

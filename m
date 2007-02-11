From: akpm@linux-foundation.org
Subject: - uml-make-signal-handlers-static.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:09 -0800
Message-ID: <200702112249.l1BMn9hQ015699@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59820 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932692AbXBKWtL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: make signal handlers static
has been removed from the -mm tree.  Its filename was
     uml-make-signal-handlers-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: make signal handlers static
From: Jeff Dike <jdike@addtoit.com>

A bunch of the signal handlers can be made static.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/kern_util.h |    4 ----
 arch/um/kernel/trap.c       |   28 ++++++++++++++--------------
 2 files changed, 14 insertions(+), 18 deletions(-)

diff -puN arch/um/include/kern_util.h~uml-make-signal-handlers-static arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-make-signal-handlers-static
+++ a/arch/um/include/kern_util.h
@@ -87,7 +87,6 @@ extern void timer_irq(union uml_pt_regs 
 extern void unprotect_stack(unsigned long stack);
 extern void do_uml_exitcalls(void);
 extern int attach_debugger(int idle_pid, int pid, int stop);
-extern void bad_segv(struct faultinfo fi, unsigned long ip);
 extern int config_gdb(char *str);
 extern int remove_gdb(void);
 extern char *uml_strdup(char *string);
@@ -103,8 +102,6 @@ extern int clear_user_proc(void *buf, in
 extern int copy_to_user_proc(void *to, void *from, int size);
 extern int copy_from_user_proc(void *to, void *from, int size);
 extern int strlen_user_proc(char *str);
-extern void bus_handler(int sig, union uml_pt_regs *regs);
-extern void winch(int sig, union uml_pt_regs *regs);
 extern long execute_syscall(void *r);
 extern int smp_sigio_handler(void);
 extern void *get_current(void);
@@ -119,7 +116,6 @@ extern void time_init_kern(void);
 
 /* Are we disallowed to sleep? Used to choose between GFP_KERNEL and GFP_ATOMIC. */
 extern int __cant_sleep(void);
-extern void segv_handler(int sig, union uml_pt_regs *regs);
 extern void sigio_handler(int sig, union uml_pt_regs *regs);
 
 #endif
diff -puN arch/um/kernel/trap.c~uml-make-signal-handlers-static arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~uml-make-signal-handlers-static
+++ a/arch/um/kernel/trap.c
@@ -128,7 +128,18 @@ out_of_memory:
 	goto out;
 }
 
-void segv_handler(int sig, union uml_pt_regs *regs)
+static void bad_segv(struct faultinfo fi, unsigned long ip)
+{
+	struct siginfo si;
+
+	si.si_signo = SIGSEGV;
+	si.si_code = SEGV_ACCERR;
+	si.si_addr = (void __user *) FAULT_ADDRESS(fi);
+	current->thread.arch.faultinfo = fi;
+	force_sig_info(SIGSEGV, &si, current);
+}
+
+static void segv_handler(int sig, union uml_pt_regs *regs)
 {
 	struct faultinfo * fi = UPT_FAULTINFO(regs);
 
@@ -205,17 +216,6 @@ unsigned long segv(struct faultinfo fi, 
 	return(0);
 }
 
-void bad_segv(struct faultinfo fi, unsigned long ip)
-{
-	struct siginfo si;
-
-	si.si_signo = SIGSEGV;
-	si.si_code = SEGV_ACCERR;
-	si.si_addr = (void __user *) FAULT_ADDRESS(fi);
-	current->thread.arch.faultinfo = fi;
-	force_sig_info(SIGSEGV, &si, current);
-}
-
 void relay_signal(int sig, union uml_pt_regs *regs)
 {
 	if(arch_handle_signal(sig, regs))
@@ -232,14 +232,14 @@ void relay_signal(int sig, union uml_pt_
 	force_sig(sig, current);
 }
 
-void bus_handler(int sig, union uml_pt_regs *regs)
+static void bus_handler(int sig, union uml_pt_regs *regs)
 {
 	if(current->thread.fault_catcher != NULL)
 		do_longjmp(current->thread.fault_catcher, 1);
 	else relay_signal(sig, regs);
 }
 
-void winch(int sig, union uml_pt_regs *regs)
+static void winch(int sig, union uml_pt_regs *regs)
 {
 	do_IRQ(WINCH_IRQ, regs);
 }
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch

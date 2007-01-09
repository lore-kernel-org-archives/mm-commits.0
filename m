From: akpm@osdl.org
Subject: + uml-make-signal-handlers-static.patch added to -mm tree
Date: Tue, 09 Jan 2007 12:57:57 -0800
Message-ID: <200701092057.l09KvvhR015082@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43466 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443AbXAIU6F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:58:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: make signal handlers static
has been added to the -mm tree.  Its filename is
     uml-make-signal-handlers-static.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: make signal handlers static
From: Jeff Dike <jdike@addtoit.com>

A bunch of the signal handlers can be made static.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
proc-remove-useless-and-buggy-nlink-settings.patch

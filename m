From: akpm@linux-foundation.org
Subject: + x86-disable-unhandled-signals-printk-by-default.patch added to -mm tree
Date: Wed, 25 Jul 2007 21:15:42 -0700
Message-ID: <200707260415.l6Q4FgXD013384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757571AbXGZEQX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 00:16:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: masouds@google.com, ak@suse.de


The patch titled
     x86: disable unhandled-signals printk by default
has been added to the -mm tree.  Its filename is
     x86-disable-unhandled-signals-printk-by-default.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: disable unhandled-signals printk by default
From: Masoud Sharbiani <masouds@google.com

This patch makes the i386 behave the same way that x86_64 does when a
segfault happens. A line gets printed to the kernel log so that tools
that need to check for failures can behave more uniformly between
debug.show_unhandled_signals sysctl variable to 0 (or by doing
echo 0 > /proc/sys/debug/exception-trace)

Also, all of the lines being printed are now using printk_ratelimit()
to deny the ability of DoS from a local user with a program like the
following:

main()
{
       while (1)
               if (!fork()) *(int *)0 = 0;
}

With this patch, the old exception_trace that was enabled becomes disabled by
default; x86_64 had that enabled, and i386 didn't have anything...

Signed-off-by: Masoud Sharbiani <masouds@google.com
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/signal.c   |    7 ------
 arch/i386/kernel/traps.c    |    7 ------
 arch/i386/mm/fault.c        |   10 ---------
 arch/x86_64/kernel/signal.c |    2 -
 arch/x86_64/kernel/traps.c  |    6 +----
 arch/x86_64/mm/fault.c      |   15 +++++++++++---
 arch/x86_64/mm/init.c       |   35 ++++++++++++++++++++++++++++++++++
 include/asm-x86_64/proto.h  |    2 +
 include/linux/signal.h      |    3 --
 kernel/signal.c             |   10 ---------
 kernel/sysctl.c             |   10 ---------
 11 files changed, 52 insertions(+), 55 deletions(-)

diff -puN arch/i386/kernel/signal.c~x86-disable-unhandled-signals-printk-by-default arch/i386/kernel/signal.c
--- a/arch/i386/kernel/signal.c~x86-disable-unhandled-signals-printk-by-default
+++ a/arch/i386/kernel/signal.c
@@ -199,13 +199,6 @@ asmlinkage int sys_sigreturn(unsigned lo
 	return eax;
 
 badframe:
-	if (show_unhandled_signals && printk_ratelimit())
-		printk("%s%s[%d] bad frame in sigreturn frame:%p eip:%lx"
-		       " esp:%lx oeax:%lx\n",
-		    current->pid > 1 ? KERN_INFO : KERN_EMERG,
-		    current->comm, current->pid, frame, regs->eip,
-		    regs->esp, regs->orig_eax);
-
 	force_sig(SIGSEGV, current);
 	return 0;
 }	
diff -puN arch/i386/kernel/traps.c~x86-disable-unhandled-signals-printk-by-default arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~x86-disable-unhandled-signals-printk-by-default
+++ a/arch/i386/kernel/traps.c
@@ -618,13 +618,6 @@ fastcall void __kprobes do_general_prote
 
 	current->thread.error_code = error_code;
 	current->thread.trap_no = 13;
-	if (show_unhandled_signals && unhandled_signal(current, SIGSEGV) &&
-	    printk_ratelimit())
-		printk(KERN_INFO
-		    "%s[%d] general protection eip:%lx esp:%lx error:%lx\n",
-		    current->comm, current->pid,
-		    regs->eip, regs->esp, error_code);
-
 	force_sig(SIGSEGV, current);
 	return;
 
diff -puN arch/i386/mm/fault.c~x86-disable-unhandled-signals-printk-by-default arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~x86-disable-unhandled-signals-printk-by-default
+++ a/arch/i386/mm/fault.c
@@ -283,8 +283,6 @@ static inline int vmalloc_fault(unsigned
 	return 0;
 }
 
-int show_unhandled_signals = 1;
-
 /*
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
@@ -471,14 +469,6 @@ bad_area_nosemaphore:
 		if (is_prefetch(regs, address, error_code))
 			return;
 
-		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
-		    printk_ratelimit()) {
-			printk("%s%s[%d]: segfault at %08lx eip %08lx "
-			    "esp %08lx error %lx\n",
-			    tsk->pid > 1 ? KERN_INFO : KERN_EMERG,
-			    tsk->comm, tsk->pid, address, regs->eip,
-			    regs->esp, error_code);
-		}
 		tsk->thread.cr2 = address;
 		/* Kernel addresses are always protection faults */
 		tsk->thread.error_code = error_code | (address >= TASK_SIZE);
diff -puN arch/x86_64/kernel/signal.c~x86-disable-unhandled-signals-printk-by-default arch/x86_64/kernel/signal.c
--- a/arch/x86_64/kernel/signal.c~x86-disable-unhandled-signals-printk-by-default
+++ a/arch/x86_64/kernel/signal.c
@@ -487,7 +487,7 @@ do_notify_resume(struct pt_regs *regs, v
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
 { 
 	struct task_struct *me = current; 
-	if (show_unhandled_signals && printk_ratelimit())
+	if (exception_trace)
 		printk("%s[%d] bad frame in %s frame:%p rip:%lx rsp:%lx orax:%lx\n",
 	       me->comm,me->pid,where,frame,regs->rip,regs->rsp,regs->orig_rax); 
 
diff -puN arch/x86_64/kernel/traps.c~x86-disable-unhandled-signals-printk-by-default arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~x86-disable-unhandled-signals-printk-by-default
+++ a/arch/x86_64/kernel/traps.c
@@ -584,8 +584,7 @@ static void __kprobes do_trap(int trapnr
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_no = trapnr;
 
-		if (show_unhandled_signals && unhandled_signal(tsk, signr) &&
-		    printk_ratelimit())
+		if (exception_trace && unhandled_signal(tsk, signr))
 			printk(KERN_INFO
 			       "%s[%d] trap %s rip:%lx rsp:%lx error:%lx\n",
 			       tsk->comm, tsk->pid, str,
@@ -689,8 +688,7 @@ asmlinkage void __kprobes do_general_pro
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_no = 13;
 
-		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
-		    printk_ratelimit())
+		if (exception_trace && unhandled_signal(tsk, SIGSEGV))
 			printk(KERN_INFO
 		       "%s[%d] general protection rip:%lx rsp:%lx error:%lx\n",
 			       tsk->comm, tsk->pid,
diff -puN arch/x86_64/mm/fault.c~x86-disable-unhandled-signals-printk-by-default arch/x86_64/mm/fault.c
--- a/arch/x86_64/mm/fault.c~x86-disable-unhandled-signals-printk-by-default
+++ a/arch/x86_64/mm/fault.c
@@ -221,6 +221,16 @@ static int is_errata93(struct pt_regs *r
 	return 0;
 } 
 
+int unhandled_signal(struct task_struct *tsk, int sig)
+{
+	if (is_init(tsk))
+		return 1;
+	if (tsk->ptrace & PT_PTRACED)
+		return 0;
+	return (tsk->sighand->action[sig-1].sa.sa_handler == SIG_IGN) ||
+		(tsk->sighand->action[sig-1].sa.sa_handler == SIG_DFL);
+}
+
 static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
 				 unsigned long error_code)
 {
@@ -292,7 +302,7 @@ static int vmalloc_fault(unsigned long a
 }
 
 static int page_fault_trace;
-int show_unhandled_signals = 1;
+int exception_trace = 1;
 
 /*
  * This routine handles page faults.  It determines the address,
@@ -484,8 +494,7 @@ bad_area_nosemaphore:
 		    (address >> 32))
 			return;
 
-		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
-		    printk_ratelimit()) {
+		if (exception_trace && unhandled_signal(tsk, SIGSEGV)) {
 			printk(
 		       "%s%s[%d]: segfault at %016lx rip %016lx rsp %016lx error %lx\n",
 					tsk->pid > 1 ? KERN_INFO : KERN_EMERG,
diff -puN arch/x86_64/mm/init.c~x86-disable-unhandled-signals-printk-by-default arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~x86-disable-unhandled-signals-printk-by-default
+++ a/arch/x86_64/mm/init.c
@@ -687,6 +687,41 @@ int kern_addr_valid(unsigned long addr) 
 	return pfn_valid(pte_pfn(*pte));
 }
 
+#ifdef CONFIG_SYSCTL
+#include <linux/sysctl.h>
+
+extern int exception_trace, page_fault_trace;
+
+static ctl_table debug_table2[] = {
+	{
+		.ctl_name	= 99,
+		.procname	= "exception-trace",
+		.data		= &exception_trace,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
+	{}
+};
+
+static ctl_table debug_root_table2[] = {
+	{
+		.ctl_name = CTL_DEBUG,
+		.procname = "debug",
+		.mode = 0555,
+		.child = debug_table2
+	},
+	{}
+};
+
+static __init int x8664_sysctl_init(void)
+{
+	register_sysctl_table(debug_root_table2);
+	return 0;
+}
+__initcall(x8664_sysctl_init);
+#endif
+
 /* A pseudo VMA to allow ptrace access for the vsyscall page.  This only
    covers the 64bit vsyscall page now. 32bit has a real VMA now and does
    not need special handling anymore. */
diff -puN include/asm-x86_64/proto.h~x86-disable-unhandled-signals-printk-by-default include/asm-x86_64/proto.h
--- a/include/asm-x86_64/proto.h~x86-disable-unhandled-signals-printk-by-default
+++ a/include/asm-x86_64/proto.h
@@ -75,6 +75,8 @@ extern void setup_node_bootmem(int nodei
 extern void early_quirks(void);
 extern void check_efer(void);
 
+extern int unhandled_signal(struct task_struct *tsk, int sig);
+
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
 
 extern unsigned long table_start, table_end;
diff -puN include/linux/signal.h~x86-disable-unhandled-signals-printk-by-default include/linux/signal.h
--- a/include/linux/signal.h~x86-disable-unhandled-signals-printk-by-default
+++ a/include/linux/signal.h
@@ -237,15 +237,12 @@ extern int group_send_sig_info(int sig, 
 extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
 extern long do_sigpending(void __user *, unsigned long);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
-extern int show_unhandled_signals;
 
 struct pt_regs;
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
 
 extern struct kmem_cache *sighand_cachep;
 
-int unhandled_signal(struct task_struct *tsk, int sig);
-
 /*
  * In POSIX a signal is sent either to a specific thread (Linux task)
  * or to the process as a whole (Linux thread group).  How the signal
diff -puN kernel/signal.c~x86-disable-unhandled-signals-printk-by-default kernel/signal.c
--- a/kernel/signal.c~x86-disable-unhandled-signals-printk-by-default
+++ a/kernel/signal.c
@@ -255,16 +255,6 @@ flush_signal_handlers(struct task_struct
 	}
 }
 
-int unhandled_signal(struct task_struct *tsk, int sig)
-{
-	if (is_init(tsk))
-		return 1;
-	if (tsk->ptrace & PT_PTRACED)
-		return 0;
-	return (tsk->sighand->action[sig-1].sa.sa_handler == SIG_IGN) ||
-		(tsk->sighand->action[sig-1].sa.sa_handler == SIG_DFL);
-}
-
 
 /* Notify the system that a driver wants to block all signals for this
  * process, and wants to be notified if any signals at all were to be
diff -puN kernel/sysctl.c~x86-disable-unhandled-signals-printk-by-default kernel/sysctl.c
--- a/kernel/sysctl.c~x86-disable-unhandled-signals-printk-by-default
+++ a/kernel/sysctl.c
@@ -1203,16 +1203,6 @@ static ctl_table fs_table[] = {
 };
 
 static ctl_table debug_table[] = {
-#ifdef CONFIG_X86
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "exception-trace",
-		.data		= &show_unhandled_signals,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec
-	},
-#endif
 	{ .ctl_name = 0 }
 };
 
_

Patches currently in -mm which might be from masouds@google.com are

x86-disable-unhandled-signals-printk-by-default.patch

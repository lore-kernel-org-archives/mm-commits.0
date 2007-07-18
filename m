From: akpm@linux-foundation.org
Subject: + i386-show-unhandled-signals.patch added to -mm tree
Date: Wed, 18 Jul 2007 13:09:14 -0700
Message-ID: <200707182009.l6IK9E2G026603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38996 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760256AbXGRUJ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 16:09:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: masouds@google.com, ak@suse.de


The patch titled
     i386: show unhandled signals
has been added to the -mm tree.  Its filename is
     i386-show-unhandled-signals.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: show unhandled signals
From: Masoud Sharbiani <masouds@google.com>

This patch makes the i386 behave the same way that x86_64 does when a
segfault happens.  A line gets printed to the kernel log so that tools that
need to check for failures can behave more uniformly between
debug.show_unhandled_signals sysctl variable to 0 (or by doing echo 0 >
/proc/sys/debug/exception-trace)

Also, all of the lines being printed are now using printk_ratelimit() to
deny the ability of DoS from a local user with a program like the
following:

main()
{
       while (1)
               if (!fork()) *(int *)0 = 0;
}

Signed-off-by: Masoud Sharbiani <masouds@google.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/signal.c   |    7 ++++++
 arch/i386/kernel/traps.c    |    7 ++++++
 arch/i386/mm/fault.c        |   10 +++++++++
 arch/x86_64/kernel/signal.c |    2 -
 arch/x86_64/kernel/traps.c  |    6 +++--
 arch/x86_64/mm/fault.c      |   15 ++------------
 arch/x86_64/mm/init.c       |   35 ----------------------------------
 include/asm-x86_64/proto.h  |    2 -
 include/linux/signal.h      |    3 ++
 kernel/signal.c             |   10 +++++++++
 kernel/sysctl.c             |   10 +++++++++
 11 files changed, 55 insertions(+), 52 deletions(-)

diff -puN arch/i386/kernel/signal.c~i386-show-unhandled-signals arch/i386/kernel/signal.c
--- a/arch/i386/kernel/signal.c~i386-show-unhandled-signals
+++ a/arch/i386/kernel/signal.c
@@ -199,6 +199,13 @@ asmlinkage int sys_sigreturn(unsigned lo
 	return eax;
 
 badframe:
+	if (show_unhandled_signals && printk_ratelimit())
+		printk("%s%s[%d] bad frame in sigreturn frame:%p eip:%lx"
+		       " esp:%lx oeax:%lx\n",
+		    current->pid > 1 ? KERN_INFO : KERN_EMERG,
+		    current->comm, current->pid, frame, regs->eip,
+		    regs->esp, regs->orig_eax);
+
 	force_sig(SIGSEGV, current);
 	return 0;
 }	
diff -puN arch/i386/kernel/traps.c~i386-show-unhandled-signals arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~i386-show-unhandled-signals
+++ a/arch/i386/kernel/traps.c
@@ -679,6 +679,13 @@ fastcall void __kprobes do_general_prote
 
 	current->thread.error_code = error_code;
 	current->thread.trap_no = 13;
+	if (show_unhandled_signals && unhandled_signal(current, SIGSEGV) &&
+	    printk_ratelimit())
+		printk(KERN_INFO
+		    "%s[%d] general protection eip:%lx esp:%lx error:%lx\n",
+		    current->comm, current->pid,
+		    regs->eip, regs->esp, error_code);
+
 	force_sig(SIGSEGV, current);
 	return;
 
diff -puN arch/i386/mm/fault.c~i386-show-unhandled-signals arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~i386-show-unhandled-signals
+++ a/arch/i386/mm/fault.c
@@ -283,6 +283,8 @@ static inline int vmalloc_fault(unsigned
 	return 0;
 }
 
+int show_unhandled_signals = 1;
+
 /*
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
@@ -469,6 +471,14 @@ bad_area_nosemaphore:
 		if (is_prefetch(regs, address, error_code))
 			return;
 
+		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
+		    printk_ratelimit()) {
+			printk("%s%s[%d]: segfault at %08lx eip %08lx "
+			    "esp %08lx error %lx\n",
+			    tsk->pid > 1 ? KERN_INFO : KERN_EMERG,
+			    tsk->comm, tsk->pid, address, regs->eip,
+			    regs->esp, error_code);
+		}
 		tsk->thread.cr2 = address;
 		/* Kernel addresses are always protection faults */
 		tsk->thread.error_code = error_code | (address >= TASK_SIZE);
diff -puN arch/x86_64/kernel/signal.c~i386-show-unhandled-signals arch/x86_64/kernel/signal.c
--- a/arch/x86_64/kernel/signal.c~i386-show-unhandled-signals
+++ a/arch/x86_64/kernel/signal.c
@@ -487,7 +487,7 @@ do_notify_resume(struct pt_regs *regs, v
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
 { 
 	struct task_struct *me = current; 
-	if (exception_trace)
+	if (show_unhandled_signals && printk_ratelimit())
 		printk("%s[%d] bad frame in %s frame:%p rip:%lx rsp:%lx orax:%lx\n",
 	       me->comm,me->pid,where,frame,regs->rip,regs->rsp,regs->orig_rax); 
 
diff -puN arch/x86_64/kernel/traps.c~i386-show-unhandled-signals arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~i386-show-unhandled-signals
+++ a/arch/x86_64/kernel/traps.c
@@ -647,7 +647,8 @@ static void __kprobes do_trap(int trapnr
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_no = trapnr;
 
-		if (exception_trace && unhandled_signal(tsk, signr))
+		if (show_unhandled_signals && unhandled_signal(tsk, signr) &&
+		    printk_ratelimit())
 			printk(KERN_INFO
 			       "%s[%d] trap %s rip:%lx rsp:%lx error:%lx\n",
 			       tsk->comm, tsk->pid, str,
@@ -751,7 +752,8 @@ asmlinkage void __kprobes do_general_pro
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_no = 13;
 
-		if (exception_trace && unhandled_signal(tsk, SIGSEGV))
+		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
+		    printk_ratelimit())
 			printk(KERN_INFO
 		       "%s[%d] general protection rip:%lx rsp:%lx error:%lx\n",
 			       tsk->comm, tsk->pid,
diff -puN arch/x86_64/mm/fault.c~i386-show-unhandled-signals arch/x86_64/mm/fault.c
--- a/arch/x86_64/mm/fault.c~i386-show-unhandled-signals
+++ a/arch/x86_64/mm/fault.c
@@ -221,16 +221,6 @@ static int is_errata93(struct pt_regs *r
 	return 0;
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
 static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
 				 unsigned long error_code)
 {
@@ -302,7 +292,7 @@ static int vmalloc_fault(unsigned long a
 }
 
 int page_fault_trace = 0;
-int exception_trace = 1;
+int show_unhandled_signals = 1;
 
 /*
  * This routine handles page faults.  It determines the address,
@@ -494,7 +484,8 @@ bad_area_nosemaphore:
 		    (address >> 32))
 			return;
 
-		if (exception_trace && unhandled_signal(tsk, SIGSEGV)) {
+		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
+		    printk_ratelimit()) {
 			printk(
 		       "%s%s[%d]: segfault at %016lx rip %016lx rsp %016lx error %lx\n",
 					tsk->pid > 1 ? KERN_INFO : KERN_EMERG,
diff -puN arch/x86_64/mm/init.c~i386-show-unhandled-signals arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~i386-show-unhandled-signals
+++ a/arch/x86_64/mm/init.c
@@ -701,41 +701,6 @@ int kern_addr_valid(unsigned long addr) 
 	return pfn_valid(pte_pfn(*pte));
 }
 
-#ifdef CONFIG_SYSCTL
-#include <linux/sysctl.h>
-
-extern int exception_trace, page_fault_trace;
-
-static ctl_table debug_table2[] = {
-	{
-		.ctl_name	= 99,
-		.procname	= "exception-trace",
-		.data		= &exception_trace,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec
-	},
-	{}
-}; 
-
-static ctl_table debug_root_table2[] = { 
-	{
-		.ctl_name = CTL_DEBUG,
-		.procname = "debug",
-		.mode = 0555,
-		.child = debug_table2
-	},
-	{}
-}; 
-
-static __init int x8664_sysctl_init(void)
-{ 
-	register_sysctl_table(debug_root_table2);
-	return 0;
-}
-__initcall(x8664_sysctl_init);
-#endif
-
 /* A pseudo VMA to allow ptrace access for the vsyscall page.  This only
    covers the 64bit vsyscall page now. 32bit has a real VMA now and does
    not need special handling anymore. */
diff -puN include/asm-x86_64/proto.h~i386-show-unhandled-signals include/asm-x86_64/proto.h
--- a/include/asm-x86_64/proto.h~i386-show-unhandled-signals
+++ a/include/asm-x86_64/proto.h
@@ -72,8 +72,6 @@ extern void setup_node_bootmem(int nodei
 extern void early_quirks(void);
 extern void check_efer(void);
 
-extern int unhandled_signal(struct task_struct *tsk, int sig);
-
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
 
 extern unsigned long table_start, table_end;
diff -puN include/linux/signal.h~i386-show-unhandled-signals include/linux/signal.h
--- a/include/linux/signal.h~i386-show-unhandled-signals
+++ a/include/linux/signal.h
@@ -237,12 +237,15 @@ extern int group_send_sig_info(int sig, 
 extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
 extern long do_sigpending(void __user *, unsigned long);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
+extern int show_unhandled_signals;
 
 struct pt_regs;
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
 
 extern struct kmem_cache *sighand_cachep;
 
+int unhandled_signal(struct task_struct *tsk, int sig);
+
 /*
  * In POSIX a signal is sent either to a specific thread (Linux task)
  * or to the process as a whole (Linux thread group).  How the signal
diff -puN kernel/signal.c~i386-show-unhandled-signals kernel/signal.c
--- a/kernel/signal.c~i386-show-unhandled-signals
+++ a/kernel/signal.c
@@ -255,6 +255,16 @@ flush_signal_handlers(struct task_struct
 	}
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
 
 /* Notify the system that a driver wants to block all signals for this
  * process, and wants to be notified if any signals at all were to be
diff -puN kernel/sysctl.c~i386-show-unhandled-signals kernel/sysctl.c
--- a/kernel/sysctl.c~i386-show-unhandled-signals
+++ a/kernel/sysctl.c
@@ -1200,6 +1200,16 @@ static ctl_table fs_table[] = {
 };
 
 static ctl_table debug_table[] = {
+#ifdef CONFIG_X86
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "exception-trace",
+		.data		= &show_unhandled_signals,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
+#endif
 	{ .ctl_name = 0 }
 };
 
_

Patches currently in -mm which might be from masouds@google.com are

i386-show-unhandled-signals.patch

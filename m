From: akpm@linux-foundation.org
Subject: + kallsyms-printk-add-loglvl-to-print_ip_sym.patch added
 to -mm tree
Date: Mon, 20 Apr 2020 16:10:36 -0700
Message-ID: <20200420231036.FTUPUQfB8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgDTXKk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 19:10:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 0x7f454c46@gmail.com, anton.ivanov@cambridgegreys.com, aou@eecs.berkeley.edu, bcain@codeaurora.org, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, bsegall@google.com, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, daniel.thompson@linaro.org, davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de, dianders@chromium.org, dietmar.eggemann@arm.com, dima@arista.com, fenghua.yu@intel.com, geert@linux-m68k.org, gor@linux.ibm.com, green.hu@gmail.com, gregkh@linuxfoundation.org, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, hpa@zytor.com, ink@jurassic.park.msu.ru, jacquiot.aurelien@gmail.com, James.Bottomley@HansenPartnership.com, jason.wessel@windriver.com, jcmvbkbc@gmail.com, jdike@addtoit.com, jhogan@kernel.org, jonas@southpole.se, jslaby@suse.com


The patch titled
     Subject: kallsyms/printk: add loglvl to print_ip_sym()
has been added to the -mm tree.  Its filename is
     kallsyms-printk-add-loglvl-to-print_ip_sym.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kallsyms-printk-add-loglvl-to-print_ip_sym.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kallsyms-printk-add-loglvl-to-print_ip_sym.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: kallsyms/printk: add loglvl to print_ip_sym()

Patch series "Add log level to show_stack()", v3.

Add log level argument to show_stack().

Done in three stages:
1. Introducing show_stack_loglvl() for every architecture
2. Migrating old users with an explicit log level
3. Renaming show_stack_loglvl() into show_stack()

Justification:

- It's a design mistake to move a business-logic decision into platform
  realization detail.

- I have currently two patches sets that would benefit from this work:
  Removing console_loglevel jumps in sysrq driver [1] Hung task warning
  before panic [2] - suggested by Tetsuo (but he probably didn't realise
  what it would involve).

- While doing (1), (2) the backtraces were adjusted to headers and other
  messages for each situation - so there won't be a situation when the
  backtrace is printed, but the headers are missing because they have
  lesser log level (or the reverse).

- As the result in (2) plays with console_loglevel for kdb are removed.

The least important for upstream, but maybe still worth to note that every
company I've worked in so far had an off-list patch to print backtrace
with the needed log level (but only for the architecture they cared
about).  If you have other ideas how you will benefit from show_stack()
with a log level - please, reply to this cover letter.

See also discussion on v1:
https://lore.kernel.org/linux-riscv/20191106083538.z5nlpuf64cigxigh@pathway.suse.cz/


This patch (of 50):

print_ip_sym() needs to have a log level parameter to comply with other
parts being printed.  Otherwise, half of the expected backtrace would be
printed and other may be missing with some logging level.

The following callee(s) are using now the adjusted log level:
- microblaze/unwind: the same level as headers & userspace unwind.
  Note that pr_debug()'s there are for debugging the unwinder itself.
- nds32/traps: symbol addresses are printed with the same log level
  as backtrace headers.
- lockdep: ip for locking issues is printed with the same log level
  as other part of the warning.
- sched: ip where preemption was disabled is printed as error like
  the rest part of the message.
- ftrace: bug reports are now consistent in the log level being used.

Link: http://lkml.kernel.org/r/20200418201944.482088-2-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Ben Segall <bsegall@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Will Deacon <will@kernel.org>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Dmitry Safonov <dima@arista.com>
Cc: Jiri Slaby <jslaby@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Aurelien Jacquiot <jacquiot.aurelien@gmail.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ley Foon Tan <lftan@altera.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Rich Felker <dalias@libc.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/unwind.c |    2 +-
 arch/mips/kernel/traps.c        |    4 ++--
 arch/nds32/kernel/traps.c       |    4 ++--
 arch/riscv/kernel/stacktrace.c  |    2 +-
 include/linux/kallsyms.h        |    4 ++--
 kernel/locking/lockdep.c        |    4 ++--
 kernel/sched/core.c             |    6 ++----
 kernel/trace/ftrace.c           |    8 ++++----
 tools/include/linux/kallsyms.h  |    2 +-
 9 files changed, 17 insertions(+), 19 deletions(-)

--- a/arch/microblaze/kernel/unwind.c~kallsyms-printk-add-loglvl-to-print_ip_sym
+++ a/arch/microblaze/kernel/unwind.c
@@ -254,7 +254,7 @@ static void microblaze_unwind_inner(stru
 					task->comm);
 				break;
 			} else
-				print_ip_sym(pc);
+				print_ip_sym(KERN_INFO, pc);
 		}
 
 		/* Stop when we reach anything not part of the kernel */
--- a/arch/mips/kernel/traps.c~kallsyms-printk-add-loglvl-to-print_ip_sym
+++ a/arch/mips/kernel/traps.c
@@ -123,7 +123,7 @@ static void show_raw_backtrace(unsigned
 			break;
 		}
 		if (__kernel_text_address(addr))
-			print_ip_sym(addr);
+			print_ip_sym(KERN_DEFAULT, addr);
 	}
 	printk("\n");
 }
@@ -153,7 +153,7 @@ static void show_backtrace(struct task_s
 	}
 	printk("Call Trace:\n");
 	do {
-		print_ip_sym(pc);
+		print_ip_sym(KERN_DEFAULT, pc);
 		pc = unwind_stack(task, &sp, pc, &ra);
 	} while (pc);
 	pr_cont("\n");
--- a/arch/nds32/kernel/traps.c~kallsyms-printk-add-loglvl-to-print_ip_sym
+++ a/arch/nds32/kernel/traps.c
@@ -108,7 +108,7 @@ static void __dump(struct task_struct *t
 			if (__kernel_text_address(ret_addr)) {
 				ret_addr = ftrace_graph_ret_addr(
 						tsk, &graph, ret_addr, NULL);
-				print_ip_sym(ret_addr);
+				print_ip_sym(KERN_EMERG, ret_addr);
 			}
 			if (--cnt < 0)
 				break;
@@ -124,7 +124,7 @@ static void __dump(struct task_struct *t
 
 				ret_addr = ftrace_graph_ret_addr(
 						tsk, &graph, ret_addr, NULL);
-				print_ip_sym(ret_addr);
+				print_ip_sym(KERN_EMERG, ret_addr);
 			}
 			if (--cnt < 0)
 				break;
--- a/arch/riscv/kernel/stacktrace.c~kallsyms-printk-add-loglvl-to-print_ip_sym
+++ a/arch/riscv/kernel/stacktrace.c
@@ -99,7 +99,7 @@ static void notrace walk_stackframe(stru
 
 static bool print_trace_address(unsigned long pc, void *arg)
 {
-	print_ip_sym(pc);
+	print_ip_sym(KERN_DEFAULT, pc);
 	return false;
 }
 
--- a/include/linux/kallsyms.h~kallsyms-printk-add-loglvl-to-print_ip_sym
+++ a/include/linux/kallsyms.h
@@ -165,9 +165,9 @@ static inline int kallsyms_show_value(vo
 
 #endif /*CONFIG_KALLSYMS*/
 
-static inline void print_ip_sym(unsigned long ip)
+static inline void print_ip_sym(const char *loglvl, unsigned long ip)
 {
-	printk("[<%px>] %pS\n", (void *) ip, (void *) ip);
+	printk("%s[<%px>] %pS\n", loglvl, (void *) ip, (void *) ip);
 }
 
 #endif /*_LINUX_KALLSYMS_H*/
--- a/kernel/locking/lockdep.c~kallsyms-printk-add-loglvl-to-print_ip_sym
+++ a/kernel/locking/lockdep.c
@@ -4399,7 +4399,7 @@ static void print_unlock_imbalance_bug(s
 		curr->comm, task_pid_nr(curr));
 	print_lockdep_cache(lock);
 	pr_cont(") at:\n");
-	print_ip_sym(ip);
+	print_ip_sym(KERN_WARNING, ip);
 	pr_warn("but there are no more locks to release!\n");
 	pr_warn("\nother info that might help us debug this:\n");
 	lockdep_print_held_locks(curr);
@@ -5050,7 +5050,7 @@ static void print_lock_contention_bug(st
 		curr->comm, task_pid_nr(curr));
 	print_lockdep_cache(lock);
 	pr_cont(") at:\n");
-	print_ip_sym(ip);
+	print_ip_sym(KERN_WARNING, ip);
 	pr_warn("but there are no locks held!\n");
 	pr_warn("\nother info that might help us debug this:\n");
 	lockdep_print_held_locks(curr);
--- a/kernel/sched/core.c~kallsyms-printk-add-loglvl-to-print_ip_sym
+++ a/kernel/sched/core.c
@@ -3912,8 +3912,7 @@ static noinline void __schedule_bug(stru
 	if (IS_ENABLED(CONFIG_DEBUG_PREEMPT)
 	    && in_atomic_preempt_off()) {
 		pr_err("Preemption disabled at:");
-		print_ip_sym(preempt_disable_ip);
-		pr_cont("\n");
+		print_ip_sym(KERN_ERR, preempt_disable_ip);
 	}
 	if (panic_on_warn)
 		panic("scheduling while atomic\n");
@@ -6848,8 +6847,7 @@ void ___might_sleep(const char *file, in
 	if (IS_ENABLED(CONFIG_DEBUG_PREEMPT)
 	    && !preempt_count_equals(preempt_offset)) {
 		pr_err("Preemption disabled at:");
-		print_ip_sym(preempt_disable_ip);
-		pr_cont("\n");
+		print_ip_sym(KERN_ERR, preempt_disable_ip);
 	}
 	dump_stack();
 	add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
--- a/kernel/trace/ftrace.c~kallsyms-printk-add-loglvl-to-print_ip_sym
+++ a/kernel/trace/ftrace.c
@@ -2020,12 +2020,12 @@ void ftrace_bug(int failed, struct dyn_f
 	case -EFAULT:
 		FTRACE_WARN_ON_ONCE(1);
 		pr_info("ftrace faulted on modifying ");
-		print_ip_sym(ip);
+		print_ip_sym(KERN_INFO, ip);
 		break;
 	case -EINVAL:
 		FTRACE_WARN_ON_ONCE(1);
 		pr_info("ftrace failed to modify ");
-		print_ip_sym(ip);
+		print_ip_sym(KERN_INFO, ip);
 		print_ip_ins(" actual:   ", (unsigned char *)ip);
 		pr_cont("\n");
 		if (ftrace_expected) {
@@ -2036,12 +2036,12 @@ void ftrace_bug(int failed, struct dyn_f
 	case -EPERM:
 		FTRACE_WARN_ON_ONCE(1);
 		pr_info("ftrace faulted on writing ");
-		print_ip_sym(ip);
+		print_ip_sym(KERN_INFO, ip);
 		break;
 	default:
 		FTRACE_WARN_ON_ONCE(1);
 		pr_info("ftrace faulted on unknown error ");
-		print_ip_sym(ip);
+		print_ip_sym(KERN_INFO, ip);
 	}
 	print_bug_type();
 	if (rec) {
--- a/tools/include/linux/kallsyms.h~kallsyms-printk-add-loglvl-to-print_ip_sym
+++ a/tools/include/linux/kallsyms.h
@@ -20,7 +20,7 @@ static inline const char *kallsyms_looku
 
 #include <execinfo.h>
 #include <stdlib.h>
-static inline void print_ip_sym(unsigned long ip)
+static inline void print_ip_sym(const char *loglvl, unsigned long ip)
 {
 	char **name;
 
_

Patches currently in -mm which might be from dima@arista.com are

kallsyms-printk-add-loglvl-to-print_ip_sym.patch
alpha-add-show_stack_loglvl.patch
arc-add-show_stack_loglvl.patch
arm-asm-add-loglvl-to-c_backtrace.patch
arm-add-loglvl-to-unwind_backtrace.patch
arm-add-loglvl-to-dump_backtrace.patch
arm-wire-up-dump_backtrace_entrystm.patch
arm-add-show_stack_loglvl.patch
arm64-add-loglvl-to-dump_backtrace.patch
arm64-add-show_stack_loglvl.patch
c6x-add-show_stack_loglvl.patch
csky-add-show_stack_loglvl.patch
h8300-add-show_stack_loglvl.patch
hexagon-add-show_stack_loglvl.patch
ia64-pass-log-level-as-arg-into-ia64_do_show_stack.patch
ia64-add-show_stack_loglvl.patch
m68k-add-show_stack_loglvl.patch
microblaze-add-loglvl-to-microblaze_unwind_inner.patch
microblaze-add-loglvl-to-microblaze_unwind.patch
microblaze-add-show_stack_loglvl.patch
mips-add-show_stack_loglvl.patch
nds32-add-show_stack_loglvl.patch
nios2-add-show_stack_loglvl.patch
openrisc-add-show_stack_loglvl.patch
parisc-add-show_stack_loglvl.patch
powerpc-add-show_stack_loglvl.patch
riscv-add-show_stack_loglvl.patch
s390-add-show_stack_loglvl.patch
sh-add-loglvl-to-dump_mem.patch
sh-remove-needless-printk.patch
sh-add-loglvl-to-printk_address.patch
sh-add-loglvl-to-show_trace.patch
sh-add-show_stack_loglvl.patch
sparc-add-show_stack_loglvl.patch
um-sysrq-remove-needless-variable-sp.patch
um-add-show_stack_loglvl.patch
unicore32-remove-unused-pmode-argument-in-c_backtrace.patch
unicore32-add-loglvl-to-c_backtrace.patch
unicore32-add-show_stack_loglvl.patch
x86-add-missing-const-qualifiers-for-log_lvl.patch
x86-add-show_stack_loglvl.patch
xtensa-add-loglvl-to-show_trace.patch
xtensa-add-show_stack_loglvl.patch
sysrq-use-show_stack_loglvl.patch
x86-amd_gart-print-stacktrace-for-a-leak-with-kern_err.patch
power-use-show_stack_loglvl.patch
kdb-dont-play-with-console_loglevel.patch
sched-print-stack-trace-with-kern_info.patch
kernel-use-show_stack_loglvl.patch
kernel-rename-show_stack_loglvl-=-show_stack.patch

From: akpm@linux-foundation.org
Subject: + move-die-notifier-handling-to-common-code.patch added to -mm tree
Date: Wed, 21 Mar 2007 15:11:00 -0700
Message-ID: <200703212211.l2LMB08x005006@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55857 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933855AbXCUWLk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 18:11:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, linux-arch@vger.kernel.org


The patch titled
     move die notifier handling to common code
has been added to the -mm tree.  Its filename is
     move-die-notifier-handling-to-common-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: move die notifier handling to common code
From: Christoph Hellwig <hch@lst.de>

This patch moves the die notifier handling to common code.  Previous
various architectures had exactly the same code for it.  Note that the new
code is compiled unconditionally, this should be understood as an appel to
the other architecture maintainer to implement support for it aswell (aka
sprinkling a notify_die or two in the proper place)

arm had a notifiy_die that did something totally different, I renamed it to
arm_notify_die as part of the patch and made it static to the file it's
declared and used at.  avr32 used to pass slightly less information through
this interface and I brought it into line with the other architectures.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/traps.c            |   14 +++++-----
 arch/avr32/kernel/kprobes.c        |    2 -
 arch/avr32/kernel/ptrace.c         |    4 +--
 arch/avr32/kernel/traps.c          |   16 ------------
 arch/avr32/mm/fault.c              |    2 -
 arch/i386/kernel/crash.c           |    2 -
 arch/i386/kernel/kprobes.c         |    2 -
 arch/i386/kernel/nmi.c             |    2 -
 arch/i386/kernel/traps.c           |   15 -----------
 arch/i386/mm/fault.c               |    2 -
 arch/i386/oprofile/nmi_int.c       |    2 -
 arch/i386/oprofile/nmi_timer_int.c |    3 --
 arch/ia64/kernel/crash.c           |    2 -
 arch/ia64/kernel/kprobes.c         |    2 -
 arch/ia64/kernel/mca.c             |    2 -
 arch/ia64/kernel/process.c         |    2 -
 arch/ia64/kernel/traps.c           |   18 -------------
 arch/ia64/mm/fault.c               |    2 -
 arch/ia64/sn/kernel/xpc_main.c     |    4 +--
 arch/powerpc/kernel/kprobes.c      |    2 -
 arch/powerpc/kernel/traps.c        |   16 ------------
 arch/powerpc/mm/fault.c            |    2 -
 arch/s390/kernel/kprobes.c         |    2 -
 arch/s390/kernel/traps.c           |   16 ------------
 arch/s390/mm/fault.c               |    2 -
 arch/sparc/kernel/head.S           |    2 -
 arch/sparc/kernel/setup.c          |    2 -
 arch/sparc/kernel/traps.c          |    2 -
 arch/sparc/mm/fault.c              |    2 -
 arch/sparc/mm/srmmu.c              |    2 -
 arch/sparc64/kernel/kprobes.c      |    2 -
 arch/sparc64/kernel/traps.c        |   15 -----------
 arch/sparc64/mm/fault.c            |    2 -
 arch/x86_64/kernel/crash.c         |    2 -
 arch/x86_64/kernel/kprobes.c       |    2 -
 arch/x86_64/kernel/mce.c           |    2 -
 arch/x86_64/kernel/nmi.c           |    2 -
 arch/x86_64/kernel/pci-gart.c      |    2 -
 arch/x86_64/kernel/process.c       |    2 -
 arch/x86_64/kernel/reboot.c        |    2 -
 arch/x86_64/kernel/smpboot.c       |    2 -
 arch/x86_64/kernel/traps.c         |   18 -------------
 arch/x86_64/mm/fault.c             |    2 -
 include/asm-alpha/kdebug.h         |    1 
 include/asm-arm/kdebug.h           |    1 
 include/asm-arm/system.h           |    3 --
 include/asm-arm26/kdebug.h         |    1 
 include/asm-avr32/kdebug.h         |   25 +-----------------
 include/asm-cris/kdebug.h          |    1 
 include/asm-frv/kdebug.h           |    1 
 include/asm-generic/kdebug.h       |    8 ++++++
 include/asm-h8300/kdebug.h         |    1 
 include/asm-i386/kdebug.h          |   24 ------------------
 include/asm-ia64/kdebug.h          |   27 --------------------
 include/asm-m32r/kdebug.h          |    1 
 include/asm-m68k/kdebug.h          |    1 
 include/asm-m68knommu/kdebug.h     |    1 
 include/asm-mips/kdebug.h          |    1 
 include/asm-parisc/kdebug.h        |    1 
 include/asm-powerpc/kdebug.h       |   18 -------------
 include/asm-ppc/kdebug.h           |    1 
 include/asm-s390/kdebug.h          |   28 ---------------------
 include/asm-sh/kdebug.h            |    1 
 include/asm-sh64/kdebug.h          |    1 
 include/asm-sparc/kdebug.h         |    4 +++
 include/asm-sparc64/kdebug.h       |   23 -----------------
 include/asm-um/kdebug.h            |    1 
 include/asm-v850/kdebug.h          |    1 
 include/asm-x86_64/kdebug.h        |   24 ------------------
 include/asm-xtensa/kdebug.h        |    1 
 include/linux/kdebug.h             |   20 +++++++++++++++
 kernel/Makefile                    |    2 -
 kernel/die_notifier.c              |   36 +++++++++++++++++++++++++++
 kernel/kprobes.c                   |    2 -
 74 files changed, 139 insertions(+), 325 deletions(-)

diff -puN arch/arm/kernel/traps.c~move-die-notifier-handling-to-common-code arch/arm/kernel/traps.c
--- a/arch/arm/kernel/traps.c~move-die-notifier-handling-to-common-code
+++ a/arch/arm/kernel/traps.c
@@ -245,8 +245,8 @@ NORET_TYPE void die(const char *str, str
 	do_exit(SIGSEGV);
 }
 
-void notify_die(const char *str, struct pt_regs *regs, struct siginfo *info,
-		unsigned long err, unsigned long trap)
+static void arm_notify_die(const char *str, struct pt_regs *regs,
+		struct siginfo *info, unsigned long err, unsigned long trap)
 {
 	if (user_mode(regs)) {
 		current->thread.error_code = err;
@@ -329,7 +329,7 @@ asmlinkage void __exception do_undefinst
 	info.si_code  = ILL_ILLOPC;
 	info.si_addr  = pc;
 
-	notify_die("Oops - undefined instruction", regs, &info, 0, 6);
+	arm_notify_die("Oops - undefined instruction", regs, &info, 0, 6);
 }
 
 asmlinkage void do_unexp_fiq (struct pt_regs *regs)
@@ -383,7 +383,7 @@ static int bad_syscall(int n, struct pt_
 	info.si_addr  = (void __user *)instruction_pointer(regs) -
 			 (thumb_mode(regs) ? 2 : 4);
 
-	notify_die("Oops - bad syscall", regs, &info, n, 0);
+	arm_notify_die("Oops - bad syscall", regs, &info, n, 0);
 
 	return regs->ARM_r0;
 }
@@ -427,7 +427,7 @@ asmlinkage int arm_syscall(int no, struc
 		info.si_code  = SEGV_MAPERR;
 		info.si_addr  = NULL;
 
-		notify_die("branch through zero", regs, &info, 0, 0);
+		arm_notify_die("branch through zero", regs, &info, 0, 0);
 		return 0;
 
 	case NR(breakpoint): /* SWI BREAK_POINT */
@@ -563,7 +563,7 @@ asmlinkage int arm_syscall(int no, struc
 	info.si_addr  = (void __user *)instruction_pointer(regs) -
 			 (thumb_mode(regs) ? 2 : 4);
 
-	notify_die("Oops - bad syscall(2)", regs, &info, no, 0);
+	arm_notify_die("Oops - bad syscall(2)", regs, &info, no, 0);
 	return 0;
 }
 
@@ -637,7 +637,7 @@ baddataabort(int code, unsigned long ins
 	info.si_code  = ILL_ILLOPC;
 	info.si_addr  = (void __user *)addr;
 
-	notify_die("unknown data abort code", regs, &info, instr, 0);
+	arm_notify_die("unknown data abort code", regs, &info, instr, 0);
 }
 
 void __attribute__((noreturn)) __bug(const char *file, int line)
diff -puN arch/avr32/kernel/kprobes.c~move-die-notifier-handling-to-common-code arch/avr32/kernel/kprobes.c
--- a/arch/avr32/kernel/kprobes.c~move-die-notifier-handling-to-common-code
+++ a/arch/avr32/kernel/kprobes.c
@@ -15,7 +15,7 @@
 #include <linux/ptrace.h>
 
 #include <asm/cacheflush.h>
-#include <asm/kdebug.h>
+#include <linux/kdebug.h>
 #include <asm/ocd.h>
 
 DEFINE_PER_CPU(struct kprobe *, current_kprobe);
diff -puN arch/avr32/kernel/ptrace.c~move-die-notifier-handling-to-common-code arch/avr32/kernel/ptrace.c
--- a/arch/avr32/kernel/ptrace.c~move-die-notifier-handling-to-common-code
+++ a/arch/avr32/kernel/ptrace.c
@@ -21,7 +21,7 @@
 #include <asm/uaccess.h>
 #include <asm/ocd.h>
 #include <asm/mmu_context.h>
-#include <asm/kdebug.h>
+#include <linux/kdebug.h>
 
 static struct pt_regs *get_user_regs(struct task_struct *tsk)
 {
@@ -300,7 +300,7 @@ asmlinkage void do_debug_priv(struct pt_
 	else
 		die_val = DIE_BREAKPOINT;
 
-	if (notify_die(die_val, regs, 0, SIGTRAP) == NOTIFY_STOP)
+	if (notify_die(die_val, "ptrace", regs, 0, 0, SIGTRAP) == NOTIFY_STOP)
 		return;
 
 	if (likely(ds & DS_SSS)) {
diff -puN arch/avr32/kernel/traps.c~move-die-notifier-handling-to-common-code arch/avr32/kernel/traps.c
--- a/arch/avr32/kernel/traps.c~move-die-notifier-handling-to-common-code
+++ a/arch/avr32/kernel/traps.c
@@ -151,22 +151,6 @@ void dump_stack(void)
 }
 EXPORT_SYMBOL(dump_stack);
 
-ATOMIC_NOTIFIER_HEAD(avr32_die_chain);
-
-int register_die_notifier(struct notifier_block *nb)
-{
-	pr_debug("register_die_notifier: %p\n", nb);
-
-	return atomic_notifier_chain_register(&avr32_die_chain, nb);
-}
-EXPORT_SYMBOL(register_die_notifier);
-
-int unregister_die_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&avr32_die_chain, nb);
-}
-EXPORT_SYMBOL(unregister_die_notifier);
-
 static DEFINE_SPINLOCK(die_lock);
 
 void __die(const char *str, struct pt_regs *regs, unsigned long err,
diff -puN arch/avr32/mm/fault.c~move-die-notifier-handling-to-common-code arch/avr32/mm/fault.c
--- a/arch/avr32/mm/fault.c~move-die-notifier-handling-to-common-code
+++ a/arch/avr32/mm/fault.c
@@ -13,7 +13,7 @@
 #include <linux/module.h>
 #include <linux/pagemap.h>
 
-#include <asm/kdebug.h>
+#include <linux/kdebug.h>
 #include <asm/mmu_context.h>
 #include <asm/sysreg.h>
 #include <asm/uaccess.h>
diff -puN arch/i386/kernel/crash.c~move-die-notifier-handling-to-common-code arch/i386/kernel/crash.c
--- a/arch/i386/kernel/crash.c~move-die-notifier-handling-to-common-code
+++ a/arch/i386/kernel/crash.c
@@ -22,7 +22,7 @@
 #include <asm/nmi.h>
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
-#include <asm/kdebug.h>
+#include <linux/kdebug.h>
 #include <asm/smp.h>
 
 #include <mach_ipi.h>
diff -puN arch/i386/kernel/kprobes.c~move-die-notifier-handling-to-common-code arch/i386/kernel/kprobes.c
--- a/arch/i386/kernel/kprobes.c~move-die-notifier-handling-to-common-code
+++ a/arch/i386/kernel/kprobes.c
@@ -31,8 +31,8 @@
 #include <linux/kprobes.h>
 #include <linux/ptrace.h>
 #include <linux/preempt.h>
+#include <linux/kdebug.h>
 #include <asm/cacheflush.h>
-#include <asm/kdebug.h>
 #include <asm/desc.h>
 #include <asm/uaccess.h>
 
diff -puN arch/i386/kernel/nmi.c~move-die-notifier-handling-to-common-code arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c~move-die-notifier-handling-to-common-code
+++ a/arch/i386/kernel/nmi.c
@@ -24,10 +24,10 @@
 #include <linux/kprobes.h>
 #include <linux/cpumask.h>
 #include <linux/kernel_stat.h>
+#include <linux/kdebug.h>
 
 #include <asm/smp.h>
 #include <asm/nmi.h>
-#include <asm/kdebug.h>
 #include <asm/intel_arch_perfmon.h>
 
 #include "mach_traps.h"
diff -puN arch/i386/kernel/traps.c~move-die-notifier-handling-to-common-code arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~move-die-notifier-handling-to-common-code
+++ a/arch/i386/kernel/traps.c
@@ -52,7 +52,7 @@
 #include <asm/unwind.h>
 #include <asm/smp.h>
 #include <asm/arch_hooks.h>
-#include <asm/kdebug.h>
+#include <linux/kdebug.h>
 #include <asm/stacktrace.h>
 
 #include <linux/module.h>
@@ -95,20 +95,7 @@ asmlinkage void machine_check(void);
 
 int kstack_depth_to_print = 24;
 static unsigned int code_bytes = 64;
-ATOMIC_NOTIFIER_HEAD(i386die_chain);
 
-int register_die_notifier(struct notifier_block *nb)
-{
-	vmalloc_sync_all();
-	return atomic_notifier_chain_register(&i386die_chain, nb);
-}
-EXPORT_SYMBOL(register_die_notifier); /* used modular by kdb */
-
-int unregister_die_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&i386die_chain, nb);
-}
-EXPORT_SYMBOL(unregister_die_notifier); /* used modular by kdb */
 
 static inline int valid_stack_ptr(struct thread_info *tinfo, void *p)
 {
diff -puN arch/i386/mm/fault.c~move-die-notifier-handling-to-common-code arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~move-die-notifier-handling-to-common-code
+++ a/arch/i386/mm/fault.c
@@ -24,10 +24,10 @@
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
+#include <linux/kdebug.h>
 
 #include <asm/system.h>
 #include <asm/desc.h>
-#include <asm/kdebug.h>
 #include <asm/segment.h>
 
 extern void die(const char *,struct pt_regs *,long);
diff -puN arch/i386/oprofile/nmi_int.c~move-die-notifier-handling-to-common-code arch/i386/oprofile/nmi_int.c
--- a/arch/i386/oprofile/nmi_int.c~move-die-notifier-handling-to-common-code
+++ a/arch/i386/oprofile/nmi_int.c
@@ -14,10 +14,10 @@
 #include <linux/sysdev.h>
 #include <linux/slab.h>
 #include <linux/moduleparam.h>
+#include <linux/kdebug.h>
 #include <asm/nmi.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
-#include <asm/kdebug.h>
  
 #include "op_counter.h"
 #include "op_x86_model.h"
diff -puN arch/i386/oprofile/nmi_timer_int.c~move-die-notifier-handling-to-common-code arch/i386/oprofile/nmi_timer_int.c
--- a/arch/i386/oprofile/nmi_timer_int.c~move-die-notifier-handling-to-common-code
+++ a/arch/i386/oprofile/nmi_timer_int.c
@@ -12,12 +12,11 @@
 #include <linux/errno.h>
 #include <linux/oprofile.h>
 #include <linux/rcupdate.h>
-
+#include <linux/kdebug.h>
 
 #include <asm/nmi.h>
 #include <asm/apic.h>
 #include <asm/ptrace.h>
-#include <asm/kdebug.h>
  
 static int profile_timer_exceptions_notify(struct notifier_block *self,
 					   unsigned long val, void *data)
diff -puN arch/ia64/kernel/crash.c~move-die-notifier-handling-to-common-code arch/ia64/kernel/crash.c
--- a/arch/ia64/kernel/crash.c~move-die-notifier-handling-to-common-code
+++ a/arch/ia64/kernel/crash.c
@@ -16,8 +16,8 @@
 #include <linux/elfcore.h>
 #include <linux/sysctl.h>
 #include <linux/init.h>
+#include <linux/kdebug.h>
 
-#include <asm/kdebug.h>
 #include <asm/mca.h>
 
 int kdump_status[NR_CPUS];
diff -puN arch/ia64/kernel/kprobes.c~move-die-notifier-handling-to-common-code arch/ia64/kernel/kprobes.c
--- a/arch/ia64/kernel/kprobes.c~move-die-notifier-handling-to-common-code
+++ a/arch/ia64/kernel/kprobes.c
@@ -29,9 +29,9 @@
 #include <linux/slab.h>
 #include <linux/preempt.h>
 #include <linux/moduleloader.h>
+#include <linux/kdebug.h>
 
 #include <asm/pgtable.h>
-#include <asm/kdebug.h>
 #include <asm/sections.h>
 #include <asm/uaccess.h>
 
diff -puN arch/ia64/kernel/mca.c~move-die-notifier-handling-to-common-code arch/ia64/kernel/mca.c
--- a/arch/ia64/kernel/mca.c~move-die-notifier-handling-to-common-code
+++ a/arch/ia64/kernel/mca.c
@@ -72,9 +72,9 @@
 #include <linux/smp.h>
 #include <linux/workqueue.h>
 #include <linux/cpumask.h>
+#include <linux/kdebug.h>
 
 #include <asm/delay.h>
-#include <asm/kdebug.h>
 #include <asm/machvec.h>
 #include <asm/meminit.h>
 #include <asm/page.h>
diff -puN arch/ia64/kernel/process.c~move-die-notifier-handling-to-common-code arch/ia64/kernel/process.c
--- a/arch/ia64/kernel/process.c~move-die-notifier-handling-to-common-code
+++ a/arch/ia64/kernel/process.c
@@ -27,13 +27,13 @@
 #include <linux/efi.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/kdebug.h>
 
 #include <asm/cpu.h>
 #include <asm/delay.h>
 #include <asm/elf.h>
 #include <asm/ia32.h>
 #include <asm/irq.h>
-#include <asm/kdebug.h>
 #include <asm/kexec.h>
 #include <asm/pgalloc.h>
 #include <asm/processor.h>
diff -puN arch/ia64/kernel/traps.c~move-die-notifier-handling-to-common-code arch/ia64/kernel/traps.c
--- a/arch/ia64/kernel/traps.c~move-die-notifier-handling-to-common-code
+++ a/arch/ia64/kernel/traps.c
@@ -16,33 +16,17 @@
 #include <linux/hardirq.h>
 #include <linux/kprobes.h>
 #include <linux/delay.h>		/* for ssleep() */
+#include <linux/kdebug.h>
 
 #include <asm/fpswa.h>
 #include <asm/ia32.h>
 #include <asm/intrinsics.h>
 #include <asm/processor.h>
 #include <asm/uaccess.h>
-#include <asm/kdebug.h>
 
 fpswa_interface_t *fpswa_interface;
 EXPORT_SYMBOL(fpswa_interface);
 
-ATOMIC_NOTIFIER_HEAD(ia64die_chain);
-
-int
-register_die_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&ia64die_chain, nb);
-}
-EXPORT_SYMBOL_GPL(register_die_notifier);
-
-int
-unregister_die_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&ia64die_chain, nb);
-}
-EXPORT_SYMBOL_GPL(unregister_die_notifier);
-
 void __init
 trap_init (void)
 {
diff -puN arch/ia64/mm/fault.c~move-die-notifier-handling-to-common-code arch/ia64/mm/fault.c
--- a/arch/ia64/mm/fault.c~move-die-notifier-handling-to-common-code
+++ a/arch/ia64/mm/fault.c
@@ -10,12 +10,12 @@
 #include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/kprobes.h>
+#include <linux/kdebug.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/uaccess.h>
-#include <asm/kdebug.h>
 
 extern void die (char *, struct pt_regs *, long);
 
diff -puN arch/ia64/sn/kernel/xpc_main.c~move-die-notifier-handling-to-common-code arch/ia64/sn/kernel/xpc_main.c
--- a/arch/ia64/sn/kernel/xpc_main.c~move-die-notifier-handling-to-common-code
+++ a/arch/ia64/sn/kernel/xpc_main.c
@@ -55,9 +55,9 @@
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/completion.h>
+#include <linux/kdebug.h>
 #include <asm/sn/intr.h>
 #include <asm/sn/sn_sal.h>
-#include <asm/kdebug.h>
 #include <asm/uaccess.h>
 #include <asm/sn/xpc.h>
 
@@ -1332,7 +1332,7 @@ xpc_init(void)
 		dev_warn(xpc_part, "can't register reboot notifier\n");
 	}
 
-	/* add ourselves to the die_notifier list (i.e., ia64die_chain) */
+	/* add ourselves to the die_notifier list */
 	ret = register_die_notifier(&xpc_die_notifier);
 	if (ret != 0) {
 		dev_warn(xpc_part, "can't register die notifier\n");
diff -puN arch/powerpc/kernel/kprobes.c~move-die-notifier-handling-to-common-code arch/powerpc/kernel/kprobes.c
--- a/arch/powerpc/kernel/kprobes.c~move-die-notifier-handling-to-common-code
+++ a/arch/powerpc/kernel/kprobes.c
@@ -30,8 +30,8 @@
 #include <linux/ptrace.h>
 #include <linux/preempt.h>
 #include <linux/module.h>
+#include <linux/kdebug.h>
 #include <asm/cacheflush.h>
-#include <asm/kdebug.h>
 #include <asm/sstep.h>
 #include <asm/uaccess.h>
 
diff -puN arch/powerpc/kernel/traps.c~move-die-notifier-handling-to-common-code arch/powerpc/kernel/traps.c
--- a/arch/powerpc/kernel/traps.c~move-die-notifier-handling-to-common-code
+++ a/arch/powerpc/kernel/traps.c
@@ -33,8 +33,8 @@
 #include <linux/kexec.h>
 #include <linux/backlight.h>
 #include <linux/bug.h>
+#include <linux/kdebug.h>
 
-#include <asm/kdebug.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -72,20 +72,6 @@ EXPORT_SYMBOL(__debugger_dabr_match);
 EXPORT_SYMBOL(__debugger_fault_handler);
 #endif
 
-ATOMIC_NOTIFIER_HEAD(powerpc_die_chain);
-
-int register_die_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&powerpc_die_chain, nb);
-}
-EXPORT_SYMBOL(register_die_notifier);
-
-int unregister_die_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&powerpc_die_chain, nb);
-}
-EXPORT_SYMBOL(unregister_die_notifier);
-
 /*
  * Trap & Exception support
  */
diff -puN arch/powerpc/mm/fault.c~move-die-notifier-handling-to-common-code arch/powerpc/mm/fault.c
--- a/arch/powerpc/mm/fault.c~move-die-notifier-handling-to-common-code
+++ a/arch/powerpc/mm/fault.c
@@ -28,6 +28,7 @@
 #include <linux/highmem.h>
 #include <linux/module.h>
 #include <linux/kprobes.h>
+#include <linux/kdebug.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -36,7 +37,6 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
-#include <asm/kdebug.h>
 #include <asm/siginfo.h>
 
 #ifdef CONFIG_KPROBES
diff -puN arch/s390/kernel/kprobes.c~move-die-notifier-handling-to-common-code arch/s390/kernel/kprobes.c
--- a/arch/s390/kernel/kprobes.c~move-die-notifier-handling-to-common-code
+++ a/arch/s390/kernel/kprobes.c
@@ -24,8 +24,8 @@
 #include <linux/ptrace.h>
 #include <linux/preempt.h>
 #include <linux/stop_machine.h>
+#include <linux/kdebug.h>
 #include <asm/cacheflush.h>
-#include <asm/kdebug.h>
 #include <asm/sections.h>
 #include <asm/uaccess.h>
 #include <linux/module.h>
diff -puN arch/s390/kernel/traps.c~move-die-notifier-handling-to-common-code arch/s390/kernel/traps.c
--- a/arch/s390/kernel/traps.c~move-die-notifier-handling-to-common-code
+++ a/arch/s390/kernel/traps.c
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/kdebug.h>
 #include <linux/kallsyms.h>
 #include <linux/reboot.h>
 #include <linux/kprobes.h>
@@ -40,7 +41,6 @@
 #include <asm/s390_ext.h>
 #include <asm/lowcore.h>
 #include <asm/debug.h>
-#include <asm/kdebug.h>
 
 /* Called from entry.S only */
 extern void handle_per_exception(struct pt_regs *regs);
@@ -70,20 +70,6 @@ static int kstack_depth_to_print = 12;
 static int kstack_depth_to_print = 20;
 #endif /* CONFIG_64BIT */
 
-ATOMIC_NOTIFIER_HEAD(s390die_chain);
-
-int register_die_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&s390die_chain, nb);
-}
-EXPORT_SYMBOL(register_die_notifier);
-
-int unregister_die_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&s390die_chain, nb);
-}
-EXPORT_SYMBOL(unregister_die_notifier);
-
 /*
  * For show_trace we have tree different stack to consider:
  *   - the panic stack which is used if the kernel stack has overflown
diff -puN arch/s390/mm/fault.c~move-die-notifier-handling-to-common-code arch/s390/mm/fault.c
--- a/arch/s390/mm/fault.c~move-die-notifier-handling-to-common-code
+++ a/arch/s390/mm/fault.c
@@ -20,6 +20,7 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
+#include <linux/kdebug.h>
 #include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/console.h>
@@ -30,7 +31,6 @@
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
-#include <asm/kdebug.h>
 #include <asm/s390_ext.h>
 
 #ifndef CONFIG_64BIT
diff -puN arch/sparc/kernel/head.S~move-die-notifier-handling-to-common-code arch/sparc/kernel/head.S
--- a/arch/sparc/kernel/head.S~move-die-notifier-handling-to-common-code
+++ a/arch/sparc/kernel/head.S
@@ -19,7 +19,7 @@
 #include <asm/ptrace.h>
 #include <asm/psr.h>
 #include <asm/page.h>
-#include <asm/kdebug.h>
+#include <linux/kdebug.h>
 #include <asm/winmacro.h>
 #include <asm/thread_info.h>	/* TI_UWINMASK */
 #include <asm/errno.h>
diff -puN arch/sparc/kernel/setup.c~move-die-notifier-handling-to-common-code arch/sparc/kernel/setup.c
--- a/arch/sparc/kernel/setup.c~move-die-notifier-handling-to-common-code
+++ a/arch/sparc/kernel/setup.c
@@ -31,6 +31,7 @@
 #include <linux/spinlock.h>
 #include <linux/root_dev.h>
 #include <linux/cpu.h>
+#include <linux/kdebug.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -40,7 +41,6 @@
 #include <asm/pgtable.h>
 #include <asm/traps.h>
 #include <asm/vaddrs.h>
-#include <asm/kdebug.h>
 #include <asm/mbus.h>
 #include <asm/idprom.h>
 #include <asm/machines.h>
diff -puN arch/sparc/kernel/traps.c~move-die-notifier-handling-to-common-code arch/sparc/kernel/traps.c
--- a/arch/sparc/kernel/traps.c~move-die-notifier-handling-to-common-code
+++ a/arch/sparc/kernel/traps.c
@@ -15,6 +15,7 @@
 #include <linux/signal.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
+#include <linux/kdebug.h>
 
 #include <asm/delay.h>
 #include <asm/system.h>
@@ -22,7 +23,6 @@
 #include <asm/oplib.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/kdebug.h>
 #include <asm/unistd.h>
 #include <asm/traps.h>
 
diff -puN arch/sparc/mm/fault.c~move-die-notifier-handling-to-common-code arch/sparc/mm/fault.c
--- a/arch/sparc/mm/fault.c~move-die-notifier-handling-to-common-code
+++ a/arch/sparc/mm/fault.c
@@ -21,6 +21,7 @@
 #include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/kdebug.h>
 
 #include <asm/system.h>
 #include <asm/page.h>
@@ -30,7 +31,6 @@
 #include <asm/oplib.h>
 #include <asm/smp.h>
 #include <asm/traps.h>
-#include <asm/kdebug.h>
 #include <asm/uaccess.h>
 
 extern int prom_node_root;
diff -puN arch/sparc/mm/srmmu.c~move-die-notifier-handling-to-common-code arch/sparc/mm/srmmu.c
--- a/arch/sparc/mm/srmmu.c~move-die-notifier-handling-to-common-code
+++ a/arch/sparc/mm/srmmu.c
@@ -18,13 +18,13 @@
 #include <linux/bootmem.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
+#include <linux/kdebug.h>
 
 #include <asm/bitext.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
-#include <asm/kdebug.h>
 #include <asm/vaddrs.h>
 #include <asm/traps.h>
 #include <asm/smp.h>
diff -puN arch/sparc64/kernel/kprobes.c~move-die-notifier-handling-to-common-code arch/sparc64/kernel/kprobes.c
--- a/arch/sparc64/kernel/kprobes.c~move-die-notifier-handling-to-common-code
+++ a/arch/sparc64/kernel/kprobes.c
@@ -6,7 +6,7 @@
 #include <linux/kernel.h>
 #include <linux/kprobes.h>
 #include <linux/module.h>
-#include <asm/kdebug.h>
+#include <linux/kdebug.h>
 #include <asm/signal.h>
 #include <asm/cacheflush.h>
 #include <asm/uaccess.h>
diff -puN arch/sparc64/kernel/traps.c~move-die-notifier-handling-to-common-code arch/sparc64/kernel/traps.c
--- a/arch/sparc64/kernel/traps.c~move-die-notifier-handling-to-common-code
+++ a/arch/sparc64/kernel/traps.c
@@ -18,6 +18,7 @@
 #include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/init.h>
+#include <linux/kdebug.h>
 
 #include <asm/delay.h>
 #include <asm/system.h>
@@ -36,26 +37,12 @@
 #include <asm/psrcompat.h>
 #include <asm/processor.h>
 #include <asm/timer.h>
-#include <asm/kdebug.h>
 #include <asm/head.h>
 #ifdef CONFIG_KMOD
 #include <linux/kmod.h>
 #endif
 #include <asm/prom.h>
 
-ATOMIC_NOTIFIER_HEAD(sparc64die_chain);
-
-int register_die_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&sparc64die_chain, nb);
-}
-EXPORT_SYMBOL(register_die_notifier);
-
-int unregister_die_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&sparc64die_chain, nb);
-}
-EXPORT_SYMBOL(unregister_die_notifier);
 
 /* When an irrecoverable trap occurs at tl > 0, the trap entry
  * code logs the trap state registers at every level in the trap
diff -puN arch/sparc64/mm/fault.c~move-die-notifier-handling-to-common-code arch/sparc64/mm/fault.c
--- a/arch/sparc64/mm/fault.c~move-die-notifier-handling-to-common-code
+++ a/arch/sparc64/mm/fault.c
@@ -20,6 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/kprobes.h>
 #include <linux/kallsyms.h>
+#include <linux/kdebug.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -29,7 +30,6 @@
 #include <asm/asi.h>
 #include <asm/lsu.h>
 #include <asm/sections.h>
-#include <asm/kdebug.h>
 #include <asm/mmu_context.h>
 
 #ifdef CONFIG_KPROBES
diff -puN arch/x86_64/kernel/crash.c~move-die-notifier-handling-to-common-code arch/x86_64/kernel/crash.c
--- a/arch/x86_64/kernel/crash.c~move-die-notifier-handling-to-common-code
+++ a/arch/x86_64/kernel/crash.c
@@ -17,13 +17,13 @@
 #include <linux/delay.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
+#include <linux/kdebug.h>
 
 #include <asm/processor.h>
 #include <asm/hardirq.h>
 #include <asm/nmi.h>
 #include <asm/hw_irq.h>
 #include <asm/mach_apic.h>
-#include <asm/kdebug.h>
 
 /* This keeps a track of which one is crashing cpu. */
 static int crashing_cpu;
diff -puN arch/x86_64/kernel/kprobes.c~move-die-notifier-handling-to-common-code arch/x86_64/kernel/kprobes.c
--- a/arch/x86_64/kernel/kprobes.c~move-die-notifier-handling-to-common-code
+++ a/arch/x86_64/kernel/kprobes.c
@@ -37,10 +37,10 @@
 #include <linux/slab.h>
 #include <linux/preempt.h>
 #include <linux/module.h>
+#include <linux/kdebug.h>
 
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
-#include <asm/kdebug.h>
 #include <asm/uaccess.h>
 
 void jprobe_return_end(void);
diff -puN arch/x86_64/kernel/mce.c~move-die-notifier-handling-to-common-code arch/x86_64/kernel/mce.c
--- a/arch/x86_64/kernel/mce.c~move-die-notifier-handling-to-common-code
+++ a/arch/x86_64/kernel/mce.c
@@ -20,10 +20,10 @@
 #include <linux/percpu.h>
 #include <linux/ctype.h>
 #include <linux/kmod.h>
+#include <linux/kdebug.h>
 #include <asm/processor.h> 
 #include <asm/msr.h>
 #include <asm/mce.h>
-#include <asm/kdebug.h>
 #include <asm/uaccess.h>
 #include <asm/smp.h>
 
diff -puN arch/x86_64/kernel/nmi.c~move-die-notifier-handling-to-common-code arch/x86_64/kernel/nmi.c
--- a/arch/x86_64/kernel/nmi.c~move-die-notifier-handling-to-common-code
+++ a/arch/x86_64/kernel/nmi.c
@@ -21,11 +21,11 @@
 #include <linux/sysctl.h>
 #include <linux/kprobes.h>
 #include <linux/cpumask.h>
+#include <linux/kdebug.h>
 
 #include <asm/smp.h>
 #include <asm/nmi.h>
 #include <asm/proto.h>
-#include <asm/kdebug.h>
 #include <asm/mce.h>
 #include <asm/intel_arch_perfmon.h>
 
diff -puN arch/x86_64/kernel/pci-gart.c~move-die-notifier-handling-to-common-code arch/x86_64/kernel/pci-gart.c
--- a/arch/x86_64/kernel/pci-gart.c~move-die-notifier-handling-to-common-code
+++ a/arch/x86_64/kernel/pci-gart.c
@@ -22,13 +22,13 @@
 #include <linux/topology.h>
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
+#include <linux/kdebug.h>
 #include <asm/atomic.h>
 #include <asm/io.h>
 #include <asm/mtrr.h>
 #include <asm/pgtable.h>
 #include <asm/proto.h>
 #include <asm/cacheflush.h>
-#include <asm/kdebug.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
 #include <asm/k8.h>
diff -puN arch/x86_64/kernel/process.c~move-die-notifier-handling-to-common-code arch/x86_64/kernel/process.c
--- a/arch/x86_64/kernel/process.c~move-die-notifier-handling-to-common-code
+++ a/arch/x86_64/kernel/process.c
@@ -36,6 +36,7 @@
 #include <linux/random.h>
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
+#include <linux/kdebug.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -46,7 +47,6 @@
 #include <asm/mmu_context.h>
 #include <asm/pda.h>
 #include <asm/prctl.h>
-#include <asm/kdebug.h>
 #include <asm/desc.h>
 #include <asm/proto.h>
 #include <asm/ia32.h>
diff -puN arch/x86_64/kernel/reboot.c~move-die-notifier-handling-to-common-code arch/x86_64/kernel/reboot.c
--- a/arch/x86_64/kernel/reboot.c~move-die-notifier-handling-to-common-code
+++ a/arch/x86_64/kernel/reboot.c
@@ -7,8 +7,8 @@
 #include <linux/ctype.h>
 #include <linux/string.h>
 #include <linux/pm.h>
+#include <linux/kdebug.h>
 #include <asm/io.h>
-#include <asm/kdebug.h>
 #include <asm/delay.h>
 #include <asm/hw_irq.h>
 #include <asm/system.h>
diff -puN arch/x86_64/kernel/smpboot.c~move-die-notifier-handling-to-common-code arch/x86_64/kernel/smpboot.c
--- a/arch/x86_64/kernel/smpboot.c~move-die-notifier-handling-to-common-code
+++ a/arch/x86_64/kernel/smpboot.c
@@ -49,11 +49,11 @@
 #include <linux/delay.h>
 #include <linux/mc146818rtc.h>
 #include <linux/smp.h>
+#include <linux/kdebug.h>
 
 #include <asm/mtrr.h>
 #include <asm/pgalloc.h>
 #include <asm/desc.h>
-#include <asm/kdebug.h>
 #include <asm/tlbflush.h>
 #include <asm/proto.h>
 #include <asm/nmi.h>
diff -puN arch/x86_64/kernel/traps.c~move-die-notifier-handling-to-common-code arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~move-die-notifier-handling-to-common-code
+++ a/arch/x86_64/kernel/traps.c
@@ -32,6 +32,7 @@
 #include <linux/unwind.h>
 #include <linux/uaccess.h>
 #include <linux/bug.h>
+#include <linux/kdebug.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -39,7 +40,6 @@
 #include <asm/debugreg.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
-#include <asm/kdebug.h>
 #include <asm/processor.h>
 #include <asm/unwind.h>
 #include <asm/smp.h>
@@ -71,22 +71,6 @@ asmlinkage void alignment_check(void);
 asmlinkage void machine_check(void);
 asmlinkage void spurious_interrupt_bug(void);
 
-ATOMIC_NOTIFIER_HEAD(die_chain);
-EXPORT_SYMBOL(die_chain);
-
-int register_die_notifier(struct notifier_block *nb)
-{
-	vmalloc_sync_all();
-	return atomic_notifier_chain_register(&die_chain, nb);
-}
-EXPORT_SYMBOL(register_die_notifier); /* used modular by kdb */
-
-int unregister_die_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&die_chain, nb);
-}
-EXPORT_SYMBOL(unregister_die_notifier); /* used modular by kdb */
-
 static inline void conditional_sti(struct pt_regs *regs)
 {
 	if (regs->eflags & X86_EFLAGS_IF)
diff -puN arch/x86_64/mm/fault.c~move-die-notifier-handling-to-common-code arch/x86_64/mm/fault.c
--- a/arch/x86_64/mm/fault.c~move-die-notifier-handling-to-common-code
+++ a/arch/x86_64/mm/fault.c
@@ -24,13 +24,13 @@
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
+#include <linux/kdebug.h>
 
 #include <asm/system.h>
 #include <asm/pgalloc.h>
 #include <asm/smp.h>
 #include <asm/tlbflush.h>
 #include <asm/proto.h>
-#include <asm/kdebug.h>
 #include <asm-generic/sections.h>
 
 /* Page fault error code bits */
diff -puN /dev/null include/asm-alpha/kdebug.h
--- /dev/null
+++ a/include/asm-alpha/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN /dev/null include/asm-arm/kdebug.h
--- /dev/null
+++ a/include/asm-arm/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN include/asm-arm/system.h~move-die-notifier-handling-to-common-code include/asm-arm/system.h
--- a/include/asm-arm/system.h~move-die-notifier-handling-to-common-code
+++ a/include/asm-arm/system.h
@@ -92,9 +92,6 @@ void die(const char *msg, struct pt_regs
 		__attribute__((noreturn));
 
 struct siginfo;
-void notify_die(const char *str, struct pt_regs *regs, struct siginfo *info,
-		unsigned long err, unsigned long trap);
-
 void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
 				       struct pt_regs *),
 		     int sig, const char *name);
diff -puN /dev/null include/asm-arm26/kdebug.h
--- /dev/null
+++ a/include/asm-arm26/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN include/asm-avr32/kdebug.h~move-die-notifier-handling-to-common-code include/asm-avr32/kdebug.h
--- a/include/asm-avr32/kdebug.h~move-die-notifier-handling-to-common-code
+++ a/include/asm-avr32/kdebug.h
@@ -3,19 +3,6 @@
 
 #include <linux/notifier.h>
 
-struct pt_regs;
-
-struct die_args {
-	struct pt_regs *regs;
-	int trapnr;
-};
-
-int register_die_notifier(struct notifier_block *nb);
-int unregister_die_notifier(struct notifier_block *nb);
-int register_page_fault_notifier(struct notifier_block *nb);
-int unregister_page_fault_notifier(struct notifier_block *nb);
-extern struct atomic_notifier_head avr32_die_chain;
-
 /* Grossly misnamed. */
 enum die_val {
 	DIE_FAULT,
@@ -24,15 +11,7 @@ enum die_val {
 	DIE_PAGE_FAULT,
 };
 
-static inline int notify_die(enum die_val val, struct pt_regs *regs,
-			     int trap, int sig)
-{
-	struct die_args args = {
-		.regs = regs,
-		.trapnr = trap,
-	};
-
-	return atomic_notifier_call_chain(&avr32_die_chain, val, &args);
-}
+int register_page_fault_notifier(struct notifier_block *nb);
+int unregister_page_fault_notifier(struct notifier_block *nb);
 
 #endif /* __ASM_AVR32_KDEBUG_H */
diff -puN /dev/null include/asm-cris/kdebug.h
--- /dev/null
+++ a/include/asm-cris/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN /dev/null include/asm-frv/kdebug.h
--- /dev/null
+++ a/include/asm-frv/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN /dev/null include/asm-generic/kdebug.h
--- /dev/null
+++ a/include/asm-generic/kdebug.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_GENERIC_KDEBUG_H
+#define _ASM_GENERIC_KDEBUG_H
+
+enum die_val {
+	DIE_UNUSED,
+};
+
+#endif /* _ASM_GENERIC_KDEBUG_H */
diff -puN /dev/null include/asm-h8300/kdebug.h
--- /dev/null
+++ a/include/asm-h8300/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN include/asm-i386/kdebug.h~move-die-notifier-handling-to-common-code include/asm-i386/kdebug.h
--- a/include/asm-i386/kdebug.h~move-die-notifier-handling-to-common-code
+++ a/include/asm-i386/kdebug.h
@@ -9,19 +9,8 @@
 
 struct pt_regs;
 
-struct die_args {
-	struct pt_regs *regs;
-	const char *str;
-	long err;
-	int trapnr;
-	int signr;
-};
-
-extern int register_die_notifier(struct notifier_block *);
-extern int unregister_die_notifier(struct notifier_block *);
 extern int register_page_fault_notifier(struct notifier_block *);
 extern int unregister_page_fault_notifier(struct notifier_block *);
-extern struct atomic_notifier_head i386die_chain;
 
 
 /* Grossly misnamed. */
@@ -42,17 +31,4 @@ enum die_val {
 	DIE_PAGE_FAULT,
 };
 
-static inline int notify_die(enum die_val val, const char *str,
-			struct pt_regs *regs, long err, int trap, int sig)
-{
-	struct die_args args = {
-		.regs = regs,
-		.str = str,
-		.err = err,
-		.trapnr = trap,
-		.signr = sig
-	};
-	return atomic_notifier_call_chain(&i386die_chain, val, &args);
-}
-
 #endif
diff -puN include/asm-ia64/kdebug.h~move-die-notifier-handling-to-common-code include/asm-ia64/kdebug.h
--- a/include/asm-ia64/kdebug.h~move-die-notifier-handling-to-common-code
+++ a/include/asm-ia64/kdebug.h
@@ -28,21 +28,8 @@
  */
 #include <linux/notifier.h>
 
-struct pt_regs;
-
-struct die_args {
-	struct pt_regs *regs;
-	const char *str;
-	long err;
-	int trapnr;
-	int signr;
-};
-
-extern int register_die_notifier(struct notifier_block *);
-extern int unregister_die_notifier(struct notifier_block *);
 extern int register_page_fault_notifier(struct notifier_block *);
 extern int unregister_page_fault_notifier(struct notifier_block *);
-extern struct atomic_notifier_head ia64die_chain;
 
 enum die_val {
 	DIE_BREAK = 1,
@@ -74,18 +61,4 @@ enum die_val {
 	DIE_KDUMP_LEAVE,
 };
 
-static inline int notify_die(enum die_val val, char *str, struct pt_regs *regs,
-			     long err, int trap, int sig)
-{
-	struct die_args args = {
-		.regs   = regs,
-		.str    = str,
-		.err    = err,
-		.trapnr = trap,
-		.signr  = sig
-	};
-
-	return atomic_notifier_call_chain(&ia64die_chain, val, &args);
-}
-
 #endif
diff -puN /dev/null include/asm-m32r/kdebug.h
--- /dev/null
+++ a/include/asm-m32r/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN /dev/null include/asm-m68k/kdebug.h
--- /dev/null
+++ a/include/asm-m68k/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN /dev/null include/asm-m68knommu/kdebug.h
--- /dev/null
+++ a/include/asm-m68knommu/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN /dev/null include/asm-mips/kdebug.h
--- /dev/null
+++ a/include/asm-mips/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN /dev/null include/asm-parisc/kdebug.h
--- /dev/null
+++ a/include/asm-parisc/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN include/asm-powerpc/kdebug.h~move-die-notifier-handling-to-common-code include/asm-powerpc/kdebug.h
--- a/include/asm-powerpc/kdebug.h~move-die-notifier-handling-to-common-code
+++ a/include/asm-powerpc/kdebug.h
@@ -6,18 +6,6 @@
 
 #include <linux/notifier.h>
 
-struct pt_regs;
-
-struct die_args {
-	struct pt_regs *regs;
-	const char *str;
-	long err;
-	int trapnr;
-	int signr;
-};
-
-extern int register_die_notifier(struct notifier_block *);
-extern int unregister_die_notifier(struct notifier_block *);
 extern int register_page_fault_notifier(struct notifier_block *);
 extern int unregister_page_fault_notifier(struct notifier_block *);
 extern struct atomic_notifier_head powerpc_die_chain;
@@ -32,11 +20,5 @@ enum die_val {
 	DIE_PAGE_FAULT,
 };
 
-static inline int notify_die(enum die_val val,char *str,struct pt_regs *regs,long err,int trap, int sig)
-{
-	struct die_args args = { .regs=regs, .str=str, .err=err, .trapnr=trap,.signr=sig };
-	return atomic_notifier_call_chain(&powerpc_die_chain, val, &args);
-}
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_KDEBUG_H */
diff -puN /dev/null include/asm-ppc/kdebug.h
--- /dev/null
+++ a/include/asm-ppc/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN include/asm-s390/kdebug.h~move-die-notifier-handling-to-common-code include/asm-s390/kdebug.h
--- a/include/asm-s390/kdebug.h~move-die-notifier-handling-to-common-code
+++ a/include/asm-s390/kdebug.h
@@ -8,23 +8,8 @@
 
 struct pt_regs;
 
-struct die_args {
-	struct pt_regs *regs;
-	const char *str;
-	long err;
-	int trapnr;
-	int signr;
-};
-
-/* Note - you should never unregister because that can race with NMIs.
- * If you really want to do it first unregister - then synchronize_sched
- *  - then free.
- */
-extern int register_die_notifier(struct notifier_block *);
-extern int unregister_die_notifier(struct notifier_block *);
 extern int register_page_fault_notifier(struct notifier_block *);
 extern int unregister_page_fault_notifier(struct notifier_block *);
-extern struct atomic_notifier_head s390die_chain;
 
 enum die_val {
 	DIE_OOPS = 1,
@@ -42,19 +27,6 @@ enum die_val {
 	DIE_PAGE_FAULT,
 };
 
-static inline int notify_die(enum die_val val, const char *str,
-			struct pt_regs *regs, long err, int trap, int sig)
-{
-	struct die_args args = {
-		.regs = regs,
-		.str = str,
-		.err = err,
-		.trapnr = trap,
-		.signr = sig
-	};
-	return atomic_notifier_call_chain(&s390die_chain, val, &args);
-}
-
 extern void die(const char *, struct pt_regs *, long);
 
 #endif
diff -puN /dev/null include/asm-sh/kdebug.h
--- /dev/null
+++ a/include/asm-sh/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN /dev/null include/asm-sh64/kdebug.h
--- /dev/null
+++ a/include/asm-sh64/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN include/asm-sparc/kdebug.h~move-die-notifier-handling-to-common-code include/asm-sparc/kdebug.h
--- a/include/asm-sparc/kdebug.h~move-die-notifier-handling-to-common-code
+++ a/include/asm-sparc/kdebug.h
@@ -66,4 +66,8 @@ static inline void sp_enter_debugger(voi
 #define KDEBUG_DUNNO2_OFF   0x8
 #define KDEBUG_TEACH_OFF    0xc
 
+enum die_val {
+	DIE_UNUSED,
+};
+
 #endif /* !(_SPARC_KDEBUG_H) */
diff -puN include/asm-sparc64/kdebug.h~move-die-notifier-handling-to-common-code include/asm-sparc64/kdebug.h
--- a/include/asm-sparc64/kdebug.h~move-die-notifier-handling-to-common-code
+++ a/include/asm-sparc64/kdebug.h
@@ -7,19 +7,8 @@
 
 struct pt_regs;
 
-struct die_args {
-	struct pt_regs *regs;
-	const char *str;
-	long err;
-	int trapnr;
-	int signr;
-};
-
-extern int register_die_notifier(struct notifier_block *);
-extern int unregister_die_notifier(struct notifier_block *);
 extern int register_page_fault_notifier(struct notifier_block *);
 extern int unregister_page_fault_notifier(struct notifier_block *);
-extern struct atomic_notifier_head sparc64die_chain;
 
 extern void bad_trap(struct pt_regs *, long);
 
@@ -36,16 +25,4 @@ enum die_val {
 	DIE_PAGE_FAULT,
 };
 
-static inline int notify_die(enum die_val val,char *str, struct pt_regs *regs,
-			     long err, int trap, int sig)
-{
-	struct die_args args = { .regs		= regs,
-				 .str		= str,
-				 .err		= err,
-				 .trapnr	= trap,
-				 .signr		= sig };
-
-	return atomic_notifier_call_chain(&sparc64die_chain, val, &args);
-}
-
 #endif
diff -puN /dev/null include/asm-um/kdebug.h
--- /dev/null
+++ a/include/asm-um/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN /dev/null include/asm-v850/kdebug.h
--- /dev/null
+++ a/include/asm-v850/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN include/asm-x86_64/kdebug.h~move-die-notifier-handling-to-common-code include/asm-x86_64/kdebug.h
--- a/include/asm-x86_64/kdebug.h~move-die-notifier-handling-to-common-code
+++ a/include/asm-x86_64/kdebug.h
@@ -5,19 +5,8 @@
 
 struct pt_regs;
 
-struct die_args {
-	struct pt_regs *regs;
-	const char *str;
-	long err;
-	int trapnr;
-	int signr;
-};
-
-extern int register_die_notifier(struct notifier_block *);
-extern int unregister_die_notifier(struct notifier_block *);
 extern int register_page_fault_notifier(struct notifier_block *);
 extern int unregister_page_fault_notifier(struct notifier_block *);
-extern struct atomic_notifier_head die_chain;
 
 /* Grossly misnamed. */
 enum die_val {
@@ -37,19 +26,6 @@ enum die_val {
 	DIE_PAGE_FAULT,
 };
 
-static inline int notify_die(enum die_val val, const char *str,
-			struct pt_regs *regs, long err, int trap, int sig)
-{
-	struct die_args args = {
-		.regs = regs,
-		.str = str,
-		.err = err,
-		.trapnr = trap,
-		.signr = sig
-	};
-	return atomic_notifier_call_chain(&die_chain, val, &args);
-} 
-
 extern void printk_address(unsigned long address);
 extern void die(const char *,struct pt_regs *,long);
 extern void __die(const char *,struct pt_regs *,long);
diff -puN /dev/null include/asm-xtensa/kdebug.h
--- /dev/null
+++ a/include/asm-xtensa/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff -puN /dev/null include/linux/kdebug.h
--- /dev/null
+++ a/include/linux/kdebug.h
@@ -0,0 +1,20 @@
+#ifndef _LINUX_KDEBUG_H
+#define _LINUX_KDEBUG_H
+
+#include <asm/kdebug.h>
+
+struct die_args {
+	struct pt_regs *regs;
+	const char *str;
+	long err;
+	int trapnr;
+	int signr;
+};
+
+int register_die_notifier(struct notifier_block *nb);
+int unregister_die_notifier(struct notifier_block *nb);
+
+int notify_die(enum die_val val, const char *str,
+	       struct pt_regs *regs, long err, int trap, int sig);
+
+#endif /* _LINUX_KDEBUG_H */
diff -puN kernel/Makefile~move-die-notifier-handling-to-common-code kernel/Makefile
--- a/kernel/Makefile~move-die-notifier-handling-to-common-code
+++ a/kernel/Makefile
@@ -8,7 +8,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
-	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o
+	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o die_notifier.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
diff -puN /dev/null kernel/die_notifier.c
--- /dev/null
+++ a/kernel/die_notifier.c
@@ -0,0 +1,36 @@
+
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/kdebug.h>
+
+
+static ATOMIC_NOTIFIER_HEAD(die_chain);
+
+int notify_die(enum die_val val, const char *str,
+	       struct pt_regs *regs, long err, int trap, int sig)
+{
+	struct die_args args = {
+		.regs		= regs,
+		.str		= str,
+		.err		= err,
+		.trapnr		= trap,
+		.signr		= sig,
+
+	};
+
+	return atomic_notifier_call_chain(&die_chain, val, &args);
+}
+
+int register_die_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&die_chain, nb);
+}
+EXPORT_SYMBOL_GPL(register_die_notifier);
+
+int unregister_die_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&die_chain, nb);
+}
+EXPORT_SYMBOL_GPL(unregister_die_notifier);
+
+
diff -puN kernel/kprobes.c~move-die-notifier-handling-to-common-code kernel/kprobes.c
--- a/kernel/kprobes.c~move-die-notifier-handling-to-common-code
+++ a/kernel/kprobes.c
@@ -42,10 +42,10 @@
 #include <linux/freezer.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/kdebug.h>
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
 #include <asm/errno.h>
-#include <asm/kdebug.h>
 
 #define KPROBE_HASH_BITS 6
 #define KPROBE_TABLE_SIZE (1 << KPROBE_HASH_BITS)
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
cifs-remove-unneeded-checks.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
simplify-the-stacktrace-code.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
freevxfs-possible-null-pointer-dereference-fix.patch
vfs-remove-superflous-sb-==-null-checks.patch
nameic-remove-utterly-outdated-comment.patch
move-die-notifier-handling-to-common-code.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch

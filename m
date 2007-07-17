From: akpm@linux-foundation.org
Subject: - report-that-kernel-is-tainted-if-there-were-an-oops-before.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:58 -0700
Message-ID: <200707172301.l6HN1wCn011442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936736AbXGQXQe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, linux-arch@vger.kernel.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Report that kernel is tainted if there was an OOPS
has been removed from the -mm tree.  Its filename was
     report-that-kernel-is-tainted-if-there-were-an-oops-before.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Report that kernel is tainted if there was an OOPS
From: Pavel Emelianov <xemul@openvz.org>

If the kernel OOPSed or BUGed then it probably should be considered as
tainted.  Thus, all subsequent OOPSes and SysRq dumps will report the
tainted kernel.  This saves a lot of time explaining oddities in the
calltraces.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/oops-tracing.txt |    2 ++
 arch/alpha/kernel/traps.c      |    1 +
 arch/arm/kernel/traps.c        |    1 +
 arch/arm26/kernel/traps.c      |    1 +
 arch/avr32/kernel/traps.c      |    1 +
 arch/i386/kernel/traps.c       |    1 +
 arch/ia64/kernel/traps.c       |    1 +
 arch/m68k/kernel/traps.c       |    1 +
 arch/m68knommu/kernel/traps.c  |    1 +
 arch/mips/kernel/traps.c       |    1 +
 arch/powerpc/kernel/traps.c    |    1 +
 arch/ppc/kernel/traps.c        |    1 +
 arch/s390/kernel/traps.c       |    1 +
 arch/sh/kernel/traps.c         |    1 +
 arch/sparc/kernel/traps.c      |    1 +
 arch/sparc64/kernel/traps.c    |    1 +
 arch/x86_64/kernel/traps.c     |    1 +
 arch/xtensa/kernel/traps.c     |    1 +
 include/linux/kernel.h         |    1 +
 kernel/panic.c                 |    5 +++--
 20 files changed, 23 insertions(+), 2 deletions(-)

diff -puN Documentation/oops-tracing.txt~report-that-kernel-is-tainted-if-there-were-an-oops-before Documentation/oops-tracing.txt
--- a/Documentation/oops-tracing.txt~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/Documentation/oops-tracing.txt
@@ -251,6 +251,8 @@ characters, each representing a particul
   7: 'U' if a user or user application specifically requested that the
      Tainted flag be set, ' ' otherwise.
 
+  8: 'D' if the kernel has died recently, i.e. there was an OOPS or BUG.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
diff -puN arch/alpha/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/alpha/kernel/traps.c
--- a/arch/alpha/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/alpha/kernel/traps.c
@@ -184,6 +184,7 @@ die_if_kernel(char * str, struct pt_regs
 #endif
 	printk("%s(%d): %s %ld\n", current->comm, current->pid, str, err);
 	dik_show_regs(regs, r9_15);
+	add_taint(TAINT_DIE);
 	dik_show_trace((unsigned long *)(regs+1));
 	dik_show_code((unsigned int *)regs->pc);
 
diff -puN arch/arm/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/arm/kernel/traps.c
--- a/arch/arm/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/arm/kernel/traps.c
@@ -249,6 +249,7 @@ NORET_TYPE void die(const char *str, str
 	bust_spinlocks(1);
 	__die(str, err, thread, regs);
 	bust_spinlocks(0);
+	add_taint(TAINT_DIE);
 	spin_unlock_irq(&die_lock);
 
 	if (in_interrupt())
diff -puN arch/arm26/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/arm26/kernel/traps.c
--- a/arch/arm26/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/arm26/kernel/traps.c
@@ -185,6 +185,7 @@ NORET_TYPE void die(const char *str, str
 	printk("Internal error: %s: %x\n", str, err);
 	printk("CPU: %d\n", smp_processor_id());
 	show_regs(regs);
+	add_taint(TAINT_DIE);
 	printk("Process %s (pid: %d, stack limit = 0x%p)\n",
 		current->comm, current->pid, end_of_stack(tsk));
 
diff -puN arch/avr32/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/avr32/kernel/traps.c
--- a/arch/avr32/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/avr32/kernel/traps.c
@@ -56,6 +56,7 @@ void NORET_TYPE die(const char *str, str
 	show_regs_log_lvl(regs, KERN_EMERG);
 	show_stack_log_lvl(current, regs->sp, regs, KERN_EMERG);
 	bust_spinlocks(0);
+	add_taint(TAINT_DIE);
 	spin_unlock_irq(&die_lock);
 
 	if (in_interrupt())
diff -puN arch/i386/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/i386/kernel/traps.c
@@ -433,6 +433,7 @@ void die(const char * str, struct pt_reg
 
 	bust_spinlocks(0);
 	die.lock_owner = -1;
+	add_taint(TAINT_DIE);
 	spin_unlock_irqrestore(&die.lock, flags);
 
 	if (!regs)
diff -puN arch/ia64/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/ia64/kernel/traps.c
--- a/arch/ia64/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/ia64/kernel/traps.c
@@ -69,6 +69,7 @@ die (const char *str, struct pt_regs *re
 
 	bust_spinlocks(0);
 	die.lock_owner = -1;
+	add_taint(TAINT_DIE);
 	spin_unlock_irq(&die.lock);
 
 	if (panic_on_oops)
diff -puN arch/m68k/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/m68k/kernel/traps.c
--- a/arch/m68k/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/m68k/kernel/traps.c
@@ -1170,6 +1170,7 @@ void die_if_kernel (char *str, struct pt
 	console_verbose();
 	printk("%s: %08x\n",str,nr);
 	show_registers(fp);
+	add_taint(TAINT_DIE);
 	do_exit(SIGSEGV);
 }
 
diff -puN arch/m68knommu/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/m68knommu/kernel/traps.c
--- a/arch/m68knommu/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/m68knommu/kernel/traps.c
@@ -83,6 +83,7 @@ void die_if_kernel(char *str, struct pt_
 	printk(KERN_EMERG "Process %s (pid: %d, stackpage=%08lx)\n",
 		current->comm, current->pid, PAGE_SIZE+(unsigned long)current);
 	show_stack(NULL, (unsigned long *)fp);
+	add_taint(TAINT_DIE);
 	do_exit(SIGSEGV);
 }
 
diff -puN arch/mips/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/mips/kernel/traps.c
@@ -326,6 +326,7 @@ void __noreturn die(const char * str, st
 #endif /* CONFIG_MIPS_MT_SMTC */
 	printk("%s[#%d]:\n", str, ++die_counter);
 	show_registers(regs);
+	add_taint(TAINT_DIE);
 	spin_unlock_irq(&die_lock);
 
 	if (in_interrupt())
diff -puN arch/powerpc/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/powerpc/kernel/traps.c
--- a/arch/powerpc/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/powerpc/kernel/traps.c
@@ -149,6 +149,7 @@ int die(const char *str, struct pt_regs 
 
 	bust_spinlocks(0);
 	die.lock_owner = -1;
+	add_taint(TAINT_DIE);
 	spin_unlock_irqrestore(&die.lock, flags);
 
 	if (kexec_should_crash(current) ||
diff -puN arch/ppc/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/ppc/kernel/traps.c
--- a/arch/ppc/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/ppc/kernel/traps.c
@@ -92,6 +92,7 @@ int die(const char * str, struct pt_regs
 	if (nl)
 		printk("\n");
 	show_regs(fp);
+	add_taint(TAINT_DIE);
 	spin_unlock_irq(&die_lock);
 	/* do_exit() should take care of panic'ing from an interrupt
 	 * context so we don't handle it here
diff -puN arch/s390/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/s390/kernel/traps.c
--- a/arch/s390/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/s390/kernel/traps.c
@@ -262,6 +262,7 @@ void die(const char * str, struct pt_reg
 	print_modules();
 	show_regs(regs);
 	bust_spinlocks(0);
+	add_taint(TAINT_DIE);
 	spin_unlock_irq(&die_lock);
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
diff -puN arch/sh/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/sh/kernel/traps.c
--- a/arch/sh/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/sh/kernel/traps.c
@@ -103,6 +103,7 @@ void die(const char * str, struct pt_reg
 			 (unsigned long)task_stack_page(current));
 
 	bust_spinlocks(0);
+	add_taint(TAINT_DIE);
 	spin_unlock_irq(&die_lock);
 
 	if (kexec_should_crash(current))
diff -puN arch/sparc/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/sparc/kernel/traps.c
--- a/arch/sparc/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/sparc/kernel/traps.c
@@ -101,6 +101,7 @@ void die_if_kernel(char *str, struct pt_
 
 	printk("%s(%d): %s [#%d]\n", current->comm, current->pid, str, ++die_counter);
 	show_regs(regs);
+	add_taint(TAINT_DIE);
 
 	__SAVE; __SAVE; __SAVE; __SAVE;
 	__SAVE; __SAVE; __SAVE; __SAVE;
diff -puN arch/sparc64/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/sparc64/kernel/traps.c
--- a/arch/sparc64/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/sparc64/kernel/traps.c
@@ -2225,6 +2225,7 @@ void die_if_kernel(char *str, struct pt_
 	notify_die(DIE_OOPS, str, regs, 0, 255, SIGSEGV);
 	__asm__ __volatile__("flushw");
 	__show_regs(regs);
+	add_taint(TAINT_DIE);
 	if (regs->tstate & TSTATE_PRIV) {
 		struct reg_window *rw = (struct reg_window *)
 			(regs->u_regs[UREG_FP] + STACK_BIAS);
diff -puN arch/x86_64/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/x86_64/kernel/traps.c
@@ -518,6 +518,7 @@ void __kprobes __die(const char * str, s
 	printk("\n");
 	notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV);
 	show_registers(regs);
+	add_taint(TAINT_DIE);
 	/* Executive summary in case the oops scrolled away */
 	printk(KERN_ALERT "RIP ");
 	printk_address(regs->rip); 
diff -puN arch/xtensa/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before arch/xtensa/kernel/traps.c
--- a/arch/xtensa/kernel/traps.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/arch/xtensa/kernel/traps.c
@@ -482,6 +482,7 @@ void die(const char * str, struct pt_reg
 	if (!user_mode(regs))
 		show_stack(NULL, (unsigned long*)regs->areg[1]);
 
+	add_taint(TAINT_DIE);
 	spin_unlock_irq(&die_lock);
 
 	if (in_interrupt())
diff -puN include/linux/kernel.h~report-that-kernel-is-tainted-if-there-were-an-oops-before include/linux/kernel.h
--- a/include/linux/kernel.h~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/include/linux/kernel.h
@@ -210,6 +210,7 @@ extern enum system_states {
 #define TAINT_MACHINE_CHECK		(1<<4)
 #define TAINT_BAD_PAGE			(1<<5)
 #define TAINT_USER			(1<<6)
+#define TAINT_DIE			(1<<7)
 
 extern void dump_stack(void);
 
diff -puN kernel/panic.c~report-that-kernel-is-tainted-if-there-were-an-oops-before kernel/panic.c
--- a/kernel/panic.c~report-that-kernel-is-tainted-if-there-were-an-oops-before
+++ a/kernel/panic.c
@@ -159,14 +159,15 @@ const char *print_tainted(void)
 {
 	static char buf[20];
 	if (tainted) {
-		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c",
+		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c",
 			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
 			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
 			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
 			tainted & TAINT_FORCED_RMMOD ? 'R' : ' ',
  			tainted & TAINT_MACHINE_CHECK ? 'M' : ' ',
 			tainted & TAINT_BAD_PAGE ? 'B' : ' ',
-			tainted & TAINT_USER ? 'U' : ' ');
+			tainted & TAINT_USER ? 'U' : ' ',
+			tainted & TAINT_DIE ? 'D' : ' ');
 	}
 	else
 		snprintf(buf, sizeof(buf), "Not tainted");
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
make-input-layer-use-seq_list_xxx-helpers.patch
fix-user-struct-leakage-with-locked-ipc-shem-segment.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch

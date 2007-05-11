From: akpm@linux-foundation.org
Subject: - separate-freezer-from-pm-code-rev-2.patch removed from -mm tree
Date: Fri, 11 May 2007 12:29:24 -0700
Message-ID: <200705111929.l4BJTO0L024594@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759893AbXEKTac (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:30:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ego@in.ibm.com, oleg@tv-sign.ru, pavel@ucw.cz, penberg@cs.helsinki.fi, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Separate freezer from PM code
has been removed from the -mm tree.  Its filename was
     separate-freezer-from-pm-code-rev-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Separate freezer from PM code
From: Rafael J. Wysocki <rjw@sisk.pl>

Now that the freezer is used by kprobes, it is no longer a PM-specific
piece of code.  Move the freezer code out of kernel/power and introduce the
CONFIG_FREEZER option that will be chosen automatically if PM or KPROBES is
set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig         |    2 
 arch/avr32/Kconfig       |    2 
 arch/avr32/Kconfig.debug |    1 
 arch/blackfin/Kconfig    |    2 
 arch/frv/Kconfig         |    2 
 arch/i386/Kconfig        |    3 
 arch/ia64/Kconfig        |    3 
 arch/mips/Kconfig        |    2 
 arch/powerpc/Kconfig     |    3 
 arch/ppc/Kconfig         |    2 
 arch/s390/Kconfig        |    3 
 arch/sh/Kconfig          |    2 
 arch/sparc64/Kconfig     |    3 
 arch/x86_64/Kconfig      |    3 
 include/linux/freezer.h  |    2 
 kernel/Kconfig.freezer   |    5 
 kernel/Makefile          |    1 
 kernel/freezer.c         |  236 +++++++++++++++++++++++++++++++++++++
 kernel/kprobes.c         |    2 
 kernel/power/Kconfig     |    1 
 kernel/power/Makefile    |    2 
 kernel/power/process.c   |  236 -------------------------------------
 22 files changed, 279 insertions(+), 239 deletions(-)

diff -puN arch/arm/Kconfig~separate-freezer-from-pm-code-rev-2 arch/arm/Kconfig
--- a/arch/arm/Kconfig~separate-freezer-from-pm-code-rev-2
+++ a/arch/arm/Kconfig
@@ -931,6 +931,8 @@ config ARTHUR
 
 endmenu
 
+source "kernel/Kconfig.freezer"
+
 menu "Power management options"
 
 source "kernel/power/Kconfig"
diff -puN arch/avr32/Kconfig~separate-freezer-from-pm-code-rev-2 arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~separate-freezer-from-pm-code-rev-2
+++ a/arch/avr32/Kconfig
@@ -206,6 +206,8 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 source "arch/avr32/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/avr32/Kconfig.debug~separate-freezer-from-pm-code-rev-2 arch/avr32/Kconfig.debug
--- a/arch/avr32/Kconfig.debug~separate-freezer-from-pm-code-rev-2
+++ a/arch/avr32/Kconfig.debug
@@ -9,6 +9,7 @@ source "lib/Kconfig.debug"
 config KPROBES
 	bool "Kprobes"
 	depends on DEBUG_KERNEL
+	select FREEZER
 	help
 	  Kprobes allows you to trap at almost any kernel address and
           execute a callback function.  register_kprobe() establishes
diff -puN arch/blackfin/Kconfig~separate-freezer-from-pm-code-rev-2 arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~separate-freezer-from-pm-code-rev-2
+++ a/arch/blackfin/Kconfig
@@ -816,6 +816,8 @@ source "fs/Kconfig.binfmt"
 
 endmenu
 
+source "kernel/Kconfig.freezer"
+
 menu "Power management options"
 source "kernel/power/Kconfig"
 
diff -puN arch/frv/Kconfig~separate-freezer-from-pm-code-rev-2 arch/frv/Kconfig
--- a/arch/frv/Kconfig~separate-freezer-from-pm-code-rev-2
+++ a/arch/frv/Kconfig
@@ -364,6 +364,8 @@ source "drivers/pcmcia/Kconfig"
 #	  sleep-deprived psychotic hacker types can say Y now, everyone else
 #	  should probably wait a while.
 
+source "kernel/Kconfig.freezer"
+
 menu "Power management options"
 source kernel/power/Kconfig
 endmenu
diff -puN arch/i386/Kconfig~separate-freezer-from-pm-code-rev-2 arch/i386/Kconfig
--- a/arch/i386/Kconfig~separate-freezer-from-pm-code-rev-2
+++ a/arch/i386/Kconfig
@@ -916,6 +916,8 @@ config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
 	depends on HIGHMEM
 
+source "kernel/Kconfig.freezer"
+
 menu "Power management options (ACPI, APM)"
 	depends on !X86_VOYAGER
 
@@ -1220,6 +1222,7 @@ source "arch/i386/oprofile/Kconfig"
 config KPROBES
 	bool "Kprobes (EXPERIMENTAL)"
 	depends on KALLSYMS && EXPERIMENTAL && MODULES
+	select FREEZER
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
diff -puN arch/ia64/Kconfig~separate-freezer-from-pm-code-rev-2 arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~separate-freezer-from-pm-code-rev-2
+++ a/arch/ia64/Kconfig
@@ -495,6 +495,8 @@ source "fs/Kconfig.binfmt"
 
 endmenu
 
+source "kernel/Kconfig.freezer"
+
 menu "Power management and ACPI"
 
 source "kernel/power/Kconfig"
@@ -582,6 +584,7 @@ source "arch/ia64/oprofile/Kconfig"
 config KPROBES
 	bool "Kprobes (EXPERIMENTAL)"
 	depends on KALLSYMS && EXPERIMENTAL && MODULES
+	select FREEZER
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
diff -puN arch/mips/Kconfig~separate-freezer-from-pm-code-rev-2 arch/mips/Kconfig
--- a/arch/mips/Kconfig~separate-freezer-from-pm-code-rev-2
+++ a/arch/mips/Kconfig
@@ -2063,6 +2063,8 @@ source "drivers/pci/hotplug/Kconfig"
 
 endmenu
 
+source "kernel/Kconfig.freezer"
+
 menu "Executable file formats"
 
 source "fs/Kconfig.binfmt"
diff -puN arch/powerpc/Kconfig~separate-freezer-from-pm-code-rev-2 arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~separate-freezer-from-pm-code-rev-2
+++ a/arch/powerpc/Kconfig
@@ -578,6 +578,8 @@ config CMDLINE
 	  some command-line options at build time by entering them here.  In
 	  most cases you will need to specify the root device here.
 
+source kernel/Kconfig.freezer
+
 if !44x || BROKEN
 source kernel/power/Kconfig
 endif
@@ -892,6 +894,7 @@ source "arch/powerpc/oprofile/Kconfig"
 config KPROBES
 	bool "Kprobes (EXPERIMENTAL)"
 	depends on !BOOKE && !4xx && KALLSYMS && EXPERIMENTAL && MODULES
+	select FREEZER
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
diff -puN arch/ppc/Kconfig~separate-freezer-from-pm-code-rev-2 arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~separate-freezer-from-pm-code-rev-2
+++ a/arch/ppc/Kconfig
@@ -1153,6 +1153,8 @@ config PROC_HARDWARE
 
 source "drivers/zorro/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 if !44x || BROKEN
 source kernel/power/Kconfig
 endif
diff -puN arch/s390/Kconfig~separate-freezer-from-pm-code-rev-2 arch/s390/Kconfig
--- a/arch/s390/Kconfig~separate-freezer-from-pm-code-rev-2
+++ a/arch/s390/Kconfig
@@ -533,6 +533,8 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "Instrumentation Support"
 
 source "arch/s390/oprofile/Kconfig"
@@ -540,6 +542,7 @@ source "arch/s390/oprofile/Kconfig"
 config KPROBES
 	bool "Kprobes (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && MODULES
+	select FREEZER
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.	register_kprobe() establishes
diff -puN arch/sh/Kconfig~separate-freezer-from-pm-code-rev-2 arch/sh/Kconfig
--- a/arch/sh/Kconfig~separate-freezer-from-pm-code-rev-2
+++ a/arch/sh/Kconfig
@@ -706,6 +706,8 @@ source "fs/Kconfig.binfmt"
 
 endmenu
 
+source "kernel/Kconfig.freezer"
+
 menu "Power management options (EXPERIMENTAL)"
 depends on EXPERIMENTAL
 
diff -puN arch/sparc64/Kconfig~separate-freezer-from-pm-code-rev-2 arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~separate-freezer-from-pm-code-rev-2
+++ a/arch/sparc64/Kconfig
@@ -427,6 +427,8 @@ source "drivers/fc4/Kconfig"
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 menu "Instrumentation Support"
         depends on EXPERIMENTAL
 
@@ -435,6 +437,7 @@ source "arch/sparc64/oprofile/Kconfig"
 config KPROBES
 	bool "Kprobes (EXPERIMENTAL)"
 	depends on KALLSYMS && EXPERIMENTAL && MODULES
+	select FREEZER
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
diff -puN arch/x86_64/Kconfig~separate-freezer-from-pm-code-rev-2 arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~separate-freezer-from-pm-code-rev-2
+++ a/arch/x86_64/Kconfig
@@ -695,6 +695,8 @@ config GENERIC_PENDING_IRQ
 	depends on GENERIC_HARDIRQS && SMP
 	default y
 
+source "kernel/Kconfig.freezer"
+
 menu "Power management options"
 
 source kernel/power/Kconfig
@@ -781,6 +783,7 @@ source "arch/x86_64/oprofile/Kconfig"
 config KPROBES
 	bool "Kprobes (EXPERIMENTAL)"
 	depends on KALLSYMS && EXPERIMENTAL && MODULES
+	select FREEZER
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
diff -puN include/linux/freezer.h~separate-freezer-from-pm-code-rev-2 include/linux/freezer.h
--- a/include/linux/freezer.h~separate-freezer-from-pm-code-rev-2
+++ a/include/linux/freezer.h
@@ -2,7 +2,7 @@
 
 #include <linux/sched.h>
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_FREEZER
 /*
  * Check if a process has been frozen
  */
diff -puN /dev/null kernel/Kconfig.freezer
--- /dev/null
+++ a/kernel/Kconfig.freezer
@@ -0,0 +1,5 @@
+# Tasks freezer configuration
+
+config FREEZER
+	bool
+	default n
diff -puN kernel/Makefile~separate-freezer-from-pm-code-rev-2 kernel/Makefile
--- a/kernel/Makefile~separate-freezer-from-pm-code-rev-2
+++ a/kernel/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_STACK_UNWIND) += unwind.o
 obj-$(CONFIG_PM) += power/
+obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_COMPAT) += compat.o
diff -puN /dev/null kernel/freezer.c
--- /dev/null
+++ a/kernel/freezer.c
@@ -0,0 +1,236 @@
+/*
+ * linux/kernel/freezer.c
+ *
+ * Generic mechanism for freezing and thawing tasks, originally from swsusp.
+ *
+ * Distributed under the GPLv2
+ */
+
+
+#undef DEBUG
+
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/syscalls.h>
+#include <linux/freezer.h>
+
+/*
+ * Timeout for stopping processes
+ */
+#define TIMEOUT	(20 * HZ)
+
+#define FREEZER_KERNEL_THREADS 0
+#define FREEZER_USER_SPACE 1
+
+static inline int freezeable(struct task_struct * p)
+{
+	if ((p == current) ||
+	    (p->flags & PF_NOFREEZE) ||
+	    (p->exit_state != 0))
+		return 0;
+	return 1;
+}
+
+/*
+ * freezing is complete, mark current process as frozen
+ */
+static inline void frozen_process(void)
+{
+	if (!unlikely(current->flags & PF_NOFREEZE)) {
+		current->flags |= PF_FROZEN;
+		wmb();
+	}
+	clear_tsk_thread_flag(current, TIF_FREEZE);
+}
+
+/* Refrigerator is place where frozen processes are stored :-). */
+void refrigerator(void)
+{
+	/* Hmm, should we be allowed to suspend when there are realtime
+	   processes around? */
+	long save;
+
+	task_lock(current);
+	if (freezing(current)) {
+		frozen_process();
+		task_unlock(current);
+	} else {
+		task_unlock(current);
+		return;
+	}
+	save = current->state;
+	pr_debug("%s entered refrigerator\n", current->comm);
+
+	spin_lock_irq(&current->sighand->siglock);
+	recalc_sigpending(); /* We sent fake signal, clean it up */
+	spin_unlock_irq(&current->sighand->siglock);
+
+	for (;;) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (!frozen(current))
+			break;
+		schedule();
+	}
+	pr_debug("%s left refrigerator\n", current->comm);
+	current->state = save;
+}
+
+static inline void freeze_process(struct task_struct *p)
+{
+	unsigned long flags;
+
+	if (!freezing(p)) {
+		rmb();
+		if (!frozen(p)) {
+			if (p->state == TASK_STOPPED)
+				force_sig_specific(SIGSTOP, p);
+
+			freeze(p);
+			spin_lock_irqsave(&p->sighand->siglock, flags);
+			signal_wake_up(p, p->state == TASK_STOPPED);
+			spin_unlock_irqrestore(&p->sighand->siglock, flags);
+		}
+	}
+}
+
+static void cancel_freezing(struct task_struct *p)
+{
+	unsigned long flags;
+
+	if (freezing(p)) {
+		pr_debug("  clean up: %s\n", p->comm);
+		do_not_freeze(p);
+		spin_lock_irqsave(&p->sighand->siglock, flags);
+		recalc_sigpending_tsk(p);
+		spin_unlock_irqrestore(&p->sighand->siglock, flags);
+	}
+}
+
+static inline int is_user_space(struct task_struct *p)
+{
+	int ret;
+
+	task_lock(p);
+	ret = p->mm && !(p->flags & PF_BORROWED_MM);
+	task_unlock(p);
+	return ret;
+}
+
+static unsigned int try_to_freeze_tasks(int freeze_user_space)
+{
+	struct task_struct *g, *p;
+	unsigned long end_time;
+	unsigned int todo;
+
+	end_time = jiffies + TIMEOUT;
+	do {
+		todo = 0;
+		read_lock(&tasklist_lock);
+		do_each_thread(g, p) {
+			if (!freezeable(p))
+				continue;
+
+			if (frozen(p))
+				continue;
+
+			if (p->state == TASK_TRACED && frozen(p->parent)) {
+				cancel_freezing(p);
+				continue;
+			}
+			if (freeze_user_space && !is_user_space(p))
+				continue;
+
+			freeze_process(p);
+			if (!freezer_should_skip(p))
+				todo++;
+		} while_each_thread(g, p);
+		read_unlock(&tasklist_lock);
+		yield();			/* Yield is okay here */
+		if (todo && time_after(jiffies, end_time))
+			break;
+	} while (todo);
+
+	if (todo) {
+		/* This does not unfreeze processes that are already frozen
+		 * (we have slightly ugly calling convention in that respect,
+		 * and caller must call thaw_processes() if something fails),
+		 * but it cleans up leftover PF_FREEZE requests.
+		 */
+		printk("\n");
+		printk(KERN_ERR "Stopping %s timed out after %d seconds "
+				"(%d tasks refusing to freeze):\n",
+				freeze_user_space ? "user space processes" :
+					"kernel threads",
+				TIMEOUT / HZ, todo);
+		read_lock(&tasklist_lock);
+		do_each_thread(g, p) {
+			if (freeze_user_space && !is_user_space(p))
+				continue;
+
+			task_lock(p);
+			if (freezeable(p) && !frozen(p) &&
+			    !freezer_should_skip(p))
+				printk(KERN_ERR " %s\n", p->comm);
+
+			cancel_freezing(p);
+			task_unlock(p);
+		} while_each_thread(g, p);
+		read_unlock(&tasklist_lock);
+	}
+
+	return todo;
+}
+
+/**
+ *	freeze_processes - tell processes to enter the refrigerator
+ *
+ *	Returns 0 on success, or the number of processes that didn't freeze,
+ *	although they were told to.
+ */
+int freeze_processes(void)
+{
+	unsigned int nr_unfrozen;
+
+	printk("Stopping tasks ... ");
+	nr_unfrozen = try_to_freeze_tasks(FREEZER_USER_SPACE);
+	if (nr_unfrozen)
+		return nr_unfrozen;
+
+	sys_sync();
+	nr_unfrozen = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
+	if (nr_unfrozen)
+		return nr_unfrozen;
+
+	printk("done.\n");
+	BUG_ON(in_atomic());
+	return 0;
+}
+
+static void thaw_tasks(int thaw_user_space)
+{
+	struct task_struct *g, *p;
+
+	read_lock(&tasklist_lock);
+	do_each_thread(g, p) {
+		if (!freezeable(p))
+			continue;
+
+		if (is_user_space(p) == !thaw_user_space)
+			continue;
+
+		thaw_process(p);
+	} while_each_thread(g, p);
+	read_unlock(&tasklist_lock);
+}
+
+void thaw_processes(void)
+{
+	printk("Restarting tasks ... ");
+	thaw_tasks(FREEZER_KERNEL_THREADS);
+	thaw_tasks(FREEZER_USER_SPACE);
+	schedule();
+	printk("done.\n");
+}
+
+EXPORT_SYMBOL(refrigerator);
diff -puN kernel/kprobes.c~separate-freezer-from-pm-code-rev-2 kernel/kprobes.c
--- a/kernel/kprobes.c~separate-freezer-from-pm-code-rev-2
+++ a/kernel/kprobes.c
@@ -108,7 +108,7 @@ static int collect_garbage_slots(void);
 static int __kprobes check_safety(void)
 {
 	int ret = 0;
-#if defined(CONFIG_PREEMPT) && defined(CONFIG_PM)
+#ifdef CONFIG_PREEMPT
 	ret = freeze_processes();
 	if (ret == 0) {
 		struct task_struct *p, *q;
diff -puN kernel/power/Kconfig~separate-freezer-from-pm-code-rev-2 kernel/power/Kconfig
--- a/kernel/power/Kconfig~separate-freezer-from-pm-code-rev-2
+++ a/kernel/power/Kconfig
@@ -1,6 +1,7 @@
 config PM
 	bool "Power Management support"
 	depends on !IA64_HP_SIM
+	select FREEZER
 	---help---
 	  "Power Management" means that parts of your computer are shut
 	  off or put into a power conserving "sleep" mode if they are not
diff -puN kernel/power/Makefile~separate-freezer-from-pm-code-rev-2 kernel/power/Makefile
--- a/kernel/power/Makefile~separate-freezer-from-pm-code-rev-2
+++ a/kernel/power/Makefile
@@ -3,7 +3,7 @@ ifeq ($(CONFIG_PM_DEBUG),y)
 EXTRA_CFLAGS	+=	-DDEBUG
 endif
 
-obj-y				:= main.o process.o console.o
+obj-y				:= main.o console.o
 obj-$(CONFIG_PM_LEGACY)		+= pm.o
 obj-$(CONFIG_SOFTWARE_SUSPEND)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
diff -puN kernel/power/process.c~separate-freezer-from-pm-code-rev-2 /dev/null
--- a/kernel/power/process.c
+++ /dev/null
@@ -1,236 +0,0 @@
-/*
- * drivers/power/process.c - Functions for starting/stopping processes on 
- *                           suspend transitions.
- *
- * Originally from swsusp.
- */
-
-
-#undef DEBUG
-
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/suspend.h>
-#include <linux/module.h>
-#include <linux/syscalls.h>
-#include <linux/freezer.h>
-
-/* 
- * Timeout for stopping processes
- */
-#define TIMEOUT	(20 * HZ)
-
-#define FREEZER_KERNEL_THREADS 0
-#define FREEZER_USER_SPACE 1
-
-static inline int freezeable(struct task_struct * p)
-{
-	if ((p == current) ||
-	    (p->flags & PF_NOFREEZE) ||
-	    (p->exit_state != 0))
-		return 0;
-	return 1;
-}
-
-/*
- * freezing is complete, mark current process as frozen
- */
-static inline void frozen_process(void)
-{
-	if (!unlikely(current->flags & PF_NOFREEZE)) {
-		current->flags |= PF_FROZEN;
-		wmb();
-	}
-	clear_tsk_thread_flag(current, TIF_FREEZE);
-}
-
-/* Refrigerator is place where frozen processes are stored :-). */
-void refrigerator(void)
-{
-	/* Hmm, should we be allowed to suspend when there are realtime
-	   processes around? */
-	long save;
-
-	task_lock(current);
-	if (freezing(current)) {
-		frozen_process();
-		task_unlock(current);
-	} else {
-		task_unlock(current);
-		return;
-	}
-	save = current->state;
-	pr_debug("%s entered refrigerator\n", current->comm);
-
-	spin_lock_irq(&current->sighand->siglock);
-	recalc_sigpending(); /* We sent fake signal, clean it up */
-	spin_unlock_irq(&current->sighand->siglock);
-
-	for (;;) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (!frozen(current))
-			break;
-		schedule();
-	}
-	pr_debug("%s left refrigerator\n", current->comm);
-	current->state = save;
-}
-
-static inline void freeze_process(struct task_struct *p)
-{
-	unsigned long flags;
-
-	if (!freezing(p)) {
-		rmb();
-		if (!frozen(p)) {
-			if (p->state == TASK_STOPPED)
-				force_sig_specific(SIGSTOP, p);
-
-			freeze(p);
-			spin_lock_irqsave(&p->sighand->siglock, flags);
-			signal_wake_up(p, p->state == TASK_STOPPED);
-			spin_unlock_irqrestore(&p->sighand->siglock, flags);
-		}
-	}
-}
-
-static void cancel_freezing(struct task_struct *p)
-{
-	unsigned long flags;
-
-	if (freezing(p)) {
-		pr_debug("  clean up: %s\n", p->comm);
-		do_not_freeze(p);
-		spin_lock_irqsave(&p->sighand->siglock, flags);
-		recalc_sigpending_tsk(p);
-		spin_unlock_irqrestore(&p->sighand->siglock, flags);
-	}
-}
-
-static inline int is_user_space(struct task_struct *p)
-{
-	int ret;
-
-	task_lock(p);
-	ret = p->mm && !(p->flags & PF_BORROWED_MM);
-	task_unlock(p);
-	return ret;
-}
-
-static unsigned int try_to_freeze_tasks(int freeze_user_space)
-{
-	struct task_struct *g, *p;
-	unsigned long end_time;
-	unsigned int todo;
-
-	end_time = jiffies + TIMEOUT;
-	do {
-		todo = 0;
-		read_lock(&tasklist_lock);
-		do_each_thread(g, p) {
-			if (!freezeable(p))
-				continue;
-
-			if (frozen(p))
-				continue;
-
-			if (p->state == TASK_TRACED && frozen(p->parent)) {
-				cancel_freezing(p);
-				continue;
-			}
-			if (freeze_user_space && !is_user_space(p))
-				continue;
-
-			freeze_process(p);
-			if (!freezer_should_skip(p))
-				todo++;
-		} while_each_thread(g, p);
-		read_unlock(&tasklist_lock);
-		yield();			/* Yield is okay here */
-		if (todo && time_after(jiffies, end_time))
-			break;
-	} while (todo);
-
-	if (todo) {
-		/* This does not unfreeze processes that are already frozen
-		 * (we have slightly ugly calling convention in that respect,
-		 * and caller must call thaw_processes() if something fails),
-		 * but it cleans up leftover PF_FREEZE requests.
-		 */
-		printk("\n");
-		printk(KERN_ERR "Stopping %s timed out after %d seconds "
-				"(%d tasks refusing to freeze):\n",
-				freeze_user_space ? "user space processes" :
-					"kernel threads",
-				TIMEOUT / HZ, todo);
-		read_lock(&tasklist_lock);
-		do_each_thread(g, p) {
-			if (freeze_user_space && !is_user_space(p))
-				continue;
-
-			task_lock(p);
-			if (freezeable(p) && !frozen(p) &&
-			    !freezer_should_skip(p))
-				printk(KERN_ERR " %s\n", p->comm);
-
-			cancel_freezing(p);
-			task_unlock(p);
-		} while_each_thread(g, p);
-		read_unlock(&tasklist_lock);
-	}
-
-	return todo;
-}
-
-/**
- *	freeze_processes - tell processes to enter the refrigerator
- *
- *	Returns 0 on success, or the number of processes that didn't freeze,
- *	although they were told to.
- */
-int freeze_processes(void)
-{
-	unsigned int nr_unfrozen;
-
-	printk("Stopping tasks ... ");
-	nr_unfrozen = try_to_freeze_tasks(FREEZER_USER_SPACE);
-	if (nr_unfrozen)
-		return nr_unfrozen;
-
-	sys_sync();
-	nr_unfrozen = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
-	if (nr_unfrozen)
-		return nr_unfrozen;
-
-	printk("done.\n");
-	BUG_ON(in_atomic());
-	return 0;
-}
-
-static void thaw_tasks(int thaw_user_space)
-{
-	struct task_struct *g, *p;
-
-	read_lock(&tasklist_lock);
-	do_each_thread(g, p) {
-		if (!freezeable(p))
-			continue;
-
-		if (is_user_space(p) == !thaw_user_space)
-			continue;
-
-		thaw_process(p);
-	} while_each_thread(g, p);
-	read_unlock(&tasklist_lock);
-}
-
-void thaw_processes(void)
-{
-	printk("Restarting tasks ... ");
-	thaw_tasks(FREEZER_KERNEL_THREADS);
-	thaw_tasks(FREEZER_USER_SPACE);
-	schedule();
-	printk("done.\n");
-}
-
-EXPORT_SYMBOL(refrigerator);
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
add-common-orderly_poweroff.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch

From: akpm@linux-foundation.org
Subject: + watchdog-split-up-config-options.patch added to -mm tree
Date: Fri, 16 Jun 2017 11:24:55 -0700
Message-ID: <59442277.IomWi6XGOm63W5Fw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59348 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753285AbdFPSY5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 14:24:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@gmail.com, babu.moger@oracle.com, benh@kernel.crashing.org, dzickus@redhat.com, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog: split up config options
has been added to the -mm tree.  Its filename is
     watchdog-split-up-config-options.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-split-up-config-options.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-split-up-config-options.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: kernel/watchdog: split up config options

Split SOFTLOCKUP_DETECTOR from LOCKUP_DETECTOR, and split
HARDLOCKUP_DETECTOR_PERF from HARDLOCKUP_DETECTOR.

LOCKUP_DETECTOR implies the general boot, sysctl, and programming
interfaces for the lockup detectors.

An architecture that wants to use a hard lockup detector must define
HAVE_HARDLOCKUP_DETECTOR_PERF or HAVE_HARDLOCKUP_DETECTOR_ARCH.

Alternatively an arch can define HAVE_NMI_WATCHDOG, which provides the
minimum arch_touch_nmi_watchdog, and it otherwise does its own thing and
does not implement the LOCKUP_DETECTOR interfaces.

sparc is unusual in that it has started to implement some of the
interfaces, but not fully yet.  It should probably be converted to a full
HAVE_HARDLOCKUP_DETECTOR_ARCH.

Link: http://lkml.kernel.org/r/20170616065715.18390-4-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Don Zickus <dzickus@redhat.com>
Reviewed-by: Babu Moger <babu.moger@oracle.com>
Tested-by: Babu Moger <babu.moger@oracle.com>	[sparc]
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                   |   23 ++
 arch/powerpc/Kconfig           |    1 
 arch/powerpc/kernel/setup_64.c |    2 
 arch/x86/Kconfig               |    1 
 arch/x86/kernel/apic/hw_nmi.c  |    2 
 include/linux/nmi.h            |   29 ++-
 kernel/Makefile                |    2 
 kernel/sysctl.c                |   31 ++-
 kernel/watchdog.c              |  243 ++++++++++++++++++++-----------
 kernel/watchdog_hld.c          |   32 ----
 lib/Kconfig.debug              |   45 +++--
 11 files changed, 252 insertions(+), 159 deletions(-)

diff -puN arch/Kconfig~watchdog-split-up-config-options arch/Kconfig
--- a/arch/Kconfig~watchdog-split-up-config-options
+++ a/arch/Kconfig
@@ -288,6 +288,29 @@ config HAVE_PERF_EVENTS_NMI
 	  subsystem.  Also has support for calculating CPU cycle events
 	  to determine how many clock cycles in a given period.
 
+
+config HAVE_HARDLOCKUP_DETECTOR_PERF
+	bool
+	depends on HAVE_PERF_EVENTS_NMI
+	help
+	  The arch chooses to use the generic perf-NMI-based hardlockup
+	  detector. Must define HAVE_PERF_EVENTS_NMI.
+
+config HAVE_NMI_WATCHDOG
+	bool
+	help
+	  The arch provides a low level NMI watchdog. It provides
+	  asm/nmi.h, and defines its own arch_touch_nmi_watchdog().
+
+config HAVE_HARDLOCKUP_DETECTOR_ARCH
+	bool
+	select HAVE_NMI_WATCHDOG
+	help
+	  The arch chooses to provide its own hardlockup detector, which is
+	  a superset of the HAVE_NMI_WATCHDOG. It also conforms to config
+	  interfaces and parameters provided by hardlockup detector subsystem.
+
+
 config HAVE_PERF_REGS
 	bool
 	help
diff -puN arch/powerpc/Kconfig~watchdog-split-up-config-options arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~watchdog-split-up-config-options
+++ a/arch/powerpc/Kconfig
@@ -202,6 +202,7 @@ config PPC
 	select HAVE_OPTPROBES			if PPC64
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI		if PPC64
+	select HAVE_HARDLOCKUP_DETECTOR_PERF	if HAVE_PERF_EVENTS_NMI
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_RCU_TABLE_FREE		if SMP
diff -puN arch/powerpc/kernel/setup_64.c~watchdog-split-up-config-options arch/powerpc/kernel/setup_64.c
--- a/arch/powerpc/kernel/setup_64.c~watchdog-split-up-config-options
+++ a/arch/powerpc/kernel/setup_64.c
@@ -727,7 +727,7 @@ struct ppc_pci_io ppc_pci_io;
 EXPORT_SYMBOL(ppc_pci_io);
 #endif
 
-#ifdef CONFIG_HARDLOCKUP_DETECTOR
+#ifdef CONFIG_HARDLOCKUP_DETECTOR_PERF
 u64 hw_nmi_get_sample_period(int watchdog_thresh)
 {
 	return ppc_proc_freq * watchdog_thresh;
diff -puN arch/x86/Kconfig~watchdog-split-up-config-options arch/x86/Kconfig
--- a/arch/x86/Kconfig~watchdog-split-up-config-options
+++ a/arch/x86/Kconfig
@@ -157,6 +157,7 @@ config X86
 	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI
+	select HAVE_HARDLOCKUP_DETECTOR_PERF	if HAVE_PERF_EVENTS_NMI
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_REGS_AND_STACK_ACCESS_API
diff -puN arch/x86/kernel/apic/hw_nmi.c~watchdog-split-up-config-options arch/x86/kernel/apic/hw_nmi.c
--- a/arch/x86/kernel/apic/hw_nmi.c~watchdog-split-up-config-options
+++ a/arch/x86/kernel/apic/hw_nmi.c
@@ -19,7 +19,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 
-#ifdef CONFIG_HARDLOCKUP_DETECTOR
+#ifdef CONFIG_HARDLOCKUP_DETECTOR_PERF
 u64 hw_nmi_get_sample_period(int watchdog_thresh)
 {
 	return (u64)(cpu_khz) * 1000 * watchdog_thresh;
diff -puN include/linux/nmi.h~watchdog-split-up-config-options include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-split-up-config-options
+++ a/include/linux/nmi.h
@@ -11,13 +11,21 @@
 #endif
 
 #ifdef CONFIG_LOCKUP_DETECTOR
+void lockup_detector_init(void);
+#else
+static inline void lockup_detector_init(void)
+{
+}
+#endif
+
+#ifdef CONFIG_SOFTLOCKUP_DETECTOR
 extern void touch_softlockup_watchdog_sched(void);
 extern void touch_softlockup_watchdog(void);
 extern void touch_softlockup_watchdog_sync(void);
 extern void touch_all_softlockup_watchdogs(void);
 extern unsigned int  softlockup_panic;
-extern unsigned int  hardlockup_panic;
-void lockup_detector_init(void);
+extern int soft_watchdog_enabled;
+extern atomic_t watchdog_park_in_progress;
 #else
 static inline void touch_softlockup_watchdog_sched(void)
 {
@@ -31,9 +39,6 @@ static inline void touch_softlockup_watc
 static inline void touch_all_softlockup_watchdogs(void)
 {
 }
-static inline void lockup_detector_init(void)
-{
-}
 #endif
 
 #ifdef CONFIG_DETECT_HUNG_TASK
@@ -63,15 +68,18 @@ static inline void reset_hung_task_detec
 
 #if defined(CONFIG_HARDLOCKUP_DETECTOR)
 extern void hardlockup_detector_disable(void);
+extern unsigned int hardlockup_panic;
 #else
 static inline void hardlockup_detector_disable(void) {}
 #endif
 
-#if defined(CONFIG_HARDLOCKUP_DETECTOR) || defined(CONFIG_HAVE_NMI_WATCHDOG)
+#if defined(CONFIG_HARDLOCKUP_DETECTOR_PERF)
 extern void arch_touch_nmi_watchdog(void);
 #else
+#if !defined(CONFIG_HAVE_NMI_WATCHDOG)
 static inline void arch_touch_nmi_watchdog(void) {}
 #endif
+#endif
 
 /**
  * touch_nmi_watchdog - restart NMI watchdog timeout.
@@ -141,15 +149,18 @@ static inline bool trigger_single_cpu_ba
 }
 #endif
 
-#ifdef CONFIG_LOCKUP_DETECTOR
+#ifdef CONFIG_HARDLOCKUP_DETECTOR_PERF
 u64 hw_nmi_get_sample_period(int watchdog_thresh);
+#endif
+
+#ifdef CONFIG_LOCKUP_DETECTOR
 extern int nmi_watchdog_enabled;
-extern int soft_watchdog_enabled;
 extern int watchdog_user_enabled;
 extern int watchdog_thresh;
 extern unsigned long watchdog_enabled;
+extern struct cpumask watchdog_cpumask;
 extern unsigned long *watchdog_cpumask_bits;
-extern atomic_t watchdog_park_in_progress;
+extern int __read_mostly watchdog_suspended;
 #ifdef CONFIG_SMP
 extern int sysctl_softlockup_all_cpu_backtrace;
 extern int sysctl_hardlockup_all_cpu_backtrace;
diff -puN kernel/Makefile~watchdog-split-up-config-options kernel/Makefile
--- a/kernel/Makefile~watchdog-split-up-config-options
+++ a/kernel/Makefile
@@ -82,7 +82,7 @@ obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_KGDB) += debug/
 obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
 obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
-obj-$(CONFIG_HARDLOCKUP_DETECTOR) += watchdog_hld.o
+obj-$(CONFIG_HARDLOCKUP_DETECTOR_PERF) += watchdog_hld.o
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
diff -puN kernel/sysctl.c~watchdog-split-up-config-options kernel/sysctl.c
--- a/kernel/sysctl.c~watchdog-split-up-config-options
+++ a/kernel/sysctl.c
@@ -880,6 +880,14 @@ static struct ctl_table kern_table[] = {
 #endif
 	},
 	{
+		.procname	= "watchdog_cpumask",
+		.data		= &watchdog_cpumask_bits,
+		.maxlen		= NR_CPUS,
+		.mode		= 0644,
+		.proc_handler	= proc_watchdog_cpumask,
+	},
+#ifdef CONFIG_SOFTLOCKUP_DETECTOR
+	{
 		.procname       = "soft_watchdog",
 		.data           = &soft_watchdog_enabled,
 		.maxlen         = sizeof (int),
@@ -889,13 +897,6 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 	{
-		.procname	= "watchdog_cpumask",
-		.data		= &watchdog_cpumask_bits,
-		.maxlen		= NR_CPUS,
-		.mode		= 0644,
-		.proc_handler	= proc_watchdog_cpumask,
-	},
-	{
 		.procname	= "softlockup_panic",
 		.data		= &softlockup_panic,
 		.maxlen		= sizeof(int),
@@ -904,27 +905,29 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
-#ifdef CONFIG_HARDLOCKUP_DETECTOR
+#ifdef CONFIG_SMP
 	{
-		.procname	= "hardlockup_panic",
-		.data		= &hardlockup_panic,
+		.procname	= "softlockup_all_cpu_backtrace",
+		.data		= &sysctl_softlockup_all_cpu_backtrace,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+#endif /* CONFIG_SMP */
 #endif
-#ifdef CONFIG_SMP
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
 	{
-		.procname	= "softlockup_all_cpu_backtrace",
-		.data		= &sysctl_softlockup_all_cpu_backtrace,
+		.procname	= "hardlockup_panic",
+		.data		= &hardlockup_panic,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+#ifdef CONFIG_SMP
 	{
 		.procname	= "hardlockup_all_cpu_backtrace",
 		.data		= &sysctl_hardlockup_all_cpu_backtrace,
@@ -936,6 +939,8 @@ static struct ctl_table kern_table[] = {
 	},
 #endif /* CONFIG_SMP */
 #endif
+#endif
+
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
 	{
 		.procname       = "unknown_nmi_panic",
diff -puN kernel/watchdog.c~watchdog-split-up-config-options kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-split-up-config-options
+++ a/kernel/watchdog.c
@@ -29,15 +29,58 @@
 #include <linux/kvm_para.h>
 #include <linux/kthread.h>
 
+/* Watchdog configuration */
 static DEFINE_MUTEX(watchdog_proc_mutex);
 
-#if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
-unsigned long __read_mostly watchdog_enabled = SOFT_WATCHDOG_ENABLED|NMI_WATCHDOG_ENABLED;
+int __read_mostly nmi_watchdog_enabled;
+
+#if defined(CONFIG_HARDLOCKUP_DETECTOR) || defined(CONFIG_HAVE_NMI_WATCHDOG)
+unsigned long __read_mostly watchdog_enabled = SOFT_WATCHDOG_ENABLED |
+						NMI_WATCHDOG_ENABLED;
 #else
 unsigned long __read_mostly watchdog_enabled = SOFT_WATCHDOG_ENABLED;
 #endif
-int __read_mostly nmi_watchdog_enabled;
+
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+/* boot commands */
+/*
+ * Should we panic when a soft-lockup or hard-lockup occurs:
+ */
+unsigned int __read_mostly hardlockup_panic =
+			CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE;
+/*
+ * We may not want to enable hard lockup detection by default in all cases,
+ * for example when running the kernel as a guest on a hypervisor. In these
+ * cases this function can be called to disable hard lockup detection. This
+ * function should only be executed once by the boot processor before the
+ * kernel command line parameters are parsed, because otherwise it is not
+ * possible to override this in hardlockup_panic_setup().
+ */
+void hardlockup_detector_disable(void)
+{
+	watchdog_enabled &= ~NMI_WATCHDOG_ENABLED;
+}
+
+static int __init hardlockup_panic_setup(char *str)
+{
+	if (!strncmp(str, "panic", 5))
+		hardlockup_panic = 1;
+	else if (!strncmp(str, "nopanic", 7))
+		hardlockup_panic = 0;
+	else if (!strncmp(str, "0", 1))
+		watchdog_enabled &= ~NMI_WATCHDOG_ENABLED;
+	else if (!strncmp(str, "1", 1))
+		watchdog_enabled |= NMI_WATCHDOG_ENABLED;
+	return 1;
+}
+__setup("nmi_watchdog=", hardlockup_panic_setup);
+
+#endif
+
+#ifdef CONFIG_SOFTLOCKUP_DETECTOR
 int __read_mostly soft_watchdog_enabled;
+#endif
+
 int __read_mostly watchdog_user_enabled;
 int __read_mostly watchdog_thresh = 10;
 
@@ -45,15 +88,9 @@ int __read_mostly watchdog_thresh = 10;
 int __read_mostly sysctl_softlockup_all_cpu_backtrace;
 int __read_mostly sysctl_hardlockup_all_cpu_backtrace;
 #endif
-static struct cpumask watchdog_cpumask __read_mostly;
+struct cpumask watchdog_cpumask __read_mostly;
 unsigned long *watchdog_cpumask_bits = cpumask_bits(&watchdog_cpumask);
 
-/* Helper for online, unparked cpus. */
-#define for_each_watchdog_cpu(cpu) \
-	for_each_cpu_and((cpu), cpu_online_mask, &watchdog_cpumask)
-
-atomic_t watchdog_park_in_progress = ATOMIC_INIT(0);
-
 /*
  * The 'watchdog_running' variable is set to 1 when the watchdog threads
  * are registered/started and is set to 0 when the watchdog threads are
@@ -72,7 +109,27 @@ static int __read_mostly watchdog_runnin
  * of 'watchdog_running' cannot change while the watchdog is deactivated
  * temporarily (see related code in 'proc' handlers).
  */
-static int __read_mostly watchdog_suspended;
+int __read_mostly watchdog_suspended;
+
+/*
+ * These functions can be overridden if an architecture implements its
+ * own hardlockup detector.
+ */
+int __weak watchdog_nmi_enable(unsigned int cpu)
+{
+	return 0;
+}
+void __weak watchdog_nmi_disable(unsigned int cpu)
+{
+}
+
+#ifdef CONFIG_SOFTLOCKUP_DETECTOR
+
+/* Helper for online, unparked cpus. */
+#define for_each_watchdog_cpu(cpu) \
+	for_each_cpu_and((cpu), cpu_online_mask, &watchdog_cpumask)
+
+atomic_t watchdog_park_in_progress = ATOMIC_INIT(0);
 
 static u64 __read_mostly sample_period;
 
@@ -120,6 +177,7 @@ static int __init softlockup_all_cpu_bac
 	return 1;
 }
 __setup("softlockup_all_cpu_backtrace=", softlockup_all_cpu_backtrace_setup);
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
 static int __init hardlockup_all_cpu_backtrace_setup(char *str)
 {
 	sysctl_hardlockup_all_cpu_backtrace =
@@ -128,6 +186,7 @@ static int __init hardlockup_all_cpu_bac
 }
 __setup("hardlockup_all_cpu_backtrace=", hardlockup_all_cpu_backtrace_setup);
 #endif
+#endif
 
 /*
  * Hard-lockup warnings should be triggered after just a few seconds. Soft-
@@ -213,18 +272,6 @@ void touch_softlockup_watchdog_sync(void
 	__this_cpu_write(watchdog_touch_ts, 0);
 }
 
-/* watchdog detector functions */
-bool is_hardlockup(void)
-{
-	unsigned long hrint = __this_cpu_read(hrtimer_interrupts);
-
-	if (__this_cpu_read(hrtimer_interrupts_saved) == hrint)
-		return true;
-
-	__this_cpu_write(hrtimer_interrupts_saved, hrint);
-	return false;
-}
-
 static int is_softlockup(unsigned long touch_ts)
 {
 	unsigned long now = get_timestamp();
@@ -237,21 +284,21 @@ static int is_softlockup(unsigned long t
 	return 0;
 }
 
-static void watchdog_interrupt_count(void)
+/* watchdog detector functions */
+bool is_hardlockup(void)
 {
-	__this_cpu_inc(hrtimer_interrupts);
-}
+	unsigned long hrint = __this_cpu_read(hrtimer_interrupts);
 
-/*
- * These two functions are mostly architecture specific
- * defining them as weak here.
- */
-int __weak watchdog_nmi_enable(unsigned int cpu)
-{
-	return 0;
+	if (__this_cpu_read(hrtimer_interrupts_saved) == hrint)
+		return true;
+
+	__this_cpu_write(hrtimer_interrupts_saved, hrint);
+	return false;
 }
-void __weak watchdog_nmi_disable(unsigned int cpu)
+
+static void watchdog_interrupt_count(void)
 {
+	__this_cpu_inc(hrtimer_interrupts);
 }
 
 static int watchdog_enable_all_cpus(void);
@@ -502,57 +549,6 @@ static void watchdog_unpark_threads(void
 		kthread_unpark(per_cpu(softlockup_watchdog, cpu));
 }
 
-/*
- * Suspend the hard and soft lockup detector by parking the watchdog threads.
- */
-int lockup_detector_suspend(void)
-{
-	int ret = 0;
-
-	get_online_cpus();
-	mutex_lock(&watchdog_proc_mutex);
-	/*
-	 * Multiple suspend requests can be active in parallel (counted by
-	 * the 'watchdog_suspended' variable). If the watchdog threads are
-	 * running, the first caller takes care that they will be parked.
-	 * The state of 'watchdog_running' cannot change while a suspend
-	 * request is active (see related code in 'proc' handlers).
-	 */
-	if (watchdog_running && !watchdog_suspended)
-		ret = watchdog_park_threads();
-
-	if (ret == 0)
-		watchdog_suspended++;
-	else {
-		watchdog_disable_all_cpus();
-		pr_err("Failed to suspend lockup detectors, disabled\n");
-		watchdog_enabled = 0;
-	}
-
-	mutex_unlock(&watchdog_proc_mutex);
-
-	return ret;
-}
-
-/*
- * Resume the hard and soft lockup detector by unparking the watchdog threads.
- */
-void lockup_detector_resume(void)
-{
-	mutex_lock(&watchdog_proc_mutex);
-
-	watchdog_suspended--;
-	/*
-	 * The watchdog threads are unparked if they were previously running
-	 * and if there is no more active suspend request.
-	 */
-	if (watchdog_running && !watchdog_suspended)
-		watchdog_unpark_threads();
-
-	mutex_unlock(&watchdog_proc_mutex);
-	put_online_cpus();
-}
-
 static int update_watchdog_all_cpus(void)
 {
 	int ret;
@@ -604,6 +600,81 @@ static void watchdog_disable_all_cpus(vo
 	}
 }
 
+#else /* SOFTLOCKUP */
+static int watchdog_park_threads(void)
+{
+	return 0;
+}
+
+static void watchdog_unpark_threads(void)
+{
+}
+
+static int watchdog_enable_all_cpus(void)
+{
+	return 0;
+}
+
+static void watchdog_disable_all_cpus(void)
+{
+}
+
+static void set_sample_period(void)
+{
+}
+#endif /* SOFTLOCKUP */
+
+/*
+ * Suspend the hard and soft lockup detector by parking the watchdog threads.
+ */
+int lockup_detector_suspend(void)
+{
+	int ret = 0;
+
+	get_online_cpus();
+	mutex_lock(&watchdog_proc_mutex);
+	/*
+	 * Multiple suspend requests can be active in parallel (counted by
+	 * the 'watchdog_suspended' variable). If the watchdog threads are
+	 * running, the first caller takes care that they will be parked.
+	 * The state of 'watchdog_running' cannot change while a suspend
+	 * request is active (see related code in 'proc' handlers).
+	 */
+	if (watchdog_running && !watchdog_suspended)
+		ret = watchdog_park_threads();
+
+	if (ret == 0)
+		watchdog_suspended++;
+	else {
+		watchdog_disable_all_cpus();
+		pr_err("Failed to suspend lockup detectors, disabled\n");
+		watchdog_enabled = 0;
+	}
+
+	mutex_unlock(&watchdog_proc_mutex);
+
+	return ret;
+}
+
+/*
+ * Resume the hard and soft lockup detector by unparking the watchdog threads.
+ */
+void lockup_detector_resume(void)
+{
+	mutex_lock(&watchdog_proc_mutex);
+
+	watchdog_suspended--;
+	/*
+	 * The watchdog threads are unparked if they were previously running
+	 * and if there is no more active suspend request.
+	 */
+	if (watchdog_running && !watchdog_suspended)
+		watchdog_unpark_threads();
+
+	mutex_unlock(&watchdog_proc_mutex);
+	put_online_cpus();
+}
+
 #ifdef CONFIG_SYSCTL
 
 /*
@@ -810,9 +881,11 @@ int proc_watchdog_cpumask(struct ctl_tab
 			 * a temporary cpumask, so we are likely not in a
 			 * position to do much else to make things better.
 			 */
+#ifdef CONFIG_SOFTLOCKUP_DETECTOR
 			if (smpboot_update_cpumask_percpu_thread(
 				    &watchdog_threads, &watchdog_cpumask) != 0)
 				pr_err("cpumask update failed\n");
+#endif
 		}
 	}
 out:
diff -puN kernel/watchdog_hld.c~watchdog-split-up-config-options kernel/watchdog_hld.c
--- a/kernel/watchdog_hld.c~watchdog-split-up-config-options
+++ a/kernel/watchdog_hld.c
@@ -22,39 +22,7 @@ static DEFINE_PER_CPU(bool, hard_watchdo
 static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 
-/* boot commands */
-/*
- * Should we panic when a soft-lockup or hard-lockup occurs:
- */
-unsigned int __read_mostly hardlockup_panic =
-			CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE;
 static unsigned long hardlockup_allcpu_dumped;
-/*
- * We may not want to enable hard lockup detection by default in all cases,
- * for example when running the kernel as a guest on a hypervisor. In these
- * cases this function can be called to disable hard lockup detection. This
- * function should only be executed once by the boot processor before the
- * kernel command line parameters are parsed, because otherwise it is not
- * possible to override this in hardlockup_panic_setup().
- */
-void hardlockup_detector_disable(void)
-{
-	watchdog_enabled &= ~NMI_WATCHDOG_ENABLED;
-}
-
-static int __init hardlockup_panic_setup(char *str)
-{
-	if (!strncmp(str, "panic", 5))
-		hardlockup_panic = 1;
-	else if (!strncmp(str, "nopanic", 7))
-		hardlockup_panic = 0;
-	else if (!strncmp(str, "0", 1))
-		watchdog_enabled &= ~NMI_WATCHDOG_ENABLED;
-	else if (!strncmp(str, "1", 1))
-		watchdog_enabled |= NMI_WATCHDOG_ENABLED;
-	return 1;
-}
-__setup("nmi_watchdog=", hardlockup_panic_setup);
 
 void arch_touch_nmi_watchdog(void)
 {
diff -puN lib/Kconfig.debug~watchdog-split-up-config-options lib/Kconfig.debug
--- a/lib/Kconfig.debug~watchdog-split-up-config-options
+++ a/lib/Kconfig.debug
@@ -778,34 +778,45 @@ config DEBUG_SHIRQ
 menu "Debug Lockups and Hangs"
 
 config LOCKUP_DETECTOR
-	bool "Detect Hard and Soft Lockups"
+	bool
+
+config SOFTLOCKUP_DETECTOR
+	bool "Detect Soft Lockups"
 	depends on DEBUG_KERNEL && !S390
+	select LOCKUP_DETECTOR
 	help
 	  Say Y here to enable the kernel to act as a watchdog to detect
-	  hard and soft lockups.
+	  soft lockups.
 
 	  Softlockups are bugs that cause the kernel to loop in kernel
 	  mode for more than 20 seconds, without giving other tasks a
 	  chance to run.  The current stack trace is displayed upon
 	  detection and the system will stay locked up.
 
+config HARDLOCKUP_DETECTOR_PERF
+	bool
+	select SOFTLOCKUP_DETECTOR
+
+#
+# arch/ can define HAVE_HARDLOCKUP_DETECTOR_ARCH to provide their own hard
+# lockup detector rather than the perf based detector.
+#
+config HARDLOCKUP_DETECTOR
+	bool "Detect Hard Lockups"
+	depends on DEBUG_KERNEL && !S390
+	depends on HAVE_HARDLOCKUP_DETECTOR_PERF || HAVE_HARDLOCKUP_DETECTOR_ARCH
+	select LOCKUP_DETECTOR
+	select HARDLOCKUP_DETECTOR_PERF if HAVE_HARDLOCKUP_DETECTOR_PERF
+	select HARDLOCKUP_DETECTOR_ARCH if HAVE_HARDLOCKUP_DETECTOR_ARCH
+	help
+	  Say Y here to enable the kernel to act as a watchdog to detect
+	  hard lockups.
+
 	  Hardlockups are bugs that cause the CPU to loop in kernel mode
 	  for more than 10 seconds, without letting other interrupts have a
 	  chance to run.  The current stack trace is displayed upon detection
 	  and the system will stay locked up.
 
-	  The overhead should be minimal.  A periodic hrtimer runs to
-	  generate interrupts and kick the watchdog task every 4 seconds.
-	  An NMI is generated every 10 seconds or so to check for hardlockups.
-
-	  The frequency of hrtimer and NMI events and the soft and hard lockup
-	  thresholds can be controlled through the sysctl watchdog_thresh.
-
-config HARDLOCKUP_DETECTOR
-	def_bool y
-	depends on LOCKUP_DETECTOR && !HAVE_NMI_WATCHDOG
-	depends on PERF_EVENTS && HAVE_PERF_EVENTS_NMI
-
 config BOOTPARAM_HARDLOCKUP_PANIC
 	bool "Panic (Reboot) On Hard Lockups"
 	depends on HARDLOCKUP_DETECTOR
@@ -826,7 +837,7 @@ config BOOTPARAM_HARDLOCKUP_PANIC_VALUE
 
 config BOOTPARAM_SOFTLOCKUP_PANIC
 	bool "Panic (Reboot) On Soft Lockups"
-	depends on LOCKUP_DETECTOR
+	depends on SOFTLOCKUP_DETECTOR
 	help
 	  Say Y here to enable the kernel to panic on "soft lockups",
 	  which are bugs that cause the kernel to loop in kernel
@@ -843,7 +854,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC
 
 config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	int
-	depends on LOCKUP_DETECTOR
+	depends on SOFTLOCKUP_DETECTOR
 	range 0 1
 	default 0 if !BOOTPARAM_SOFTLOCKUP_PANIC
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
@@ -851,7 +862,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 config DETECT_HUNG_TASK
 	bool "Detect Hung Tasks"
 	depends on DEBUG_KERNEL
-	default LOCKUP_DETECTOR
+	default SOFTLOCKUP_DETECTOR
 	help
 	  Say Y here to enable the kernel to detect "hung tasks",
 	  which are bugs that cause the task to be stuck in
_

Patches currently in -mm which might be from npiggin@gmail.com are

watchdog-remove-unused-declaration.patch
watchdog-introduce-arch_touch_nmi_watchdog.patch
watchdog-split-up-config-options.patch
watchdog-provide-watchdog_reconfigure-for-arch-watchdogs.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog.patch


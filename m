From: akpm@linux-foundation.org
Subject: + watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz.patch added to -mm tree
Date: Thu, 30 Apr 2015 14:19:19 -0700
Message-ID: <55429c57.6XK9eyh0JP8yRMQu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbD3VTU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Apr 2015 17:19:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@ezchip.com, dzickus@redhat.com, mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: add watchdog_cpumask sysctl to assist nohz
has been added to the -mm tree.  Its filename is
     watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: watchdog: add watchdog_cpumask sysctl to assist nohz

Change the default behavior of watchdog so it only runs on the
housekeeping cores when nohz_full is enabled at build and boot time. 
Allow modifying the set of cores the watchdog is currently running on with
a new kernel.watchdog_cpumask sysctl.

In the current system, the watchdog subsystem runs a periodic timer that
schedules the watchdog kthread to run.  However, nohz_full cores are
designed to allow userspace application code running on those cores to
have 100% access to the CPU.  So the watchdog system prevents the
nohz_full application code from being able to run the way it wants to,
thus the motivation to suppress the watchdog on nohz_full cores, which
this patchset provides by default.

However, if we disable the watchdog globally, then the housekeeping cores
can't benefit from the watchdog functionality.  So we allow disabling it
only on some cores.  See Documentation/lockup-watchdogs.txt for more
information.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lockup-watchdogs.txt |   18 +++++++
 Documentation/sysctl/kernel.txt    |   21 ++++++++
 include/linux/nmi.h                |    3 +
 kernel/sysctl.c                    |    7 ++
 kernel/watchdog.c                  |   64 ++++++++++++++++++++++++---
 5 files changed, 108 insertions(+), 5 deletions(-)

diff -puN Documentation/lockup-watchdogs.txt~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz Documentation/lockup-watchdogs.txt
--- a/Documentation/lockup-watchdogs.txt~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz
+++ a/Documentation/lockup-watchdogs.txt
@@ -61,3 +61,21 @@ As explained above, a kernel knob is pro
 administrators to configure the period of the hrtimer and the perf
 event. The right value for a particular environment is a trade-off
 between fast response to lockups and detection overhead.
+
+By default, the watchdog runs on all online cores.  However, on a
+kernel configured with NO_HZ_FULL, by default the watchdog runs only
+on the housekeeping cores, not the cores specified in the "nohz_full"
+boot argument.  If we allowed the watchdog to run by default on
+the "nohz_full" cores, we would have to run timer ticks to activate
+the scheduler, which would prevent the "nohz_full" functionality
+from protecting the user code on those cores from the kernel.
+Of course, disabling it by default on the nohz_full cores means that
+when those cores do enter the kernel, by default we will not be
+able to detect if they lock up.  However, allowing the watchdog
+to continue to run on the housekeeping (non-tickless) cores means
+that we will continue to detect lockups properly on those cores.
+
+In either case, the set of cores excluded from running the watchdog
+may be adjusted via the kernel.watchdog_cpumask sysctl.  For
+nohz_full cores, this may be useful for debugging a case where the
+kernel seems to be hanging on the nohz_full cores.
diff -puN Documentation/sysctl/kernel.txt~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz
+++ a/Documentation/sysctl/kernel.txt
@@ -923,6 +923,27 @@ and nmi_watchdog.
 
 ==============================================================
 
+watchdog_cpumask:
+
+This value can be used to control on which cpus the watchdog may run.
+The default cpumask is all possible cores, but if NO_HZ_FULL is
+enabled in the kernel config, and cores are specified with the
+nohz_full= boot argument, those cores are excluded by default.
+Offline cores can be included in this mask, and if the core is later
+brought online, the watchdog will be started based on the mask value.
+
+Typically this value would only be touched in the nohz_full case
+to re-enable cores that by default were not running the watchdog,
+if a kernel lockup was suspected on those cores.
+
+The argument value is the standard cpulist format for cpumasks,
+so for example to enable the watchdog on cores 0, 2, 3, and 4 you
+might say:
+
+  echo 0,2-4 > /proc/sys/kernel/watchdog_cpumask
+
+==============================================================
+
 watchdog_thresh:
 
 This value can be used to control the frequency of hrtimer and NMI
diff -puN include/linux/nmi.h~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz
+++ a/include/linux/nmi.h
@@ -67,6 +67,7 @@ extern int nmi_watchdog_enabled;
 extern int soft_watchdog_enabled;
 extern int watchdog_user_enabled;
 extern int watchdog_thresh;
+extern unsigned long *watchdog_cpumask_bits;
 extern int sysctl_softlockup_all_cpu_backtrace;
 struct ctl_table;
 extern int proc_watchdog(struct ctl_table *, int ,
@@ -77,6 +78,8 @@ extern int proc_soft_watchdog(struct ctl
 			      void __user *, size_t *, loff_t *);
 extern int proc_watchdog_thresh(struct ctl_table *, int ,
 				void __user *, size_t *, loff_t *);
+extern int proc_watchdog_cpumask(struct ctl_table *, int,
+				 void __user *, size_t *, loff_t *);
 #endif
 
 #ifdef CONFIG_HAVE_ACPI_APEI_NMI
diff -puN kernel/sysctl.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz kernel/sysctl.c
--- a/kernel/sysctl.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz
+++ a/kernel/sysctl.c
@@ -881,6 +881,13 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 	{
+		.procname	= "watchdog_cpumask",
+		.data		= &watchdog_cpumask_bits,
+		.maxlen		= NR_CPUS,
+		.mode		= 0644,
+		.proc_handler	= proc_watchdog_cpumask,
+	},
+	{
 		.procname	= "softlockup_panic",
 		.data		= &softlockup_panic,
 		.maxlen		= sizeof(int),
diff -puN kernel/watchdog.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz
+++ a/kernel/watchdog.c
@@ -19,6 +19,7 @@
 #include <linux/sysctl.h>
 #include <linux/smpboot.h>
 #include <linux/sched/rt.h>
+#include <linux/tick.h>
 
 #include <asm/irq_regs.h>
 #include <linux/kvm_para.h>
@@ -56,6 +57,12 @@ int __read_mostly sysctl_softlockup_all_
 #else
 #define sysctl_softlockup_all_cpu_backtrace 0
 #endif
+static struct cpumask watchdog_cpumask __read_mostly;
+unsigned long *watchdog_cpumask_bits = cpumask_bits(&watchdog_cpumask);
+
+/* Helper for online, unparked cpus. */
+#define for_each_watchdog_cpu(cpu) \
+	for_each_cpu_and((cpu), cpu_online_mask, &watchdog_cpumask)
 
 static int __read_mostly watchdog_running;
 static u64 __read_mostly sample_period;
@@ -205,7 +212,7 @@ void touch_all_softlockup_watchdogs(void
 	 * do we care if a 0 races with a timestamp?
 	 * all it means is the softlock check starts one cycle later
 	 */
-	for_each_online_cpu(cpu)
+	for_each_watchdog_cpu(cpu)
 		per_cpu(watchdog_touch_ts, cpu) = 0;
 }
 
@@ -612,7 +619,7 @@ void watchdog_nmi_enable_all(void)
 		return;
 
 	get_online_cpus();
-	for_each_online_cpu(cpu)
+	for_each_watchdog_cpu(cpu)
 		watchdog_nmi_enable(cpu);
 	put_online_cpus();
 }
@@ -625,7 +632,7 @@ void watchdog_nmi_disable_all(void)
 		return;
 
 	get_online_cpus();
-	for_each_online_cpu(cpu)
+	for_each_watchdog_cpu(cpu)
 		watchdog_nmi_disable(cpu);
 	put_online_cpus();
 }
@@ -684,7 +691,7 @@ static void update_watchdog_all_cpus(voi
 	int cpu;
 
 	get_online_cpus();
-	for_each_online_cpu(cpu)
+	for_each_watchdog_cpu(cpu)
 		update_watchdog(cpu);
 	put_online_cpus();
 }
@@ -697,8 +704,12 @@ static int watchdog_enable_all_cpus(void
 		err = smpboot_register_percpu_thread(&watchdog_threads);
 		if (err)
 			pr_err("Failed to create watchdog threads, disabled\n");
-		else
+		else {
+			if (smpboot_update_cpumask_percpu_thread(
+				    &watchdog_threads, &watchdog_cpumask))
+				pr_err("Failed to set cpumask for watchdog threads\n");
 			watchdog_running = 1;
+		}
 	} else {
 		/*
 		 * Enable/disable the lockup detectors or
@@ -869,12 +880,55 @@ out:
 	mutex_unlock(&watchdog_proc_mutex);
 	return err;
 }
+
+/*
+ * The cpumask is the mask of possible cpus that the watchdog can run
+ * on, not the mask of cpus it is actually running on.  This allows the
+ * user to specify a mask that will include cpus that have not yet
+ * been brought online, if desired.
+ */
+int proc_watchdog_cpumask(struct ctl_table *table, int write,
+			  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int err;
+
+	mutex_lock(&watchdog_proc_mutex);
+	err = proc_do_large_bitmap(table, write, buffer, lenp, ppos);
+	if (!err && write) {
+		/* Remove impossible cpus to keep sysctl output cleaner. */
+		cpumask_and(&watchdog_cpumask, &watchdog_cpumask,
+			    cpu_possible_mask);
+
+		if (watchdog_enabled && watchdog_thresh) {
+			/*
+			 * Failure would be due to being unable to allocate
+			 * a temporary cpumask, so we are likely not in a
+			 * position to do much else to make things better.
+			 */
+			if (smpboot_update_cpumask_percpu_thread(
+				    &watchdog_threads, &watchdog_cpumask) != 0)
+				pr_err("cpumask update failed\n");
+		}
+	}
+	mutex_unlock(&watchdog_proc_mutex);
+	return err;
+}
+
 #endif /* CONFIG_SYSCTL */
 
 void __init lockup_detector_init(void)
 {
 	set_sample_period();
 
+#ifdef CONFIG_NO_HZ_FULL
+	if (!cpumask_empty(tick_nohz_full_mask))
+		pr_info("Disabling watchdog on nohz_full cores by default\n");
+	cpumask_andnot(&watchdog_cpumask, cpu_possible_mask,
+		       tick_nohz_full_mask);
+#else
+	cpumask_copy(&watchdog_cpumask, cpu_possible_mask);
+#endif
+
 	if (watchdog_enabled)
 		watchdog_enable_all_cpus();
 }
_

Patches currently in -mm which might be from cmetcalf@ezchip.com are

origin.patch
smpboot-allow-excluding-cpus-from-the-smpboot-threads.patch
watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz.patch
procfs-treat-parked-tasks-as-sleeping-for-task-state.patch
mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch
__bitmap_parselist-fix-bug-in-empty-string-handling.patch
linux-next.patch


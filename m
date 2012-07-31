From: akpm@linux-foundation.org
Subject: [merged] nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:09 -0700
Message-ID: <20120731184909.E5A2E1E007E@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab2GaStL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:11 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: snanda@chromium.org, a.p.zijlstra@chello.nl, dzickus@redhat.com, khandual@linux.vnet.ibm.com, mingo@elte.hu, msb@chromium.org, rjw@sisk.pl, srivatsa.bhat@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: NMI watchdog: fix for lockup detector breakage on resume
has been removed from the -mm tree.  Its filename was
     nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sameer Nanda <snanda@chromium.org>
Subject: NMI watchdog: fix for lockup detector breakage on resume

On the suspend/resume path the boot CPU does not go though an
offline->online transition.  This breaks the NMI detector post-resume
since it depends on PMU state that is lost when the system gets suspended.

Fix this by forcing a CPU offline->online transition for the lockup
detector on the boot CPU during resume.

To provide more context, we enable NMI watchdog on Chrome OS.  We have
seen several reports of systems freezing up completely which indicated
that the NMI watchdog was not firing for some reason.

Debugging further, we found a simple way of repro'ing system freezes --
issuing the command 'tasket 1 sh -c "echo nmilockup > /proc/breakme"'
after the system has been suspended/resumed one or more times.

With this patch in place, the system freeze result in panics, as expected.
 These panics provide a nice stack trace for us to debug the actual issue
causing the freeze.

[akpm@linux-foundation.org: fiddle with code comment]
[akpm@linux-foundation.org: make lockup_detector_bootcpu_resume() conditional on CONFIG_SUSPEND]
[akpm@linux-foundation.org: fix section errors]
Signed-off-by: Sameer Nanda <snanda@chromium.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h  |    8 ++++++++
 kernel/power/suspend.c |    3 +++
 kernel/watchdog.c      |   21 +++++++++++++++++++--
 3 files changed, 30 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume include/linux/sched.h
--- a/include/linux/sched.h~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume
+++ a/include/linux/sched.h
@@ -334,6 +334,14 @@ static inline void lockup_detector_init(
 }
 #endif
 
+#if defined(CONFIG_LOCKUP_DETECTOR) && defined(CONFIG_SUSPEND)
+void lockup_detector_bootcpu_resume(void);
+#else
+static inline void lockup_detector_bootcpu_resume(void)
+{
+}
+#endif
+
 #ifdef CONFIG_DETECT_HUNG_TASK
 extern unsigned int  sysctl_hung_task_panic;
 extern unsigned long sysctl_hung_task_check_count;
diff -puN kernel/power/suspend.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume kernel/power/suspend.c
--- a/kernel/power/suspend.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume
+++ a/kernel/power/suspend.c
@@ -178,6 +178,9 @@ static int suspend_enter(suspend_state_t
 	arch_suspend_enable_irqs();
 	BUG_ON(irqs_disabled());
 
+	/* Kick the lockup detector */
+	lockup_detector_bootcpu_resume();
+
  Enable_cpus:
 	enable_nonboot_cpus();
 
diff -puN kernel/watchdog.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume kernel/watchdog.c
--- a/kernel/watchdog.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume
+++ a/kernel/watchdog.c
@@ -575,7 +575,7 @@ out:
 /*
  * Create/destroy watchdog threads as CPUs come and go:
  */
-static int __cpuinit
+static int
 cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
@@ -610,10 +610,27 @@ cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cpu_nfb = {
+static struct notifier_block cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
+#ifdef CONFIG_SUSPEND
+/*
+ * On exit from suspend we force an offline->online transition on the boot CPU
+ * so that the PMU state that was lost while in suspended state gets set up
+ * properly for the boot CPU.  This information is required for restarting the
+ * NMI watchdog.
+ */
+void lockup_detector_bootcpu_resume(void)
+{
+	void *cpu = (void *)(long)smp_processor_id();
+
+	cpu_callback(&cpu_nfb, CPU_DEAD_FROZEN, cpu);
+	cpu_callback(&cpu_nfb, CPU_UP_PREPARE_FROZEN, cpu);
+	cpu_callback(&cpu_nfb, CPU_ONLINE_FROZEN, cpu);
+}
+#endif
+
 void __init lockup_detector_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
_

Patches currently in -mm which might be from snanda@chromium.org are

origin.patch


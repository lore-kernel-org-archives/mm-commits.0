From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 12:08:50 -0700
Message-ID: <552eb742.tDzEL0yrdB9e6MCv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbbDOTIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: enable the new user interface of the watchdog mechanism
has been removed from the -mm tree.  Its filename was
     watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: enable the new user interface of the watchdog mechanism

With the current user interface of the watchdog mechanism it is only
possible to disable or enable both lockup detectors at the same time. 
This series introduces new kernel parameters and changes the semantics of
some existing kernel parameters, so that the hard lockup detector and the
soft lockup detector can be disabled or enabled individually.  With this
series applied, the user interface is as follows.

- parameters in /proc/sys/kernel

  . soft_watchdog
    This is a new parameter to control and examine the run state of
    the soft lockup detector.

  . nmi_watchdog
    The semantics of this parameter have changed. It can now be used
    to control and examine the run state of the hard lockup detector.

  . watchdog
    This parameter is still available to control the run state of both
    lockup detectors at the same time. If this parameter is examined,
    it shows the logical OR of soft_watchdog and nmi_watchdog.

  . watchdog_thresh
    The semantics of this parameter are not affected by the patch.

- kernel command line parameters

  . nosoftlockup
    The semantics of this parameter have changed. It can now be used
    to disable the soft lockup detector at boot time.

  . nmi_watchdog=0 or nmi_watchdog=1
    Disable or enable the hard lockup detector at boot time. The patch
    introduces '=1' as a new option.

  . nowatchdog
    The semantics of this parameter are not affected by the patch. It
    is still available to disable both lockup detectors at boot time.

Also, remove the proc_dowatchdog() function which is no longer needed.

[dzickus@redhat.com: wrote changelog]
[dzickus@redhat.com: update documentation for kernel params and sysctl]
Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 +
 Documentation/sysctl/kernel.txt     |   64 +++++++++++++++++---
 include/linux/nmi.h                 |    2 
 kernel/sysctl.c                     |   35 +++++++----
 kernel/watchdog.c                   |   81 +++++---------------------
 5 files changed, 98 insertions(+), 90 deletions(-)

diff -puN Documentation/kernel-parameters.txt~watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism
+++ a/Documentation/kernel-parameters.txt
@@ -2236,8 +2236,9 @@ bytes respectively. Such letter suffixes
 
 	nmi_watchdog=	[KNL,BUGS=X86] Debugging features for SMP kernels
 			Format: [panic,][nopanic,][num]
-			Valid num: 0
+			Valid num: 0 or 1
 			0 - turn nmi_watchdog off
+			1 - turn nmi_watchdog on
 			When panic is specified, panic when an NMI watchdog
 			timeout occurs (or 'nopanic' to override the opposite
 			default).
@@ -2464,7 +2465,8 @@ bytes respectively. Such letter suffixes
 
 	nousb		[USB] Disable the USB subsystem
 
-	nowatchdog	[KNL] Disable the lockup detector (NMI watchdog).
+	nowatchdog	[KNL] Disable both lockup detectors, i.e.
+                        soft-lockup and NMI watchdog (hard-lockup).
 
 	nowb		[ARM]
 
diff -puN Documentation/sysctl/kernel.txt~watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism
+++ a/Documentation/sysctl/kernel.txt
@@ -77,12 +77,14 @@ show up in /proc/sys/kernel:
 - shmmax                      [ sysv ipc ]
 - shmmni
 - softlockup_all_cpu_backtrace
+- soft_watchdog
 - stop-a                      [ SPARC only ]
 - sysrq                       ==> Documentation/sysrq.txt
 - sysctl_writes_strict
 - tainted
 - threads-max
 - unknown_nmi_panic
+- watchdog
 - watchdog_thresh
 - version
 
@@ -417,16 +419,23 @@ successful IPC object allocation.
 
 nmi_watchdog:
 
-Enables/Disables the NMI watchdog on x86 systems. When the value is
-non-zero the NMI watchdog is enabled and will continuously test all
-online cpus to determine whether or not they are still functioning
-properly. Currently, passing "nmi_watchdog=" parameter at boot time is
-required for this function to work.
-
-If LAPIC NMI watchdog method is in use (nmi_watchdog=2 kernel
-parameter), the NMI watchdog shares registers with oprofile. By
-disabling the NMI watchdog, oprofile may have more registers to
-utilize.
+This parameter can be used to control the NMI watchdog
+(i.e. the hard lockup detector) on x86 systems.
+
+   0 - disable the hard lockup detector
+   1 - enable the hard lockup detector
+
+The hard lockup detector monitors each CPU for its ability to respond to
+timer interrupts. The mechanism utilizes CPU performance counter registers
+that are programmed to generate Non-Maskable Interrupts (NMIs) periodically
+while a CPU is busy. Hence, the alternative name 'NMI watchdog'.
+
+The NMI watchdog is disabled by default if the kernel is running as a guest
+in a KVM virtual machine. This default can be overridden by adding
+
+   nmi_watchdog=1
+
+to the guest kernel command line (see Documentation/kernel-parameters.txt).
 
 ==============================================================
 
@@ -816,6 +825,22 @@ NMI.
 
 ==============================================================
 
+soft_watchdog
+
+This parameter can be used to control the soft lockup detector.
+
+   0 - disable the soft lockup detector
+   1 - enable the soft lockup detector
+
+The soft lockup detector monitors CPUs for threads that are hogging the CPUs
+without rescheduling voluntarily, and thus prevent the 'watchdog/N' threads
+from running. The mechanism depends on the CPUs ability to respond to timer
+interrupts which are needed for the 'watchdog/N' threads to be woken up by
+the watchdog timer function, otherwise the NMI watchdog - if enabled - can
+detect a hard lockup condition.
+
+==============================================================
+
 tainted:
 
 Non-zero if the kernel has been tainted.  Numeric values, which
@@ -858,6 +883,25 @@ example.  If a system hangs up, try pres
 
 ==============================================================
 
+watchdog:
+
+This parameter can be used to disable or enable the soft lockup detector
+_and_ the NMI watchdog (i.e. the hard lockup detector) at the same time.
+
+   0 - disable both lockup detectors
+   1 - enable both lockup detectors
+
+The soft lockup detector and the NMI watchdog can also be disabled or
+enabled individually, using the soft_watchdog and nmi_watchdog parameters.
+If the watchdog parameter is read, for example by executing
+
+   cat /proc/sys/kernel/watchdog
+
+the output of this command (0 or 1) shows the logical OR of soft_watchdog
+and nmi_watchdog.
+
+==============================================================
+
 watchdog_thresh:
 
 This value can be used to control the frequency of hrtimer and NMI
diff -puN include/linux/nmi.h~watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism
+++ a/include/linux/nmi.h
@@ -82,8 +82,6 @@ extern int proc_soft_watchdog(struct ctl
 			      void __user *, size_t *, loff_t *);
 extern int proc_watchdog_thresh(struct ctl_table *, int ,
 				void __user *, size_t *, loff_t *);
-extern int proc_dowatchdog(struct ctl_table *, int ,
-			   void __user *, size_t *, loff_t *);
 #endif
 
 #ifdef CONFIG_HAVE_ACPI_APEI_NMI
diff -puN kernel/sysctl.c~watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism kernel/sysctl.c
--- a/kernel/sysctl.c~watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism
+++ a/kernel/sysctl.c
@@ -846,7 +846,7 @@ static struct ctl_table kern_table[] = {
 		.data           = &watchdog_user_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
-		.proc_handler   = proc_dowatchdog,
+		.proc_handler   = proc_watchdog,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -855,11 +855,33 @@ static struct ctl_table kern_table[] = {
 		.data		= &watchdog_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dowatchdog,
+		.proc_handler	= proc_watchdog_thresh,
 		.extra1		= &zero,
 		.extra2		= &sixty,
 	},
 	{
+		.procname       = "nmi_watchdog",
+		.data           = &nmi_watchdog_enabled,
+		.maxlen         = sizeof (int),
+		.mode           = 0644,
+		.proc_handler   = proc_nmi_watchdog,
+		.extra1		= &zero,
+#if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
+		.extra2		= &one,
+#else
+		.extra2		= &zero,
+#endif
+	},
+	{
+		.procname       = "soft_watchdog",
+		.data           = &soft_watchdog_enabled,
+		.maxlen         = sizeof (int),
+		.mode           = 0644,
+		.proc_handler   = proc_soft_watchdog,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+	{
 		.procname	= "softlockup_panic",
 		.data		= &softlockup_panic,
 		.maxlen		= sizeof(int),
@@ -879,15 +901,6 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 #endif /* CONFIG_SMP */
-	{
-		.procname       = "nmi_watchdog",
-		.data           = &watchdog_user_enabled,
-		.maxlen         = sizeof (int),
-		.mode           = 0644,
-		.proc_handler   = proc_dowatchdog,
-		.extra1		= &zero,
-		.extra2		= &one,
-	},
 #endif
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
 	{
diff -puN kernel/watchdog.c~watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism
+++ a/kernel/watchdog.c
@@ -110,15 +110,9 @@ static int __init hardlockup_panic_setup
 	else if (!strncmp(str, "nopanic", 7))
 		hardlockup_panic = 0;
 	else if (!strncmp(str, "0", 1))
-		watchdog_user_enabled = 0;
-	else if (!strncmp(str, "1", 1) || !strncmp(str, "2", 1)) {
-		/*
-		 * Setting 'nmi_watchdog=1' or 'nmi_watchdog=2' (legacy option)
-		 * has the same effect.
-		 */
-		watchdog_user_enabled = 1;
-		watchdog_enable_hardlockup_detector(true);
-	}
+		watchdog_enabled &= ~NMI_WATCHDOG_ENABLED;
+	else if (!strncmp(str, "1", 1))
+		watchdog_enabled |= NMI_WATCHDOG_ENABLED;
 	return 1;
 }
 __setup("nmi_watchdog=", hardlockup_panic_setup);
@@ -137,19 +131,18 @@ __setup("softlockup_panic=", softlockup_
 
 static int __init nowatchdog_setup(char *str)
 {
-	watchdog_user_enabled = 0;
+	watchdog_enabled = 0;
 	return 1;
 }
 __setup("nowatchdog", nowatchdog_setup);
 
-/* deprecated */
 static int __init nosoftlockup_setup(char *str)
 {
-	watchdog_user_enabled = 0;
+	watchdog_enabled &= ~SOFT_WATCHDOG_ENABLED;
 	return 1;
 }
 __setup("nosoftlockup", nosoftlockup_setup);
-/*  */
+
 #ifdef CONFIG_SMP
 static int __init softlockup_all_cpu_backtrace_setup(char *str)
 {
@@ -264,10 +257,11 @@ static int is_softlockup(unsigned long t
 {
 	unsigned long now = get_timestamp();
 
-	/* Warn about unreasonable delays: */
-	if (time_after(now, touch_ts + get_softlockup_thresh()))
-		return now - touch_ts;
-
+	if (watchdog_enabled & SOFT_WATCHDOG_ENABLED) {
+		/* Warn about unreasonable delays. */
+		if (time_after(now, touch_ts + get_softlockup_thresh()))
+			return now - touch_ts;
+	}
 	return 0;
 }
 
@@ -532,6 +526,10 @@ static int watchdog_nmi_enable(unsigned
 	struct perf_event_attr *wd_attr;
 	struct perf_event *event = per_cpu(watchdog_ev, cpu);
 
+	/* nothing to do if the hard lockup detector is disabled */
+	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
+		goto out;
+
 	/*
 	 * Some kernels need to default hard lockup detection to
 	 * 'disabled', for example a guest on a hypervisor.
@@ -856,59 +854,12 @@ out:
 	mutex_unlock(&watchdog_proc_mutex);
 	return err;
 }
-
-/*
- * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
- */
-
-int proc_dowatchdog(struct ctl_table *table, int write,
-		    void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	int err, old_thresh, old_enabled;
-	bool old_hardlockup;
-
-	mutex_lock(&watchdog_proc_mutex);
-	old_thresh = ACCESS_ONCE(watchdog_thresh);
-	old_enabled = ACCESS_ONCE(watchdog_user_enabled);
-	old_hardlockup = watchdog_hardlockup_detector_is_enabled();
-
-	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
-	if (err || !write)
-		goto out;
-
-	set_sample_period();
-	/*
-	 * Watchdog threads shouldn't be enabled if they are
-	 * disabled. The 'watchdog_running' variable check in
-	 * watchdog_*_all_cpus() function takes care of this.
-	 */
-	if (watchdog_user_enabled && watchdog_thresh) {
-		/*
-		 * Prevent a change in watchdog_thresh accidentally overriding
-		 * the enablement of the hardlockup detector.
-		 */
-		if (watchdog_user_enabled != old_enabled)
-			watchdog_enable_hardlockup_detector(true);
-		err = watchdog_enable_all_cpus(old_thresh != watchdog_thresh);
-	} else
-		watchdog_disable_all_cpus();
-
-	/* Restore old values on failure */
-	if (err) {
-		watchdog_thresh = old_thresh;
-		watchdog_user_enabled = old_enabled;
-		watchdog_enable_hardlockup_detector(old_hardlockup);
-	}
-out:
-	mutex_unlock(&watchdog_proc_mutex);
-	return err;
-}
 #endif /* CONFIG_SYSCTL */
 
 void __init lockup_detector_init(void)
 {
 	set_sample_period();
 
-	if (watchdog_user_enabled)
+	if (watchdog_enabled)
 		watchdog_enable_all_cpus(false);
 }
_

Patches currently in -mm which might be from uobergfe@redhat.com are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: +
 watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism.patch
 added to -mm tree
Date: Mon, 23 Feb 2015 13:20:51 -0800
Message-ID: <54eb99b3.tl6tjT/PY1SzWWbd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbbBWVUw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 16:20:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: enable the new user interface of the watchdog mechanism
has been added to the -mm tree.  Its filename is
     watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    2 -
 kernel/sysctl.c     |   35 ++++++++++++------
 kernel/watchdog.c   |   81 ++++++++----------------------------------
 3 files changed, 40 insertions(+), 78 deletions(-)

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
 
@@ -526,6 +520,10 @@ static int watchdog_nmi_enable(unsigned
 	struct perf_event_attr *wd_attr;
 	struct perf_event *event = per_cpu(watchdog_ev, cpu);
 
+	/* nothing to do if the hard lockup detector is disabled */
+	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
+		goto out;
+
 	/*
 	 * Some kernels need to default hard lockup detection to
 	 * 'disabled', for example a guest on a hypervisor.
@@ -844,59 +842,12 @@ out:
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

watchdog-new-definitions-and-variables-initialization.patch
watchdog-introduce-the-proc_watchdog_update-function.patch
watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog.patch
watchdog-introduce-the-proc_watchdog_common-function.patch
watchdog-introduce-separate-handlers-for-parameters-in-proc-sys-kernel.patch
watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events.patch
watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism.patch
watchdog-clean-up-some-function-names-and-arguments.patch
watchdog-introduce-the-hardlockup_detector_disable-function.patch


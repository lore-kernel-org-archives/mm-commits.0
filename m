From: akpm@linux-foundation.org
Subject: + watchdog-control-hard-lockup-detection-default.patch added to
 -mm tree
Date: Wed, 13 Aug 2014 15:28:48 -0700
Message-ID: <53ebe6a0.Odo7tHjWgbtbRv8l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:60886 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaHMW2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 18:28:49 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so131160pde.5
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 15:28:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, drjones@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: control hard lockup detection default
has been added to the -mm tree.  Its filename is
     watchdog-control-hard-lockup-detection-default.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-control-hard-lockup-detection-default.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-control-hard-lockup-detection-default.patch

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
Subject: kernel/watchdog.c: control hard lockup detection default

In some cases we don't want hard lockup detection enabled by default.  An
example is when running as a guest.  Introduce

  watchdog_enable_hardlockup_detector(bool)

allowing those cases to disable hard lockup detection.  This must be
executed early by the boot processor from e.g.  smp_prepare_boot_cpu, in
order to allow kernel command line arguments to override it, as well as to
avoid hard lockup detection being enabled before we've had a chance to
indicate that it's unwanted.  In summary,

  initial boot:					default=enabled
  smp_prepare_boot_cpu
    watchdog_enable_hardlockup_detector(false):	default=disabled
  cmdline has 'nmi_watchdog=1':			default=enabled

The running kernel still has the ability to enable/disable at any time
with /proc/sys/kernel/nmi_watchdog us usual.  However even when the
default has been overridden /proc/sys/kernel/nmi_watchdog will initially
show '1'.  To truly turn it on one must disable/enable it, i.e.

  echo 0 > /proc/sys/kernel/nmi_watchdog
  echo 1 > /proc/sys/kernel/nmi_watchdog

This patch will be immediately useful for KVM with the next patch of this
series.  Other hypervisor guest types may find it useful as well.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    9 +++++++
 kernel/watchdog.c   |   50 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 57 insertions(+), 2 deletions(-)

diff -puN include/linux/nmi.h~watchdog-control-hard-lockup-detection-default include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-control-hard-lockup-detection-default
+++ a/include/linux/nmi.h
@@ -17,11 +17,20 @@
 #if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
 #include <asm/nmi.h>
 extern void touch_nmi_watchdog(void);
+extern void watchdog_enable_hardlockup_detector(bool val);
+extern bool watchdog_hardlockup_detector_is_enabled(void);
 #else
 static inline void touch_nmi_watchdog(void)
 {
 	touch_softlockup_watchdog();
 }
+static inline void watchdog_enable_hardlockup_detector(bool)
+{
+}
+static inline bool watchdog_hardlockup_detector_is_enabled(void)
+{
+	return true;
+}
 #endif
 
 /*
diff -puN kernel/watchdog.c~watchdog-control-hard-lockup-detection-default kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-control-hard-lockup-detection-default
+++ a/kernel/watchdog.c
@@ -59,6 +59,25 @@ static unsigned long soft_lockup_nmi_war
 static int hardlockup_panic =
 			CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE;
 
+static bool hardlockup_detector_enabled = true;
+/*
+ * We may not want to enable hard lockup detection by default in all cases,
+ * for example when running the kernel as a guest on a hypervisor. In these
+ * cases this function can be called to disable hard lockup detection. This
+ * function should only be executed once by the boot processor before the
+ * kernel command line parameters are parsed, because otherwise it is not
+ * possible to override this in hardlockup_panic_setup().
+ */
+void watchdog_enable_hardlockup_detector(bool val)
+{
+	hardlockup_detector_enabled = val;
+}
+
+bool watchdog_hardlockup_detector_is_enabled(void)
+{
+	return hardlockup_detector_enabled;
+}
+
 static int __init hardlockup_panic_setup(char *str)
 {
 	if (!strncmp(str, "panic", 5))
@@ -67,6 +86,14 @@ static int __init hardlockup_panic_setup
 		hardlockup_panic = 0;
 	else if (!strncmp(str, "0", 1))
 		watchdog_user_enabled = 0;
+	else if (!strncmp(str, "1", 1) || !strncmp(str, "2", 1)) {
+		/*
+		 * Setting 'nmi_watchdog=1' or 'nmi_watchdog=2' (legacy option)
+		 * has the same effect.
+		 */
+		watchdog_user_enabled = 1;
+		watchdog_enable_hardlockup_detector(true);
+	}
 	return 1;
 }
 __setup("nmi_watchdog=", hardlockup_panic_setup);
@@ -465,6 +492,15 @@ static int watchdog_nmi_enable(unsigned
 	struct perf_event_attr *wd_attr;
 	struct perf_event *event = per_cpu(watchdog_ev, cpu);
 
+	/*
+	 * Some kernels need to default hard lockup detection to
+	 * 'disabled', for example a guest on a hypervisor.
+	 */
+	if (!watchdog_hardlockup_detector_is_enabled()) {
+		event = ERR_PTR(-ENOENT);
+		goto handle_err;
+	}
+
 	/* is it already setup and enabled? */
 	if (event && event->state > PERF_EVENT_STATE_OFF)
 		goto out;
@@ -479,6 +515,7 @@ static int watchdog_nmi_enable(unsigned
 	/* Try to register using hardware perf events */
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
 
+handle_err:
 	/* save cpu0 error for future comparision */
 	if (cpu == 0 && IS_ERR(event))
 		cpu0_err = PTR_ERR(event);
@@ -624,11 +661,13 @@ int proc_dowatchdog(struct ctl_table *ta
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int err, old_thresh, old_enabled;
+	bool old_hardlockup;
 	static DEFINE_MUTEX(watchdog_proc_mutex);
 
 	mutex_lock(&watchdog_proc_mutex);
 	old_thresh = ACCESS_ONCE(watchdog_thresh);
 	old_enabled = ACCESS_ONCE(watchdog_user_enabled);
+	old_hardlockup = watchdog_hardlockup_detector_is_enabled();
 
 	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 	if (err || !write)
@@ -640,15 +679,22 @@ int proc_dowatchdog(struct ctl_table *ta
 	 * disabled. The 'watchdog_running' variable check in
 	 * watchdog_*_all_cpus() function takes care of this.
 	 */
-	if (watchdog_user_enabled && watchdog_thresh)
+	if (watchdog_user_enabled && watchdog_thresh) {
+		/*
+		 * Prevent a change in watchdog_thresh accidentally overriding
+		 * the enablement of the hardlockup detector.
+		 */
+		if (watchdog_user_enabled != old_enabled)
+			watchdog_enable_hardlockup_detector(true);
 		err = watchdog_enable_all_cpus(old_thresh != watchdog_thresh);
-	else
+	} else
 		watchdog_disable_all_cpus();
 
 	/* Restore old values on failure */
 	if (err) {
 		watchdog_thresh = old_thresh;
 		watchdog_user_enabled = old_enabled;
+		watchdog_enable_hardlockup_detector(old_hardlockup);
 	}
 out:
 	mutex_unlock(&watchdog_proc_mutex);
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-fix-print-once-on-enable.patch
watchdog-control-hard-lockup-detection-default.patch
kvm-ensure-hard-lockup-detection-is-disabled-by-default.patch


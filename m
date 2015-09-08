From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-rename-watchdog_suspend-and-watchdog_resume.patch removed from -mm tree
Date: Tue, 08 Sep 2015 11:03:22 -0700
Message-ID: <55ef22ea.eMEzYQYNN0TrphIt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbIHSDX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:03:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, a.p.zijlstra@chello.nl, atomlin@redhat.com, cmetcalf@ezchip.com, dzickus@redhat.com, eranian@google.com, fweisbec@gmail.com, jolsa@kernel.org, linux@roeck-us.net, mhocko@suse.cz, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: rename watchdog_suspend() and watchdog_resume()
has been removed from the -mm tree.  Its filename was
     watchdog-rename-watchdog_suspend-and-watchdog_resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: rename watchdog_suspend() and watchdog_resume()

Rename watchdog_suspend() to lockup_detector_suspend() and
watchdog_resume() to lockup_detector_resume() to avoid confusion with the
watchdog subsystem and to be consistent with the existing name
lockup_detector_init().

Also provide comment blocks to explain the watchdog_running and
watchdog_suspended variables and their relationship.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Stephane Eranian <eranian@google.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/perf_event_intel.c |    4 +--
 include/linux/nmi.h                    |    8 +++----
 kernel/watchdog.c                      |   26 +++++++++++++++++++----
 3 files changed, 28 insertions(+), 10 deletions(-)

diff -puN arch/x86/kernel/cpu/perf_event_intel.c~watchdog-rename-watchdog_suspend-and-watchdog_resume arch/x86/kernel/cpu/perf_event_intel.c
--- a/arch/x86/kernel/cpu/perf_event_intel.c~watchdog-rename-watchdog_suspend-and-watchdog_resume
+++ a/arch/x86/kernel/cpu/perf_event_intel.c
@@ -3627,7 +3627,7 @@ static __init int fixup_ht_bug(void)
 		return 0;
 	}
 
-	if (watchdog_suspend() != 0) {
+	if (lockup_detector_suspend() != 0) {
 		pr_debug("failed to disable PMU erratum BJ122, BV98, HSD29 workaround\n");
 		return 0;
 	}
@@ -3638,7 +3638,7 @@ static __init int fixup_ht_bug(void)
 	x86_pmu.commit_scheduling = NULL;
 	x86_pmu.stop_scheduling = NULL;
 
-	watchdog_resume();
+	lockup_detector_resume();
 
 	get_online_cpus();
 
diff -puN include/linux/nmi.h~watchdog-rename-watchdog_suspend-and-watchdog_resume include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-rename-watchdog_suspend-and-watchdog_resume
+++ a/include/linux/nmi.h
@@ -78,15 +78,15 @@ extern int proc_watchdog_thresh(struct c
 				void __user *, size_t *, loff_t *);
 extern int proc_watchdog_cpumask(struct ctl_table *, int,
 				 void __user *, size_t *, loff_t *);
-extern int watchdog_suspend(void);
-extern void watchdog_resume(void);
+extern int lockup_detector_suspend(void);
+extern void lockup_detector_resume(void);
 #else
-static inline int watchdog_suspend(void)
+static inline int lockup_detector_suspend(void)
 {
 	return 0;
 }
 
-static inline void watchdog_resume(void)
+static inline void lockup_detector_resume(void)
 {
 }
 #endif
diff -puN kernel/watchdog.c~watchdog-rename-watchdog_suspend-and-watchdog_resume kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-rename-watchdog_suspend-and-watchdog_resume
+++ a/kernel/watchdog.c
@@ -67,8 +67,26 @@ unsigned long *watchdog_cpumask_bits = c
 #define for_each_watchdog_cpu(cpu) \
 	for_each_cpu_and((cpu), cpu_online_mask, &watchdog_cpumask)
 
-static int __read_mostly watchdog_suspended;
+/*
+ * The 'watchdog_running' variable is set to 1 when the watchdog threads
+ * are registered/started and is set to 0 when the watchdog threads are
+ * unregistered/stopped, so it is an indicator whether the threads exist.
+ */
 static int __read_mostly watchdog_running;
+/*
+ * If a subsystem has a need to deactivate the watchdog temporarily, it
+ * can use the suspend/resume interface to achieve this. The content of
+ * the 'watchdog_suspended' variable reflects this state. Existing threads
+ * are parked/unparked by the lockup_detector_{suspend|resume} functions
+ * (see comment blocks pertaining to those functions for further details).
+ *
+ * 'watchdog_suspended' also prevents threads from being registered/started
+ * or unregistered/stopped via parameters in /proc/sys/kernel, so the state
+ * of 'watchdog_running' cannot change while the watchdog is deactivated
+ * temporarily (see related code in 'proc' handlers).
+ */
+static int __read_mostly watchdog_suspended;
+
 static u64 __read_mostly sample_period;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
@@ -669,7 +687,7 @@ static void watchdog_unpark_threads(void
 /*
  * Suspend the hard and soft lockup detector by parking the watchdog threads.
  */
-int watchdog_suspend(void)
+int lockup_detector_suspend(void)
 {
 	int ret = 0;
 
@@ -679,7 +697,7 @@ int watchdog_suspend(void)
 	 * the 'watchdog_suspended' variable). If the watchdog threads are
 	 * running, the first caller takes care that they will be parked.
 	 * The state of 'watchdog_running' cannot change while a suspend
-	 * request is active (see related changes in 'proc' handlers).
+	 * request is active (see related code in 'proc' handlers).
 	 */
 	if (watchdog_running && !watchdog_suspended)
 		ret = watchdog_park_threads();
@@ -695,7 +713,7 @@ int watchdog_suspend(void)
 /*
  * Resume the hard and soft lockup detector by unparking the watchdog threads.
  */
-void watchdog_resume(void)
+void lockup_detector_resume(void)
 {
 	mutex_lock(&watchdog_proc_mutex);
 
_

Patches currently in -mm which might be from uobergfe@redhat.com are



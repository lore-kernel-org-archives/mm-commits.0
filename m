From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-use-suspend-resume-interface-in-fixup_ht_bug.patch removed from
 -mm tree
Date: Tue, 08 Sep 2015 11:03:19 -0700
Message-ID: <55ef22e7.X+nsjjfGR7DWWGvA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbIHSDU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:03:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, a.p.zijlstra@chello.nl, atomlin@redhat.com, cmetcalf@ezchip.com, dzickus@redhat.com, eranian@google.com, fweisbec@gmail.com, jolsa@kernel.org, linux@roeck-us.net, mhocko@suse.cz, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: use suspend/resume interface in fixup_ht_bug()
has been removed from the -mm tree.  Its filename was
     watchdog-use-suspend-resume-interface-in-fixup_ht_bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: use suspend/resume interface in fixup_ht_bug()

Remove watchdog_nmi_disable_all() and watchdog_nmi_enable_all() since
these functions are no longer needed.  If a subsystem has a need to
deactivate the watchdog temporarily, it should utilize the
watchdog_suspend() and watchdog_resume() functions.

[akpm@linux-foundation.org: fix build with CONFIG_LOCKUP_DETECTOR=m]
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

 arch/x86/kernel/cpu/perf_event_intel.c |    7 +++-
 include/linux/nmi.h                    |   13 +++++---
 kernel/watchdog.c                      |   35 -----------------------
 3 files changed, 14 insertions(+), 41 deletions(-)

diff -puN arch/x86/kernel/cpu/perf_event_intel.c~watchdog-use-suspend-resume-interface-in-fixup_ht_bug arch/x86/kernel/cpu/perf_event_intel.c
--- a/arch/x86/kernel/cpu/perf_event_intel.c~watchdog-use-suspend-resume-interface-in-fixup_ht_bug
+++ a/arch/x86/kernel/cpu/perf_event_intel.c
@@ -3627,7 +3627,10 @@ static __init int fixup_ht_bug(void)
 		return 0;
 	}
 
-	watchdog_nmi_disable_all();
+	if (watchdog_suspend() != 0) {
+		pr_debug("failed to disable PMU erratum BJ122, BV98, HSD29 workaround\n");
+		return 0;
+	}
 
 	x86_pmu.flags &= ~(PMU_FL_EXCL_CNTRS | PMU_FL_EXCL_ENABLED);
 
@@ -3635,7 +3638,7 @@ static __init int fixup_ht_bug(void)
 	x86_pmu.commit_scheduling = NULL;
 	x86_pmu.stop_scheduling = NULL;
 
-	watchdog_nmi_enable_all();
+	watchdog_resume();
 
 	get_online_cpus();
 
diff -puN include/linux/nmi.h~watchdog-use-suspend-resume-interface-in-fixup_ht_bug include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-use-suspend-resume-interface-in-fixup_ht_bug
+++ a/include/linux/nmi.h
@@ -26,12 +26,8 @@ static inline void touch_nmi_watchdog(vo
 
 #if defined(CONFIG_HARDLOCKUP_DETECTOR)
 extern void hardlockup_detector_disable(void);
-void watchdog_nmi_disable_all(void);
-void watchdog_nmi_enable_all(void);
 #else
 static inline void hardlockup_detector_disable(void) {}
-static inline void watchdog_nmi_disable_all(void) {}
-static inline void watchdog_nmi_enable_all(void) {}
 #endif
 
 /*
@@ -84,6 +80,15 @@ extern int proc_watchdog_cpumask(struct
 				 void __user *, size_t *, loff_t *);
 extern int watchdog_suspend(void);
 extern void watchdog_resume(void);
+#else
+static inline int watchdog_suspend(void)
+{
+	return 0;
+}
+
+static inline void watchdog_resume(void)
+{
+}
 #endif
 
 #ifdef CONFIG_HAVE_ACPI_APEI_NMI
diff -puN kernel/watchdog.c~watchdog-use-suspend-resume-interface-in-fixup_ht_bug kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-use-suspend-resume-interface-in-fixup_ht_bug
+++ a/kernel/watchdog.c
@@ -615,41 +615,6 @@ static void watchdog_nmi_disable(unsigne
 	}
 }
 
-void watchdog_nmi_enable_all(void)
-{
-	int cpu;
-
-	mutex_lock(&watchdog_proc_mutex);
-
-	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
-		goto unlock;
-
-	get_online_cpus();
-	for_each_watchdog_cpu(cpu)
-		watchdog_nmi_enable(cpu);
-	put_online_cpus();
-
-unlock:
-	mutex_unlock(&watchdog_proc_mutex);
-}
-
-void watchdog_nmi_disable_all(void)
-{
-	int cpu;
-
-	mutex_lock(&watchdog_proc_mutex);
-
-	if (!watchdog_running)
-		goto unlock;
-
-	get_online_cpus();
-	for_each_watchdog_cpu(cpu)
-		watchdog_nmi_disable(cpu);
-	put_online_cpus();

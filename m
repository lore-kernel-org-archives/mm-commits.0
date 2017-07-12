From: akpm@linux-foundation.org
Subject: [patch 56/96] kernel/watchdog: provide
 watchdog_nmi_reconfigure() for arch watchdogs
Date: Wed, 12 Jul 2017 14:35:49 -0700
Message-ID: <20170712213549.i5dbwcu04%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752710AbdGLVf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, babu.moger@oracle.com, benh@kernel.crashing.org, dzickus@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com, paulus@samba.org, torvalds@linux-foundation.org

From: Nicholas Piggin <npiggin@gmail.com>
Subject: kernel/watchdog: provide watchdog_nmi_reconfigure() for arch watchdogs

After reconfiguring watchdog sysctls etc., architecture specific watchdogs
may not get all their parameters updated.

watchdog_nmi_reconfigure() can be implemented to pull the new values in
and set the arch NMI watchdog.

[npiggin@gmail.com: add code comments]
  Link: http://lkml.kernel.org/r/20170617125933.774d3858@roar.ozlabs.ibm.com
[arnd@arndb.de: hide unused function]
  Link: http://lkml.kernel.org/r/20170620204854.966601-1-arnd@arndb.de
Link: http://lkml.kernel.org/r/20170616065715.18390-5-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Don Zickus <dzickus@redhat.com>
Tested-by: Babu Moger <babu.moger@oracle.com>	[sparc]
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   48 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff -puN kernel/watchdog.c~watchdog-provide-watchdog_reconfigure-for-arch-watchdogs kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-provide-watchdog_reconfigure-for-arch-watchdogs
+++ a/kernel/watchdog.c
@@ -114,6 +114,10 @@ int __read_mostly watchdog_suspended;
 /*
  * These functions can be overridden if an architecture implements its
  * own hardlockup detector.
+ *
+ * watchdog_nmi_enable/disable can be implemented to start and stop when
+ * softlockup watchdog threads start and stop. The arch must select the
+ * SOFTLOCKUP_DETECTOR Kconfig.
  */
 int __weak watchdog_nmi_enable(unsigned int cpu)
 {
@@ -123,6 +127,22 @@ void __weak watchdog_nmi_disable(unsigne
 {
 }
 
+/*
+ * watchdog_nmi_reconfigure can be implemented to be notified after any
+ * watchdog configuration change. The arch hardlockup watchdog should
+ * respond to the following variables:
+ * - nmi_watchdog_enabled
+ * - watchdog_thresh
+ * - watchdog_cpumask
+ * - sysctl_hardlockup_all_cpu_backtrace
+ * - hardlockup_panic
+ * - watchdog_suspended
+ */
+void __weak watchdog_nmi_reconfigure(void)
+{
+}
+
+
 #ifdef CONFIG_SOFTLOCKUP_DETECTOR
 
 /* Helper for online, unparked cpus. */
@@ -600,6 +620,14 @@ static void watchdog_disable_all_cpus(vo
 	}
 }
 
+#ifdef CONFIG_SYSCTL
+static int watchdog_update_cpus(void)
+{
+	return smpboot_update_cpumask_percpu_thread(
+		    &watchdog_threads, &watchdog_cpumask);
+}
+#endif
+
 #else /* SOFTLOCKUP */
 static int watchdog_park_threads(void)
 {
@@ -619,6 +647,13 @@ static void watchdog_disable_all_cpus(vo
 {
 }
 
+#ifdef CONFIG_SYSCTL
+static int watchdog_update_cpus(void)
+{
+	return 0;
+}
+#endif
+
 static void set_sample_period(void)
 {
 }
@@ -651,6 +686,8 @@ int lockup_detector_suspend(void)
 		watchdog_enabled = 0;
 	}
 
+	watchdog_nmi_reconfigure();
+
 	mutex_unlock(&watchdog_proc_mutex);
 
 	return ret;
@@ -671,6 +708,8 @@ void lockup_detector_resume(void)
 	if (watchdog_running && !watchdog_suspended)
 		watchdog_unpark_threads();
 
+	watchdog_nmi_reconfigure();
+
 	mutex_unlock(&watchdog_proc_mutex);
 	put_online_cpus();
 }
@@ -696,6 +735,8 @@ static int proc_watchdog_update(void)
 	else
 		watchdog_disable_all_cpus();
 
+	watchdog_nmi_reconfigure();
+
 	return err;
 
 }
@@ -881,12 +922,11 @@ int proc_watchdog_cpumask(struct ctl_tab
 			 * a temporary cpumask, so we are likely not in a
 			 * position to do much else to make things better.
 			 */
-#ifdef CONFIG_SOFTLOCKUP_DETECTOR
-			if (smpboot_update_cpumask_percpu_thread(
-				    &watchdog_threads, &watchdog_cpumask) != 0)
+			if (watchdog_update_cpus() != 0)
 				pr_err("cpumask update failed\n");
-#endif
 		}
+
+		watchdog_nmi_reconfigure();
 	}
 out:
 	mutex_unlock(&watchdog_proc_mutex);
_

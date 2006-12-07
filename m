From: akpm@osdl.org
Subject: - handle-per-subsystem-mutexes-for-config_hotplug_cpu-not-set.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:07:19 -0800
Message-ID: <200612072307.kB7N7JKR030352@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52772 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163817AbWLGXH3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Handle per-subsystem mutexes for CONFIG_HOTPLUG_CPU not set
has been removed from the -mm tree.  Its filename was
     handle-per-subsystem-mutexes-for-config_hotplug_cpu-not-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Handle per-subsystem mutexes for CONFIG_HOTPLUG_CPU not set
From: Gautham R Shenoy <ego@in.ibm.com>

Provide a common interface for all the subsystems to lock and unlock their
per-subsystem hotcpu mutexes.

When CONFIG_HOTPLUG_CPU is not set, these operations would be no-ops.

[akpm@osdl.org: macros -> inlines]
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/cpu.h |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff -puN include/linux/cpu.h~handle-per-subsystem-mutexes-for-config_hotplug_cpu-not-set include/linux/cpu.h
--- a/include/linux/cpu.h~handle-per-subsystem-mutexes-for-config_hotplug_cpu-not-set
+++ a/include/linux/cpu.h
@@ -24,6 +24,7 @@
 #include <linux/compiler.h>
 #include <linux/cpumask.h>
 #include <asm/semaphore.h>
+#include <linux/mutex.h>
 
 struct cpu {
 	int node_id;		/* The node which contains the CPU */
@@ -74,6 +75,17 @@ extern struct sysdev_class cpu_sysdev_cl
 
 #ifdef CONFIG_HOTPLUG_CPU
 /* Stop CPUs going up and down. */
+
+static inline void cpuhotplug_mutex_lock(struct mutex *cpu_hp_mutex)
+{
+	mutex_lock(cpu_hp_mutex);
+}
+
+static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
+{
+	mutex_unlock(cpu_hp_mutex);
+}
+
 extern void lock_cpu_hotplug(void);
 extern void unlock_cpu_hotplug(void);
 #define hotcpu_notifier(fn, pri) {				\
@@ -85,7 +97,14 @@ extern void unlock_cpu_hotplug(void);
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
 int cpu_down(unsigned int cpu);
 #define cpu_is_offline(cpu) unlikely(!cpu_online(cpu))
-#else
+
+#else		/* CONFIG_HOTPLUG_CPU */
+
+static inline void cpuhotplug_mutex_lock(struct mutex *cpu_hp_mutex)
+{ }
+static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
+{ }
+
 #define lock_cpu_hotplug()	do { } while (0)
 #define unlock_cpu_hotplug()	do { } while (0)
 #define lock_cpu_hotplug_interruptible() 0
@@ -95,7 +114,7 @@ int cpu_down(unsigned int cpu);
 
 /* CPUs don't go offline once they're online w/o CONFIG_HOTPLUG_CPU */
 static inline int cpu_is_offline(int cpu) { return 0; }
-#endif
+#endif		/* CONFIG_HOTPLUG_CPU */
 
 #ifdef CONFIG_SUSPEND_SMP
 extern int disable_nonboot_cpus(void);
_

Patches currently in -mm which might be from ego@in.ibm.com are

origin.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
git-cpufreq.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
handle-cpu_lock_acquire-and-cpu_lock_release-in-workqueue_cpu_callback.patch


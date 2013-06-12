From: akpm@linux-foundation.org
Subject: [folded-merged]
 cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-v11.patch removed from -mm tree
Date: Wed, 12 Jun 2013 13:56:46 -0700
Message-ID: <51b8e08e.ozn4GbAhNvZ4yjR0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab3FLU4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jun 2013 16:56:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holt@sgi.com, srivatsa.bhat@linux.vnet.ibm.com

Subject: [folded-merged] cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-v11.patch removed from -mm tree
To: srivatsa.bhat@linux.vnet.ibm.com,holt@sgi.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 12 Jun 2013 13:56:46 -0700


The patch titled
     Subject: cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-v11
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-v11.patch

This patch was dropped because it was folded into cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch

------------------------------------------------------
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-v11

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |   18 ++++--------------
 kernel/cpu.c        |   42 +++++++++++++++++++++---------------------
 2 files changed, 25 insertions(+), 35 deletions(-)

diff -puN include/linux/cpu.h~cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-v11 include/linux/cpu.h
--- a/include/linux/cpu.h~cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-v11
+++ a/include/linux/cpu.h
@@ -167,20 +167,6 @@ static inline void cpu_maps_update_done(
 }
 
 #endif /* CONFIG_SMP */
-
-#ifdef CONFIG_PM_SLEEP_SMP
-extern void cpu_hotplug_enable(void);
-extern void cpu_hotplug_disable(void);
-#else
-static inline void cpu_hotplug_enable(void)
-{
-}
-
-static inline void cpu_hotplug_disable(void)
-{
-}
-#endif
-
 extern struct bus_type cpu_subsys;
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -188,6 +174,8 @@ extern struct bus_type cpu_subsys;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
+extern void cpu_hotplug_disable(void);
+extern void cpu_hotplug_enable(void);
 #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
@@ -211,6 +199,8 @@ static inline void cpu_hotplug_driver_un
 
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
+#define cpu_hotplug_disable()	do { } while (0)
+#define cpu_hotplug_enable()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff -puN kernel/cpu.c~cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-v11 kernel/cpu.c
--- a/kernel/cpu.c~cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-v11
+++ a/kernel/cpu.c
@@ -133,6 +133,27 @@ static void cpu_hotplug_done(void)
 	mutex_unlock(&cpu_hotplug.lock);
 }
 
+/*
+ * Wait for currently running CPU hotplug operations to complete (if any) and
+ * disable future CPU hotplug (from sysfs). The 'cpu_add_remove_lock' protects
+ * the 'cpu_hotplug_disabled' flag. The same lock is also acquired by the
+ * hotplug path before performing hotplug operations. So acquiring that lock
+ * guarantees mutual exclusion from any currently running hotplug operations.
+ */
+void cpu_hotplug_disable(void)
+{
+	cpu_maps_update_begin();
+	cpu_hotplug_disabled = 1;
+	cpu_maps_update_done();
+}
+
+void cpu_hotplug_enable(void)
+{
+	cpu_maps_update_begin();
+	cpu_hotplug_disabled = 0;
+	cpu_maps_update_done();
+}
+
 #else /* #if CONFIG_HOTPLUG_CPU */
 static void cpu_hotplug_begin(void) {}
 static void cpu_hotplug_done(void) {}
@@ -541,27 +562,6 @@ static int __init alloc_frozen_cpus(void
 core_initcall(alloc_frozen_cpus);
 
 /*
- * Wait for currently running CPU hotplug operations to complete (if any) and
- * disable future CPU hotplug (from sysfs). The 'cpu_add_remove_lock' protects
- * the 'cpu_hotplug_disabled' flag. The same lock is also acquired by the
- * hotplug path before performing hotplug operations. So acquiring that lock
- * guarantees mutual exclusion from any currently running hotplug operations.
- */
-void cpu_hotplug_disable(void)
-{
-	cpu_maps_update_begin();
-	cpu_hotplug_disabled = 1;
-	cpu_maps_update_done();
-}
-
-void cpu_hotplug_enable(void)
-{
-	cpu_maps_update_begin();
-	cpu_hotplug_disabled = 0;
-	cpu_maps_update_done();
-}

From: akpm@linux-foundation.org
Subject: +
 cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-v11.patch added to -mm tree
Date: Mon, 20 May 2013 13:15:25 -0700
Message-ID: <519a845d.3g9fj0ZYu39fXs9l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab3ETUP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 16:15:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holt@sgi.com, srivatsa.bhat@linux.vnet.ibm.com

Subject: + cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-v11.patch added to -mm tree
To: srivatsa.bhat@linux.vnet.ibm.com,holt@sgi.com
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 13:15:25 -0700


The patch titled
     Subject: cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-v11
has been added to the -mm tree.  Its filename is
     cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-v11.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -168,20 +168,6 @@ static inline void cpu_maps_update_done(
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
@@ -189,6 +175,8 @@ extern struct bus_type cpu_subsys;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
+extern void cpu_hotplug_disable(void);
+extern void cpu_hotplug_enable(void);
 #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
@@ -212,6 +200,8 @@ static inline void cpu_hotplug_driver_un
 
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

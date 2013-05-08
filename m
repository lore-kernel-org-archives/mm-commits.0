From: akpm@linux-foundation.org
Subject: + cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch added to -mm tree
Date: Wed, 08 May 2013 13:39:22 -0700
Message-ID: <20130508203923.0076931C082__4341.25800752572$1368045581$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:62402 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3EHUjY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 16:39:24 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so221716qen.0
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 13:39:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srivatsa.bhat@linux.vnet.ibm.com, gxt@mprc.pku.edu.cn, holt@sgi.com, hpa@zytor.com, linux@arm.linux.org.uk, mingo@elte.hu, rja@sgi.com, shawn.guo@linaro.org, stable@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: CPU hotplug: provide a generic helper to disable/enable CPU hotplug
has been added to the -mm tree.  Its filename is
     cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch

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
Subject: CPU hotplug: provide a generic helper to disable/enable CPU hotplug

There are instances in the kernel where we would like to disable CPU
hotplug (from sysfs) during some important operation.  Today the freezer
code depends on this and the code to do it was kinda tailor-made for that.

Restructure the code and make it generic enough to be useful for
other usecases too.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |    3 +++
 kernel/cpu.c        |   27 +++++++++------------------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff -puN include/linux/cpu.h~cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug include/linux/cpu.h
--- a/include/linux/cpu.h~cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug
+++ a/include/linux/cpu.h
@@ -141,6 +141,8 @@ static inline void unregister_cpu_notifi
 }
 #endif
 
+extern void cpu_hotplug_disable(void);
+extern void cpu_hotplug_enable(void);
 int cpu_up(unsigned int cpu);
 void notify_cpu_starting(unsigned int cpu);
 extern void cpu_maps_update_begin(void);
@@ -148,6 +150,7 @@ extern void cpu_maps_update_done(void);
 
 #else	/* CONFIG_SMP */
 
+#define cpu_hotplug_disable()	do { } while (0)
 #define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 
 static inline int register_cpu_notifier(struct notifier_block *nb)
diff -puN kernel/cpu.c~cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug kernel/cpu.c
--- a/kernel/cpu.c~cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug
+++ a/kernel/cpu.c
@@ -541,29 +541,20 @@ static int __init alloc_frozen_cpus(void
 core_initcall(alloc_frozen_cpus);
 
 /*
- * Prevent regular CPU hotplug from racing with the freezer, by disabling CPU
- * hotplug when tasks are about to be frozen. Also, don't allow the freezer
- * to continue until any currently running CPU hotplug operation gets
- * completed.
- * To modify the 'cpu_hotplug_disabled' flag, we need to acquire the
- * 'cpu_add_remove_lock'. And this same lock is also taken by the regular
- * CPU hotplug path and released only after it is complete. Thus, we
- * (and hence the freezer) will block here until any currently running CPU
- * hotplug operation gets completed.
+ * Wait for currently running CPU hotplug operations to complete (if any) and
+ * disable future CPU hotplug (from sysfs). The 'cpu_add_remove_lock' protects
+ * the 'cpu_hotplug_disabled' flag. The same lock is also acquired by the
+ * hotplug path before performing hotplug operations. So acquiring that lock
+ * guarantees mutual exclusion from any currently running hotplug operations.
  */
-void cpu_hotplug_disable_before_freeze(void)
+void cpu_hotplug_disable(void)
 {
 	cpu_maps_update_begin();
 	cpu_hotplug_disabled = 1;
 	cpu_maps_update_done();
 }
 
-
-/*
- * When tasks have been thawed, re-enable regular CPU hotplug (which had been
- * disabled while beginning to freeze tasks).
- */
-void cpu_hotplug_enable_after_thaw(void)
+void cpu_hotplug_enable(void)
 {
 	cpu_maps_update_begin();
 	cpu_hotplug_disabled = 0;
@@ -589,12 +580,12 @@ cpu_hotplug_pm_callback(struct notifier_
 
 	case PM_SUSPEND_PREPARE:
 	case PM_HIBERNATION_PREPARE:
-		cpu_hotplug_disable_before_freeze();
+		cpu_hotplug_disable();
 		break;
 
 	case PM_POST_SUSPEND:
 	case PM_POST_HIBERNATION:
-		cpu_hotplug_enable_after_thaw();
+		cpu_hotplug_enable();
 		break;
 
 	default:
_

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

origin.patch
linux-next.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch
migrate-shutdown-reboot-to-boot-cpu.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch


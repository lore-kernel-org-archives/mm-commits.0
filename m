From: akpm@linux-foundation.org
Subject: + cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch added to -mm tree
Date: Wed, 24 Apr 2013 15:04:18 -0700
Message-ID: <20130424220418.EC54431C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:54834 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416Ab3DXWEU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 18:04:20 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so6885ggc.2
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 15:04:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srivatsa.bhat@linux.vnet.ibm.com, holt@sgi.com, hpa@zytor.com, mingo@redhat.com, rja@sgi.com, stable@vger.kernel.org


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

We recently noticed that reboot of a 1024 cpu machine takes approx 16
minutes of just stopping the cpus.  The slowdown was tracked to commit
f96972f ("kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()").

The current implementation does all the work of hot removing the cpus
before halting the system.  We are switching to just migrating to the
reboot_cpu and then continuing with shutdown/reboot.

The patch set is broken into five parts.  The first two are planned for
the stable release.  The others move the halt/shutdown/reboot related
functions to their own kernel/reboot.c file and then introduce the kernel
boot parameter.


This patch:

There are instances in the kernel where we would like to disable CPU
hotplug (from sysfs) during some important operation.  Today the freezer
code depends on this and the code to do it was kinda tailor-made for that.

Restructure the code and make it generic enough to be useful for
other usecases too.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |    2 ++
 kernel/cpu.c        |   27 +++++++++------------------
 2 files changed, 11 insertions(+), 18 deletions(-)

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

linux-next.patch
kthread-introduce-to_live_kthread.patch
kthread-kill-task_get_live_kthread.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
mm-rewrite-the-comment-over-migrate_pages-more-comprehensibly.patch
numa-cpu-hotplug-change-links-of-cpu-and-node-when-changing-node-number-by-onlining-cpu.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch


From: akpm@linux-foundation.org
Subject: - pm-separate-hibernation-code-from-suspend-code-fix.patch removed from -mm tree
Date: Fri, 04 May 2007 23:18:15 -0700
Message-ID: <200705050618.l456IJt3029721@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423117AbXEEGSh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 May 2007 02:18:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     PM: Separate hibernation code from suspend code (fix)
has been removed from the -mm tree.  Its filename was
     pm-separate-hibernation-code-from-suspend-code-fix.patch

This patch was dropped because it was folded into pm-separate-hibernation-code-from-suspend-code.patch

------------------------------------------------------
Subject: PM: Separate hibernation code from suspend code (fix)
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove unnecessary comments in include/linux/suspend.h and  add a comment
describing hibernation_set_ops() in kernel/power/disk.c .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/suspend.h |    8 --------
 kernel/power/disk.c     |    5 +++++
 2 files changed, 5 insertions(+), 8 deletions(-)

diff -puN include/linux/suspend.h~pm-separate-hibernation-code-from-suspend-code-fix include/linux/suspend.h
--- a/include/linux/suspend.h~pm-separate-hibernation-code-from-suspend-code-fix
+++ a/include/linux/suspend.h
@@ -58,15 +58,7 @@ extern void swsusp_set_page_free(struct 
 extern void swsusp_unset_page_free(struct page *);
 extern unsigned long get_safe_page(gfp_t gfp_mask);
 
-/**
- * hibernation_set_ops - set the global hibernate operations
- * @ops: the hibernation operations to use in subsequent hibernation transitions
- */
 extern void hibernation_set_ops(struct hibernation_ops *ops);
-
-/**
- * hibernate - hibernate the system
- */
 extern int hibernate(void);
 #else
 static inline void register_nosave_region(unsigned long b, unsigned long e) {}
diff -puN kernel/power/disk.c~pm-separate-hibernation-code-from-suspend-code-fix kernel/power/disk.c
--- a/kernel/power/disk.c~pm-separate-hibernation-code-from-suspend-code-fix
+++ a/kernel/power/disk.c
@@ -47,6 +47,11 @@ enum {
 
 struct hibernation_ops *hibernation_ops;
 
+/**
+ * hibernation_set_ops - set the global hibernate operations
+ * @ops: the hibernation operations to use in subsequent hibernation transitions
+ */
+
 void hibernation_set_ops(struct hibernation_ops *ops)
 {
 	if (ops && !(ops->prepare && ops->enter && ops->finish)) {
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
fix-refrigerator-vs-thaw_process-race.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
freezer-remove-pf_nofreeze-from-handle_initrd.patch
swsusp-use-rbtree-for-tracking-allocated-swap.patch
freezer-fix-racy-usage-of-try_to_freeze-in-kswapd.patch
remove-software_suspend.patch
power-management-change-sys-power-disk-display.patch
kconfig-mentioneds-hibernation-not-just-swsusp.patch
swsusp-fix-snapshot_release.patch
swsusp-free-more-memory.patch
pm-separate-hibernation-code-from-suspend-code.patch
pm-separate-hibernation-code-from-suspend-code-fix.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
remvoe-kthread_bind-call-from-_cpu_down.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
add-suspend-related-notifications-for-cpu-hotplug.patch
add-suspend-related-notifications-for-cpu-hotplug-cleanup.patch
microcode-use-suspend-related-cpu-hotplug-notifications.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch

From: akpm@linux-foundation.org
Subject: + swsusp-free-more-memory.patch added to -mm tree
Date: Sun, 22 Apr 2007 17:37:58 -0700
Message-ID: <200704230037.l3N0bwsA004228@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030307AbXDWAi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 20:38:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz


The patch titled
     swsusp: free more memory
has been added to the -mm tree.  Its filename is
     swsusp-free-more-memory.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: swsusp: free more memory
From: Rafael J. Wysocki <rjw@sisk.pl>

Move the definition of PAGES_FOR_IO to kernel/power/power.h and introduce
SPARE_PAGES representing the number of pages that should be freed by the
swsusp's memory shrinker in addition to PAGES_FOR_IO so that device drivers
can allocate some memory (up to 1 MB total) in their .suspend() routines
without causing the suspend to fail.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/suspend.h |    6 ------
 kernel/power/power.h    |   12 +++++++++++-
 kernel/power/swsusp.c   |    2 +-
 3 files changed, 12 insertions(+), 8 deletions(-)

diff -puN include/linux/suspend.h~swsusp-free-more-memory include/linux/suspend.h
--- a/include/linux/suspend.h~swsusp-free-more-memory
+++ a/include/linux/suspend.h
@@ -52,10 +52,4 @@ struct saved_context;
 void __save_processor_state(struct saved_context *ctxt);
 void __restore_processor_state(struct saved_context *ctxt);
 
-/*
- * XXX: We try to keep some more pages free so that I/O operations succeed
- * without paging. Might this be more?
- */
-#define PAGES_FOR_IO	1024
-
 #endif /* _LINUX_SWSUSP_H */
diff -puN kernel/power/power.h~swsusp-free-more-memory kernel/power/power.h
--- a/kernel/power/power.h~swsusp-free-more-memory
+++ a/kernel/power/power.h
@@ -14,8 +14,18 @@ struct swsusp_info {
 
 
 #ifdef CONFIG_SOFTWARE_SUSPEND
-extern int pm_suspend_disk(void);
+/*
+ * Keep some memory free so that I/O operations can succeed without paging
+ * [Might this be more than 4 MB?]
+ */
+#define PAGES_FOR_IO	((4096 * 1024) >> PAGE_SHIFT)
+/*
+ * Keep 1 MB of memory free so that device drivers can allocate some pages in
+ * their .suspend() routines without breaking the suspend to disk.
+ */
+#define SPARE_PAGES	((1024 * 1024) >> PAGE_SHIFT)
 
+extern int pm_suspend_disk(void);
 #else
 static inline int pm_suspend_disk(void)
 {
diff -puN kernel/power/swsusp.c~swsusp-free-more-memory kernel/power/swsusp.c
--- a/kernel/power/swsusp.c~swsusp-free-more-memory
+++ a/kernel/power/swsusp.c
@@ -233,7 +233,7 @@ int swsusp_shrink_memory(void)
 		long size, highmem_size;
 
 		highmem_size = count_highmem_pages();
-		size = count_data_pages() + PAGES_FOR_IO;
+		size = count_data_pages() + PAGES_FOR_IO + SPARE_PAGES;
 		tmp = size;
 		size += highmem_size;
 		for_each_zone (zone)
_

Patches currently in -mm which might be from rjw@sisk.pl are

fix-refrigerator-vs-thaw_process-race.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
swsusp-fix-error-paths-in-snapshot_open.patch
swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-force-pm_opsvalid-callback-to-be.patch
freezer-remove-pf_nofreeze-from-handle_initrd.patch
swsusp-use-rbtree-for-tracking-allocated-swap.patch
freezer-fix-racy-usage-of-try_to_freeze-in-kswapd.patch
remove-software_suspend.patch
power-management-change-sys-power-disk-display.patch
kconfig-mentioneds-hibernation-not-just-swsusp.patch
swsusp-fix-snapshot_release.patch
swsusp-free-more-memory.patch
pm-introduce-suspend-notifiers-rev-2.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race.patch
freezer-document-task_lock-in-thaw_process.patch
add-suspend-related-notifications-for-cpu-hotplug.patch
microcode-use-suspend-related-cpu-hotplug-notifications.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch

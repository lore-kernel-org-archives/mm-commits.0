From: akpm@linux-foundation.org
Subject: - swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch removed from -mm tree
Date: Mon, 07 May 2007 17:05:21 -0700
Message-ID: <200705080005.l4805LEM009090@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755191AbXEHAGG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: use GFP_KERNEL for creating basic data structures
has been removed from the -mm tree.  Its filename was
     swsusp-use-gfp_kernel-for-creating-basic-data-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: use GFP_KERNEL for creating basic data structures
From: Rafael J. Wysocki <rjw@sisk.pl>

Make swsusp call create_basic_memory_bitmaps() before processes are frozen, so
that GFP_KERNEL allocations can be made in it.  Additionally, ensure that the
swsusp's userland interface won't be used while either pm_suspend_disk() or
software_resume() is being executed.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c     |   37 ++++++++++++++++++++++++++-----------
 kernel/power/power.h    |    3 +++
 kernel/power/snapshot.c |    8 ++++----
 kernel/power/user.c     |   10 +++++-----
 4 files changed, 38 insertions(+), 20 deletions(-)

diff -puN kernel/power/disk.c~swsusp-use-gfp_kernel-for-creating-basic-data-structures kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-use-gfp_kernel-for-creating-basic-data-structures
+++ a/kernel/power/disk.c
@@ -130,28 +130,33 @@ int pm_suspend_disk(void)
 {
 	int error;
 
+	/* The snapshot device should not be opened while we're running */
+	if (!atomic_add_unless(&snapshot_device_available, -1, 0))
+		return -EBUSY;
+
+	/* Allocate memory management structures */
+	error = create_basic_memory_bitmaps();
+	if (error)
+		goto Exit;
+
 	error = prepare_processes();
 	if (error)
-		return error;
+		goto Finish;
 
 	if (pm_disk_mode == PM_DISK_TESTPROC) {
 		printk("swsusp debug: Waiting for 5 seconds.\n");
 		mdelay(5000);
 		goto Thaw;
 	}
-	/* Allocate memory management structures */
-	error = create_basic_memory_bitmaps();
-	if (error)
-		goto Thaw;
 
 	/* Free memory before shutting down devices. */
 	error = swsusp_shrink_memory();
 	if (error)
-		goto Finish;
+		goto Thaw;
 
 	error = platform_prepare();
 	if (error)
-		goto Finish;
+		goto Thaw;
 
 	suspend_console();
 	error = device_suspend(PMSG_FREEZE);
@@ -186,7 +191,7 @@ int pm_suspend_disk(void)
 			power_down();
 		else {
 			swsusp_free();
-			goto Finish;
+			goto Thaw;
 		}
 	} else {
 		pr_debug("PM: Image restored successfully.\n");
@@ -199,10 +204,12 @@ int pm_suspend_disk(void)
 	platform_finish();
 	device_resume();
 	resume_console();
- Finish:
-	free_basic_memory_bitmaps();
  Thaw:
 	unprepare_processes();
+ Finish:
+	free_basic_memory_bitmaps();
+ Exit:
+	atomic_inc(&snapshot_device_available);
 	return error;
 }
 
@@ -250,9 +257,15 @@ static int software_resume(void)
 	if (error)
 		goto Unlock;
 
+	/* The snapshot device should not be opened while we're running */
+	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
+		error = -EBUSY;
+		goto Unlock;
+	}
+
 	error = create_basic_memory_bitmaps();
 	if (error)
-		goto Unlock;
+		goto Finish;
 
 	pr_debug("PM: Preparing processes for restore.\n");
 	error = prepare_processes();
@@ -290,6 +303,8 @@ static int software_resume(void)
 	unprepare_processes();
  Done:
 	free_basic_memory_bitmaps();
+ Finish:
+	atomic_inc(&snapshot_device_available);
 	/* For success case, the suspend path will release the lock */
  Unlock:
 	mutex_unlock(&pm_mutex);
diff -puN kernel/power/power.h~swsusp-use-gfp_kernel-for-creating-basic-data-structures kernel/power/power.h
--- a/kernel/power/power.h~swsusp-use-gfp_kernel-for-creating-basic-data-structures
+++ a/kernel/power/power.h
@@ -140,6 +140,9 @@ struct resume_swap_area {
 #define PMOPS_ENTER	2
 #define PMOPS_FINISH	3
 
+/* If unset, the snapshot device cannot be open. */
+extern atomic_t snapshot_device_available;
+
 /**
  *	The bitmap is used for tracing allocated swap pages
  *
diff -puN kernel/power/snapshot.c~swsusp-use-gfp_kernel-for-creating-basic-data-structures kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~swsusp-use-gfp_kernel-for-creating-basic-data-structures
+++ a/kernel/power/snapshot.c
@@ -723,19 +723,19 @@ int create_basic_memory_bitmaps(void)
 
 	BUG_ON(forbidden_pages_map || free_pages_map);
 
-	bm1 = kzalloc(sizeof(struct memory_bitmap), GFP_ATOMIC);
+	bm1 = kzalloc(sizeof(struct memory_bitmap), GFP_KERNEL);
 	if (!bm1)
 		return -ENOMEM;
 
-	error = memory_bm_create(bm1, GFP_ATOMIC | __GFP_COLD, PG_ANY);
+	error = memory_bm_create(bm1, GFP_KERNEL, PG_ANY);
 	if (error)
 		goto Free_first_object;
 
-	bm2 = kzalloc(sizeof(struct memory_bitmap), GFP_ATOMIC);
+	bm2 = kzalloc(sizeof(struct memory_bitmap), GFP_KERNEL);
 	if (!bm2)
 		goto Free_first_bitmap;
 
-	error = memory_bm_create(bm2, GFP_ATOMIC | __GFP_COLD, PG_ANY);
+	error = memory_bm_create(bm2, GFP_KERNEL, PG_ANY);
 	if (error)
 		goto Free_second_object;
 
diff -puN kernel/power/user.c~swsusp-use-gfp_kernel-for-creating-basic-data-structures kernel/power/user.c
--- a/kernel/power/user.c~swsusp-use-gfp_kernel-for-creating-basic-data-structures
+++ a/kernel/power/user.c
@@ -40,21 +40,21 @@ static struct snapshot_data {
 	char platform_suspend;
 } snapshot_state;
 
-static atomic_t device_available = ATOMIC_INIT(1);
+atomic_t snapshot_device_available = ATOMIC_INIT(1);
 
 static int snapshot_open(struct inode *inode, struct file *filp)
 {
 	struct snapshot_data *data;
 
-	if (!atomic_add_unless(&device_available, -1, 0))
+	if (!atomic_add_unless(&snapshot_device_available, -1, 0))
 		return -EBUSY;
 
 	if ((filp->f_flags & O_ACCMODE) == O_RDWR) {
-		atomic_inc(&device_available);
+		atomic_inc(&snapshot_device_available);
 		return -ENOSYS;
 	}
 	if(create_basic_memory_bitmaps()) {
-		atomic_inc(&device_available);
+		atomic_inc(&snapshot_device_available);
 		return -ENOMEM;
 	}
 	nonseekable_open(inode, filp);
@@ -92,7 +92,7 @@ static int snapshot_release(struct inode
 		enable_nonboot_cpus();
 		mutex_unlock(&pm_mutex);
 	}
-	atomic_inc(&device_available);
+	atomic_inc(&snapshot_device_available);
 	return 0;
 }
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
swsusp-clean-up-print.patch
pm-separate-hibernation-code-from-suspend-code.patch
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

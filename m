From: akpm@linux-foundation.org
Subject: - swsusp-remove-code-duplication-between-diskc-and-userc.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:01 -0700
Message-ID: <200707192000.l6JK01JL019390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761308AbXGSU1O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:27:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: remove code duplication between disk.c and user.c
has been removed from the -mm tree.  Its filename was
     swsusp-remove-code-duplication-between-diskc-and-userc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: remove code duplication between disk.c and user.c
From: Rafael J. Wysocki <rjw@sisk.pl>

Currently, much of the code in kernel/power/disk.c is duplicated in
kernel/power/user.c , mainly for historical reasons.  By eliminating this code
duplication we can reduce the size of user.c quite substantially and remove
the maintenance difficulty resulting from it.

[bunk@stusta.de: kernel/power/disk.c: make code static]
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c  |  184 +++++++++++++++++++++++------------------
 kernel/power/power.h |    5 -
 kernel/power/user.c  |   96 +--------------------
 3 files changed, 115 insertions(+), 170 deletions(-)

diff -puN kernel/power/disk.c~swsusp-remove-code-duplication-between-diskc-and-userc kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-remove-code-duplication-between-diskc-and-userc
+++ a/kernel/power/disk.c
@@ -45,7 +45,7 @@ enum {
 
 static int hibernation_mode = HIBERNATION_SHUTDOWN;
 
-struct hibernation_ops *hibernation_ops;
+static struct hibernation_ops *hibernation_ops;
 
 /**
  * hibernation_set_ops - set the global hibernate operations
@@ -74,9 +74,9 @@ void hibernation_set_ops(struct hibernat
  *	platform driver if so configured and return an error code if it fails
  */
 
-static int platform_prepare(void)
+static int platform_prepare(int platform_mode)
 {
-	return (hibernation_mode == HIBERNATION_PLATFORM && hibernation_ops) ?
+	return (platform_mode && hibernation_ops) ?
 		hibernation_ops->prepare() : 0;
 }
 
@@ -85,13 +85,104 @@ static int platform_prepare(void)
  *	using the platform driver (must be called after platform_prepare())
  */
 
-static void platform_finish(void)
+static void platform_finish(int platform_mode)
 {
-	if (hibernation_mode == HIBERNATION_PLATFORM && hibernation_ops)
+	if (platform_mode && hibernation_ops)
 		hibernation_ops->finish();
 }
 
 /**
+ *	hibernation_snapshot - quiesce devices and create the hibernation
+ *	snapshot image.
+ *	@platform_mode - if set, use the platform driver, if available, to
+ *			 prepare the platform frimware for the power transition.
+ *
+ *	Must be called with pm_mutex held
+ */
+
+int hibernation_snapshot(int platform_mode)
+{
+	int error;
+
+	/* Free memory before shutting down devices. */
+	error = swsusp_shrink_memory();
+	if (error)
+		goto Finish;
+
+	error = platform_prepare(platform_mode);
+	if (error)
+		goto Finish;
+
+	suspend_console();
+	error = device_suspend(PMSG_FREEZE);
+	if (error)
+		goto Resume_devices;
+
+	error = disable_nonboot_cpus();
+	if (!error) {
+		if (hibernation_mode != HIBERNATION_TEST) {
+			in_suspend = 1;
+			error = swsusp_suspend();
+			/* Control returns here after successful restore */
+		} else {
+			printk("swsusp debug: Waiting for 5 seconds.\n");
+			mdelay(5000);
+		}
+	}
+	enable_nonboot_cpus();
+ Resume_devices:
+	platform_finish(platform_mode);
+	device_resume();
+	resume_console();
+ Finish:
+	return error;
+}
+
+/**
+ *	hibernation_restore - quiesce devices and restore the hibernation
+ *	snapshot image.  If successful, control returns in hibernation_snaphot()
+ *
+ *	Must be called with pm_mutex held
+ */
+
+int hibernation_restore(void)
+{
+	int error;
+
+	pm_prepare_console();
+	suspend_console();
+	error = device_suspend(PMSG_PRETHAW);
+	if (error)
+		goto Finish;
+
+	error = disable_nonboot_cpus();
+	if (!error)
+		error = swsusp_resume();
+
+	enable_nonboot_cpus();
+ Finish:
+	device_resume();
+	resume_console();
+	pm_restore_console();
+	return error;
+}
+
+/**
+ *	hibernation_platform_enter - enter the hibernation state using the
+ *	platform driver (if available)
+ */
+
+int hibernation_platform_enter(void)
+{
+	if (hibernation_ops) {
+		kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
+		return hibernation_ops->enter();
+	} else {
+		return -ENOSYS;
+	}
+}
+
+/**
  *	power_down - Shut the machine down for hibernation.
  *
  *	Use the platform driver, if configured so; otherwise try
@@ -111,11 +202,7 @@ static void power_down(void)
 		kernel_restart(NULL);
 		break;
 	case HIBERNATION_PLATFORM:
-		if (hibernation_ops) {
-			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
-			hibernation_ops->enter();
-			break;
-		}
+		hibernation_platform_enter();
 	}
 	kernel_halt();
 	/*
@@ -171,62 +258,17 @@ int hibernate(void)
 		mdelay(5000);
 		goto Thaw;
 	}
-
-	/* Free memory before shutting down devices. */
-	error = swsusp_shrink_memory();
-	if (error)
-		goto Thaw;
-
-	error = platform_prepare();
-	if (error)
-		goto Thaw;
-
-	suspend_console();
-	error = device_suspend(PMSG_FREEZE);
-	if (error) {
-		printk(KERN_ERR "PM: Some devices failed to suspend\n");
-		goto Resume_devices;
-	}
-	error = disable_nonboot_cpus();
-	if (error)
-		goto Enable_cpus;
-
-	if (hibernation_mode == HIBERNATION_TEST) {
-		printk("swsusp debug: Waiting for 5 seconds.\n");
-		mdelay(5000);
-		goto Enable_cpus;
-	}
-
-	pr_debug("PM: snapshotting memory.\n");
-	in_suspend = 1;
-	error = swsusp_suspend();
-	if (error)
-		goto Enable_cpus;
-
-	if (in_suspend) {
-		enable_nonboot_cpus();
-		platform_finish();
-		device_resume();
-		resume_console();
+	error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
+	if (in_suspend && !error) {
 		pr_debug("PM: writing image.\n");
 		error = swsusp_write();
+		swsusp_free();
 		if (!error)
 			power_down();
-		else {
-			swsusp_free();
-			goto Thaw;
-		}
 	} else {
 		pr_debug("PM: Image restored successfully.\n");
+		swsusp_free();
 	}
-
-	swsusp_free();
- Enable_cpus:
-	enable_nonboot_cpus();
- Resume_devices:
-	platform_finish();
-	device_resume();
-	resume_console();
  Thaw:
 	mutex_unlock(&pm_mutex);
 	unprepare_processes();
@@ -301,29 +343,11 @@ static int software_resume(void)
 	pr_debug("PM: Reading swsusp image.\n");
 
 	error = swsusp_read();
-	if (error) {
-		swsusp_free();
-		goto Thaw;
-	}
-
-	pr_debug("PM: Preparing devices for restore.\n");
-
-	suspend_console();
-	error = device_suspend(PMSG_PRETHAW);
-	if (error)
-		goto Free;
-
-	error = disable_nonboot_cpus();
 	if (!error)
-		swsusp_resume();
+		hibernation_restore();
 
-	enable_nonboot_cpus();
- Free:
-	swsusp_free();
-	device_resume();
-	resume_console();
- Thaw:
 	printk(KERN_ERR "PM: Restore failed, recovering.\n");
+	swsusp_free();
 	unprepare_processes();
  Done:
 	free_basic_memory_bitmaps();
@@ -333,7 +357,7 @@ static int software_resume(void)
  Unlock:
 	mutex_unlock(&pm_mutex);
 	pr_debug("PM: Resume from disk failed.\n");
-	return 0;
+	return error;
 }
 
 late_initcall(software_resume);
diff -puN kernel/power/power.h~swsusp-remove-code-duplication-between-diskc-and-userc kernel/power/power.h
--- a/kernel/power/power.h~swsusp-remove-code-duplication-between-diskc-and-userc
+++ a/kernel/power/power.h
@@ -25,7 +25,10 @@ struct swsusp_info {
  */
 #define SPARE_PAGES	((1024 * 1024) >> PAGE_SHIFT)
 
-extern struct hibernation_ops *hibernation_ops;
+/* kernel/power/disk.c */
+extern int hibernation_snapshot(int platform_mode);
+extern int hibernation_restore(void);
+extern int hibernation_platform_enter(void);
 #endif
 
 extern int pfn_is_nosave(unsigned long);
diff -puN kernel/power/user.c~swsusp-remove-code-duplication-between-diskc-and-userc kernel/power/user.c
--- a/kernel/power/user.c~swsusp-remove-code-duplication-between-diskc-and-userc
+++ a/kernel/power/user.c
@@ -128,83 +128,6 @@ static ssize_t snapshot_write(struct fil
 	return res;
 }
 
-static inline int platform_prepare(void)
-{
-	int error = 0;
-
-	if (hibernation_ops)
-		error = hibernation_ops->prepare();
-
-	return error;
-}
-
-static inline void platform_finish(void)
-{
-	if (hibernation_ops)
-		hibernation_ops->finish();
-}
-
-static inline int snapshot_suspend(int platform_suspend)
-{
-	int error;
-
-	mutex_lock(&pm_mutex);
-	/* Free memory before shutting down devices. */
-	error = swsusp_shrink_memory();
-	if (error)
-		goto Finish;
-
-	if (platform_suspend) {
-		error = platform_prepare();
-		if (error)
-			goto Finish;
-	}
-	suspend_console();
-	error = device_suspend(PMSG_FREEZE);
-	if (error)
-		goto Resume_devices;
-
-	error = disable_nonboot_cpus();
-	if (!error) {
-		in_suspend = 1;
-		error = swsusp_suspend();
-	}
-	enable_nonboot_cpus();
- Resume_devices:
-	if (platform_suspend)
-		platform_finish();
-
-	device_resume();
-	resume_console();
- Finish:
-	mutex_unlock(&pm_mutex);
-	return error;
-}
-
-static inline int snapshot_restore(void)
-{
-	int error;
-
-	mutex_lock(&pm_mutex);
-	pm_prepare_console();
-	suspend_console();
-	error = device_suspend(PMSG_PRETHAW);
-	if (error)
-		goto Finish;
-
-	error = disable_nonboot_cpus();
-	if (!error)
-		error = swsusp_resume();
-
-	enable_nonboot_cpus();
- Finish:
-	device_resume();
-	resume_console();
-	pm_restore_console();
-	mutex_unlock(&pm_mutex);
-	return error;
-}
-
 static int snapshot_ioctl(struct inode *inode, struct file *filp,
                           unsigned int cmd, unsigned long arg)
 {
@@ -251,7 +174,7 @@ static int snapshot_ioctl(struct inode *
 			error = -EPERM;
 			break;
 		}
-		error = snapshot_suspend(data->platform_suspend);
+		error = hibernation_snapshot(data->platform_suspend);
 		if (!error)
 			error = put_user(in_suspend, (unsigned int __user *)arg);
 		if (!error)
@@ -265,7 +188,7 @@ static int snapshot_ioctl(struct inode *
 			error = -EPERM;
 			break;
 		}
-		error = snapshot_restore();
+		error = hibernation_restore();
 		break;
 
 	case SNAPSHOT_FREE:
@@ -377,19 +300,14 @@ static int snapshot_ioctl(struct inode *
 		switch (arg) {
 
 		case PMOPS_PREPARE:
-			if (hibernation_ops) {
-				data->platform_suspend = 1;
-				error = 0;
-			} else {
-				error = -ENOSYS;
-			}
+			data->platform_suspend = 1;
+			error = 0;
 			break;
 
 		case PMOPS_ENTER:
-			if (data->platform_suspend) {
-				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
-				error = hibernation_ops->enter();
-			}
+			if (data->platform_suspend)
+				error = hibernation_platform_enter();
+
 			break;
 
 		case PMOPS_FINISH:
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
acpi-implement-the-set_target-callback-from-pm_ops.patch
acpi-add-acpi_pm_device_sleep_state-helper-routine.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
shrink_slab-handle-bad-shrinkers.patch

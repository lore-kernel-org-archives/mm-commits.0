From: akpm@osdl.org
Subject: + swsusp-change-code-ordering-in-diskc.patch added to -mm tree
Date: Wed, 20 Dec 2006 22:20:12 -0800
Message-ID: <200612210620.kBL6KCqK017535@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41978 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422756AbWLUGUg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 01:20:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, greg@kroah.com, mochel@digitalimplant.org, nigel@suspend2.net, pavel@ucw.cz


The patch titled
     swsusp: Change code ordering in disk.c
has been added to the -mm tree.  Its filename is
     swsusp-change-code-ordering-in-diskc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: swsusp: Change code ordering in disk.c
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Change the ordering of code in kernel/power/disk.c so that device_suspend() is
called before disable_nonboot_cpus() and platform_finish() is called after
enable_nonboot_cpus() and before device_resume(), as indicated by the recent
discussion on Linux-PM (cf. 
http://lists.osdl.org/pipermail/linux-pm/2006-November/004164.html).

The changes here only affect the built-in swsusp.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>
Cc: Nigel Cunningham <nigel@suspend2.net>
Cc: Patrick Mochel <mochel@digitalimplant.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/cpu.c        |    2 
 kernel/power/disk.c |  110 +++++++++++++++++++++---------------------
 2 files changed, 57 insertions(+), 55 deletions(-)

diff -puN kernel/cpu.c~swsusp-change-code-ordering-in-diskc kernel/cpu.c
--- a/kernel/cpu.c~swsusp-change-code-ordering-in-diskc
+++ a/kernel/cpu.c
@@ -309,6 +309,8 @@ void enable_nonboot_cpus(void)
 	mutex_lock(&cpu_add_remove_lock);
 	cpu_hotplug_disabled = 0;
 	mutex_unlock(&cpu_add_remove_lock);
+	if (cpus_empty(frozen_cpus))
+		return;
 
 	printk("Enabling non-boot CPUs ...\n");
 	for_each_cpu_mask(cpu, frozen_cpus) {
diff -puN kernel/power/disk.c~swsusp-change-code-ordering-in-diskc kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-change-code-ordering-in-diskc
+++ a/kernel/power/disk.c
@@ -87,52 +87,24 @@ static inline void platform_finish(void)
 	}
 }
 
+static void unprepare_processes(void)
+{
+	thaw_processes();
+	pm_restore_console();
+}
+
 static int prepare_processes(void)
 {
 	int error = 0;
 
 	pm_prepare_console();
-
-	error = disable_nonboot_cpus();
-	if (error)
-		goto enable_cpus;
-
 	if (freeze_processes()) {
 		error = -EBUSY;
-		goto thaw;
+		unprepare_processes();
 	}
-
-	if (pm_disk_mode == PM_DISK_TESTPROC) {
-		printk("swsusp debug: Waiting for 5 seconds.\n");
-		mdelay(5000);
-		goto thaw;
-	}
-
-	error = platform_prepare();
-	if (error)
-		goto thaw;
-
-	/* Free memory before shutting down devices. */
-	if (!(error = swsusp_shrink_memory()))
-		return 0;
-
-	platform_finish();
- thaw:
-	thaw_processes();
- enable_cpus:
-	enable_nonboot_cpus();
-	pm_restore_console();
 	return error;
 }
 
-static void unprepare_processes(void)
-{
-	platform_finish();
-	thaw_processes();
-	enable_nonboot_cpus();
-	pm_restore_console();
-}
-
 /**
  *	pm_suspend_disk - The granpappy of hibernation power management.
  *
@@ -150,29 +122,45 @@ int pm_suspend_disk(void)
 	if (error)
 		return error;
 
-	if (pm_disk_mode == PM_DISK_TESTPROC)
-		return 0;
+	if (pm_disk_mode == PM_DISK_TESTPROC) {
+		printk("swsusp debug: Waiting for 5 seconds.\n");
+		mdelay(5000);
+		goto Thaw;
+	}
+	/* Free memory before shutting down devices. */
+	error = swsusp_shrink_memory();
+	if (error)
+		goto Thaw;
+
+	error = platform_prepare();
+	if (error)
+		goto Thaw;
 
 	suspend_console();
 	error = device_suspend(PMSG_FREEZE);
 	if (error) {
-		resume_console();
-		printk("Some devices failed to suspend\n");
-		goto Thaw;
+		printk(KERN_ERR "PM: Some devices failed to suspend\n");
+		goto Resume_devices;
 	}
+	error = disable_nonboot_cpus();
+	if (error)
+		goto Enable_cpus;
 
 	if (pm_disk_mode == PM_DISK_TEST) {
 		printk("swsusp debug: Waiting for 5 seconds.\n");
 		mdelay(5000);
-		goto Done;
+		goto Enable_cpus;
 	}
 
 	pr_debug("PM: snapshotting memory.\n");
 	in_suspend = 1;
-	if ((error = swsusp_suspend()))
-		goto Done;
+	error = swsusp_suspend();
+	if (error)
+		goto Enable_cpus;
 
 	if (in_suspend) {
+		enable_nonboot_cpus();
+		platform_finish();
 		device_resume();
 		resume_console();
 		pr_debug("PM: writing image.\n");
@@ -188,7 +176,10 @@ int pm_suspend_disk(void)
 	}
 
 	swsusp_free();
- Done:
+ Enable_cpus:
+	enable_nonboot_cpus();
+ Resume_devices:
+	platform_finish();
 	device_resume();
 	resume_console();
  Thaw:
@@ -237,41 +228,50 @@ static int software_resume(void)
 
 	pr_debug("PM: Checking swsusp image.\n");
 
-	if ((error = swsusp_check()))
+	error = swsusp_check();
+	if (error)
 		goto Done;
 
 	pr_debug("PM: Preparing processes for restore.\n");
 
-	if ((error = prepare_processes())) {
+	error = prepare_processes();
+	if (error) {
 		swsusp_close();
 		goto Done;
 	}
 
 	pr_debug("PM: Reading swsusp image.\n");
 
-	if ((error = swsusp_read())) {
+	error = swsusp_read();
+	if (error) {
 		swsusp_free();
 		goto Thaw;
 	}
 
 	pr_debug("PM: Preparing devices for restore.\n");
 
-	suspend_console();
-	if ((error = device_suspend(PMSG_PRETHAW))) {
-		resume_console();
-		printk("Some devices failed to suspend\n");
+	error = platform_prepare();
+	if (error) {
 		swsusp_free();
 		goto Thaw;
 	}
+	suspend_console();
+	error = device_suspend(PMSG_PRETHAW);
+	if (error)
+		goto Free;
 
-	mb();
+	error = disable_nonboot_cpus();
+	if (!error)
+		swsusp_resume();
 
-	pr_debug("PM: Restoring saved image.\n");
-	swsusp_resume();
-	pr_debug("PM: Restore failed, recovering.n");
+	enable_nonboot_cpus();
+ Free:
+	swsusp_free();
+	platform_finish();
 	device_resume();
 	resume_console();
  Thaw:
+	printk(KERN_ERR "PM: Restore failed, recovering.\n");
 	unprepare_processes();
  Done:
 	/* For success case, the suspend path will release the lock */
_

Patches currently in -mm which might be from rjw@sisk.pl are

fix-swapped-parameters-in-mm-vmscanc.patch
shrink_all_memory-fix-lru_pages-handling.patch
git-acpi.patch
pm-change-code-ordering-in-mainc.patch
swsusp-change-code-ordering-in-diskc.patch
swsusp-change-code-ordering-in-userc.patch
swsusp-change-code-ordering-in-userc-sanity.patch
swsusp-change-pm_ops-handling-by-userland-interface.patch
shrink_slab-handle-bad-shrinkers.patch


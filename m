From: akpm@linux-foundation.org
Subject: + pm-rework-struct-hibernation_ops.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:03:30 -0700
Message-ID: <200707180003.l6I03UC0014541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765716AbXGRADm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@ucw.cz


The patch titled
     PM: Rework struct hibernation_ops
has been added to the -mm tree.  Its filename is
     pm-rework-struct-hibernation_ops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PM: Rework struct hibernation_ops
From: Rafael J. Wysocki <rjw@sisk.pl>

During hibernation we also need to tell the ACPI core that we're going to put
the system into the S4 sleep state.  For this reason, an additional method in
'struct hibernation_ops' is needed, playing the role of set_target() in
'struct platform_suspend_operations'.  Moreover, the role of the .prepare()
method is now different, so it's better to introduce another method, that in
general may be different from .prepare(), that will be used to prepare the
platform for creating the hibernation image (.prepare() is used anyway to
notify the platform that we're going to enter the low power state after the
image has been saved).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |   12 ++++++++++-
 include/linux/suspend.h   |   38 ++++++++++++++++++++++++++++++------
 kernel/power/disk.c       |   27 +++++++++++++++++++------
 3 files changed, 64 insertions(+), 13 deletions(-)

diff -puN drivers/acpi/sleep/main.c~pm-rework-struct-hibernation_ops drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~pm-rework-struct-hibernation_ops
+++ a/drivers/acpi/sleep/main.c
@@ -199,6 +199,12 @@ static struct platform_suspend_ops acpi_
 };
 
 #ifdef CONFIG_SOFTWARE_SUSPEND
+static int acpi_hibernation_start(void)
+{
+	acpi_target_sleep_state = ACPI_STATE_S4;
+	return 0;
+}
+
 static int acpi_hibernation_prepare(void)
 {
 	return acpi_sleep_prepare(ACPI_STATE_S4);
@@ -227,6 +233,8 @@ static void acpi_hibernation_finish(void
 
 	/* reset firmware waking vector */
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
+
+	acpi_target_sleep_state = ACPI_STATE_S0;
 }
 
 static int acpi_hibernation_pre_restore(void)
@@ -244,9 +252,11 @@ static void acpi_hibernation_restore_cle
 }
 
 static struct hibernation_ops acpi_hibernation_ops = {
+	.start = acpi_hibernation_start,
+	.pre_snapshot = acpi_hibernation_prepare,
+	.finish = acpi_hibernation_finish,
 	.prepare = acpi_hibernation_prepare,
 	.enter = acpi_hibernation_enter,
-	.finish = acpi_hibernation_finish,
 	.pre_restore = acpi_hibernation_pre_restore,
 	.restore_cleanup = acpi_hibernation_restore_cleanup,
 };
diff -puN include/linux/suspend.h~pm-rework-struct-hibernation_ops include/linux/suspend.h
--- a/include/linux/suspend.h~pm-rework-struct-hibernation_ops
+++ a/include/linux/suspend.h
@@ -133,16 +133,42 @@ extern void mark_free_pages(struct zone 
  *
  * All three methods must be assigned.
  *
- * @prepare: prepare system for hibernation
- * @enter: shut down system after state has been saved to disk
- * @finish: finish/clean up after state has been reloaded
- * @pre_restore: prepare system for the restoration from a hibernation image
- * @restore_cleanup: clean up after a failing image restoration
+ * @start: Tell the platform driver that we're starting hibernation.
+ *	Called right after shrinking memory and before freezing devices.
+ *
+ * @pre_snapshot: Prepare the platform for creating the hibernation image.
+ *	Called right after devices have been frozen and before the nonboot
+ *	CPUs are disabled (runs with IRQs on).
+ *
+ * @finish: Restore the previous state of the platform after the hibernation
+ *	image has been created *or* put the platform into the normal operation
+ *	mode after the hibernation (the same method is executed in both cases).
+ *	Called right after the nonboot CPUs have been enabled and before
+ *	thawing devices (runs with IRQs on).
+ *
+ * @prepare: Prepare the platform for entering the low power state.
+ *	Called right after the hibernation image has been saved and before
+ *	devices are prepared for entering the low power state.
+ *
+ * @enter: Put the system into the low power state after the hibernation image
+ *	has been saved to disk.
+ *	Called after the nonboot CPUs have been disabled and all of the low
+ *	level devices have been shut down (runs with IRQs off).
+ *
+ * @pre_restore: Prepare system for the restoration from a hibernation image.
+ *	Called right after devices have been frozen and before the nonboot
+ *	CPUs are disabled (runs with IRQs on).
+ *
+ * @restore_cleanup: Clean up after a failing image restoration.
+ *	Called right after the nonboot CPUs have been enabled and before
+ *	thawing devices (runs with IRQs on).
  */
 struct hibernation_ops {
+	int (*start)(void);
+	int (*pre_snapshot)(void);
+	void (*finish)(void);
 	int (*prepare)(void);
 	int (*enter)(void);
-	void (*finish)(void);
 	int (*pre_restore)(void);
 	void (*restore_cleanup)(void);
 };
diff -puN kernel/power/disk.c~pm-rework-struct-hibernation_ops kernel/power/disk.c
--- a/kernel/power/disk.c~pm-rework-struct-hibernation_ops
+++ a/kernel/power/disk.c
@@ -54,8 +54,9 @@ static struct hibernation_ops *hibernati
 
 void hibernation_set_ops(struct hibernation_ops *ops)
 {
-	if (ops && !(ops->prepare && ops->enter && ops->finish
-	    && ops->pre_restore && ops->restore_cleanup)) {
+	if (ops && !(ops->start && ops->pre_snapshot && ops->finish
+	    && ops->prepare && ops->enter && ops->pre_restore
+	    && ops->restore_cleanup)) {
 		WARN_ON(1);
 		return;
 	}
@@ -69,16 +70,26 @@ void hibernation_set_ops(struct hibernat
 	mutex_unlock(&pm_mutex);
 }
 
+/**
+ *	platform_start - tell the platform driver that we're starting
+ *	hibernation
+ */
+
+static int platform_start(int platform_mode)
+{
+	return (platform_mode && hibernation_ops) ?
+		hibernation_ops->start() : 0;
+}
 
 /**
- *	platform_prepare - prepare the machine for hibernation using the
+ *	platform_pre_snapshot - prepare the machine for hibernation using the
  *	platform driver if so configured and return an error code if it fails
  */
 
-static int platform_prepare(int platform_mode)
+static int platform_pre_snapshot(int platform_mode)
 {
 	return (platform_mode && hibernation_ops) ?
-		hibernation_ops->prepare() : 0;
+		hibernation_ops->pre_snapshot() : 0;
 }
 
 /**
@@ -135,12 +146,16 @@ int hibernation_snapshot(int platform_mo
 	if (error)
 		return error;
 
+	error = platform_start(platform_mode);
+	if (error)
+		return error;
+
 	suspend_console();
 	error = device_suspend(PMSG_FREEZE);
 	if (error)
 		goto Resume_console;
 
-	error = platform_prepare(platform_mode);
+	error = platform_pre_snapshot(platform_mode);
 	if (error)
 		goto Resume_devices;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
pm-reduce-code-duplication-between-mainc-and-userc-updated.patch
acpi-do-not-prepare-for-hibernation-in-acpi_shutdown.patch
pm-introduce-pm_power_off_prepare.patch
pm-optional-beeping-during-resume-from-suspend-to-ram.patch
pm-integrate-beeping-flag-with-existing-acpi_sleep-flags.patch
pm-remove-deprecated-sysfs-files.patch
pm-remove-deprecated-dpm_runtime_-routines.patch
suspend-maintainers-update.patch
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

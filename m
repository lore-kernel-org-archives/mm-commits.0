From: akpm@linux-foundation.org
Subject: + acpi-implement-the-set_target-callback-from-pm_ops.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:03:15 -0700
Message-ID: <200707180003.l6I03FQj014516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43080 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765606AbXGRADl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:03:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, lenb@kernel.org, pavel@ucw.cz


The patch titled
     ACPI: Implement the set_target() callback from pm_ops
has been added to the -mm tree.  Its filename is
     acpi-implement-the-set_target-callback-from-pm_ops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: Implement the set_target() callback from pm_ops
From: Rafael J. Wysocki <rjw@sisk.pl>

In the future some drivers may need to use ACPI to determine the low power
states in which to place their devices, but to provide the drivers with this
information the ACPI core needs to know what sleep state the system is going
to enter.  Namely, the device's state should not be too high power for given
system sleep state and, if the device is supposed to be able to wake up the
system, its state should not be too low power for the wake up to be possible).
 For this purpose, the ACPI core needs to implement the set_target() method in
'struct pm_ops' and store the target system sleep state passed by the PM core
in a variable.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |   84 ++++++++++++++++++++++--------------
 1 files changed, 52 insertions(+), 32 deletions(-)

diff -puN drivers/acpi/sleep/main.c~acpi-implement-the-set_target-callback-from-pm_ops drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-implement-the-set_target-callback-from-pm_ops
+++ a/drivers/acpi/sleep/main.c
@@ -34,34 +34,54 @@ static u32 acpi_suspend_states[] = {
 
 static int init_8259A_after_S1;
 
+extern int acpi_sleep_prepare(u32 acpi_state);
+extern void acpi_power_off(void);
+
+static u32 acpi_target_sleep_state = ACPI_STATE_S0;
+
+/**
+ *	acpi_pm_set_target - Set the target system sleep state to the state
+ *		associated with given @pm_state, if supported.
+ */
+
+static int acpi_pm_set_target(suspend_state_t pm_state)
+{
+	u32 acpi_state = acpi_suspend_states[pm_state];
+	int error = 0;
+
+	if (sleep_states[acpi_state]) {
+		acpi_target_sleep_state = acpi_state;
+	} else {
+		printk(KERN_ERR "ACPI does not support this state: %d\n",
+			pm_state);
+		error = -ENOSYS;
+	}
+	return error;
+}
+
 /**
  *	acpi_pm_prepare - Do preliminary suspend work.
- *	@pm_state:		suspend state we're entering.
+ *	@pm_state: ignored
  *
- *	Make sure we support the state. If we do, and we need it, set the
- *	firmware waking vector and do arch-specific nastiness to get the 
- *	wakeup code to the waking vector. 
+ *	If necessary, set the firmware waking vector and do arch-specific
+ *	nastiness to get the wakeup code to the waking vector.
  */
 
-extern int acpi_sleep_prepare(u32 acpi_state);
-extern void acpi_power_off(void);
-
 static int acpi_pm_prepare(suspend_state_t pm_state)
 {
-	u32 acpi_state = acpi_suspend_states[pm_state];
+	int error = acpi_sleep_prepare(acpi_target_sleep_state);
 
-	if (!sleep_states[acpi_state]) {
-		printk("acpi_pm_prepare does not support %d \n", pm_state);
-		return -EPERM;
-	}
-	return acpi_sleep_prepare(acpi_state);
+	if (error)
+		acpi_target_sleep_state = ACPI_STATE_S0;
+
+	return error;
 }
 
 /**
  *	acpi_pm_enter - Actually enter a sleep state.
- *	@pm_state:		State we're entering.
+ *	@pm_state: ignored
  *
- *	Flush caches and go to sleep. For STR or STD, we have to call 
+ *	Flush caches and go to sleep. For STR or S2, we have to call
  *	arch-specific assembly, which in turn call acpi_enter_sleep_state().
  *	It's unfortunate, but it works. Please fix if you're feeling frisky.
  */
@@ -70,31 +90,32 @@ static int acpi_pm_enter(suspend_state_t
 {
 	acpi_status status = AE_OK;
 	unsigned long flags = 0;
-	u32 acpi_state = acpi_suspend_states[pm_state];
+	u32 acpi_state = acpi_target_sleep_state;
 
 	ACPI_FLUSH_CPU_CACHE();
 
 	/* Do arch specific saving of state. */
-	if (pm_state > PM_SUSPEND_STANDBY) {
+	if (acpi_state == ACPI_STATE_S2 || acpi_state == ACPI_STATE_S3) {
 		int error = acpi_save_state_mem();
-		if (error)
+
+		if (error) {
+			acpi_target_sleep_state = ACPI_STATE_S0;
 			return error;
+		}
 	}
 
 	local_irq_save(flags);
 	acpi_enable_wakeup_device(acpi_state);
-	switch (pm_state) {
-	case PM_SUSPEND_STANDBY:
+	switch (acpi_state) {
+	case ACPI_STATE_S1:
 		barrier();
 		status = acpi_enter_sleep_state(acpi_state);
 		break;
 
-	case PM_SUSPEND_MEM:
+	case ACPI_STATE_S2:
+	case ACPI_STATE_S3:
 		do_suspend_lowlevel();
 		break;
-
-	default:
-		return -EINVAL;
 	}
 
 	/* ACPI 3.0 specs (P62) says that it's the responsabilty
@@ -107,12 +128,8 @@ static int acpi_pm_enter(suspend_state_t
 	local_irq_restore(flags);
 	printk(KERN_DEBUG "Back to C!\n");
 
-	/* restore processor state
-	 * We should only be here if we're coming back from STR or STD.
-	 * And, in the case of the latter, the memory image should have already
-	 * been loaded from disk.
-	 */
-	if (pm_state > PM_SUSPEND_STANDBY)
+	/* restore processor state */
+	if (acpi_state == ACPI_STATE_S2 || acpi_state == ACPI_STATE_S3)
 		acpi_restore_state_mem();
 
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
@@ -120,7 +137,7 @@ static int acpi_pm_enter(suspend_state_t
 
 /**
  *	acpi_pm_finish - Finish up suspend sequence.
- *	@pm_state:		State we're coming out of.
+ *	@pm_state: ignored
  *
  *	This is called after we wake back up (or if entering the sleep state
  *	failed). 
@@ -128,7 +145,7 @@ static int acpi_pm_enter(suspend_state_t
 
 static int acpi_pm_finish(suspend_state_t pm_state)
 {
-	u32 acpi_state = acpi_suspend_states[pm_state];
+	u32 acpi_state = acpi_target_sleep_state;
 
 	acpi_leave_sleep_state(acpi_state);
 	acpi_disable_wakeup_device(acpi_state);
@@ -136,6 +153,8 @@ static int acpi_pm_finish(suspend_state_
 	/* reset firmware waking vector */
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
 
+	acpi_target_sleep_state = ACPI_STATE_S0;
+
 	if (init_8259A_after_S1) {
 		printk("Broken toshiba laptop -> kicking interrupts\n");
 		init_8259A(0);
@@ -176,6 +195,7 @@ static int acpi_pm_state_valid(suspend_s
 
 static struct pm_ops acpi_pm_ops = {
 	.valid = acpi_pm_state_valid,
+	.set_target = acpi_pm_set_target,
 	.prepare = acpi_pm_prepare,
 	.enter = acpi_pm_enter,
 	.finish = acpi_pm_finish,
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

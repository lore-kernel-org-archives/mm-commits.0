From: akpm@linux-foundation.org
Subject: + acpi-suspend-call-_pts-before-suspending-devices.patch added to -mm tree
Date: Mon, 07 Jan 2008 16:14:43 -0800
Message-ID: <200801080014.m080EiB6019368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754266AbYAHAP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 19:15:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl


The patch titled
     ACPI suspend: Call _PTS before suspending devices
has been added to the -mm tree.  Its filename is
     acpi-suspend-call-_pts-before-suspending-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ACPI suspend: Call _PTS before suspending devices
From: Rafael J. Wysocki <rjw@sisk.pl>

The ACPI 1.0 specification wants us to put devices into low power states after
executing the _PTS global control method, while ACPI 2.0 and later want us to
do that in the reverse order.  The current suspend code follows ACPI 2.0 in
that respect which causes some ACPI 1.0x systems to hang during suspend (ref. 
http://bugzilla.kernel.org/show_bug.cgi?id=9528).

Make the suspend code execute _PTS before putting devices into low power
states (ie.  in accordance with ACPI 1.0x) and provide a command line option
to override the default if need be.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 ++
 drivers/acpi/sleep/main.c           |   51 +++++++++++++++++++-------
 2 files changed, 43 insertions(+), 13 deletions(-)

diff -puN Documentation/kernel-parameters.txt~acpi-suspend-call-_pts-before-suspending-devices Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~acpi-suspend-call-_pts-before-suspending-devices
+++ a/Documentation/kernel-parameters.txt
@@ -167,6 +167,11 @@ and is between 256 and 4096 characters. 
 	acpi_irq_isa=	[HW,ACPI] If irq_balance, mark listed IRQs used by ISA
 			Format: <irq>,<irq>...
 
+	acpi_new_pts_ordering [HW,ACPI]
+			Enforce the ACPI 2.0 ordering of the _PTS control
+			method wrt putting devices into low power states
+			default: pre ACPI 2.0 ordering of _PTS
+
 	acpi_no_auto_ssdt	[HW,ACPI] Disable automatic loading of SSDT
 
 	acpi_os_name=	[HW,ACPI] Tell ACPI BIOS the name of the OS
diff -puN drivers/acpi/sleep/main.c~acpi-suspend-call-_pts-before-suspending-devices drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-suspend-call-_pts-before-suspending-devices
+++ a/drivers/acpi/sleep/main.c
@@ -26,6 +26,21 @@ u8 sleep_states[ACPI_S_STATE_COUNT];
 
 #ifdef CONFIG_PM_SLEEP
 static u32 acpi_target_sleep_state = ACPI_STATE_S0;
+static bool acpi_sleep_finish_wake_up;
+
+/*
+ * ACPI 2.0 and later want us to execute _PTS after suspending devices, so we
+ * allow the user to request that behavior by using the 'acpi_new_pts_ordering'
+ * kernel command line option that causes the following variable to be set.
+ */
+static bool new_pts_ordering;
+
+static int __init acpi_new_pts_ordering(char *str)
+{
+	new_pts_ordering = true;
+	return 1;
+}
+__setup("acpi_new_pts_ordering", acpi_new_pts_ordering);
 #endif
 
 static int acpi_sleep_prepare(u32 acpi_state)
@@ -74,6 +89,14 @@ static int acpi_pm_begin(suspend_state_t
 
 	if (sleep_states[acpi_state]) {
 		acpi_target_sleep_state = acpi_state;
+		if (new_pts_ordering)
+			return 0;
+
+		error = acpi_sleep_prepare(acpi_state);
+		if (error)
+			acpi_target_sleep_state = ACPI_STATE_S0;
+		else
+			acpi_sleep_finish_wake_up = true;
 	} else {
 		printk(KERN_ERR "ACPI does not support this state: %d\n",
 			pm_state);
@@ -91,15 +114,17 @@ static int acpi_pm_begin(suspend_state_t
 
 static int acpi_pm_prepare(void)
 {
-	int error;
+	if (new_pts_ordering) {
+		int error = acpi_sleep_prepare(acpi_target_sleep_state);
 
-	error = acpi_sleep_prepare(acpi_target_sleep_state);
-	if (error)
-		acpi_target_sleep_state = ACPI_STATE_S0;
-	else if (!ACPI_SUCCESS(acpi_hw_disable_all_gpes()))
-		error = -EFAULT;
+		if (error) {
+			acpi_target_sleep_state = ACPI_STATE_S0;
+			return error;
+		}
+		acpi_sleep_finish_wake_up = true;
+	}
 
-	return error;
+	return ACPI_SUCCESS(acpi_hw_disable_all_gpes()) ? 0 : -EFAULT;
 }
 
 /**
@@ -123,10 +148,8 @@ static int acpi_pm_enter(suspend_state_t
 	if (acpi_state == ACPI_STATE_S3) {
 		int error = acpi_save_state_mem();
 
-		if (error) {
-			acpi_target_sleep_state = ACPI_STATE_S0;
+		if (error)
 			return error;
-		}
 	}
 
 	local_irq_save(flags);
@@ -187,6 +210,7 @@ static void acpi_pm_finish(void)
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
 
 	acpi_target_sleep_state = ACPI_STATE_S0;
+	acpi_sleep_finish_wake_up = false;
 
 #ifdef CONFIG_X86
 	if (init_8259A_after_S1) {
@@ -203,10 +227,11 @@ static void acpi_pm_finish(void)
 static void acpi_pm_end(void)
 {
 	/*
-	 * This is necessary in case acpi_pm_finish() is not called during a
-	 * failing transition to a sleep state.
+	 * This is necessary in case acpi_pm_finish() is not called directly
+	 * during a failing transition to a sleep state.
 	 */
-	acpi_target_sleep_state = ACPI_STATE_S0;
+	if (acpi_sleep_finish_wake_up)
+		acpi_pm_finish();
 }
 
 static int acpi_pm_state_valid(suspend_state_t pm_state)
_

Patches currently in -mm which might be from rjw@sisk.pl are

git-acpi.patch
suspend-introduce-begin-and-end-callbacks.patch
acpi-separate-invocations-of-_gts-and-_bfs-from-_pts-and-_wak.patch
acpi-separate-disabling-of-gpes-from-_pts.patch
acpi-suspend-call-_pts-before-suspending-devices.patch
hibernation-introduce-begin-and-end-callbacks.patch
acpi-hibernation-call-_pts-before-suspending-devices.patch
acpi-print-message-before-calling-_pts.patch
revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
git-x86.patch
git-xfs.patch
cpufreq-initialise-default-governor-before-use.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
pnp-do-not-stop-start-devices-in-suspend-resume-path.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch

From: akpm@linux-foundation.org
Subject: + acpi-separate-disabling-of-gpes-from-_pts.patch added to -mm tree
Date: Mon, 07 Jan 2008 16:14:41 -0800
Message-ID: <200801080014.m080EfpU019365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35600 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755495AbYAHAP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 19:15:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@suse.cz


The patch titled
     ACPI: Separate disabling of GPEs from _PTS
has been added to the -mm tree.  Its filename is
     acpi-separate-disabling-of-gpes-from-_pts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ACPI: Separate disabling of GPEs from _PTS
From: Rafael J. Wysocki <rjw@sisk.pl>

The preparation to enter an ACPI system sleep state is now tied to the
disabling of GPEs, but the GPEs should not be disabled before suspending
devices.  Since on ACPI 1.0x systems the _PTS global control method should be
executed before suspending devices, we need to disable GPEs separately.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/hardware/hwsleep.c |    4 ----
 drivers/acpi/sleep/main.c       |   17 +++++++++++++++--
 2 files changed, 15 insertions(+), 6 deletions(-)

diff -puN drivers/acpi/hardware/hwsleep.c~acpi-separate-disabling-of-gpes-from-_pts drivers/acpi/hardware/hwsleep.c
--- a/drivers/acpi/hardware/hwsleep.c~acpi-separate-disabling-of-gpes-from-_pts
+++ a/drivers/acpi/hardware/hwsleep.c
@@ -229,10 +229,6 @@ acpi_status acpi_enter_sleep_state_prep(
 				"While executing method _SST"));
 	}
 
-	/* Disable/Clear all GPEs */
-
-	status = acpi_hw_disable_all_gpes();
-
 	return_ACPI_STATUS(status);
 }
 
diff -puN drivers/acpi/sleep/main.c~acpi-separate-disabling-of-gpes-from-_pts drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-separate-disabling-of-gpes-from-_pts
+++ a/drivers/acpi/sleep/main.c
@@ -91,10 +91,13 @@ static int acpi_pm_begin(suspend_state_t
 
 static int acpi_pm_prepare(void)
 {
-	int error = acpi_sleep_prepare(acpi_target_sleep_state);
+	int error;
 
+	error = acpi_sleep_prepare(acpi_target_sleep_state);
 	if (error)
 		acpi_target_sleep_state = ACPI_STATE_S0;
+	else if (!ACPI_SUCCESS(acpi_hw_disable_all_gpes()))
+		error = -EFAULT;
 
 	return error;
 }
@@ -261,7 +264,16 @@ static int acpi_hibernation_start(void)
 
 static int acpi_hibernation_prepare(void)
 {
-	return acpi_sleep_prepare(ACPI_STATE_S4);
+	int error;
+
+	error = acpi_sleep_prepare(ACPI_STATE_S4);
+	if (error)
+		return error;
+
+	if (!ACPI_SUCCESS(acpi_hw_disable_all_gpes()))
+		error = -EFAULT;
+
+	return error;
 }
 
 static int acpi_hibernation_enter(void)
@@ -426,6 +438,7 @@ static void acpi_power_off_prepare(void)
 {
 	/* Prepare to power off the system */
 	acpi_sleep_prepare(ACPI_STATE_S5);
+	acpi_hw_disable_all_gpes();
 }
 
 static void acpi_power_off(void)
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

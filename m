From: akpm@linux-foundation.org
Subject: - acpi-hibernation-call-_pts-before-suspending-devices.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:33:48 -0800
Message-ID: <200801131133.m0DBXSrj009849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353AbYAMLi4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:38:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     ACPI hibernation: Call _PTS before suspending devices
has been removed from the -mm tree.  Its filename was
     acpi-hibernation-call-_pts-before-suspending-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ACPI hibernation: Call _PTS before suspending devices
From: Rafael J. Wysocki <rjw@sisk.pl>

The ACPI 1.0 specification wants us to put devices into low power states after
executing the _PTS global control method, while ACPI 2.0 and later want us to
do that in the reverse order.  The current hibernation code follows ACPI 2.0
in that respect which may cause some ACPI 1.0x systems to hang during
hibernation (ref.  http://bugzilla.kernel.org/show_bug.cgi?id=9528).

Make the hibernation code execute _PTS before putting devices into low power
states (ie.  in accordance with ACPI 1.0x) with the possibility to override
that using the 'acpi_new_pts_ordering' kernel command line option.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |   36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff -puN drivers/acpi/sleep/main.c~acpi-hibernation-call-_pts-before-suspending-devices drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-hibernation-call-_pts-before-suspending-devices
+++ a/drivers/acpi/sleep/main.c
@@ -283,22 +283,34 @@ static struct dmi_system_id __initdata a
 #ifdef CONFIG_HIBERNATION
 static int acpi_hibernation_begin(void)
 {
+	int error;
+
 	acpi_target_sleep_state = ACPI_STATE_S4;
-	return 0;
+	if (new_pts_ordering)
+		return 0;
+
+	error = acpi_sleep_prepare(ACPI_STATE_S4);
+	if (error)
+		acpi_target_sleep_state = ACPI_STATE_S0;
+	else
+		acpi_sleep_finish_wake_up = true;
+
+	return error;
 }
 
 static int acpi_hibernation_prepare(void)
 {
-	int error;
-
-	error = acpi_sleep_prepare(ACPI_STATE_S4);
-	if (error)
-		return error;
+	if (new_pts_ordering) {
+		int error = acpi_sleep_prepare(ACPI_STATE_S4);
 
-	if (!ACPI_SUCCESS(acpi_hw_disable_all_gpes()))
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
 
 static int acpi_hibernation_enter(void)
@@ -339,15 +351,17 @@ static void acpi_hibernation_finish(void
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
 
 	acpi_target_sleep_state = ACPI_STATE_S0;
+	acpi_sleep_finish_wake_up = false;
 }
 
 static void acpi_hibernation_end(void)
 {
 	/*
 	 * This is necessary in case acpi_hibernation_finish() is not called
-	 * during a failing transition to the sleep state.
+	 * directly during a failing transition to the sleep state.
 	 */
-	acpi_target_sleep_state = ACPI_STATE_S0;
+	if (acpi_sleep_finish_wake_up)
+		acpi_hibernation_finish();
 }
 
 static int acpi_hibernation_pre_restore(void)
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
pm-acquire-device-locks-on-suspend-rev-3.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes-2.patch
git-x86.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
git-xfs.patch
cpufreq-initialise-default-governor-before-use.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
remove-obsolete-sys-devices-power-state-docs.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch

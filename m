From: akpm@linux-foundation.org
Subject: - acpi-print-message-before-calling-_pts.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:33:50 -0800
Message-ID: <200801131133.m0DBXUc1009852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60454 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbYAMLjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:39:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ACPI: Print message before calling _PTS
has been removed from the -mm tree.  Its filename was
     acpi-print-message-before-calling-_pts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ACPI: Print message before calling _PTS
From: Rafael J. Wysocki <rjw@sisk.pl>

Make acpi_sleep_prepare() static and cause it to print a message specifying
the ACPI system sleep state to be entered (helpful for debugging the
suspend/hibernation code).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/acpi/sleep/main.c~acpi-print-message-before-calling-_pts drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-print-message-before-calling-_pts
+++ a/drivers/acpi/sleep/main.c
@@ -59,6 +59,8 @@ static int acpi_sleep_prepare(u32 acpi_s
 	ACPI_FLUSH_CPU_CACHE();
 	acpi_enable_wakeup_device_prep(acpi_state);
 #endif
+	printk(KERN_INFO PREFIX "Preparing to enter system sleep state S%d\n",
+		acpi_state);
 	acpi_enter_sleep_state_prep(acpi_state);
 	return 0;
 }
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

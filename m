From: akpm@linux-foundation.org
Subject: + acpi-print-message-before-calling-_pts.patch added to -mm tree
Date: Mon, 07 Jan 2008 16:14:49 -0800
Message-ID: <200801080014.m080EnNS019383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58553 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560AbYAHAPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 19:15:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@suse.cz


The patch titled
     ACPI: Print message before calling _PTS
has been added to the -mm tree.  Its filename is
     acpi-print-message-before-calling-_pts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

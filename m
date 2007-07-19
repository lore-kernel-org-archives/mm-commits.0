From: akpm@linux-foundation.org
Subject: - swsusp-fix-hibernation-code-ordering.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:06 -0700
Message-ID: <200707192000.l6JK06JT019420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42065 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932986AbXGSU0x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:26:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: fix hibernation code ordering
has been removed from the -mm tree.  Its filename was
     swsusp-fix-hibernation-code-ordering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: fix hibernation code ordering
From: Rafael J. Wysocki <rjw@sisk.pl>

Change the code ordering so that hibernation_ops->prepare() is called after
device_suspend().  This is needed so that we don't violate the ACPI
specification, which states that the _PTS and _GTS system-control methods,
executed from acpi_sleep_prepare(), ought to be called after devices have been
put in low power states.

The "Finish" label in hibernation_restore() is moved, because device_suspend()
resumes devices if the suspending of them fails and the restore code ordering
should reflect the hibernation code ordering.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/power/disk.c~swsusp-fix-hibernation-code-ordering kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-fix-hibernation-code-ordering
+++ a/kernel/power/disk.c
@@ -133,15 +133,15 @@ int hibernation_snapshot(int platform_mo
 	/* Free memory before shutting down devices. */
 	error = swsusp_shrink_memory();
 	if (error)
-		goto Finish;
-
-	error = platform_prepare(platform_mode);
-	if (error)
-		goto Finish;
+		return error;
 
 	suspend_console();
 	error = device_suspend(PMSG_FREEZE);
 	if (error)
+		goto Resume_console;
+
+	error = platform_prepare(platform_mode);
+	if (error)
 		goto Resume_devices;
 
 	error = disable_nonboot_cpus();
@@ -159,8 +159,8 @@ int hibernation_snapshot(int platform_mo
  Resume_devices:
 	platform_finish(platform_mode);
 	device_resume();
+ Resume_console:
 	resume_console();
- Finish:
 	return error;
 }
 
@@ -191,8 +191,8 @@ int hibernation_restore(int platform_mod
 		enable_nonboot_cpus();
 	}
 	platform_restore_cleanup(platform_mode);
- Finish:
 	device_resume();
+ Finish:
 	resume_console();
 	pm_restore_console();
 	return error;
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

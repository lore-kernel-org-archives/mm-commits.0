From: akpm@linux-foundation.org
Subject: + swsusp-fix-hibernation-code-ordering.patch added to -mm tree
Date: Tue, 29 May 2007 13:53:40 -0700
Message-ID: <200705292053.l4TKreVZ011267@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752929AbXE2Ux6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 16:53:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz


The patch titled
     swsusp: fix hibernation code ordering
has been added to the -mm tree.  Its filename is
     swsusp-fix-hibernation-code-ordering.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 7 insertions(+), 7 deletions(-)

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

at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch

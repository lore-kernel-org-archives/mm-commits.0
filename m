From: akpm@linux-foundation.org
Subject: - fix-ide-ide-hpa-detect-from-resume.patch removed from -mm tree
Date: Sat, 16 Jun 2007 08:31:17 -0700
Message-ID: <200706161531.l5GFVHfN014725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757549AbXFPPbo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Jun 2007 11:31:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Resume from RAM on HPC nx6325 broken
has been removed from the -mm tree.  Its filename was
     fix-ide-ide-hpa-detect-from-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Resume from RAM on HPC nx6325 broken
From: Rafael J. Wysocki <rjw@sisk.pl>

generic_ide_resume() should check if dev->driver is not NULL before applying
to_ide_driver() to it.  Fix that.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/ide/ide.c~fix-ide-ide-hpa-detect-from-resume drivers/ide/ide.c
--- a/drivers/ide/ide.c~fix-ide-ide-hpa-detect-from-resume
+++ a/drivers/ide/ide.c
@@ -1010,7 +1010,6 @@ static int generic_ide_resume(struct dev
 {
 	ide_drive_t *drive = dev->driver_data;
 	ide_hwif_t *hwif = HWIF(drive);
-	ide_driver_t *drv = to_ide_driver(dev->driver);
 	struct request rq;
 	struct request_pm_state rqpm;
 	ide_task_t args;
@@ -1033,8 +1032,12 @@ static int generic_ide_resume(struct dev
 
 	err = ide_do_drive_cmd(drive, &rq, ide_head_wait);
 
-	if (err == 0 && drv && drv->resume)
-		drv->resume(drive);
+	if (err == 0 && dev->driver) {
+		ide_driver_t *drv = to_ide_driver(dev->driver);
+
+		if (drv->resume)
+			drv->resume(drive);
+	}
 
 	return err;
 }
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
swsusp-fix-userland-interface.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
shrink_slab-handle-bad-shrinkers.patch
beeping-patch-for-debugging-acpi-sleep.patch

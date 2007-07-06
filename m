From: akpm@linux-foundation.org
Subject: - acpi-do-not-attempt-to-run-s1-standby-workarounds-while-hibernating.patch removed from -mm tree
Date: Thu, 05 Jul 2007 17:51:48 -0700
Message-ID: <200707060051.l660pmAY028320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57396 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760888AbXGFAwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 20:52:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, lenb@kernel.org, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     acpi: do not attempt to run S1 (standby) workarounds while hibernating
has been removed from the -mm tree.  Its filename was
     acpi-do-not-attempt-to-run-s1-standby-workarounds-while-hibernating.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: acpi: do not attempt to run S1 (standby) workarounds while hibernating
From: Pavel Machek <pavel@ucw.cz>

If we have quirk "init...  after standby", we should not be calling it while
resuming from hibernation.  And...  that quirk is only ever needed on toshiba
4030cdt...  and...  noone should be using standby these days, anyway.

That quirk was certainly _not_ meant to be ran after hibernation.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/acpi/sleep/main.c~acpi-do-not-attempt-to-run-s1-standby-workarounds-while-hibernating drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-do-not-attempt-to-run-s1-standby-workarounds-while-hibernating
+++ a/drivers/acpi/sleep/main.c
@@ -210,11 +210,6 @@ static void acpi_hibernation_finish(void
 
 	/* reset firmware waking vector */
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
-
-	if (init_8259A_after_S1) {
-		printk("Broken toshiba laptop -> kicking interrupts\n");
-		init_8259A(0);
-	}
 }
 
 static struct hibernation_ops acpi_hibernation_ops = {
_

Patches currently in -mm which might be from pavel@ucw.cz are

working-3d-dri-intel-agpko-resume-for-i815-chip.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch
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
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
pm-reduce-code-duplication-between-mainc-and-userc-updated.patch
acpi-do-not-prepare-for-hibernation-in-acpi_shutdown.patch
pm-introduce-pm_power_off_prepare.patch

From: akpm@linux-foundation.org
Subject: + acpi-do-not-attempt-to-run-s1-standby-workarounds-while-hibernating.patch added to -mm tree
Date: Mon, 11 Jun 2007 13:05:59 -0700
Message-ID: <200706112005.l5BK5x07028021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40187 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbXFKUGQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 16:06:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, lenb@kernel.org, pavel@suse.cz


The patch titled
     acpi: do not attempt to run S1 (standby) workarounds while hibernating
has been added to the -mm tree.  Its filename is
     acpi-do-not-attempt-to-run-s1-standby-workarounds-while-hibernating.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi: do not attempt to run S1 (standby) workarounds while hibernating
From: Pavel Machek <pavel@ucw.cz>

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |    5 -----
 1 files changed, 5 deletions(-)

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
 
 static int acpi_hibernation_pre_restore(void)
_

Patches currently in -mm which might be from pavel@ucw.cz are

acpi-do-not-attempt-to-run-s1-standby-workarounds-while-hibernating.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-input.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch
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
beeping-patch-for-debugging-acpi-sleep.patch

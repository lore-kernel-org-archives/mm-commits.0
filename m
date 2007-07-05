From: akpm@linux-foundation.org
Subject: + acpi-do-not-prepare-for-hibernation-in-acpi_shutdown.patch added to -mm tree
Date: Thu, 05 Jul 2007 15:16:22 -0700
Message-ID: <200707052216.l65MGMCi021936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53279 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761237AbXGEWQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 18:16:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, lenb@kernel.org, pavel@ucw.cz


The patch titled
     ACPI: Do not prepare for hibernation in acpi_shutdown
has been added to the -mm tree.  Its filename is
     acpi-do-not-prepare-for-hibernation-in-acpi_shutdown.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: Do not prepare for hibernation in acpi_shutdown
From: Rafael J. Wysocki <rjw@sisk.pl>

Since we are now explicitly calling hibernation_ops->prepare() before
hibernation_ops->enter() in hibernation_platform_enter() (defined in
kernel/power/disk.c), ACPI should not call acpi_sleep_prepare(ACPI_STATE_S4)
from acpi_shutdown().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/poweroff.c |    3 ---
 1 files changed, 3 deletions(-)

diff -puN drivers/acpi/sleep/poweroff.c~acpi-do-not-prepare-for-hibernation-in-acpi_shutdown drivers/acpi/sleep/poweroff.c
--- a/drivers/acpi/sleep/poweroff.c~acpi-do-not-prepare-for-hibernation-in-acpi_shutdown
+++ a/drivers/acpi/sleep/poweroff.c
@@ -54,9 +54,6 @@ static int acpi_shutdown(struct sys_devi
 	case SYSTEM_POWER_OFF:
 		/* Prepare to power off the system */
 		return acpi_sleep_prepare(ACPI_STATE_S5);
-	case SYSTEM_SUSPEND_DISK:
-		/* Prepare to suspend the system to disk */
-		return acpi_sleep_prepare(ACPI_STATE_S4);
 	default:
 		return 0;
 	}
_

Patches currently in -mm which might be from rjw@sisk.pl are

pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch
pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm-update.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
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
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
pm-reduce-code-duplication-between-mainc-and-userc-updated.patch
acpi-do-not-prepare-for-hibernation-in-acpi_shutdown.patch
pm-introduce-pm_power_off_prepare.patch
shrink_slab-handle-bad-shrinkers.patch

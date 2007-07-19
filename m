From: akpm@linux-foundation.org
Subject: - acpi-do-not-prepare-for-hibernation-in-acpi_shutdown.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:28 -0700
Message-ID: <200707192000.l6JK0SSi019451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933040AbXGSU0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:26:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, lenb@kernel.org, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     ACPI: Do not prepare for hibernation in acpi_shutdown
has been removed from the -mm tree.  Its filename was
     acpi-do-not-prepare-for-hibernation-in-acpi_shutdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 3 deletions(-)

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

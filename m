From: akpm@linux-foundation.org
Subject: - acpi-clean-up-acpi_enter_sleep_state_prep.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:10:25 -0700
Message-ID: <200710102110.l9ALAPoU025929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38676 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756531AbXJJVLG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:11:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, lenb@kernel.org, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     ACPI: clean up acpi_enter_sleep_state_prep
has been removed from the -mm tree.  Its filename was
     acpi-clean-up-acpi_enter_sleep_state_prep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: clean up acpi_enter_sleep_state_prep
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove some redundant code from acpi_enter_sleep_state_prep() and clean up
a comment in there.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/hardware/hwsleep.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/acpi/hardware/hwsleep.c~acpi-clean-up-acpi_enter_sleep_state_prep drivers/acpi/hardware/hwsleep.c
--- a/drivers/acpi/hardware/hwsleep.c~acpi-clean-up-acpi_enter_sleep_state_prep
+++ a/drivers/acpi/hardware/hwsleep.c
@@ -234,15 +234,11 @@ acpi_status acpi_enter_sleep_state_prep(
 				"While executing method _SST"));
 	}
 
-	/*
-	 * 1) Disable/Clear all GPEs
-	 */
+	/* Disable/Clear all GPEs */
+
 	status = acpi_hw_disable_all_gpes();
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
 
-	return_ACPI_STATUS(AE_OK);
+	return_ACPI_STATUS(status);
 }
 
 ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_prep)
_

Patches currently in -mm which might be from rjw@sisk.pl are

git-acpi.patch
git-net.patch
revert-x86_64-mm-cpa-einval.patch
x86-64-disable-local-apic-timer-use-on-amd-systems-with-c1e.patch
x86_64-cleanup-apic-c.patch
make-kernel-power-maincsuspend_enter-static.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-introduce-freezer-firendly-waiting-macros-fix.patch
freezer-do-not-send-signals-to-kernel-threads.patch
unexport-pm_power_off_prepare.patch
pm_trace-displays-the-wrong-time-from-the-rtc.patch
freezer-be-more-verbose.patch
freezer-use-wait-queue-instead-of-busy-looping.patch
freezer-measure-freezing-time.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
s2ram-kill-old-debugging-junk.patch
hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch
hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch
hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch
hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
hibernation-check-if-acpi-is-enabled-during-restore-in-the-right-place.patch
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4.patch
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4-fix.patch
pnp-make-pnpacpi_suspend-handle-errors.patch
shrink_slab-handle-bad-shrinkers.patch

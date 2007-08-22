From: akpm@linux-foundation.org
Subject: + acpi-clean-up-acpi_enter_sleep_state_prep.patch added to -mm tree
Date: Wed, 22 Aug 2007 15:18:42 -0700
Message-ID: <200708222218.l7MMIgLb007516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37097 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759900AbXHVWTO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 18:19:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, lenb@kernel.org


The patch titled
     ACPI: clean up acpi_enter_sleep_state_prep
has been added to the -mm tree.  Its filename is
     acpi-clean-up-acpi_enter_sleep_state_prep.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: clean up acpi_enter_sleep_state_prep
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove some redundant code from acpi_enter_sleep_state_prep() and clean up
a comment in there.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/hardware/hwsleep.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

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

pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-3x.patch
enable-gpes-before-calling-_wak-on-resume.patch
hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.patch
acpi-clean-up-acpi_enter_sleep_state_prep.patch
uli526x-add-suspend-and-resume-routines.patch
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
pnp-make-pnpacpi_suspend-handle-errors.patch
shrink_slab-handle-bad-shrinkers.patch

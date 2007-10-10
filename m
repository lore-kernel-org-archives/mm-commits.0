From: akpm@linux-foundation.org
Subject: - hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:10:23 -0700
Message-ID: <200710102110.l9ALANLu025926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756478AbXJJVKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:10:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, lenb@kernel.org, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Hibernation: Make sure that ACPI is enabled in acpi_hibernation_finish
has been removed from the -mm tree.  Its filename was
     hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Hibernation: Make sure that ACPI is enabled in acpi_hibernation_finish
From: Rafael J. Wysocki <rjw@sisk.pl>

If the BIOS does not enable ACPI and the "acpi=off" command line parameter
is passed to the boot kernel, ACPI may be disabled when the (restored)
image kernel attempts to execute acpi_hibernation_finish().  To prevent
this from happening we can call acpi_enable() from
acpi_hibernation_finish() (if ACPI is already enabled, this will have no
effect).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/acpi/sleep/main.c~hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish
+++ a/drivers/acpi/sleep/main.c
@@ -256,6 +256,11 @@ static int acpi_hibernation_enter(void)
 
 static void acpi_hibernation_finish(void)
 {
+	/*
+	 * If ACPI is not enabled by the BIOS and the boot kernel, we need to
+	 * enable it here.
+	 */
+	acpi_enable();
 	acpi_leave_sleep_state(ACPI_STATE_S4);
 	acpi_disable_wakeup_device(ACPI_STATE_S4);
 
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

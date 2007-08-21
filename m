From: akpm@linux-foundation.org
Subject: + hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.patch added to -mm tree
Date: Tue, 21 Aug 2007 14:16:48 -0700
Message-ID: <200708212116.l7LLGmZ2011414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37300 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753757AbXHUVRf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Aug 2007 17:17:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, lenb@kernel.org, pavel@ucw.cz


The patch titled
     Hibernation: Make sure that ACPI is enabled in acpi_hibernation_finish
has been added to the -mm tree.  Its filename is
     hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 5 insertions(+)

diff -puN drivers/acpi/sleep/main.c~hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish
+++ a/drivers/acpi/sleep/main.c
@@ -230,6 +230,11 @@ static int acpi_hibernation_enter(void)
 
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

pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-3x.patch
enable-gpes-before-calling-_wak-on-resume.patch
hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.patch
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

From: akpm@linux-foundation.org
Subject: - x86_64-cleanup-apic-c-fix-2.patch removed from -mm tree
Date: Tue, 02 Oct 2007 14:44:56 -0700
Message-ID: <200710022144.l92LiuK0023925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42393 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753351AbXJBVpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 17:45:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Fix CPU hotplug breakage on HP nx6325
has been removed from the -mm tree.  Its filename was
     x86_64-cleanup-apic-c-fix-2.patch

This patch was dropped because it was folded into x86_64-cleanup-apic-c.patch

------------------------------------------------------
Subject: Fix CPU hotplug breakage on HP nx6325
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix CPU hotplug breakage on HP nx6325 and similar boxes caused by a reference
to disable_apic_timer (labeled as __initdata) from the CPU initialization code.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/x86_64/kernel/apic.c~x86_64-cleanup-apic-c-fix-2 arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86_64-cleanup-apic-c-fix-2
+++ a/arch/x86_64/kernel/apic.c
@@ -42,7 +42,7 @@
 
 int apic_verbosity;
 static int apic_calibrate_pmtmr __initdata;
-int disable_apic_timer __initdata;
+int disable_apic_timer __cpuinitdata;
 
 /* Local APIC timer works in C2? */
 int local_apic_timer_c2_ok;
_

Patches currently in -mm which might be from rjw@sisk.pl are

hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.patch
acpi-clean-up-acpi_enter_sleep_state_prep.patch
git-net.patch
revert-x86_64-mm-cpa-einval.patch
x86-64-disable-local-apic-timer-use-on-amd-systems-with-c1e.patch
x86_64-cleanup-apic-c.patch
x86_64-cleanup-apic-c-fix-2.patch
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

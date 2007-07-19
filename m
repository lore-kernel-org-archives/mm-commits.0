From: akpm@linux-foundation.org
Subject: - hibernation-prepare-to-enter-the-low-power-state.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:08 -0700
Message-ID: <200707192000.l6JK08E2019423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47464 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755968AbXGSUA5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:00:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ego@in.ibm.com, nigel@nigel.suspend2.net, oleg@tv-sign.ru, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Hibernation: prepare to enter the low power state
has been removed from the -mm tree.  Its filename was
     hibernation-prepare-to-enter-the-low-power-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Hibernation: prepare to enter the low power state
From: Rafael J. Wysocki <rjw@sisk.pl>

During hibernation we call hibernation_ops->prepare() before creating the image,
but then, before saving it, we cancel the power transition by calling
hibernation_ops->finish().  Thus prior to calling hibernation_ops->enter() we
should let the platform firmware know that we're going to enter the low power
state after all.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN kernel/power/disk.c~hibernation-prepare-to-enter-the-low-power-state kernel/power/disk.c
--- a/kernel/power/disk.c~hibernation-prepare-to-enter-the-low-power-state
+++ a/kernel/power/disk.c
@@ -205,12 +205,23 @@ int hibernation_restore(int platform_mod
 
 int hibernation_platform_enter(void)
 {
+	int error;
+
 	if (hibernation_ops) {
 		kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
-		return hibernation_ops->enter();
+		/*
+		 * We have cancelled the power transition by running
+		 * hibernation_ops->finish() before saving the image, so we
+		 * should let the firmware know that we're going to enter the
+		 * sleep state after all
+		 */
+		error = hibernation_ops->prepare();
+		if (!error)
+			error = hibernation_ops->enter();
 	} else {
-		return -ENOSYS;
+		error = -ENOSYS;
 	}
+	return error;
 }
 
 /**
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

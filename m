From: akpm@linux-foundation.org
Subject: + hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4-fix.patch added to -mm tree
Date: Sat, 15 Sep 2007 22:42:30 -0700
Message-ID: <200709160542.l8G5gUMN002290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36895 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069AbXIPFm7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 01:42:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@ucw.cz


The patch titled
     Hibernation: Resume consoles if hibernation_platform_enter fails
has been added to the -mm tree.  Its filename is
     hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Hibernation: Resume consoles if hibernation_platform_enter fails
From: Rafael J. Wysocki <rjw@sisk.pl>

If hibernation_platform_enter() fails, consoles should be resumed so that
diagnostic information related to the failure is available to the user.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/power/disk.c~hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4-fix kernel/power/disk.c
--- a/kernel/power/disk.c~hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4-fix
+++ a/kernel/power/disk.c
@@ -293,7 +293,7 @@ int hibernation_platform_enter(void)
 	suspend_console();
 	error = device_suspend(PMSG_SUSPEND);
 	if (error)
-		return error;
+		goto Resume_console;
 
 	error = hibernation_ops->prepare();
 	if (error)
@@ -320,6 +320,8 @@ int hibernation_platform_enter(void)
 	hibernation_ops->finish();
  Resume_devices:
 	device_resume();
+ Resume_console:
+	resume_console();
 	return error;
 }
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

fix-failure-to-resume-from-initrds.patch
hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.patch
acpi-clean-up-acpi_enter_sleep_state_prep.patch
git-netdev-all.patch
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

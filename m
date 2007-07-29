From: akpm@linux-foundation.org
Subject: - fix-thinkpad-t42-poweroff-failure-by-pm-introduce-pm_power_off_prepare.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:12:49 -0700
Message-ID: <200707290612.l6T6Cnvq011148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39386 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759524AbXG2GXy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, michal.k.k.piotrowski@gmail.com, yoshfuji@linux-ipv6.org, mm-commits@vger.kernel.org


The patch titled
     Fix ThinkPad T42 poweroff failure by "PM: Introduce pm_power_off_prepare"
has been removed from the -mm tree.  Its filename was
     fix-thinkpad-t42-poweroff-failure-by-pm-introduce-pm_power_off_prepare.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix ThinkPad T42 poweroff failure by "PM: Introduce pm_power_off_prepare"
From: Rafael J. Wysocki <rjw@sisk.pl>

Generally, sysdev_shutdown() should be called after the ACPI preparation for
powering the system off.  To make it happen, we can separate sysdev_shutdown()
from device_shutdown() and call it directly wherever necessary.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/shutdown.c |    2 --
 include/linux/device.h        |    3 +++
 kernel/power/disk.c           |    1 +
 kernel/sys.c                  |    3 +++
 4 files changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/base/power/shutdown.c~fix-thinkpad-t42-poweroff-failure-by-pm-introduce-pm_power_off_prepare drivers/base/power/shutdown.c
--- a/drivers/base/power/shutdown.c~fix-thinkpad-t42-poweroff-failure-by-pm-introduce-pm_power_off_prepare
+++ a/drivers/base/power/shutdown.c
@@ -44,7 +44,5 @@ void device_shutdown(void)
 			dev->driver->shutdown(dev);
 		}
 	}
-
-	sysdev_shutdown();
 }
 
diff -puN include/linux/device.h~fix-thinkpad-t42-poweroff-failure-by-pm-introduce-pm_power_off_prepare include/linux/device.h
--- a/include/linux/device.h~fix-thinkpad-t42-poweroff-failure-by-pm-introduce-pm_power_off_prepare
+++ a/include/linux/device.h
@@ -551,6 +551,9 @@ extern void put_device(struct device * d
 /* drivers/base/power/shutdown.c */
 extern void device_shutdown(void);
 
+/* drivers/base/sys.c */
+extern void sysdev_shutdown(void);
+
 
 /* drivers/base/firmware.c */
 extern int __must_check firmware_register(struct kset *);
diff -puN kernel/power/disk.c~fix-thinkpad-t42-poweroff-failure-by-pm-introduce-pm_power_off_prepare kernel/power/disk.c
--- a/kernel/power/disk.c~fix-thinkpad-t42-poweroff-failure-by-pm-introduce-pm_power_off_prepare
+++ a/kernel/power/disk.c
@@ -216,6 +216,7 @@ int hibernation_platform_enter(void)
 		 * sleep state after all
 		 */
 		error = hibernation_ops->prepare();
+		sysdev_shutdown();
 		if (!error)
 			error = hibernation_ops->enter();
 	} else {
diff -puN kernel/sys.c~fix-thinkpad-t42-poweroff-failure-by-pm-introduce-pm_power_off_prepare kernel/sys.c
--- a/kernel/sys.c~fix-thinkpad-t42-poweroff-failure-by-pm-introduce-pm_power_off_prepare
+++ a/kernel/sys.c
@@ -804,6 +804,7 @@ static void kernel_restart_prepare(char 
 	blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, cmd);
 	system_state = SYSTEM_RESTART;
 	device_shutdown();
+	sysdev_shutdown();
 }
 
 /**
@@ -860,6 +861,7 @@ void kernel_shutdown_prepare(enum system
 void kernel_halt(void)
 {
 	kernel_shutdown_prepare(SYSTEM_HALT);
+	sysdev_shutdown();
 	printk(KERN_EMERG "System halted.\n");
 	machine_halt();
 }
@@ -876,6 +878,7 @@ void kernel_power_off(void)
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
+	sysdev_shutdown();
 	printk(KERN_EMERG "Power down.\n");
 	machine_power_off();
 }
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
shrink_slab-handle-bad-shrinkers.patch

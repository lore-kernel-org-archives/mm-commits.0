From: akpm@linux-foundation.org
Subject: - pm-introduce-pm_power_off_prepare.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:30 -0700
Message-ID: <200707192000.l6JK0UNC019456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55017 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932279AbXGSUUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:20:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     PM: Introduce pm_power_off_prepare
has been removed from the -mm tree.  Its filename was
     pm-introduce-pm_power_off_prepare.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PM: Introduce pm_power_off_prepare
From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce the pm_power_off_prepare() callback that can be registered by the
interested platforms in analogy with pm_idle() and pm_power_off(), used for
preparing the system to power off (needed by ACPI).

This allows us to drop acpi_sysclass and device_acpi that are only defined in
order to register the ACPI power off preparation callback, which is needed by
pm_power_off() registered in a much different way.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/poweroff.c |   38 +++++++-------------------------
 include/linux/pm.h            |    1 
 kernel/sys.c                  |    9 +++++++
 3 files changed, 19 insertions(+), 29 deletions(-)

diff -puN drivers/acpi/sleep/poweroff.c~pm-introduce-pm_power_off_prepare drivers/acpi/sleep/poweroff.c
--- a/drivers/acpi/sleep/poweroff.c~pm-introduce-pm_power_off_prepare
+++ a/drivers/acpi/sleep/poweroff.c
@@ -39,7 +39,13 @@ int acpi_sleep_prepare(u32 acpi_state)
 
 #ifdef CONFIG_PM
 
-void acpi_power_off(void)
+static void acpi_power_off_prepare(void)
+{
+	/* Prepare to power off the system */
+	acpi_sleep_prepare(ACPI_STATE_S5);
+}
+
+static void acpi_power_off(void)
 {
 	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
 	printk("%s called\n", __FUNCTION__);
@@ -48,27 +54,6 @@ void acpi_power_off(void)
 	acpi_enter_sleep_state(ACPI_STATE_S5);
 }
 
-static int acpi_shutdown(struct sys_device *x)
-{
-	switch (system_state) {
-	case SYSTEM_POWER_OFF:
-		/* Prepare to power off the system */
-		return acpi_sleep_prepare(ACPI_STATE_S5);
-	default:
-		return 0;
-	}
-}
-
-static struct sysdev_class acpi_sysclass = {
-	set_kset_name("acpi"),
-	.shutdown = acpi_shutdown
-};
-
-static struct sys_device device_acpi = {
-	.id = 0,
-	.cls = &acpi_sysclass,
-};
-
 static int acpi_poweroff_init(void)
 {
 	if (!acpi_disabled) {
@@ -78,13 +63,8 @@ static int acpi_poweroff_init(void)
 		status =
 		    acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
 		if (ACPI_SUCCESS(status)) {
-			int error;
-			error = sysdev_class_register(&acpi_sysclass);
-			if (!error)
-				error = sysdev_register(&device_acpi);
-			if (!error)
-				pm_power_off = acpi_power_off;
-			return error;
+			pm_power_off_prepare = acpi_power_off_prepare;
+			pm_power_off = acpi_power_off;
 		}
 	}
 	return 0;
diff -puN include/linux/pm.h~pm-introduce-pm_power_off_prepare include/linux/pm.h
--- a/include/linux/pm.h~pm-introduce-pm_power_off_prepare
+++ a/include/linux/pm.h
@@ -101,6 +101,7 @@ struct pm_dev
  */
 extern void (*pm_idle)(void);
 extern void (*pm_power_off)(void);
+extern void (*pm_power_off_prepare)(void);
 
 typedef int __bitwise suspend_state_t;
 
diff -puN kernel/sys.c~pm-introduce-pm_power_off_prepare kernel/sys.c
--- a/kernel/sys.c~pm-introduce-pm_power_off_prepare
+++ a/kernel/sys.c
@@ -100,6 +100,13 @@ struct pid *cad_pid;
 EXPORT_SYMBOL(cad_pid);
 
 /*
+ * If set, this is used for preparing the system to power off.
+ */
+
+void (*pm_power_off_prepare)(void);
+EXPORT_SYMBOL(pm_power_off_prepare);
+
+/*
  *	Notifier list for kernel code which wants to be called
  *	at shutdown. This is used to stop any idling DMA operations
  *	and the like. 
@@ -867,6 +874,8 @@ EXPORT_SYMBOL_GPL(kernel_halt);
 void kernel_power_off(void)
 {
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
+	if (pm_power_off_prepare)
+		pm_power_off_prepare();
 	printk(KERN_EMERG "Power down.\n");
 	machine_power_off();
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

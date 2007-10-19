From: akpm@linux-foundation.org
Subject: - hibernation-check-if-acpi-is-enabled-during-restore-in-the-right-place.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:28 -0700
Message-ID: <200710190341.l9J3fStx012822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41964 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966522AbXJSD4A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Hibernation: Check if ACPI is enabled during restore in the right =
place
has been removed from the -mm tree.  Its filename was
     hibernation-check-if-acpi-is-enabled-during-restore-in-the-right-p=
lace.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: Hibernation: Check if ACPI is enabled during restore in the ri=
ght place
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

The following scenario leads to total confusion of the platform firmwar=
e on
some boxes (eg. HPC nx6325):
* Hibernate with ACPI enabled
* Resume passing "acpi=3Doff" to the boot kernel

To prevent this from happening it's necessary to check if ACPI is enabl=
ed (and
enable it if that's not the case) _right_ _after_ control has been tran=
sfered
from the boot kernel to the image kernel, before device_power_up() is c=
alled
(ie.  with interrupts disabled).  =A0Enabling ACPI after calling
device_power_up() turns out to be insufficient.

=46or this reason, introduce new hibernation callback ->leave() that wi=
ll be
executed before device_power_up() by the restored image kernel.  =A0To =
make it
work, it also is necessary to move swsusp_suspend() from swsusp.c to di=
sk.c
(it's name is changed to "create_image", which is more up to the point)=
=2E

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |   10 ++++++
 include/linux/suspend.h   |    7 ++++
 kernel/power/disk.c       |   58 +++++++++++++++++++++++++++++++++++-
 kernel/power/power.h      |    1=20
 kernel/power/swsusp.c     |   33 --------------------
 5 files changed, 74 insertions(+), 35 deletions(-)

diff -puN drivers/acpi/sleep/main.c~hibernation-check-if-acpi-is-enable=
d-during-restore-in-the-right-place drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~hibernation-check-if-acpi-is-enabled-du=
ring-restore-in-the-right-place
+++ a/drivers/acpi/sleep/main.c
@@ -257,6 +257,15 @@ static int acpi_hibernation_enter(void)
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
 }
=20
+static void acpi_hibernation_leave(void)
+{
+	/*
+	 * If ACPI is not enabled by the BIOS and the boot kernel, we need to
+	 * enable it here.
+	 */
+	acpi_enable();
+}
+
 static void acpi_hibernation_finish(void)
 {
 	acpi_leave_sleep_state(ACPI_STATE_S4);
@@ -288,6 +297,7 @@ static struct platform_hibernation_ops a
 	.finish =3D acpi_hibernation_finish,
 	.prepare =3D acpi_hibernation_prepare,
 	.enter =3D acpi_hibernation_enter,
+	.leave =3D acpi_hibernation_leave,
 	.pre_restore =3D acpi_hibernation_pre_restore,
 	.restore_cleanup =3D acpi_hibernation_restore_cleanup,
 };
diff -puN include/linux/suspend.h~hibernation-check-if-acpi-is-enabled-=
during-restore-in-the-right-place include/linux/suspend.h
--- a/include/linux/suspend.h~hibernation-check-if-acpi-is-enabled-duri=
ng-restore-in-the-right-place
+++ a/include/linux/suspend.h
@@ -156,6 +156,12 @@ extern void mark_free_pages(struct zone=20
  *	Called after the nonboot CPUs have been disabled and all of the low
  *	level devices have been shut down (runs with IRQs off).
  *
+ * @leave: Perform the first stage of the cleanup after the system sle=
ep state
+ *	indicated by @set_target() has been left.
+ *	Called right after the control has been passed from the boot kernel=
 to
+ *	the image kernel, before the nonboot CPUs are enabled and before de=
vices
+ *	are resumed.  Executed with interrupts disabled.
+ *
  * @pre_restore: Prepare system for the restoration from a hibernation=
 image.
  *	Called right after devices have been frozen and before the nonboot
  *	CPUs are disabled (runs with IRQs on).
@@ -170,6 +176,7 @@ struct platform_hibernation_ops {
 	void (*finish)(void);
 	int (*prepare)(void);
 	int (*enter)(void);
+	void (*leave)(void);
 	int (*pre_restore)(void);
 	void (*restore_cleanup)(void);
 };
diff -puN kernel/power/disk.c~hibernation-check-if-acpi-is-enabled-duri=
ng-restore-in-the-right-place kernel/power/disk.c
--- a/kernel/power/disk.c~hibernation-check-if-acpi-is-enabled-during-r=
estore-in-the-right-place
+++ a/kernel/power/disk.c
@@ -93,6 +93,17 @@ static int platform_pre_snapshot(int pla
 }
=20
 /**
+ *	platform_leave - prepare the machine for switching to the normal mo=
de
+ *	of operation using the platform driver (called with interrupts disa=
bled)
+ */
+
+static void platform_leave(int platform_mode)
+{
+	if (platform_mode && hibernation_ops)
+		hibernation_ops->leave();
+}
+
+/**
  *	platform_finish - switch the machine to the normal mode of operatio=
n
  *	using the platform driver (must be called after platform_prepare())
  */
@@ -129,6 +140,51 @@ static void platform_restore_cleanup(int
 }
=20
 /**
+ *	create_image - freeze devices that need to be frozen with interrupt=
s
+ *	off, create the hibernation image and thaw those devices.  Control
+ *	reappears in this routine after a restore.
+ */
+
+int create_image(int platform_mode)
+{
+	int error;
+
+	error =3D arch_prepare_suspend();
+	if (error)
+		return error;
+
+	local_irq_disable();
+	/* At this point, device_suspend() has been called, but *not*
+	 * device_power_down(). We *must* call device_power_down() now.
+	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
+	 * become desynchronized with the actual state of the hardware
+	 * at resume time, and evil weirdness ensues.
+	 */
+	error =3D device_power_down(PMSG_FREEZE);
+	if (error) {
+		printk(KERN_ERR "Some devices failed to power down, "
+			KERN_ERR "aborting suspend\n");
+		goto Enable_irqs;
+	}
+
+	save_processor_state();
+	error =3D swsusp_arch_suspend();
+	if (error)
+		printk(KERN_ERR "Error %d while creating the image\n", error);
+	/* Restore control flow magically appears here */
+	restore_processor_state();
+	if (!in_suspend)
+		platform_leave(platform_mode);
+	/* NOTE:  device_power_up() is just a resume() for devices
+	 * that suspended with irqs off ... no overall powerup.
+	 */
+	device_power_up();
+ Enable_irqs:
+	local_irq_enable();
+	return error;
+}
+
+/**
  *	hibernation_snapshot - quiesce devices and create the hibernation
  *	snapshot image.
  *	@platform_mode - if set, use the platform driver, if available, to
@@ -163,7 +219,7 @@ int hibernation_snapshot(int platform_mo
 	if (!error) {
 		if (hibernation_mode !=3D HIBERNATION_TEST) {
 			in_suspend =3D 1;
-			error =3D swsusp_suspend();
+			error =3D create_image(platform_mode);
 			/* Control returns here after successful restore */
 		} else {
 			printk("swsusp debug: Waiting for 5 seconds.\n");
diff -puN kernel/power/power.h~hibernation-check-if-acpi-is-enabled-dur=
ing-restore-in-the-right-place kernel/power/power.h
--- a/kernel/power/power.h~hibernation-check-if-acpi-is-enabled-during-=
restore-in-the-right-place
+++ a/kernel/power/power.h
@@ -183,7 +183,6 @@ extern int swsusp_swap_in_use(void);
 extern int swsusp_check(void);
 extern int swsusp_shrink_memory(void);
 extern void swsusp_free(void);
-extern int swsusp_suspend(void);
 extern int swsusp_resume(void);
 extern int swsusp_read(unsigned int *flags_p);
 extern int swsusp_write(unsigned int flags);
diff -puN kernel/power/swsusp.c~hibernation-check-if-acpi-is-enabled-du=
ring-restore-in-the-right-place kernel/power/swsusp.c
--- a/kernel/power/swsusp.c~hibernation-check-if-acpi-is-enabled-during=
-restore-in-the-right-place
+++ a/kernel/power/swsusp.c
@@ -270,39 +270,6 @@ int swsusp_shrink_memory(void)
 	return 0;
 }
=20
-int swsusp_suspend(void)
-{
-	int error;
-
-	if ((error =3D arch_prepare_suspend()))
-		return error;
-
-	local_irq_disable();
-	/* At this point, device_suspend() has been called, but *not*
-	 * device_power_down(). We *must* device_power_down() now.
-	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
-	 * become desynchronized with the actual state of the hardware
-	 * at resume time, and evil weirdness ensues.
-	 */
-	if ((error =3D device_power_down(PMSG_FREEZE))) {
-		printk(KERN_ERR "Some devices failed to power down, aborting suspend=
\n");
-		goto Enable_irqs;
-	}
-
-	save_processor_state();
-	if ((error =3D swsusp_arch_suspend()))
-		printk(KERN_ERR "Error %d suspending\n", error);
-	/* Restore control flow magically appears here */
-	restore_processor_state();
-	/* NOTE:  device_power_up() is just a resume() for devices
-	 * that suspended with irqs off ... no overall powerup.
-	 */
-	device_power_up();
- Enable_irqs:
-	local_irq_enable();
-	return error;
-}
-
 int swsusp_resume(void)
 {
 	int error;
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
revert-x86_64-mm-cpa-einval.patch
shrink_slab-handle-bad-shrinkers.patch

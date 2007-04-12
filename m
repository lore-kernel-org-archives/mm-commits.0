From: akpm@linux-foundation.org
Subject: - fix-hotplug-for-legacy-platform-drivers-update.patch removed from -mm tree
Date: Wed, 11 Apr 2007 23:33:03 -0700
Message-ID: <200704120633.l3C6X3Y0024791@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47443 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161565AbXDLGdR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 02:33:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, dilinger@debian.org, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     fix-hotplug-for-legacy-platform-drivers update
has been removed from the -mm tree.  Its filename was
     fix-hotplug-for-legacy-platform-drivers-update.patch

This patch was dropped because it was folded into fix-hotplug-for-legacy-platform-drivers.patch

------------------------------------------------------
Subject: fix-hotplug-for-legacy-platform-drivers update
From: David Brownell <david-b@pacbell.net>

This updates only comments, based on feedback.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <gregkh@suse.de>
Cc: Andres Salomon <dilinger@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/platform.c           |   20 ++++++++++----------
 drivers/pcmcia/pxa2xx_mainstone.c |    1 -
 drivers/pcmcia/pxa2xx_sharpsl.c   |    1 -
 3 files changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/base/platform.c~fix-hotplug-for-legacy-platform-drivers-update drivers/base/platform.c
--- a/drivers/base/platform.c~fix-hotplug-for-legacy-platform-drivers-update
+++ a/drivers/base/platform.c
@@ -161,10 +161,10 @@ static void platform_device_release(stru
  *	Create a platform device object which can have other objects attached
  *	to it, and which will have attached objects freed when it is released.
  *
- *	This device will be marked as not supporting hotpluggable drivers; in
- *	the unusual case that the device isn't being dynamically allocated as
- *	of a legacy "probe the hardware" driver, infrastructure code should
- *	reverse this marking.
+ *	This device will be marked as not supporting hotpluggable drivers; no
+ *	device add/remove uevents will be generated.  In the unusual case that
+ *	the device isn't being dynamically allocated as a legacy "probe the
+ *	hardware" driver, infrastructure code should reverse this marking.
  */
 struct platform_device *platform_device_alloc(const char *name, unsigned int id)
 {
@@ -180,7 +180,7 @@ struct platform_device *platform_device_
 
 		/* prevent hotplug "modprobe $(MODALIAS)" from causing trouble in
 		 * legacy probe-the-hardware drivers, which don't properly split
-		 * out enumeration logic from drivers.
+		 * out device enumeration logic from drivers.
 		 */
 		pa->pdev.dev.uevent_suppress = 1;
 	}
@@ -362,11 +362,11 @@ EXPORT_SYMBOL_GPL(platform_device_unregi
  *	to be dropped.
  *
  *	This interface is primarily intended for use with legacy drivers
- *	which probe hardware directly.  Because such drivers create device
- *	nodes themselves, rather than letting system infrastructure handle
- *	such device enumeration tasks, they don't fully conform to the Linux
- *	driver model.  In particular, when such drivers are built as modules,
- *	they can't be "hotplugged".
+ *	which probe hardware directly.  Because such drivers create sysfs
+ *	device nodes themselves, rather than letting system infrastructure
+ *	handle such device enumeration tasks, they don't fully conform to
+ *	the Linux driver model.  In particular, when such drivers are built
+ *	as modules, they can't be "hotplugged".
  */
 struct platform_device *platform_device_register_simple(char *name, unsigned int id,
 							struct resource *res, unsigned int num)
diff -puN drivers/pcmcia/pxa2xx_mainstone.c~fix-hotplug-for-legacy-platform-drivers-update drivers/pcmcia/pxa2xx_mainstone.c
--- a/drivers/pcmcia/pxa2xx_mainstone.c~fix-hotplug-for-legacy-platform-drivers-update
+++ a/drivers/pcmcia/pxa2xx_mainstone.c
@@ -175,7 +175,6 @@ static int __init mst_pcmcia_init(void)
 	if (!mst_pcmcia_device)
 		return -ENOMEM;
 
-	/* REVISIT just statically allocate the device */
 	mst_pcmcia_device->dev.uevent_suppress = 0;
 	mst_pcmcia_device->dev.platform_data = &mst_pcmcia_ops;
 
diff -puN drivers/pcmcia/pxa2xx_sharpsl.c~fix-hotplug-for-legacy-platform-drivers-update drivers/pcmcia/pxa2xx_sharpsl.c
--- a/drivers/pcmcia/pxa2xx_sharpsl.c~fix-hotplug-for-legacy-platform-drivers-update
+++ a/drivers/pcmcia/pxa2xx_sharpsl.c
@@ -261,7 +261,6 @@ static int __init sharpsl_pcmcia_init(vo
 	if (!sharpsl_pcmcia_device)
 		return -ENOMEM;
 
-	/* REVISIT just statically allocate the device */
 	sharpsl_pcmcia_device->dev.uevent_suppress = 0;
 	sharpsl_pcmcia_device->dev.platform_data = &sharpsl_pcmcia_ops;
 	sharpsl_pcmcia_device->dev.parent = platform_scoop_config->devs[0].dev;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
doc-gpiotxt-describes-open-drain-emulation.patch
fix-hotplug-for-legacy-platform-drivers.patch
fix-hotplug-for-legacy-platform-drivers-update.patch
make-proc-acpi-wakeup-more-useful.patch
update-documentation-driver-model-platformtxt.patch
at91_cf-minor-fix.patch
scsi-newstyle-hotplug-coldplug-support.patch
usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
parport-dev-driver-model-support-powerpc-fix.patch
layered-parport-code-uses-parport-dev.patch
pnpacpi-sets-pnpdev-devarchdata.patch
pnpacpi-sets-pnpdev-devarchdata-fix.patch
minor-spi_butterfly-cleanup.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-update-to-class-device-removal-patches.patch
rtc-kconfig-cleanup.patch
rtc-cmos-wakeup-interface.patch
acpi-wakeup-hooks-for-rtc-cmos.patch

From: akpm@linux-foundation.org
Subject: + pnpacpi-sets-pnpdev-devarchdata.patch added to -mm tree
Date: Tue, 03 Apr 2007 15:33:50 -0700
Message-ID: <200704032233.l33MXorR005214@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46555 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992436AbXDCWfV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 18:35:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, ambx1@neo.rr.com, bjorn.helgaas@hp.com, dbrownell@users.sourceforge.net, lenb@kernel.org


The patch titled
     PNPACPI sets pnpdev->dev.archdata
has been added to the -mm tree.  Its filename is
     pnpacpi-sets-pnpdev-devarchdata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNPACPI sets pnpdev->dev.archdata
From: David Brownell <david-b@pacbell.net>

Teach PNPACPI how to hook up its devices to their ACPI nodes, so that
pnpdev->dev.archdata points to the parallel acpi device node.  Previously
this only worked for PCI, leaving a notable hole.

Export "acpi_bus_type" so this can work.

Remove some extraneous whitespace.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/scan.c        |    2 -
 drivers/pnp/pnpacpi/core.c |   53 +++++++++++++++++++++++++++++------
 include/acpi/acpi_bus.h    |    3 +
 3 files changed, 49 insertions(+), 9 deletions(-)

diff -puN drivers/acpi/scan.c~pnpacpi-sets-pnpdev-devarchdata drivers/acpi/scan.c
--- a/drivers/acpi/scan.c~pnpacpi-sets-pnpdev-devarchdata
+++ a/drivers/acpi/scan.c
@@ -302,7 +302,7 @@ static void acpi_device_shutdown(struct 
 	return ;
 }
 
-static struct bus_type acpi_bus_type = {
+struct bus_type acpi_bus_type = {
 	.name		= "acpi",
 	.suspend	= acpi_device_suspend,
 	.resume		= acpi_device_resume,
diff -puN drivers/pnp/pnpacpi/core.c~pnpacpi-sets-pnpdev-devarchdata drivers/pnp/pnpacpi/core.c
--- a/drivers/pnp/pnpacpi/core.c~pnpacpi-sets-pnpdev-devarchdata
+++ a/drivers/pnp/pnpacpi/core.c
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2004 Matthieu Castet <castet.matthieu@free.fr>
  * Copyright (c) 2004 Li Shaohua <shaohua.li@intel.com>
- * 
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
  * Free Software Foundation; either version 2, or (at your option) any
@@ -18,7 +18,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
- 
+
 #include <linux/acpi.h>
 #include <linux/pnp.h>
 #include <acpi/acpi_bus.h>
@@ -82,7 +82,7 @@ static void __init pnpidacpi_to_pnpid(ch
 static int pnpacpi_get_resources(struct pnp_dev * dev, struct pnp_resource_table * res)
 {
 	acpi_status status;
-	status = pnpacpi_parse_allocated_resource((acpi_handle)dev->data, 
+	status = pnpacpi_parse_allocated_resource((acpi_handle)dev->data,
 		&dev->res);
 	return ACPI_FAILURE(status) ? -ENODEV : 0;
 }
@@ -112,9 +112,9 @@ static int pnpacpi_set_resources(struct 
 static int pnpacpi_disable_resources(struct pnp_dev *dev)
 {
 	acpi_status status;
-	
+
 	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
-	status = acpi_evaluate_object((acpi_handle)dev->data, 
+	status = acpi_evaluate_object((acpi_handle)dev->data,
 		"_DIS", NULL, NULL);
 	return ACPI_FAILURE(status) ? -ENODEV : 0;
 }
@@ -167,7 +167,7 @@ static int __init pnpacpi_add_device(str
 		strncpy(dev->name, acpi_device_bid(device), sizeof(dev->name));
 
 	dev->number = num;
-	
+
 	/* set the initial values for the PnP device */
 	dev_id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
 	if (!dev_id)
@@ -185,14 +185,14 @@ static int __init pnpacpi_add_device(str
 	}
 
 	if(dev->capabilities & PNP_CONFIGURABLE) {
-		status = pnpacpi_parse_resource_option_data(device->handle, 
+		status = pnpacpi_parse_resource_option_data(device->handle,
 			dev);
 		if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND)) {
 			pnp_err("PnPACPI: METHOD_NAME__PRS failure for %s", dev_id->id);
 			goto err1;
 		}
 	}
-	
+
 	/* parse compatible ids */
 	if (device->flags.compatible_ids) {
 		struct acpi_compatible_id_list *cid_list = device->pnp.cid_list;
@@ -236,6 +236,41 @@ static acpi_status __init pnpacpi_add_de
 	return AE_OK;
 }
 
+static int __init acpi_pnp_match(struct device *dev, void *_pnp)
+{
+	struct acpi_device	*acpi = to_acpi_device(dev);
+	struct pnp_dev		*pnp = _pnp;
+
+	/* true means it matched */
+	return acpi->flags.hardware_id
+		&& compare_pnp_id(pnp->id, acpi->pnp.hardware_id);
+}
+
+static int __init acpi_pnp_find_device(struct device *dev, acpi_handle *handle)
+{
+	struct device		*adev;
+	struct acpi_device	*acpi;
+
+	adev = bus_find_device(&acpi_bus_type, NULL,
+			to_pnp_dev(dev),
+			acpi_pnp_match);
+	if (!adev)
+		return -ENODEV;
+
+	acpi = to_acpi_device(adev);
+	*handle = acpi->handle;
+	put_device(adev);
+	return 0;
+}
+
+/* complete initialization of a PNPACPI device includes having
+ * pnpdev->dev.archdata.acpi_handle point to its ACPI sibling.
+ */
+static struct acpi_bus_type __initdata acpi_pnp_bus = {
+	.bus = &pnp_bus_type,
+	.find_device = acpi_pnp_find_device,
+};
+
 int pnpacpi_disabled __initdata;
 static int __init pnpacpi_init(void)
 {
@@ -245,8 +280,10 @@ static int __init pnpacpi_init(void)
 	}
 	pnp_info("PnP ACPI init");
 	pnp_register_protocol(&pnpacpi_protocol);
+	register_acpi_bus_type(&acpi_pnp_bus);
 	acpi_get_devices(NULL, pnpacpi_add_device_handler, NULL, NULL);
 	pnp_info("PnP ACPI: found %d devices", num);
+	unregister_acpi_bus_type(&acpi_pnp_bus);
 	return 0;
 }
 subsys_initcall(pnpacpi_init);
diff -puN include/acpi/acpi_bus.h~pnpacpi-sets-pnpdev-devarchdata include/acpi/acpi_bus.h
--- a/include/acpi/acpi_bus.h~pnpacpi-sets-pnpdev-devarchdata
+++ a/include/acpi/acpi_bus.h
@@ -303,6 +303,9 @@ struct acpi_device {
 #define to_acpi_device(d)	container_of(d, struct acpi_device, dev)
 #define to_acpi_driver(d)	container_of(d, struct acpi_driver, drv)
 
+/* acpi_device.dev.bus == &acpi_bus_type */
+extern struct bus_type acpi_bus_type;
+
 /*
  * Events
  * ------
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
scsi-newstyle-hotplug-coldplug-support.patch
fix-hotplug-for-legacy-platform-drivers.patch
update-documentation-driver-model-platformtxt.patch
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
minor-spi_butterfly-cleanup.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-kconfig-cleanup.patch
rtc-cmos-wakeup-interface.patch
acpi-wakeup-hooks-for-rtc-cmos.patch

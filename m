From: akpm@linux-foundation.org
Subject: - pnpacpi-sets-pnpdev-devarchdata.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:40 -0700
Message-ID: <200705090248.l492mea1009139@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969834AbXEICuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, ambx1@neo.rr.com, bjorn.helgaas@hp.com, dbrownell@users.sourceforge.net, greg@kroah.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     PNPACPI sets pnpdev->dev.archdata
has been removed from the -mm tree.  Its filename was
     pnpacpi-sets-pnpdev-devarchdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/scan.c        |    2 -
 drivers/pnp/pnpacpi/core.c |   54 +++++++++++++++++++++++++++++------
 include/acpi/acpi_bus.h    |    3 +
 3 files changed, 50 insertions(+), 9 deletions(-)

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
@@ -236,6 +236,42 @@ static acpi_status __init pnpacpi_add_de
 	return AE_OK;
 }
 
+static int __init acpi_pnp_match(struct device *dev, void *_pnp)
+{
+	struct acpi_device	*acpi = to_acpi_device(dev);
+	struct pnp_dev		*pnp = _pnp;
+
+	/* true means it matched */
+	return acpi->flags.hardware_id
+		&& !acpi_get_physical_device(acpi->handle)
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
@@ -245,8 +281,10 @@ static int __init pnpacpi_init(void)
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
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch

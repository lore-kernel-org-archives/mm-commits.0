From: akpm@linux-foundation.org
Subject: - pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch removed from -mm tree
Date: Sat, 12 Jan 2008 21:28:19 -0800
Message-ID: <200801130527.m0D5RxUn030646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbYAMF30 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 00:29:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, a.zummo@towertech.it, david-b@pacbell.net, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     PNP: request ioport and iomem resources used by active devices
has been removed from the -mm tree.  Its filename was
     pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PNP: request ioport and iomem resources used by active devices
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Reserve resources used by active PNP devices to prevent those resources
from being assigned to other devices.

This can be turned off with the "pnp=no_reservations" flag.  If you need to
use it, please report it, because it indicates a potential problem, like a
driver that requests more resources than it needs.

This is similar to request_standard_resources().  That function requests
resources for a compiled-in list of standard PC devices such as DMA
controllers, PICs, timers, and keyboard, and marks them "busy." This patch
requests resources for devices that are actually present but does not mark
them "busy."

Sometimes the built-in standard resources are larger than what PNP reports,
or they combine things that PNP reports separately, which makes things look
a little strange, e.g.,

    0000-001f : dma1		<-- built-in resource includes 2 controllers
      0000-000f : 00:02		<-- PNP reports only one DMA controller
    0020-0021 : pic1
    002e-002f : 00:06
    0040-0043 : timer0
    0050-0053 : timer1
    0060-006f : keyboard	<-- built-in resource groups several things
      0060-0060 : 00:04		<-- PNP reports 8042 controller data register
      0061-0061 : 00:03		<-- PNP reports AT-style speaker
      0064-0064 : 00:04		<-- PNP reports 8042 controller status register
    0070-0073 : 00:06
      0070-0071 : rtc

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    8 ++
 drivers/pnp/base.h                  |    2 
 drivers/pnp/core.c                  |    3 
 drivers/pnp/manager.c               |   12 ++-
 drivers/pnp/resource.c              |  103 ++++++++++++++++++++++++++
 5 files changed, 125 insertions(+), 3 deletions(-)

diff -puN Documentation/kernel-parameters.txt~pnp-request-ioport-and-iomem-resources-used-by-active-devices Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~pnp-request-ioport-and-iomem-resources-used-by-active-devices
+++ a/Documentation/kernel-parameters.txt
@@ -1412,6 +1412,14 @@ and is between 256 and 4096 characters. 
 			Format: { parport<nr> | timid | 0 }
 			See also Documentation/parport.txt.
 
+	pnp=		[PNP] PNP subsystem options:
+		no_reservations	Don't reserve resources used by PNP devices
+				This is for working around problems where a
+				driver uses a PNP device without using the PNP
+				core.  Typical symptom is that the driver can't
+				reserve the resources it needs.  Please report
+				these issues.
+
 	pnpacpi=	[ACPI]
 			{ off }
 
diff -puN drivers/pnp/base.h~pnp-request-ioport-and-iomem-resources-used-by-active-devices drivers/pnp/base.h
--- a/drivers/pnp/base.h~pnp-request-ioport-and-iomem-resources-used-by-active-devices
+++ a/drivers/pnp/base.h
@@ -5,6 +5,8 @@ void pnp_fixup_device(struct pnp_dev *de
 void pnp_free_option(struct pnp_option *option);
 int __pnp_add_device(struct pnp_dev *dev);
 void __pnp_remove_device(struct pnp_dev *dev);
+int pnp_request_resources(struct pnp_dev *dev);
+int pnp_release_resources(struct pnp_dev *dev);
 
 int pnp_check_port(struct pnp_dev * dev, int idx);
 int pnp_check_mem(struct pnp_dev * dev, int idx);
diff -puN drivers/pnp/core.c~pnp-request-ioport-and-iomem-resources-used-by-active-devices drivers/pnp/core.c
--- a/drivers/pnp/core.c~pnp-request-ioport-and-iomem-resources-used-by-active-devices
+++ a/drivers/pnp/core.c
@@ -124,6 +124,9 @@ int __pnp_add_device(struct pnp_dev *dev
 	list_add_tail(&dev->protocol_list, &dev->protocol->devices);
 	spin_unlock(&pnp_lock);
 
+	if (dev->active)
+		pnp_request_resources(dev);
+
 	ret = device_register(&dev->dev);
 	if (ret)
 		return ret;
diff -puN drivers/pnp/manager.c~pnp-request-ioport-and-iomem-resources-used-by-active-devices drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-request-ioport-and-iomem-resources-used-by-active-devices
+++ a/drivers/pnp/manager.c
@@ -392,9 +392,11 @@ int pnp_manual_config_dev(struct pnp_dev
 
 	if (!pnp_can_configure(dev))
 		return -ENODEV;
+
 	bak = pnp_alloc(sizeof(struct pnp_resource_table));
 	if (!bak)
 		return -ENOMEM;
+
 	*bak = dev->res;
 
 	mutex_lock(&pnp_res_mutex);
@@ -464,7 +466,7 @@ int pnp_auto_config_dev(struct pnp_dev *
  * pnp_start_dev - low-level start of the PnP device
  * @dev: pointer to the desired device
  *
- * assumes that resources have already been allocated
+ * assumes that resources have already been assigned to the device
  */
 int pnp_start_dev(struct pnp_dev *dev)
 {
@@ -473,6 +475,9 @@ int pnp_start_dev(struct pnp_dev *dev)
 		return -EINVAL;
 	}
 
+	if (pnp_request_resources(dev))
+		dev_err(&dev->dev, "could not allocate resources\n");
+
 	if (dev->protocol->set(dev, &dev->res) < 0) {
 		dev_err(&dev->dev, "activation failed\n");
 		return -EIO;
@@ -485,8 +490,6 @@ int pnp_start_dev(struct pnp_dev *dev)
 /**
  * pnp_stop_dev - low-level disable of the PnP device
  * @dev: pointer to the desired device
- *
- * does not free resources
  */
 int pnp_stop_dev(struct pnp_dev *dev)
 {
@@ -494,11 +497,14 @@ int pnp_stop_dev(struct pnp_dev *dev)
 		dev_dbg(&dev->dev, "disabling not supported\n");
 		return -EINVAL;
 	}
+
 	if (dev->protocol->disable(dev) < 0) {
 		dev_err(&dev->dev, "disable failed\n");
 		return -EIO;
 	}
 
+	pnp_release_resources(dev);
+
 	dev_info(&dev->dev, "disabled\n");
 	return 0;
 }
diff -puN drivers/pnp/resource.c~pnp-request-ioport-and-iomem-resources-used-by-active-devices drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~pnp-request-ioport-and-iomem-resources-used-by-active-devices
+++ a/drivers/pnp/resource.c
@@ -23,6 +23,7 @@ static int pnp_reserve_irq[16] = {[0 ...
 static int pnp_reserve_dma[8] = {[0 ... 7] = -1 };	/* reserve (don't use) some DMA */
 static int pnp_reserve_io[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some I/O region */
 static int pnp_reserve_mem[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some memory region */
+static int pnp_no_reservations;
 
 /*
  * option registration
@@ -461,6 +462,98 @@ int pnp_check_dma(struct pnp_dev *dev, i
 #endif
 }
 
+int pnp_request_resources(struct pnp_dev *dev)
+{
+	int i, ret;
+	struct resource *res;
+
+	if (pnp_no_reservations) {
+		dev_warn(&dev->dev, "not reserving active resources because "
+			"\"pnp=no_reservations\"\n");
+		for (i = 0; i < PNP_MAX_PORT; i++) {
+			if (pnp_port_valid(dev, i)) {
+				res = &dev->res.port_resource[i];
+				dev_warn(&dev->dev, "  ports 0x%llx-0x%llx\n",
+					(unsigned long long) res->start,
+					(unsigned long long) res->end);
+			}
+		}
+		for (i = 0; i < PNP_MAX_MEM; i++) {
+			if (pnp_mem_valid(dev, i)) {
+				res = &dev->res.mem_resource[i];
+				dev_warn(&dev->dev, "  MMIO 0x%llx-0x%llx\n",
+					(unsigned long long) res->start,
+					(unsigned long long) res->end);
+			}
+		}
+		return 0;
+	}
+
+	/*
+	 * We use insert_resource() rather than request_resource() because
+	 * request_standard_resources() has already requested some standard
+	 * areas that are described by PNP.
+	 */
+	for (i = 0; i < PNP_MAX_PORT; i++) {
+		if (pnp_port_valid(dev, i)) {
+			res = &dev->res.port_resource[i];
+			res->name = dev->dev.bus_id;
+			ret = insert_resource(&ioport_resource, res);
+			if (ret)
+				dev_warn(&dev->dev,
+					"can't allocate I/O ports at 0x%llx\n",
+					(unsigned long long) res->start);
+		}
+	}
+
+	for (i = 0; i < PNP_MAX_MEM; i++) {
+		if (pnp_mem_valid(dev, i)) {
+			res = &dev->res.mem_resource[i];
+			res->name = dev->dev.bus_id;
+			ret = insert_resource(&iomem_resource, res);
+			if (ret)
+				dev_warn(&dev->dev,
+					"can't allocate MMIO space at 0x%llx\n",
+					(unsigned long long) res->start);
+		}
+	}
+
+	return 0;
+}
+
+int pnp_release_resources(struct pnp_dev *dev)
+{
+	int i, ret;
+	struct resource *res;
+
+	if (pnp_no_reservations)
+		return 0;
+
+	for (i = 0; i < PNP_MAX_PORT; i++) {
+		if (pnp_port_valid(dev, i)) {
+			res = &dev->res.port_resource[i];
+			ret = release_resource(res);
+			if (ret)
+				dev_warn(&dev->dev,
+					"can't release I/O ports at 0x%llx\n",
+					(unsigned long long) res->start);
+		}
+	}
+
+	for (i = 0; i < PNP_MAX_MEM; i++) {
+		if (pnp_mem_valid(dev, i)) {
+			res = &dev->res.mem_resource[i];
+			ret = release_resource(res);
+			if (ret)
+				dev_warn(&dev->dev,
+					"can't release MMIO space at 0x%llx\n",
+					(unsigned long long) res->start);
+		}
+	}
+
+	return 0;
+}
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {
@@ -512,3 +605,13 @@ static int __init pnp_setup_reserve_mem(
 }
 
 __setup("pnp_reserve_mem=", pnp_setup_reserve_mem);
+
+static int __init pnp_setup(char *str)
+{
+	if (!strcmp(str, "no_reservations"))
+		pnp_no_reservations = 1;
+
+	return 1;
+}
+
+__setup("pnp=", pnp_setup);
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
serial-keep-the-dtr-setting-for-serial-console.patch
parport_serial-netmos-9855-fix.patch
rtc-cmos-exports-nvram-in-sysfs.patch
pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values.patch
declare-pnp-option-parsing-functions-as-__init.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
dont-touch-fs_struct-in-drivers.patch

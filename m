From: akpm@osdl.org
Subject: - acpi-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:36:13 -0800
Message-ID: <200612210036.kBL0aDc9011174@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53227 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161093AbWLUAgR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:36:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan_952@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     acpi: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     acpi-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: acpi: replace kmalloc+memset with kzalloc
From: "Burman Yan" <yan_952@hotmail.com>



Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/kernel/cpufreq/acpi-cpufreq.c |    4 +---
 drivers/acpi/ac.c                       |    3 +--
 drivers/acpi/acpi_memhotplug.c          |    3 +--
 drivers/acpi/asus_acpi.c                |    3 +--
 drivers/acpi/battery.c                  |    9 +++------
 drivers/acpi/container.c                |    3 +--
 drivers/acpi/ec.c                       |    9 +++------
 drivers/acpi/fan.c                      |    3 +--
 drivers/acpi/i2c_ec.c                   |    6 ++----
 drivers/acpi/ibm_acpi.c                 |    3 +--
 drivers/acpi/pci_bind.c                 |   16 +++++-----------
 drivers/acpi/pci_irq.c                  |    9 +++------
 drivers/acpi/pci_link.c                 |    6 ++----
 drivers/acpi/pci_root.c                 |    3 +--
 drivers/acpi/power.c                    |    3 +--
 drivers/acpi/processor_core.c           |    3 +--
 drivers/acpi/sbs.c                      |    3 +--
 drivers/acpi/scan.c                     |    3 +--
 drivers/acpi/thermal.c                  |    7 ++-----
 drivers/acpi/utils.c                    |    6 ++----
 drivers/acpi/video.c                    |   10 +++-------
 drivers/pci/hotplug/acpiphp_ibm.c       |    3 +--
 22 files changed, 38 insertions(+), 80 deletions(-)

diff -puN arch/ia64/kernel/cpufreq/acpi-cpufreq.c~acpi-replace-kmallocmemset-with-kzalloc arch/ia64/kernel/cpufreq/acpi-cpufreq.c
--- a/arch/ia64/kernel/cpufreq/acpi-cpufreq.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/arch/ia64/kernel/cpufreq/acpi-cpufreq.c
@@ -276,12 +276,10 @@ acpi_cpufreq_cpu_init (
 
 	dprintk("acpi_cpufreq_cpu_init\n");
 
-	data = kmalloc(sizeof(struct cpufreq_acpi_io), GFP_KERNEL);
+	data = kzalloc(sizeof(struct cpufreq_acpi_io), GFP_KERNEL);
 	if (!data)
 		return (-ENOMEM);
 
-	memset(data, 0, sizeof(struct cpufreq_acpi_io));
-
 	acpi_io_data[cpu] = data;
 
 	result = acpi_processor_register_performance(&data->acpi_data, cpu);
diff -puN drivers/acpi/ac.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/ac.c
--- a/drivers/acpi/ac.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/ac.c
@@ -221,10 +221,9 @@ static int acpi_ac_add(struct acpi_devic
 	if (!device)
 		return -EINVAL;
 
-	ac = kmalloc(sizeof(struct acpi_ac), GFP_KERNEL);
+	ac = kzalloc(sizeof(struct acpi_ac), GFP_KERNEL);
 	if (!ac)
 		return -ENOMEM;
-	memset(ac, 0, sizeof(struct acpi_ac));
 
 	ac->device = device;
 	strcpy(acpi_device_name(device), ACPI_AC_DEVICE_NAME);
diff -puN drivers/acpi/acpi_memhotplug.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/acpi_memhotplug.c
--- a/drivers/acpi/acpi_memhotplug.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -395,10 +395,9 @@ static int acpi_memory_device_add(struct
 	if (!device)
 		return -EINVAL;
 
-	mem_device = kmalloc(sizeof(struct acpi_memory_device), GFP_KERNEL);
+	mem_device = kzalloc(sizeof(struct acpi_memory_device), GFP_KERNEL);
 	if (!mem_device)
 		return -ENOMEM;
-	memset(mem_device, 0, sizeof(struct acpi_memory_device));
 
 	INIT_LIST_HEAD(&mem_device->res_list);
 	mem_device->device = device;
diff -puN drivers/acpi/asus_acpi.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/asus_acpi.c
@@ -1264,10 +1264,9 @@ static int asus_hotk_add(struct acpi_dev
 	printk(KERN_NOTICE "Asus Laptop ACPI Extras version %s\n",
 	       ASUS_ACPI_VERSION);
 
-	hotk = kmalloc(sizeof(struct asus_hotk), GFP_KERNEL);
+	hotk = kzalloc(sizeof(struct asus_hotk), GFP_KERNEL);
 	if (!hotk)
 		return -ENOMEM;
-	memset(hotk, 0, sizeof(struct asus_hotk));
 
 	hotk->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_HOTK_DEVICE_NAME);
diff -puN drivers/acpi/battery.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/battery.c
--- a/drivers/acpi/battery.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/battery.c
@@ -160,12 +160,11 @@ acpi_battery_get_info(struct acpi_batter
 		goto end;
 	}
 
-	data.pointer = kmalloc(data.length, GFP_KERNEL);
+	data.pointer = kzalloc(data.length, GFP_KERNEL);
 	if (!data.pointer) {
 		result = -ENOMEM;
 		goto end;
 	}
-	memset(data.pointer, 0, data.length);
 
 	status = acpi_extract_package(package, &format, &data);
 	if (ACPI_FAILURE(status)) {
@@ -220,12 +219,11 @@ acpi_battery_get_status(struct acpi_batt
 		goto end;
 	}
 
-	data.pointer = kmalloc(data.length, GFP_KERNEL);
+	data.pointer = kzalloc(data.length, GFP_KERNEL);
 	if (!data.pointer) {
 		result = -ENOMEM;
 		goto end;
 	}
-	memset(data.pointer, 0, data.length);
 
 	status = acpi_extract_package(package, &format, &data);
 	if (ACPI_FAILURE(status)) {
@@ -694,10 +692,9 @@ static int acpi_battery_add(struct acpi_
 	if (!device)
 		return -EINVAL;
 
-	battery = kmalloc(sizeof(struct acpi_battery), GFP_KERNEL);
+	battery = kzalloc(sizeof(struct acpi_battery), GFP_KERNEL);
 	if (!battery)
 		return -ENOMEM;
-	memset(battery, 0, sizeof(struct acpi_battery));
 
 	battery->device = device;
 	strcpy(acpi_device_name(device), ACPI_BATTERY_DEVICE_NAME);
diff -puN drivers/acpi/container.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/container.c
--- a/drivers/acpi/container.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/container.c
@@ -96,11 +96,10 @@ static int acpi_container_add(struct acp
 		return -EINVAL;
 	}
 
-	container = kmalloc(sizeof(struct acpi_container), GFP_KERNEL);
+	container = kzalloc(sizeof(struct acpi_container), GFP_KERNEL);
 	if (!container)
 		return -ENOMEM;
 
-	memset(container, 0, sizeof(struct acpi_container));
 	container->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_CONTAINER_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_CONTAINER_CLASS);
diff -puN drivers/acpi/ec.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/ec.c
--- a/drivers/acpi/ec.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/ec.c
@@ -624,10 +624,9 @@ static int acpi_ec_add(struct acpi_devic
 	if (!device)
 		return -EINVAL;
 
-	ec = kmalloc(sizeof(struct acpi_ec), GFP_KERNEL);
+	ec = kzalloc(sizeof(struct acpi_ec), GFP_KERNEL);
 	if (!ec)
 		return -ENOMEM;
-	memset(ec, 0, sizeof(struct acpi_ec));
 
 	ec->handle = device->handle;
 	ec->uid = -1;
@@ -848,12 +847,11 @@ static int __init acpi_ec_fake_ecdt(void
 
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Try to make an fake ECDT"));
 
-	ec_ecdt = kmalloc(sizeof(struct acpi_ec), GFP_KERNEL);
+	ec_ecdt = kzalloc(sizeof(struct acpi_ec), GFP_KERNEL);
 	if (!ec_ecdt) {
 		ret = -ENOMEM;
 		goto error;
 	}
-	memset(ec_ecdt, 0, sizeof(struct acpi_ec));
 
 	status = acpi_get_devices(ACPI_EC_HID,
 				  acpi_fake_ecdt_callback, NULL, NULL);
@@ -885,10 +883,9 @@ static int __init acpi_ec_get_real_ecdt(
 	/*
 	 * Generate a temporary ec context to use until the namespace is scanned
 	 */
-	ec_ecdt = kmalloc(sizeof(struct acpi_ec), GFP_KERNEL);
+	ec_ecdt = kzalloc(sizeof(struct acpi_ec), GFP_KERNEL);
 	if (!ec_ecdt)
 		return -ENOMEM;
-	memset(ec_ecdt, 0, sizeof(struct acpi_ec));
 
 	mutex_init(&ec_ecdt->lock);
 	if (acpi_ec_mode == EC_INTR) {
diff -puN drivers/acpi/fan.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/fan.c
--- a/drivers/acpi/fan.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/fan.c
@@ -186,10 +186,9 @@ static int acpi_fan_add(struct acpi_devi
 	if (!device)
 		return -EINVAL;
 
-	fan = kmalloc(sizeof(struct acpi_fan), GFP_KERNEL);
+	fan = kzalloc(sizeof(struct acpi_fan), GFP_KERNEL);
 	if (!fan)
 		return -ENOMEM;
-	memset(fan, 0, sizeof(struct acpi_fan));
 
 	fan->device = device;
 	strcpy(acpi_device_name(device), "Fan");
diff -puN drivers/acpi/i2c_ec.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/i2c_ec.c
--- a/drivers/acpi/i2c_ec.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/i2c_ec.c
@@ -309,18 +309,16 @@ static int acpi_ec_hc_add(struct acpi_de
 		return -EINVAL;
 	}
 
-	ec_hc = kmalloc(sizeof(struct acpi_ec_hc), GFP_KERNEL);
+	ec_hc = kzalloc(sizeof(struct acpi_ec_hc), GFP_KERNEL);
 	if (!ec_hc) {
 		return -ENOMEM;
 	}
-	memset(ec_hc, 0, sizeof(struct acpi_ec_hc));
 
-	smbus = kmalloc(sizeof(struct acpi_ec_smbus), GFP_KERNEL);
+	smbus = kzalloc(sizeof(struct acpi_ec_smbus), GFP_KERNEL);
 	if (!smbus) {
 		kfree(ec_hc);
 		return -ENOMEM;
 	}
-	memset(smbus, 0, sizeof(struct acpi_ec_smbus));
 
 	ec_hc->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_EC_HC_DEVICE_NAME);
diff -puN drivers/acpi/ibm_acpi.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/ibm_acpi.c
--- a/drivers/acpi/ibm_acpi.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/ibm_acpi.c
@@ -2516,13 +2516,12 @@ static int __init register_driver(struct
 {
 	int ret;
 
-	ibm->driver = kmalloc(sizeof(struct acpi_driver), GFP_KERNEL);
+	ibm->driver = kzalloc(sizeof(struct acpi_driver), GFP_KERNEL);
 	if (!ibm->driver) {
 		printk(IBM_ERR "kmalloc(ibm->driver) failed\n");
 		return -1;
 	}
 
-	memset(ibm->driver, 0, sizeof(struct acpi_driver));
 	sprintf(ibm->driver->name, "%s_%s", IBM_NAME, ibm->name);
 	ibm->driver->ids = ibm->hid;
 	ibm->driver->ops.add = &ibm_device_add;
diff -puN drivers/acpi/pci_bind.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/pci_bind.c
--- a/drivers/acpi/pci_bind.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/pci_bind.c
@@ -122,19 +122,17 @@ int acpi_pci_bind(struct acpi_device *de
 	if (!device || !device->parent)
 		return -EINVAL;
 
-	pathname = kmalloc(ACPI_PATHNAME_MAX, GFP_KERNEL);
+	pathname = kzalloc(ACPI_PATHNAME_MAX, GFP_KERNEL);
 	if (!pathname)
 		return -ENOMEM;
-	memset(pathname, 0, ACPI_PATHNAME_MAX);
 	buffer.length = ACPI_PATHNAME_MAX;
 	buffer.pointer = pathname;
 
-	data = kmalloc(sizeof(struct acpi_pci_data), GFP_KERNEL);
+	data = kzalloc(sizeof(struct acpi_pci_data), GFP_KERNEL);
 	if (!data) {
 		kfree(pathname);
 		return -ENOMEM;
 	}
-	memset(data, 0, sizeof(struct acpi_pci_data));
 
 	acpi_get_name(device->handle, ACPI_FULL_PATHNAME, &buffer);
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Binding PCI device [%s]...\n",
@@ -281,10 +279,9 @@ int acpi_pci_unbind(struct acpi_device *
 	if (!device || !device->parent)
 		return -EINVAL;
 
-	pathname = kmalloc(ACPI_PATHNAME_MAX, GFP_KERNEL);
+	pathname = kzalloc(ACPI_PATHNAME_MAX, GFP_KERNEL);
 	if (!pathname)
 		return -ENOMEM;
-	memset(pathname, 0, ACPI_PATHNAME_MAX);
 
 	buffer.length = ACPI_PATHNAME_MAX;
 	buffer.pointer = pathname;
@@ -331,11 +328,9 @@ acpi_pci_bind_root(struct acpi_device *d
 	char *pathname = NULL;
 	struct acpi_buffer buffer = { 0, NULL };
 
-
-	pathname = kmalloc(ACPI_PATHNAME_MAX, GFP_KERNEL);
+	pathname = kzalloc(ACPI_PATHNAME_MAX, GFP_KERNEL);
 	if (!pathname)
 		return -ENOMEM;
-	memset(pathname, 0, ACPI_PATHNAME_MAX);
 
 	buffer.length = ACPI_PATHNAME_MAX;
 	buffer.pointer = pathname;
@@ -345,12 +340,11 @@ acpi_pci_bind_root(struct acpi_device *d
 		return -EINVAL;
 	}
 
-	data = kmalloc(sizeof(struct acpi_pci_data), GFP_KERNEL);
+	data = kzalloc(sizeof(struct acpi_pci_data), GFP_KERNEL);
 	if (!data) {
 		kfree(pathname);
 		return -ENOMEM;
 	}
-	memset(data, 0, sizeof(struct acpi_pci_data));
 
 	data->id = *id;
 	data->bus = bus;
diff -puN drivers/acpi/pci_irq.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/pci_irq.c
--- a/drivers/acpi/pci_irq.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/pci_irq.c
@@ -89,10 +89,9 @@ acpi_pci_irq_add_entry(acpi_handle handl
 	if (!prt)
 		return -EINVAL;
 
-	entry = kmalloc(sizeof(struct acpi_prt_entry), GFP_KERNEL);
+	entry = kzalloc(sizeof(struct acpi_prt_entry), GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
-	memset(entry, 0, sizeof(struct acpi_prt_entry));
 
 	entry->id.segment = segment;
 	entry->id.bus = bus;
@@ -161,10 +160,9 @@ int acpi_pci_irq_add_prt(acpi_handle han
 	static int first_time = 1;
 
 
-	pathname = kmalloc(ACPI_PATHNAME_MAX, GFP_KERNEL);
+	pathname = kzalloc(ACPI_PATHNAME_MAX, GFP_KERNEL);
 	if (!pathname)
 		return -ENOMEM;
-	memset(pathname, 0, ACPI_PATHNAME_MAX);
 
 	if (first_time) {
 		acpi_prt.count = 0;
@@ -198,11 +196,10 @@ int acpi_pci_irq_add_prt(acpi_handle han
 		return -ENODEV;
 	}
 
-	prt = kmalloc(buffer.length, GFP_KERNEL);
+	prt = kzalloc(buffer.length, GFP_KERNEL);
 	if (!prt) {
 		return -ENOMEM;
 	}
-	memset(prt, 0, buffer.length);
 	buffer.pointer = prt;
 
 	status = acpi_get_irq_routing_table(handle, &buffer);
diff -puN drivers/acpi/pci_link.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/pci_link.c
--- a/drivers/acpi/pci_link.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/pci_link.c
@@ -307,11 +307,10 @@ static int acpi_pci_link_set(struct acpi
 	if (!link || !irq)
 		return -EINVAL;
 
-	resource = kmalloc(sizeof(*resource) + 1, irqs_disabled() ? GFP_ATOMIC: GFP_KERNEL);
+	resource = kzalloc(sizeof(*resource) + 1, irqs_disabled() ? GFP_ATOMIC: GFP_KERNEL);
 	if (!resource)
 		return -ENOMEM;
 
-	memset(resource, 0, sizeof(*resource) + 1);
 	buffer.length = sizeof(*resource) + 1;
 	buffer.pointer = resource;
 
@@ -718,10 +717,9 @@ static int acpi_pci_link_add(struct acpi
 	if (!device)
 		return -EINVAL;
 
-	link = kmalloc(sizeof(struct acpi_pci_link), GFP_KERNEL);
+	link = kzalloc(sizeof(struct acpi_pci_link), GFP_KERNEL);
 	if (!link)
 		return -ENOMEM;
-	memset(link, 0, sizeof(struct acpi_pci_link));
 
 	link->device = device;
 	strcpy(acpi_device_name(device), ACPI_PCI_LINK_DEVICE_NAME);
diff -puN drivers/acpi/pci_root.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/pci_root.c
--- a/drivers/acpi/pci_root.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/pci_root.c
@@ -165,10 +165,9 @@ static int acpi_pci_root_add(struct acpi
 	if (!device)
 		return -EINVAL;
 
-	root = kmalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
+	root = kzalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
 	if (!root)
 		return -ENOMEM;
-	memset(root, 0, sizeof(struct acpi_pci_root));
 	INIT_LIST_HEAD(&root->node);
 
 	root->device = device;
diff -puN drivers/acpi/power.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/power.c
--- a/drivers/acpi/power.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/power.c
@@ -532,10 +532,9 @@ static int acpi_power_add(struct acpi_de
 	if (!device)
 		return -EINVAL;
 
-	resource = kmalloc(sizeof(struct acpi_power_resource), GFP_KERNEL);
+	resource = kzalloc(sizeof(struct acpi_power_resource), GFP_KERNEL);
 	if (!resource)
 		return -ENOMEM;
-	memset(resource, 0, sizeof(struct acpi_power_resource));
 
 	resource->device = device;
 	strcpy(resource->name, device->pnp.bus_id);
diff -puN drivers/acpi/processor_core.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/processor_core.c
@@ -615,10 +615,9 @@ static int acpi_processor_add(struct acp
 	if (!device)
 		return -EINVAL;
 
-	pr = kmalloc(sizeof(struct acpi_processor), GFP_KERNEL);
+	pr = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
 	if (!pr)
 		return -ENOMEM;
-	memset(pr, 0, sizeof(struct acpi_processor));
 
 	pr->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_PROCESSOR_DEVICE_NAME);
diff -puN drivers/acpi/sbs.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/sbs.c
@@ -1576,12 +1576,11 @@ static int acpi_sbs_add(struct acpi_devi
 	int id, cnt;
 	acpi_status status = AE_OK;
 
-	sbs = kmalloc(sizeof(struct acpi_sbs), GFP_KERNEL);
+	sbs = kzalloc(sizeof(struct acpi_sbs), GFP_KERNEL);
 	if (!sbs) {
 		ACPI_DEBUG_PRINT((ACPI_DB_ERROR, "kmalloc() failed\n"));
 		return -ENOMEM;
 	}
-	memset(sbs, 0, sizeof(struct acpi_sbs));
 
 	cnt = 0;
 	while (cnt < 10) {
diff -puN drivers/acpi/scan.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/scan.c
--- a/drivers/acpi/scan.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/scan.c
@@ -984,12 +984,11 @@ acpi_add_single_object(struct acpi_devic
 	if (!child)
 		return -EINVAL;
 
-	device = kmalloc(sizeof(struct acpi_device), GFP_KERNEL);
+	device = kzalloc(sizeof(struct acpi_device), GFP_KERNEL);
 	if (!device) {
 		printk(KERN_ERR PREFIX "Memory allocation error\n");
 		return -ENOMEM;
 	}
-	memset(device, 0, sizeof(struct acpi_device));
 
 	device->handle = handle;
 	device->parent = parent;
diff -puN drivers/acpi/thermal.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/thermal.c
--- a/drivers/acpi/thermal.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/thermal.c
@@ -902,12 +902,10 @@ acpi_thermal_write_trip_points(struct fi
 	int i = 0;
 
 
-	limit_string = kmalloc(ACPI_THERMAL_MAX_LIMIT_STR_LEN, GFP_KERNEL);
+	limit_string = kzalloc(ACPI_THERMAL_MAX_LIMIT_STR_LEN, GFP_KERNEL);
 	if (!limit_string)
 		return -ENOMEM;
 
-	memset(limit_string, 0, ACPI_THERMAL_MAX_LIMIT_STR_LEN);
-
 	active = kmalloc(ACPI_THERMAL_MAX_ACTIVE * sizeof(int), GFP_KERNEL);
 	if (!active) {
 		kfree(limit_string);
@@ -1271,10 +1269,9 @@ static int acpi_thermal_add(struct acpi_
 	if (!device)
 		return -EINVAL;
 
-	tz = kmalloc(sizeof(struct acpi_thermal), GFP_KERNEL);
+	tz = kzalloc(sizeof(struct acpi_thermal), GFP_KERNEL);
 	if (!tz)
 		return -ENOMEM;
-	memset(tz, 0, sizeof(struct acpi_thermal));
 
 	tz->device = device;
 	strcpy(tz->name, device->pnp.bus_id);
diff -puN drivers/acpi/utils.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/utils.c
--- a/drivers/acpi/utils.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/utils.c
@@ -262,11 +262,10 @@ acpi_evaluate_integer(acpi_handle handle
 	if (!data)
 		return AE_BAD_PARAMETER;
 
-	element = kmalloc(sizeof(union acpi_object), irqs_disabled() ? GFP_ATOMIC: GFP_KERNEL);
+	element = kzalloc(sizeof(union acpi_object), irqs_disabled() ? GFP_ATOMIC: GFP_KERNEL);
 	if (!element)
 		return AE_NO_MEMORY;
 
-	memset(element, 0, sizeof(union acpi_object));
 	buffer.length = sizeof(union acpi_object);
 	buffer.pointer = element;
 	status = acpi_evaluate_object(handle, pathname, arguments, &buffer);
@@ -321,12 +320,11 @@ acpi_evaluate_string(acpi_handle handle,
 		return AE_BAD_DATA;
 	}
 
-	*data = kmalloc(element->string.length + 1, GFP_KERNEL);
+	*data = kzalloc(element->string.length + 1, GFP_KERNEL);
 	if (!data) {
 		printk(KERN_ERR PREFIX "Memory allocation\n");
 		return -ENOMEM;
 	}
-	memset(*data, 0, element->string.length + 1);
 
 	memcpy(*data, element->string.pointer, element->string.length);
 
diff -puN drivers/acpi/video.c~acpi-replace-kmallocmemset-with-kzalloc drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/acpi/video.c
@@ -532,11 +532,10 @@ static void acpi_video_device_find_cap(s
 		int count = 0;
 		union acpi_object *o;
 
-		br = kmalloc(sizeof(*br), GFP_KERNEL);
+		br = kzalloc(sizeof(*br), GFP_KERNEL);
 		if (!br) {
 			printk(KERN_ERR "can't allocate memory\n");
 		} else {
-			memset(br, 0, sizeof(*br));
 			br->levels = kmalloc(obj->package.count *
 					     sizeof *(br->levels), GFP_KERNEL);
 			if (!br->levels)
@@ -1259,12 +1258,10 @@ acpi_video_bus_get_one_device(struct acp
 	    acpi_evaluate_integer(device->handle, "_ADR", NULL, &device_id);
 	if (ACPI_SUCCESS(status)) {
 
-		data = kmalloc(sizeof(struct acpi_video_device), GFP_KERNEL);
+		data = kzalloc(sizeof(struct acpi_video_device), GFP_KERNEL);
 		if (!data)
 			return -ENOMEM;
 
-		memset(data, 0, sizeof(struct acpi_video_device));
-
 		strcpy(acpi_device_name(device), ACPI_VIDEO_DEVICE_NAME);
 		strcpy(acpi_device_class(device), ACPI_VIDEO_CLASS);
 		acpi_driver_data(device) = data;
@@ -1691,10 +1688,9 @@ static int acpi_video_bus_add(struct acp
 	if (!device)
 		return -EINVAL;
 
-	video = kmalloc(sizeof(struct acpi_video_bus), GFP_KERNEL);
+	video = kzalloc(sizeof(struct acpi_video_bus), GFP_KERNEL);
 	if (!video)
 		return -ENOMEM;
-	memset(video, 0, sizeof(struct acpi_video_bus));
 
 	video->device = device;
 	strcpy(acpi_device_name(device), ACPI_VIDEO_BUS_NAME);
diff -puN drivers/pci/hotplug/acpiphp_ibm.c~acpi-replace-kmallocmemset-with-kzalloc drivers/pci/hotplug/acpiphp_ibm.c
--- a/drivers/pci/hotplug/acpiphp_ibm.c~acpi-replace-kmallocmemset-with-kzalloc
+++ a/drivers/pci/hotplug/acpiphp_ibm.c
@@ -319,13 +319,12 @@ static int ibm_get_table_from_acpi(char 
 	if (bufp == NULL)
 		goto read_table_done;
 
-	lbuf = kmalloc(size, GFP_KERNEL);
+	lbuf = kzalloc(size, GFP_KERNEL);
 	dbg("%s: element count: %i, ASL table size: %i, &table = 0x%p\n",
 			__FUNCTION__, package->package.count, size, lbuf);
 
 	if (lbuf) {
 		*bufp = lbuf;
-		memset(lbuf, 0, size);
 	} else {
 		size = -ENOMEM;
 		goto read_table_done;
_

Patches currently in -mm which might be from yan_952@hotmail.com are

git-acpi.patch
git-mtd.patch
serial-replace-kmallocmemset-with-kzalloc.patch


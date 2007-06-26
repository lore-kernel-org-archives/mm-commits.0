From: akpm@linux-foundation.org
Subject: + intel-iommu-dmar-detection-and-parsing-logic.patch added to -mm tree
Date: Mon, 25 Jun 2007 23:42:43 -0700
Message-ID: <200706260642.l5Q6ghZo020203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48388 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922AbXFZGnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 02:43:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anil.s.keshavamurthy@intel.com, a.p.zijlstra@chello.nl, ak@suse.de, arjan@infradead.org, ashok.raj@intel.com, clameter@sgi.com, davem@davemloft.net, greg@kroah.com, lenb@kernel.org, muli@il.ibm.com, suresh.b.siddha@intel.com


The patch titled
     Intel IOMMU: DMAR detection and parsing logic
has been added to the -mm tree.  Its filename is
     intel-iommu-dmar-detection-and-parsing-logic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Intel IOMMU: DMAR detection and parsing logic
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

This patch supports the upcomming Intel IOMMU hardware a.k.a.  Intel(R)
Virtualization Technology for Directed I/O Architecture and the hardware spec
for the same can be found here
http://www.intel.com/technology/virtualization/index.htm


This patch:

Add support for early detection and parsing of DMAR's (DMA Remapping) reported
to OS via ACPI tables.

DMA remapping(DMAR) devices support enables independent address translations
for Direct Memory Access(DMA) from Devices.  These DMA remapping devices are
reported via ACPI tables and includes pci device scope covered by these DMA
remapping device.

For detailed info on the specification of "Intel(R) Virtualization Technology
for Directed I/O Architecture" please see
http://www.intel.com/technology/virtualization/index.htm

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Greg KH <greg@kroah.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Kconfig   |   11 +
 drivers/pci/Makefile  |    3 
 drivers/pci/dmar.c    |  327 ++++++++++++++++++++++++++++++++++++++++
 include/acpi/actbl1.h |   27 ++-
 include/linux/dmar.h  |   52 ++++++
 5 files changed, 413 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/Kconfig~intel-iommu-dmar-detection-and-parsing-logic arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~intel-iommu-dmar-detection-and-parsing-logic
+++ a/arch/x86_64/Kconfig
@@ -748,6 +748,17 @@ config PCI_MMCONFIG
 	bool "Support mmconfig PCI config space access"
 	depends on PCI && ACPI
 
+config DMAR
+	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
+	depends on PCI_MSI && ACPI && EXPERIMENTAL
+	default y
+	help
+	  DMA remapping(DMAR) devices support enables independent address
+	  translations for Direct Memory Access(DMA) from Devices.
+	  These DMA remapping devices are reported via ACPI tables
+	  and includes pci device scope covered by these DMA
+	  remapping device.
+
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
diff -puN drivers/pci/Makefile~intel-iommu-dmar-detection-and-parsing-logic drivers/pci/Makefile
--- a/drivers/pci/Makefile~intel-iommu-dmar-detection-and-parsing-logic
+++ a/drivers/pci/Makefile
@@ -20,6 +20,9 @@ obj-$(CONFIG_PCI_MSI) += msi.o
 # Build the Hypertransport interrupt support
 obj-$(CONFIG_HT_IRQ) += htirq.o
 
+# Build Intel IOMMU support
+obj-$(CONFIG_DMAR) += dmar.o
+
 #
 # Some architectures use the generic PCI setup functions
 #
diff -puN /dev/null drivers/pci/dmar.c
--- /dev/null
+++ a/drivers/pci/dmar.c
@@ -0,0 +1,327 @@
+/*
+ * Copyright (c) 2006, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * 	Copyright (C) Ashok Raj <ashok.raj@intel.com>
+ *	Copyright (C) Shaohua Li <shaohua.li@intel.com>
+ *	Copyright (C) Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ *
+ * 	This file implements early detection/parsing of DMA Remapping Devices
+ * reported to OS through BIOS via DMA remapping reporting (DMAR) ACPI
+ * tables.
+ */
+
+#include <linux/pci.h>
+#include <linux/dmar.h>
+
+#undef PREFIX
+#define PREFIX "DMAR:"
+
+/* No locks are needed as DMA remapping hardware unit
+ * list is constructed at boot time and hotplug of
+ * these units are not supported by the architecture.
+ */
+LIST_HEAD(dmar_drhd_units);
+LIST_HEAD(dmar_rmrr_units);
+
+static struct acpi_table_header * __initdata dmar_tbl;
+
+static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
+{
+	/*
+	 * add INCLUDE_ALL at the tail, so scan the list will find it at
+	 * the very end.
+	 */
+	if (drhd->include_all)
+		list_add_tail(&drhd->list, &dmar_drhd_units);
+	else
+		list_add(&drhd->list, &dmar_drhd_units);
+}
+
+static void __init dmar_register_rmrr_unit(struct dmar_rmrr_unit *rmrr)
+{
+	list_add(&rmrr->list, &dmar_rmrr_units);
+}
+
+static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
+					   struct pci_dev **dev, u16 segment)
+{
+	struct pci_bus *bus;
+	struct pci_dev *pdev = NULL;
+	struct acpi_dmar_pci_path *path;
+	int count;
+
+	bus = pci_find_bus(segment, scope->bus);
+	path = (struct acpi_dmar_pci_path *)(scope + 1);
+	count = (scope->length - sizeof(struct acpi_dmar_device_scope))
+		/ sizeof(struct acpi_dmar_pci_path);
+
+	while (count) {
+		if (pdev)
+			pci_dev_put(pdev);
+		/*
+		 * Some BIOSes list non-exist devices in DMAR table, just
+		 * ignore it
+		 */
+		if (!bus) {
+			printk(KERN_WARNING
+			PREFIX "Device scope bus [%d] not found\n",
+			scope->bus);
+			break;
+		}
+		pdev = pci_get_slot(bus, PCI_DEVFN(path->dev, path->fn));
+		if (!pdev) {
+			printk(KERN_WARNING PREFIX
+			"Device scope device [%04x:%02x:%02x.%02x] not found\n",
+				segment, bus->number, path->dev, path->fn);
+			break;
+		}
+		path ++;
+		count --;
+		bus = pdev->subordinate;
+	}
+	if (!pdev) {
+		printk(KERN_WARNING PREFIX
+		"Device scope device [%04x:%02x:%02x.%02x] not found\n",
+		segment, scope->bus, path->dev, path->fn);
+		*dev = NULL;
+		return 0;
+	}
+	if ((scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT && \
+			pdev->subordinate) || (scope->entry_type == \
+			ACPI_DMAR_SCOPE_TYPE_BRIDGE && !pdev->subordinate)) {
+		pci_dev_put(pdev);
+		printk(KERN_WARNING PREFIX
+			"Device scope type does not match for %s\n",
+			 pci_name(pdev));
+		return -EINVAL;
+	}
+	*dev = pdev;
+	return 0;
+}
+
+static int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
+				       struct pci_dev ***devices, u16 segment)
+{
+	struct acpi_dmar_device_scope *scope;
+	void * tmp = start;
+	int index;
+	int ret;
+
+	*cnt = 0;
+	while (start < end) {
+		scope = start;
+		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
+		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
+			(*cnt)++;
+		else
+			printk(KERN_WARNING PREFIX
+				"Unsupported device scope\n");
+		start += scope->length;
+	}
+	if (*cnt == 0)
+		return 0;
+
+	*devices = kcalloc(*cnt, sizeof(struct pci_dev *), GFP_KERNEL);
+	if (!*devices)
+		return -ENOMEM;
+
+	start = tmp;
+	index = 0;
+	while (start < end) {
+		scope = start;
+		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
+		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE) {
+			ret = dmar_parse_one_dev_scope(scope,
+				&(*devices)[index], segment);
+			if (ret) {
+				kfree(*devices);
+				return ret;
+			}
+			index ++;
+		}
+		start += scope->length;
+	}
+
+	return 0;
+}
+
+/**
+ * dmar_parse_one_drhd - parses exactly one DMA remapping hardware definition
+ * structure which uniquely represent one DMA remapping hardware unit
+ * present in the platform
+ */
+static int __init
+dmar_parse_one_drhd(struct acpi_dmar_header *header)
+{
+	struct acpi_dmar_hardware_unit *drhd;
+	struct dmar_drhd_unit *dmaru;
+	int ret = 0;
+	static int include_all;
+
+	dmaru = kzalloc(sizeof(*dmaru), GFP_KERNEL);
+	if (!dmaru)
+		return -ENOMEM;
+
+	drhd = (struct acpi_dmar_hardware_unit *)header;
+	dmaru->reg_base_addr = drhd->address;
+	dmaru->include_all = drhd->flags & 0x1; /* BIT0: INCLUDE_ALL */
+
+	if (!dmaru->include_all)
+		ret = dmar_parse_dev_scope((void *)(drhd + 1),
+				((void *)drhd) + header->length,
+				&dmaru->devices_cnt, &dmaru->devices,
+				drhd->segment);
+	else {
+		/* Only allow one INCLUDE_ALL */
+		if (include_all) {
+			printk(KERN_WARNING PREFIX "Only one INCLUDE_ALL "
+				"device scope is allowed\n");
+			ret = -EINVAL;
+		}
+		include_all = 1;
+	}
+
+	if (ret || (dmaru->devices_cnt == 0 && !dmaru->include_all))
+		kfree(dmaru);
+	else
+		dmar_register_drhd_unit(dmaru);
+	return ret;
+}
+
+static int __init
+dmar_parse_one_rmrr(struct acpi_dmar_header *header)
+{
+	struct acpi_dmar_reserved_memory *rmrr;
+	struct dmar_rmrr_unit *rmrru;
+	int ret = 0;
+
+	rmrru = kzalloc(sizeof(*rmrru), GFP_KERNEL);
+	if (!rmrru)
+		return -ENOMEM;
+
+	rmrr = (struct acpi_dmar_reserved_memory *)header;
+	rmrru->base_address = rmrr->base_address;
+	rmrru->end_address = rmrr->end_address;
+	ret = dmar_parse_dev_scope((void *)(rmrr + 1),
+		((void *)rmrr) + header->length,
+		&rmrru->devices_cnt, &rmrru->devices, rmrr->segment);
+
+	if (ret || (rmrru->devices_cnt == 0))
+		kfree(rmrru);
+	else
+		dmar_register_rmrr_unit(rmrru);
+	return ret;
+}
+
+static void __init
+dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
+{
+	struct acpi_dmar_hardware_unit *drhd;
+	struct acpi_dmar_reserved_memory *rmrr;
+
+	switch (header->type) {
+	case ACPI_DMAR_TYPE_HARDWARE_UNIT:
+		drhd = (struct acpi_dmar_hardware_unit *)header;
+		printk (KERN_INFO PREFIX
+			"DRHD (flags: 0x%08x)base: 0x%016Lx\n",
+			drhd->flags, drhd->address);
+		break;
+	case ACPI_DMAR_TYPE_RESERVED_MEMORY:
+		rmrr = (struct acpi_dmar_reserved_memory *)header;
+
+		printk (KERN_INFO PREFIX
+			"RMRR base: 0x%016Lx end: 0x%016Lx\n",
+			rmrr->base_address, rmrr->end_address);
+		break;
+	}
+}
+
+/**
+ * parse_dmar_table - parses the DMA reporting table
+ */
+static int __init
+parse_dmar_table(void)
+{
+	struct acpi_table_dmar *dmar;
+	struct acpi_dmar_header *entry_header;
+	int ret = 0;
+
+	dmar = (struct acpi_table_dmar *)dmar_tbl;
+
+	if (!dmar->width) {
+		printk (KERN_WARNING PREFIX "Zero: Invalid DMAR haw\n");
+		return -EINVAL;
+	}
+
+	printk (KERN_INFO PREFIX "Host address width %d\n",
+		dmar->width + 1);
+
+	entry_header = (struct acpi_dmar_header *)(dmar + 1);
+	while (((unsigned long)entry_header) <
+			(((unsigned long)dmar) + dmar_tbl->length)) {
+		dmar_table_print_dmar_entry(entry_header);
+
+		switch (entry_header->type) {
+		case ACPI_DMAR_TYPE_HARDWARE_UNIT:
+			ret = dmar_parse_one_drhd(entry_header);
+			break;
+		case ACPI_DMAR_TYPE_RESERVED_MEMORY:
+			ret = dmar_parse_one_rmrr(entry_header);
+			break;
+		default:
+			printk(KERN_WARNING PREFIX
+				"Unknown DMAR structure type\n");
+			ret = 0; /* for forward compatibility */
+			break;
+		}
+		if (ret)
+			break;
+
+		entry_header = ((void *)entry_header + entry_header->length);
+	}
+	return ret;
+}
+
+
+int __init dmar_table_init(void)
+{
+
+	parse_dmar_table();
+	if (list_empty(&dmar_drhd_units)) {
+		printk(KERN_ERR PREFIX "No DMAR devices found\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+
+/**
+ * early_dmar_detect - checks to see if the platform supports DMAR devices
+ */
+int __init early_dmar_detect(void)
+{
+	acpi_status status = AE_OK;
+
+	/* if we could find DMAR table, then there are DMAR devices */
+	status = acpi_get_table(ACPI_SIG_DMAR, 0,
+				(struct acpi_table_header **)&dmar_tbl);
+
+	if (ACPI_SUCCESS(status) && !dmar_tbl) {
+		printk (KERN_WARNING PREFIX "Unable to map DMAR\n");
+		status = AE_NOT_FOUND;
+	}
+
+	return (ACPI_SUCCESS(status) ? 1 : 0);
+}
diff -puN include/acpi/actbl1.h~intel-iommu-dmar-detection-and-parsing-logic include/acpi/actbl1.h
--- a/include/acpi/actbl1.h~intel-iommu-dmar-detection-and-parsing-logic
+++ a/include/acpi/actbl1.h
@@ -257,7 +257,8 @@ struct acpi_table_dbgp {
 struct acpi_table_dmar {
 	struct acpi_table_header header;	/* Common ACPI table header */
 	u8 width;		/* Host Address Width */
-	u8 reserved[11];
+	u8 flags;
+	u8 reserved[10];
 };
 
 /* DMAR subtable header */
@@ -265,8 +266,6 @@ struct acpi_table_dmar {
 struct acpi_dmar_header {
 	u16 type;
 	u16 length;
-	u8 flags;
-	u8 reserved[3];
 };
 
 /* Values for subtable type in struct acpi_dmar_header */
@@ -274,13 +273,15 @@ struct acpi_dmar_header {
 enum acpi_dmar_type {
 	ACPI_DMAR_TYPE_HARDWARE_UNIT = 0,
 	ACPI_DMAR_TYPE_RESERVED_MEMORY = 1,
-	ACPI_DMAR_TYPE_RESERVED = 2	/* 2 and greater are reserved */
+	ACPI_DMAR_TYPE_ATSR = 2,
+	ACPI_DMAR_TYPE_RESERVED = 3	/* 3 and greater are reserved */
 };
 
 struct acpi_dmar_device_scope {
 	u8 entry_type;
 	u8 length;
-	u8 segment;
+	u16 reserved;
+	u8 enumeration_id;
 	u8 bus;
 };
 
@@ -290,7 +291,14 @@ enum acpi_dmar_scope_type {
 	ACPI_DMAR_SCOPE_TYPE_NOT_USED = 0,
 	ACPI_DMAR_SCOPE_TYPE_ENDPOINT = 1,
 	ACPI_DMAR_SCOPE_TYPE_BRIDGE = 2,
-	ACPI_DMAR_SCOPE_TYPE_RESERVED = 3	/* 3 and greater are reserved */
+	ACPI_DMAR_SCOPE_TYPE_IOAPIC = 3,
+	ACPI_DMAR_SCOPE_TYPE_HPET = 4,
+	ACPI_DMAR_SCOPE_TYPE_RESERVED = 5	/* 5 and greater are reserved */
+};
+
+struct acpi_dmar_pci_path {
+	u8 dev;
+	u8 fn;
 };
 
 /*
@@ -301,6 +309,9 @@ enum acpi_dmar_scope_type {
 
 struct acpi_dmar_hardware_unit {
 	struct acpi_dmar_header header;
+	u8 flags;
+	u8 reserved;
+	u16 segment;
 	u64 address;		/* Register Base Address */
 };
 
@@ -312,7 +323,9 @@ struct acpi_dmar_hardware_unit {
 
 struct acpi_dmar_reserved_memory {
 	struct acpi_dmar_header header;
-	u64 address;		/* 4_k aligned base address */
+	u16 reserved;
+	u16 segment;
+	u64 base_address;		/* 4_k aligned base address */
 	u64 end_address;	/* 4_k aligned limit address */
 };
 
diff -puN /dev/null include/linux/dmar.h
--- /dev/null
+++ a/include/linux/dmar.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (c) 2006, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * Copyright (C) Ashok Raj <ashok.raj@intel.com>
+ * Copyright (C) Shaohua Li <shaohua.li@intel.com>
+ */
+
+#ifndef __DMAR_H__
+#define __DMAR_H__
+
+#include <linux/acpi.h>
+#include <linux/types.h>
+
+
+extern int dmar_table_init(void);
+extern int early_dmar_detect(void);
+
+extern struct list_head dmar_drhd_units;
+extern struct list_head dmar_rmrr_units;
+
+struct dmar_drhd_unit {
+	struct list_head list;		/* list of drhd units	*/
+	u64	reg_base_addr;		/* register base address*/
+	struct	pci_dev **devices; 	/* target device array	*/
+	int	devices_cnt;		/* target device count	*/
+	u8	ignored:1; 		/* ignore drhd		*/
+	u8	include_all:1;
+	struct intel_iommu *iommu;
+};
+
+struct dmar_rmrr_unit {
+	struct list_head list;		/* list of rmrr units	*/
+	u64	base_address;		/* reserved base address*/
+	u64	end_address;		/* reserved end address */
+	struct pci_dev **devices;	/* target devices */
+	int	devices_cnt;		/* target device count */
+};
+
+#endif /* __DMAR_H__ */
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

jprobes-make-struct-jprobeentry-a-void.patch
jprobes-remove-jprobe_entry.patch
jprobes-make-jprobes-a-little-safer-for-users.patch
jprobes-make-jprobes-a-little-safer-for-users-fix.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch

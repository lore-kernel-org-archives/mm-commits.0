From: akpm@linux-foundation.org
Subject: - i-oat-add-dca-services.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:39:34 -0700
Message-ID: <200710162039.l9GKdYa4015555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39368 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965863AbXJPVRy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:17:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shannon.nelson@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     I/OAT: Add DCA services
has been removed from the -mm tree.  Its filename was
     i-oat-add-dca-services.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: I/OAT: Add DCA services
From: Shannon Nelson <shannon.nelson@intel.com>

Add code to connect to the DCA driver and provide cpu tags for use by
drivers that would like to use Direct Cache Access hints.

    [Adrian Bunk]                Several Kconfig cleanup items
    [Andrew Morten, Chris Leech] Fix for using cpu_physical_id() even when
			         built for uni-processor

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dca/Kconfig             |    6 
 drivers/dma/Kconfig             |   60 +++---
 drivers/dma/Makefile            |    2 
 drivers/dma/ioat.c              |   17 +
 drivers/dma/ioat_dca.c          |  263 ++++++++++++++++++++++++++++++
 drivers/dma/ioatdma.h           |    3 
 include/asm-x86/cpufeature_32.h |    1 
 7 files changed, 320 insertions(+), 32 deletions(-)

diff -puN drivers/dca/Kconfig~i-oat-add-dca-services drivers/dca/Kconfig
--- a/drivers/dca/Kconfig~i-oat-add-dca-services
+++ a/drivers/dca/Kconfig
@@ -3,9 +3,5 @@
 #
 
 config DCA
-	tristate "DCA support for clients and providers"
-	default m
-	help
-	  This is a server to help modules that want to use Direct Cache
-	  Access to find DCA providers that will supply correct CPU tags.
+	tristate
 
diff -puN drivers/dma/Kconfig~i-oat-add-dca-services drivers/dma/Kconfig
--- a/drivers/dma/Kconfig~i-oat-add-dca-services
+++ a/drivers/dma/Kconfig
@@ -2,42 +2,52 @@
 # DMA engine configuration
 #
 
-menu "DMA Engine support"
-	depends on HAS_DMA
+menuconfig DMADEVICES
+	bool "DMA Offload Engine support"
+	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
+	help
+	  Intel(R) offload engines enable offloading memory copies in the
+	  network stack and RAID operations in the MD driver.
+
+if DMADEVICES
+
+comment "DMA Devices"
+
+config INTEL_IOATDMA
+	tristate "Intel I/OAT DMA support"
+	depends on PCI && X86
+	select DMA_ENGINE
+	select DCA
+	help
+	  Enable support for the Intel(R) I/OAT DMA engine present
+	  in recent Intel Xeon chipsets.
+
+	  Say Y here if you have such a chipset.
+
+	  If unsure, say N.
+
+config INTEL_IOP_ADMA
+	tristate "Intel IOP ADMA support"
+	depends on ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
+	select ASYNC_CORE
+	select DMA_ENGINE
+	help
+	  Enable support for the Intel(R) IOP Series RAID engines.
 
 config DMA_ENGINE
-	bool "Support for DMA engines"
-	---help---
-          DMA engines offload bulk memory operations from the CPU to dedicated
-          hardware, allowing the operations to happen asynchronously.
+	bool
 
 comment "DMA Clients"
+	depends on DMA_ENGINE
 
 config NET_DMA
 	bool "Network: TCP receive copy offload"
 	depends on DMA_ENGINE && NET
 	default y
-	---help---
+	help
 	  This enables the use of DMA engines in the network stack to
 	  offload receive copy-to-user operations, freeing CPU cycles.
 	  Since this is the main user of the DMA engine, it should be enabled;
 	  say Y here.
 
-comment "DMA Devices"
-
-config INTEL_IOATDMA
-	tristate "Intel I/OAT DMA support"
-	depends on DMA_ENGINE && PCI
-	default m
-	---help---
-	  Enable support for the Intel(R) I/OAT DMA engine.
-
-config INTEL_IOP_ADMA
-        tristate "Intel IOP ADMA support"
-        depends on DMA_ENGINE && (ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX)
-	select ASYNC_CORE
-        default m
-        ---help---
-          Enable support for the Intel(R) IOP Series RAID engines.
-
-endmenu
+endif
diff -puN drivers/dma/Makefile~i-oat-add-dca-services drivers/dma/Makefile
--- a/drivers/dma/Makefile~i-oat-add-dca-services
+++ a/drivers/dma/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_DMA_ENGINE) += dmaengine.o
 obj-$(CONFIG_NET_DMA) += iovlock.o
 obj-$(CONFIG_INTEL_IOATDMA) += ioatdma.o
-ioatdma-objs := ioat.o ioat_dma.o
+ioatdma-objs := ioat.o ioat_dma.o ioat_dca.o
 obj-$(CONFIG_INTEL_IOP_ADMA) += iop-adma.o
diff -puN drivers/dma/ioat.c~i-oat-add-dca-services drivers/dma/ioat.c
--- a/drivers/dma/ioat.c~i-oat-add-dca-services
+++ a/drivers/dma/ioat.c
@@ -1,6 +1,6 @@
 /*
  * Intel I/OAT DMA Linux driver
- * Copyright(c) 2004 - 2007 Intel Corporation.
+ * Copyright(c) 2007 Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
+#include <linux/dca.h>
 #include "ioatdma.h"
 #include "ioatdma_registers.h"
 #include "ioatdma_hw.h"
@@ -49,6 +50,7 @@ struct ioat_device {
 	struct pci_dev		*pdev;
 	void __iomem		*iobase;
 	struct ioatdma_device	*dma;
+	struct dca_provider	*dca;
 };
 
 static int __devinit ioat_probe(struct pci_dev *pdev,
@@ -57,6 +59,10 @@ static int __devinit ioat_probe(struct p
 static void __devexit ioat_remove(struct pci_dev *pdev);
 #endif
 
+static int ioat_dca_enabled = 1;
+module_param(ioat_dca_enabled, int, 0644);
+MODULE_PARM_DESC(ioat_dca_enabled, "control support of dca service (default: 1)");
+
 static int ioat_setup_functionality(struct pci_dev *pdev, void __iomem *iobase)
 {
 	struct ioat_device *device = pci_get_drvdata(pdev);
@@ -67,6 +73,8 @@ static int ioat_setup_functionality(stru
 	switch (version) {
 	case IOAT_VER_1_2:
 		device->dma = ioat_dma_probe(pdev, iobase);
+		if (ioat_dca_enabled)
+			device->dca = ioat_dca_init(pdev, iobase);
 		break;
 	default:
 		err = -ENODEV;
@@ -83,6 +91,13 @@ static void ioat_shutdown_functionality(
 		ioat_dma_remove(device->dma);
 		device->dma = NULL;
 	}
+
+	if (device->dca) {
+		unregister_dca_provider(device->dca);
+		free_dca_provider(device->dca);
+		device->dca = NULL;
+	}
+
 }
 
 static struct pci_driver ioat_pci_drv = {
diff -puN /dev/null drivers/dma/ioat_dca.c
--- /dev/null
+++ a/drivers/dma/ioat_dca.c
@@ -0,0 +1,263 @@
+/*
+ * Intel I/OAT DMA Linux driver
+ * Copyright(c) 2007 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/smp.h>
+#include <linux/interrupt.h>
+#include <linux/dca.h>
+
+/* either a kernel change is needed, or we need something like this in kernel */
+#ifndef CONFIG_SMP
+#include <asm/smp.h>
+#undef cpu_physical_id
+#define cpu_physical_id(cpu) (cpuid_ebx(1) >> 24)
+#endif
+
+#include "ioatdma.h"
+#include "ioatdma_registers.h"
+
+/*
+ * Bit 16 of a tag map entry is the "valid" bit, if it is set then bits 0:15
+ * contain the bit number of the APIC ID to map into the DCA tag.  If the valid
+ * bit is not set, then the value must be 0 or 1 and defines the bit in the tag.
+ */
+#define DCA_TAG_MAP_VALID 0x80
+
+/*
+ * "Legacy" DCA systems do not implement the DCA register set in the
+ * I/OAT device.  Software needs direct support for their tag mappings.
+ */
+
+#define APICID_BIT(x)		(DCA_TAG_MAP_VALID | (x))
+#define IOAT_TAG_MAP_LEN	8
+
+static u8 ioat_tag_map_BNB[IOAT_TAG_MAP_LEN] = {
+	1, APICID_BIT(1), APICID_BIT(2), APICID_BIT(2), };
+static u8 ioat_tag_map_SCNB[IOAT_TAG_MAP_LEN] = {
+	1, APICID_BIT(1), APICID_BIT(2), APICID_BIT(2), };
+static u8 ioat_tag_map_CNB[IOAT_TAG_MAP_LEN] = {
+	1, APICID_BIT(1), APICID_BIT(3), APICID_BIT(4), APICID_BIT(2), };
+static u8 ioat_tag_map_UNISYS[IOAT_TAG_MAP_LEN] = { 0 };
+
+/* pack PCI B/D/F into a u16 */
+static inline u16 dcaid_from_pcidev(struct pci_dev *pci)
+{
+	return (pci->bus->number << 8) | pci->devfn;
+}
+
+static int dca_enabled_in_bios(void)
+{
+	/* CPUID level 9 returns DCA configuration */
+	/* Bit 0 indicates DCA enabled by the BIOS */
+	unsigned long cpuid_level_9;
+	int res;
+
+	cpuid_level_9 = cpuid_eax(9);
+	res = test_bit(0, &cpuid_level_9);
+	if (!res)
+		printk(KERN_ERR "ioat dma: DCA is disabled in BIOS\n");
+
+	return res;
+}
+
+static int system_has_dca_enabled(void)
+{
+	if (boot_cpu_has(X86_FEATURE_DCA))
+		return dca_enabled_in_bios();
+
+	printk(KERN_ERR "ioat dma: boot cpu doesn't have X86_FEATURE_DCA\n");
+	return 0;
+}
+
+struct ioat_dca_slot {
+	struct pci_dev *pdev;	/* requester device */
+	u16 rid;		/* requester id, as used by IOAT */
+};
+
+#define IOAT_DCA_MAX_REQ 6
+
+struct ioat_dca_priv {
+	void __iomem		*iobase;
+	void			*dca_base;
+	int			 max_requesters;
+	int			 requester_count;
+	u8			 tag_map[IOAT_TAG_MAP_LEN];
+	struct ioat_dca_slot 	 req_slots[0];
+};
+
+/* 5000 series chipset DCA Port Requester ID Table Entry Format
+ * [15:8]	PCI-Express Bus Number
+ * [7:3]	PCI-Express Device Number
+ * [2:0]	PCI-Express Function Number
+ *
+ * 5000 series chipset DCA control register format
+ * [7:1]	Reserved (0)
+ * [0]		Ignore Function Number
+ */
+
+static int ioat_dca_add_requester(struct dca_provider *dca, struct device *dev)
+{
+	struct ioat_dca_priv *ioatdca = dca_priv(dca);
+	struct pci_dev *pdev;
+	int i;
+	u16 id;
+
+	/* This implementation only supports PCI-Express */
+	if (dev->bus != &pci_bus_type)
+		return -ENODEV;
+	pdev = to_pci_dev(dev);
+	id = dcaid_from_pcidev(pdev);
+
+	if (ioatdca->requester_count == ioatdca->max_requesters)
+		return -ENODEV;
+
+	for (i = 0; i < ioatdca->max_requesters; i++) {
+		if (ioatdca->req_slots[i].pdev == NULL) {
+			/* found an empty slot */
+			ioatdca->requester_count++;
+			ioatdca->req_slots[i].pdev = pdev;
+			ioatdca->req_slots[i].rid = id;
+			writew(id, ioatdca->dca_base + (i * 4));
+			/* make sure the ignore function bit is off */
+			writeb(0, ioatdca->dca_base + (i * 4) + 2);
+			return i;
+		}
+	}
+	/* Error, ioatdma->requester_count is out of whack */
+	return -EFAULT;
+}
+
+static int ioat_dca_remove_requester(struct dca_provider *dca,
+				     struct device *dev)
+{
+	struct ioat_dca_priv *ioatdca = dca_priv(dca);
+	struct pci_dev *pdev;
+	int i;
+
+	/* This implementation only supports PCI-Express */
+	if (dev->bus != &pci_bus_type)
+		return -ENODEV;
+	pdev = to_pci_dev(dev);
+
+	for (i = 0; i < ioatdca->max_requesters; i++) {
+		if (ioatdca->req_slots[i].pdev == pdev) {
+			writew(0, ioatdca->dca_base + (i * 4));
+			ioatdca->req_slots[i].pdev = NULL;
+			ioatdca->req_slots[i].rid = 0;
+			ioatdca->requester_count--;
+			return i;
+		}
+	}
+	return -ENODEV;
+}
+
+static u8 ioat_dca_get_tag(struct dca_provider *dca, int cpu)
+{
+	struct ioat_dca_priv *ioatdca = dca_priv(dca);
+	int i, apic_id, bit, value;
+	u8 entry, tag;
+
+	tag = 0;
+	apic_id = cpu_physical_id(cpu);
+
+	for (i = 0; i < IOAT_TAG_MAP_LEN; i++) {
+		entry = ioatdca->tag_map[i];
+		if (entry & DCA_TAG_MAP_VALID) {
+			bit = entry & ~DCA_TAG_MAP_VALID;
+			value = (apic_id & (1 << bit)) ? 1 : 0;
+		} else {
+			value = entry ? 1 : 0;
+		}
+		tag |= (value << i);
+	}
+	return tag;
+}
+
+static struct dca_ops ioat_dca_ops = {
+	.add_requester		= ioat_dca_add_requester,
+	.remove_requester	= ioat_dca_remove_requester,
+	.get_tag		= ioat_dca_get_tag,
+};
+
+
+struct dca_provider *ioat_dca_init(struct pci_dev *pdev, void __iomem *iobase)
+{
+	struct dca_provider *dca;
+	struct ioat_dca_priv *ioatdca;
+	u8 *tag_map = NULL;
+	int i;
+	int err;
+
+	if (!system_has_dca_enabled())
+		return NULL;
+
+	/* I/OAT v1 systems must have a known tag_map to support DCA */
+	switch (pdev->vendor) {
+	case PCI_VENDOR_ID_INTEL:
+		switch (pdev->device) {
+		case PCI_DEVICE_ID_INTEL_IOAT:
+			tag_map = ioat_tag_map_BNB;
+			break;
+		case PCI_DEVICE_ID_INTEL_IOAT_CNB:
+			tag_map = ioat_tag_map_CNB;
+			break;
+		case PCI_DEVICE_ID_INTEL_IOAT_SCNB:
+			tag_map = ioat_tag_map_SCNB;
+			break;
+		}
+		break;
+	case PCI_VENDOR_ID_UNISYS:
+		switch (pdev->device) {
+		case PCI_DEVICE_ID_UNISYS_DMA_DIRECTOR:
+			tag_map = ioat_tag_map_UNISYS;
+			break;
+		}
+		break;
+	}
+	if (tag_map == NULL)
+		return NULL;
+
+	dca = alloc_dca_provider(&ioat_dca_ops,
+			sizeof(*ioatdca) +
+			(sizeof(struct ioat_dca_slot) * IOAT_DCA_MAX_REQ));
+	if (!dca)
+		return NULL;
+
+	ioatdca = dca_priv(dca);
+	ioatdca->max_requesters = IOAT_DCA_MAX_REQ;
+
+	ioatdca->dca_base = iobase + 0x54;
+
+	/* copy over the APIC ID to DCA tag mapping */
+	for (i = 0; i < IOAT_TAG_MAP_LEN; i++)
+		ioatdca->tag_map[i] = tag_map[i];
+
+	err = register_dca_provider(dca, &pdev->dev);
+	if (err) {
+		free_dca_provider(dca);
+		return NULL;
+	}
+
+	return dca;
+}
+
diff -puN drivers/dma/ioatdma.h~i-oat-add-dca-services drivers/dma/ioatdma.h
--- a/drivers/dma/ioatdma.h~i-oat-add-dca-services
+++ a/drivers/dma/ioatdma.h
@@ -132,9 +132,12 @@ struct ioat_desc_sw {
 struct ioatdma_device *ioat_dma_probe(struct pci_dev *pdev,
 				      void __iomem *iobase);
 void ioat_dma_remove(struct ioatdma_device *device);
+struct dca_provider *ioat_dca_init(struct pci_dev *pdev,
+				   void __iomem *iobase);
 #else
 #define ioat_dma_probe(pdev, iobase)    NULL
 #define ioat_dma_remove(device)         do { } while (0)
+#define ioat_dca_init(pdev, iobase)	NULL
 #endif
 
 #endif /* IOATDMA_H */
diff -puN include/asm-x86/cpufeature_32.h~i-oat-add-dca-services include/asm-x86/cpufeature_32.h
--- a/include/asm-x86/cpufeature_32.h~i-oat-add-dca-services
+++ a/include/asm-x86/cpufeature_32.h
@@ -92,6 +92,7 @@
 #define X86_FEATURE_CID		(4*32+10) /* Context ID */
 #define X86_FEATURE_CX16        (4*32+13) /* CMPXCHG16B */
 #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
+#define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
 #define X86_FEATURE_XSTORE	(5*32+ 2) /* on-CPU RNG present (xstore insn) */
_

Patches currently in -mm which might be from shannon.nelson@intel.com are

origin.patch
remove-unsafe-from-module-struct.patch

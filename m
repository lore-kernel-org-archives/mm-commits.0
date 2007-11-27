From: akpm@linux-foundation.org
Subject: - msi-set-en-bit-of-msi-mapping-capability-on-ht-platform.patch removed from -mm tree
Date: Tue, 27 Nov 2007 14:21:58 -0800
Message-ID: <200711272221.lARMLxFn002406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40225 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbXK0WWl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 17:22:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pchen@nvidia.com, acurrid@nvidia.com, ebiederm@xmission.com, prakash@punnoor.de, sebastien.dugue@bull.net, mm-commits@vger.kernel.org


The patch titled
     msi: set 'En' bit of MSI Mapping Capability on HT platform
has been removed from the -mm tree.  Its filename was
     msi-set-en-bit-of-msi-mapping-capability-on-ht-platform.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: msi: set 'En' bit of MSI Mapping Capability on HT platform
From: Peer Chen <pchen@nvidia.com>

According to the HyperTransport spec, 'En' indicate if the MSI Mapping is
active.  So it should be set when enable the MSI.

Signed-off-by: Andy Currid <acurrid@nvidia.com>
Signed-off-by: Peer Chen <pchen@nvidia.com>
Cc: Prakash Punnoor <prakash@punnoor.de>
Cc: Sbastien Dugu <sebastien.dugue@bull.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/msi.c       |  103 ++++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h |    9 +++
 2 files changed, 112 insertions(+)

diff -puN drivers/pci/msi.c~msi-set-en-bit-of-msi-mapping-capability-on-ht-platform drivers/pci/msi.c
--- a/drivers/pci/msi.c~msi-set-en-bit-of-msi-mapping-capability-on-ht-platform
+++ a/drivers/pci/msi.c
@@ -20,6 +20,8 @@
 #include <asm/errno.h>
 #include <asm/io.h>
 
+#include <asm/k8.h>
+
 #include "pci.h"
 #include "msi.h"
 
@@ -289,6 +291,99 @@ void pci_restore_msi_state(struct pci_de
 }
 EXPORT_SYMBOL_GPL(pci_restore_msi_state);
 
+/*
+ * pci_enable_msi_ht_cap - Set the HT MSI mapping capability En bit of
+ * a device.
+ *
+ * @dev: pointer to the pci_dev data structure of MSI device function
+ */
+
+static int pci_enable_msi_ht_cap(struct pci_dev *dev)
+{
+	int pos;
+	u8 flags;
+
+	if ((pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING)) != 0)
+	{
+		pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags);
+		pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
+						  flags | HT_MSI_FLAGS_ENABLE);
+
+		printk(KERN_INFO "PCI: %s: enabled HT MSI mapping\n", pci_name(dev));
+	}
+
+	return pos;
+}
+
+/**
+ * pci_check_msi_ht_cap - check for and enable the MSI mapping capability En bit
+ * of devices or upstream bridge on HT-base system.
+ * @dev: pointer to the pci_dev data structure of MSI device function
+ *
+ * Search if device support ht MSI mapping capability on HT-base
+ * platform, if yes, enable the En bit. If device can't support MSI mapping,
+ * search the the upstream bridge for that capability, enable En bit find it,
+ * otherwise disable the MSI function if device and upstream bridge can't
+ * support MSI mapping capability.
+ **/
+
+static int pci_check_msi_ht_cap(struct pci_dev *dev)
+{
+	struct pci_dev *bridge_dev;
+
+	if (num_k8_northbridges != 0) {	/* If the system is the HT-base */
+
+		/* Check for upstream NVIDIA host bridges */
+
+		if (((bridge_dev = pci_find_slot(0, 0)) != NULL) &&
+				 (bridge_dev->vendor == PCI_VENDOR_ID_NVIDIA)) {
+			switch (bridge_dev->device) {
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC0:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC1:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC2:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC3:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC4:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC5:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC6:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC7:
+			case PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_MEMC:
+
+				pci_enable_msi_ht_cap(bridge_dev);
+
+				bridge_dev = NULL;
+				while ((bridge_dev = pci_get_device(PCI_VENDOR_ID_NVIDIA,
+					PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_MEMC, bridge_dev))
+					!= NULL) {
+					pci_enable_msi_ht_cap(bridge_dev);
+			 	}
+
+				break;
+
+			default:
+				break;
+			}
+		}
+
+
+		if (pci_enable_msi_ht_cap(dev) != 0) {
+			return 0;
+		} else {
+			/* Get upstream bridge device handle */
+
+			bridge_dev = dev->bus->self;
+			while(bridge_dev != 0) {
+				if (pci_enable_msi_ht_cap(bridge_dev) != 0) {
+					return 0;
+				} else
+					bridge_dev = bridge_dev->bus->self;
+			}
+
+			return 1;
+		}
+	}
+	return 0;
+}
+
 /**
  * msi_capability_init - configure device's MSI capability structure
  * @dev: pointer to the pci_dev data structure of MSI device function
@@ -510,6 +605,10 @@ int pci_enable_msi(struct pci_dev* dev)
 	if (status)
 		return status;
 
+	status = pci_check_msi_ht_cap(dev);
+	if(status)
+		return status;
+
 	WARN_ON(!!dev->msi_enabled);
 
 	/* Check whether driver already requested for MSI-X irqs */
@@ -605,6 +704,10 @@ int pci_enable_msix(struct pci_dev* dev,
 	if (status)
 		return status;
 
+	status = pci_check_msi_ht_cap(dev);
+	if(status)
+		return status;
+
 	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
 	pci_read_config_word(dev, msi_control_reg(pos), &control);
 	nr_entries = multi_msix_capable(control);
diff -puN include/linux/pci_ids.h~msi-set-en-bit-of-msi-mapping-capability-on-ht-platform include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~msi-set-en-bit-of-msi-mapping-capability-on-ht-platform
+++ a/include/linux/pci_ids.h
@@ -1153,7 +1153,16 @@
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_IDE	0x0265
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA	0x0266
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2	0x0267
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC0   0x02F0
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC1   0x02F1
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC2   0x02F2
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC3   0x02F3
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC4   0x02F4
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC5   0x02F5
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC6   0x02F6
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_C51_MEMC7   0x02F7
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SMBUS	0x0368
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_MEMC	0x0369
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_IDE	0x036E
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA	0x037E
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2	0x037F
_

Patches currently in -mm which might be from pchen@nvidia.com are

quirk-enable-msi-mapping-on-ht1000.patch
msi-set-en-bit-of-msi-mapping-capability-on-ht-platform.patch
msi-set-en-bit-of-msi-mapping-capability-on-ht-platform-fix.patch

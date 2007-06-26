From: akpm@linux-foundation.org
Subject: + intel-iommu-pci-generic-helper-function.patch added to -mm tree
Date: Mon, 25 Jun 2007 23:42:46 -0700
Message-ID: <200706260642.l5Q6gkSh020211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbXFZGnN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 02:43:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anil.s.keshavamurthy@intel.com, a.p.zijlstra@chello.nl, ak@suse.de, arjan@infradead.org, ashok.raj@intel.com, clameter@sgi.com, davem@davemloft.net, greg@kroah.com, muli@il.ibm.com, suresh.b.siddha@intel.com


The patch titled
     Intel IOMMU: PCI generic helper function
has been added to the -mm tree.  Its filename is
     intel-iommu-pci-generic-helper-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Intel IOMMU: PCI generic helper function
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

When devices are under a p2p bridge, upstream transactions get replaced by the
device id of the bridge as it owns the PCIE transaction.  Hence its necessary
to setup translations on behalf of the bridge as well.  Due to this limitation
all devices under a p2p share the same domain in a DMAR.

We just cache the type of device, if its a native PCIe device
or not for later use.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.h    |    1 +
 drivers/pci/probe.c  |   14 ++++++++++++++
 drivers/pci/search.c |   30 ++++++++++++++++++++++++++++++
 include/linux/pci.h  |    2 ++
 4 files changed, 47 insertions(+)

diff -puN drivers/pci/pci.h~intel-iommu-pci-generic-helper-function drivers/pci/pci.h
--- a/drivers/pci/pci.h~intel-iommu-pci-generic-helper-function
+++ a/drivers/pci/pci.h
@@ -92,3 +92,4 @@ pci_match_one_device(const struct pci_de
 	return NULL;
 }
 
+struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
diff -puN drivers/pci/probe.c~intel-iommu-pci-generic-helper-function drivers/pci/probe.c
--- a/drivers/pci/probe.c~intel-iommu-pci-generic-helper-function
+++ a/drivers/pci/probe.c
@@ -861,6 +861,19 @@ static void pci_release_dev(struct devic
 	kfree(pci_dev);
 }
 
+static void set_pcie_port_type(struct pci_dev *pdev)
+{
+	int pos;
+	u16 reg16;
+
+	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
+	if (!pos)
+		return;
+	pdev->is_pcie = 1;
+	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
+	pdev->pcie_type = (reg16 & PCI_EXP_FLAGS_TYPE) >> 4;
+}
+
 /**
  * pci_cfg_space_size - get the configuration space size of the PCI device.
  * @dev: PCI device
@@ -975,6 +988,7 @@ pci_scan_device(struct pci_bus *bus, int
 	dev->device = (l >> 16) & 0xffff;
 	dev->cfg_size = pci_cfg_space_size(dev);
 	dev->error_state = pci_channel_io_normal;
+	set_pcie_port_type(dev);
 
 	/* Assume 32-bit PCI; let 64-bit PCI cards (which are far rarer)
 	   set this higher, assuming the system even supports it.  */
diff -puN drivers/pci/search.c~intel-iommu-pci-generic-helper-function drivers/pci/search.c
--- a/drivers/pci/search.c~intel-iommu-pci-generic-helper-function
+++ a/drivers/pci/search.c
@@ -14,6 +14,36 @@
 #include "pci.h"
 
 DECLARE_RWSEM(pci_bus_sem);
+/*
+ * find the upstream PCIE-to-PCI bridge of a PCI device
+ * if the device is PCIE, return NULL
+ * if the device isn't connected to a PCIE bridge (that is its parent is a
+ * legacy PCI bridge and the bridge is directly connected to bus 0), return its
+ * parent
+ */
+struct pci_dev *
+pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
+{
+	struct pci_dev *tmp = NULL;
+
+	if (pdev->is_pcie)
+		return NULL;
+	while (1) {
+		if (!pdev->bus->self)
+			break;
+		pdev = pdev->bus->self;
+		/* a p2p bridge */
+		if (!pdev->is_pcie) {
+			tmp = pdev;
+			continue;
+		}
+		/* PCI device should connect to a PCIE bridge */
+		BUG_ON(pdev->pcie_type != PCI_EXP_TYPE_PCI_BRIDGE);
+		return pdev;
+	}
+
+	return tmp;
+}
 
 static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
 {
diff -puN include/linux/pci.h~intel-iommu-pci-generic-helper-function include/linux/pci.h
--- a/include/linux/pci.h~intel-iommu-pci-generic-helper-function
+++ a/include/linux/pci.h
@@ -141,6 +141,7 @@ struct pci_dev {
 	unsigned int	class;		/* 3 bytes: (base,sub,prog-if) */
 	u8		revision;	/* PCI revision, low byte of class word */
 	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
+	u8		pcie_type;	/* PCI-E device/port type */
 	u8		rom_base_reg;	/* which config register controls the ROM */
 	u8		pin;  		/* which interrupt pin this device uses */
 
@@ -183,6 +184,7 @@ struct pci_dev {
 	unsigned int 	msi_enabled:1;
 	unsigned int	msix_enabled:1;
 	unsigned int	is_managed:1;
+	unsigned int	is_pcie:1;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
 	u32		saved_config_space[16]; /* config space saved at suspend time */
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

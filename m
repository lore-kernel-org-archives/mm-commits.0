From: akpm@linux-foundation.org
Subject: - pci-x-pci-express-read-control-interfaces.patch removed from -mm tree
Date: Mon, 21 May 2007 16:17:38 -0700
Message-ID: <200705212317.l4LNHb8O022498@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59679 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759629AbXEUXWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 19:22:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.oruba@amd.com, andrew.vasquez@qlogic.com, auke-jan.h.kok@intel.com, greg@kroah.com, jeff@garzik.org, mst@mellanox.co.il, rolandd@cisco.com, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     PCI-X/PCI-Express read control interfaces
has been removed from the -mm tree.  Its filename was
     pci-x-pci-express-read-control-interfaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PCI-X/PCI-Express read control interfaces
From: "Peter Oruba" <peter.oruba@amd.com>

This patch set introduces a PCI-X / PCI-Express read byte count control
interface.  Instead of letting every driver to directly read/write to PCI
config space for that, an interface is provided.  The interface functions then
can be used for quirks since some PCI bridges require that read byte count
values are set by the BIOS and left unchanged by device drivers.


This patch:

Introduce an interface to read and write PCI-X / PCI-Express maximum read byte
count values from PCI config space.  There is a second function that returns
the maximum _designed_ read byte count, which marks the maximum value for a
device, since some drivers try to set MMRBC to the highest allowed value and
rely on such a function.

Signed-off by: Peter Oruba <peter.oruba@amd.com>
Based on patch set by Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Michael S. Tsirkin <mst@mellanox.co.il>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c    |  164 +++++++++++++++++++++++++++++++++++++++++
 drivers/pci/quirks.c |   16 ++++
 include/linux/pci.h  |    7 +
 3 files changed, 186 insertions(+), 1 deletion(-)

diff -puN drivers/pci/pci.c~pci-x-pci-express-read-control-interfaces drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-x-pci-express-read-control-interfaces
+++ a/drivers/pci/pci.c
@@ -1394,6 +1394,170 @@ pci_set_consistent_dma_mask(struct pci_d
 #endif
 
 /**
+ * pcix_get_max_mmrbc - get PCI-X maximum designed memory read byte count
+ * @dev: PCI device to query
+ *
+ * Returns mmrbc: maximum designed memory read count in bytes
+ *    or appropriate error value.
+ */
+int
+pcix_get_max_mmrbc(struct pci_dev *dev)
+{
+	int ret, err, cap;
+	u32 stat;
+
+	cap = pci_find_capability(dev, PCI_CAP_ID_PCIX);
+	if (!cap)
+		return -EINVAL;
+
+	err = pci_read_config_dword(dev, cap + PCI_X_STATUS, &stat);
+	if (err)
+		return -EINVAL;
+
+	ret = (stat & PCI_X_STATUS_MAX_READ) >> 12;
+
+	return ret;
+}
+EXPORT_SYMBOL(pcix_get_max_mmrbc);
+
+/**
+ * pcix_get_mmrbc - get PCI-X maximum memory read byte count
+ * @dev: PCI device to query
+ *
+ * Returns mmrbc: maximum memory read count in bytes
+ *    or appropriate error value.
+ */
+int
+pcix_get_mmrbc(struct pci_dev *dev)
+{
+	int ret, cap;
+	u32 cmd;
+
+	cap = pci_find_capability(dev, PCI_CAP_ID_PCIX);
+	if (!cap)
+		return -EINVAL;
+
+	ret = pci_read_config_dword(dev, cap + PCI_X_CMD, &cmd);
+	if (!ret)
+		ret = 512 << ((cmd & PCI_X_CMD_MAX_READ) >> 2);
+
+	return ret;
+}
+EXPORT_SYMBOL(pcix_get_mmrbc);
+
+/**
+ * pcix_set_mmrbc - set PCI-X maximum memory read byte count
+ * @dev: PCI device to query
+ * @mmrbc: maximum memory read count in bytes
+ *    valid values are 512, 1024, 2048, 4096
+ *
+ * If possible sets maximum memory read byte count, some bridges have erratas
+ * that prevent this.
+ */
+int
+pcix_set_mmrbc(struct pci_dev *dev, int mmrbc)
+{
+	int cap, err = -EINVAL;
+	u32 stat, cmd, v, o;
+
+	if (mmrbc < 512 || mmrbc > 4096 || (mmrbc & (mmrbc-1)))
+		goto out;
+
+	v = ffs(mmrbc) - 10;
+
+	cap = pci_find_capability(dev, PCI_CAP_ID_PCIX);
+	if (!cap)
+		goto out;
+
+	err = pci_read_config_dword(dev, cap + PCI_X_STATUS, &stat);
+	if (err)
+		goto out;
+
+	if (v > (stat & PCI_X_STATUS_MAX_READ) >> 21)
+		return -E2BIG;
+
+	err = pci_read_config_dword(dev, cap + PCI_X_CMD, &cmd);
+	if (err)
+		goto out;
+
+	o = (cmd & PCI_X_CMD_MAX_READ) >> 2;
+	if (o != v) {
+		if (v > o && dev->bus &&
+		   (dev->bus->bus_flags & PCI_BUS_FLAGS_NO_MMRBC))
+			return -EIO;
+
+		cmd &= ~PCI_X_CMD_MAX_READ;
+		cmd |= v << 2;
+		err = pci_write_config_dword(dev, cap + PCI_X_CMD, cmd);
+	}
+out:
+	return err;
+}
+EXPORT_SYMBOL(pcix_set_mmrbc);
+
+/**
+ * pcie_get_readrq - get PCI Express read request size
+ * @dev: PCI device to query
+ *
+ * Returns maximum memory read request in bytes
+ *    or appropriate error value.
+ */
+int pcie_get_readrq(struct pci_dev *dev)
+{
+	int ret, cap;
+	u16 ctl;
+
+	cap = pci_find_capability(dev, PCI_CAP_ID_EXP);
+	if (!cap)
+		return -EINVAL;
+
+	ret = pci_read_config_word(dev, cap + PCI_EXP_DEVCTL, &ctl);
+	if (!ret)
+	ret = 128 << ((ctl & PCI_EXP_DEVCTL_READRQ) >> 12);
+
+	return ret;
+}
+EXPORT_SYMBOL(pcie_get_readrq);
+
+/**
+ * pcie_set_readrq - set PCI Express maximum memory read request
+ * @dev: PCI device to query
+ * @count: maximum memory read count in bytes
+ *    valid values are 128, 256, 512, 1024, 2048, 4096
+ *
+ * If possible sets maximum read byte count
+ */
+int
+pcie_set_readrq(struct pci_dev *dev, int rq)
+{
+	int cap, err = -EINVAL;
+	u16 ctl, v;
+
+	if (rq < 128 || rq > 4096 || (rq & (rq-1)))
+		goto out;
+
+	v = (ffs(rq) - 8) << 12;
+
+	cap = pci_find_capability(dev, PCI_CAP_ID_EXP);
+	if (!cap)
+		goto out;
+
+	err = pci_read_config_word(dev, cap + PCI_EXP_DEVCTL, &ctl);
+	if (err)
+		goto out;
+
+	if ((ctl & PCI_EXP_DEVCTL_READRQ) != v) {
+		ctl &= ~PCI_EXP_DEVCTL_READRQ;
+		ctl |= v;
+		err = pci_write_config_dword(dev, cap + PCI_EXP_DEVCTL, ctl);
+	}
+
+out:
+	return err;
+}
+EXPORT_SYMBOL(pcie_set_readrq);
+
+/**
  * pci_select_bars - Make BAR mask from the type of resource
  * @dev: the PCI device for which BAR mask is made
  * @flags: resource type mask to be selected
diff -puN drivers/pci/quirks.c~pci-x-pci-express-read-control-interfaces drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-x-pci-express-read-control-interfaces
+++ a/drivers/pci/quirks.c
@@ -627,6 +627,22 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AM
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_amd_8131_ioapic);
 #endif /* CONFIG_X86_IO_APIC */
 
+/*
+ * Some settings of MMRBC can lead to data corruption so block changes.
+ * See AMD 8131 HyperTransport PCI-X Tunnel Revision Guide
+ */
+static void __init quirk_amd_8131_mmrbc(struct pci_dev *dev)
+{
+	unsigned char revid;
+
+	pci_read_config_byte(dev, PCI_REVISION_ID, &revid);
+	if (dev->subordinate && revid <= 0x12) {
+        	printk(KERN_INFO "AMD8131 rev %x detected, disabling PCI-X MMRBC\n",
+        		revid);
+        	dev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MMRBC;
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_amd_8131_mmrbc);
 
 /*
  * FIXME: it is questionable that quirk_via_acpi
diff -puN include/linux/pci.h~pci-x-pci-express-read-control-interfaces include/linux/pci.h
--- a/include/linux/pci.h~pci-x-pci-express-read-control-interfaces
+++ a/include/linux/pci.h
@@ -111,7 +111,8 @@ enum pcie_reset_state {
 
 typedef unsigned short __bitwise pci_bus_flags_t;
 enum pci_bus_flags {
-	PCI_BUS_FLAGS_NO_MSI = (__force pci_bus_flags_t) 1,
+	PCI_BUS_FLAGS_NO_MSI   = (__force pci_bus_flags_t) 1,
+	PCI_BUS_FLAGS_NO_MMRBC = (__force pci_bus_flags_t) 2,
 };
 
 struct pci_cap_saved_state {
@@ -550,6 +551,10 @@ void pci_intx(struct pci_dev *dev, int e
 void pci_msi_off(struct pci_dev *dev);
 int pci_set_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask);
+int pcix_get_max_mmrbc(struct pci_dev *dev);
+int pcix_get_mmrbc(struct pci_dev *dev);
+int pcix_set_mmrbc(struct pci_dev *dev, int mmrbc);
+int pcie_set_readrq(struct pci_dev *dev, int rq);
 void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno);
 int __must_check pci_assign_resource(struct pci_dev *dev, int i);
 int __must_check pci_assign_resource_fixed(struct pci_dev *dev, int i);
_

Patches currently in -mm which might be from peter.oruba@amd.com are

pci-x-pci-express-read-control-interfaces-fix.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch

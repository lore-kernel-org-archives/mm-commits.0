From: akpm@linux-foundation.org
Subject: [merged] pci-enable-pcie-aer-only-after-checking-firmware-support.patch removed from -mm tree
Date: Thu, 26 Feb 2009 11:30:33 -0800
Message-ID: <200902261930.n1QJUXYn014437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752420AbZBZTai (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 14:30:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew.patterson@hp.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci: enable PCIe AER only after checking firmware support
has been removed from the -mm tree.  Its filename was
     pci-enable-pcie-aer-only-after-checking-firmware-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: enable PCIe AER only after checking firmware support
From: Andrew Patterson <andrew.patterson@hp.com>

The PCIe port driver currently sets the PCIe AER error reporting bits for
any root or switch port without first checking to see if firmware will
grant control.  This patch moves setting these bits to the AER service
driver aer_enable_port routine.  The bits are then set for the root port
and any downstream switch ports after the check for firmware support
(aer_osc_setup) is made.  The patch also unsets the bits in a similar
fashion when the AER service driver is unloaded.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aer/aerdrv_core.c |   49 ++++++++++++++++++++++-----
 drivers/pci/pcie/portdrv_pci.c     |    2 -
 2 files changed, 40 insertions(+), 11 deletions(-)

diff -puN drivers/pci/pcie/aer/aerdrv_core.c~pci-enable-pcie-aer-only-after-checking-firmware-support drivers/pci/pcie/aer/aerdrv_core.c
--- a/drivers/pci/pcie/aer/aerdrv_core.c~pci-enable-pcie-aer-only-after-checking-firmware-support
+++ a/drivers/pci/pcie/aer/aerdrv_core.c
@@ -108,6 +108,35 @@ int pci_cleanup_aer_correct_error_status
 }
 #endif  /*  0  */
 
+
+static void set_device_error_reporting(struct pci_dev *dev, void *data)
+{
+	bool enable = *((bool *)data);
+
+	if (dev->pcie_type != PCIE_RC_PORT &&
+	    dev->pcie_type != PCIE_SW_UPSTREAM_PORT &&
+	    dev->pcie_type != PCIE_SW_DOWNSTREAM_PORT)
+		return;
+
+	if (enable)
+		pci_enable_pcie_error_reporting(dev);
+	else
+		pci_disable_pcie_error_reporting(dev);
+}
+
+/**
+ * set_downstream_devices_error_reporting - enable/disable the error reporting
+ * bits on the root port and its downstream ports.
+ * @dev: pointer to root port's pci_dev data structure
+ * @enable: true = enable error reporting, false = disable error reporting.
+ */
+static void set_downstream_devices_error_reporting(struct pci_dev *dev,
+						   bool enable)
+{
+	set_device_error_reporting(dev, &enable);
+	pci_walk_bus(dev->subordinate, set_device_error_reporting, &enable);
+}
+
 static int find_device_iter(struct device *device, void *data)
 {
 	struct pci_dev *dev;
@@ -525,15 +554,11 @@ void aer_enable_rootport(struct aer_rpc 
 	pci_read_config_dword(pdev, aer_pos + PCI_ERR_UNCOR_STATUS, &reg32);
 	pci_write_config_dword(pdev, aer_pos + PCI_ERR_UNCOR_STATUS, reg32);
 
-	/* Enable Root Port device reporting error itself */
-	pci_read_config_word(pdev, pos+PCI_EXP_DEVCTL, &reg16);
-	reg16 = reg16 |
-		PCI_EXP_DEVCTL_CERE |
-		PCI_EXP_DEVCTL_NFERE |
-		PCI_EXP_DEVCTL_FERE |
-		PCI_EXP_DEVCTL_URRE;
-	pci_write_config_word(pdev, pos+PCI_EXP_DEVCTL,
-		reg16);
+	/*
+	 * Enable error reporting for the root port device and downstream port
+	 * devices.
+	 */
+	set_downstream_devices_error_reporting(pdev, true);
 
 	/* Enable Root Port's interrupt in response to error messages */
 	pci_write_config_dword(pdev,
@@ -553,6 +578,12 @@ static void disable_root_aer(struct aer_
 	u32 reg32;
 	int pos;
 
+	/*
+	 * Disable error reporting for the root port device and downstream port
+	 * devices.
+	 */
+	set_downstream_devices_error_reporting(pdev, false);
+
 	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
 	/* Disable Root's interrupt in response to error messages */
 	pci_write_config_dword(pdev, pos + PCI_ERR_ROOT_COMMAND, 0);
diff -puN drivers/pci/pcie/portdrv_pci.c~pci-enable-pcie-aer-only-after-checking-firmware-support drivers/pci/pcie/portdrv_pci.c
--- a/drivers/pci/pcie/portdrv_pci.c~pci-enable-pcie-aer-only-after-checking-firmware-support
+++ a/drivers/pci/pcie/portdrv_pci.c
@@ -87,8 +87,6 @@ static int __devinit pcie_portdrv_probe 
 
 	pci_save_state(dev);
 
-	pci_enable_pcie_error_reporting(dev);

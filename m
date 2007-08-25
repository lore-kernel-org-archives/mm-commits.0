From: akpm@linux-foundation.org
Subject: - add-pci_try_set_mwi.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:21:47 -0700
Message-ID: <200708250321.l7P3Llr3027889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53070 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752754AbXHYDWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:22:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     add pci_try_set_mwi
has been removed from the -mm tree.  Its filename was
     add-pci_try_set_mwi.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: add pci_try_set_mwi
From: Randy Dunlap <randy.dunlap@oracle.com>

As suggested by Andrew, add pci_try_set_mwi(), which does not require
return-value checking.

- add pci_try_set_mwi() without __must_check
- make it return 0 on success, errno if the "try" failed or error
- review callers

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/pci.txt                         |    5 ++
 drivers/ata/pata_cs5530.c                     |    2 -
 drivers/ide/pci/cs5530.c                      |    2 -
 drivers/net/cassini.c                         |    4 +-
 drivers/net/starfire.c                        |    2 -
 drivers/net/tulip/tulip_core.c                |    2 -
 drivers/net/wireless/prism54/islpci_hotplug.c |    3 -
 drivers/pci/pci.c                             |   28 +++++++++++++---
 drivers/scsi/lpfc/lpfc_init.c                 |    5 --
 drivers/usb/gadget/net2280.c                  |    2 -
 include/linux/pci.h                           |    1 
 11 files changed, 38 insertions(+), 18 deletions(-)

diff -puN Documentation/pci.txt~add-pci_try_set_mwi Documentation/pci.txt
--- a/Documentation/pci.txt~add-pci_try_set_mwi
+++ a/Documentation/pci.txt
@@ -296,7 +296,10 @@ If the PCI device can use the PCI Memory
 call pci_set_mwi().  This enables the PCI_COMMAND bit for Mem-Wr-Inval
 and also ensures that the cache line size register is set correctly.
 Check the return value of pci_set_mwi() as not all architectures
-or chip-sets may support Memory-Write-Invalidate.
+or chip-sets may support Memory-Write-Invalidate.  Alternatively,
+if Mem-Wr-Inval would be nice to have but is not required, call
+pci_try_set_mwi() to have the system do its best effort at enabling
+Mem-Wr-Inval.
 
 
 3.2 Request MMIO/IOP resources
diff -puN drivers/ata/pata_cs5530.c~add-pci_try_set_mwi drivers/ata/pata_cs5530.c
--- a/drivers/ata/pata_cs5530.c~add-pci_try_set_mwi
+++ a/drivers/ata/pata_cs5530.c
@@ -266,7 +266,7 @@ static int cs5530_init_chip(void)
 	}
 
 	pci_set_master(cs5530_0);
-	pci_set_mwi(cs5530_0);
+	pci_try_set_mwi(cs5530_0);
 
 	/*
 	 * Set PCI CacheLineSize to 16-bytes:
diff -puN drivers/ide/pci/cs5530.c~add-pci_try_set_mwi drivers/ide/pci/cs5530.c
--- a/drivers/ide/pci/cs5530.c~add-pci_try_set_mwi
+++ a/drivers/ide/pci/cs5530.c
@@ -236,7 +236,7 @@ static unsigned int __devinit init_chips
 	 */
 
 	pci_set_master(cs5530_0);
-	pci_set_mwi(cs5530_0);
+	pci_try_set_mwi(cs5530_0);
 
 	/*
 	 * Set PCI CacheLineSize to 16-bytes:
diff -puN drivers/net/cassini.c~add-pci_try_set_mwi drivers/net/cassini.c
--- a/drivers/net/cassini.c~add-pci_try_set_mwi
+++ a/drivers/net/cassini.c
@@ -4919,13 +4919,13 @@ static int __devinit cas_init_one(struct
 	pci_cmd &= ~PCI_COMMAND_SERR;
 	pci_cmd |= PCI_COMMAND_PARITY;
 	pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
-	if (pci_set_mwi(pdev))
+	if (pci_try_set_mwi(pdev))
 		printk(KERN_WARNING PFX "Could not enable MWI for %s\n",
 		       pci_name(pdev));
 
 	/*
 	 * On some architectures, the default cache line size set
-	 * by pci_set_mwi reduces perforamnce.  We have to increase
+	 * by pci_try_set_mwi reduces perforamnce.  We have to increase
 	 * it for this case.  To start, we'll print some configuration
 	 * data.
 	 */
diff -puN drivers/net/starfire.c~add-pci_try_set_mwi drivers/net/starfire.c
--- a/drivers/net/starfire.c~add-pci_try_set_mwi
+++ a/drivers/net/starfire.c
@@ -740,7 +740,7 @@ static int __devinit starfire_init_one(s
 	pci_set_master(pdev);
 
 	/* enable MWI -- it vastly improves Rx performance on sparc64 */
-	pci_set_mwi(pdev);
+	pci_try_set_mwi(pdev);
 
 #ifdef ZEROCOPY
 	/* Starfire can do TCP/UDP checksumming */
diff -puN drivers/net/tulip/tulip_core.c~add-pci_try_set_mwi drivers/net/tulip/tulip_core.c
--- a/drivers/net/tulip/tulip_core.c~add-pci_try_set_mwi
+++ a/drivers/net/tulip/tulip_core.c
@@ -1155,7 +1155,7 @@ static void __devinit tulip_mwi_config (
 	/* set or disable MWI in the standard PCI command bit.
 	 * Check for the case where  mwi is desired but not available
 	 */
-	if (csr0 & MWI)	pci_set_mwi(pdev);
+	if (csr0 & MWI)	pci_try_set_mwi(pdev);
 	else		pci_clear_mwi(pdev);
 
 	/* read result from hardware (in case bit refused to enable) */
diff -puN drivers/net/wireless/prism54/islpci_hotplug.c~add-pci_try_set_mwi drivers/net/wireless/prism54/islpci_hotplug.c
--- a/drivers/net/wireless/prism54/islpci_hotplug.c~add-pci_try_set_mwi
+++ a/drivers/net/wireless/prism54/islpci_hotplug.c
@@ -166,8 +166,7 @@ prism54_probe(struct pci_dev *pdev, cons
 	pci_set_master(pdev);
 
 	/* enable MWI */
-	if (!pci_set_mwi(pdev))
-		printk(KERN_INFO "%s: pci_set_mwi(pdev) succeeded\n", DRV_NAME);
+	pci_try_set_mwi(pdev);
 
 	/* setup the network device interface and its structure */
 	if (!(ndev = islpci_setup(pdev))) {
diff -puN drivers/pci/pci.c~add-pci_try_set_mwi drivers/pci/pci.c
--- a/drivers/pci/pci.c~add-pci_try_set_mwi
+++ a/drivers/pci/pci.c
@@ -1186,6 +1186,11 @@ int pci_set_mwi(struct pci_dev *dev)
 	return 0;
 }
 
+int pci_try_set_mwi(struct pci_dev *dev)
+{
+	return 0;
+}
+
 void pci_clear_mwi(struct pci_dev *dev)
 {
 }
@@ -1242,9 +1247,7 @@ pci_set_cacheline_size(struct pci_dev *d
  * pci_set_mwi - enables memory-write-invalidate PCI transaction
  * @dev: the PCI device for which MWI is enabled
  *
- * Enables the Memory-Write-Invalidate transaction in %PCI_COMMAND,
- * and then calls @pcibios_set_mwi to do the needed arch specific
- * operations or a generic mwi-prep function.
+ * Enables the Memory-Write-Invalidate transaction in %PCI_COMMAND.
  *
  * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
  */
@@ -1260,7 +1263,8 @@ pci_set_mwi(struct pci_dev *dev)
 
 	pci_read_config_word(dev, PCI_COMMAND, &cmd);
 	if (! (cmd & PCI_COMMAND_INVALIDATE)) {
-		pr_debug("PCI: Enabling Mem-Wr-Inval for device %s\n", pci_name(dev));
+		pr_debug("PCI: Enabling Mem-Wr-Inval for device %s\n",
+			pci_name(dev));
 		cmd |= PCI_COMMAND_INVALIDATE;
 		pci_write_config_word(dev, PCI_COMMAND, cmd);
 	}
@@ -1269,6 +1273,21 @@ pci_set_mwi(struct pci_dev *dev)
 }
 
 /**
+ * pci_try_set_mwi - enables memory-write-invalidate PCI transaction
+ * @dev: the PCI device for which MWI is enabled
+ *
+ * Enables the Memory-Write-Invalidate transaction in %PCI_COMMAND.
+ * Callers are not required to check the return value.
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+int pci_try_set_mwi(struct pci_dev *dev)
+{
+	int rc = pci_set_mwi(dev);
+	return rc;
+}
+
+/**
  * pci_clear_mwi - disables Memory-Write-Invalidate for device dev
  * @dev: the PCI device to disable
  *
@@ -1600,6 +1619,7 @@ EXPORT_SYMBOL(pci_release_selected_regio
 EXPORT_SYMBOL(pci_request_selected_regions);
 EXPORT_SYMBOL(pci_set_master);
 EXPORT_SYMBOL(pci_set_mwi);
+EXPORT_SYMBOL(pci_try_set_mwi);
 EXPORT_SYMBOL(pci_clear_mwi);
 EXPORT_SYMBOL_GPL(pci_intx);
 EXPORT_SYMBOL(pci_set_dma_mask);
diff -puN drivers/scsi/lpfc/lpfc_init.c~add-pci_try_set_mwi drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~add-pci_try_set_mwi
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -1578,10 +1578,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	INIT_LIST_HEAD(&phba->fc_nodes);
 
 	pci_set_master(pdev);
-	retval = pci_set_mwi(pdev);
-	if (retval)
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "Warning: pci_set_mwi returned %d\n", retval);
+	pci_try_set_mwi(pdev);
 
 	if (pci_set_dma_mask(phba->pcidev, DMA_64BIT_MASK) != 0)
 		if (pci_set_dma_mask(phba->pcidev, DMA_32BIT_MASK) != 0)
diff -puN drivers/usb/gadget/net2280.c~add-pci_try_set_mwi drivers/usb/gadget/net2280.c
--- a/drivers/usb/gadget/net2280.c~add-pci_try_set_mwi
+++ a/drivers/usb/gadget/net2280.c
@@ -2964,7 +2964,7 @@ static int net2280_probe (struct pci_dev
 			, &dev->pci->pcimstctl);
 	/* erratum 0115 shouldn't appear: Linux inits PCI_LATENCY_TIMER */
 	pci_set_master (pdev);
-	pci_set_mwi (pdev);
+	pci_try_set_mwi (pdev);
 
 	/* ... also flushes any posted pci writes */
 	dev->chiprev = get_idx_reg (dev->regs, REG_CHIPREV) & 0xffff;
diff -puN include/linux/pci.h~add-pci_try_set_mwi include/linux/pci.h
--- a/include/linux/pci.h~add-pci_try_set_mwi
+++ a/include/linux/pci.h
@@ -545,6 +545,7 @@ void pci_set_master(struct pci_dev *dev)
 int pci_set_pcie_reset_state(struct pci_dev *dev, enum pcie_reset_state state);
 #define HAVE_PCI_SET_MWI
 int __must_check pci_set_mwi(struct pci_dev *dev);
+int pci_try_set_mwi(struct pci_dev *dev);
 void pci_clear_mwi(struct pci_dev *dev);
 void pci_intx(struct pci_dev *dev, int enable);
 void pci_msi_off(struct pci_dev *dev);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
maintainers-update-dco-info.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
git-mtd.patch
pci-aer-fix-warnings-when-pcieaer=n.patch
git-unionfs.patch
git-ipwireless_cs.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
profile-likely-unlikely-macros.patch

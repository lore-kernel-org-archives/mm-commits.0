From: akpm@linux-foundation.org
Subject: - e1000-make-ioport-free.patch removed from -mm tree
Date: Wed, 23 Jul 2008 14:02:37 -0700
Message-ID: <200807232102.m6NL2bD9011776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754554AbYGWVOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 17:14:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: izumi.taku@jp.fujitsu.com, auke-jan.h.kok@intel.com, jeff@garzik.org, jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com, john.ronciak@intel.com, kusumi.tomohiro@jp.fujitsu.com


The patch titled
     e1000: make ioport free
has been removed from the -mm tree.  Its filename was
     e1000-make-ioport-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000: make ioport free
From: Taku Izumi <izumi.taku@jp.fujitsu.com>

This patch makes e1000 driver ioport-free.  This corrects behavior in
probe function so as not to request ioport resources as long as they are
not really needed.  This is based on the ioport-free patch of e1000 driver
from Auke Kok and Tomohiro Kusumi.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: John Ronciak <john.ronciak@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000.h      |    4 +
 drivers/net/e1000/e1000_main.c |   88 ++++++++++++++++++++++++++-----
 2 files changed, 80 insertions(+), 12 deletions(-)

diff -puN drivers/net/e1000/e1000.h~e1000-make-ioport-free drivers/net/e1000/e1000.h
--- a/drivers/net/e1000/e1000.h~e1000-make-ioport-free
+++ a/drivers/net/e1000/e1000.h
@@ -342,6 +342,10 @@ struct e1000_adapter {
 	bool quad_port_a;
 	unsigned long flags;
 	u32 eeprom_wol;
+
+	/* for ioport free */
+	int	bars;
+	int	need_ioport;
 };
 
 enum e1000_state_t {
diff -puN drivers/net/e1000/e1000_main.c~e1000-make-ioport-free drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000-make-ioport-free
+++ a/drivers/net/e1000/e1000_main.c
@@ -872,6 +872,44 @@ static void e1000_dump_eeprom(struct e10
 }
 
 /**
+ * e1000_is_need_ioport - determine if an adapter needs ioport resources or not
+ * @pdev: PCI device information struct
+ *
+ * Returns true if an adapter needs ioport resources
+ **/
+
+static int
+e1000_is_need_ioport(struct pci_dev *pdev)
+{
+	switch (pdev->device) {
+	case E1000_DEV_ID_82540EM:
+	case E1000_DEV_ID_82540EM_LOM:
+	case E1000_DEV_ID_82540EP:
+	case E1000_DEV_ID_82540EP_LOM:
+	case E1000_DEV_ID_82540EP_LP:
+	case E1000_DEV_ID_82541EI:
+	case E1000_DEV_ID_82541EI_MOBILE:
+	case E1000_DEV_ID_82541ER_LOM:
+	case E1000_DEV_ID_82541ER:
+	case E1000_DEV_ID_82541GI:
+	case E1000_DEV_ID_82541GI_LF:
+	case E1000_DEV_ID_82541GI_MOBILE:
+	case E1000_DEV_ID_82544EI_COPPER:
+	case E1000_DEV_ID_82544EI_FIBER:
+	case E1000_DEV_ID_82544GC_COPPER:
+	case E1000_DEV_ID_82544GC_LOM:
+	case E1000_DEV_ID_82545EM_COPPER:
+	case E1000_DEV_ID_82545EM_FIBER:
+	case E1000_DEV_ID_82546EB_COPPER:
+	case E1000_DEV_ID_82546EB_FIBER:
+	case E1000_DEV_ID_82546EB_QUAD_COPPER:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/**
  * e1000_probe - Device Initialization Routine
  * @pdev: PCI device information struct
  * @ent: entry in e1000_pci_tbl
@@ -895,9 +933,19 @@ e1000_probe(struct pci_dev *pdev,
 	int i, err, pci_using_dac;
 	u16 eeprom_data = 0;
 	u16 eeprom_apme_mask = E1000_EEPROM_APME;
+	int bars, need_ioport;
 	DECLARE_MAC_BUF(mac);
 
-	if ((err = pci_enable_device(pdev)))
+	/* do not allocate ioport bars when not needed */
+	need_ioport = e1000_is_need_ioport(pdev);
+	if (need_ioport) {
+		bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);
+		err = pci_enable_device(pdev);
+	} else {
+		bars = pci_select_bars(pdev, IORESOURCE_MEM);
+		err = pci_enable_device_mem(pdev);
+	}
+	if (err)
 		return err;
 
 	if (!(err = pci_set_dma_mask(pdev, DMA_64BIT_MASK)) &&
@@ -912,7 +960,8 @@ e1000_probe(struct pci_dev *pdev,
 		pci_using_dac = 0;
 	}
 
-	if ((err = pci_request_regions(pdev, e1000_driver_name)))
+	err = pci_request_selected_regions(pdev, bars, e1000_driver_name);
+	if (err)
 		goto err_pci_reg;
 
 	pci_set_master(pdev);
@@ -930,6 +979,8 @@ e1000_probe(struct pci_dev *pdev,
 	adapter->pdev = pdev;
 	adapter->hw.back = adapter;
 	adapter->msg_enable = (1 << debug) - 1;
+	adapter->bars = bars;
+	adapter->need_ioport = need_ioport;
 
 	err = -EIO;
 	adapter->hw.hw_addr = ioremap(pci_resource_start(pdev, BAR_0),
@@ -937,12 +988,15 @@ e1000_probe(struct pci_dev *pdev,
 	if (!adapter->hw.hw_addr)
 		goto err_ioremap;
 
-	for (i = BAR_1; i <= BAR_5; i++) {
-		if (pci_resource_len(pdev, i) == 0)
-			continue;
-		if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
-			adapter->hw.io_base = pci_resource_start(pdev, i);
-			break;
+	if (adapter->need_ioport) {
+		for (i = BAR_1; i <= BAR_5; i++) {
+			if (pci_resource_len(pdev, i) == 0)
+				continue;
+			if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
+				adapter->hw.io_base =
+					pci_resource_start(pdev, i);
+				break;
+			}
 		}
 	}
 
@@ -1214,7 +1268,7 @@ err_sw_init:
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
-	pci_release_regions(pdev);
+	pci_release_selected_regions(pdev, bars);
 err_pci_reg:
 err_dma:
 	pci_disable_device(pdev);
@@ -1267,7 +1321,7 @@ e1000_remove(struct pci_dev *pdev)
 	iounmap(adapter->hw.hw_addr);
 	if (adapter->hw.flash_address)
 		iounmap(adapter->hw.flash_address);
-	pci_release_regions(pdev);
+	pci_release_selected_regions(pdev, adapter->bars);
 
 	free_netdev(netdev);
 
@@ -5196,7 +5250,12 @@ e1000_resume(struct pci_dev *pdev)
 
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
-	if ((err = pci_enable_device(pdev))) {
+
+	if (adapter->need_ioport)
+		err = pci_enable_device(pdev);
+	else
+		err = pci_enable_device_mem(pdev);
+	if (err) {
 		printk(KERN_ERR "e1000: Cannot enable PCI device from suspend\n");
 		return err;
 	}
@@ -5290,8 +5349,13 @@ static pci_ers_result_t e1000_io_slot_re
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev->priv;
+	int err;
 
-	if (pci_enable_device(pdev)) {
+	if (adapter->need_ioport)
+		err = pci_enable_device(pdev);
+	else
+		err = pci_enable_device_mem(pdev);
+	if (err) {
 		printk(KERN_ERR "e1000: Cannot re-enable PCI device after reset.\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
_

Patches currently in -mm which might be from izumi.taku@jp.fujitsu.com are

origin.patch


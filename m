From: akpm@linux-foundation.org
Subject: + e1000e-make-ioport-free.patch added to -mm tree
Date: Tue, 01 Jul 2008 14:07:43 -0700
Message-ID: <200807012107.m61L7hac014757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754999AbYGAVIb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 17:08:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: izumi.taku@jp.fujitsu.com, auke-jan.h.kok@intel.com, jeff@garzik.org, jesse.brandeburg@intel.com


The patch titled
     e1000e: make ioport free
has been added to the -mm tree.  Its filename is
     e1000e-make-ioport-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e: make ioport free
From: Taku Izumi <izumi.taku@jp.fujitsu.com>

This patch makes e1000e driver ioport-free.  This corrects behavior in
probe function so as not to request ioport resources as long as they are
not really needed.

Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/e1000.h  |    4 ++
 drivers/net/e1000e/netdev.c |   48 +++++++++++++++++++++++++++++-----
 2 files changed, 46 insertions(+), 6 deletions(-)

diff -puN drivers/net/e1000e/e1000.h~e1000e-make-ioport-free drivers/net/e1000e/e1000.h
--- a/drivers/net/e1000e/e1000.h~e1000e-make-ioport-free
+++ a/drivers/net/e1000e/e1000.h
@@ -283,6 +283,10 @@ struct e1000_adapter {
 	unsigned long led_status;
 
 	unsigned int flags;
+
+	/* for ioport free */
+	int bars;
+	int need_ioport;
 };
 
 struct e1000_info {
diff -puN drivers/net/e1000e/netdev.c~e1000e-make-ioport-free drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~e1000e-make-ioport-free
+++ a/drivers/net/e1000e/netdev.c
@@ -4002,7 +4002,11 @@ static int e1000_resume(struct pci_dev *
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 	e1000e_disable_l1aspm(pdev);
-	err = pci_enable_device(pdev);
+
+	if (adapter->need_ioport)
+		err = pci_enable_device(pdev);
+	else
+		err = pci_enable_device_mem(pdev);
 	if (err) {
 		dev_err(&pdev->dev,
 			"Cannot enable PCI device from suspend\n");
@@ -4103,9 +4107,14 @@ static pci_ers_result_t e1000_io_slot_re
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
+	int err;
 
 	e1000e_disable_l1aspm(pdev);
-	if (pci_enable_device(pdev)) {
+	if (adapter->need_ioport)
+		err = pci_enable_device(pdev);
+	else
+		err = pci_enable_device_mem(pdev);
+	if (err) {
 		dev_err(&pdev->dev,
 			"Cannot re-enable PCI device after reset.\n");
 		return PCI_ERS_RESULT_DISCONNECT;
@@ -4184,6 +4193,21 @@ static void e1000_print_device_info(stru
 }
 
 /**
+ * e1000e_is_need_ioport - determine if an adapter needs ioport resources or not
+ * @pdev: PCI device information struct
+ *
+ * Returns true if an adapters needs ioport resources
+ **/
+static int e1000e_is_need_ioport(struct pci_dev *pdev)
+{
+	switch (pdev->device) {
+	/* Currently there are no adapters that need ioport resources */
+	default:
+		return false;
+	}
+}
+
+/**
  * e1000_probe - Device Initialization Routine
  * @pdev: PCI device information struct
  * @ent: entry in e1000_pci_tbl
@@ -4208,9 +4232,19 @@ static int __devinit e1000_probe(struct 
 	int i, err, pci_using_dac;
 	u16 eeprom_data = 0;
 	u16 eeprom_apme_mask = E1000_EEPROM_APME;
+	int bars, need_ioport;
 
 	e1000e_disable_l1aspm(pdev);
-	err = pci_enable_device(pdev);
+
+	/* do not allocate ioport bars when not needed */
+	need_ioport = e1000e_is_need_ioport(pdev);
+	if (need_ioport) {
+		bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);
+		err = pci_enable_device(pdev);
+	} else {
+		bars = pci_select_bars(pdev, IORESOURCE_MEM);
+		err = pci_enable_device_mem(pdev);
+	}
 	if (err)
 		return err;
 
@@ -4233,7 +4267,7 @@ static int __devinit e1000_probe(struct 
 		}
 	}
 
-	err = pci_request_regions(pdev, e1000e_driver_name);
+	err = pci_request_selected_regions(pdev, bars, e1000e_driver_name);
 	if (err)
 		goto err_pci_reg;
 
@@ -4258,6 +4292,8 @@ static int __devinit e1000_probe(struct 
 	adapter->hw.adapter = adapter;
 	adapter->hw.mac.type = ei->mac;
 	adapter->msg_enable = (1 << NETIF_MSG_DRV | NETIF_MSG_PROBE) - 1;
+	adapter->bars = bars;
+	adapter->need_ioport = need_ioport;
 
 	mmio_start = pci_resource_start(pdev, 0);
 	mmio_len = pci_resource_len(pdev, 0);
@@ -4497,7 +4533,7 @@ err_sw_init:
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
-	pci_release_regions(pdev);
+	pci_release_selected_regions(pdev, bars);
 err_pci_reg:
 err_dma:
 	pci_disable_device(pdev);
@@ -4545,7 +4581,7 @@ static void __devexit e1000_remove(struc
 	iounmap(adapter->hw.hw_addr);
 	if (adapter->hw.flash_address)
 		iounmap(adapter->hw.flash_address);
-	pci_release_regions(pdev);
+	pci_release_selected_regions(pdev, adapter->bars);
 
 	free_netdev(netdev);
 
_

Patches currently in -mm which might be from izumi.taku@jp.fujitsu.com are

e1000-make-ioport-free.patch
e1000e-make-ioport-free.patch
igb-make-ioport-free.patch


From: akpm@linux-foundation.org
Subject: + dmfe-add-support-for-suspend-resume.patch added to -mm tree
Date: Thu, 15 Feb 2007 22:11:30 -0800
Message-ID: <200702160611.l1G6BUE8021593@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52734 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423312AbXBPGLj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 01:11:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, jeff@garzik.org, val_henson@linux.intel.com


The patch titled
     dmfe: add support for suspend/resume
has been added to the -mm tree.  Its filename is
     dmfe-add-support-for-suspend-resume.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dmfe: add support for suspend/resume
From: Maxim Levitsky <maximlevitsky@gmail.com>

This adds support for suspend resume

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Valerie Henson <val_henson@linux.intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/dmfe.c |   48 ++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff -puN drivers/net/tulip/dmfe.c~dmfe-add-support-for-suspend-resume drivers/net/tulip/dmfe.c
--- a/drivers/net/tulip/dmfe.c~dmfe-add-support-for-suspend-resume
+++ a/drivers/net/tulip/dmfe.c
@@ -55,9 +55,6 @@
 
     TODO
 
-    Implement pci_driver::suspend() and pci_driver::resume()
-    power management methods.
-
     Check on 64 bit boxes.
     Check and fix on big endian boxes.
 
@@ -2050,11 +2047,56 @@ static struct pci_device_id dmfe_pci_tbl
 MODULE_DEVICE_TABLE(pci, dmfe_pci_tbl);
 
 
+
+static int dmfe_suspend(struct pci_dev *pci_dev, pm_message_t state)
+{
+	struct net_device *dev = pci_get_drvdata(pci_dev);
+	struct dmfe_board_info *db = netdev_priv(dev);
+
+	/* Disable upper layer interface */
+	netif_device_detach (dev);
+
+	/* Disable Tx/Rx */
+	db->cr6_data &= ~(CR6_RXSC | CR6_TXSC);
+	update_cr6(db->cr6_data, dev->base_addr);
+
+	/* Disable Interrupt */
+	outl (0, dev->base_addr + DCR7);
+	outl (inl (dev->base_addr + DCR5), dev->base_addr + DCR5);
+
+	/* Fre RX buffers */
+	dmfe_free_rxbuffer (db);
+
+	/* Power down device*/
+	pci_set_power_state (pci_dev, pci_choose_state (pci_dev,state));
+	pci_save_state (pci_dev);
+
+	return 0;
+}
+
+static int dmfe_resume (struct pci_dev *pci_dev)
+{
+	struct net_device *dev = pci_get_drvdata (pci_dev);
+
+	pci_restore_state(pci_dev);
+	pci_set_power_state(pci_dev ,PCI_D0);
+
+	/* Re-initilize DM910X board */
+	dmfe_init_dm910x(dev);
+
+	/* Restart upper layer interface */
+	netif_device_attach(dev);
+
+	return 0;
+}
+
 static struct pci_driver dmfe_driver = {
 	.name		= "dmfe",
 	.id_table	= dmfe_pci_tbl,
 	.probe		= dmfe_init_one,
 	.remove		= __devexit_p(dmfe_remove_one),
+	.suspend        = dmfe_suspend,
+	.resume         = dmfe_resume
 };
 
 MODULE_AUTHOR("Sten Wang, sten_wang@davicom.com.tw");
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

dmfe-trivial-spelling-fixes.patch
dmfe-fix-two-bugs.patch
dmfe-fix-link-detection.patch
dmfe-add-support-for-suspend-resume.patch
dmfe-add-support-for-suspend-resume-fix.patch
dmfe-add-support-for-wake-on-lan.patch

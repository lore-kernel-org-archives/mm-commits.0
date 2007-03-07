From: akpm@linux-foundation.org
Subject: - dmfe-add-support-for-suspend-resume.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:23:06 -0800
Message-ID: <200703070423.l274N6ev019036@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47198 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319AbXCGEXL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:23:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maximlevitsky@gmail.com, jeff@garzik.org, val_henson@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     dmfe: add support for suspend/resume
has been removed from the -mm tree.  Its filename was
     dmfe-add-support-for-suspend-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dmfe: add support for suspend/resume
From: Maxim Levitsky <maximlevitsky@gmail.com>

This adds support for suspend resume

[akpm@linux-foundation.org: fix CONFIG_PM=n, coding style]
Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Valerie Henson <val_henson@linux.intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/dmfe.c |   52 ++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

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
 
@@ -2050,11 +2047,60 @@ static struct pci_device_id dmfe_pci_tbl
 MODULE_DEVICE_TABLE(pci, dmfe_pci_tbl);
 
 
+#ifdef CONFIG_PM
+static int dmfe_suspend(struct pci_dev *pci_dev, pm_message_t state)
+{
+	struct net_device *dev = pci_get_drvdata(pci_dev);
+	struct dmfe_board_info *db = netdev_priv(dev);
+
+	/* Disable upper layer interface */
+	netif_device_detach(dev);
+
+	/* Disable Tx/Rx */
+	db->cr6_data &= ~(CR6_RXSC | CR6_TXSC);
+	update_cr6(db->cr6_data, dev->base_addr);
+
+	/* Disable Interrupt */
+	outl(0, dev->base_addr + DCR7);
+	outl(inl (dev->base_addr + DCR5), dev->base_addr + DCR5);
+
+	/* Fre RX buffers */
+	dmfe_free_rxbuffer(db);
+
+	/* Power down device*/
+	pci_set_power_state(pci_dev, pci_choose_state (pci_dev,state));
+	pci_save_state(pci_dev);
+
+	return 0;
+}
+
+static int dmfe_resume(struct pci_dev *pci_dev)
+{
+	struct net_device *dev = pci_get_drvdata(pci_dev);
+
+	pci_restore_state(pci_dev);
+	pci_set_power_state(pci_dev, PCI_D0);
+
+	/* Re-initilize DM910X board */
+	dmfe_init_dm910x(dev);
+
+	/* Restart upper layer interface */
+	netif_device_attach(dev);
+
+	return 0;
+}
+#else
+#define dmfe_suspend NULL
+#define dmfe_resume NULL
+#endif
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

origin.patch
git-netdev-all.patch

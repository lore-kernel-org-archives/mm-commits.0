From: akpm@linux-foundation.org
Subject: + 3x59x-fix-pci-resource-management.patch added to -mm tree
Date: Wed, 10 Jun 2009 13:47:08 -0700
Message-ID: <200906102047.n5AKl80h018698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603AbZFJUvc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 16:51:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sshtylyov@ru.mvista.com, klassert@mathematik.tu-chemnitz.de


The patch titled
     3c59x: fix PCI resource management
has been added to the -mm tree.  Its filename is
     3x59x-fix-pci-resource-management.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 3c59x: fix PCI resource management
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

The driver wrongly claimed I/O ports at an address returned by pci_iomap()
-- even if it was passed an MMIO address.  Fix this by claiming/releasing
all PCI resources in the PCI driver probe/remove handlers instead and get
rid of the must_free_region flag weirdness (why would Cardbus claim
anything for us?).

Also, the remove handler was trying to talk to the chip after having
disabled its address decoders (at least on x86) -- fix this and get rid of
useless VORTEX_PCI() calls.

While at it, fix some cases of the overly indented code...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c59x.c |   66 ++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

diff -puN drivers/net/3c59x.c~3x59x-fix-pci-resource-management drivers/net/3c59x.c
--- a/drivers/net/3c59x.c~3x59x-fix-pci-resource-management
+++ a/drivers/net/3c59x.c
@@ -629,7 +629,6 @@ struct vortex_private {
 		pm_state_valid:1,				/* pci_dev->saved_config_space has sane contents */
 		open:1,
 		medialock:1,
-		must_free_region:1,				/* Flag: if zero, Cardbus owns the I/O region */
 		large_frames:1;			/* accept large frames */
 	int drv_flags;
 	u16 status_enable;
@@ -962,7 +961,13 @@ static int __devinit vortex_init_one(str
 	/* wake up and enable device */
 	rc = pci_enable_device(pdev);
 	if (rc < 0)
-		goto out;
+		return rc;
+
+	rc = pci_request_regions(pdev, "3c59x");
+	if (rc < 0) {
+		pci_disable_device(pdev);
+		return rc;
+	}
 
 	unit = vortex_cards_found;
 
@@ -982,13 +987,13 @@ static int __devinit vortex_init_one(str
 	rc = vortex_probe1(&pdev->dev, ioaddr, pdev->irq,
 			   ent->driver_data, unit);
 	if (rc < 0) {
-		pci_disable_device(pdev);
-		goto out;
+		pci_release_regions(pdev);
+		pci_disable_device (pdev);
+		return rc;
 	}
 
 	vortex_cards_found++;
 
-out:
 	return rc;
 }
 
@@ -1125,11 +1130,6 @@ static int __devinit vortex_probe1(struc
 
 	/* PCI-only startup logic */
 	if (pdev) {
-		/* EISA resources already marked, so only PCI needs to do this here */
-		/* Ignore return value, because Cardbus drivers already allocate for us */
-		if (request_region(dev->base_addr, vci->io_size, print_name) != NULL)
-			vp->must_free_region = 1;
-
 		/* enable bus-mastering if necessary */
 		if (vci->flags & PCI_USES_MASTER)
 			pci_set_master(pdev);
@@ -1160,12 +1160,13 @@ static int __devinit vortex_probe1(struc
 	vp->mii.reg_num_mask = 0x1f;
 
 	/* Makes sure rings are at least 16 byte aligned. */
-	vp->rx_ring = pci_alloc_consistent(pdev, sizeof(struct boom_rx_desc) * RX_RING_SIZE
-					   + sizeof(struct boom_tx_desc) * TX_RING_SIZE,
+	vp->rx_ring = pci_alloc_consistent(pdev,
+					   sizeof(struct boom_rx_desc) * RX_RING_SIZE +
+					   sizeof(struct boom_tx_desc) * TX_RING_SIZE,
 					   &vp->rx_ring_dma);
 	retval = -ENOMEM;
 	if (!vp->rx_ring)
-		goto free_region;
+		goto free_device;
 
 	vp->tx_ring = (struct boom_tx_desc *)(vp->rx_ring + RX_RING_SIZE);
 	vp->tx_ring_dma = vp->rx_ring_dma + sizeof(struct boom_rx_desc) * RX_RING_SIZE;
@@ -1432,13 +1433,11 @@ static int __devinit vortex_probe1(struc
 
 free_ring:
 	pci_free_consistent(pdev,
-						sizeof(struct boom_rx_desc) * RX_RING_SIZE
-							+ sizeof(struct boom_tx_desc) * TX_RING_SIZE,
-						vp->rx_ring,
-						vp->rx_ring_dma);
-free_region:
-	if (vp->must_free_region)
-		release_region(dev->base_addr, vci->io_size);
+			    sizeof(struct boom_rx_desc) * RX_RING_SIZE +
+			    sizeof(struct boom_tx_desc) * TX_RING_SIZE,
+			    vp->rx_ring,
+			    vp->rx_ring_dma);
+free_device:
 	free_netdev(dev);
 	pr_err(PFX "vortex_probe1 fails.  Returns %d\n", retval);
 out:
@@ -3165,29 +3164,28 @@ static void __devexit vortex_remove_one(
 	vp = netdev_priv(dev);
 
 	if (vp->cb_fn_base)
-		pci_iounmap(VORTEX_PCI(vp), vp->cb_fn_base);
+		pci_iounmap(pdev, vp->cb_fn_base);
 
 	unregister_netdev(dev);
 
-	if (VORTEX_PCI(vp)) {
-		pci_set_power_state(VORTEX_PCI(vp), PCI_D0);	/* Go active */
-		if (vp->pm_state_valid)
-			pci_restore_state(VORTEX_PCI(vp));
-		pci_disable_device(VORTEX_PCI(vp));
-	}
+	pci_set_power_state(pdev, PCI_D0);	/* Go active */
+	if (vp->pm_state_valid)
+		pci_restore_state(pdev);
+
 	/* Should really use issue_and_wait() here */
 	iowrite16(TotalReset | ((vp->drv_flags & EEPROM_RESET) ? 0x04 : 0x14),
 	     vp->ioaddr + EL3_CMD);
 
-	pci_iounmap(VORTEX_PCI(vp), vp->ioaddr);
+	pci_iounmap(pdev, vp->ioaddr);
 
 	pci_free_consistent(pdev,
-						sizeof(struct boom_rx_desc) * RX_RING_SIZE
-							+ sizeof(struct boom_tx_desc) * TX_RING_SIZE,
-						vp->rx_ring,
-						vp->rx_ring_dma);
-	if (vp->must_free_region)
-		release_region(dev->base_addr, vp->io_size);
+			    sizeof(struct boom_rx_desc) * RX_RING_SIZE +
+			    sizeof(struct boom_tx_desc) * TX_RING_SIZE,
+			    vp->rx_ring,
+			    vp->rx_ring_dma);
+
+	pci_release_regions(pdev);
+	pci_disable_device (pdev);
 	free_netdev(dev);
 }
 
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

linux-next.patch
3x59x-fix-pci-resource-management.patch
lib-add-lib-gcdc.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch
sound-core-pcm_timerc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch


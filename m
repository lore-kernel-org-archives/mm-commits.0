From: akpm@linux-foundation.org
Subject: - atl1-disable-broken-64-bit-dma.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:27:50 -0700
Message-ID: <200709160927.l8G9Roia009286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51614 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbXIPJis (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kronos.it@gmail.com, csnook@redhat.com, jcliburn@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     atl1: disable broken 64-bit DMA
has been removed from the -mm tree.  Its filename was
     atl1-disable-broken-64-bit-dma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atl1: disable broken 64-bit DMA
From: Luca Tettamanti <kronos.it@gmail.com>

Disable data-corrupting 64-bit DMA on atl1.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Acked-by: Jay Cliburn <jcliburn@gmail.com>
Acked-by: Chris Snook <csnook@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_main.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff -puN drivers/net/atl1/atl1_main.c~atl1-disable-broken-64-bit-dma drivers/net/atl1/atl1_main.c
--- a/drivers/net/atl1/atl1_main.c~atl1-disable-broken-64-bit-dma
+++ a/drivers/net/atl1/atl1_main.c
@@ -2202,21 +2202,16 @@ static int __devinit atl1_probe(struct p
 	struct net_device *netdev;
 	struct atl1_adapter *adapter;
 	static int cards_found = 0;
-	bool pci_using_64 = true;
 	int err;
 
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
 
-	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 	if (err) {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
-		if (err) {
-			dev_err(&pdev->dev, "no usable DMA configuration\n");
-			goto err_dma;
-		}
-		pci_using_64 = false;
+		dev_err(&pdev->dev, "no usable DMA configuration\n");
+		goto err_dma;
 	}
 	/* Mark all PCI regions associated with PCI device
 	 * pdev as being reserved by owner atl1_driver_name
@@ -2281,7 +2276,6 @@ static int __devinit atl1_probe(struct p
 
 	netdev->ethtool_ops = &atl1_ethtool_ops;
 	adapter->bd_number = cards_found;
-	adapter->pci_using_64 = pci_using_64;
 
 	/* setup the private structure */
 	err = atl1_sw_init(adapter);
@@ -2298,9 +2292,6 @@ static int __devinit atl1_probe(struct p
 	 */
 	/* netdev->features |= NETIF_F_TSO; */
 
-	if (pci_using_64)
-		netdev->features |= NETIF_F_HIGHDMA;
-
 	netdev->features |= NETIF_F_LLTX;
 
 	/*
_

Patches currently in -mm which might be from kronos.it@gmail.com are

origin.patch
git-kvm.patch
git-net.patch
git-wireless.patch

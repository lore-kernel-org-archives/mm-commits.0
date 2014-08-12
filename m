From: akpm@linux-foundation.org
Subject: [merged] rtl818x-use-pci_zalloc_consistent.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:42:49 -0700
Message-ID: <53ea6e39.OcDxM/UO6hY4ig2I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:51958 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbaHLTmu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:50 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1920577oah.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtl818x: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     rtl818x-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: rtl818x: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/rtl818x/rtl8180/dev.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/net/wireless/rtl818x/rtl8180/dev.c~rtl818x-use-pci_zalloc_consistent drivers/net/wireless/rtl818x/rtl8180/dev.c
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c~rtl818x-use-pci_zalloc_consistent
+++ a/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -972,16 +972,13 @@ static int rtl8180_init_rx_ring(struct i
 	else
 		priv->rx_ring_sz = sizeof(struct rtl8180_rx_desc);
 
-	priv->rx_ring = pci_alloc_consistent(priv->pdev,
-					     priv->rx_ring_sz * 32,
-					     &priv->rx_ring_dma);
-
+	priv->rx_ring = pci_zalloc_consistent(priv->pdev, priv->rx_ring_sz * 32,
+					      &priv->rx_ring_dma);
 	if (!priv->rx_ring || (unsigned long)priv->rx_ring & 0xFF) {
 		wiphy_err(dev->wiphy, "Cannot allocate RX ring\n");
 		return -ENOMEM;
 	}
 
-	memset(priv->rx_ring, 0, priv->rx_ring_sz * 32);
 	priv->rx_idx = 0;
 
 	for (i = 0; i < 32; i++) {
@@ -1040,14 +1037,14 @@ static int rtl8180_init_tx_ring(struct i
 	dma_addr_t dma;
 	int i;
 
-	ring = pci_alloc_consistent(priv->pdev, sizeof(*ring) * entries, &dma);
+	ring = pci_zalloc_consistent(priv->pdev, sizeof(*ring) * entries,
+				     &dma);
 	if (!ring || (unsigned long)ring & 0xFF) {
 		wiphy_err(dev->wiphy, "Cannot allocate TX ring (prio = %d)\n",
 			  prio);
 		return -ENOMEM;
 	}
 
-	memset(ring, 0, sizeof(*ring)*entries);
 	priv->tx_ring[prio].desc = ring;
 	priv->tx_ring[prio].dma = dma;
 	priv->tx_ring[prio].idx = 0;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: [merged] mwl8k-use-pci_zalloc_consistent.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:42:47 -0700
Message-ID: <53ea6e37.DJX+FoihtsCOCljY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:56710 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbaHLTms (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:48 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so1911514oig.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, buytenh@wantstofly.org, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mwl8k: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     mwl8k-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: mwl8k: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/mwl8k.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/net/wireless/mwl8k.c~mwl8k-use-pci_zalloc_consistent drivers/net/wireless/mwl8k.c
--- a/drivers/net/wireless/mwl8k.c~mwl8k-use-pci_zalloc_consistent
+++ a/drivers/net/wireless/mwl8k.c
@@ -1159,12 +1159,11 @@ static int mwl8k_rxq_init(struct ieee802
 
 	size = MWL8K_RX_DESCS * priv->rxd_ops->rxd_size;
 
-	rxq->rxd = pci_alloc_consistent(priv->pdev, size, &rxq->rxd_dma);
+	rxq->rxd = pci_zalloc_consistent(priv->pdev, size, &rxq->rxd_dma);
 	if (rxq->rxd == NULL) {
 		wiphy_err(hw->wiphy, "failed to alloc RX descriptors\n");
 		return -ENOMEM;
 	}
-	memset(rxq->rxd, 0, size);
 
 	rxq->buf = kcalloc(MWL8K_RX_DESCS, sizeof(*rxq->buf), GFP_KERNEL);
 	if (rxq->buf == NULL) {
@@ -1451,12 +1450,11 @@ static int mwl8k_txq_init(struct ieee802
 
 	size = MWL8K_TX_DESCS * sizeof(struct mwl8k_tx_desc);
 
-	txq->txd = pci_alloc_consistent(priv->pdev, size, &txq->txd_dma);
+	txq->txd = pci_zalloc_consistent(priv->pdev, size, &txq->txd_dma);
 	if (txq->txd == NULL) {
 		wiphy_err(hw->wiphy, "failed to alloc TX descriptors\n");
 		return -ENOMEM;
 	}
-	memset(txq->txd, 0, size);
 
 	txq->skb = kcalloc(MWL8K_TX_DESCS, sizeof(*txq->skb), GFP_KERNEL);
 	if (txq->skb == NULL) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch


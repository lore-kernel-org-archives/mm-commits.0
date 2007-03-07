From: akpm@linux-foundation.org
Subject: - dmfe-fix-two-bugs.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:23:00 -0800
Message-ID: <200703070423.l274N0Qd019030@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47187 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbXCGEXH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:23:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maximlevitsky@gmail.com, jeff@garzik.org, val_henson@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     dmfe: fix two bugs
has been removed from the -mm tree.  Its filename was
     dmfe-fix-two-bugs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dmfe: fix two bugs
From: Maxim Levitsky <maximlevitsky@gmail.com>

Fix a oops on module removal due to deallocating memory before unregistring
driver Fix a NULL pointer dereference when dev_alloc_skb fails

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Valerie Henson <val_henson@linux.intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/dmfe.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/net/tulip/dmfe.c~dmfe-fix-two-bugs drivers/net/tulip/dmfe.c
--- a/drivers/net/tulip/dmfe.c~dmfe-fix-two-bugs
+++ a/drivers/net/tulip/dmfe.c
@@ -501,14 +501,17 @@ static void __devexit dmfe_remove_one (s
 	DMFE_DBUG(0, "dmfe_remove_one()", 0);
 
  	if (dev) {
+
+		unregister_netdev(dev);
+
 		pci_free_consistent(db->pdev, sizeof(struct tx_desc) *
 					DESC_ALL_CNT + 0x20, db->desc_pool_ptr,
  					db->desc_pool_dma_ptr);
 		pci_free_consistent(db->pdev, TX_BUF_ALLOC * TX_DESC_CNT + 4,
 					db->buf_pool_ptr, db->buf_pool_dma_ptr);
-		unregister_netdev(dev);
 		pci_release_regions(pdev);
 		free_netdev(dev);	/* free board information */
+
 		pci_set_drvdata(pdev, NULL);
 	}
 
@@ -927,7 +930,7 @@ static inline u32 cal_CRC(unsigned char 
 static void dmfe_rx_packet(struct DEVICE *dev, struct dmfe_board_info * db)
 {
 	struct rx_desc *rxptr;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *newskb;
 	int rxlen;
 	u32 rdes0;
 
@@ -980,9 +983,11 @@ static void dmfe_rx_packet(struct DEVICE
 				} else {
 					/* Good packet, send to upper layer */
 					/* Shorst packet used new SKB */
-					if ( (rxlen < RX_COPY_SIZE) &&
-						( (skb = dev_alloc_skb(rxlen + 2) )
-						!= NULL) ) {
+					if ((rxlen < RX_COPY_SIZE) &&
+						((newskb = dev_alloc_skb(rxlen + 2))
+						!= NULL)) {
+
+						skb = newskb;
 						/* size less than COPY_SIZE, allocate a rxlen SKB */
 						skb->dev = dev;
 						skb_reserve(skb, 2); /* 16byte align */
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

origin.patch
git-netdev-all.patch

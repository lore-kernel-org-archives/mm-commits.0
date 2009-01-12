From: akpm@linux-foundation.org
Subject: - irda-fix-incomplete-conversation-to-internal-stats.patch removed from -mm tree
Date: Mon, 12 Jan 2009 11:58:12 -0800
Message-ID: <200901121958.n0CJwC6A027353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755258AbZALUKl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 15:10:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     irda: fix incomplete conversation to internal stats
has been removed from the -mm tree.  Its filename was
     irda-fix-incomplete-conversation-to-internal-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: irda: fix incomplete conversation to internal stats
From: Alexander Beregalov <a.beregalov@gmail.com>

Fix for commit af0490810c (irda: convert to internal stats)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/au1k_ir.c  |    2 +-
 drivers/net/irda/donauboe.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/net/irda/au1k_ir.c~irda-fix-incomplete-conversation-to-internal-stats drivers/net/irda/au1k_ir.c
--- a/drivers/net/irda/au1k_ir.c~irda-fix-incomplete-conversation-to-internal-stats
+++ a/drivers/net/irda/au1k_ir.c
@@ -594,7 +594,7 @@ static int au1k_irda_rx(struct net_devic
 			update_rx_stats(dev, flags, count);
 			skb=alloc_skb(count+1,GFP_ATOMIC);
 			if (skb == NULL) {
-				aup->stats.rx_dropped++;
+				aup->netdev->stats.rx_dropped++;
 				continue;
 			}
 			skb_reserve(skb, 1);
diff -puN drivers/net/irda/donauboe.c~irda-fix-incomplete-conversation-to-internal-stats drivers/net/irda/donauboe.c
--- a/drivers/net/irda/donauboe.c~irda-fix-incomplete-conversation-to-internal-stats
+++ a/drivers/net/irda/donauboe.c
@@ -1194,13 +1194,13 @@ toshoboe_interrupt (int irq, void *dev_i
               txp = txpc;
               txpc++;
               txpc %= TX_SLOTS;
-              self->stats.tx_packets++;
+              self->netdev->stats.tx_packets++;
               if (self->ring->tx[txpc].control & OBOE_CTL_TX_HW_OWNS)
                   self->ring->tx[txp].control &= ~OBOE_CTL_TX_RTCENTX;
             }
-          self->stats.tx_packets--;
+          self->netdev->stats.tx_packets--;
 #else
-          self->stats.tx_packets++;
+          self->netdev->stats.tx_packets++;
 #endif
           toshoboe_start_DMA(self, OBOE_CONFIG0H_ENTX);
         }
@@ -1280,7 +1280,7 @@ dumpbufs(self->rx_bufs[self->rxs],len,'<
                       skb_put (skb, len);
                       skb_copy_to_linear_data(skb, self->rx_bufs[self->rxs],
 					      len);
-                      self->stats.rx_packets++;
+                      self->netdev->stats.rx_packets++;
                       skb->dev = self->netdev;
                       skb_reset_mac_header(skb);
                       skb->protocol = htons (ETH_P_IRDA);
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

linux-next.patch


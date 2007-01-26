From: akpm@osdl.org
Subject: - forcedeth-statistics-optimization.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:52:20 -0800
Message-ID: <200701260752.l0Q7qKQJ010832@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50551 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030828AbXAZHwX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:52:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: statistics optimization
has been removed from the -mm tree.  Its filename was
     forcedeth-statistics-optimization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: forcedeth: statistics optimization
From: Ayaz Abdulla <aabdulla@nvidia.com>

Optimize the data paths that can support hw counters.  It removes the sw
counted statistics.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/forcedeth.c |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-statistics-optimization drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-statistics-optimization
+++ a/drivers/net/forcedeth.c
@@ -1351,10 +1351,19 @@ static struct net_device_stats *nv_get_s
 {
 	struct fe_priv *np = netdev_priv(dev);
 
-	/* It seems that the nic always generates interrupts and doesn't
-	 * accumulate errors internally. Thus the current values in np->stats
-	 * are already up to date.
-	 */
+	/* If the nic supports hw counters then retrieve latest values */
+	if (np->driver_data & (DEV_HAS_STATISTICS_V1|DEV_HAS_STATISTICS_V2)) {
+		nv_get_hw_stats(dev);
+
+		/* copy to net_device stats */
+		np->stats.tx_bytes = np->estats.tx_bytes;
+		np->stats.tx_fifo_errors = np->estats.tx_fifo_errors;
+		np->stats.tx_carrier_errors = np->estats.tx_carrier_errors;
+		np->stats.rx_crc_errors = np->estats.rx_crc_errors;
+		np->stats.rx_over_errors = np->estats.rx_over_errors;
+		np->stats.rx_errors = np->estats.rx_errors_total;
+		np->stats.tx_errors = np->estats.tx_errors_total;
+	}
 	return &np->stats;
 }
 
@@ -1944,16 +1953,8 @@ static void nv_tx_done_optimized(struct 
 		np->get_tx_ctx->dma = 0;
 
 		if (flags & NV_TX2_LASTPACKET) {
-			if (flags & NV_TX2_ERROR) {
-				if (flags & NV_TX2_UNDERFLOW)
-					np->stats.tx_fifo_errors++;
-				if (flags & NV_TX2_CARRIERLOST)
-					np->stats.tx_carrier_errors++;
-				np->stats.tx_errors++;
-			} else {
+			if (!(flags & NV_TX2_ERROR))
 				np->stats.tx_packets++;
-				np->stats.tx_bytes += np->get_tx_ctx->skb->len;
-			}
 			dev_kfree_skb_any(np->get_tx_ctx->skb);
 			np->get_tx_ctx->skb = NULL;
 		}
@@ -2290,7 +2291,6 @@ static int nv_rx_process_optimized(struc
 				if (flags & NV_RX2_ERROR4) {
 					len = nv_getlen(dev, skb->data, len);
 					if (len < 0) {
-						np->stats.rx_errors++;
 						dev_kfree_skb(skb);
 						goto next_pkt;
 					}
@@ -2303,11 +2303,6 @@ static int nv_rx_process_optimized(struc
 				}
 				/* the rest are hard errors */
 				else {
-					if (flags & NV_RX2_CRCERR)
-						np->stats.rx_crc_errors++;
-					if (flags & NV_RX2_OVERFLOW)
-						np->stats.rx_over_errors++;
-					np->stats.rx_errors++;
 					dev_kfree_skb(skb);
 					goto next_pkt;
 				}
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

git-netdev-all.patch

From: akpm@osdl.org
Subject: - forcedeth-rx-skb-recycle.patch removed from -mm tree
Date: Mon, 22 Jan 2007 12:46:50 -0800
Message-ID: <200701222046.l0MKkoAt001586@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50443 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545AbXAVUq6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 15:46:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: rx skb recycle
has been removed from the -mm tree.  Its filename was
     forcedeth-rx-skb-recycle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: forcedeth: rx skb recycle
From: Ayaz Abdulla <aabdulla@nvidia.com>

Remove the code that recycled the skb on error.  This will help in reducing
the branches in the main data paths.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/forcedeth.c |   78 ++++++++++++++++++++------------------
 1 files changed, 43 insertions(+), 35 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-rx-skb-recycle drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-rx-skb-recycle
+++ a/drivers/net/forcedeth.c
@@ -1330,36 +1330,32 @@ static int nv_alloc_rx(struct net_device
 				break;
 		}
 
-		if (np->put_rx_ctx->skb == NULL) {
-
-			skb = dev_alloc_skb(np->rx_buf_sz + NV_RX_ALLOC_PAD);
-			if (!skb)
-				return 1;
-
+		skb = dev_alloc_skb(np->rx_buf_sz + NV_RX_ALLOC_PAD);
+		if (skb) {
 			skb->dev = dev;
 			np->put_rx_ctx->skb = skb;
+			np->put_rx_ctx->dma = pci_map_single(np->pci_dev, skb->data,
+							     skb->end-skb->data, PCI_DMA_FROMDEVICE);
+			np->put_rx_ctx->dma_len = skb->end-skb->data;
+			if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
+				np->put_rx.orig->buf = cpu_to_le32(np->put_rx_ctx->dma);
+				wmb();
+				np->put_rx.orig->flaglen = cpu_to_le32(np->rx_buf_sz | NV_RX_AVAIL);
+				if (np->put_rx.orig++ == np->last_rx.orig)
+					np->put_rx.orig = np->first_rx.orig;
+			} else {
+				np->put_rx.ex->bufhigh = cpu_to_le64(np->put_rx_ctx->dma) >> 32;
+				np->put_rx.ex->buflow = cpu_to_le64(np->put_rx_ctx->dma) & 0x0FFFFFFFF;
+				wmb();
+				np->put_rx.ex->flaglen = cpu_to_le32(np->rx_buf_sz | NV_RX2_AVAIL);
+				if (np->put_rx.ex++ == np->last_rx.ex)
+					np->put_rx.ex = np->first_rx.ex;
+			}
+			if (np->put_rx_ctx++ == np->last_rx_ctx)
+				np->put_rx_ctx = np->first_rx_ctx;
 		} else {
-			skb = np->put_rx_ctx->skb;
-		}
-		np->put_rx_ctx->dma = pci_map_single(np->pci_dev, skb->data,
-					skb->end-skb->data, PCI_DMA_FROMDEVICE);
-		np->put_rx_ctx->dma_len = skb->end-skb->data;
-		if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
-			np->put_rx.orig->buf = cpu_to_le32(np->put_rx_ctx->dma);
-			wmb();
-			np->put_rx.orig->flaglen = cpu_to_le32(np->rx_buf_sz | NV_RX_AVAIL);
-			if (np->put_rx.orig++ == np->last_rx.orig)
-				np->put_rx.orig = np->first_rx.orig;
-		} else {
-			np->put_rx.ex->bufhigh = cpu_to_le64(np->put_rx_ctx->dma) >> 32;
-			np->put_rx.ex->buflow = cpu_to_le64(np->put_rx_ctx->dma) & 0x0FFFFFFFF;
-			wmb();
-			np->put_rx.ex->flaglen = cpu_to_le32(np->rx_buf_sz | NV_RX2_AVAIL);
-			if (np->put_rx.ex++ == np->last_rx.ex)
-				np->put_rx.ex = np->first_rx.ex;
+			return 1;
 		}
-		if (np->put_rx_ctx++ == np->last_rx_ctx)
-			np->put_rx_ctx = np->first_rx_ctx;
 	}
 	return 0;
 }
@@ -1948,6 +1944,8 @@ static int nv_rx_process(struct net_devi
 		pci_unmap_single(np->pci_dev, np->get_rx_ctx->dma,
 				np->get_rx_ctx->dma_len,
 				PCI_DMA_FROMDEVICE);
+		skb = np->get_rx_ctx->skb;
+		np->get_rx_ctx->skb = NULL;
 
 		{
 			int j;
@@ -1955,39 +1953,46 @@ static int nv_rx_process(struct net_devi
 			for (j=0; j<64; j++) {
 				if ((j%16) == 0)
 					dprintk("\n%03x:", j);
-				dprintk(" %02x", ((unsigned char*)np->get_rx_ctx->skb->data)[j]);
+				dprintk(" %02x", ((unsigned char*)skb->data)[j]);
 			}
 			dprintk("\n");
 		}
 		/* look at what we actually got: */
 		if (np->desc_ver == DESC_VER_1) {
-			if (!(flags & NV_RX_DESCRIPTORVALID))
+			if (!(flags & NV_RX_DESCRIPTORVALID)) {
+				dev_kfree_skb(skb);
 				goto next_pkt;
+			}
 
 			if (flags & NV_RX_ERROR) {
 				if (flags & NV_RX_MISSEDFRAME) {
 					np->stats.rx_missed_errors++;
 					np->stats.rx_errors++;
+					dev_kfree_skb(skb);
 					goto next_pkt;
 				}
 				if (flags & (NV_RX_ERROR1|NV_RX_ERROR2|NV_RX_ERROR3)) {
 					np->stats.rx_errors++;
+					dev_kfree_skb(skb);
 					goto next_pkt;
 				}
 				if (flags & NV_RX_CRCERR) {
 					np->stats.rx_crc_errors++;
 					np->stats.rx_errors++;
+					dev_kfree_skb(skb);
 					goto next_pkt;
 				}
 				if (flags & NV_RX_OVERFLOW) {
 					np->stats.rx_over_errors++;
 					np->stats.rx_errors++;
+					dev_kfree_skb(skb);
 					goto next_pkt;
 				}
 				if (flags & NV_RX_ERROR4) {
-					len = nv_getlen(dev, np->get_rx_ctx->skb->data, len);
+					len = nv_getlen(dev, skb->data, len);
 					if (len < 0) {
 						np->stats.rx_errors++;
+						dev_kfree_skb(skb);
 						goto next_pkt;
 					}
 				}
@@ -1999,28 +2004,34 @@ static int nv_rx_process(struct net_devi
 				}
 			}
 		} else {
-			if (!(flags & NV_RX2_DESCRIPTORVALID))
+			if (!(flags & NV_RX2_DESCRIPTORVALID)) {
+				dev_kfree_skb(skb);
 				goto next_pkt;
+			}
 
 			if (flags & NV_RX2_ERROR) {
 				if (flags & (NV_RX2_ERROR1|NV_RX2_ERROR2|NV_RX2_ERROR3)) {
 					np->stats.rx_errors++;
+					dev_kfree_skb(skb);
 					goto next_pkt;
 				}
 				if (flags & NV_RX2_CRCERR) {
 					np->stats.rx_crc_errors++;
 					np->stats.rx_errors++;
+					dev_kfree_skb(skb);
 					goto next_pkt;
 				}
 				if (flags & NV_RX2_OVERFLOW) {
 					np->stats.rx_over_errors++;
 					np->stats.rx_errors++;
+					dev_kfree_skb(skb);
 					goto next_pkt;
 				}
 				if (flags & NV_RX2_ERROR4) {
-					len = nv_getlen(dev, np->get_rx_ctx->skb->data, len);
+					len = nv_getlen(dev, skb->data, len);
 					if (len < 0) {
 						np->stats.rx_errors++;
+						dev_kfree_skb(skb);
 						goto next_pkt;
 					}
 				}
@@ -2037,16 +2048,13 @@ static int nv_rx_process(struct net_devi
 				    flags == NV_RX2_CHECKSUMOK2 ||
 				    flags == NV_RX2_CHECKSUMOK3) {
 					dprintk(KERN_DEBUG "%s: hw checksum hit!.\n", dev->name);
-					np->get_rx_ctx->skb->ip_summed = CHECKSUM_UNNECESSARY;
+					skb->ip_summed = CHECKSUM_UNNECESSARY;
 				} else {
 					dprintk(KERN_DEBUG "%s: hwchecksum miss!.\n", dev->name);
 				}
 			}
 		}
 		/* got a valid packet - forward it to the network core */
-		skb = np->get_rx_ctx->skb;
-		np->get_rx_ctx->skb = NULL;
-
 		skb_put(skb, len);
 		skb->protocol = eth_type_trans(skb, dev);
 		dprintk(KERN_DEBUG "%s: nv_rx_process: %d bytes, proto %d accepted.\n",
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

git-netdev-all.patch
forcedeth-optimized-routines.patch
forcedeth-tx-limiting.patch
forcedeth-tx-data-path-optimization.patch
forcedeth-rx-data-path-optimization.patch
forcedeth-irq-data-path-optimization.patch
forcedeth-tx-max-work.patch
forcedeth-statistics-supported.patch
forcedeth-statistics-optimization.patch

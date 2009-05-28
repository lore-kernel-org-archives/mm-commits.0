From: akpm@linux-foundation.org
Subject: + net-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch added to -mm tree
Date: Wed, 27 May 2009 22:35:29 -0700
Message-ID: <200905280535.n4S5ZTlL031983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326AbZE1Ffe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 01:35:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net


The patch titled
     net: replace dma_sync_single with dma_sync_single_for_cpu
has been added to the -mm tree.  Its filename is
     net-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch

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
Subject: net: replace dma_sync_single with dma_sync_single_for_cpu
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This replaces dma_sync_single() with dma_sync_single_for_cpu() because
dma_sync_single() is an obsolete API; include/linux/dma-mapping.h says:

/* Backwards compat, remove in 2.7.x */
#define dma_sync_single		dma_sync_single_for_cpu
#define dma_sync_sg		dma_sync_sg_for_cpu

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/arm/ep93xx_eth.c |    4 ++--
 drivers/net/arm/ixp4xx_eth.c |    4 ++--
 drivers/net/mlx4/mr.c        |    7 ++++---
 drivers/net/wan/ixp4xx_hss.c |    4 ++--
 4 files changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/net/arm/ep93xx_eth.c~net-replace-dma_sync_single-with-dma_sync_single_for_cpu drivers/net/arm/ep93xx_eth.c
--- a/drivers/net/arm/ep93xx_eth.c~net-replace-dma_sync_single-with-dma_sync_single_for_cpu
+++ a/drivers/net/arm/ep93xx_eth.c
@@ -253,7 +253,7 @@ static int ep93xx_rx(struct net_device *
 		skb = dev_alloc_skb(length + 2);
 		if (likely(skb != NULL)) {
 			skb_reserve(skb, 2);
-			dma_sync_single(NULL, ep->descs->rdesc[entry].buf_addr,
+			dma_sync_single_for_cpu(NULL, ep->descs->rdesc[entry].buf_addr,
 						length, DMA_FROM_DEVICE);
 			skb_copy_to_linear_data(skb, ep->rx_buf[entry], length);
 			skb_put(skb, length);
@@ -331,7 +331,7 @@ static int ep93xx_xmit(struct sk_buff *s
 	ep->descs->tdesc[entry].tdesc1 =
 		TDESC1_EOF | (entry << 16) | (skb->len & 0xfff);
 	skb_copy_and_csum_dev(skb, ep->tx_buf[entry]);
-	dma_sync_single(NULL, ep->descs->tdesc[entry].buf_addr,
+	dma_sync_single_for_cpu(NULL, ep->descs->tdesc[entry].buf_addr,
 				skb->len, DMA_TO_DEVICE);
 	dev_kfree_skb(skb);
 
diff -puN drivers/net/arm/ixp4xx_eth.c~net-replace-dma_sync_single-with-dma_sync_single_for_cpu drivers/net/arm/ixp4xx_eth.c
--- a/drivers/net/arm/ixp4xx_eth.c~net-replace-dma_sync_single-with-dma_sync_single_for_cpu
+++ a/drivers/net/arm/ixp4xx_eth.c
@@ -562,8 +562,8 @@ static int eth_poll(struct napi_struct *
 		dma_unmap_single(&dev->dev, desc->data - NET_IP_ALIGN,
 				 RX_BUFF_SIZE, DMA_FROM_DEVICE);
 #else
-		dma_sync_single(&dev->dev, desc->data - NET_IP_ALIGN,
-				RX_BUFF_SIZE, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(&dev->dev, desc->data - NET_IP_ALIGN,
+					RX_BUFF_SIZE, DMA_FROM_DEVICE);
 		memcpy_swab32((u32 *)skb->data, (u32 *)port->rx_buff_tab[n],
 			      ALIGN(NET_IP_ALIGN + desc->pkt_len, 4) / 4);
 #endif
diff -puN drivers/net/mlx4/mr.c~net-replace-dma_sync_single-with-dma_sync_single_for_cpu drivers/net/mlx4/mr.c
--- a/drivers/net/mlx4/mr.c~net-replace-dma_sync_single-with-dma_sync_single_for_cpu
+++ a/drivers/net/mlx4/mr.c
@@ -402,7 +402,8 @@ static int mlx4_write_mtt_chunk(struct m
 	for (i = 0; i < npages; ++i)
 		mtts[i] = cpu_to_be64(page_list[i] | MLX4_MTT_FLAG_PRESENT);
 
-	dma_sync_single(&dev->pdev->dev, dma_handle, npages * sizeof (u64), DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(&dev->pdev->dev, dma_handle,
+				npages * sizeof (u64), DMA_TO_DEVICE);
 
 	return 0;
 }
@@ -549,8 +550,8 @@ int mlx4_map_phys_fmr(struct mlx4_dev *d
 	for (i = 0; i < npages; ++i)
 		fmr->mtts[i] = cpu_to_be64(page_list[i] | MLX4_MTT_FLAG_PRESENT);
 
-	dma_sync_single(&dev->pdev->dev, fmr->dma_handle,
-			npages * sizeof(u64), DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(&dev->pdev->dev, fmr->dma_handle,
+				npages * sizeof(u64), DMA_TO_DEVICE);
 
 	fmr->mpt->key    = cpu_to_be32(key);
 	fmr->mpt->lkey   = cpu_to_be32(key);
diff -puN drivers/net/wan/ixp4xx_hss.c~net-replace-dma_sync_single-with-dma_sync_single_for_cpu drivers/net/wan/ixp4xx_hss.c
--- a/drivers/net/wan/ixp4xx_hss.c~net-replace-dma_sync_single-with-dma_sync_single_for_cpu
+++ a/drivers/net/wan/ixp4xx_hss.c
@@ -732,8 +732,8 @@ static int hss_hdlc_poll(struct napi_str
 		dma_unmap_single(&dev->dev, desc->data,
 				 RX_SIZE, DMA_FROM_DEVICE);
 #else
-		dma_sync_single(&dev->dev, desc->data,
-				RX_SIZE, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(&dev->dev, desc->data,
+					RX_SIZE, DMA_FROM_DEVICE);
 		memcpy_swab32((u32 *)skb->data, (u32 *)port->rx_buff_tab[n],
 			      ALIGN(desc->pkt_len, 4) / 4);
 #endif
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
sg_io-dont-perform-unneeded-copy-in-compat-code.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
net-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
vino-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
usb-replace-dma_sync_single-and-dma_sync_sg-with-dma_sync_single_for_cpu-and-dma_sync_sg_for_cpu.patch


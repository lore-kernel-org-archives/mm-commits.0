From: akpm@linux-foundation.org
Subject: - ixp4xx_eth-fix-dma_mapping_error-compile-errors.patch removed from -mm tree
Date: Thu, 14 Aug 2008 16:54:40 -0700
Message-ID: <200808142354.m7ENseWO003959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846AbYHNXzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikpe@it.uu.se, jeff@garzik.org, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     ixp4xx_eth: fix dma_mapping_error() compile errors
has been removed from the -mm tree.  Its filename was
     ixp4xx_eth-fix-dma_mapping_error-compile-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ixp4xx_eth: fix dma_mapping_error() compile errors
From: Mikael Pettersson <mikpe@it.uu.se>

The arm ixp4xx_eth driver doesn't compile in 2.6.27-rc1:

  CC [M]  drivers/net/arm/ixp4xx_eth.o
drivers/net/arm/ixp4xx_eth.c: In function 'eth_poll':
drivers/net/arm/ixp4xx_eth.c:554: warning: passing argument 1 of 'dma_mapping_error' makes pointer from integer without a cast
drivers/net/arm/ixp4xx_eth.c:554: error: too few arguments to function 'dma_mapping_error'
drivers/net/arm/ixp4xx_eth.c: In function 'eth_xmit':
drivers/net/arm/ixp4xx_eth.c:701: warning: passing argument 1 of 'dma_mapping_error' makes pointer from integer without a cast
drivers/net/arm/ixp4xx_eth.c:701: error: too few arguments to function 'dma_mapping_error'
drivers/net/arm/ixp4xx_eth.c: In function 'init_queues':
drivers/net/arm/ixp4xx_eth.c:886: warning: passing argument 1 of 'dma_mapping_error' makes pointer from integer without a cast
drivers/net/arm/ixp4xx_eth.c:886: error: too few arguments to function 'dma_mapping_error'
make[3]: *** [drivers/net/arm/ixp4xx_eth.o] Error 1
make[2]: *** [drivers/net/arm] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

dma_mapping_error() changed in 2.6.27-rc1 to also take a device parameter,
but nobody bothered updating ixp4xx_eth.c. Fixed by passing the appropriate
device value in the dma_mapping_error() calls.

Tested on an ixp425 box.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Acked-by: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/arm/ixp4xx_eth.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/arm/ixp4xx_eth.c~ixp4xx_eth-fix-dma_mapping_error-compile-errors drivers/net/arm/ixp4xx_eth.c
--- a/drivers/net/arm/ixp4xx_eth.c~ixp4xx_eth-fix-dma_mapping_error-compile-errors
+++ a/drivers/net/arm/ixp4xx_eth.c
@@ -551,7 +551,7 @@ static int eth_poll(struct napi_struct *
 		if ((skb = netdev_alloc_skb(dev, RX_BUFF_SIZE))) {
 			phys = dma_map_single(&dev->dev, skb->data,
 					      RX_BUFF_SIZE, DMA_FROM_DEVICE);
-			if (dma_mapping_error(phys)) {
+			if (dma_mapping_error(&dev->dev, phys)) {
 				dev_kfree_skb(skb);
 				skb = NULL;
 			}
@@ -698,7 +698,7 @@ static int eth_xmit(struct sk_buff *skb,
 #endif
 
 	phys = dma_map_single(&dev->dev, mem, bytes, DMA_TO_DEVICE);
-	if (dma_mapping_error(phys)) {
+	if (dma_mapping_error(&dev->dev, phys)) {
 #ifdef __ARMEB__
 		dev_kfree_skb(skb);
 #else
@@ -883,7 +883,7 @@ static int init_queues(struct port *port
 		desc->buf_len = MAX_MRU;
 		desc->data = dma_map_single(&port->netdev->dev, data,
 					    RX_BUFF_SIZE, DMA_FROM_DEVICE);
-		if (dma_mapping_error(desc->data)) {
+		if (dma_mapping_error(&port->netdev->dev, desc->data)) {
 			free_buffer(buff);
 			return -EIO;
 		}
_

Patches currently in -mm which might be from mikpe@it.uu.se are

git-net.patch


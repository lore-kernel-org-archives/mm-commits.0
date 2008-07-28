From: akpm@linux-foundation.org
Subject: - powerpc-ibmveth-fix-multiple-errors-with-dma_mapping_error-conversion.patch removed from -mm tree
Date: Mon, 28 Jul 2008 14:11:07 -0700
Message-ID: <200807282111.m6SLB7sO027642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760894AbYG1VRq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 17:17:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     powerpc/ibmveth: fix multiple errors with dma_mapping_error conversion
has been removed from the -mm tree.  Its filename was
     powerpc-ibmveth-fix-multiple-errors-with-dma_mapping_error-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc/ibmveth: fix multiple errors with dma_mapping_error conversion
From: Stephen Rothwell <sfr@canb.auug.org.au>

The addition of an argument to dma_mapping_error() in commit
8d8bb39b9eba32dd70e87fd5ad5c5dd4ba118e06 "dma-mapping: add the device
argument to dma_mapping_error()" left a bit of fallout:

drivers/net/ibmveth.c:263: error: too few arguments to function 'dma_mapping_error'
drivers/net/ibmveth.c:264: error: expected ')' before 'goto'
drivers/net/ibmveth.c:284: error: expected expression before '}' token
drivers/net/ibmveth.c:297: error: too few arguments to function 'dma_mapping_error'
drivers/net/ibmveth.c:298: error: expected ')' before 'dma_unmap_single'
drivers/net/ibmveth.c:306: error: expected expression before '}' token
drivers/net/ibmveth.c:491: error: too few arguments to function 'dma_mapping_error'
drivers/net/ibmveth.c:927: error: too few arguments to function 'dma_mapping_error'
drivers/net/ibmveth.c:927: error: expected ')' before '{' token
drivers/net/ibmveth.c:974: error: expected expression before '}' token
drivers/net/ibmveth.c:914: error: label 'out' used but not defined m

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ibmveth.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/ibmveth.c~powerpc-ibmveth-fix-multiple-errors-with-dma_mapping_error-conversion drivers/net/ibmveth.c
--- a/drivers/net/ibmveth.c~powerpc-ibmveth-fix-multiple-errors-with-dma_mapping_error-conversion
+++ a/drivers/net/ibmveth.c
@@ -260,7 +260,7 @@ static void ibmveth_replenish_buffer_poo
 		dma_addr = dma_map_single(&adapter->vdev->dev, skb->data,
 				pool->buff_size, DMA_FROM_DEVICE);
 
-		if (dma_mapping_error((&adapter->vdev->dev, dma_addr))
+		if (dma_mapping_error(&adapter->vdev->dev, dma_addr))
 			goto failure;
 
 		pool->free_map[free_index] = IBM_VETH_INVALID_MAP;
@@ -294,7 +294,7 @@ failure:
 		pool->consumer_index = pool->size - 1;
 	else
 		pool->consumer_index--;
-	if (!dma_mapping_error((&adapter->vdev->dev, dma_addr))
+	if (!dma_mapping_error(&adapter->vdev->dev, dma_addr))
 		dma_unmap_single(&adapter->vdev->dev,
 		                 pool->dma_addr[index], pool->buff_size,
 		                 DMA_FROM_DEVICE);
@@ -488,7 +488,7 @@ static void ibmveth_cleanup(struct ibmve
 						 &adapter->rx_buff_pool[i]);
 
 	if (adapter->bounce_buffer != NULL) {
-		if (!dma_mapping_error(adapter->bounce_buffer_dma)) {
+		if (!dma_mapping_error(dev, adapter->bounce_buffer_dma)) {
 			dma_unmap_single(&adapter->vdev->dev,
 					adapter->bounce_buffer_dma,
 					adapter->netdev->mtu + IBMVETH_BUFF_OH,
@@ -924,7 +924,7 @@ static int ibmveth_start_xmit(struct sk_
 		buf[1] = 0;
 	}
 
-	if (dma_mapping_error((&adapter->vdev->dev, data_dma_addr)) {
+	if (dma_mapping_error(&adapter->vdev->dev, data_dma_addr)) {
 		if (!firmware_has_feature(FW_FEATURE_CMO))
 			ibmveth_error_printk("tx: unable to map xmit buffer\n");
 		skb_copy_from_linear_data(skb, adapter->bounce_buffer,
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch


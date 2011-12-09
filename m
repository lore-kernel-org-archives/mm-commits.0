From: akpm@linux-foundation.org
Subject: [merged] rapidio-tsi721-switch-to-dma_zalloc_coherent.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:08:45 -0800
Message-ID: <201112092008.pB9K8jHj014857@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:51009 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab1LIUIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:08:46 -0500
Received: by mail-yx0-f202.google.com with SMTP id m5so433165yen.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 12:08:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: switch to dma_zalloc_coherent
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-switch-to-dma_zalloc_coherent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: switch to dma_zalloc_coherent

Replace the pair dma_alloc_coherent()+memset() with the new
dma_zalloc_coherent() added by Andrew Morton for kernel version 3.2

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-switch-to-dma_zalloc_coherent drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-switch-to-dma_zalloc_coherent
+++ a/drivers/rapidio/devices/tsi721.c
@@ -851,14 +851,12 @@ static int tsi721_doorbell_init(struct t
 	INIT_WORK(&priv->idb_work, tsi721_db_dpc);
 
 	/* Allocate buffer for inbound doorbells queue */
-	priv->idb_base = dma_alloc_coherent(&priv->pdev->dev,
+	priv->idb_base = dma_zalloc_coherent(&priv->pdev->dev,
 				IDB_QSIZE * TSI721_IDB_ENTRY_SIZE,
 				&priv->idb_dma, GFP_KERNEL);
 	if (!priv->idb_base)
 		return -ENOMEM;
 
-	memset(priv->idb_base, 0, IDB_QSIZE * TSI721_IDB_ENTRY_SIZE);
-
 	dev_dbg(&priv->pdev->dev, "Allocated IDB buffer @ %p (phys = %llx)\n",
 		priv->idb_base, (unsigned long long)priv->idb_dma);
 
@@ -904,7 +902,7 @@ static int tsi721_bdma_ch_init(struct ts
 	 */
 
 	/* Allocate space for DMA descriptors */
-	bd_ptr = dma_alloc_coherent(&priv->pdev->dev,
+	bd_ptr = dma_zalloc_coherent(&priv->pdev->dev,
 					bd_num * sizeof(struct tsi721_dma_desc),
 					&bd_phys, GFP_KERNEL);
 	if (!bd_ptr)
@@ -913,8 +911,6 @@ static int tsi721_bdma_ch_init(struct ts
 	priv->bdma[chnum].bd_phys = bd_phys;
 	priv->bdma[chnum].bd_base = bd_ptr;
 
-	memset(bd_ptr, 0, bd_num * sizeof(struct tsi721_dma_desc));
-
 	dev_dbg(&priv->pdev->dev, "DMA descriptors @ %p (phys = %llx)\n",
 		bd_ptr, (unsigned long long)bd_phys);
 
@@ -922,7 +918,7 @@ static int tsi721_bdma_ch_init(struct ts
 	sts_size = (bd_num >= TSI721_DMA_MINSTSSZ) ?
 					bd_num : TSI721_DMA_MINSTSSZ;
 	sts_size = roundup_pow_of_two(sts_size);
-	sts_ptr = dma_alloc_coherent(&priv->pdev->dev,
+	sts_ptr = dma_zalloc_coherent(&priv->pdev->dev,
 				     sts_size * sizeof(struct tsi721_dma_sts),
 				     &sts_phys, GFP_KERNEL);
 	if (!sts_ptr) {
@@ -938,8 +934,6 @@ static int tsi721_bdma_ch_init(struct ts
 	priv->bdma[chnum].sts_base = sts_ptr;
 	priv->bdma[chnum].sts_size = sts_size;
 
-	memset(sts_ptr, 0, sts_size);
-
 	dev_dbg(&priv->pdev->dev,
 		"desc status FIFO @ %p (phys = %llx) size=0x%x\n",
 		sts_ptr, (unsigned long long)sts_phys, sts_size);
@@ -1400,7 +1394,7 @@ static int tsi721_open_outb_mbox(struct 
 
 	/* Outbound message descriptor status FIFO allocation */
 	priv->omsg_ring[mbox].sts_size = roundup_pow_of_two(entries + 1);
-	priv->omsg_ring[mbox].sts_base = dma_alloc_coherent(&priv->pdev->dev,
+	priv->omsg_ring[mbox].sts_base = dma_zalloc_coherent(&priv->pdev->dev,
 			priv->omsg_ring[mbox].sts_size *
 						sizeof(struct tsi721_dma_sts),
 			&priv->omsg_ring[mbox].sts_phys, GFP_KERNEL);
@@ -1412,9 +1406,6 @@ static int tsi721_open_outb_mbox(struct 
 		goto out_desc;
 	}
 
-	memset(priv->omsg_ring[mbox].sts_base, 0,
-		entries * sizeof(struct tsi721_dma_sts));

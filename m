From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-tsi721_dma-adjust-six-checks-for-null-pointers.patch removed from
 -mm tree
Date: Wed, 07 Feb 2018 11:58:45 -0800
Message-ID: <20180207195845.eTLqxNF7a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60080 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754221AbeBGT6q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:58:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, mporter@kernel.crashing.org


The patch titled
     Subject: drivers/rapidio/devices/tsi721_dma.c: adjust six checks for null pointers
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721_dma-adjust-six-checks-for-null-pointers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: drivers/rapidio/devices/tsi721_dma.c: adjust six checks for null pointers

checkpatch pointed out the following:

Comparison to NULL could be written !...

Thus fix the affected source code places.

Link: http://lkml.kernel.org/r/c3e79a1a-891e-cb62-990f-bd99839311b9@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721_dma.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-adjust-six-checks-for-null-pointers drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-adjust-six-checks-for-null-pointers
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -222,7 +222,7 @@ static int tsi721_bdma_ch_free(struct ts
 	struct tsi721_device *priv = to_tsi721(bdma_chan->dchan.device);
 #endif
 
-	if (bdma_chan->bd_base == NULL)
+	if (!bdma_chan->bd_base)
 		return 0;
 
 	/* Check if DMA channel still running */
@@ -346,7 +346,7 @@ tsi721_desc_fill_init(struct tsi721_tx_d
 {
 	u64 rio_addr;
 
-	if (bd_ptr == NULL)
+	if (!bd_ptr)
 		return -EINVAL;
 
 	/* Initialize DMA descriptor */
@@ -370,7 +370,7 @@ tsi721_desc_fill_init(struct tsi721_tx_d
 static int
 tsi721_desc_fill_end(struct tsi721_dma_desc *bd_ptr, u32 bcount, bool interrupt)
 {
-	if (bd_ptr == NULL)
+	if (!bd_ptr)
 		return -EINVAL;
 
 	/* Update DMA descriptor */
@@ -555,9 +555,7 @@ static void tsi721_advance_work(struct t
 	 * If there is no data transfer in progress, fetch new descriptor from
 	 * the pending queue.
 	*/

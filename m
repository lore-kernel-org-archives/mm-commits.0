From: akpm@linux-foundation.org
Subject: [patch 070/114] drivers/rapidio/devices/tsi721_dma.c:
 delete an error message for a failed memory allocation in
 tsi721_alloc_chan_resources()
Date: Tue, 06 Feb 2018 15:40:06 -0800
Message-ID: <20180206234006.hWUufjBpV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55364 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932090AbeBFXkI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:40:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexandre.bounine@idt.com, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, mporter@kernel.crashing.org, torvalds@linux-foundation.org

From: Markus Elfring <elfring@users.sourceforge.net>
Subject: drivers/rapidio/devices/tsi721_dma.c: delete an error message for a failed memory allocation in tsi721_alloc_chan_resources()

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Link: http://lkml.kernel.org/r/a96fcaf8-ea24-bcac-0214-273620349d42@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721_dma.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-delete-an-error-message-for-a-failed-memory-allocation-in-tsi721_alloc_chan_resources drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-delete-an-error-message-for-a-failed-memory-allocation-in-tsi721_alloc_chan_resources
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -754,9 +754,6 @@ static int tsi721_alloc_chan_resources(s
 	desc = kcalloc(dma_txqueue_sz, sizeof(struct tsi721_tx_desc),
 			GFP_ATOMIC);
 	if (!desc) {
-		tsi_err(&dchan->dev->device,
-			"DMAC%d Failed to allocate logical descriptors",
-			bdma_chan->id);
 		tsi721_bdma_ch_free(bdma_chan);
 		return -ENOMEM;
 	}
_

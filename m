From: akpm@linux-foundation.org
Subject: [patch 071/114] drivers/rapidio/devices/tsi721_dma.c:
 delete an unnecessary variable initialisation in
 tsi721_alloc_chan_resources()
Date: Tue, 06 Feb 2018 15:40:10 -0800
Message-ID: <20180206234010.Gi-bGiqms%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55384 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932090AbeBFXkL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:40:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexandre.bounine@idt.com, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, mporter@kernel.crashing.org, torvalds@linux-foundation.org

From: Markus Elfring <elfring@users.sourceforge.net>
Subject: drivers/rapidio/devices/tsi721_dma.c: delete an unnecessary variable initialisation in tsi721_alloc_chan_resources()

The local variable "desc" will eventually be set to an appropriate pointer
a bit later. Thus omit the explicit initialisation at the beginning.

Link: http://lkml.kernel.org/r/728d8e20-4ae9-d661-d932-2d99ce67e71f@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-delete-an-unnecessary-variable-initialisation-in-tsi721_alloc_chan_resources drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-delete-an-unnecessary-variable-initialisation-in-tsi721_alloc_chan_resources
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -735,7 +735,7 @@ static dma_cookie_t tsi721_tx_submit(str
 static int tsi721_alloc_chan_resources(struct dma_chan *dchan)
 {
 	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
-	struct tsi721_tx_desc *desc = NULL;
+	struct tsi721_tx_desc *desc;
 	int i;
 
 	tsi_debug(DMA, &dchan->dev->device, "DMAC%d", bdma_chan->id);
_

From: akpm@linux-foundation.org
Subject: [patch 095/111] rapidio/tsi721_dma: advance queue processing from transfer submit call
Date: Tue, 02 Aug 2016 14:06:46 -0700
Message-ID: <57a10b66./urLF5kkhunILY75%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbcHBVmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:42:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org

From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721_dma: advance queue processing from transfer submit call

Add advancing transfer queue immediately from transfer submit call.  DMA
performance improvement: This will start transfer without waiting for
'issue_pending' command if there is no DMA transfer in progress.

Link: http://lkml.kernel.org/r/1469125134-16523-8-git-send-email-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721_dma.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-advance-queue-processing-from-transfer-submit-call drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-advance-queue-processing-from-transfer-submit-call
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -726,6 +726,7 @@ static dma_cookie_t tsi721_tx_submit(str
 	cookie = dma_cookie_assign(txd);
 	desc->status = DMA_IN_PROGRESS;
 	list_add_tail(&desc->desc_node, &bdma_chan->queue);
+	tsi721_advance_work(bdma_chan, NULL);
 
 	spin_unlock_bh(&bdma_chan->lock);
 	return cookie;
_

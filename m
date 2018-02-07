From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?rapidio-tsi721=5Fdma-delete-an-error-message-for-a-failed-me?=
 =?US-ASCII?Q?mory-allocation-in-tsi721=5Falloc=5Fchan=5Fresources.patch?=
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:58:39 -0800
Message-ID: <20180207195839.T1jF9o3Yn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60048 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754494AbeBGT6k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:58:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, mporter@kernel.crashing.org


The patch titled
     Subject: drivers/rapidio/devices/tsi721_dma.c: delete an error message for a failed memory allocation in tsi721_alloc_chan_resources()
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721_dma-delete-an-error-message-for-a-failed-memory-allocation-in-tsi721_alloc_chan_resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from elfring@users.sourceforge.net are



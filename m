From: akpm@linux-foundation.org
Subject: + rapidio-tsi721_dma-adjust-six-checks-for-null-pointers.patch
 added to -mm tree
Date: Fri, 22 Dec 2017 14:29:49 -0800
Message-ID: <5a3d875d.9Gr9zeFkEKUQmuhK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46766 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756725AbdLVW3u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Dec 2017 17:29:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, alexandre.bounine@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rapidio/devices/tsi721_dma.c: adjust six checks for null pointers
has been added to the -mm tree.  Its filename is
     rapidio-tsi721_dma-adjust-six-checks-for-null-pointers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721_dma-adjust-six-checks-for-null-pointers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721_dma-adjust-six-checks-for-null-pointers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
-	if (desc == NULL && bdma_chan->active_tx == NULL &&
-					!list_empty(&bdma_chan->queue)) {
+	if (!desc && !bdma_chan->active_tx && !list_empty(&bdma_chan->queue)) {
 		desc = list_first_entry(&bdma_chan->queue,
 					struct tsi721_tx_desc, desc_node);
 		list_del_init((&desc->desc_node));
@@ -796,7 +794,7 @@ static void tsi721_free_chan_resources(s
 
 	tsi_debug(DMA, &dchan->dev->device, "DMAC%d", bdma_chan->id);
 
-	if (bdma_chan->bd_base == NULL)
+	if (!bdma_chan->bd_base)
 		return;
 
 	tsi721_bdma_interrupt_enable(bdma_chan, 0);
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

rapidio-delete-an-error-message-for-a-failed-memory-allocation-in-rio_init_mports.patch
rapidio-adjust-12-checks-for-null-pointers.patch
rapidio-adjust-five-function-calls-together-with-a-variable-assignment.patch
rapidio-improve-a-size-determination-in-five-functions.patch
rapidio-delete-an-unnecessary-variable-initialisation-in-three-functions.patch
rapidio-return-an-error-code-only-as-a-constant-in-two-functions.patch
rapidio-move-12-export_symbol_gpl-calls-to-function-implementations.patch
rapidio-tsi721_dma-delete-an-error-message-for-a-failed-memory-allocation-in-tsi721_alloc_chan_resources.patch
rapidio-tsi721_dma-delete-an-unnecessary-variable-initialisation-in-tsi721_alloc_chan_resources.patch
rapidio-tsi721_dma-adjust-six-checks-for-null-pointers.patch


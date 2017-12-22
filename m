From: akpm@linux-foundation.org
Subject: +
 rapidio-tsi721_dma-delete-an-unnecessary-variable-initialisation-in-tsi721_alloc_chan_resources.patch added to -mm tree
Date: Fri, 22 Dec 2017 14:29:47 -0800
Message-ID: <5a3d875b.ITAUDotNu/M3S+9t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46760 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756725AbdLVW3s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Dec 2017 17:29:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, alexandre.bounine@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rapidio/devices/tsi721_dma.c: delete an unnecessary variable initialisation in tsi721_alloc_chan_resources()
has been added to the -mm tree.  Its filename is
     rapidio-tsi721_dma-delete-an-unnecessary-variable-initialisation-in-tsi721_alloc_chan_resources.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721_dma-delete-an-unnecessary-variable-initialisation-in-tsi721_alloc_chan_resources.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721_dma-delete-an-unnecessary-variable-initialisation-in-tsi721_alloc_chan_resources.patch

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


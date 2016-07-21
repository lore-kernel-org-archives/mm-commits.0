From: akpm@linux-foundation.org
Subject: +
 rapidio-tsi721_dma-advance-queue-processing-from-transfer-submit-call.patch added to -mm tree
Date: Thu, 21 Jul 2016 11:40:28 -0700
Message-ID: <5791171c.9D9gEm2yytxVc2x/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbcGUSk3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jul 2016 14:40:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721_dma: advance queue processing from transfer submit call
has been added to the -mm tree.  Its filename is
     rapidio-tsi721_dma-advance-queue-processing-from-transfer-submit-call.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721_dma-advance-queue-processing-from-transfer-submit-call.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721_dma-advance-queue-processing-from-transfer-submit-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-rapidio-channelized-messaging-driver.patch
rapidio-documentation-fix-mangled-paragraph-in-mport_cdev.patch
rapidio-fix-return-value-description-for-dma_prep-functions.patch
rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters.patch
rapidio-tsi721-add-pcie-mrrs-override-parameter.patch
rapidio-tsi721-add-messaging-mbox-selector-parameter.patch
rapidio-tsi721_dma-advance-queue-processing-from-transfer-submit-call.patch
rapidio-fix-error-handling-in-mbox-request-release-functions.patch
rapidio-idt_gen2-fix-locking-warning.patch
rapidio-change-inbound-window-size-type-to-u64.patch
rapidio-modify-for-rev3-specification-changes.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch
rapidio-switches-add-driver-for-idt-gen3-switches.patch


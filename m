From: akpm@linux-foundation.org
Subject: +
 rapidio-tsi721_dma-fix-failure-to-obtain-transaction-descriptor.patch added to -mm tree
Date: Thu, 24 Jul 2014 16:05:28 -0700
Message-ID: <53d19138.fInj0n3fokFRW5OQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:34840 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934747AbaGXXF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 19:05:29 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so993076ieb.0
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 16:05:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, dan.j.williams@intel.com, mporter@kernel.crashing.org, stable@vger.kernel.org, stef.van.os@prodrive-technologies.com, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721_dma: fix failure to obtain transaction descriptor
has been added to the -mm tree.  Its filename is
     rapidio-tsi721_dma-fix-failure-to-obtain-transaction-descriptor.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721_dma-fix-failure-to-obtain-transaction-descriptor.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721_dma-fix-failure-to-obtain-transaction-descriptor.patch

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
Subject: rapidio/tsi721_dma: fix failure to obtain transaction descriptor

This is a bug fix for the situation when function tsi721_desc_get() fails
to obtain a free transaction descriptor.

The bug usually results in a memory access crash dump when data transfer
scatter-gather list has more entries than size of hardware buffer
descriptors ring.  This fix ensures that error is properly returned to a
caller instead of an invalid entry.

This patch is applicable to kernel versions starting from v3.5.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Stef van Os <stef.van.os@prodrive-technologies.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>	[3.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721_dma.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-fix-failure-to-obtain-transaction-descriptor drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721_dma-fix-failure-to-obtain-transaction-descriptor
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -287,6 +287,12 @@ struct tsi721_tx_desc *tsi721_desc_get(s
 			"desc %p not ACKed\n", tx_desc);
 	}
 
+	if (ret == NULL) {
+		dev_dbg(bdma_chan->dchan.device->dev,
+			"%s: unable to obtain tx descriptor\n", __func__);
+		goto err_out;
+	}
+
 	i = bdma_chan->wr_count_next % bdma_chan->bd_num;
 	if (i == bdma_chan->bd_num - 1) {
 		i = 0;
@@ -297,7 +303,7 @@ struct tsi721_tx_desc *tsi721_desc_get(s
 	tx_desc->txd.phys = bdma_chan->bd_phys +
 				i * sizeof(struct tsi721_dma_desc);
 	tx_desc->hw_desc = &((struct tsi721_dma_desc *)bdma_chan->bd_base)[i];

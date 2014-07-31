From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-tsi721_dma-fix-failure-to-obtain-transaction-descriptor.patch
 removed from -mm tree
Date: Thu, 31 Jul 2014 13:22:06 -0700
Message-ID: <53daa56e.bVVcVhetG5N7r42H%akpm__9546.59226486019$1406838144$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:58178 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaGaUWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jul 2014 16:22:07 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so596068pab.1
        for <mm-commits@vger.kernel.org>; Thu, 31 Jul 2014 13:22:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, dan.j.williams@intel.com, mporter@kernel.crashing.org, stable@vger.kernel.org, stef.van.os@prodrive-technologies.com, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721_dma: fix failure to obtain transaction descriptor
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721_dma-fix-failure-to-obtain-transaction-descriptor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

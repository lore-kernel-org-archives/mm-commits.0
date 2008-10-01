From: akpm@linux-foundation.org
Subject: - dmatest-properly-handle-duplicate-dma-channels.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:50:38 -0700
Message-ID: <200810012150.m91Locbf005858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753675AbYJAVuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: timur@freescale.com, dan.j.williams@intel.com, haavard.skinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     dmatest: properly handle duplicate DMA channels
has been removed from the -mm tree.  Its filename was
     dmatest-properly-handle-duplicate-dma-channels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmatest: properly handle duplicate DMA channels
From: Timur Tabi <timur@freescale.com>

Update the the dmatest driver so that it handles duplicate DMA channels
properly.

When a DMA client is notified of an available DMA channel, it must check
if it has already allocated resources for that channel.  If so, it should
return DMA_DUP.  This can happen, for example, if a DMA driver calls
dma_async_device_register() more than once.

Signed-off-by: Timur Tabi <timur@freescale.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmatest.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/dma/dmatest.c~dmatest-properly-handle-duplicate-dma-channels drivers/dma/dmatest.c
--- a/drivers/dma/dmatest.c~dmatest-properly-handle-duplicate-dma-channels
+++ a/drivers/dma/dmatest.c
@@ -325,6 +325,11 @@ static enum dma_state_client dmatest_add
 	struct dmatest_thread	*thread;
 	unsigned int		i;
 
+	/* Have we already been told about this channel? */
+	list_for_each_entry(dtc, &dmatest_channels, node)
+		if (dtc->chan == chan)
+			return DMA_DUP;
+
 	dtc = kmalloc(sizeof(struct dmatest_chan), GFP_ATOMIC);
 	if (!dtc) {
 		pr_warning("dmatest: No memory for %s\n", chan->dev.bus_id);
_

Patches currently in -mm which might be from timur@freescale.com are

origin.patch
git-powerpc.patch
git-async_tx.patch
git-sound.patch


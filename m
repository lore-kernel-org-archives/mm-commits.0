From: akpm@linux-foundation.org
Subject: [merged] atmel-mci-fix-initialization-of-dma-slave-data.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:16:52 -0800
Message-ID: <200902191916.n1JJGq5j016296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984AbZBSTRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:17:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, anemo@mba.ocn.ne.jp, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel-mci: fix initialization of dma slave data
has been removed from the -mm tree.  Its filename was
     atmel-mci-fix-initialization-of-dma-slave-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel-mci: fix initialization of dma slave data
From: Dan Williams <dan.j.williams@intel.com>

The conversion of atmel-mci to dma_request_channel missed the
initialization of the channel dma_slave information.  The filter_fn passed
to dma_request_channel is responsible for initializing the channel's
private data.  This implementation has the additional benefit of enabling
a generic client-channel data passing mechanism.

Reviewed-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmaengine.c      |    2 ++
 drivers/dma/dw_dmac.c        |    5 ++---
 drivers/dma/dw_dmac_regs.h   |    2 --
 drivers/mmc/host/atmel-mci.c |    5 +++--
 include/linux/dmaengine.h    |    2 ++
 5 files changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/dma/dmaengine.c~atmel-mci-fix-initialization-of-dma-slave-data drivers/dma/dmaengine.c
--- a/drivers/dma/dmaengine.c~atmel-mci-fix-initialization-of-dma-slave-data
+++ a/drivers/dma/dmaengine.c
@@ -518,6 +518,7 @@ struct dma_chan *__dma_request_channel(d
 				       dma_chan_name(chan), err);
 			else
 				break;
+			chan->private = NULL;
 			chan = NULL;
 		}
 	}
@@ -536,6 +537,7 @@ void dma_release_channel(struct dma_chan
 	WARN_ONCE(chan->client_count != 1,
 		  "chan reference count %d != 1\n", chan->client_count);
 	dma_chan_put(chan);
+	chan->private = NULL;
 	mutex_unlock(&dma_list_mutex);
 }
 EXPORT_SYMBOL_GPL(dma_release_channel);
diff -puN drivers/dma/dw_dmac.c~atmel-mci-fix-initialization-of-dma-slave-data drivers/dma/dw_dmac.c
--- a/drivers/dma/dw_dmac.c~atmel-mci-fix-initialization-of-dma-slave-data
+++ a/drivers/dma/dw_dmac.c
@@ -560,7 +560,7 @@ dwc_prep_slave_sg(struct dma_chan *chan,
 		unsigned long flags)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
-	struct dw_dma_slave	*dws = dwc->dws;
+	struct dw_dma_slave	*dws = chan->private;
 	struct dw_desc		*prev;
 	struct dw_desc		*first;
 	u32			ctllo;
@@ -790,7 +790,7 @@ static int dwc_alloc_chan_resources(stru
 	cfghi = DWC_CFGH_FIFO_MODE;
 	cfglo = 0;
 
-	dws = dwc->dws;
+	dws = chan->private;
 	if (dws) {
 		/*
 		 * We need controller-specific data to set up slave
@@ -866,7 +866,6 @@ static void dwc_free_chan_resources(stru
 	spin_lock_bh(&dwc->lock);
 	list_splice_init(&dwc->free_list, &list);
 	dwc->descs_allocated = 0;
-	dwc->dws = NULL;
 
 	/* Disable interrupts */
 	channel_clear_bit(dw, MASK.XFER, dwc->mask);
diff -puN drivers/dma/dw_dmac_regs.h~atmel-mci-fix-initialization-of-dma-slave-data drivers/dma/dw_dmac_regs.h
--- a/drivers/dma/dw_dmac_regs.h~atmel-mci-fix-initialization-of-dma-slave-data
+++ a/drivers/dma/dw_dmac_regs.h
@@ -139,8 +139,6 @@ struct dw_dma_chan {
 	struct list_head	queue;
 	struct list_head	free_list;
 
-	struct dw_dma_slave	*dws;
-
 	unsigned int		descs_allocated;
 };
 
diff -puN drivers/mmc/host/atmel-mci.c~atmel-mci-fix-initialization-of-dma-slave-data drivers/mmc/host/atmel-mci.c
--- a/drivers/mmc/host/atmel-mci.c~atmel-mci-fix-initialization-of-dma-slave-data
+++ a/drivers/mmc/host/atmel-mci.c
@@ -1548,9 +1548,10 @@ static bool filter(struct dma_chan *chan
 {
 	struct dw_dma_slave *dws = slave;
 
-	if (dws->dma_dev == chan->device->dev)
+	if (dws->dma_dev == chan->device->dev) {
+		chan->private = dws;
 		return true;
-	else
+	} else
 		return false;
 }
 #endif
diff -puN include/linux/dmaengine.h~atmel-mci-fix-initialization-of-dma-slave-data include/linux/dmaengine.h
--- a/include/linux/dmaengine.h~atmel-mci-fix-initialization-of-dma-slave-data
+++ a/include/linux/dmaengine.h
@@ -121,6 +121,7 @@ struct dma_chan_percpu {
  * @local: per-cpu pointer to a struct dma_chan_percpu
  * @client-count: how many clients are using this channel
  * @table_count: number of appearances in the mem-to-mem allocation table
+ * @private: private data for certain client-channel associations
  */
 struct dma_chan {
 	struct dma_device *device;
@@ -134,6 +135,7 @@ struct dma_chan {
 	struct dma_chan_percpu *local;
 	int client_count;
 	int table_count;
+	void *private;
 };
 
 /**
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
linux-next.patch


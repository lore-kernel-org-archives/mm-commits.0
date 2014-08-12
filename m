From: akpm@linux-foundation.org
Subject: [merged] rapidio-add-new-rapidio-dma-interface-routines.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:30 -0700
Message-ID: <53ea6dae.fM39Q9OA7XzJPRTp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:43326 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbaHLTkb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:31 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2670157pab.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, stef.van.os@prodrive-technologies.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: add new RapidIO DMA interface routines
has been removed from the -mm tree.  Its filename was
     rapidio-add-new-rapidio-dma-interface-routines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: add new RapidIO DMA interface routines

Resending because the original email was rejected by some gateways.

Add RapidIO DMA interface routines that directly use reference to the mport
device object and/or target device destination ID as parameters.
This allows to perform RapidIO DMA transfer requests by modules that do not
have an access to the RapidIO device list.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Stef van Os <stef.van.os@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c   |   66 +++++++++++++++++++++++++++-----------
 include/linux/rio_drv.h |    5 ++
 2 files changed, 52 insertions(+), 19 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-add-new-rapidio-dma-interface-routines drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-new-rapidio-dma-interface-routines
+++ a/drivers/rapidio/rio.c
@@ -1509,30 +1509,39 @@ EXPORT_SYMBOL_GPL(rio_route_clr_table);
 
 static bool rio_chan_filter(struct dma_chan *chan, void *arg)
 {
-	struct rio_dev *rdev = arg;
+	struct rio_mport *mport = arg;
 
 	/* Check that DMA device belongs to the right MPORT */
-	return (rdev->net->hport ==
-		container_of(chan->device, struct rio_mport, dma));
+	return mport == container_of(chan->device, struct rio_mport, dma);
 }
 
 /**
- * rio_request_dma - request RapidIO capable DMA channel that supports
- *   specified target RapidIO device.
- * @rdev: RIO device control structure
+ * rio_request_mport_dma - request RapidIO capable DMA channel associated
+ *   with specified local RapidIO mport device.
+ * @mport: RIO mport to perform DMA data transfers
  *
  * Returns pointer to allocated DMA channel or NULL if failed.
  */
-struct dma_chan *rio_request_dma(struct rio_dev *rdev)
+struct dma_chan *rio_request_mport_dma(struct rio_mport *mport)
 {
 	dma_cap_mask_t mask;
-	struct dma_chan *dchan;
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
-	dchan = dma_request_channel(mask, rio_chan_filter, rdev);
+	return dma_request_channel(mask, rio_chan_filter, mport);
+}
+EXPORT_SYMBOL_GPL(rio_request_mport_dma);
 
-	return dchan;
+/**
+ * rio_request_dma - request RapidIO capable DMA channel that supports
+ *   specified target RapidIO device.
+ * @rdev: RIO device associated with DMA transfer
+ *
+ * Returns pointer to allocated DMA channel or NULL if failed.
+ */
+struct dma_chan *rio_request_dma(struct rio_dev *rdev)
+{
+	return rio_request_mport_dma(rdev->net->hport);
 }
 EXPORT_SYMBOL_GPL(rio_request_dma);
 
@@ -1547,10 +1556,10 @@ void rio_release_dma(struct dma_chan *dc
 EXPORT_SYMBOL_GPL(rio_release_dma);
 
 /**
- * rio_dma_prep_slave_sg - RapidIO specific wrapper
+ * rio_dma_prep_xfer - RapidIO specific wrapper
  *   for device_prep_slave_sg callback defined by DMAENGINE.
- * @rdev: RIO device control structure
  * @dchan: DMA channel to configure
+ * @destid: target RapidIO device destination ID
  * @data: RIO specific data descriptor
  * @direction: DMA data transfer direction (TO or FROM the device)
  * @flags: dmaengine defined flags
@@ -1560,11 +1569,10 @@ EXPORT_SYMBOL_GPL(rio_release_dma);
  * target RIO device.
  * Returns pointer to DMA transaction descriptor or NULL if failed.
  */
-struct dma_async_tx_descriptor *rio_dma_prep_slave_sg(struct rio_dev *rdev,
-	struct dma_chan *dchan, struct rio_dma_data *data,
+struct dma_async_tx_descriptor *rio_dma_prep_xfer(struct dma_chan *dchan,
+	u16 destid, struct rio_dma_data *data,
 	enum dma_transfer_direction direction, unsigned long flags)
 {
-	struct dma_async_tx_descriptor *txd = NULL;
 	struct rio_dma_ext rio_ext;
 
 	if (dchan->device->device_prep_slave_sg == NULL) {
@@ -1572,15 +1580,35 @@ struct dma_async_tx_descriptor *rio_dma_
 		return NULL;
 	}
 
-	rio_ext.destid = rdev->destid;
+	rio_ext.destid = destid;
 	rio_ext.rio_addr_u = data->rio_addr_u;
 	rio_ext.rio_addr = data->rio_addr;
 	rio_ext.wr_type = data->wr_type;
 
-	txd = dmaengine_prep_rio_sg(dchan, data->sg, data->sg_len,
-					direction, flags, &rio_ext);
+	return dmaengine_prep_rio_sg(dchan, data->sg, data->sg_len,
+				     direction, flags, &rio_ext);
+}
+EXPORT_SYMBOL_GPL(rio_dma_prep_xfer);
 
-	return txd;
+/**
+ * rio_dma_prep_slave_sg - RapidIO specific wrapper
+ *   for device_prep_slave_sg callback defined by DMAENGINE.
+ * @rdev: RIO device control structure
+ * @dchan: DMA channel to configure
+ * @data: RIO specific data descriptor
+ * @direction: DMA data transfer direction (TO or FROM the device)
+ * @flags: dmaengine defined flags
+ *
+ * Initializes RapidIO capable DMA channel for the specified data transfer.
+ * Uses DMA channel private extension to pass information related to remote
+ * target RIO device.
+ * Returns pointer to DMA transaction descriptor or NULL if failed.
+ */
+struct dma_async_tx_descriptor *rio_dma_prep_slave_sg(struct rio_dev *rdev,
+	struct dma_chan *dchan, struct rio_dma_data *data,
+	enum dma_transfer_direction direction, unsigned long flags)
+{
+	return rio_dma_prep_xfer(dchan,	rdev->destid, data, direction, flags);
 }
 EXPORT_SYMBOL_GPL(rio_dma_prep_slave_sg);
 
diff -puN include/linux/rio_drv.h~rapidio-add-new-rapidio-dma-interface-routines include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~rapidio-add-new-rapidio-dma-interface-routines
+++ a/include/linux/rio_drv.h
@@ -384,11 +384,16 @@ void rio_dev_put(struct rio_dev *);
 
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
 extern struct dma_chan *rio_request_dma(struct rio_dev *rdev);
+extern struct dma_chan *rio_request_mport_dma(struct rio_mport *mport);
 extern void rio_release_dma(struct dma_chan *dchan);
 extern struct dma_async_tx_descriptor *rio_dma_prep_slave_sg(
 		struct rio_dev *rdev, struct dma_chan *dchan,
 		struct rio_dma_data *data,
 		enum dma_transfer_direction direction, unsigned long flags);
+extern struct dma_async_tx_descriptor *rio_dma_prep_xfer(
+		struct dma_chan *dchan,	u16 destid,
+		struct rio_dma_data *data,
+		enum dma_transfer_direction direction, unsigned long flags);
 #endif
 
 /**
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch


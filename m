From: akpm@linux-foundation.org
Subject: [merged] rapidio-add-dma-engine-support-for-rio-data-transfers.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:35:03 -0700
Message-ID: <20120601193503.D3340A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:42188 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933336Ab2FATfF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:35:05 -0400
Received: by vcbfl13 with SMTP id fl13so245573vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:35:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, dan.j.williams@intel.com, leoli@freescale.com, mporter@kernel.crashing.org, paul.gortmaker@windriver.com, vinod.koul@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: add DMA engine support for RIO data transfers
has been removed from the -mm tree.  Its filename was
     rapidio-add-dma-engine-support-for-rio-data-transfers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: add DMA engine support for RIO data transfers

Adds DMA Engine framework support into RapidIO subsystem.

Uses DMA Engine DMA_SLAVE interface to generate data transfers to/from
remote RapidIO target devices.

Introduces RapidIO-specific wrapper for prep_slave_sg() interface with an
extra parameter to pass target specific information.

Uses scatterlist to describe local data buffer.  Address flat data buffer
on a remote side.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/Kconfig   |   14 ++++++
 drivers/rapidio/rio.c     |   81 ++++++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h |   12 +++++
 include/linux/rio.h       |   47 ++++++++++++++++++++
 include/linux/rio_drv.h   |    9 ++++
 5 files changed, 163 insertions(+)

diff -puN drivers/rapidio/Kconfig~rapidio-add-dma-engine-support-for-rio-data-transfers drivers/rapidio/Kconfig
--- a/drivers/rapidio/Kconfig~rapidio-add-dma-engine-support-for-rio-data-transfers
+++ a/drivers/rapidio/Kconfig
@@ -22,6 +22,20 @@ config RAPIDIO_ENABLE_RX_TX_PORTS
 	  ports for Input/Output direction to allow other traffic
 	  than Maintenance transfers.
 
+config RAPIDIO_DMA_ENGINE
+	bool "DMA Engine support for RapidIO"
+	depends on RAPIDIO
+	select DMADEVICES
+	select DMA_ENGINE
+	help
+	  Say Y here if you want to use DMA Engine frameork for RapidIO data
+	  transfers to/from target RIO devices. RapidIO uses NREAD and
+	  NWRITE (NWRITE_R, SWRITE) requests to transfer data between local
+	  memory and memory on remote target device. You need a DMA controller
+	  capable to perform data transfers to/from RapidIO.
+
+	  If you are unsure about this, say Y here.
+
 config RAPIDIO_DEBUG
 	bool "RapidIO subsystem debug messages"
 	depends on RAPIDIO
diff -puN drivers/rapidio/rio.c~rapidio-add-dma-engine-support-for-rio-data-transfers drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-dma-engine-support-for-rio-data-transfers
+++ a/drivers/rapidio/rio.c
@@ -1121,6 +1121,87 @@ int rio_std_route_clr_table(struct rio_m
 	return 0;
 }
 
+#ifdef CONFIG_RAPIDIO_DMA_ENGINE
+
+static bool rio_chan_filter(struct dma_chan *chan, void *arg)
+{
+	struct rio_dev *rdev = arg;
+
+	/* Check that DMA device belongs to the right MPORT */
+	return (rdev->net->hport ==
+		container_of(chan->device, struct rio_mport, dma));
+}
+
+/**
+ * rio_request_dma - request RapidIO capable DMA channel that supports
+ *   specified target RapidIO device.
+ * @rdev: RIO device control structure
+ *
+ * Returns pointer to allocated DMA channel or NULL if failed.
+ */
+struct dma_chan *rio_request_dma(struct rio_dev *rdev)
+{
+	dma_cap_mask_t mask;
+	struct dma_chan *dchan;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	dchan = dma_request_channel(mask, rio_chan_filter, rdev);
+
+	return dchan;
+}
+EXPORT_SYMBOL_GPL(rio_request_dma);
+
+/**
+ * rio_release_dma - release specified DMA channel
+ * @dchan: DMA channel to release
+ */
+void rio_release_dma(struct dma_chan *dchan)
+{
+	dma_release_channel(dchan);
+}
+EXPORT_SYMBOL_GPL(rio_release_dma);
+
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
+	struct dma_async_tx_descriptor *txd = NULL;
+	struct rio_dma_ext rio_ext;
+
+	if (dchan->device->device_prep_slave_sg == NULL) {
+		pr_err("%s: prep_rio_sg == NULL\n", __func__);
+		return NULL;
+	}
+
+	rio_ext.destid = rdev->destid;
+	rio_ext.rio_addr_u = data->rio_addr_u;
+	rio_ext.rio_addr = data->rio_addr;
+	rio_ext.wr_type = data->wr_type;
+
+	txd = dmaengine_prep_rio_sg(dchan, data->sg, data->sg_len,
+					direction, flags, &rio_ext);
+
+	return txd;
+}
+EXPORT_SYMBOL_GPL(rio_dma_prep_slave_sg);
+
+#endif /* CONFIG_RAPIDIO_DMA_ENGINE */
+
 static void rio_fixup_device(struct rio_dev *dev)
 {
 }
diff -puN include/linux/dmaengine.h~rapidio-add-dma-engine-support-for-rio-data-transfers include/linux/dmaengine.h
--- a/include/linux/dmaengine.h~rapidio-add-dma-engine-support-for-rio-data-transfers
+++ a/include/linux/dmaengine.h
@@ -635,6 +635,18 @@ static inline struct dma_async_tx_descri
 						  dir, flags, NULL);
 }
 
+#ifdef CONFIG_RAPIDIO_DMA_ENGINE
+struct rio_dma_ext;
+static inline struct dma_async_tx_descriptor *dmaengine_prep_rio_sg(
+	struct dma_chan *chan, struct scatterlist *sgl,	unsigned int sg_len,
+	enum dma_transfer_direction dir, unsigned long flags,
+	struct rio_dma_ext *rio_ext)
+{
+	return chan->device->device_prep_slave_sg(chan, sgl, sg_len,
+						  dir, flags, rio_ext);
+}
+#endif
+
 static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
 		size_t period_len, enum dma_transfer_direction dir)
diff -puN include/linux/rio.h~rapidio-add-dma-engine-support-for-rio-data-transfers include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-dma-engine-support-for-rio-data-transfers
+++ a/include/linux/rio.h
@@ -20,6 +20,9 @@
 #include <linux/errno.h>
 #include <linux/device.h>
 #include <linux/rio_regs.h>
+#ifdef CONFIG_RAPIDIO_DMA_ENGINE
+#include <linux/dmaengine.h>
+#endif
 
 #define RIO_NO_HOPCOUNT		-1
 #define RIO_INVALID_DESTID	0xffff
@@ -254,6 +257,9 @@ struct rio_mport {
 	u32 phys_efptr;
 	unsigned char name[40];
 	void *priv;		/* Master port private data */
+#ifdef CONFIG_RAPIDIO_DMA_ENGINE
+	struct dma_device	dma;
+#endif
 };
 
 /**
@@ -395,6 +401,47 @@ union rio_pw_msg {
 	u32 raw[RIO_PW_MSG_SIZE/sizeof(u32)];
 };
 
+#ifdef CONFIG_RAPIDIO_DMA_ENGINE
+
+/**
+ * enum rio_write_type - RIO write transaction types used in DMA transfers
+ *
+ * Note: RapidIO specification defines write (NWRITE) and
+ * write-with-response (NWRITE_R) data transfer operations.
+ * Existing DMA controllers that service RapidIO may use one of these operations
+ * for entire data transfer or their combination with only the last data packet
+ * requires response.
+ */
+enum rio_write_type {
+	RDW_DEFAULT,		/* default method used by DMA driver */
+	RDW_ALL_NWRITE,		/* all packets use NWRITE */
+	RDW_ALL_NWRITE_R,	/* all packets use NWRITE_R */
+	RDW_LAST_NWRITE_R,	/* last packet uses NWRITE_R, others - NWRITE */
+};
+
+struct rio_dma_ext {
+	u16 destid;
+	u64 rio_addr;	/* low 64-bits of 66-bit RapidIO address */
+	u8  rio_addr_u;  /* upper 2-bits of 66-bit RapidIO address */
+	enum rio_write_type wr_type; /* preferred RIO write operation type */
+};
+
+struct rio_dma_data {
+	/* Local data (as scatterlist) */
+	struct scatterlist	*sg;	/* I/O scatter list */
+	unsigned int		sg_len;	/* size of scatter list */
+	/* Remote device address (flat buffer) */
+	u64 rio_addr;	/* low 64-bits of 66-bit RapidIO address */
+	u8  rio_addr_u;  /* upper 2-bits of 66-bit RapidIO address */
+	enum rio_write_type wr_type; /* preferred RIO write operation type */
+};
+
+static inline struct rio_mport *dma_to_mport(struct dma_device *ddev)
+{
+	return container_of(ddev, struct rio_mport, dma);
+}
+#endif /* CONFIG_RAPIDIO_DMA_ENGINE */
+
 /* Architecture and hardware-specific functions */
 extern int rio_register_mport(struct rio_mport *);
 extern int rio_open_inb_mbox(struct rio_mport *, void *, int, int);
diff -puN include/linux/rio_drv.h~rapidio-add-dma-engine-support-for-rio-data-transfers include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~rapidio-add-dma-engine-support-for-rio-data-transfers
+++ a/include/linux/rio_drv.h
@@ -377,6 +377,15 @@ void rio_unregister_driver(struct rio_dr
 struct rio_dev *rio_dev_get(struct rio_dev *);
 void rio_dev_put(struct rio_dev *);
 
+#ifdef CONFIG_RAPIDIO_DMA_ENGINE
+extern struct dma_chan *rio_request_dma(struct rio_dev *rdev);
+extern void rio_release_dma(struct dma_chan *dchan);
+extern struct dma_async_tx_descriptor *rio_dma_prep_slave_sg(
+		struct rio_dev *rdev, struct dma_chan *dchan,
+		struct rio_dma_data *data,
+		enum dma_transfer_direction direction, unsigned long flags);
+#endif
+
 /**
  * rio_name - Get the unique RIO device identifier
  * @rdev: RIO device
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch
rapidio-tsi721-add-dma-engine-support.patch


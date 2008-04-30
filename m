From: akpm@linux-foundation.org
Subject: - rapidio-change-rio-function-mpc85xx_-to-fsl_.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:51:03 -0700
Message-ID: <200804300551.m3U5p3Dx030186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759219AbYD3FvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:51:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: change RIO function mpc85xx_ to fsl_
has been removed from the -mm tree.  Its filename was
     rapidio-change-rio-function-mpc85xx_-to-fsl_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: change RIO function mpc85xx_ to fsl_
From: Zhang Wei <wei.zhang@freescale.com>

The driver is also fit for Freescale MPC8641 processor.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |   80 ++++++++++++++++----------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-change-rio-function-mpc85xx_-to-fsl_ arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-change-rio-function-mpc85xx_-to-fsl_
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -1,5 +1,5 @@
 /*
- * MPC85xx RapidIO support
+ * Freescale MPC85xx/MPC86xx RapidIO support
  *
  * Copyright 2005 MontaVista Software, Inc.
  * Matt Porter <mporter@kernel.crashing.org>
@@ -145,7 +145,7 @@ static struct rio_msg_rx_ring {
 } msg_rx_ring;
 
 /**
- * mpc85xx_rio_doorbell_send - Send a MPC85xx doorbell message
+ * fsl_rio_doorbell_send - Send a MPC85xx doorbell message
  * @index: ID of RapidIO interface
  * @destid: Destination ID of target device
  * @data: 16-bit info field of RapidIO doorbell message
@@ -153,9 +153,9 @@ static struct rio_msg_rx_ring {
  * Sends a MPC85xx doorbell message. Returns %0 on success or
  * %-EINVAL on failure.
  */
-static int mpc85xx_rio_doorbell_send(int index, u16 destid, u16 data)
+static int fsl_rio_doorbell_send(int index, u16 destid, u16 data)
 {
-	pr_debug("mpc85xx_doorbell_send: index %d destid %4.4x data %4.4x\n",
+	pr_debug("fsl_doorbell_send: index %d destid %4.4x data %4.4x\n",
 		 index, destid, data);
 	out_be32((void *)&dbell_atmu_regs->rowtar, destid << 22);
 	out_be16((void *)(dbell_win), data);
@@ -164,7 +164,7 @@ static int mpc85xx_rio_doorbell_send(int
 }
 
 /**
- * mpc85xx_local_config_read - Generate a MPC85xx local config space read
+ * fsl_local_config_read - Generate a MPC85xx local config space read
  * @index: ID of RapdiIO interface
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
@@ -173,9 +173,9 @@ static int mpc85xx_rio_doorbell_send(int
  * Generates a MPC85xx local configuration space read. Returns %0 on
  * success or %-EINVAL on failure.
  */
-static int mpc85xx_local_config_read(int index, u32 offset, int len, u32 * data)
+static int fsl_local_config_read(int index, u32 offset, int len, u32 *data)
 {
-	pr_debug("mpc85xx_local_config_read: index %d offset %8.8x\n", index,
+	pr_debug("fsl_local_config_read: index %d offset %8.8x\n", index,
 		 offset);
 	*data = in_be32((void *)(regs_win + offset));
 
@@ -183,7 +183,7 @@ static int mpc85xx_local_config_read(int
 }
 
 /**
- * mpc85xx_local_config_write - Generate a MPC85xx local config space write
+ * fsl_local_config_write - Generate a MPC85xx local config space write
  * @index: ID of RapdiIO interface
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
@@ -192,10 +192,10 @@ static int mpc85xx_local_config_read(int
  * Generates a MPC85xx local configuration space write. Returns %0 on
  * success or %-EINVAL on failure.
  */
-static int mpc85xx_local_config_write(int index, u32 offset, int len, u32 data)
+static int fsl_local_config_write(int index, u32 offset, int len, u32 data)
 {
 	pr_debug
-	    ("mpc85xx_local_config_write: index %d offset %8.8x data %8.8x\n",
+	    ("fsl_local_config_write: index %d offset %8.8x data %8.8x\n",
 	     index, offset, data);
 	out_be32((void *)(regs_win + offset), data);
 
@@ -203,7 +203,7 @@ static int mpc85xx_local_config_write(in
 }
 
 /**
- * mpc85xx_rio_config_read - Generate a MPC85xx read maintenance transaction
+ * fsl_rio_config_read - Generate a MPC85xx read maintenance transaction
  * @index: ID of RapdiIO interface
  * @destid: Destination ID of transaction
  * @hopcount: Number of hops to target device
@@ -215,13 +215,13 @@ static int mpc85xx_local_config_write(in
  * success or %-EINVAL on failure.
  */
 static int
-mpc85xx_rio_config_read(int index, u16 destid, u8 hopcount, u32 offset, int len,
+fsl_rio_config_read(int index, u16 destid, u8 hopcount, u32 offset, int len,
 			u32 * val)
 {
 	u8 *data;
 
 	pr_debug
-	    ("mpc85xx_rio_config_read: index %d destid %d hopcount %d offset %8.8x len %d\n",
+	    ("fsl_rio_config_read: index %d destid %d hopcount %d offset %8.8x len %d\n",
 	     index, destid, hopcount, offset, len);
 	out_be32((void *)&maint_atmu_regs->rowtar,
 		 (destid << 22) | (hopcount << 12) | ((offset & ~0x3) >> 9));
@@ -243,7 +243,7 @@ mpc85xx_rio_config_read(int index, u16 d
 }
 
 /**
- * mpc85xx_rio_config_write - Generate a MPC85xx write maintenance transaction
+ * fsl_rio_config_write - Generate a MPC85xx write maintenance transaction
  * @index: ID of RapdiIO interface
  * @destid: Destination ID of transaction
  * @hopcount: Number of hops to target device
@@ -255,12 +255,12 @@ mpc85xx_rio_config_read(int index, u16 d
  * success or %-EINVAL on failure.
  */
 static int
-mpc85xx_rio_config_write(int index, u16 destid, u8 hopcount, u32 offset,
+fsl_rio_config_write(int index, u16 destid, u8 hopcount, u32 offset,
 			 int len, u32 val)
 {
 	u8 *data;
 	pr_debug
-	    ("mpc85xx_rio_config_write: index %d destid %d hopcount %d offset %8.8x len %d val %8.8x\n",
+	    ("fsl_rio_config_write: index %d destid %d hopcount %d offset %8.8x len %d val %8.8x\n",
 	     index, destid, hopcount, offset, len, val);
 	out_be32((void *)&maint_atmu_regs->rowtar,
 		 (destid << 22) | (hopcount << 12) | ((offset & ~0x3) >> 9));
@@ -344,7 +344,7 @@ rio_hw_add_outb_message(struct rio_mport
 EXPORT_SYMBOL_GPL(rio_hw_add_outb_message);
 
 /**
- * mpc85xx_rio_tx_handler - MPC85xx outbound message interrupt handler
+ * fsl_rio_tx_handler - MPC85xx outbound message interrupt handler
  * @irq: Linux interrupt number
  * @dev_instance: Pointer to interrupt-specific data
  *
@@ -352,7 +352,7 @@ EXPORT_SYMBOL_GPL(rio_hw_add_outb_messag
  * mailbox event handler and acks the interrupt occurrence.
  */
 static irqreturn_t
-mpc85xx_rio_tx_handler(int irq, void *dev_instance)
+fsl_rio_tx_handler(int irq, void *dev_instance)
 {
 	int osr;
 	struct rio_mport *port = (struct rio_mport *)dev_instance;
@@ -452,7 +452,7 @@ int rio_open_outb_mbox(struct rio_mport 
 
 	/* Hook up outbound message handler */
 	if ((rc =
-	     request_irq(MPC85xx_IRQ_RIO_TX, mpc85xx_rio_tx_handler, 0,
+	     request_irq(MPC85xx_IRQ_RIO_TX, fsl_rio_tx_handler, 0,
 			 "msg_tx", (void *)mport)) < 0)
 		goto out_irq;
 
@@ -511,7 +511,7 @@ void rio_close_outb_mbox(struct rio_mpor
 }
 
 /**
- * mpc85xx_rio_rx_handler - MPC85xx inbound message interrupt handler
+ * fsl_rio_rx_handler - MPC85xx inbound message interrupt handler
  * @irq: Linux interrupt number
  * @dev_instance: Pointer to interrupt-specific data
  *
@@ -519,7 +519,7 @@ void rio_close_outb_mbox(struct rio_mpor
  * mailbox event handler and acks the interrupt occurrence.
  */
 static irqreturn_t
-mpc85xx_rio_rx_handler(int irq, void *dev_instance)
+fsl_rio_rx_handler(int irq, void *dev_instance)
 {
 	int isr;
 	struct rio_mport *port = (struct rio_mport *)dev_instance;
@@ -597,7 +597,7 @@ int rio_open_inb_mbox(struct rio_mport *
 
 	/* Hook up inbound message handler */
 	if ((rc =
-	     request_irq(MPC85xx_IRQ_RIO_RX, mpc85xx_rio_rx_handler, 0,
+	     request_irq(MPC85xx_IRQ_RIO_RX, fsl_rio_rx_handler, 0,
 			 "msg_rx", (void *)mport)) < 0) {
 		dma_free_coherent(NULL, RIO_MSG_BUFFER_SIZE,
 				  msg_tx_ring.virt_buffer[i],
@@ -729,7 +729,7 @@ void *rio_hw_get_inb_message(struct rio_
 EXPORT_SYMBOL_GPL(rio_hw_get_inb_message);
 
 /**
- * mpc85xx_rio_dbell_handler - MPC85xx doorbell interrupt handler
+ * fsl_rio_dbell_handler - MPC85xx doorbell interrupt handler
  * @irq: Linux interrupt number
  * @dev_instance: Pointer to interrupt-specific data
  *
@@ -737,7 +737,7 @@ EXPORT_SYMBOL_GPL(rio_hw_get_inb_message
  * doorbell event handlers and executes a matching event handler.
  */
 static irqreturn_t
-mpc85xx_rio_dbell_handler(int irq, void *dev_instance)
+fsl_rio_dbell_handler(int irq, void *dev_instance)
 {
 	int dsr;
 	struct rio_mport *port = (struct rio_mport *)dev_instance;
@@ -794,14 +794,14 @@ mpc85xx_rio_dbell_handler(int irq, void 
 }
 
 /**
- * mpc85xx_rio_doorbell_init - MPC85xx doorbell interface init
+ * fsl_rio_doorbell_init - MPC85xx doorbell interface init
  * @mport: Master port implementing the inbound doorbell unit
  *
  * Initializes doorbell unit hardware and inbound DMA buffer
- * ring. Called from mpc85xx_rio_setup(). Returns %0 on success
+ * ring. Called from fsl_rio_setup(). Returns %0 on success
  * or %-ENOMEM on failure.
  */
-static int mpc85xx_rio_doorbell_init(struct rio_mport *mport)
+static int fsl_rio_doorbell_init(struct rio_mport *mport)
 {
 	int rc = 0;
 
@@ -835,7 +835,7 @@ static int mpc85xx_rio_doorbell_init(str
 
 	/* Hook up doorbell handler */
 	if ((rc =
-	     request_irq(MPC85xx_IRQ_RIO_BELL, mpc85xx_rio_dbell_handler, 0,
+	     request_irq(MPC85xx_IRQ_RIO_BELL, fsl_rio_dbell_handler, 0,
 			 "dbell_rx", (void *)mport) < 0)) {
 		iounmap((void *)dbell_win);
 		dma_free_coherent(NULL, 512 * DOORBELL_MESSAGE_SIZE,
@@ -854,7 +854,7 @@ static int mpc85xx_rio_doorbell_init(str
 
 static char *cmdline = NULL;
 
-static int mpc85xx_rio_get_hdid(int index)
+static int fsl_rio_get_hdid(int index)
 {
 	/* XXX Need to parse multiple entries in some format */
 	if (!cmdline)
@@ -863,7 +863,7 @@ static int mpc85xx_rio_get_hdid(int inde
 	return simple_strtol(cmdline, NULL, 0);
 }
 
-static int mpc85xx_rio_get_cmdline(char *s)
+static int fsl_rio_get_cmdline(char *s)
 {
 	if (!s)
 		return 0;
@@ -872,10 +872,10 @@ static int mpc85xx_rio_get_cmdline(char 
 	return 1;
 }
 
-__setup("riohdid=", mpc85xx_rio_get_cmdline);
+__setup("riohdid=", fsl_rio_get_cmdline);
 
 /**
- * mpc85xx_rio_setup - Setup MPC85xx RapidIO interface
+ * fsl_rio_setup - Setup MPC85xx RapidIO interface
  * @law_start: Starting physical address of RapidIO LAW
  * @law_size: Size of RapidIO LAW
  *
@@ -883,17 +883,17 @@ __setup("riohdid=", mpc85xx_rio_get_cmdl
  * master port with system-specific info, and registers the
  * master port with the RapidIO subsystem.
  */
-void mpc85xx_rio_setup(int law_start, int law_size)
+void fsl_rio_setup(int law_start, int law_size)
 {
 	struct rio_ops *ops;
 	struct rio_mport *port;
 
 	ops = kmalloc(sizeof(struct rio_ops), GFP_KERNEL);
-	ops->lcread = mpc85xx_local_config_read;
-	ops->lcwrite = mpc85xx_local_config_write;
-	ops->cread = mpc85xx_rio_config_read;
-	ops->cwrite = mpc85xx_rio_config_write;
-	ops->dsend = mpc85xx_rio_doorbell_send;
+	ops->lcread = fsl_local_config_read;
+	ops->lcwrite = fsl_local_config_write;
+	ops->cread = fsl_rio_config_read;
+	ops->cwrite = fsl_rio_config_write;
+	ops->dsend = fsl_rio_doorbell_send;
 
 	port = kmalloc(sizeof(struct rio_mport), GFP_KERNEL);
 	port->id = 0;
@@ -909,7 +909,7 @@ void mpc85xx_rio_setup(int law_start, in
 	strcpy(port->name, "RIO0 mport");
 
 	port->ops = ops;
-	port->host_deviceid = mpc85xx_rio_get_hdid(port->id);
+	port->host_deviceid = fsl_rio_get_hdid(port->id);
 
 	rio_register_mport(port);
 
@@ -928,5 +928,5 @@ void mpc85xx_rio_setup(int law_start, in
 	/* Configure outbound doorbell window */
 	out_be32((void *)&dbell_atmu_regs->rowbar, 0x000c0400);
 	out_be32((void *)&dbell_atmu_regs->rowar, 0x8004200b);
-	mpc85xx_rio_doorbell_init(port);
+	fsl_rio_doorbell_init(port);
 }
_

Patches currently in -mm which might be from wei.zhang@freescale.com are

origin.patch
rapidio-add-memory-mapping-driver-to-rapidio.patch
rapidio-add-rapidio-space-allocation-bitmap-arithmetic.patch
rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch
rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch
rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
rapidio-fix-docbook-references.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch


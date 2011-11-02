From: akpm@linux-foundation.org
Subject: [folded] rapidio-add-mport-driver-for-tsi721-bridge-update.patch removed from -mm tree
Date: Wed, 02 Nov 2011 13:17:55 -0700
Message-ID: <201111022017.pA2KHuO3030266@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:58029 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1KBUSe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2011 16:18:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, chul.kim@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: RapidIO: Tsi721 driver - fixes for the initial release
has been removed from the -mm tree.  Its filename was
     rapidio-add-mport-driver-for-tsi721-bridge-update.patch

This patch was dropped because it was folded into rapidio-add-mport-driver-for-tsi721-bridge.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: RapidIO: Tsi721 driver - fixes for the initial release

- address comments made by Andrew Morton,
  see http://marc.info/?l=linux-kernel&m=131361256714116&w=2
- add spinlock for IB_MSG handler
- rename private BDMA channel structure to avoid conflict with DMA engine
- fix endianess bug in outbound message interrupt handler

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Chul Kim <chul.kim@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/Kconfig  |    2 
 drivers/rapidio/devices/tsi721.c |  273 +++++++++++++++--------------
 drivers/rapidio/devices/tsi721.h |   20 +-
 3 files changed, 161 insertions(+), 134 deletions(-)

diff -puN drivers/rapidio/devices/Kconfig~rapidio-add-mport-driver-for-tsi721-bridge-update drivers/rapidio/devices/Kconfig
--- a/drivers/rapidio/devices/Kconfig~rapidio-add-mport-driver-for-tsi721-bridge-update
+++ a/drivers/rapidio/devices/Kconfig
@@ -4,7 +4,7 @@
 
 config RAPIDIO_TSI721
 	bool "IDT Tsi721 PCI Express SRIO Controller support"
-	depends on RAPIDIO && PCI && PCIEPORTBUS
+	depends on RAPIDIO && PCIEPORTBUS
 	default "n"
 	---help---
 	  Include support for IDT Tsi721 PCI Express Serial RapidIO controller.
diff -puN drivers/rapidio/devices/tsi721.c~rapidio-add-mport-driver-for-tsi721-bridge-update drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-add-mport-driver-for-tsi721-bridge-update
+++ a/drivers/rapidio/devices/tsi721.c
@@ -136,21 +136,20 @@ static int tsi721_maint_dma(struct tsi72
 	/* Start DMA operation */
 	iowrite32(rd_count + 2,
 		priv->regs + TSI721_DMAC_DWRCNT(TSI721_DMACH_MAINT));
-	(void)ioread32(priv->regs + TSI721_DMAC_DWRCNT(TSI721_DMACH_MAINT));
+	ioread32(priv->regs + TSI721_DMAC_DWRCNT(TSI721_DMACH_MAINT));
 	i = 0;
 
 	/* Wait until DMA transfer is finished */
 	while ((ch_stat = ioread32(priv->regs +
 		TSI721_DMAC_STS(TSI721_DMACH_MAINT))) & TSI721_DMAC_STS_RUN) {
-		udelay(10);
-		i++;
-		if (i >= 5000000) {
+		udelay(1);
+		if (++i >= 5000000) {
 			dev_dbg(&priv->pdev->dev,
 				"%s : DMA[%d] read timeout ch_status=%x\n",
 				__func__, TSI721_DMACH_MAINT, ch_stat);
 			if (!do_wr)
 				*data = 0xffffffff;
-			err = -EFAULT;
+			err = -EIO;
 			goto err_out;
 		}
 	}
@@ -173,7 +172,7 @@ static int tsi721_maint_dma(struct tsi72
 		udelay(1);
 		if (!do_wr)
 			*data = 0xffffffff;
-		err = -EFAULT;
+		err = -EIO;
 		goto err_out;
 	}
 
@@ -288,18 +287,15 @@ static void tsi721_pw_dpc(struct work_st
 {
 	struct tsi721_device *priv = container_of(work, struct tsi721_device,
 						    pw_work);
-	unsigned long flags;
 	u32 msg_buffer[RIO_PW_MSG_SIZE/sizeof(u32)]; /* Use full size PW message
 							buffer for RIO layer */
 
 	/*
 	 * Process port-write messages
 	 */
-	spin_lock_irqsave(&priv->pw_fifo_lock, flags);
-	while (kfifo_out(&priv->pw_fifo, (unsigned char *)msg_buffer,
-			 TSI721_RIO_PW_MSG_SIZE)) {
+	while (kfifo_out_spinlocked(&priv->pw_fifo, (unsigned char *)msg_buffer,
+			 TSI721_RIO_PW_MSG_SIZE, &priv->pw_fifo_lock)) {
 		/* Process one message */
-		spin_unlock_irqrestore(&priv->pw_fifo_lock, flags);
 #ifdef DEBUG_PW
 		{
 		u32 i;
@@ -315,9 +311,7 @@ static void tsi721_pw_dpc(struct work_st
 #endif
 		/* Pass the port-write message to RIO core for processing */
 		rio_inb_pwrite_handler((union rio_pw_msg *)msg_buffer);
-		spin_lock_irqsave(&priv->pw_fifo_lock, flags);
 	}
-	spin_unlock_irqrestore(&priv->pw_fifo_lock, flags);
 }
 
 /**
@@ -457,87 +451,6 @@ static void tsi721_db_dpc(struct work_st
 }
 
 /**
- * tsi721_srio_msix - Tsi721 MSI-X SRIO MAC interrupt handler
- * @irq: Linux interrupt number
- * @ptr: Pointer to interrupt-specific data (mport structure)
- *
- * Handles Tsi721 interrupts from SRIO MAC.
- */
-static irqreturn_t tsi721_srio_msix(int irq, void *ptr)
-{
-	struct tsi721_device *priv = ((struct rio_mport *)ptr)->priv;
-	u32 srio_int;
-
-	/* Service SRIO MAC interrupts */
-	srio_int = ioread32(priv->regs + TSI721_RIO_EM_INT_STAT);
-	if (srio_int & TSI721_RIO_EM_INT_STAT_PW_RX)
-		tsi721_pw_handler((struct rio_mport *)ptr);
-
-	return IRQ_HANDLED;
-}
-
-/**
- * tsi721_sr2pc_ch_msix - Tsi721 MSI-X SR2PC Channel interrupt handler
- * @irq: Linux interrupt number
- * @ptr: Pointer to interrupt-specific data (mport structure)
- *
- * Handles Tsi721 interrupts from SR2PC Channel.
- * NOTE: At this moment services only one SR2PC channel associated with inbound
- * doorbells.
- */
-static irqreturn_t tsi721_sr2pc_ch_msix(int irq, void *ptr)
-{
-	struct tsi721_device *priv = ((struct rio_mport *)ptr)->priv;
-	u32 sr_ch_int;
-
-	/* Service Inbound DB interrupt from SR2PC channel */
-	sr_ch_int = ioread32(priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
-	if (sr_ch_int & TSI721_SR_CHINT_IDBQRCV)
-		tsi721_dbell_handler((struct rio_mport *)ptr);
-
-	/* Clear interrupts */
-	iowrite32(sr_ch_int, priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
-	/* Read back to ensure that interrupt was cleared */
-	sr_ch_int = ioread32(priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
-
-	return IRQ_HANDLED;
-}
-
-/**
- * tsi721_omsg_msix - MSI-X interrupt handler for outbound messaging
- * @irq: Linux interrupt number
- * @ptr: Pointer to interrupt-specific data (mport structure)
- *
- * Handles outbound messaging interrupts signaled using MSI-X.
- */
-static irqreturn_t tsi721_omsg_msix(int irq, void *ptr)
-{
-	struct tsi721_device *priv = ((struct rio_mport *)ptr)->priv;
-	int mbox;
-
-	mbox = (irq - priv->msix[TSI721_VECT_OMB0_DONE].vector) % RIO_MAX_MBOX;
-	tsi721_omsg_handler(priv, mbox);
-	return IRQ_HANDLED;
-}
-
-/**
- * tsi721_imsg_msix - MSI-X interrupt handler for inbound messaging
- * @irq: Linux interrupt number
- * @ptr: Pointer to interrupt-specific data (mport structure)
- *
- * Handles inbound messaging interrupts signaled using MSI-X.
- */
-static irqreturn_t tsi721_imsg_msix(int irq, void *ptr)
-{
-	struct tsi721_device *priv = ((struct rio_mport *)ptr)->priv;
-	int mbox;
-
-	mbox = (irq - priv->msix[TSI721_VECT_IMB0_RCV].vector) % RIO_MAX_MBOX;
-	tsi721_imsg_handler(priv, mbox + 4);
-	return IRQ_HANDLED;
-}
-
-/**
  * tsi721_irqhandler - Tsi721 interrupt handler
  * @irq: Linux interrupt number
  * @ptr: Pointer to interrupt-specific data (mport structure)
@@ -575,7 +488,7 @@ static irqreturn_t tsi721_irqhandler(int
 			/* Clear interrupts */
 			iowrite32(intval,
 				priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
-			(void)ioread32(priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
+			ioread32(priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
 		}
 	}
 
@@ -653,7 +566,89 @@ static void tsi721_interrupts_init(struc
 			TSI721_DEV_INT_SMSG_CH;
 
 	iowrite32(intr, priv->regs + TSI721_DEV_INTE);
-	(void)ioread32(priv->regs + TSI721_DEV_INTE);
+	ioread32(priv->regs + TSI721_DEV_INTE);
+}
+
+#ifdef CONFIG_PCI_MSI
+/**
+ * tsi721_omsg_msix - MSI-X interrupt handler for outbound messaging
+ * @irq: Linux interrupt number
+ * @ptr: Pointer to interrupt-specific data (mport structure)
+ *
+ * Handles outbound messaging interrupts signaled using MSI-X.
+ */
+static irqreturn_t tsi721_omsg_msix(int irq, void *ptr)
+{
+	struct tsi721_device *priv = ((struct rio_mport *)ptr)->priv;
+	int mbox;
+
+	mbox = (irq - priv->msix[TSI721_VECT_OMB0_DONE].vector) % RIO_MAX_MBOX;
+	tsi721_omsg_handler(priv, mbox);
+	return IRQ_HANDLED;
+}
+
+/**
+ * tsi721_imsg_msix - MSI-X interrupt handler for inbound messaging
+ * @irq: Linux interrupt number
+ * @ptr: Pointer to interrupt-specific data (mport structure)
+ *
+ * Handles inbound messaging interrupts signaled using MSI-X.
+ */
+static irqreturn_t tsi721_imsg_msix(int irq, void *ptr)
+{
+	struct tsi721_device *priv = ((struct rio_mport *)ptr)->priv;
+	int mbox;
+
+	mbox = (irq - priv->msix[TSI721_VECT_IMB0_RCV].vector) % RIO_MAX_MBOX;
+	tsi721_imsg_handler(priv, mbox + 4);
+	return IRQ_HANDLED;
+}
+
+/**
+ * tsi721_srio_msix - Tsi721 MSI-X SRIO MAC interrupt handler
+ * @irq: Linux interrupt number
+ * @ptr: Pointer to interrupt-specific data (mport structure)
+ *
+ * Handles Tsi721 interrupts from SRIO MAC.
+ */
+static irqreturn_t tsi721_srio_msix(int irq, void *ptr)
+{
+	struct tsi721_device *priv = ((struct rio_mport *)ptr)->priv;
+	u32 srio_int;
+
+	/* Service SRIO MAC interrupts */
+	srio_int = ioread32(priv->regs + TSI721_RIO_EM_INT_STAT);
+	if (srio_int & TSI721_RIO_EM_INT_STAT_PW_RX)
+		tsi721_pw_handler((struct rio_mport *)ptr);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * tsi721_sr2pc_ch_msix - Tsi721 MSI-X SR2PC Channel interrupt handler
+ * @irq: Linux interrupt number
+ * @ptr: Pointer to interrupt-specific data (mport structure)
+ *
+ * Handles Tsi721 interrupts from SR2PC Channel.
+ * NOTE: At this moment services only one SR2PC channel associated with inbound
+ * doorbells.
+ */
+static irqreturn_t tsi721_sr2pc_ch_msix(int irq, void *ptr)
+{
+	struct tsi721_device *priv = ((struct rio_mport *)ptr)->priv;
+	u32 sr_ch_int;
+
+	/* Service Inbound DB interrupt from SR2PC channel */
+	sr_ch_int = ioread32(priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
+	if (sr_ch_int & TSI721_SR_CHINT_IDBQRCV)
+		tsi721_dbell_handler((struct rio_mport *)ptr);
+
+	/* Clear interrupts */
+	iowrite32(sr_ch_int, priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
+	/* Read back to ensure that interrupt was cleared */
+	sr_ch_int = ioread32(priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
+
+	return IRQ_HANDLED;
 }
 
 /**
@@ -678,26 +673,11 @@ static int tsi721_request_msix(struct ri
 	err = request_irq(priv->msix[TSI721_VECT_PWRX].vector,
 			tsi721_srio_msix, 0,
 			priv->msix[TSI721_VECT_PWRX].irq_name, (void *)mport);
-out:
-	return err;
-}
-
-static int tsi721_request_irq(struct rio_mport *mport)
-{
-	struct tsi721_device *priv = mport->priv;
-	int err;
-
-	if (priv->flags & TSI721_USING_MSIX)
-		err = tsi721_request_msix(mport);
-	else
-		err = request_irq(priv->pdev->irq, tsi721_irqhandler,
-			  (priv->flags & TSI721_USING_MSI) ? 0 : IRQF_SHARED,
-			  DRV_NAME, (void *)mport);
-
 	if (err)
-		dev_err(&priv->pdev->dev,
-			"Unable to allocate interrupt, Error: %d\n", err);
-
+		free_irq(
+			priv->msix[TSI721_VECT_IDB].vector,
+			(void *)mport);
+out:
 	return err;
 }
 
@@ -781,6 +761,28 @@ static int tsi721_enable_msix(struct tsi
 
 	return 0;
 }
+#endif /* CONFIG_PCI_MSI */
+
+static int tsi721_request_irq(struct rio_mport *mport)
+{
+	struct tsi721_device *priv = mport->priv;
+	int err;
+
+#ifdef CONFIG_PCI_MSI
+	if (priv->flags & TSI721_USING_MSIX)
+		err = tsi721_request_msix(mport);
+	else
+#endif
+		err = request_irq(priv->pdev->irq, tsi721_irqhandler,
+			  (priv->flags & TSI721_USING_MSI) ? 0 : IRQF_SHARED,
+			  DRV_NAME, (void *)mport);
+
+	if (err)
+		dev_err(&priv->pdev->dev,
+			"Unable to allocate interrupt, Error: %d\n", err);
+
+	return err;
+}
 
 /**
  * tsi721_init_pc2sr_mapping - initializes outbound (PCIe->SRIO)
@@ -966,11 +968,11 @@ static int tsi721_bdma_ch_init(struct ts
 	iowrite32(TSI721_DMAC_INT_ALL,
 		priv->regs + TSI721_DMAC_INT(chnum));
 
-	(void)ioread32(priv->regs + TSI721_DMAC_INT(chnum));
+	ioread32(priv->regs + TSI721_DMAC_INT(chnum));
 
 	/* Toggle DMA channel initialization */
 	iowrite32(TSI721_DMAC_CTL_INIT,	priv->regs + TSI721_DMAC_CTL(chnum));
-	(void)ioread32(priv->regs + TSI721_DMAC_CTL(chnum));
+	ioread32(priv->regs + TSI721_DMAC_CTL(chnum));
 	udelay(10);
 
 	return 0;
@@ -1205,7 +1207,7 @@ tsi721_add_outb_message(struct rio_mport
 	/* Set new write count value */
 	iowrite32(priv->omsg_ring[mbox].wr_count,
 		priv->regs + TSI721_OBDMAC_DWRCNT(mbox));
-	(void)ioread32(priv->regs + TSI721_OBDMAC_DWRCNT(mbox));
+	ioread32(priv->regs + TSI721_OBDMAC_DWRCNT(mbox));
 
 	return 0;
 }
@@ -1246,7 +1248,7 @@ static void tsi721_omsg_handler(struct t
 		while (sts_ptr[j]) {
 			for (i = 0; i < 8 && sts_ptr[j]; i++, j++) {
 				prev_ptr = last_ptr;
-				last_ptr = sts_ptr[j];
+				last_ptr = le64_to_cpu(sts_ptr[j]);
 				sts_ptr[j] = 0;
 			}
 
@@ -1308,7 +1310,7 @@ no_sts_update:
 				priv->regs + TSI721_OBDMAC_INT(ch));
 		iowrite32(TSI721_OBDMAC_CTL_INIT,
 				priv->regs + TSI721_OBDMAC_CTL(ch));
-		(void)ioread32(priv->regs + TSI721_OBDMAC_CTL(ch));
+		ioread32(priv->regs + TSI721_OBDMAC_CTL(ch));
 
 		/* Inform upper level to clear all pending tx slots */
 		if (priv->mport->outb_msg[ch].mcback)
@@ -1318,7 +1320,7 @@ no_sts_update:
 		/* Synch tx_slot tracking */
 		iowrite32(priv->omsg_ring[ch].tx_slot,
 			priv->regs + TSI721_OBDMAC_DRDCNT(ch));
-		(void)ioread32(priv->regs + TSI721_OBDMAC_DRDCNT(ch));
+		ioread32(priv->regs + TSI721_OBDMAC_DRDCNT(ch));
 		priv->omsg_ring[ch].wr_count = priv->omsg_ring[ch].tx_slot;
 		priv->omsg_ring[ch].sts_rdptr = 0;
 	}
@@ -1394,8 +1396,6 @@ static int tsi721_open_outb_mbox(struct 
 		goto out_buf;
 	}
 
-	memset(priv->omsg_ring[mbox].omd_base, 0,
-		(entries + 1) * sizeof(struct tsi721_omsg_desc));
 	priv->omsg_ring[mbox].tx_slot = 0;
 
 	/* Outbound message descriptor status FIFO allocation */
@@ -1437,6 +1437,7 @@ static int tsi721_open_outb_mbox(struct 
 
 	/* Enable interrupts */
 
+#ifdef CONFIG_PCI_MSI
 	if (priv->flags & TSI721_USING_MSIX) {
 		/* Request interrupt service if we are in MSI-X mode */
 		rc = request_irq(
@@ -1467,12 +1468,14 @@ static int tsi721_open_outb_mbox(struct 
 			goto out_stat;
 		}
 	}
+#endif /* CONFIG_PCI_MSI */
 
 	tsi721_omsg_interrupt_enable(priv, mbox, TSI721_OBDMAC_INT_ALL);
 
 	/* Initialize Outbound Message descriptors ring */
 	bd_ptr = priv->omsg_ring[mbox].omd_base;
 	bd_ptr[entries].type_id = cpu_to_le32(DTYPE5 << 29);
+	bd_ptr[entries].msg_info = 0;
 	bd_ptr[entries].next_lo =
 		cpu_to_le32((u64)priv->omsg_ring[mbox].omd_phys &
 		TSI721_OBDMAC_DPTRL_MASK);
@@ -1483,13 +1486,14 @@ static int tsi721_open_outb_mbox(struct 
 
 	/* Initialize Outbound Message engine */
 	iowrite32(TSI721_OBDMAC_CTL_INIT, priv->regs + TSI721_OBDMAC_CTL(mbox));
-	(void)ioread32(priv->regs + TSI721_OBDMAC_DWRCNT(mbox));
+	ioread32(priv->regs + TSI721_OBDMAC_DWRCNT(mbox));
 	udelay(10);
 
 	priv->omsg_init[mbox] = 1;
 
 	return 0;
 
+#ifdef CONFIG_PCI_MSI
 out_stat:
 	dma_free_coherent(&priv->pdev->dev,
 		priv->omsg_ring[mbox].sts_size * sizeof(struct tsi721_dma_sts),
@@ -1497,6 +1501,7 @@ out_stat:
 		priv->omsg_ring[mbox].sts_phys);
 
 	priv->omsg_ring[mbox].sts_base = NULL;
+#endif /* CONFIG_PCI_MSI */
 
 out_desc:
 	dma_free_coherent(&priv->pdev->dev,
@@ -1540,12 +1545,14 @@ static void tsi721_close_outb_mbox(struc
 
 	tsi721_omsg_interrupt_disable(priv, mbox, TSI721_OBDMAC_INT_ALL);
 
+#ifdef CONFIG_PCI_MSI
 	if (priv->flags & TSI721_USING_MSIX) {
 		free_irq(priv->msix[TSI721_VECT_OMB0_DONE + mbox].vector,
 			 (void *)mport);
 		free_irq(priv->msix[TSI721_VECT_OMB0_INT + mbox].vector,
 			 (void *)mport);
 	}
+#endif /* CONFIG_PCI_MSI */
 
 	/* Free OMSG Descriptor Status FIFO */
 	dma_free_coherent(&priv->pdev->dev,
@@ -1589,6 +1596,8 @@ static void tsi721_imsg_handler(struct t
 	u32 mbox = ch - 4;
 	u32 imsg_int;
 
+	spin_lock(&priv->imsg_ring[mbox].lock);
+
 	imsg_int = ioread32(priv->regs + TSI721_IBDMAC_INT(ch));
 
 	if (imsg_int & TSI721_IBDMAC_INT_SRTO)
@@ -1620,6 +1629,8 @@ static void tsi721_imsg_handler(struct t
 		ch_inte |= TSI721_INT_IMSG_CHAN(ch);
 		iowrite32(ch_inte, priv->regs + TSI721_DEV_CHAN_INTE);
 	}
+
+	spin_unlock(&priv->imsg_ring[mbox].lock);
 }
 
 /**
@@ -1653,6 +1664,7 @@ static int tsi721_open_inb_mbox(struct r
 	priv->imsg_ring[mbox].fq_wrptr = 0;
 	for (i = 0; i < priv->imsg_ring[mbox].size; i++)
 		priv->imsg_ring[mbox].imq_base[i] = NULL;
+	spin_lock_init(&priv->imsg_ring[mbox].lock);
 
 	/* Allocate buffers for incoming messages */
 	priv->imsg_ring[mbox].buf_base =
@@ -1740,6 +1752,7 @@ static int tsi721_open_inb_mbox(struct r
 
 	/* Enable interrupts */
 
+#ifdef CONFIG_PCI_MSI
 	if (priv->flags & TSI721_USING_MSIX) {
 		/* Request interrupt service if we are in MSI-X mode */
 		rc = request_irq(priv->msix[TSI721_VECT_IMB0_RCV + mbox].vector,
@@ -1763,15 +1776,19 @@ static int tsi721_open_inb_mbox(struct r
 			dev_dbg(&priv->pdev->dev,
 				"Unable to allocate MSI-X interrupt for "
 				"IBOX%d-INT\n", mbox);
+			free_irq(
+				priv->msix[TSI721_VECT_IMB0_RCV + mbox].vector,
+				(void *)mport);
 			goto out_desc;
 		}
 	}
+#endif /* CONFIG_PCI_MSI */
 
 	tsi721_imsg_interrupt_enable(priv, ch, TSI721_IBDMAC_INT_ALL);
 
 	/* Initialize Inbound Message Engine */
 	iowrite32(TSI721_IBDMAC_CTL_INIT, priv->regs + TSI721_IBDMAC_CTL(ch));
-	(void)ioread32(priv->regs + TSI721_IBDMAC_CTL(ch));
+	ioread32(priv->regs + TSI721_IBDMAC_CTL(ch));
 	udelay(10);
 	priv->imsg_ring[mbox].fq_wrptr = entries - 1;
 	iowrite32(entries - 1, priv->regs + TSI721_IBDMAC_FQWP(ch));
@@ -1779,6 +1796,7 @@ static int tsi721_open_inb_mbox(struct r
 	priv->imsg_init[mbox] = 1;
 	return 0;
 
+#ifdef CONFIG_PCI_MSI
 out_desc:
 	dma_free_coherent(&priv->pdev->dev,
 		priv->imsg_ring[mbox].size * sizeof(struct tsi721_imsg_desc),
@@ -1786,6 +1804,7 @@ out_desc:
 		priv->imsg_ring[mbox].imd_phys);
 
 	priv->imsg_ring[mbox].imd_base = NULL;
+#endif /* CONFIG_PCI_MSI */
 
 out_dma:
 	dma_free_coherent(&priv->pdev->dev,
@@ -1827,12 +1846,14 @@ static void tsi721_close_inb_mbox(struct
 	/* Disable Interrupts */
 	tsi721_imsg_interrupt_disable(priv, ch, TSI721_OBDMAC_INT_MASK);
 
+#ifdef CONFIG_PCI_MSI
 	if (priv->flags & TSI721_USING_MSIX) {
 		free_irq(priv->msix[TSI721_VECT_IMB0_RCV + mbox].vector,
 				(void *)mport);
 		free_irq(priv->msix[TSI721_VECT_IMB0_INT + mbox].vector,
 				(void *)mport);
 	}
+#endif /* CONFIG_PCI_MSI */
 
 	/* Clear Inbound Buffer Queue */
 	for (rx_slot = 0; rx_slot < priv->imsg_ring[mbox].size; rx_slot++)
@@ -2101,6 +2122,7 @@ static int __devinit tsi721_setup_mport(
 
 	/* Hook up interrupt handler */
 
+#ifdef CONFIG_PCI_MSI
 	if (!tsi721_enable_msix(priv))
 		priv->flags |= TSI721_USING_MSIX;
 	else if (!pci_enable_msi(pdev))
@@ -2108,6 +2130,7 @@ static int __devinit tsi721_setup_mport(
 	else
 		dev_info(&pdev->dev,
 			 "MSI/MSI-X is not available. Using legacy INTx.\n");
+#endif /* CONFIG_PCI_MSI */
 
 	err = tsi721_request_irq(mport);
 
diff -puN drivers/rapidio/devices/tsi721.h~rapidio-add-mport-driver-for-tsi721-bridge-update drivers/rapidio/devices/tsi721.h
--- a/drivers/rapidio/devices/tsi721.h~rapidio-add-mport-driver-for-tsi721-bridge-update
+++ a/drivers/rapidio/devices/tsi721.h
@@ -505,7 +505,7 @@ struct tsi721_dma_desc {
 		__le32 data[4];		   /* if DTYPE == 2 */
 		u32    reserved[4];	   /* if DTYPE == 3 */
 	};
-} __attribute__((aligned(32)));
+} __aligned(32);
 
 /*
  * Inbound Messaging Descriptor
@@ -533,7 +533,7 @@ struct tsi721_imsg_desc {
 	__le32 bufptr_hi;
 	u32    reserved[12];
 
-} __attribute__((aligned(64)));
+} __aligned(64);
 
 /*
  * Outbound Messaging Descriptor
@@ -567,11 +567,11 @@ struct tsi721_omsg_desc {
 		__le32 next_hi;		/* if DTYPE == 5 */
 	};
 
-} __attribute__((aligned(16)));
+} __aligned(16);
 
 struct tsi721_dma_sts {
 	__le64	desc_sts[8];
-} __attribute__((aligned(64)));
+} __aligned(64);
 
 struct tsi721_desc_sts_fifo {
 	union {
@@ -581,7 +581,7 @@ struct tsi721_desc_sts_fifo {
 			__le32	hi;
 		} da32;
 	} stat[8];
-} __attribute__((aligned(64)));
+} __aligned(64);
 
 /* Descriptor types for BDMA and Messaging blocks */
 enum dma_dtype {
@@ -624,7 +624,7 @@ enum tsi721_smsg_int_flag {
 
 /* Structures */
 
-struct dma_chan {
+struct tsi721_bdma_chan {
 	int		bd_num;		/* number of buffer descriptors */
 	void		*bd_base;	/* start of DMA descriptors */
 	dma_addr_t	bd_phys;
@@ -651,6 +651,7 @@ struct tsi721_imsg_ring {
 	void		*dev_id;
 	u32		fq_wrptr;
 	u32		desc_rdptr;
+	spinlock_t	lock;
 };
 
 struct tsi721_omsg_ring {
@@ -679,6 +680,7 @@ enum tsi721_flags {
 	TSI721_IMSGID_SET	= (1 << 2),
 };
 
+#ifdef CONFIG_PCI_MSI
 /*
  * MSI-X Table Entries (0 ... 69)
  */
@@ -726,14 +728,16 @@ struct msix_irq {
 	u16	vector;
 	char	irq_name[IRQ_DEVICE_NAME_MAX];
 };
+#endif /* CONFIG_PCI_MSI */
 
 struct tsi721_device {
 	struct pci_dev	*pdev;
 	struct rio_mport *mport;
 	u32		flags;
 	void __iomem	*regs;
+#ifdef CONFIG_PCI_MSI
 	struct msix_irq	msix[TSI721_VECT_MAX];
-
+#endif
 	/* Doorbells */
 	void __iomem	*odb_base;
 	void		*idb_base;
@@ -748,7 +752,7 @@ struct tsi721_device {
 	u32		pw_discard_count;
 
 	/* BDMA Engine */
-	struct dma_chan bdma[TSI721_DMA_CHNUM];
+	struct tsi721_bdma_chan bdma[TSI721_DMA_CHNUM];
 
 	/* Inbound Messaging */
 	int		imsg_init[TSI721_IMSG_CHNUM];
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

drivers-rapidio-rio-scanc-use-discovered-bit-to-test-if-enumeration-is-complete.patch
arch-powerpc-sysdev-fsl_rioc-release-rapidio-port-i-o-region-resource-if-port-failed-to-initialize.patch
rapidio-add-mport-driver-for-tsi721-bridge.patch
rapidio-fix-potential-null-deref-in-rio_setup_device.patch
drivers-net-rionetc-fix-ethernet-address-macros-for-le-platforms.patch
rapidio-documentation-update.patch
include-linux-dma-mappingh-add-dma_zalloc_coherent.patch


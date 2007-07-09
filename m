From: akpm@linux-foundation.org
Subject: - ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-update.patch removed from -mm tree
Date: Mon, 09 Jul 2007 11:44:40 -0700
Message-ID: <200707091844.l69Iifv9001259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42001 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751815AbXGISoy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 14:44:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kluo@nvidia.com, pchen@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61 (update)
has been removed from the -mm tree.  Its filename was
     ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-update.patch

This patch was dropped because it was folded into ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch

------------------------------------------------------
Subject: ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61 (update)
From: Kuan Luo <kluo@nvidia.com>

Add the Software NCQ support to sata_nv.c for MCP51/MCP55/MCP61 SATA
controller.  NCQ function is disable by default, you can enable it with
'swncq=1'. NCQ will be turned off if the drive is Maxtor on MCP51 or
MCP55 rev 0xa2  platform.

Signed-off-by: Kuan Luo <kluo@nvidia.com>
Signed-off-by: Peer Chen <pchen@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |  259 ++++++++++++++++++++++------------------
 1 file changed, 145 insertions(+), 114 deletions(-)

diff -puN drivers/ata/sata_nv.c~ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-update drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-update
+++ a/drivers/ata/sata_nv.c
@@ -190,9 +190,9 @@ enum {
 	NV_SWNCQ_IRQ_ADDED		= (1 << 2),
 	NV_SWNCQ_IRQ_REMOVED		= (1 << 3),
 
- 	NV_SWNCQ_IRQ_BACKOUT		= (1 << 4),
- 	NV_SWNCQ_IRQ_SDBFIS		= (1 << 5),
- 	NV_SWNCQ_IRQ_DHREGFIS		= (1 << 6),
+	NV_SWNCQ_IRQ_BACKOUT		= (1 << 4),
+	NV_SWNCQ_IRQ_SDBFIS		= (1 << 5),
+	NV_SWNCQ_IRQ_DHREGFIS		= (1 << 6),
 	NV_SWNCQ_IRQ_DMASETUP		= (1 << 7),
 
 	NV_SWNCQ_IRQ_HOTPLUG		= NV_SWNCQ_IRQ_ADDED |
@@ -255,27 +255,29 @@ struct nv_host_priv {
 	unsigned long		type;
 };
 
-typedef struct {
- 	u32		defer_bits;
- 	u8		front;
-	u8		rear;
-	unsigned int	tag[ATA_MAX_QUEUE + 1];
-}defer_queue_t;
+struct defer_queue {
+	u32		defer_bits;
+	unsigned int	head;
+	unsigned int	tail;
+	unsigned int	tag[ATA_MAX_QUEUE];
+};
 
 struct nv_swncq_port_priv {
 	struct ata_prd	*prd;	 /* our SG list */
 	dma_addr_t	prd_dma; /* and its DMA mapping */
 	void __iomem	*sactive_block;
+	void __iomem	*irq_block;
+	void __iomem	*tag_block;
 	u32		qc_active;
 	unsigned int	last_issue_tag;
- 	spinlock_t	lock;
- 	/* fifo loop queue  to store deferral command */
-	defer_queue_t	defer_queue;
+	spinlock_t	lock;
+	/* fifo circular queue to store deferral command */
+	struct defer_queue defer_queue;
 
- 	/* for NCQ interrupt analysis */
+	/* for NCQ interrupt analysis */
 	u32		dhfis_bits;
- 	u32		dmafis_bits;
- 	u32		sdbfis_bits;
+	u32		dmafis_bits;
+	u32		sdbfis_bits;
 
 	unsigned int	ncq_saw_d2h:1;
 	unsigned int	ncq_saw_dmas:1;
@@ -324,11 +326,12 @@ static void nv_adma_tf_read(struct ata_p
 static void nv_mcp55_thaw(struct ata_port *ap);
 static void nv_mcp55_freeze(struct ata_port *ap);
 static void nv_swncq_error_handler(struct ata_port *ap);
-static int  nv_swncq_port_start(struct ata_port *ap);
+static int nv_swncq_slave_config(struct scsi_device *sdev);
+static int nv_swncq_port_start(struct ata_port *ap);
 static void nv_swncq_qc_prep(struct ata_queued_cmd *qc);
 static void nv_swncq_fill_sg(struct ata_queued_cmd *qc);
 static unsigned int nv_swncq_qc_issue(struct ata_queued_cmd *qc);
-static void nv_swncq_irq_clear(struct ata_port *ap, u32 val);
+static void nv_swncq_irq_clear(struct ata_port *ap, u16 fis);
 static irqreturn_t nv_swncq_interrupt(int irq, void *dev_instance);
 #ifdef CONFIG_PM
 static int nv_swncq_port_suspend(struct ata_port *ap, pm_message_t mesg);
@@ -425,7 +428,7 @@ static struct scsi_host_template nv_swnc
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
-	.slave_configure	= ata_scsi_slave_config,
+	.slave_configure	= nv_swncq_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
 };
@@ -618,7 +621,7 @@ static const struct ata_port_info nv_por
 		.port_ops	= &nv_adma_ops,
 		.irq_handler	= nv_adma_interrupt,
 	},
-	/* SWNCQ*/
+	/* SWNCQ */
 	{
 		.sht		= &nv_swncq_sht,
 		.flags	        = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
@@ -638,7 +641,7 @@ MODULE_DEVICE_TABLE(pci, nv_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
 static int adma_enabled = 1;
-static int swncq_enabled = 0;
+static int swncq_enabled;
 
 static void nv_adma_register_mode(struct ata_port *ap)
 {
@@ -1593,13 +1596,6 @@ static void nv_mcp55_freeze(struct ata_p
 	void __iomem *mmio_base = ap->host->iomap[NV_MMIO_BAR];
 	int shift = ap->port_no * NV_INT_PORT_SHIFT_MCP55;
 	u32 mask;
-	u32 val;
-
-	if (ap->flags & ATA_FLAG_NCQ) {
-		val = readl(mmio_base + NV_CTL_MCP55);
-		val &= ~(NV_CTL_PRI_SWNCQ << ap->port_no);
-		writel(val, mmio_base + NV_CTL_MCP55);/* disable ncq */
-	}
 
 	writel(NV_INT_ALL_MCP55 << shift, mmio_base + NV_INT_STATUS_MCP55);
 
@@ -1614,13 +1610,6 @@ static void nv_mcp55_thaw(struct ata_por
 	void __iomem *mmio_base = ap->host->iomap[NV_MMIO_BAR];
 	int shift = ap->port_no * NV_INT_PORT_SHIFT_MCP55;
 	u32 mask;
-	u32 val;
-
-	if (ap->flags & ATA_FLAG_NCQ) {
-		val = readl(mmio_base + NV_CTL_MCP55);
-		val |= (NV_CTL_PRI_SWNCQ << ap->port_no);
-		writel(val, mmio_base + NV_CTL_MCP55);/* enable ncq */
-	}
 
 	writel(NV_INT_ALL_MCP55 << shift, mmio_base + NV_INT_STATUS_MCP55);
 
@@ -1706,31 +1695,25 @@ static void nv_adma_error_handler(struct
 static void nv_swncq_qc_to_dq(struct ata_port *ap, struct ata_queued_cmd *qc)
 {
 	struct nv_swncq_port_priv *pp = ap->private_data;
-	defer_queue_t	*dq = &pp->defer_queue;
+	struct defer_queue *dq = &pp->defer_queue;
 
 	/* queue is full */
-	WARN_ON((dq->rear + 1) % (ATA_MAX_QUEUE + 1) == dq->front);
-
+	WARN_ON(dq->tail - dq->head == ATA_MAX_QUEUE);
 	dq->defer_bits |= (1 << qc->tag);
-
-	dq->tag[dq->rear] = qc->tag;
-	dq->rear = (dq->rear + 1) % (ATA_MAX_QUEUE + 1);
-
+	dq->tag[dq->tail++ & (ATA_MAX_QUEUE - 1)] = qc->tag;
 }
 
 static struct ata_queued_cmd *nv_swncq_qc_from_dq(struct ata_port *ap)
 {
 	struct nv_swncq_port_priv *pp = ap->private_data;
-	defer_queue_t	*dq = &pp->defer_queue;
+	struct defer_queue *dq = &pp->defer_queue;
 	unsigned int tag;
 
-	if (dq->front == dq->rear) /* null queue */
+	if (dq->head == dq->tail)	/* null queue */
 		return NULL;
 
-	tag = dq->tag[dq->front];
-	dq->tag[dq->front] = ATA_TAG_POISON;
-	dq->front = (dq->front + 1) % (ATA_MAX_QUEUE + 1);
-
+	tag = dq->tag[dq->head & (ATA_MAX_QUEUE - 1)];
+	dq->tag[dq->head++ & (ATA_MAX_QUEUE - 1)] = ATA_TAG_POISON;
 	WARN_ON(!(dq->defer_bits & (1 << tag)));
 	dq->defer_bits &= ~(1 << tag);
 
@@ -1741,7 +1724,7 @@ static void nv_swncq_bmdma_stop(struct a
 {
 	/* clear start/stop bit */
 	iowrite8(ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD) & ~ATA_DMA_START,
-			ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+		 ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
 	ata_altstatus(ap);
 }
 
@@ -1761,21 +1744,20 @@ static void nv_swncq_fis_reinit(struct a
 static void nv_swncq_pp_reinit(struct ata_port *ap)
 {
 	struct nv_swncq_port_priv *pp = ap->private_data;
-	defer_queue_t		*dq = &pp->defer_queue;
+	struct defer_queue *dq = &pp->defer_queue;
 
-	dq->front = dq->rear = 0;
+	dq->head = dq->tail = 0;
 	dq->defer_bits = 0;
 	pp->qc_active = 0;
 	pp->last_issue_tag = ATA_TAG_POISON;
 	nv_swncq_fis_reinit(ap);
 }
 
-static void nv_swncq_irq_clear(struct ata_port *ap, u32 val)
+static void nv_swncq_irq_clear(struct ata_port *ap, u16 fis)
 {
-	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
-	u32  flags = (val << (ap->port_no * NV_INT_PORT_SHIFT_MCP55));
+	struct nv_swncq_port_priv *pp = ap->private_data;
 
-	writel(flags, mmio + NV_INT_STATUS_MCP55);
+	writew(fis, pp->irq_block);
 }
 
 static void nv_swncq_ncq_stop(struct ata_port *ap)
@@ -1786,23 +1768,23 @@ static void nv_swncq_ncq_stop(struct ata
 	u32 done_mask;
 
 	ata_port_printk(ap, KERN_ERR,
-		"EH in SWNCQ mode,QC:qc_active 0x%X sactive 0x%X\n",
-		ap->qc_active, ap->sactive);
+			"EH in SWNCQ mode,QC:qc_active 0x%X sactive 0x%X\n",
+			ap->qc_active, ap->sactive);
 	ata_port_printk(ap, KERN_ERR,
 		"SWNCQ:qc_active 0x%X defer_bits 0x%X last_issue_tag 0x%x\n  "
-		 "dhfis 0x%X dmafis 0x%X sdbfis 0x%X\n",
+		"dhfis 0x%X dmafis 0x%X sdbfis 0x%X\n",
 		pp->qc_active, pp->defer_queue.defer_bits, pp->last_issue_tag,
-		pp->dhfis_bits, pp->dmafis_bits,
-		pp->sdbfis_bits);
+		pp->dhfis_bits, pp->dmafis_bits, pp->sdbfis_bits);
 
 	ata_port_printk(ap, KERN_ERR, "ATA_REG 0x%X ERR_REG 0x%X\n",
-		ap->ops->check_status(ap), ioread8(ap->ioaddr.error_addr));
+			ap->ops->check_status(ap),
+			ioread8(ap->ioaddr.error_addr));
 
 	sactive = readl(pp->sactive_block);
 	done_mask = pp->qc_active ^ sactive;
 
 	ata_port_printk(ap, KERN_ERR, "tag : dhfis dmafis sdbfis sacitve\n");
-	for (i=0; i < ATA_MAX_QUEUE; i++) {
+	for (i = 0; i < ATA_MAX_QUEUE; i++) {
 		u8 err = 0;
 		if (pp->qc_active & (1 << i))
 			err = 0;
@@ -1812,11 +1794,12 @@ static void nv_swncq_ncq_stop(struct ata
 			continue;
 
 		ata_port_printk(ap, KERN_ERR,
-		"tag 0x%x: %01x %01x %01x %01x %s\n", i,
-		(pp->dhfis_bits >> i) & 0x1,
-		(pp->dmafis_bits >> i) & 0x1 , (pp->sdbfis_bits >> i) & 0x1,
-		(sactive >> i) & 0x1,
-		(err ? "error!tag doesn't exit, but sactive bit is set" : " "));
+				"tag 0x%x: %01x %01x %01x %01x %s\n", i,
+				(pp->dhfis_bits >> i) & 0x1,
+				(pp->dmafis_bits >> i) & 0x1,
+				(pp->sdbfis_bits >> i) & 0x1,
+				(sactive >> i) & 0x1,
+				(err ? "error! tag doesn't exit" : " "));
 	}
 
 	nv_swncq_pp_reinit(ap);
@@ -1835,13 +1818,13 @@ static void nv_swncq_error_handler(struc
 	}
 
 	ata_bmdma_drive_eh(ap, ata_std_prereset, ata_std_softreset,
-				nv_hardreset, ata_std_postreset);
+			   nv_hardreset, ata_std_postreset);
 }
 
 #ifdef CONFIG_PM
 static int nv_swncq_port_suspend(struct ata_port *ap, pm_message_t mesg)
 {
-	void __iomem *mmio =  ap->host->iomap[NV_MMIO_BAR];
+	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
 	u32 tmp;
 
 	/* clear irq */
@@ -1863,7 +1846,7 @@ static int nv_swncq_port_suspend(struct 
 
 static int nv_swncq_port_resume(struct ata_port *ap)
 {
-	void __iomem *mmio =  ap->host->iomap[NV_MMIO_BAR];
+	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
 	u32 tmp;
 
 	/* clear irq */
@@ -1873,7 +1856,7 @@ static int nv_swncq_port_resume(struct a
 		return 0;
 
 	/* enable irq */
-	writel(0x00fd00fd,  mmio + NV_INT_ENABLE_MCP55);
+	writel(0x00fd00fd, mmio + NV_INT_ENABLE_MCP55);
 
 	/* enable swncq */
 	tmp = readl(mmio + NV_CTL_MCP55);
@@ -1886,7 +1869,7 @@ static int nv_swncq_port_resume(struct a
 static void nv_swncq_host_init(struct ata_host *host)
 {
 	u32 tmp;
-	void __iomem	*mmio = host->iomap[NV_MMIO_BAR];
+	void __iomem *mmio = host->iomap[NV_MMIO_BAR];
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	u8 regval;
 	unsigned int i;
@@ -1902,7 +1885,7 @@ static void nv_swncq_host_init(struct at
 	writel(tmp | NV_CTL_PRI_SWNCQ | NV_CTL_SEC_SWNCQ, mmio + NV_CTL_MCP55);
 
 	for (i = 0; i < host->n_ports; i++)
-	    host->ports[i]->flags |= ATA_FLAG_NCQ;
+		host->ports[i]->flags |= ATA_FLAG_NCQ;
 
 	/* enable irq intr */
 	tmp = readl(mmio + NV_INT_ENABLE_MCP55);
@@ -1913,7 +1896,53 @@ static void nv_swncq_host_init(struct at
 	writel(~0x0, mmio + NV_INT_STATUS_MCP55);
 }
 
-static int  nv_swncq_port_start(struct ata_port *ap)
+static int nv_swncq_slave_config(struct scsi_device *sdev)
+{
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	struct ata_device *dev;
+	int rc;
+	u8 rev;
+	u8 check_maxtor = 0;
+	unsigned char model_num[ATA_ID_PROD_LEN + 1];
+
+	rc = ata_scsi_slave_config(sdev);
+	if (sdev->id >= ATA_MAX_DEVICES || sdev->channel || sdev->lun)
+		/* Not a proper libata device, ignore */
+		return rc;
+
+	dev = &ap->device[sdev->id];
+	if (!(ap->flags & ATA_FLAG_NCQ) || dev->class == ATA_DEV_ATAPI)
+		return rc;
+
+	/* if MCP51 and Maxtor, then disable ncq */
+	if (pdev->device == PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA ||
+		pdev->device == PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2)
+		check_maxtor = 1;
+
+	/* if MCP55 and rev <= a2 and Maxtor, then disable ncq */
+	if (pdev->device == PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA ||
+		pdev->device == PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2) {
+		pci_read_config_byte(pdev, 0x8, &rev);
+		if (rev <= 0xa2)
+			check_maxtor = 1;
+	}
+
+	if (!check_maxtor)
+		return rc;
+
+	ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
+
+	if (strncmp(model_num, "Maxtor", 6) == 0) {
+		ata_scsi_change_queue_depth(sdev, 1);
+		ata_dev_printk(dev, KERN_NOTICE,
+			"Disabling SWNCQ mode (depth %x)\n", sdev->queue_depth);
+	}
+
+	return rc;
+}
+
+static int nv_swncq_port_start(struct ata_port *ap)
 {
 	struct device *dev = ap->host->dev;
 	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
@@ -1929,14 +1958,15 @@ static int  nv_swncq_port_start(struct a
 		return -ENOMEM;
 
 	pp->prd = dmam_alloc_coherent(dev, ATA_PRD_TBL_SZ * ATA_MAX_QUEUE,
-				&pp->prd_dma, GFP_KERNEL);
+				      &pp->prd_dma, GFP_KERNEL);
 	if (!pp->prd)
 		return -ENOMEM;
 	memset(pp->prd, 0, ATA_PRD_TBL_SZ * ATA_MAX_QUEUE);
 
 	ap->private_data = pp;
-	pp->sactive_block = mmio + 4 * SCR_ACTIVE +
-			    ap->port_no * NV_PORT1_SCR_REG_OFFSET;
+	pp->sactive_block = ap->ioaddr.scr_addr + 4 * SCR_ACTIVE;
+	pp->irq_block = mmio + NV_INT_STATUS_MCP55 + ap->port_no * 2;
+	pp->tag_block = mmio + NV_NCQ_REG_MCP55 + ap->port_no * 2;
 	spin_lock_init(&pp->lock);
 
 	return 0;
@@ -1944,8 +1974,10 @@ static int  nv_swncq_port_start(struct a
 
 static void nv_swncq_qc_prep(struct ata_queued_cmd *qc)
 {
-	if (qc->tf.protocol != ATA_PROT_NCQ)
-		return ata_qc_prep(qc);
+	if (qc->tf.protocol != ATA_PROT_NCQ) {
+		ata_qc_prep(qc);
+		return;
+	}
 
 	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
 		return;
@@ -1958,22 +1990,20 @@ static void nv_swncq_fill_sg(struct ata_
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg;
 	unsigned int idx;
-
 	struct nv_swncq_port_priv *pp = ap->private_data;
-
 	struct ata_prd *prd;
 
 	WARN_ON(qc->__sg == NULL);
 	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
 
-	prd = (void*)pp->prd + (ATA_PRD_TBL_SZ * qc->tag);
+	prd = pp->prd + ATA_MAX_PRD * qc->tag;
 
 	idx = 0;
 	ata_for_each_sg(sg, qc) {
 		u32 addr, offset;
 		u32 sg_len, len;
 
-		addr = (u32) sg_dma_address(sg);
+		addr = (u32)sg_dma_address(sg);
 		sg_len = sg_dma_len(sg);
 
 		while (sg_len) {
@@ -2005,7 +2035,7 @@ static unsigned int nv_swncq_issue_atacm
 
 	DPRINTK("Enter\n");
 
-	writel((1 << qc->tag),  pp->sactive_block);
+	writel((1 << qc->tag), pp->sactive_block);
 	pp->last_issue_tag = qc->tag;
 	pp->dhfis_bits &= ~(1 << qc->tag);
 	pp->dmafis_bits &= ~(1 << qc->tag);
@@ -2033,7 +2063,7 @@ static unsigned int nv_swncq_qc_issue(st
 	if (!pp->qc_active)
 		nv_swncq_issue_atacmd(ap, qc);
 	else
-		nv_swncq_qc_to_dq(ap, qc); /*add defer queue*/
+		nv_swncq_qc_to_dq(ap, qc);	/* add qc to defer queue */
 	spin_unlock_irqrestore(&pp->lock, flags);
 	return 0;
 }
@@ -2052,7 +2082,6 @@ static void nv_swncq_hotplug(struct ata_
 	/* analyze @irq_stat */
 	if (fis & NV_SWNCQ_IRQ_ADDED)
 		ata_ehi_push_desc(ehi, "hot plug");
-
 	else if (fis & NV_SWNCQ_IRQ_REMOVED)
 		ata_ehi_push_desc(ehi, "hot unplug");
 
@@ -2078,7 +2107,7 @@ static int nv_swncq_sdbfis(struct ata_po
 
 	host_stat = ap->ops->bmdma_status(ap);
 	if (unlikely(host_stat & ATA_DMA_ERR)) {
-	/* error when transfering data to/from memory */
+		/* error when transfering data to/from memory */
 		ata_ehi_clear_desc(ehi);
 		ata_ehi_push_desc(ehi, "BMDMA stat 0x%x", host_stat);
 		ehi->err_mask |= AC_ERR_HOST_BUS;
@@ -2095,18 +2124,17 @@ static int nv_swncq_sdbfis(struct ata_po
 	if (unlikely(done_mask & sactive)) {
 		ata_ehi_clear_desc(ehi);
 		ata_ehi_push_desc(ehi, "illegal SWNCQ:qc_active transition"
-			"(%08x->%08x)", pp->qc_active, sactive);
+				  "(%08x->%08x)", pp->qc_active, sactive);
 		ehi->err_mask |= AC_ERR_HSM;
 		ehi->action |= ATA_EH_HARDRESET;
 		return -EINVAL;
 	}
 	for (i = 0; i < ATA_MAX_QUEUE; i++) {
-		struct ata_queued_cmd *qc;
-
 		if (!(done_mask & (1 << i)))
 			continue;
 
-		if ((qc = ata_qc_from_tag(ap, i))) {
+		qc = ata_qc_from_tag(ap, i);
+		if (qc) {
 			ata_qc_complete(qc);
 			pp->qc_active &= ~(1 << i);
 			pp->dhfis_bits &= ~(1 << i);
@@ -2123,11 +2151,12 @@ static int nv_swncq_sdbfis(struct ata_po
 	}
 
 	if (pp->qc_active & pp->dhfis_bits)
-			return nr_done;
+		return nr_done;
 
-	if (pp->ncq_saw_backout || (pp->qc_active ^pp->dhfis_bits))
-		 /* if the controller cann't get a device to host register FIS,
-		     The driver needs to reissue the new command. */
+	if (pp->ncq_saw_backout || (pp->qc_active ^ pp->dhfis_bits))
+		/* if the controller cann't get a device to host register FIS,
+		 * The driver needs to reissue the new command.
+		 */
 		lack_dhfis = 1;
 
 	DPRINTK("id 0x%x QC: qc_active 0x%x,"
@@ -2145,7 +2174,8 @@ static int nv_swncq_sdbfis(struct ata_po
 		return nr_done;
 	}
 
-	if (pp->defer_queue.defer_bits) {/* send deferral queue command */
+	if (pp->defer_queue.defer_bits) {
+		/* send deferral queue command */
 		qc = nv_swncq_qc_from_dq(ap);
 		WARN_ON(qc == NULL);
 		nv_swncq_issue_atacmd(ap, qc);
@@ -2156,19 +2186,17 @@ static int nv_swncq_sdbfis(struct ata_po
 
 static inline u32 nv_swncq_tag(struct ata_port *ap)
 {
-	void __iomem *mmio =  ap->host->iomap[NV_MMIO_BAR];
+	struct nv_swncq_port_priv *pp = ap->private_data;
 	u32 tag;
 
-	tag = readl(mmio + NV_NCQ_REG_MCP55);
-	tag >>= (2 + (16 * ap->port_no));
-	tag &= 0x1f;
-	return  tag;
+	tag = readb(pp->tag_block) >> 2;
+	return (tag & 0x1f);
 }
 
 static int nv_swncq_dmafis(struct ata_port *ap)
 {
 	struct ata_queued_cmd *qc;
-	unsigned int rw ;
+	unsigned int rw;
 	u8 dmactl;
 	u32 tag;
 	struct nv_swncq_port_priv *pp = ap->private_data;
@@ -2182,7 +2210,7 @@ static int nv_swncq_dmafis(struct ata_po
 	if (unlikely(!qc))
 		return 0;
 
-	rw  =  ((qc->tf.flags) & ATA_TFLAG_WRITE);
+	rw = qc->tf.flags & ATA_TFLAG_WRITE;
 
 	/* load PRD table addr. */
 	iowrite32(pp->prd_dma + ATA_PRD_TBL_SZ * qc->tag,
@@ -2190,7 +2218,7 @@ static int nv_swncq_dmafis(struct ata_po
 
 	/* specify data direction, triple-check start bit is clear */
 	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-	dmactl &= ~(ATA_DMA_WR);
+	dmactl &= ~ATA_DMA_WR;
 	if (!rw)
 		dmactl |= ATA_DMA_WR;
 
@@ -2199,7 +2227,7 @@ static int nv_swncq_dmafis(struct ata_po
 	return 1;
 }
 
-static void nv_swncq_host_interrupt(struct ata_port *ap,  u32  fis)
+static void nv_swncq_host_interrupt(struct ata_port *ap, u16 fis)
 {
 	struct nv_swncq_port_priv *pp = ap->private_data;
 	struct ata_queued_cmd *qc;
@@ -2239,8 +2267,9 @@ static void nv_swncq_host_interrupt(stru
 
 	spin_lock(&pp->lock);
 	if (fis & NV_SWNCQ_IRQ_BACKOUT) {
-		/* If the IRQ is backout, driver must issue the new command
-		   again some time later. */
+		/* If the IRQ is backout, driver must issue
+		 * the new command again some time later.
+		 */
 		pp->ncq_saw_backout = 1;
 	}
 
@@ -2256,8 +2285,9 @@ static void nv_swncq_host_interrupt(stru
 	}
 
 	if (fis & NV_SWNCQ_IRQ_DHREGFIS) {
-		/* The interrupt indicates the new command was transmitted
-		correctly to the drive. */
+		/* The interrupt indicates the new command
+		 * was transmitted correctly to the drive.
+		 */
 		pp->dhfis_bits |= (0x1 << pp->last_issue_tag);
 		pp->ncq_saw_d2h = 1;
 		if (pp->ncq_saw_sdb || pp->ncq_saw_backout) {
@@ -2267,7 +2297,7 @@ static void nv_swncq_host_interrupt(stru
 			goto irq_error;
 		}
 
-		if ( !(fis & NV_SWNCQ_IRQ_DMASETUP) && !pp->ncq_saw_dmas) {
+		if (!(fis & NV_SWNCQ_IRQ_DMASETUP) && !pp->ncq_saw_dmas) {
 			ata_stat = ap->ops->check_status(ap);
 			if (ata_stat & ATA_BUSY)
 				goto irq_exit;
@@ -2282,7 +2312,8 @@ static void nv_swncq_host_interrupt(stru
 
 	if (fis & NV_SWNCQ_IRQ_DMASETUP) {
 		/* program the dma controller with appropriate PRD buffers
-		   and start the DMA transfer for requested command.  */
+		 * and start the DMA transfer for requested command.
+		 */
 		pp->dmafis_bits |= (0x1 << nv_swncq_tag(ap));
 		pp->ncq_saw_dmas = 1;
 		rc = nv_swncq_dmafis(ap);
@@ -2291,7 +2322,6 @@ static void nv_swncq_host_interrupt(stru
 irq_exit:
 	spin_unlock(&pp->lock);
 	return;
-
 irq_error:
 	ata_ehi_push_desc(ehi, "fis:0x%x", fis);
 	ata_port_freeze(ap);
@@ -2306,6 +2336,7 @@ static irqreturn_t nv_swncq_interrupt(in
 	unsigned int handled = 0;
 	unsigned long flags;
 	u32 irq_stat;
+
 	spin_lock_irqsave(&host->lock, flags);
 
 	irq_stat = readl(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_MCP55);
@@ -2313,12 +2344,12 @@ static irqreturn_t nv_swncq_interrupt(in
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
-		if (ap && !(ap->flags & ATA_FLAG_DISABLED) ) {
+		if (ap && !(ap->flags & ATA_FLAG_DISABLED)) {
 			if (ap->sactive) {
-				nv_swncq_host_interrupt(ap, irq_stat & 0xffff);
+				nv_swncq_host_interrupt(ap, (u16)irq_stat);
 				handled = 1;
 			} else {
-				if (irq_stat) /* reserve Hotplug and INT intr */
+				if (irq_stat)	/* reserve Hotplug */
 					nv_swncq_irq_clear(ap, 0xfff0);
 
 				handled += nv_host_intr(ap, (u8)irq_stat);
_

Patches currently in -mm which might be from kluo@nvidia.com are

ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-update.patch

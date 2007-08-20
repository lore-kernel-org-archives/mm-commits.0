From: akpm@linux-foundation.org
Subject: - ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch removed from -mm tree
Date: Mon, 20 Aug 2007 16:20:28 -0700
Message-ID: <200708202325.l7KNPZEw029143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36036 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099AbXHTX01 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 19:26:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kluo@nvidia.com, hancockr@shaw.ca, htejun@gmail.com, jeff@garzik.org, pchen@nvidia.com, zboszor@dunaweb.hu, mm-commits@vger.kernel.org


The patch titled
     ata: add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
has been removed from the -mm tree.  Its filename was
     ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch

This patch was dropped because Changes in Jeff's tree destroyed it

------------------------------------------------------
Subject: ata: add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
From: Kuan Luo <kluo@nvidia.com>

Add the Software NCQ support to sata_nv.c for MCP51/MCP55/MCP61 SATA
controller.  NCQ function is disable by default, you can enable it with
'swncq=1'.  NCQ will be turned off if the drive is Maxtor on MCP51 or MCP55
rev 0xa2 platform.

[hancockr@shaw.ca: sata_nv: allow changing queue depth]
[akpm@linux-foundation.org: build fix]
Signed-off-by: Kuan Luo <kluo@nvidia.com>
Signed-off-by: Peer Chen <pchen@nvidia.com>
Cc: Zoltan Boszormenyi <zboszor@dunaweb.hu>
Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |  861 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 852 insertions(+), 9 deletions(-)

diff -puN drivers/ata/sata_nv.c~ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61 drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61
+++ a/drivers/ata/sata_nv.c
@@ -169,6 +169,35 @@ enum {
 	NV_ADMA_PORT_REGISTER_MODE	= (1 << 0),
 	NV_ADMA_ATAPI_SETUP_COMPLETE	= (1 << 1),
 
+	/* MCP55 reg offset */
+	NV_CTL_MCP55			= 0x400,
+	NV_INT_STATUS_MCP55		= 0x440,
+	NV_INT_ENABLE_MCP55		= 0x444,
+	NV_NCQ_REG_MCP55		= 0x448,
+
+	/* MCP55 */
+	NV_INT_ALL_MCP55		= 0xffff,
+	NV_INT_PORT_SHIFT_MCP55		= 16,	/* each port occupies 16 bits */
+	NV_INT_MASK_MCP55		= NV_INT_ALL_MCP55 & 0xfffd,
+
+	/* SWNCQ ENABLE BITS*/
+	NV_CTL_PRI_SWNCQ		= 0x02,
+	NV_CTL_SEC_SWNCQ		= 0x04,
+
+	/* SW NCQ status bits*/
+	NV_SWNCQ_IRQ_DEV		= (1 << 0),
+	NV_SWNCQ_IRQ_PM			= (1 << 1),
+	NV_SWNCQ_IRQ_ADDED		= (1 << 2),
+	NV_SWNCQ_IRQ_REMOVED		= (1 << 3),
+
+	NV_SWNCQ_IRQ_BACKOUT		= (1 << 4),
+	NV_SWNCQ_IRQ_SDBFIS		= (1 << 5),
+	NV_SWNCQ_IRQ_DHREGFIS		= (1 << 6),
+	NV_SWNCQ_IRQ_DMASETUP		= (1 << 7),
+
+	NV_SWNCQ_IRQ_HOTPLUG		= NV_SWNCQ_IRQ_ADDED |
+					  NV_SWNCQ_IRQ_REMOVED,
+
 };
 
 /* ADMA Physical Region Descriptor - one SG segment */
@@ -226,6 +255,37 @@ struct nv_host_priv {
 	unsigned long		type;
 };
 
+struct defer_queue {
+	u32		defer_bits;
+	unsigned int	head;
+	unsigned int	tail;
+	unsigned int	tag[ATA_MAX_QUEUE];
+};
+
+struct nv_swncq_port_priv {
+	struct ata_prd	*prd;	 /* our SG list */
+	dma_addr_t	prd_dma; /* and its DMA mapping */
+	void __iomem	*sactive_block;
+	void __iomem	*irq_block;
+	void __iomem	*tag_block;
+	u32		qc_active;
+	unsigned int	last_issue_tag;
+	spinlock_t	lock;
+	/* fifo circular queue to store deferral command */
+	struct defer_queue defer_queue;
+
+	/* for NCQ interrupt analysis */
+	u32		dhfis_bits;
+	u32		dmafis_bits;
+	u32		sdbfis_bits;
+
+	unsigned int	ncq_saw_d2h:1;
+	unsigned int	ncq_saw_dmas:1;
+	unsigned int	ncq_saw_sdb:1;
+	unsigned int 	ncq_saw_backout:1;
+};
+
+
 #define NV_ADMA_CHECK_INTR(GCTL, PORT) ((GCTL) & ( 1 << (19 + (12 * (PORT)))))
 
 static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
@@ -263,13 +323,29 @@ static void nv_adma_host_stop(struct ata
 static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc);
 static void nv_adma_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
 
+static void nv_mcp55_thaw(struct ata_port *ap);
+static void nv_mcp55_freeze(struct ata_port *ap);
+static void nv_swncq_error_handler(struct ata_port *ap);
+static int nv_swncq_slave_config(struct scsi_device *sdev);
+static int nv_swncq_port_start(struct ata_port *ap);
+static void nv_swncq_qc_prep(struct ata_queued_cmd *qc);
+static void nv_swncq_fill_sg(struct ata_queued_cmd *qc);
+static unsigned int nv_swncq_qc_issue(struct ata_queued_cmd *qc);
+static void nv_swncq_irq_clear(struct ata_port *ap, u16 fis);
+static irqreturn_t nv_swncq_interrupt(int irq, void *dev_instance);
+#ifdef CONFIG_PM
+static int nv_swncq_port_suspend(struct ata_port *ap, pm_message_t mesg);
+static int nv_swncq_port_resume(struct ata_port *ap);
+#endif
+
 enum nv_host_type
 {
 	GENERIC,
 	NFORCE2,
 	NFORCE3 = NFORCE2,	/* NF2 == NF3 as far as sata_nv is concerned */
 	CK804,
-	ADMA
+	ADMA,
+	SWNCQ
 };
 
 static const struct pci_device_id nv_pci_tbl[] = {
@@ -280,13 +356,13 @@ static const struct pci_device_id nv_pci
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_CK804_SATA2), CK804 },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_SATA), CK804 },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_SATA2), CK804 },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA), GENERIC },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2), GENERIC },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA), GENERIC },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2), GENERIC },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA), GENERIC },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2), GENERIC },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3), GENERIC },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3), SWNCQ },
 
 	{ } /* terminate list */
 };
@@ -339,6 +415,25 @@ static struct scsi_host_template nv_adma
 	.bios_param		= ata_std_bios_param,
 };
 
+static struct scsi_host_template nv_swncq_sht = {
+	.module			= THIS_MODULE,
+	.name			= DRV_NAME,
+	.ioctl			= ata_scsi_ioctl,
+	.queuecommand		= ata_scsi_queuecmd,
+	.change_queue_depth	= ata_scsi_change_queue_depth,
+	.can_queue		= ATA_MAX_QUEUE,
+	.this_id		= ATA_SHT_THIS_ID,
+	.sg_tablesize		= LIBATA_MAX_PRD,
+	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
+	.emulated		= ATA_SHT_EMULATED,
+	.use_clustering		= ATA_SHT_USE_CLUSTERING,
+	.proc_name		= DRV_NAME,
+	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.slave_configure	= nv_swncq_slave_config,
+	.slave_destroy		= ata_scsi_slave_destroy,
+	.bios_param		= ata_std_bios_param,
+};
+
 static const struct ata_port_operations nv_generic_ops = {
 	.tf_load		= ata_tf_load,
 	.tf_read		= ata_tf_read,
@@ -443,6 +538,36 @@ static const struct ata_port_operations 
 	.host_stop		= nv_adma_host_stop,
 };
 
+static const struct ata_port_operations nv_swncq_ops = {
+	.port_disable		= ata_port_disable,
+	.tf_load		= ata_tf_load,
+	.tf_read		= ata_tf_read,
+	.exec_command		= ata_exec_command,
+	.check_status		= ata_check_status,
+	.dev_select		= ata_std_dev_select,
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
+	.qc_prep		= nv_swncq_qc_prep,
+	.qc_issue		= nv_swncq_qc_issue,
+	.freeze			= nv_mcp55_freeze,
+	.thaw			= nv_mcp55_thaw,
+	.error_handler		= nv_swncq_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.data_xfer		= ata_data_xfer,
+	.irq_clear		= ata_bmdma_irq_clear,
+	.irq_on			= ata_irq_on,
+	.irq_ack		= ata_irq_ack,
+	.scr_read		= nv_scr_read,
+	.scr_write		= nv_scr_write,
+#ifdef CONFIG_PM
+	.port_suspend		= nv_swncq_port_suspend,
+	.port_resume		= nv_swncq_port_resume,
+#endif
+	.port_start		= nv_swncq_port_start,
+};
+
 static const struct ata_port_info nv_port_info[] = {
 	/* generic */
 	{
@@ -489,6 +614,17 @@ static const struct ata_port_info nv_por
 		.port_ops	= &nv_adma_ops,
 		.irq_handler	= nv_adma_interrupt,
 	},
+	/* SWNCQ */
+	{
+		.sht		= &nv_swncq_sht,
+		.flags	        = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_HRST_TO_RESUME,
+		.pio_mask	= NV_PIO_MASK,
+		.mwdma_mask	= NV_MWDMA_MASK,
+		.udma_mask	= NV_UDMA_MASK,
+		.port_ops	= &nv_swncq_ops,
+		.irq_handler	= nv_swncq_interrupt,
+	},
 };
 
 MODULE_AUTHOR("NVIDIA");
@@ -498,6 +634,7 @@ MODULE_DEVICE_TABLE(pci, nv_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
 static int adma_enabled = 1;
+static int swncq_enabled;
 
 static void nv_adma_register_mode(struct ata_port *ap)
 {
@@ -1451,6 +1588,34 @@ static void nv_ck804_thaw(struct ata_por
 	writeb(mask, mmio_base + NV_INT_ENABLE_CK804);
 }
 
+static void nv_mcp55_freeze(struct ata_port *ap)
+{
+	void __iomem *mmio_base = ap->host->iomap[NV_MMIO_BAR];
+	int shift = ap->port_no * NV_INT_PORT_SHIFT_MCP55;
+	u32 mask;
+
+	writel(NV_INT_ALL_MCP55 << shift, mmio_base + NV_INT_STATUS_MCP55);
+
+	mask = readl(mmio_base + NV_INT_ENABLE_MCP55);
+	mask &= ~(NV_INT_ALL_MCP55 << shift);
+	writel(mask, mmio_base + NV_INT_ENABLE_MCP55);
+	ata_bmdma_freeze(ap);
+}
+
+static void nv_mcp55_thaw(struct ata_port *ap)
+{
+	void __iomem *mmio_base = ap->host->iomap[NV_MMIO_BAR];
+	int shift = ap->port_no * NV_INT_PORT_SHIFT_MCP55;
+	u32 mask;
+
+	writel(NV_INT_ALL_MCP55 << shift, mmio_base + NV_INT_STATUS_MCP55);
+
+	mask = readl(mmio_base + NV_INT_ENABLE_MCP55);
+	mask |= (NV_INT_MASK_MCP55 << shift);
+	writel(mask, mmio_base + NV_INT_ENABLE_MCP55);
+	ata_bmdma_thaw(ap);
+}
+
 static int nv_hardreset(struct ata_link *link, unsigned int *class,
 			unsigned long deadline)
 {
@@ -1524,6 +1689,678 @@ static void nv_adma_error_handler(struct
 			   nv_hardreset, ata_std_postreset);
 }
 
+static void nv_swncq_qc_to_dq(struct ata_port *ap, struct ata_queued_cmd *qc)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	struct defer_queue *dq = &pp->defer_queue;
+
+	/* queue is full */
+	WARN_ON(dq->tail - dq->head == ATA_MAX_QUEUE);
+	dq->defer_bits |= (1 << qc->tag);
+	dq->tag[dq->tail++ & (ATA_MAX_QUEUE - 1)] = qc->tag;
+}
+
+static struct ata_queued_cmd *nv_swncq_qc_from_dq(struct ata_port *ap)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	struct defer_queue *dq = &pp->defer_queue;
+	unsigned int tag;
+
+	if (dq->head == dq->tail)	/* null queue */
+		return NULL;
+
+	tag = dq->tag[dq->head & (ATA_MAX_QUEUE - 1)];
+	dq->tag[dq->head++ & (ATA_MAX_QUEUE - 1)] = ATA_TAG_POISON;
+	WARN_ON(!(dq->defer_bits & (1 << tag)));
+	dq->defer_bits &= ~(1 << tag);
+
+	return ata_qc_from_tag(ap, tag);
+}
+
+static void nv_swncq_bmdma_stop(struct ata_port *ap)
+{
+	/* clear start/stop bit */
+	iowrite8(ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD) & ~ATA_DMA_START,
+		 ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+	ata_altstatus(ap);
+}
+
+static void nv_swncq_fis_reinit(struct ata_port *ap)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+
+	pp->dhfis_bits = 0;
+	pp->dmafis_bits = 0;
+	pp->sdbfis_bits = 0;
+	pp->ncq_saw_d2h = 0;
+	pp->ncq_saw_dmas = 0;
+	pp->ncq_saw_sdb = 0;
+	pp->ncq_saw_backout = 0;
+}
+
+static void nv_swncq_pp_reinit(struct ata_port *ap)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	struct defer_queue *dq = &pp->defer_queue;
+
+	dq->head = dq->tail = 0;
+	dq->defer_bits = 0;
+	pp->qc_active = 0;
+	pp->last_issue_tag = ATA_TAG_POISON;
+	nv_swncq_fis_reinit(ap);
+}
+
+static void nv_swncq_irq_clear(struct ata_port *ap, u16 fis)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+
+	writew(fis, pp->irq_block);
+}
+
+static void nv_swncq_ncq_stop(struct ata_port *ap)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	unsigned int i;
+	u32 sactive;
+	u32 done_mask;
+
+	ata_port_printk(ap, KERN_ERR,
+			"EH in SWNCQ mode,QC:qc_active 0x%X sactive 0x%X\n",
+			ap->qc_active, ap->sactive);
+	ata_port_printk(ap, KERN_ERR,
+		"SWNCQ:qc_active 0x%X defer_bits 0x%X last_issue_tag 0x%x\n  "
+		"dhfis 0x%X dmafis 0x%X sdbfis 0x%X\n",
+		pp->qc_active, pp->defer_queue.defer_bits, pp->last_issue_tag,
+		pp->dhfis_bits, pp->dmafis_bits, pp->sdbfis_bits);
+
+	ata_port_printk(ap, KERN_ERR, "ATA_REG 0x%X ERR_REG 0x%X\n",
+			ap->ops->check_status(ap),
+			ioread8(ap->ioaddr.error_addr));
+
+	sactive = readl(pp->sactive_block);
+	done_mask = pp->qc_active ^ sactive;
+
+	ata_port_printk(ap, KERN_ERR, "tag : dhfis dmafis sdbfis sacitve\n");
+	for (i = 0; i < ATA_MAX_QUEUE; i++) {
+		u8 err = 0;
+		if (pp->qc_active & (1 << i))
+			err = 0;
+		else if (done_mask & (1 << i))
+			err = 1;
+		else
+			continue;
+
+		ata_port_printk(ap, KERN_ERR,
+				"tag 0x%x: %01x %01x %01x %01x %s\n", i,
+				(pp->dhfis_bits >> i) & 0x1,
+				(pp->dmafis_bits >> i) & 0x1,
+				(pp->sdbfis_bits >> i) & 0x1,
+				(sactive >> i) & 0x1,
+				(err ? "error! tag doesn't exit" : " "));
+	}
+
+	nv_swncq_pp_reinit(ap);
+	ap->ops->irq_clear(ap);
+	nv_swncq_bmdma_stop(ap);
+	nv_swncq_irq_clear(ap, 0xffff);
+}
+
+static void nv_swncq_error_handler(struct ata_port *ap)
+{
+	struct ata_eh_context *ehc = &ap->eh_context;
+
+	if (ap->sactive) {
+		nv_swncq_ncq_stop(ap);
+		ehc->i.action |= ATA_EH_HARDRESET;
+	}
+
+	ata_bmdma_drive_eh(ap, ata_std_prereset, ata_std_softreset,
+			   nv_hardreset, ata_std_postreset);
+}
+
+#ifdef CONFIG_PM
+static int nv_swncq_port_suspend(struct ata_port *ap, pm_message_t mesg)
+{
+	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
+	u32 tmp;
+
+	/* clear irq */
+	writel(~0, mmio + NV_INT_STATUS_MCP55);
+
+	if (!(ap->flags & ATA_FLAG_NCQ))
+		return 0;
+
+	/* disable irq */
+	writel(0, mmio + NV_INT_ENABLE_MCP55);
+
+	/* disable swncq */
+	tmp = readl(mmio + NV_CTL_MCP55);
+	tmp &= ~(NV_CTL_PRI_SWNCQ | NV_CTL_SEC_SWNCQ);
+	writel(tmp, mmio + NV_CTL_MCP55);
+
+	return 0;
+}
+
+static int nv_swncq_port_resume(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
+	u32 tmp;
+
+	/* clear irq */
+	writel(~0, mmio + NV_INT_STATUS_MCP55);
+
+	if (!(ap->flags & ATA_FLAG_NCQ))
+		return 0;
+
+	/* enable irq */
+	writel(0x00fd00fd, mmio + NV_INT_ENABLE_MCP55);
+
+	/* enable swncq */
+	tmp = readl(mmio + NV_CTL_MCP55);
+	writel(tmp | NV_CTL_PRI_SWNCQ | NV_CTL_SEC_SWNCQ, mmio + NV_CTL_MCP55);
+
+	return 0;
+}
+#endif
+
+static void nv_swncq_host_init(struct ata_host *host)
+{
+	u32 tmp;
+	void __iomem *mmio = host->iomap[NV_MMIO_BAR];
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	u8 regval;
+	unsigned int i;
+
+	/* disable  ECO 398 */
+	pci_read_config_byte(pdev, 0x7f, &regval);
+	regval &= ~(1 << 7);
+	pci_write_config_byte(pdev, 0x7f, regval);
+
+	/* enable swncq */
+	tmp = readl(mmio + NV_CTL_MCP55);
+	VPRINTK("HOST_CTL:0x%X\n", tmp);
+	writel(tmp | NV_CTL_PRI_SWNCQ | NV_CTL_SEC_SWNCQ, mmio + NV_CTL_MCP55);
+
+	for (i = 0; i < host->n_ports; i++)
+		host->ports[i]->flags |= ATA_FLAG_NCQ;
+
+	/* enable irq intr */
+	tmp = readl(mmio + NV_INT_ENABLE_MCP55);
+	VPRINTK("HOST_ENABLE:0x%X\n", tmp);
+	writel(tmp | 0x00fd00fd, mmio + NV_INT_ENABLE_MCP55);
+
+	/*  clear port irq */
+	writel(~0x0, mmio + NV_INT_STATUS_MCP55);
+}
+
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
+{
+	struct device *dev = ap->host->dev;
+	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
+	struct nv_swncq_port_priv *pp;
+	int rc;
+
+	rc = ata_port_start(ap);
+	if (rc)
+		return rc;
+
+	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
+	if (!pp)
+		return -ENOMEM;
+
+	pp->prd = dmam_alloc_coherent(dev, ATA_PRD_TBL_SZ * ATA_MAX_QUEUE,
+				      &pp->prd_dma, GFP_KERNEL);
+	if (!pp->prd)
+		return -ENOMEM;
+	memset(pp->prd, 0, ATA_PRD_TBL_SZ * ATA_MAX_QUEUE);
+
+	ap->private_data = pp;
+	pp->sactive_block = ap->ioaddr.scr_addr + 4 * SCR_ACTIVE;
+	pp->irq_block = mmio + NV_INT_STATUS_MCP55 + ap->port_no * 2;
+	pp->tag_block = mmio + NV_NCQ_REG_MCP55 + ap->port_no * 2;
+	spin_lock_init(&pp->lock);
+
+	return 0;
+}
+
+static void nv_swncq_qc_prep(struct ata_queued_cmd *qc)
+{
+	if (qc->tf.protocol != ATA_PROT_NCQ) {
+		ata_qc_prep(qc);
+		return;
+	}
+
+	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
+		return;
+
+	nv_swncq_fill_sg(qc);
+}
+
+static void nv_swncq_fill_sg(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct scatterlist *sg;
+	unsigned int idx;
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	struct ata_prd *prd;
+
+	WARN_ON(qc->__sg == NULL);
+	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+
+	prd = pp->prd + ATA_MAX_PRD * qc->tag;
+
+	idx = 0;
+	ata_for_each_sg(sg, qc) {
+		u32 addr, offset;
+		u32 sg_len, len;
+
+		addr = (u32)sg_dma_address(sg);
+		sg_len = sg_dma_len(sg);
+
+		while (sg_len) {
+			offset = addr & 0xffff;
+			len = sg_len;
+			if ((offset + sg_len) > 0x10000)
+				len = 0x10000 - offset;
+
+			prd[idx].addr = cpu_to_le32(addr);
+			prd[idx].flags_len = cpu_to_le32(len & 0xffff);
+
+			idx++;
+			sg_len -= len;
+			addr += len;
+		}
+	}
+
+	if (idx)
+		prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+}
+
+static unsigned int nv_swncq_issue_atacmd(struct ata_port *ap,
+					  struct ata_queued_cmd *qc)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+
+	if (qc == NULL)
+		return 0;
+
+	DPRINTK("Enter\n");
+
+	writel((1 << qc->tag), pp->sactive_block);
+	pp->last_issue_tag = qc->tag;
+	pp->dhfis_bits &= ~(1 << qc->tag);
+	pp->dmafis_bits &= ~(1 << qc->tag);
+	pp->qc_active |= (0x1 << qc->tag);
+
+	ap->ops->tf_load(ap, &qc->tf);	 /* load tf registers */
+	ap->ops->exec_command(ap, &qc->tf);
+
+	DPRINTK("Issued tag %u\n", qc->tag);
+
+	return 0;
+}
+
+static unsigned int nv_swncq_qc_issue(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	unsigned long flags;
+
+	if (qc->tf.protocol != ATA_PROT_NCQ)
+		return ata_qc_issue_prot(qc);
+
+	DPRINTK("Enter\n");
+	spin_lock_irqsave(&pp->lock, flags);
+	if (!pp->qc_active)
+		nv_swncq_issue_atacmd(ap, qc);
+	else
+		nv_swncq_qc_to_dq(ap, qc);	/* add qc to defer queue */
+	spin_unlock_irqrestore(&pp->lock, flags);
+	return 0;
+}
+
+static void nv_swncq_hotplug(struct ata_port *ap, u32 fis)
+{
+	u32 serror;
+	struct ata_eh_info *ehi = &ap->eh_info;
+
+	ata_ehi_clear_desc(ehi);
+
+	/* AHCI needs SError cleared; otherwise, it might lock up */
+	sata_scr_read(ap, SCR_ERROR, &serror);
+	sata_scr_write(ap, SCR_ERROR, serror);
+
+	/* analyze @irq_stat */
+	if (fis & NV_SWNCQ_IRQ_ADDED)
+		ata_ehi_push_desc(ehi, "hot plug");
+	else if (fis & NV_SWNCQ_IRQ_REMOVED)
+		ata_ehi_push_desc(ehi, "hot unplug");
+
+	ata_ehi_hotplugged(ehi);
+
+	/* okay, let's hand over to EH */
+	ehi->serror |= serror;
+
+	ata_port_freeze(ap);
+}
+
+static int nv_swncq_sdbfis(struct ata_port *ap)
+{
+	struct ata_queued_cmd *qc;
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	struct ata_eh_info *ehi = &ap->eh_info;
+	u32 sactive;
+	int nr_done = 0;
+	u32 done_mask;
+	int i;
+	u8 host_stat;
+	u8 lack_dhfis = 0;
+
+	host_stat = ap->ops->bmdma_status(ap);
+	if (unlikely(host_stat & ATA_DMA_ERR)) {
+		/* error when transfering data to/from memory */
+		ata_ehi_clear_desc(ehi);
+		ata_ehi_push_desc(ehi, "BMDMA stat 0x%x", host_stat);
+		ehi->err_mask |= AC_ERR_HOST_BUS;
+		ehi->action |= ATA_EH_SOFTRESET;
+		return -EINVAL;
+	}
+
+	ap->ops->irq_clear(ap);
+	nv_swncq_bmdma_stop(ap);
+
+	sactive = readl(pp->sactive_block);
+	done_mask = pp->qc_active ^ sactive;
+
+	if (unlikely(done_mask & sactive)) {
+		ata_ehi_clear_desc(ehi);
+		ata_ehi_push_desc(ehi, "illegal SWNCQ:qc_active transition"
+				  "(%08x->%08x)", pp->qc_active, sactive);
+		ehi->err_mask |= AC_ERR_HSM;
+		ehi->action |= ATA_EH_HARDRESET;
+		return -EINVAL;
+	}
+	for (i = 0; i < ATA_MAX_QUEUE; i++) {
+		if (!(done_mask & (1 << i)))
+			continue;
+
+		qc = ata_qc_from_tag(ap, i);
+		if (qc) {
+			ata_qc_complete(qc);
+			pp->qc_active &= ~(1 << i);
+			pp->dhfis_bits &= ~(1 << i);
+			pp->dmafis_bits &= ~(1 << i);
+			pp->sdbfis_bits |= (1 << i);
+			nr_done++;
+		}
+	}
+
+	if (!ap->qc_active) {
+		DPRINTK("over\n");
+		nv_swncq_pp_reinit(ap);
+		return nr_done;
+	}
+
+	if (pp->qc_active & pp->dhfis_bits)
+		return nr_done;
+
+	if (pp->ncq_saw_backout || (pp->qc_active ^ pp->dhfis_bits))
+		/* if the controller cann't get a device to host register FIS,
+		 * The driver needs to reissue the new command.
+		 */
+		lack_dhfis = 1;
+
+	DPRINTK("id 0x%x QC: qc_active 0x%x,"
+		"SWNCQ:qc_active 0x%X defer_bits %X "
+		"dhfis 0x%X dmafis 0x%X last_issue_tag %x\n",
+		ap->print_id, ap->qc_active, pp->qc_active,
+		pp->defer_queue.defer_bits, pp->dhfis_bits,
+		pp->dmafis_bits, pp->last_issue_tag);
+
+	nv_swncq_fis_reinit(ap);
+
+	if (lack_dhfis) {
+		qc = ata_qc_from_tag(ap, pp->last_issue_tag);
+		nv_swncq_issue_atacmd(ap, qc);
+		return nr_done;
+	}
+
+	if (pp->defer_queue.defer_bits) {
+		/* send deferral queue command */
+		qc = nv_swncq_qc_from_dq(ap);
+		WARN_ON(qc == NULL);
+		nv_swncq_issue_atacmd(ap, qc);
+	}
+
+	return nr_done;
+}
+
+static inline u32 nv_swncq_tag(struct ata_port *ap)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	u32 tag;
+
+	tag = readb(pp->tag_block) >> 2;
+	return (tag & 0x1f);
+}
+
+static int nv_swncq_dmafis(struct ata_port *ap)
+{
+	struct ata_queued_cmd *qc;
+	unsigned int rw;
+	u8 dmactl;
+	u32 tag;
+	struct nv_swncq_port_priv *pp = ap->private_data;
+
+	nv_swncq_bmdma_stop(ap);
+	tag = nv_swncq_tag(ap);
+
+	DPRINTK("dma setup tag 0x%x\n", tag);
+	qc = ata_qc_from_tag(ap, tag);
+
+	if (unlikely(!qc))
+		return 0;
+
+	rw = qc->tf.flags & ATA_TFLAG_WRITE;
+
+	/* load PRD table addr. */
+	iowrite32(pp->prd_dma + ATA_PRD_TBL_SZ * qc->tag,
+		  ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
+
+	/* specify data direction, triple-check start bit is clear */
+	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+	dmactl &= ~ATA_DMA_WR;
+	if (!rw)
+		dmactl |= ATA_DMA_WR;
+
+	iowrite8(dmactl | ATA_DMA_START, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+
+	return 1;
+}
+
+static void nv_swncq_host_interrupt(struct ata_port *ap, u16 fis)
+{
+	struct nv_swncq_port_priv *pp = ap->private_data;
+	struct ata_queued_cmd *qc;
+	struct ata_eh_info *ehi = &ap->eh_info;
+	u32 serror;
+	u8 ata_stat;
+	int rc = 0;
+
+	ata_stat = ap->ops->check_status(ap);
+	nv_swncq_irq_clear(ap, fis);
+	if (!fis)
+		return;
+
+	if (ap->pflags & ATA_PFLAG_FROZEN)
+		return;
+
+	if (fis & NV_SWNCQ_IRQ_HOTPLUG) {
+		nv_swncq_hotplug(ap, fis);
+		return;
+	}
+
+	if (!pp->qc_active)
+		return;
+
+	if (ap->ops->scr_read(ap, SCR_ERROR, &serror))
+		return;
+	ap->ops->scr_write(ap, SCR_ERROR, serror);
+
+	if (ata_stat & ATA_ERR) {
+		ata_ehi_clear_desc(ehi);
+		ata_ehi_push_desc(ehi, "Ata error. fis:0x%X", fis);
+		ehi->err_mask |= AC_ERR_DEV;
+		ehi->serror |= serror;
+		ehi->action |= ATA_EH_SOFTRESET;
+		ata_port_freeze(ap);
+		return;
+	}
+
+	spin_lock(&pp->lock);
+	if (fis & NV_SWNCQ_IRQ_BACKOUT) {
+		/* If the IRQ is backout, driver must issue
+		 * the new command again some time later.
+		 */
+		pp->ncq_saw_backout = 1;
+	}
+
+	if (fis & NV_SWNCQ_IRQ_SDBFIS) {
+		pp->ncq_saw_sdb = 1;
+		DPRINTK("id 0x%x SWNCQ: qc_active 0x%X "
+			"dhfis 0x%X dmafis 0x%X sactive 0x%X\n",
+			ap->print_id, pp->qc_active, pp->dhfis_bits,
+			pp->dmafis_bits, readl(pp->sactive_block));
+		rc = nv_swncq_sdbfis(ap);
+		if (rc < 0)
+			goto irq_error;
+	}
+
+	if (fis & NV_SWNCQ_IRQ_DHREGFIS) {
+		/* The interrupt indicates the new command
+		 * was transmitted correctly to the drive.
+		 */
+		pp->dhfis_bits |= (0x1 << pp->last_issue_tag);
+		pp->ncq_saw_d2h = 1;
+		if (pp->ncq_saw_sdb || pp->ncq_saw_backout) {
+			ata_ehi_push_desc(ehi, "illegal fis transaction");
+			ehi->err_mask |= AC_ERR_HSM;
+			ehi->action |= ATA_EH_HARDRESET;
+			goto irq_error;
+		}
+
+		if (!(fis & NV_SWNCQ_IRQ_DMASETUP) && !pp->ncq_saw_dmas) {
+			ata_stat = ap->ops->check_status(ap);
+			if (ata_stat & ATA_BUSY)
+				goto irq_exit;
+
+			if (pp->defer_queue.defer_bits) {
+				DPRINTK("send next command\n");
+				qc = nv_swncq_qc_from_dq(ap);
+				nv_swncq_issue_atacmd(ap, qc);
+			}
+		}
+	}
+
+	if (fis & NV_SWNCQ_IRQ_DMASETUP) {
+		/* program the dma controller with appropriate PRD buffers
+		 * and start the DMA transfer for requested command.
+		 */
+		pp->dmafis_bits |= (0x1 << nv_swncq_tag(ap));
+		pp->ncq_saw_dmas = 1;
+		rc = nv_swncq_dmafis(ap);
+	}
+
+irq_exit:
+	spin_unlock(&pp->lock);
+	return;
+irq_error:
+	ata_ehi_push_desc(ehi, "fis:0x%x", fis);
+	ata_port_freeze(ap);
+	spin_unlock(&pp->lock);
+	return;
+}
+
+static irqreturn_t nv_swncq_interrupt(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	unsigned int i;
+	unsigned int handled = 0;
+	unsigned long flags;
+	u32 irq_stat;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	irq_stat = readl(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_MCP55);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		if (ap && !(ap->flags & ATA_FLAG_DISABLED)) {
+			if (ap->sactive) {
+				nv_swncq_host_interrupt(ap, (u16)irq_stat);
+				handled = 1;
+			} else {
+				if (irq_stat)	/* reserve Hotplug */
+					nv_swncq_irq_clear(ap, 0xfff0);
+
+				handled += nv_host_intr(ap, (u8)irq_stat);
+			}
+		}
+		irq_stat >>= NV_INT_PORT_SHIFT_MCP55;
+	}
+
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	return IRQ_RETVAL(handled);
+}
+
 static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version = 0;
@@ -1550,7 +2387,7 @@ static int nv_init_one (struct pci_dev *
 		return rc;
 
 	/* determine type and allocate host */
-	if (type >= CK804 && adma_enabled) {
+	if (type == CK804 && adma_enabled) {
 		dev_printk(KERN_NOTICE, &pdev->dev, "Using ADMA mode\n");
 		type = ADMA;
 	}
@@ -1596,6 +2433,9 @@ static int nv_init_one (struct pci_dev *
 		rc = nv_adma_host_init(host);
 		if (rc)
 			return rc;
+	} else if (type == SWNCQ && swncq_enabled) {
+		dev_printk(KERN_NOTICE, &pdev->dev, "Using SWNCQ mode\n");
+		nv_swncq_host_init(host);
 	}
 
 	pci_set_master(pdev);
@@ -1695,3 +2535,6 @@ module_init(nv_init);
 module_exit(nv_exit);
 module_param_named(adma, adma_enabled, bool, 0444);
 MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: true)");
+module_param_named(swncq, swncq_enabled, bool, 0444);
+MODULE_PARM_DESC(swncq, "Enable use of SWNCQ (Default: false)");
+
_

Patches currently in -mm which might be from kluo@nvidia.com are

ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch

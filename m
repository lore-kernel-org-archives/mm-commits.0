From: akpm@linux-foundation.org
Subject: - drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch removed from -mm tree
Date: Mon, 25 Jun 2007 18:58:49 -0700
Message-ID: <200706260158.l5Q1wnCR016041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51837 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbXFZB7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 21:59:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pchen@nvidia.com, htejun@gmail.com, jeff@garzik.org, kluo@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     drivers/ata: add SW NCQ support to sata_nv for MCP51/MCP55/MCP61
has been removed from the -mm tree.  Its filename was
     drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: drivers/ata: add SW NCQ support to sata_nv for MCP51/MCP55/MCP61
From: "Peer Chen" <pchen@nvidia.com>

[akpm@linux-foundation.org: fix warning, lots of cleanups]
Signed-off-by: Kuan Luo <kluo@nvidia.com>
Signed-off-by: Peer Chen <pchen@nvidia.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c | 1066 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 1054 insertions(+), 12 deletions(-)

diff -puN drivers/ata/sata_nv.c~drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61 drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61
+++ a/drivers/ata/sata_nv.c
@@ -46,6 +46,8 @@
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <linux/libata.h>
 
 #define DRV_NAME			"sata_nv"
@@ -169,6 +171,36 @@ enum {
 	NV_ADMA_PORT_REGISTER_MODE	= (1 << 0),
 	NV_ADMA_ATAPI_SETUP_COMPLETE	= (1 << 1),
 
+	/* MCP55 reg offset */
+	NV_CTL_MCP55			= 0x400,
+	NV_INT_STATUS_MCP55		= 0x440,
+	NV_INT_ENABLE_MCP55		= 0x444,
+	NV_NCQ_REG_MCP55		= 0x448,
+	NV_CH1_SACTIVE_MCP55		= 0x0C,
+
+	/* MCP55 */
+	NV_INT_ALL_MCP55		= 0xffff,
+	NV_INT_PORT_SHIFT_MCP55		= 16,	/* each port occupies 16 bits */
+	NV_INT_MASK_MCP55		= NV_INT_ALL_MCP55 & 0xfffd,
+
+	/* NCQ ENABLE BITS*/
+	NV_CTL_PRI_SWNCQ		= 0x02,
+	NV_CTL_SEC_SWNCQ		= 0x04,
+
+	/* MCP55 status bits*/
+	NV_INT_DEV_MCP55		= 0x01,
+	NV_INT_PM_MCP55			= 0x02,
+	NV_INT_ADDED_MCP55		= 0x04,
+	NV_INT_REMOVED_MCP55		= 0x08,
+
+ 	NV_INT_BACKOUT_MCP55		= 0x10,
+ 	NV_INT_SDBFIS_MCP55		= 0x20,
+ 	NV_INT_DHREGFIS_MCP55		= 0x40,
+	NV_INT_DMASETUP_MCP55		= 0x80,
+
+	NV_INT_HOTPLUG_MCP55		= (NV_INT_ADDED_MCP55 |
+						NV_INT_REMOVED_MCP55),
+
 };
 
 /* ADMA Physical Region Descriptor - one SG segment */
@@ -263,13 +295,118 @@ static void nv_adma_host_stop(struct ata
 static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc);
 static void nv_adma_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
 
+static void ncq_error_handler(struct ata_port *ap);
+static void nv_mcp55_thaw(struct ata_port *ap);
+static void nv_mcp55_freeze(struct ata_port *ap);
+static void ncq_host_init(struct ata_host *host);
+static void nv_bmdma_stop(struct ata_port *ap);
+static int nv_std_qc_defer(struct ata_port *ap);
+static int  nv_port_start(struct ata_port *ap);
+static void nv_port_stop(struct ata_port *ap);
+static void ncq_clear(struct ata_port *ap);
+static void nv_qc_prep(struct ata_queued_cmd *qc);
+static void nv_fill_sg(struct ata_queued_cmd *qc);
+static void ncq_sactive_start (struct ata_queued_cmd *qc);
+static u32 ncq_sactive_value (struct ata_port *ap);
+static unsigned int nv_qc_issue_prot(struct ata_queued_cmd *qc);
+static u32 ncq_tag_value(struct ata_port *ap);
+static int nv_ncqintr_sdbfis(struct ata_port *ap);
+static int nv_ncqintr_dmasetupfis(struct ata_port *ap);
+static void ncq_clear_singlefis(struct ata_port *ap, u32 val);
+static u32 ncq_ownfisintr_value (struct ata_port *ap);
+void ncq_hotplug(struct ata_port *ap, u32 fis);
+static irqreturn_t nv_mcp55_interrupt(int irq, void *dev_instance);
+static int ncq_interrupt(struct ata_port *ap, u32 fis);
+static int nv_scsi_queuecmd(struct scsi_cmnd *cmd,
+			    void (*done)(struct scsi_cmnd *));
+
+#undef NCQ_DEBUG
+#undef NCQ_VERBOSE_DEBUG
+#ifdef NCQ_DEBUG
+#define NPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#ifdef NCQ_VERBOSE_DEBUG
+#define NVPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#else
+#define NVPRINTK(fmt, args...) do { } while(0)
+#endif	/* NCQ_VERBOSE_DEBUG */
+#else
+#define NPRINTK(fmt, args...) do { } while(0)
+#define NVPRINTK(fmt, args...) do { } while(0)
+#endif
+
+/*    cmd_stop
+ |_byte 3__||__byte 2____||__byte 1___||__byte 0_____|
+
+byte0:the dma fis tag's value plus 1
+byte1: defer tag's value plus 1
+byte2: backout tag's value plus 1
+
+*/
+/* ncq operation */
+struct nv_port_priv {
+	struct ata_prd	*prd;	 /* our SG list */
+	dma_addr_t	prd_dma; /* and its DMA mapping */
+	u32		qc_active;
+	u8		current_tag;/* the last tag */
+	u32		dhfis_flags;/* each bit is responding to one cmd,
+					if receiving dh fis ,bit set one.*/
+	u8		retry;	/* the last cmd needed retry */
+	u32		cmd_stop;	/* stop sending cmd from upper layer.*/
+	u32		cmd_sended; /* debug info */
+	u32		defer_bits;
+ 	const	struct nv_ncq_operations	*ops;
+
+};
+
+struct  nv_ncq_operations{
+	void	(*bmdma_stop)(struct ata_port *ap);
+	void	(*sactive_start) (struct ata_queued_cmd *qc);
+	u32	(*sactive_value) (struct ata_port *ap);
+	u32	(*tag_value) (struct ata_port *ap);
+	u32	(*check_ownfis) (struct ata_port *ap);/* get the channel 's fis value */
+	void	(*clear_singlefis) (struct ata_port *ap,u32 flag);
+	int	(*qc_defer) (struct ata_port *ap);
+};
+
+static const struct nv_ncq_operations nv_ncq_ops = {
+	.bmdma_stop		= nv_bmdma_stop,
+	.sactive_start		= ncq_sactive_start,
+	.sactive_value		= ncq_sactive_value,
+	.tag_value		= ncq_tag_value,
+	.clear_singlefis	= ncq_clear_singlefis,
+	.qc_defer		= nv_std_qc_defer,
+	.check_ownfis		= ncq_ownfisintr_value ,
+};
+
+#define dma_byte(result) (((result) >> 0) & 0xff)
+#define defer_byte(result)    (((result) >> 8) & 0xff)
+#define back_byte(result)   (((result) >> 16) & 0xff)
+
+static inline void  set_dma_byte(struct nv_port_priv *pp, u8 val)
+{
+	pp->cmd_stop |= val + 1;
+}
+
+static inline void  set_defer_byte(struct nv_port_priv *pp, u8 val)
+{
+	pp->cmd_stop |= ((val + 1) << 8) ;
+}
+
+static inline void  set_back_byte(struct nv_port_priv *pp, u8 val)
+{
+	pp->cmd_stop |= ((val + 1) << 16);
+}
+
 enum nv_host_type
 {
 	GENERIC,
 	NFORCE2,
 	NFORCE3 = NFORCE2,	/* NF2 == NF3 as far as sata_nv is concerned */
 	CK804,
-	ADMA
+	ADMA,
+	MCP55,
+	MCP51 = MCP55,
+	MCP61 = MCP55
 };
 
 static const struct pci_device_id nv_pci_tbl[] = {
@@ -280,14 +417,13 @@ static const struct pci_device_id nv_pci
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
-
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA), MCP51 },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2), MCP51 },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA), MCP55 },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2),MCP55 },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA), MCP61 },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2), MCP61 },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3), MCP61 },
 	{ } /* terminate list */
 };
 
@@ -338,6 +474,24 @@ static struct scsi_host_template nv_adma
 	.bios_param		= ata_std_bios_param,
 };
 
+static struct scsi_host_template nv_sht_ncq = {
+	.module			= THIS_MODULE,
+	.name			= DRV_NAME,
+	.ioctl			= ata_scsi_ioctl,
+	.queuecommand		= nv_scsi_queuecmd,
+	.can_queue		= ATA_MAX_QUEUE - 1,
+	.this_id		= ATA_SHT_THIS_ID,
+	.sg_tablesize		= LIBATA_MAX_PRD,
+	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
+	.emulated		= ATA_SHT_EMULATED,
+	.use_clustering		= ATA_SHT_USE_CLUSTERING,
+	.proc_name		= DRV_NAME,
+	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.slave_configure	= ata_scsi_slave_config,
+	.slave_destroy		= ata_scsi_slave_destroy,
+	.bios_param		= ata_std_bios_param,
+};
+
 static const struct ata_port_operations nv_generic_ops = {
 	.port_disable		= ata_port_disable,
 	.tf_load		= ata_tf_load,
@@ -450,6 +604,33 @@ static const struct ata_port_operations 
 	.host_stop		= nv_adma_host_stop,
 };
 
+static const struct ata_port_operations nv_mcp55_ops = {
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
+	.qc_prep		= nv_qc_prep,
+	.qc_issue		= nv_qc_issue_prot,
+	.freeze			= nv_mcp55_freeze,
+	.thaw			= nv_mcp55_thaw,
+	.error_handler		= ncq_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.data_xfer		= ata_data_xfer,
+	.irq_clear		= ata_bmdma_irq_clear,
+	.irq_on			= ata_irq_on,
+	.irq_ack		= ata_irq_ack,
+	.scr_read		= nv_scr_read,
+	.scr_write		= nv_scr_write,
+	.port_start		= nv_port_start,
+	.port_stop		= nv_port_stop,
+};
+
 static const struct ata_port_info nv_port_info[] = {
 	/* generic */
 	{
@@ -496,6 +677,16 @@ static const struct ata_port_info nv_por
 		.port_ops	= &nv_adma_ops,
 		.irq_handler	= nv_adma_interrupt,
 	},
+	/* mcp55/61 */
+	{
+		.sht		= &nv_sht_ncq,
+		.flags	        = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY ,
+		.pio_mask	= NV_PIO_MASK,
+		.mwdma_mask	= NV_MWDMA_MASK,
+		.udma_mask	= NV_UDMA_MASK,
+		.port_ops	= &nv_mcp55_ops,
+		.irq_handler	= nv_mcp55_interrupt,
+	},
 };
 
 MODULE_AUTHOR("NVIDIA");
@@ -505,6 +696,7 @@ MODULE_DEVICE_TABLE(pci, nv_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
 static int adma_enabled = 1;
+static int ncq_enabled = 0;
 
 static void nv_adma_register_mode(struct ata_port *ap)
 {
@@ -760,6 +952,96 @@ static int nv_adma_check_cpb(struct ata_
 	return 0;
 }
 
+static struct ata_device * ata_find_dev(struct ata_port *ap, int id)
+{
+	if (likely(id < ATA_MAX_DEVICES))
+		return &ap->device[id];
+	return NULL;
+}
+
+static int ata_scsi_dev_enabled(struct ata_device *dev)
+{
+	if (unlikely(!ata_dev_enabled(dev)))
+		return 0;
+
+	if ((dev->ap->flags & ATA_FLAG_NO_ATAPI)) {
+		if (unlikely(dev->class == ATA_DEV_ATAPI)) {
+			ata_dev_printk(dev, KERN_WARNING,
+				       "WARNING: ATAPI is %s, device ignored.\n",
+				       1 ? "not supported with this driver" : "disabled");
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
+static struct ata_device * __ata_scsi_find_dev(struct ata_port *ap,
+					const struct scsi_device *scsidev)
+{
+	/* skip commands not addressed to targets we simulate */
+	if (unlikely(scsidev->channel || scsidev->lun))
+		return NULL;
+
+	return ata_find_dev(ap, scsidev->id);
+}
+
+static struct ata_device *
+ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev)
+{
+	struct ata_device *dev = __ata_scsi_find_dev(ap, scsidev);
+
+	if (unlikely(!dev || !ata_scsi_dev_enabled(dev)))
+		return NULL;
+
+	return dev;
+}
+
+static int nv_scsi_queuecmd(struct scsi_cmnd *cmd,
+			    void (*done)(struct scsi_cmnd *))
+{
+	struct ata_port *ap;
+	struct ata_device *dev;
+	struct scsi_device *scsidev = cmd->device;
+	struct Scsi_Host *shost = scsidev->host;
+	struct nv_port_priv *pp;
+	int rc = 0, flag = 0;
+
+	ap = ata_shost_to_port(shost);
+	pp = ap->private_data;
+	spin_unlock(shost->host_lock);
+	spin_lock(ap->lock);
+	dev = ata_scsi_find_dev(ap, scsidev);
+	if (likely(dev)) {
+		if (dev->class == ATA_DEV_ATA) {
+			switch (cmd->cmnd[0]) {
+				case READ_6:
+				case READ_10:
+				case READ_16:
+
+				case WRITE_6:
+				case WRITE_10:
+				case WRITE_16: 	flag=1;break;
+				default: 	flag=0;break;
+			}
+
+			if (flag && (dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ)) == ATA_DFLAG_NCQ)
+				rc = pp->ops->qc_defer(ap);
+		}
+	} else {
+		cmd->result = (DID_BAD_TARGET << 16);
+		done(cmd);
+	}
+
+	spin_unlock(ap->lock);
+	spin_lock(shost->host_lock);
+
+	if (rc)
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+	else
+		return ata_scsi_queuecmd(cmd,  done);
+}
+
 static int nv_host_intr(struct ata_port *ap, u8 irq_stat)
 {
 	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->active_tag);
@@ -1390,6 +1672,45 @@ static irqreturn_t nv_ck804_interrupt(in
 	return ret;
 }
 
+static irqreturn_t nv_mcp55_interrupt(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	struct nv_port_priv *pp ;
+	unsigned int i;
+	unsigned int handled = 0;
+	unsigned long flags;
+	u32 irq_stat;
+	spin_lock_irqsave(&host->lock, flags);
+
+	irq_stat = readl(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_MCP55);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		if (ap && !(ap->flags & ATA_FLAG_DISABLED) ) {
+			pp = ap->private_data;
+
+			if (pp->qc_active) {
+				handled += ncq_interrupt(ap, (irq_stat & 0xffff));
+			} else {
+
+				if (irq_stat)
+					pp->ops->clear_singlefis(ap, 0xfff0); //reserve Hotplug and INT intr
+
+				handled += nv_host_intr(ap, (u8)irq_stat);
+			}
+
+
+		}
+
+		irq_stat >>= NV_INT_PORT_SHIFT_MCP55;
+	}
+
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	return IRQ_RETVAL(handled);
+}
+
 static u32 nv_scr_read (struct ata_port *ap, unsigned int sc_reg)
 {
 	if (sc_reg > SCR_CONTROL)
@@ -1454,6 +1775,46 @@ static void nv_ck804_thaw(struct ata_por
 	writeb(mask, mmio_base + NV_INT_ENABLE_CK804);
 }
 
+static void nv_mcp55_freeze(struct ata_port *ap)
+{
+	void __iomem *mmio_base = ap->host->iomap[NV_MMIO_BAR];
+	int shift = ap->port_no * NV_INT_PORT_SHIFT_MCP55;
+	u32 mask;
+	u32 val;
+
+	if (ap->flags & ATA_FLAG_NCQ) {
+		val = readl(mmio_base + NV_CTL_MCP55);
+		val &= ~(NV_CTL_PRI_SWNCQ << ap->port_no);
+		writel(val, mmio_base + NV_CTL_MCP55);/* disable ncq */
+	}
+
+	writel(NV_INT_ALL_MCP55 << shift, mmio_base + NV_INT_STATUS_MCP55);
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
+	u32 val;
+
+	if (ap->flags & ATA_FLAG_NCQ) {
+		ncq_clear(ap);
+		val = readl(mmio_base + NV_CTL_MCP55);
+		val |= (NV_CTL_PRI_SWNCQ << ap->port_no);
+		writel(val, mmio_base + NV_CTL_MCP55);/* enable ncq */
+	}
+	writel(NV_INT_ALL_MCP55 << shift, mmio_base + NV_INT_STATUS_MCP55);
+	mask = readl(mmio_base + NV_INT_ENABLE_MCP55);
+	mask |= (NV_INT_MASK_MCP55 << shift);
+	writel(mask, mmio_base + NV_INT_ENABLE_MCP55);
+	ata_bmdma_thaw(ap);
+}
+
 static int nv_hardreset(struct ata_port *ap, unsigned int *class,
 			unsigned long deadline)
 {
@@ -1527,6 +1888,683 @@ static void nv_adma_error_handler(struct
 			   nv_hardreset, ata_std_postreset);
 }
 
+static void ncq_clear(struct ata_port *ap)
+{
+	struct nv_port_priv *pp = ap->private_data;
+
+	pp->dhfis_flags = 0;
+	pp->qc_active = 0;
+	pp->retry = 0;
+	pp->defer_bits = 0;
+	pp->cmd_stop = 0;
+	pp->cmd_sended = 0;
+	pp->current_tag = 0;
+}
+
+
+static void ncq_stop(struct ata_port *ap)
+{
+	struct nv_port_priv *pp = ap->private_data;
+	u32 serror, sstatus, sctl;
+
+	NPRINTK("shost->host_failed :%x shost->host_busy:%x \n",
+						ap->scsi_host->host_failed,
+						ap->scsi_host->host_busy);
+
+	NPRINTK("ap->qc_active:%x, pp->qc_active:%x defer_bits:%x cmd_stop:%x "
+					"current_tag:%x dhfis_flags:%x \n",
+							ap->qc_active,
+							pp->qc_active,
+							pp->defer_bits,
+							pp->cmd_stop,
+							pp->current_tag,
+							pp->dhfis_flags);
+
+	sata_scr_read(ap, SCR_ERROR, &serror);
+	sata_scr_read(ap, SCR_STATUS, &sstatus);
+	sata_scr_read(ap, SCR_CONTROL, &sctl);
+	NPRINTK("ata%u: SErr:0x%x SStat:0x%x SCtl:0x%x\n", ap->id, serror, sstatus, sctl);
+
+	pp->ops->bmdma_stop(ap);
+	pp->ops->clear_singlefis(ap, 0xffff);
+
+	ncq_clear(ap);
+}
+
+int nv_std_prereset(struct ata_port *ap, unsigned long deadline)
+{
+	struct ata_eh_context *ehc = &ap->eh_context;
+
+	if (ap->flags & ATA_FLAG_NCQ)
+		ehc->i.action |= ATA_EH_HARDRESET;
+
+	return ata_std_prereset(ap, deadline);
+}
+
+static void ncq_error_handler(struct ata_port *ap)
+{
+	u32 ncq_ctl, ncq_enable;
+	void __iomem *mmio =  ap->host->iomap[NV_MMIO_BAR];
+
+	ncq_stop(ap);
+	ata_bmdma_drive_eh(ap, nv_std_prereset, ata_std_softreset,
+				nv_hardreset, ata_std_postreset);
+
+	ncq_ctl = readl(mmio + NV_CTL_MCP55);
+	ncq_enable = readl(mmio + NV_INT_ENABLE_MCP55);
+	NPRINTK("ata%u: NCQ_CTL:%x, NCQ_ENABLE:%x\n", ap->id, ncq_ctl, ncq_enable);
+
+}
+
+static void ncq_host_init(struct ata_host *host)
+{
+	u32 flags;
+	void __iomem	*mmio = host->iomap[NV_MMIO_BAR];
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	u8 regval, rev;
+	unsigned int i;
+
+	/* enable bar 5 */
+	pci_read_config_byte(pdev, NV_MCP_SATA_CFG_20, &regval);
+	regval |= NV_MCP_SATA_CFG_20_SATA_SPACE_EN;
+	pci_write_config_byte(pdev, NV_MCP_SATA_CFG_20, regval);
+
+	pci_read_config_byte(pdev, 0x7f, &regval);
+	regval &= ~(1 << 7);
+	pci_write_config_byte(pdev, 0x7f, regval);
+
+	pci_read_config_byte(pdev, 0x08, &rev);
+
+	/* only support A02 and above for mcp55, all for mcp61.*/
+	if ((pdev->device == PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA ||
+	     pdev->device == PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2)
+		&&  rev < 0xa2)
+		return;
+
+	flags = readl(mmio + NV_CTL_MCP55);
+
+	/* enable ncq */
+	if(ncq_enabled){
+	writel(flags | NV_CTL_PRI_SWNCQ | NV_CTL_SEC_SWNCQ, mmio + NV_CTL_MCP55);
+
+	for (i = 0; i < host->n_ports; i++)
+	    host->ports[i]->flags |= ATA_FLAG_NCQ;
+
+	flags = readl(mmio + NV_INT_ENABLE_MCP55);
+	flags = (flags | 0x00fd00fd);
+	writel(flags, mmio + NV_INT_ENABLE_MCP55);
+	flags = readl(mmio + NV_INT_ENABLE_MCP55);
+	}
+
+	writel(~0x0, mmio + NV_INT_STATUS_MCP55);/*  clear intr status */
+}
+
+static void nv_bmdma_stop(struct ata_port *ap)
+{
+	if (ap->flags & ATA_FLAG_MMIO) {
+		void __iomem *mmio = ap->ioaddr.bmdma_addr;
+
+		/* clear start/stop bit */
+		writeb(readb(mmio + ATA_DMA_CMD) & ~ATA_DMA_START,
+			mmio + ATA_DMA_CMD);
+	} else {
+		/* clear start/stop bit */
+		iowrite8(ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD) & ~ATA_DMA_START,
+			ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+	}
+	ata_altstatus(ap);
+}
+
+/**
+*	nv_std_qc_defer
+*
+* RETURNS:
+* 1 defer, 0 no need defer
+*/
+
+static int nv_std_qc_defer(struct ata_port *ap)
+{
+	struct nv_port_priv *pp = ap->private_data;
+	u32 fis;
+
+	if (ap->qc_active == 0)
+		return 0;
+
+	if (ata_tag_valid(ap->active_tag))
+		return 1;
+
+	if (pp->cmd_stop)
+		return 1;
+
+	fis = pp->ops->check_ownfis(ap);
+
+	if (fis & NV_INT_DMASETUP_MCP55) {
+		if (!dma_byte(pp->cmd_stop))
+			set_dma_byte(pp, pp->ops->tag_value(ap));
+		return 1;
+	}
+
+	return 0;
+}
+
+static int  nv_port_start(struct ata_port *ap)
+{
+	struct device *dev = ap->host->dev;
+	struct nv_port_priv *pp;
+	int rc;
+
+	rc = ata_port_start(ap);
+	if (rc)
+		return rc;
+
+	pp = kzalloc(sizeof(*pp), GFP_KERNEL);
+	if (!pp) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
+	pp->prd = dma_alloc_coherent(dev, ATA_PRD_TBL_SZ*ATA_MAX_QUEUE, &pp->prd_dma, GFP_KERNEL);
+	if (!pp->prd) {
+		rc = -ENOMEM;
+		goto err_out_kfree;
+	}
+	pp->ops = &nv_ncq_ops;
+
+	ap->private_data = pp;
+
+	return 0;
+
+err_out_kfree:
+	kfree(pp);
+err_out:
+	return rc;
+}
+
+static void nv_port_stop(struct ata_port *ap)
+{
+	struct device *dev = ap->host->dev;
+	struct nv_port_priv *pp = ap->private_data;
+
+	ap->private_data = NULL;
+	dma_free_coherent(dev, ATA_PRD_TBL_SZ*ATA_MAX_QUEUE, pp->prd, pp->prd_dma);
+	kfree(pp);
+}
+
+static void nv_qc_prep(struct ata_queued_cmd *qc)
+{
+	if (qc->tf.protocol != ATA_PROT_NCQ)
+		return ata_qc_prep(qc);
+
+	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
+		return;
+
+	nv_fill_sg(qc);
+}
+
+static void nv_fill_sg(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct scatterlist *sg;
+	unsigned int idx;
+	struct nv_port_priv *pp = ap->private_data;
+	struct ata_prd *prd;
+
+	WARN_ON(qc->__sg == NULL);
+	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+
+	prd = (struct ata_prd*)((long)pp->prd + ATA_PRD_TBL_SZ*qc->tag);
+
+	idx = 0;
+	ata_for_each_sg(sg, qc) {
+		u32 addr, offset;
+		u32 sg_len, len;
+
+		/* determine if physical DMA addr spans 64K boundary.
+		 * Note h/w doesn't support 64-bit, so we unconditionally
+		 * truncate dma_addr_t to u32.
+		 */
+		addr = (u32) sg_dma_address(sg);
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
+static void ncq_sactive_start (struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
+
+	u32 base = NV_CH1_SACTIVE_MCP55 + ap->port_no * 0x40;
+	u32  sactive;
+
+	sactive = readl(mmio + base);
+	sactive  |= (1 << qc->tag);
+	writel(sactive, mmio + base);
+}
+
+static u32 ncq_sactive_value (struct ata_port *ap)
+{
+	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
+	u32 base = NV_CH1_SACTIVE_MCP55 + ap->port_no * 0x40;
+	u32  sactive;
+
+	sactive = readl(mmio + base);
+	return sactive;
+}
+
+static u32 ncq_ownfisintr_value (struct ata_port *ap)
+{
+	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
+	u32  value;
+
+	value = readl(mmio + NV_INT_STATUS_MCP55);
+	value = (value >> (ap->port_no * NV_INT_PORT_SHIFT_MCP55)) & 0xffff;
+
+	return value;
+}
+
+static void ncq_clear_singlefis(struct ata_port *ap, u32 val)
+{
+	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
+	u32  flags = (val << (ap->port_no * NV_INT_PORT_SHIFT_MCP55));
+
+	writel(flags, mmio + NV_INT_STATUS_MCP55);
+}
+
+static unsigned int nv_qc_issue_prot(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct nv_port_priv *pp = ap->private_data;
+	struct ata_taskfile	*tf = &(qc->tf);
+	struct ata_taskfile *ttf, rtf;
+	u32 fis, stat0, stat1;
+
+	ttf = &rtf;
+
+	if (qc->tf.protocol != ATA_PROT_NCQ)
+		return ata_qc_issue_prot(qc);
+
+	NPRINTK("ENTER NCQ\n");
+	stat0	= pp->ops->sactive_value(ap);
+	if (pp->retry) {
+		NPRINTK("id:0x%x RETRY: qc->tag:%x\n", ap->id, qc->tag);
+		goto retry_cmd;
+	}
+
+	stat1 = (stat0  | (1 << qc->tag));
+	fis = pp->ops->check_ownfis(ap);
+	if (stat0 > 0  && stat0 != stat1) {	/* new cmd */
+
+		if (fis & NV_INT_DMASETUP_MCP55) {
+			if (!dma_byte(pp->cmd_stop))
+				set_dma_byte(pp, pp->ops->tag_value(ap));
+			goto back_out;
+
+		}
+		if (fis & NV_INT_DHREGFIS_MCP55) {
+			ap->ops->check_status(ap);
+			ap->ops->irq_clear(ap); /* clear bm irq */
+			pp->ops->clear_singlefis(ap, NV_INT_DHREGFIS_MCP55 | NV_INT_DEV_MCP55);
+
+			/* each cmd generate one dhfis intr, otherwise error happens */
+			pp->dhfis_flags |= (0x1 << pp->current_tag);
+		}
+
+
+		if (pp->dhfis_flags != pp->qc_active)
+		/* queue have cmd,but dhfis don't generate intr
+		 * stat0!=stat1 indicates the cmd isn't a retry cmd.
+		 */
+			goto back_out;
+	}
+
+retry_cmd:
+	pp->ops->sactive_start(qc);
+	stat1 = pp->ops->sactive_value(ap);
+
+	NVPRINTK("id:0x%x sactive stat0:%x, stat1:%x tag:%x \n", ap->id, stat0, stat1, qc->tag);
+	pp->current_tag = qc->tag;
+
+	ap->ops->tf_load(ap, &qc->tf);	 /* load tf registers */
+	ap->ops->exec_command(ap, tf);
+	pp->dhfis_flags &= ~(1 << qc->tag) ;
+	pp->qc_active |= (0x1 << qc->tag);
+
+	if (!pp->retry)
+		pp->cmd_sended++;
+
+	if (pp->retry)
+		pp->retry--;
+
+	NPRINTK("EXIT NCQ\n");
+	return 0;
+back_out:
+	pp->defer_bits |= (0x1 << qc->tag);
+	if (defer_byte(pp->cmd_stop)) {
+		NPRINTK("ERRCMD_STOP\n");
+	}
+	set_defer_byte(pp, qc->tag);
+	pp->retry++;
+	NPRINTK("EXIT NCQ\n");
+	return 0;
+}
+
+u32 ncq_valid_dhfisflag(struct nv_port_priv *pp)
+{
+	u32 valid = (pp->dhfis_flags == pp->qc_active);
+
+	if (back_byte(pp->cmd_stop))
+		return valid;
+
+	if (!valid) {
+		set_back_byte(pp, pp->current_tag);
+		pp->retry++;
+		NPRINTK("NOT DHFIS intr  dhfis_flags:%x pp->qc_active:%x\n",pp->dhfis_flags, pp->qc_active);
+	}
+	return valid;
+}
+
+
+#ifdef	NCQ_DEBUG
+static void fis_dump(struct ata_port *ap, u32 fis)
+{
+	u8 dma_stat;
+	u32 sactive;
+	u32 tag;
+	u32 serror, sstatus, sctl;
+	struct nv_port_priv *pp = ap->private_data;
+
+	sactive		= pp->ops->sactive_value(ap);
+	dma_stat	= ap->ops->bmdma_status(ap);
+	tag 		= pp->ops->tag_value(ap);
+
+
+	NPRINTK("id:0x%x cmd_sended:%x fis:0x%X dma_stat:0x%X "
+		"sactive:0x%X cmd_stop:0x%X apsactive:%x tag:%X ",
+							ap->id,
+							pp->cmd_sended,
+							fis,
+							dma_stat,
+							sactive,
+							pp->cmd_stop,
+							ap->sactive,
+							tag);
+
+	sata_scr_read(ap, SCR_ERROR, &serror);
+	sata_scr_read(ap, SCR_STATUS, &sstatus);
+	sata_scr_read(ap, SCR_CONTROL, &sctl);
+	printk("SErr:0x%x SStat:0x%x SCtl:0x%x ", serror, sstatus, sctl);
+		if (fis & NV_INT_BACKOUT_MCP55)
+			printk(" backout");
+
+		if (fis & NV_INT_DHREGFIS_MCP55)
+			printk(" dhfis");
+
+		if(fis & NV_INT_DMASETUP_MCP55)
+			printk(" dmasetup");
+
+		if (fis & NV_INT_SDBFIS_MCP55)
+			printk(" sdbfis");
+
+			printk("\n");
+
+	return;
+}
+
+#else
+#define fis_dump(x, y)
+#endif
+
+
+void ncq_hotplug(struct ata_port *ap, u32 fis)
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
+	ata_ehi_push_desc(ehi, "fis_stat 0x%08x", fis);
+
+	ata_ehi_hotplugged(ehi);
+
+	/* okay, let's hand over to EH */
+	ehi->serror |= serror;
+
+	ata_port_freeze(ap);
+}
+
+static int ncq_interrupt(struct ata_port *ap, u32 fis)
+{
+	struct nv_port_priv *pp = ap->private_data;
+	u32 rc = 0;
+	u32 tag;
+	u8 ata_stat;
+
+	if (!fis)
+		return 0;
+
+	ata_stat = ap->ops->check_status(ap);
+
+	ap->ops->irq_clear(ap); /* clear bm irq */
+
+	fis_dump(ap, fis);
+
+	if (fis & NV_INT_HOTPLUG_MCP55) {
+		ncq_hotplug(ap, fis);
+		pp->ops->clear_singlefis(ap, 0xffff);
+		return 1;
+	}
+
+
+	if (!(fis & 0xf0)) {
+		pp->ops->clear_singlefis(ap, 0x0f);
+		return rc;
+	}
+
+	pp->ops->clear_singlefis(ap, NV_INT_DEV_MCP55);
+
+	if (fis &NV_INT_BACKOUT_MCP55) {
+		pp->ops->clear_singlefis(ap, NV_INT_BACKOUT_MCP55);
+		pp->retry++ ;
+		set_back_byte(pp, pp->current_tag);
+		NPRINTK("BACK OUT FIS:%x \n", fis);
+		rc = 1;
+	} /* first handle back out */
+
+	if (fis & NV_INT_SDBFIS_MCP55) {
+		pp->ops->clear_singlefis(ap, NV_INT_SDBFIS_MCP55 | NV_INT_DEV_MCP55);
+		rc = nv_ncqintr_sdbfis(ap);
+	}
+
+	if (fis &NV_INT_DHREGFIS_MCP55) {
+		pp->ops->clear_singlefis(ap, NV_INT_DHREGFIS_MCP55);
+
+		/* each cmd generate one dhfis intr, otherwise error happens */
+		pp->dhfis_flags |= (0x1 << pp->current_tag);
+	}
+
+	if (fis & NV_INT_DMASETUP_MCP55) {
+		/* don't send next request after receiving dma setupfis */
+		tag = pp->ops->tag_value(ap);
+		if (!dma_byte(pp->cmd_stop))
+			set_dma_byte(pp, tag);
+
+		pp->ops->clear_singlefis(ap, NV_INT_DMASETUP_MCP55);
+
+		rc = nv_ncqintr_dmasetupfis(ap);
+	}
+
+	return rc;
+}
+
+#ifdef NCQ_DEBUG
+static void sdbfis_dump(struct ata_port *ap)
+{
+	struct nv_port_priv *pp = ap->private_data;
+
+
+	NPRINTK("id:0x%x retry:%x ap->qc_active:0x%x pp->qc_active:0x%x "
+		"defer_bits:0x%x cmd_stop:0x%x current_tag:%X pp->dhfis_flags:0x%x\n",
+							ap->id,
+							pp->retry,
+							ap->qc_active,
+							pp->qc_active,
+							pp->defer_bits,
+							pp->cmd_stop,
+							pp->current_tag,
+							pp->dhfis_flags);
+
+	return;
+}
+#else
+#define sdbfis_dump(x)
+#endif
+
+static int nv_ncqintr_sdbfis(struct ata_port *ap)
+{
+	struct ata_queued_cmd *qc;
+	u32 sactive;
+	int nr_done = 0;
+	u32 done_mask;
+	int i;
+	u32 dh_valid;
+	struct nv_port_priv *pp = ap->private_data;
+	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
+	u32 base = NV_CH1_SACTIVE_MCP55 + ap->port_no * 0x40;
+
+	pp->ops->bmdma_stop(ap);
+
+	sactive = readl(mmio + base);
+
+	done_mask = pp->qc_active ^ sactive;
+	if (unlikely(done_mask & sactive)) {
+		ata_port_printk(ap, KERN_ERR, "illegal qc_active transition "
+				"(%08x->%08x)\n", ap->qc_active, sactive);
+		return -EINVAL;
+	}
+	for (i = 0; i < ATA_MAX_QUEUE; i++) {
+		struct ata_queued_cmd *qc;
+
+		if (!(done_mask & (1 << i)))
+			continue;
+
+		if ((qc = ata_qc_from_tag(ap, i))) {
+			ata_qc_complete(qc);
+			pp->qc_active &= ~(0x1 << i);
+			pp->dhfis_flags &= ~(0x1 << i);
+			nr_done++;
+		}
+	}
+
+	if (!ap->qc_active) {
+		NPRINTK("over\n");
+		pp->dhfis_flags = 0;
+		pp->retry = 0;
+		pp->qc_active = 0;
+		pp->defer_bits = 0;
+		pp->cmd_stop = 0;
+		pp->cmd_sended = 0;
+		pp->current_tag = 0;
+		return nr_done;
+	}
+
+	dh_valid = ncq_valid_dhfisflag(pp);
+	sdbfis_dump(ap);
+
+	if (ap->qc_active > 0 && pp->qc_active == (1 << pp->current_tag) &&
+			back_byte(pp->cmd_stop)) {
+
+		qc = ata_qc_from_tag(ap, pp->current_tag);
+			if (unlikely(!qc))
+				return nr_done;
+
+		NPRINTK("backout or novalid\n");
+		ap->ops->qc_issue(qc);
+
+		return nr_done;
+	}
+
+	if (pp->qc_active > 0 || pp->defer_bits == 0)
+		return nr_done;
+
+	for (i = 0; i < 32; i++) {
+		if (!(pp->defer_bits & (0x1 << i)))
+			continue;
+
+		qc = ata_qc_from_tag(ap, i);
+		pp->defer_bits &= ~(0x1 << i);
+		NPRINTK("DEFER\n");
+		ap->ops->qc_issue(qc);
+			break;
+	}
+
+	return nr_done;
+}
+
+static u32 ncq_tag_value(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->host->iomap[NV_MMIO_BAR];
+	u32 tag;
+	u32 base =  NV_NCQ_REG_MCP55 + ap->port_no * 2;
+
+	tag = readb(mmio + base);
+	tag = ((tag >> 2) & 0x1f);
+	return  tag;
+}
+
+static int nv_ncqintr_dmasetupfis(struct ata_port *ap)
+{
+	struct ata_queued_cmd *qc;
+	unsigned int rw ;
+	u8 dmactl;
+	u32 tag;
+	struct nv_port_priv *pp = ap->private_data;
+
+	pp->ops->bmdma_stop(ap);
+	tag = pp->ops->tag_value(ap);
+
+	qc = ata_qc_from_tag(ap, tag);
+
+	if (unlikely(!qc))
+		return 0;
+
+	rw  =  ((qc->tf.flags) & ATA_TFLAG_WRITE);
+
+	/* load PRD table addr. */
+	iowrite32(pp->prd_dma + ATA_PRD_TBL_SZ*(qc->tag), ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
+
+	/* specify data direction, triple-check start bit is clear */
+	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+	dmactl &= ~(ATA_DMA_WR);
+	if (!rw)
+		dmactl |= ATA_DMA_WR;
+
+	iowrite8(dmactl | ATA_DMA_START, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+
+	return 1;
+}
+
 static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version = 0;
@@ -1553,7 +2591,7 @@ static int nv_init_one (struct pci_dev *
 		return rc;
 
 	/* determine type and allocate host */
-	if (type >= CK804 && adma_enabled) {
+	if ((type == CK804 || type == ADMA) && adma_enabled) {
 		dev_printk(KERN_NOTICE, &pdev->dev, "Using ADMA mode\n");
 		type = ADMA;
 	}
@@ -1586,7 +2624,7 @@ static int nv_init_one (struct pci_dev *
 	host->ports[1]->ioaddr.scr_addr = base + NV_PORT1_SCR_REG_OFFSET;
 
 	/* enable SATA space for CK804 */
-	if (type >= CK804) {
+	if (type == CK804 || type == ADMA) {
 		u8 regval;
 
 		pci_read_config_byte(pdev, NV_MCP_SATA_CFG_20, &regval);
@@ -1599,7 +2637,8 @@ static int nv_init_one (struct pci_dev *
 		rc = nv_adma_host_init(host);
 		if (rc)
 			return rc;
-	}
+	}else if (type == MCP55)
+		ncq_host_init(host);
 
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, ppi[0]->irq_handler,
@@ -1698,3 +2737,6 @@ module_init(nv_init);
 module_exit(nv_exit);
 module_param_named(adma, adma_enabled, bool, 0444);
 MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: true)");
+module_param_named(ncq, ncq_enabled, bool, 0444);
+MODULE_PARM_DESC(ncq, "Enable use of NCQ (Default: false)");
+
_

Patches currently in -mm which might be from pchen@nvidia.com are

drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch

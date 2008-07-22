From: akpm@linux-foundation.org
Subject: + sata_viac-add-support-for-vt8251-fix-the-internal-chips-issue-and.patch added to -mm tree
Date: Tue, 22 Jul 2008 01:13:47 -0700
Message-ID: <200807220813.m6M8Dlpt017979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbYGVIPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 04:15:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JosephChan@via.com.tw, jeff@garzik.org, josephchan@via.com.tw, tj@kernel.org


The patch titled
     sata_via.c: add support for VT8251, fix the internal chips issue and more
has been added to the -mm tree.  Its filename is
     sata_viac-add-support-for-vt8251-fix-the-internal-chips-issue-and.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sata_via.c: add support for VT8251, fix the internal chips issue and more
From: <JosephChan@via.com.tw>

a. Add board ID for VT8251.

    - That is the VT8251 has 2 SATA channels and each channel
      supports Master/Slave slot, the standard SATA operations in libata
      suppots only Master slot.

b. Patch <svia_scr_read> and <svia_scr_write> functions for VT8251

    - The location of SATA register on VT8251 is in PCI
      configuration space, not in PCI BAR.

c. Add function <via_ata_tf_load>

    - Fix the internal bug of via chipsets, which will reset the
      device register after changing the IEN bit in CTL register

d. Add function <via_std_set_pio_mode>, <via_std_set_dma_mode> and
   <via_std_cable_detect>

    - VIA's some PATA_SATA controllers (sucu as VT6421, CX700 and
      VX800), and the configure spaces are different for those
      controllers.  To avoid writing several similar functions for these
      chips, these 3 functions are used.

e. Add function <via_std_sata_prereset> and <via_std_sata_comreset>

    - Since some VIA SATA controllers support Master/Slave mode, but
      the standard hardreset in libata does not support slave slot, so we
      implement the hardreset during prereset process and then do
      softreset.

f. Redefine sata_ops

    - Libata does not do softreset for SATA controller if hardreset
      is available, to ensure the slave slot could be detected, we skip
      standard hardrest in libata.  As a result, we could not inherit the
      ops from ata_bmdma_port_ops, which has a default hardreset.

Signed-off-by: Josepch Chan <josephchan@via.com.tw>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_via.c |  658 +++++++++++++++++++++++++++++++++------
 1 file changed, 565 insertions(+), 93 deletions(-)

diff -puN drivers/ata/sata_via.c~sata_viac-add-support-for-vt8251-fix-the-internal-chips-issue-and drivers/ata/sata_via.c
--- a/drivers/ata/sata_via.c~sata_viac-add-support-for-vt8251-fix-the-internal-chips-issue-and
+++ a/drivers/ata/sata_via.c
@@ -46,9 +46,15 @@
 #define DRV_NAME	"sata_via"
 #define DRV_VERSION	"2.3"
 
+/*
+ * vt8251 is different from other sata controllers of VIA.
+ * It has two channels, each channel has both Master and
+ * Slave slot
+ */
 enum board_ids_enum {
 	vt6420,
 	vt6421,
+	vt8251,
 };
 
 enum {
@@ -71,19 +77,25 @@ static int svia_init_one(struct pci_dev 
 static int svia_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
 static int svia_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
 static void svia_noop_freeze(struct ata_port *ap);
-static int vt6420_prereset(struct ata_link *link, unsigned long deadline);
-static int vt6421_pata_cable_detect(struct ata_port *ap);
-static void vt6421_set_pio_mode(struct ata_port *ap, struct ata_device *adev);
-static void vt6421_set_dma_mode(struct ata_port *ap, struct ata_device *adev);
+
+static void via_ata_tf_load(struct ata_port *ap, const struct ata_taskfile *tf);
+
+static void via_std_set_pio_mode(struct ata_port *ap, struct ata_device *adev);
+static void via_std_set_dma_mode(struct ata_port *ap, struct ata_device *adev);
+static int via_std_cable_detect(struct ata_port *ap);
+
+static int via_std_sata_prereset(struct ata_link *link,
+			unsigned long deadline);
+static int via_std_sata_comreset(struct ata_port *ap, int isMaster);
 
 static const struct pci_device_id svia_pci_tbl[] = {
+	{ PCI_VDEVICE(VIA, 0x3149), vt6420 }, /* Two sata channels(Master) */
 	{ PCI_VDEVICE(VIA, 0x5337), vt6420 },
-	{ PCI_VDEVICE(VIA, 0x0591), vt6420 },
-	{ PCI_VDEVICE(VIA, 0x3149), vt6420 },
-	{ PCI_VDEVICE(VIA, 0x3249), vt6421 },
-	{ PCI_VDEVICE(VIA, 0x5287), vt6420 },
 	{ PCI_VDEVICE(VIA, 0x5372), vt6420 },
+	{ PCI_VDEVICE(VIA, 0x0591), vt6420 }, /* Two sata channels(Master) */
 	{ PCI_VDEVICE(VIA, 0x7372), vt6420 },
+	{ PCI_VDEVICE(VIA, 0x3249), vt6421 }, /* 2 sata chnls, 1 pata chnl*/
+	{ PCI_VDEVICE(VIA, 0x5287), vt8251 }, /* 2 sata chnls(Master/Slave) */
 
 	{ }	/* terminate list */
 };
@@ -103,31 +115,73 @@ static struct scsi_host_template svia_sh
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
-static struct ata_port_operations vt6420_sata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+/*
+ * The opertion redefined by VIA to implement sata functions.
+ * Since some via sata controllers support Master/Slave mode,
+ * but the standard hardreset in libata could not work well
+ * for slave slot, so we implement the hardreset during
+ * prereset, and then do softreset. It should be mentioned
+ * that libata does not do softreset for sata controller if
+ * hardreset is availuable, to ensure the slave slot could
+ * be detected, we skip standard hardrest in libata. That is
+ * why we have to redefine the sata operations of sata
+ */
+static struct ata_port_operations via_std_sata_ops = {
+	.inherits		= &ata_base_port_ops,
+
+	.qc_prep		= ata_sff_qc_prep,
+	.qc_issue		= ata_sff_qc_issue,
+	.qc_fill_rtf		= ata_sff_qc_fill_rtf,
+
+	.thaw			= ata_sff_thaw,
+	.softreset		= ata_sff_softreset,
+	.postreset		= ata_sff_postreset,
+	.error_handler		= ata_sff_error_handler,
+	.post_internal_cmd	= ata_sff_post_internal_cmd,
+
+	.sff_dev_select		= ata_sff_dev_select,
+	.sff_check_status	= ata_sff_check_status,
+	.sff_tf_read		= ata_sff_tf_read,
+	.sff_exec_command	= ata_sff_exec_command,
+	.sff_data_xfer		= ata_sff_data_xfer,
+	.sff_irq_on			= ata_sff_irq_on,
+	.sff_irq_clear		= ata_sff_irq_clear,
+
+	.port_start		= ata_sff_port_start,
+
+	.mode_filter		= ata_bmdma_mode_filter,
+
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop			= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
+
+	.sff_tf_load		= via_ata_tf_load,
+
+	.prereset		= via_std_sata_prereset,
 	.freeze			= svia_noop_freeze,
-	.prereset		= vt6420_prereset,
-};
 
-static struct ata_port_operations vt6421_pata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
-	.cable_detect		= vt6421_pata_cable_detect,
-	.set_piomode		= vt6421_set_pio_mode,
-	.set_dmamode		= vt6421_set_dma_mode,
+	.scr_read		= svia_scr_read,
+	.scr_write		= svia_scr_write,
 };
 
-static struct ata_port_operations vt6421_sata_ops = {
+static struct ata_port_operations via_std_pata_ops = {
 	.inherits		= &ata_bmdma_port_ops,
-	.scr_read		= svia_scr_read,
-	.scr_write		= svia_scr_write,
+
+	.cable_detect	= via_std_cable_detect,
+	.set_piomode	= via_std_set_pio_mode,
+	.set_dmamode	= via_std_set_dma_mode,
+
+	.sff_tf_load	= via_ata_tf_load,
 };
 
-static const struct ata_port_info vt6420_port_info = {
+
+static struct ata_port_info vt6420_port_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
 	.pio_mask	= 0x1f,
 	.mwdma_mask	= 0x07,
 	.udma_mask	= ATA_UDMA6,
-	.port_ops	= &vt6420_sata_ops,
+	.port_ops	= &via_std_sata_ops,
 };
 
 static struct ata_port_info vt6421_sport_info = {
@@ -135,7 +189,7 @@ static struct ata_port_info vt6421_sport
 	.pio_mask	= 0x1f,
 	.mwdma_mask	= 0x07,
 	.udma_mask	= ATA_UDMA6,
-	.port_ops	= &vt6421_sata_ops,
+	.port_ops	= &via_std_sata_ops,
 };
 
 static struct ata_port_info vt6421_pport_info = {
@@ -143,7 +197,20 @@ static struct ata_port_info vt6421_pport
 	.pio_mask	= 0x1f,
 	.mwdma_mask	= 0,
 	.udma_mask	= ATA_UDMA6,
-	.port_ops	= &vt6421_pata_ops,
+	.port_ops	= &via_std_pata_ops,
+};
+
+/**
+ * VT8251 has two sata channels, which are both Master/Slave mode. This is different
+ * from the implementation in libata, which supports only master mode
+ */
+static struct ata_port_info vt8251_port_info = {
+	.flags		=  ATA_FLAG_SATA | ATA_FLAG_SLAVE_POSS |
+					ATA_FLAG_NO_LEGACY,
+	.pio_mask	= 0x1f,
+	.mwdma_mask	= 0x07,
+	.udma_mask	= ATA_UDMA6,
+	.port_ops	= &via_std_sata_ops,
 };
 
 MODULE_AUTHOR("Jeff Garzik");
@@ -152,22 +219,235 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, svia_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
+/**
+ * For controller 0x8251 and ox0581/0x5324, the sata controller registers do not
+ * locate in the PCI BARs, instead, they are in the PCI configure space.
+ */
 static int svia_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 {
-	if (sc_reg > SCR_CONTROL)
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8  config_space_value;
+    u8  byte_temp;
+	u32 scr_value;
+    u32 dword_temp;
+    s8  shift;
+    u8  slot;
+
+    unsigned int scr_reg = sc_reg;
+
+    if (scr_reg > SCR_CONTROL) {
+		VPRINTK("invalid scr[%d] address!\n", scr_reg);
 		return -EINVAL;
-	*val = ioread32(ap->ioaddr.scr_addr + (4 * sc_reg));
-	return 0;
+    }
+
+
+    if (!(pdev->device == 0x5287 || pdev->device == 0x0581 ||
+		pdev->device == 0x5324))
+		*val = ioread32(ap->ioaddr.scr_addr + (4 * scr_reg));
+    else {
+		config_space_value = 0;
+		scr_value = 0;
+		shift     = 0;
+
+		/**
+		 * Since these chips do not use iomap to get the address of scr,
+		 * we use these register to store the slot index
+		 */
+		slot = (u32)ap->ioaddr.scr_addr & 0x03;
+
+		if (scr_reg == SCR_STATUS) {
+			pci_read_config_byte(pdev, (0xA0 + (slot & 0x03)),
+				&config_space_value);
+
+			/* Set the DET field, bit0 and 1 of the config byte */
+			scr_value |= (config_space_value & 0x03);
+
+			/* Set the SPD field, bit4 of the configure byte */
+			if (config_space_value & (1<<4))
+				scr_value |= (u8)(0x02 << 4);
+			else
+				scr_value |= (u8)(0x01 << 4);
+
+			/* Set the IPM field, bit2 and 3 of the config byte */
+			byte_temp = (config_space_value >> 2) & 0x03;
+			shift = byte_temp - 1;
+			if (shift < 0)
+				shift = 0;
+
+			dword_temp = (byte_temp + 0x01) << shift;
+			scr_value  |= ((dword_temp & 0x0f) << 8);
+		} else if (scr_reg == SCR_ERROR) {
+			if (pdev->device == 0x5287)
+				pci_read_config_dword(pdev,
+				(0xB0 + (slot & 0x03) * 4), &scr_value);
+			else
+				pci_read_config_dword(pdev,
+				(0xA8 + (slot & 0x03) * 4), &scr_value);
+		} else if (scr_reg == SCR_CONTROL) {
+			pci_read_config_byte(pdev,
+				(0xA4 + (slot & 0x03)), &config_space_value);
+
+			 /* Read the DET field, bit0 and bit1 */
+			 byte_temp = config_space_value & 0x03;
+			 scr_value |= (((byte_temp & 0x02) << 1) |
+				 (byte_temp & 0x01));
+
+			/* Read the SPD field, bit4 */
+			scr_value &= ~(u32)0xF0;
+
+			/* Read the IPM field, bit2 and bit3 */
+			dword_temp = (config_space_value >> 2) & 0x03;
+			scr_value  |= (dword_temp << 8);
+		}
+
+		*val = scr_value;
+    }
+
+    return 0;
 }
 
+
+
 static int svia_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 {
-	if (sc_reg > SCR_CONTROL)
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8  config_space_value;
+    u8  byte_temp;
+    u8  slot;
+
+	unsigned int scr_reg = sc_reg;
+
+    if (scr_reg > SCR_CONTROL) {
+		VPRINTK("invalid scr[%d] address!\n", scr_reg);
 		return -EINVAL;
-	iowrite32(val, ap->ioaddr.scr_addr + (4 * sc_reg));
+    }
+
+    if (scr_reg == SCR_STATUS) {
+		VPRINTK("scr_status can not be write!\n");
+		return -EINVAL;
+    }
+
+    if (!(pdev->device == 0x5287 || pdev->device == 0x0581 ||
+		pdev->device == 0x5324))
+		iowrite32(val, ap->ioaddr.scr_addr + (4 * scr_reg));
+    else {
+		byte_temp  = 0;
+		config_space_value = 0;
+
+		/* To get the slot index */
+	    slot = (u32) ap->ioaddr.scr_addr & 0x03;
+
+		if (scr_reg == SCR_ERROR) {
+			if (pdev->device == 0x5287)
+				pci_write_config_dword(pdev,
+				(0xB0 + (slot & 0x03) * 4), val);
+			else
+				pci_write_config_dword(pdev,
+				(0xA8 + (slot & 0x03) * 4), val);
+		} else if (scr_reg == SCR_CONTROL) {
+			/* Set the DET field */
+			byte_temp = (((u8)(val & 0x04)) >> 1) |
+				((u8)(val & 0x01));
+			config_space_value |= (byte_temp & 0x0F);
+
+			/* Set the IPM field */
+			byte_temp = (val >> 8) & 0x03;
+			config_space_value |= (byte_temp << 2);
+			pci_write_config_byte(pdev, (0xA4 + (slot & 0x03)),
+				config_space_value);
+		}
+    }
+
 	return 0;
 }
 
+/**
+ *	via_ata_sff_tf_load - send taskfile registers to host controller
+ *	@ap: Port to which output is sent
+ *	@tf: ATA taskfile register set
+ *
+ *	Outputs ATA taskfile to standard ATA host controller.
+ *
+ *	Note: This is to fix the internal bug of via chipsets,
+ *  which will reset the device register after changing the IEN bit
+ *  on ctl register
+ */
+static void via_ata_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	unsigned int is_addr = tf->flags & ATA_TFLAG_ISADDR;
+
+	if (tf->ctl != ap->last_ctl) {
+		iowrite8(tf->ctl, ioaddr->ctl_addr);
+		iowrite8(tf->device, ioaddr->device_addr);
+		ap->last_ctl = tf->ctl;
+		ata_wait_idle(ap);
+	}
+
+	if (is_addr && (tf->flags & ATA_TFLAG_LBA48)) {
+		iowrite8(tf->hob_feature, ioaddr->feature_addr);
+		iowrite8(tf->hob_nsect, ioaddr->nsect_addr);
+		iowrite8(tf->hob_lbal, ioaddr->lbal_addr);
+		iowrite8(tf->hob_lbam, ioaddr->lbam_addr);
+		iowrite8(tf->hob_lbah, ioaddr->lbah_addr);
+		VPRINTK("hob: feat 0x%X nsect 0x%X, lba 0x%X 0x%X 0x%X\n",
+			tf->hob_feature,
+			tf->hob_nsect,
+			tf->hob_lbal,
+			tf->hob_lbam,
+			tf->hob_lbah);
+	}
+
+	if (is_addr) {
+		iowrite8(tf->feature, ioaddr->feature_addr);
+		iowrite8(tf->nsect, ioaddr->nsect_addr);
+		iowrite8(tf->lbal, ioaddr->lbal_addr);
+		iowrite8(tf->lbam, ioaddr->lbam_addr);
+		iowrite8(tf->lbah, ioaddr->lbah_addr);
+		VPRINTK("feat 0x%X nsect 0x%X lba 0x%X 0x%X 0x%X\n",
+			tf->feature,
+			tf->nsect,
+			tf->lbal,
+			tf->lbam,
+			tf->lbah);
+	}
+
+	if (tf->flags & ATA_TFLAG_DEVICE) {
+		iowrite8(tf->device, ioaddr->device_addr);
+		VPRINTK("device 0x%X\n", tf->device);
+	}
+
+	ata_wait_idle(ap);
+}
+
+static int via_std_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 tmp;
+	int cfg_addr;
+
+	if (ap->port_no == 2) {
+		if (pdev->device == 0x3249) {
+			cfg_addr = 0xB3;
+			pci_read_config_byte(pdev, cfg_addr, &tmp);
+			if (tmp & 0x10)
+				return ATA_CBL_PATA40;
+			return ATA_CBL_PATA80;
+		}
+	} else if (ap->port_no == 1) {
+		if ((pdev->device == 0x0581) || (pdev->device == 0x5324)) {
+			cfg_addr = 0x50;
+			pci_read_config_byte(pdev, cfg_addr, &tmp);
+			if (tmp & 0x10) /* 40pin cable */
+				return ATA_CBL_PATA40;
+			else /* 80pin cable */
+				return ATA_CBL_PATA80;
+		}
+	}
+
+	return ATA_CBL_SATA;
+}
+
 static void svia_noop_freeze(struct ata_port *ap)
 {
 	/* Some VIA controllers choke if ATA_NIEN is manipulated in
@@ -177,19 +457,118 @@ static void svia_noop_freeze(struct ata_
 	ata_sff_irq_clear(ap);
 }
 
+ /**
+ *	via_std_sata_comreset - comreset for via sata controller
+ *	@ap: target ATA port
+ *	@isMaster: whether the input port is master slot
+ *
+ *	Some VIA controllers does not use PCI BAR to map the sata
+ *  controller registers, besides, some via data controllers
+ *  have both master and slave slots. As a result, standard
+ *  operations in libata could not work well
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ *
+ *	RETURNS:
+ *	0 on success, -errno otherwise.
+ */
+static int via_std_sata_comreset(struct ata_port *ap, int isMaster)
+{
+    struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	unsigned long timeout = jiffies + (HZ * 5);
+	u32 sstatus, scontrol, serror;
+	int online = 0;
+
+	int slot;
+    int slot_start = ap->port_no;
+	unsigned int dev = 0;
+
+	unsigned int cbl_tmp = via_std_cable_detect(ap);
+	unsigned long flag_tmp = ap->flags;
+
+	if (ap->flags & ATA_FLAG_SLAVE_POSS)
+		slot_start = slot_start << 1;
+
+	ap->cbl = ATA_CBL_SATA;
+	ap->flags |= ATA_FLAG_SATA;
+
+	{
+		slot = (isMaster ? 0 : 1) + slot_start;
+		if (pdev->device == 0x5287 || pdev->device == 0x0581 ||
+			pdev->device == 0x5324)
+			ap->ioaddr.scr_addr = (void __iomem *)slot;
+
+		dev =  (ap->flags & ATA_FLAG_SLAVE_POSS) ? (slot&0x01) : 0;
+		ap->ops->sff_dev_select(ap, dev);
+
+		DPRINTK("Comreset SATA Device %X PORT : %d, SLOT : %s\n", \
+			    pdev->device, ap->port_no, \
+				(dev == 0) ? "<Master>" : "<Slave>");
+
+		ap->ops->scr_read(ap, SCR_CONTROL, &scontrol);
+		scontrol = (scontrol & 0x0f0) | 0x301;
+		ap->ops->scr_write(ap, SCR_CONTROL, scontrol);
+		ap->ops->scr_read(ap, SCR_CONTROL, &scontrol);
+
+		msleep(2);
+		scontrol = (scontrol & 0x0f0) | 0x300;
+		ap->ops->scr_write(ap, SCR_CONTROL, scontrol);
+		ap->ops->scr_read(ap, SCR_CONTROL, &scontrol); /* flush */
+
+		/* wait for phy to become ready, if necessary */
+		do {
+			msleep(200);
+			ap->ops->scr_read(ap, SCR_STATUS, &sstatus);
+			if ((sstatus & 0xf) != 1)
+				break;
+		} while (time_before(jiffies, timeout));
+
+		/* open code sata_print_link_status() */
+		ap->ops->scr_read(ap, SCR_STATUS, &sstatus);
+		ap->ops->scr_read(ap, SCR_CONTROL, &scontrol);
+		ap->ops->scr_read(ap, SCR_ERROR, &serror);
+		ap->ops->scr_write(ap, SCR_ERROR, serror);
+
+		ata_port_printk(ap, KERN_INFO,
+				"SATA link %s (SStatus %X SControl %X)\n",
+				online ? "up" : "down", sstatus, scontrol);
+
+		/* SStatus is read one more time */
+		ap->ops->scr_read(ap, SCR_STATUS, &sstatus);
+
+		online = (sstatus & 0xf) == 0x3;
+		if (!online) {
+			/* tell EH to bail */
+			DPRINTK("Comreset %X PORT : %d, SLOT : %s  failed\n", \
+				   pdev->device, ap->port_no, \
+					(dev == 0) ? "<Master>" : "<Slave>");
+
+			ap->cbl = cbl_tmp;
+			ap->flags = flag_tmp;
+			return -ENODEV;
+		}
+		DPRINTK("Comreset %X PORT : %d, SLOT : %s succeeded.\n", \
+			     pdev->device, ap->port_no, \
+				(dev == 0) ? "<Master>" : "<Slave>");
+
+	}
+
+	ap->cbl = cbl_tmp;
+	ap->flags = flag_tmp;
+
+
+	return 0;
+}
+
+
 /**
- *	vt6420_prereset - prereset for vt6420
+ *	via_std_sata_prereset - prereset for via sata controllers
  *	@link: target ATA link
  *	@deadline: deadline jiffies for the operation
  *
- *	SCR registers on vt6420 are pieces of shit and may hang the
- *	whole machine completely if accessed with the wrong timing.
- *	To avoid such catastrophe, vt6420 doesn't provide generic SCR
- *	access operations, but uses SStatus and SControl only during
- *	boot probing in controlled way.
- *
- *	As the old (pre EH update) probing code is proven to work, we
- *	strictly follow the access pattern.
+ *	Standard error handling will retry several times if reset
+ *  fails, this makes users cannot bear it.
  *
  *	LOCKING:
  *	Kernel thread context (may sleep)
@@ -197,79 +576,146 @@ static void svia_noop_freeze(struct ata_
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-static int vt6420_prereset(struct ata_link *link, unsigned long deadline)
+static int via_std_sata_prereset(struct ata_link *link, unsigned long deadline)
 {
 	struct ata_port *ap = link->ap;
-	struct ata_eh_context *ehc = &ap->link.eh_context;
-	unsigned long timeout = jiffies + (HZ * 5);
-	u32 sstatus, scontrol;
-	int online;
+    struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int devmask = 0;
+	int slot_cnt = 0;
+	int slot;
+	int rc;
+	u8 status;
 
 	/* don't do any SCR stuff if we're not loading */
 	if (!(ap->pflags & ATA_PFLAG_LOADING))
 		goto skip_scr;
 
-	/* Resume phy.  This is the old SATA resume sequence */
-	svia_scr_write(ap, SCR_CONTROL, 0x300);
-	svia_scr_read(ap, SCR_CONTROL, &scontrol); /* flush */
-
-	/* wait for phy to become ready, if necessary */
-	do {
-		msleep(200);
-		svia_scr_read(ap, SCR_STATUS, &sstatus);
-		if ((sstatus & 0xf) != 1)
-			break;
-	} while (time_before(jiffies, timeout));
-
-	/* open code sata_print_link_status() */
-	svia_scr_read(ap, SCR_STATUS, &sstatus);
-	svia_scr_read(ap, SCR_CONTROL, &scontrol);
-
-	online = (sstatus & 0xf) == 0x3;
-
-	ata_port_printk(ap, KERN_INFO,
-			"SATA link %s 1.5 Gbps (SStatus %X SControl %X)\n",
-			online ? "up" : "down", sstatus, scontrol);
-
-	/* SStatus is read one more time */
-	svia_scr_read(ap, SCR_STATUS, &sstatus);
-
-	if (!online) {
-		/* tell EH to bail */
-		ehc->i.action &= ~ATA_EH_RESET;
-		return 0;
+	slot_cnt = (ap->flags & ATA_FLAG_SLAVE_POSS) ? 2 : 1;
+	for (slot = 0; slot < slot_cnt; ++slot) {
+		rc = via_std_sata_comreset(ap, (slot%2 == 0) ? 1 : 0);
+		if (!rc)
+			devmask |= (1<<slot);
+
+		rc = ata_sff_wait_ready(link, deadline);
+		status = link->ap->ops->sff_check_status(link->ap);
+		DPRINTK("Prereset %X for PORT%d status %x: \n", \
+				pdev->device, ap->port_no, status);
+		if (rc != 0) {
+			DPRINTK("Prereset %X for PORT%d failed\n", \
+						pdev->device, ap->port_no);
+			devmask &= ~(1<<slot);
+		}
+	}
+
+	/*
+	 * To fix the online check in libata. The softreset in libata will check
+	 * whether the Master slot will be online for an ata link, so we should
+	 * reset the master port again if the slave slot does not have a device
+	 * attached
+	 */
+	if ((slot_cnt == 2) && (devmask == 0x01))
+		via_std_sata_comreset(ap, 1);
+	else if (devmask == 0) {
+			DPRINTK("Prereset%X for PORT%d failed: (No device)\n", \
+					pdev->device, ap->port_no);
+			return -ENODEV;
 	}
 
- skip_scr:
+skip_scr:
 	/* wait for !BSY */
-	ata_sff_wait_ready(link, deadline);
+	rc = ata_sff_wait_ready(link, deadline);
+	if (rc)
+		DPRINTK("Prereset %X for PORT%d failed\n", \
+				    pdev->device, ap->port_no);
 
-	return 0;
+	return rc;
 }
 
-static int vt6421_pata_cable_detect(struct ata_port *ap)
+
+static void via_std_set_pio_mode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 tmp;
 
-	pci_read_config_byte(pdev, PATA_UDMA_TIMING, &tmp);
-	if (tmp & 0x10)
-		return ATA_CBL_PATA40;
-	return ATA_CBL_PATA80;
-}
+	u8 cfg_byte;
+	int cfg_addr;
+	u16 tmp16;
+
+	tmp16 = pdev->device;
+
+	if ((tmp16 == 0x3249) && (ap->port_no == 2))/* PATA channel in VT6421 */
+		cfg_addr = 0xAB;
+	else if ((tmp16 == 0x0581 || tmp16 == 0x5324) &&
+		(ap->port_no == 1))/* PATA channel in VT8353 */
+		cfg_addr = 0x49;
+	else
+		return;
 
-static void vt6421_set_pio_mode(struct ata_port *ap, struct ata_device *adev)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	static const u8 pio_bits[] = { 0xA8, 0x65, 0x65, 0x31, 0x20 };
-	pci_write_config_byte(pdev, PATA_PIO_TIMING, pio_bits[adev->pio_mode - XFER_PIO_0]);
+	switch (adev->pio_mode & 0x07) {
+	case 0:
+		cfg_byte = 0xa8;
+		break;
+	case 1:
+		cfg_byte = 0x65;
+		break;
+	case 2:
+		cfg_byte = 0x65;
+		break;
+	case 3:
+		cfg_byte = 0x31;
+		break;
+	case 4:
+		cfg_byte = 0x20;
+		break;
+	default:
+		cfg_byte = 0x20;
+	}
+
+	pci_write_config_byte(pdev, cfg_addr, cfg_byte);
 }
 
-static void vt6421_set_dma_mode(struct ata_port *ap, struct ata_device *adev)
+static void via_std_set_dma_mode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	static const u8 udma_bits[] = { 0xEE, 0xE8, 0xE6, 0xE4, 0xE2, 0xE1, 0xE0, 0xE0 };
-	pci_write_config_byte(pdev, PATA_UDMA_TIMING, udma_bits[adev->dma_mode - XFER_UDMA_0]);
+	u8 cfg_byte;
+	int cfg_addr;
+	u16 tmp16;
+
+	tmp16 = pdev->device;
+
+	if ((tmp16 == 0x3249) && (ap->port_no == 2))
+		cfg_addr = 0xB3; /* PATA channel in VT6421 */
+	else if ((tmp16 == 0x0581) && (ap->port_no == 1))
+		cfg_addr = 0x50; /* PATA channel in VT8353 */
+	else
+		return;
+
+	switch (adev->dma_mode & 0x07) {
+	case 0:
+		cfg_byte = 0xee;
+		break;
+	case 1:
+		cfg_byte = 0xe8;
+		break;
+	case 2:
+		cfg_byte = 0xe6;
+		break;
+	case 3:
+		cfg_byte = 0xe4;
+		break;
+	case 4:
+		cfg_byte = 0xe2;
+		break;
+	case 5:
+		cfg_byte = 0xe1;
+		break;
+	case 6:
+		cfg_byte = 0xe0;
+		break;
+	default:
+		cfg_byte = 0xe0;
+	}
+
+	pci_write_config_byte(pdev, cfg_addr, cfg_byte);
 }
 
 static const unsigned int svia_bar_sizes[] = {
@@ -292,7 +738,7 @@ static void __iomem *vt6421_scr_addr(voi
 
 static void vt6421_init_addrs(struct ata_port *ap)
 {
-	void __iomem * const * iomap = ap->host->iomap;
+	void __iomem * const *iomap = ap->host->iomap;
 	void __iomem *reg_addr = iomap[ap->port_no];
 	void __iomem *bmdma_addr = iomap[4] + (ap->port_no * 8);
 	struct ata_ioports *ioaddr = &ap->ioaddr;
@@ -367,6 +813,26 @@ static int vt6421_prepare_host(struct pc
 	return 0;
 }
 
+static int vt8251_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
+{
+    const struct ata_port_info *ppi[] = {&vt8251_port_info, NULL};
+	struct ata_host *host;
+	int rc;
+
+	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	if (rc)
+		return rc;
+	*r_host = host;
+
+	rc = pcim_iomap_regions(pdev, 1 << 5, DRV_NAME);
+	if (rc) {
+		dev_printk(KERN_ERR, &pdev->dev, "failed to iomap PCI BAR 5\n");
+		return rc;
+	}
+
+	return 0;
+}
+
 static void svia_configure(struct pci_dev *pdev)
 {
 	u8 tmp8;
@@ -424,8 +890,11 @@ static int svia_init_one(struct pci_dev 
 
 	if (board_id == vt6420)
 		bar_sizes = &svia_bar_sizes[0];
-	else
+	else if (board_id == vt6421)
 		bar_sizes = &vt6421_bar_sizes[0];
+	else
+		bar_sizes = &svia_bar_sizes[0];
+
 
 	for (i = 0; i < ARRAY_SIZE(svia_bar_sizes); i++)
 		if ((pci_resource_start(pdev, i) == 0) ||
@@ -440,8 +909,11 @@ static int svia_init_one(struct pci_dev 
 
 	if (board_id == vt6420)
 		rc = vt6420_prepare_host(pdev, &host);
-	else
+	else if (board_id == vt6421)
 		rc = vt6421_prepare_host(pdev, &host);
+	else
+		rc = vt8251_prepare_host(pdev, &host);
+
 	if (rc)
 		return rc;
 
_

Patches currently in -mm which might be from JosephChan@via.com.tw are

sata_viac-add-support-for-vt8251-fix-the-internal-chips-issue-and.patch
pata_viac-add-flag-for-vx800-and-add-a-function-for-fixing-internal-bugs-for-via-chipsets.patch


From: akpm@linux-foundation.org
Subject: + pata_viac-add-flag-for-vx800-and-add-a-function-for-fixing-internal-bugs-for-via-chipsets.patch added to -mm tree
Date: Tue, 22 Jul 2008 01:14:34 -0700
Message-ID: <200807220814.m6M8EYoC017989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289AbYGVIP5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 04:15:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JosephChan@via.com.tw, alan@lxorguk.ukuu.org.uk, jeff@garzik.org, josephchan@via.com.tw, tj@kernel.org


The patch titled
     pata_via.c: add flag for VX800 and add a function for fixing internal bugs for VIA chipsets
has been added to the -mm tree.  Its filename is
     pata_viac-add-flag-for-vx800-and-add-a-function-for-fixing-internal-bugs-for-via-chipsets.patch

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
Subject: pata_via.c: add flag for VX800 and add a function for fixing internal bugs for VIA chipsets
From: <JosephChan@via.com.tw>

Add flag VIA_SATA_PATA for vx800, VX800 uses the same
chipset(0x0581/0x5324) as CX700, which has 1 PATA channel(Master/Slave)
and 1 SATA channel(Master/Slave) Add function <via_ata_tf_load>.  This is
to fix the internal bug of VIA chipsets, which will reset the device
register after changing the IEN bit in CTL register

Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_via.c |   64 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 1 deletion(-)

diff -puN drivers/ata/pata_via.c~pata_viac-add-flag-for-vx800-and-add-a-function-for-fixing-internal-bugs-for-via-chipsets drivers/ata/pata_via.c
--- a/drivers/ata/pata_via.c~pata_viac-add-flag-for-vx800-and-add-a-function-for-fixing-internal-bugs-for-via-chipsets
+++ a/drivers/ata/pata_via.c
@@ -98,7 +98,8 @@ static const struct via_isa_bridge {
 	u8 rev_max;
 	u16 flags;
 } via_isa_bridges[] = {
-	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
+	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, VIA_UDMA_133 |
+	VIA_BAD_AST | VIA_SATA_PATA },
 	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_SATA_PATA },
@@ -322,6 +323,65 @@ static void via_set_dmamode(struct ata_p
 	via_do_set_mode(ap, adev, adev->dma_mode, tclock[mode], set_ast, udma[mode]);
 }
 
+/**
+ *	via_ata_sff_tf_load - send taskfile registers to host controller
+ *	@ap: Port to which output is sent
+ *	@tf: ATA taskfile register set
+ *
+ *	Outputs ATA taskfile to standard ATA host controller.
+ *
+ *	Note: This is to fix the internal bug of via chipsets, which
+ *  will reset the device register after changing the IEN bit on
+ *  ctl register
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
 static struct scsi_host_template via_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -332,11 +392,13 @@ static struct ata_port_operations via_po
 	.set_piomode	= via_set_piomode,
 	.set_dmamode	= via_set_dmamode,
 	.prereset	= via_pre_reset,
+	.sff_tf_load = via_ata_tf_load,
 };
 
 static struct ata_port_operations via_port_ops_noirq = {
 	.inherits	= &via_port_ops,
 	.sff_data_xfer	= ata_sff_data_xfer_noirq,
+	.sff_tf_load = via_ata_tf_load,
 };
 
 /**
_

Patches currently in -mm which might be from JosephChan@via.com.tw are

sata_viac-add-support-for-vt8251-fix-the-internal-chips-issue-and.patch
pata_viac-add-flag-for-vx800-and-add-a-function-for-fixing-internal-bugs-for-via-chipsets.patch


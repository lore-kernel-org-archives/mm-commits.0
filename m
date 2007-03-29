From: akpm@linux-foundation.org
Subject: - ahcic-walkaround-for-sb600-sata-internal-error-issue.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:43:04 -0700
Message-ID: <200703290743.l2T7h4WJ030355@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46209 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965119AbXC2HnS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:43:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: conke.hu@gmail.com, conke.hu@amd.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ahci.c: workaround for SB600 SATA internal error issue
has been removed from the -mm tree.  Its filename was
     ahcic-walkaround-for-sb600-sata-internal-error-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ahci.c: workaround for SB600 SATA internal error issue
From: "Conke Hu" <conke.hu@gmail.com>

There is a HW issue in ATI SB600 SATA that PxSERR.E should not be set on
some conditions, for example, when there is no media in SATA CD/DVD drive
or media is not ready, AHCI controller fails to execute ATAPI commands and
reports PORT_IRQ_TF_ERR, but ATI SB600 SATA controller sets PxSERR.E at the
same time, which is not necessary.

This patch is just to ignore the INTERNAL ERROR in such case.  Without this
patch, ahci error handler will report many errors as below:

    ----------- cut from dmesg -----------
ata9: soft resetting port
ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata9.00: configured for UDMA/33
ata9: EH complete
ata9.00: exception Emask 0x40 SAct 0x0 SErr 0x800 action 0x2
ata9.00: (irq_stat 0x40000001)
ata9.00: cmd a0/00:00:00:00:20/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0
        res 51/24:03:00:00:20/00:00:00:00:00/a0 Emask 0x40 (internal error)
ata9: soft resetting port
ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata9.00: configured for UDMA/33
ata9: EH complete
ata9.00: exception Emask 0x40 SAct 0x0 SErr 0x800 action 0x2
ata9.00: (irq_stat 0x40000001)
ata9.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x43 data 12 in
        res 51/24:03:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
    -------- end cut ---------

Signed-off-by: Conke Hu <conke.hu@amd.com>
Acked-by: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff -puN drivers/ata/ahci.c~ahcic-walkaround-for-sb600-sata-internal-error-issue drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahcic-walkaround-for-sb600-sata-internal-error-issue
+++ a/drivers/ata/ahci.c
@@ -81,6 +81,7 @@ enum {
 	board_ahci_vt8251	= 2,
 	board_ahci_ign_iferr	= 3,
 	board_ahci_mv		= 4,
+	board_ahci_sb600	= 5,
 
 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -170,6 +171,7 @@ enum {
 	AHCI_FLAG_IGN_IRQ_IF_ERR	= (1 << 25), /* ignore IRQ_IF_ERR */
 	AHCI_FLAG_HONOR_PI		= (1 << 26), /* honor PORTS_IMPL */
 	AHCI_FLAG_MV_PATA		= (1 << 27), /* PATA port */
+	AHCI_FLAG_IGN_SERR_INTERNAL	= (1 << 28), /* ignore SERR_INTERNAL */
 };
 
 struct ahci_cmd_hdr {
@@ -375,6 +377,18 @@ static const struct ata_port_info ahci_p
 		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
 		.port_ops	= &ahci_ops,
 	},
+	/* board_ahci_sb600 */
+	{
+		.sht		= &ahci_sht,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
+				  ATA_FLAG_SKIP_D2H_BSY |
+				  AHCI_FLAG_IGN_SERR_INTERNAL,
+		.pio_mask	= 0x1f, /* pio0-4 */
+		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.port_ops	= &ahci_ops,
+	},
+
 };
 
 static const struct pci_device_id ahci_pci_tbl[] = {
@@ -412,7 +426,7 @@ static const struct pci_device_id ahci_p
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci_ign_iferr },
 
 	/* ATI */
-	{ PCI_VDEVICE(ATI, 0x4380), board_ahci }, /* ATI SB600 non-raid */
+	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 non-raid */
 	{ PCI_VDEVICE(ATI, 0x4381), board_ahci }, /* ATI SB600 raid */
 
 	/* VIA */
@@ -1102,8 +1116,11 @@ static void ahci_error_intr(struct ata_p
 	if (ap->flags & AHCI_FLAG_IGN_IRQ_IF_ERR)
 		irq_stat &= ~PORT_IRQ_IF_ERR;
 
-	if (irq_stat & PORT_IRQ_TF_ERR)
+	if (irq_stat & PORT_IRQ_TF_ERR) {
 		err_mask |= AC_ERR_DEV;
+		if (ap->flags & AHCI_FLAG_IGN_SERR_INTERNAL)
+			serror &= ~SERR_INTERNAL;
+	}
 
 	if (irq_stat & (PORT_IRQ_HBUS_ERR | PORT_IRQ_HBUS_DATA_ERR)) {
 		err_mask |= AC_ERR_HOST_BUS;
_

Patches currently in -mm which might be from conke.hu@gmail.com are

origin.patch

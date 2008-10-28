From: akpm@linux-foundation.org
Subject: - pata_it821x-in-2627-works-but-no-lba48-and-hdparm-t-is-slower.patch removed from -mm tree
Date: Tue, 28 Oct 2008 12:07:10 -0700
Message-ID: <200810281907.m9SJ7AJ0023786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614AbYJ1TIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 15:08:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rainbow-software.org, alan@redhat.com, jeff@garzik.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pata_it821x in 2.6.27: works but no LBA48 and "hdparm -t" is slower
has been removed from the -mm tree.  Its filename was
     pata_it821x-in-2627-works-but-no-lba48-and-hdparm-t-is-slower.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pata_it821x in 2.6.27: works but no LBA48 and "hdparm -t" is slower
From: Ondrej Zary <linux@rainbow-software.org>

This patch fixes LBA48 on pata_it821x RAID volumes - and to my surprise, also
increases the "hdparm -t" speed back. Haven't tested access to >128GB area.

ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
pata_it821x 0000:00:12.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
pata_it821x: controller in smart mode.
pata_it821x 0000:00:12.0: setting latency timer to 64
pata_it821x: Firmware 02/09/3030
0: MWDMA2 RAID1RAID 0+1 Volume: 0 SAMSUNG HD400LD
1: MWDMA2 RAID1RAID 0+1 Volume: 0 SAMSUNG HD400LD
scsi2 : pata_it821x
scsi3 : pata_it821x
ata3: PATA max UDMA/133 cmd 0x6800 ctl 0x6c00 bmdma 0x7800 irq 11
ata4: PATA max UDMA/133 cmd 0x7000 ctl 0x7400 bmdma 0x7808 irq 11
ata3.00: ATA-4: Integrated Technology Express Inc, , max MWDMA2
ata3.00: 781422766 sectors, multi 0: LBA48
ata3.00: RAID1 volume.
ata3.00: configured for DMA
scsi 2:0:0:0: Direct-Access     ATA      Integrated Techn n/a  PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 781422766 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 781422766 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4
sd 2:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0

/dev/sdb:
 Timing buffered disk reads:   60 MB in  3.01 seconds =  19.91 MB/sec

Fix LBA48 on pata_it821x RAID volumes.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <stable@kernel.org>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_it821x.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/ata/pata_it821x.c~pata_it821x-in-2627-works-but-no-lba48-and-hdparm-t-is-slower drivers/ata/pata_it821x.c
--- a/drivers/ata/pata_it821x.c~pata_it821x-in-2627-works-but-no-lba48-and-hdparm-t-is-slower
+++ a/drivers/ata/pata_it821x.c
@@ -557,9 +557,8 @@ static unsigned int it821x_read_id(struc
 	if (strstr(model_num, "Integrated Technology Express")) {
 		/* Set feature bits the firmware neglects */
 		id[49] |= 0x0300;	/* LBA, DMA */
-		id[82] |= 0x0400;	/* LBA48 */
 		id[83] &= 0x7FFF;
-		id[83] |= 0x4000;	/* Word 83 is valid */
+		id[83] |= 0x4400;	/* Word 83 is valid and LBA48 */
 		id[86] |= 0x0400;	/* LBA48 on */
 		id[ATA_ID_MAJOR_VER] |= 0x1F;
 	}
_

Patches currently in -mm which might be from linux@rainbow-software.org are

origin.patch


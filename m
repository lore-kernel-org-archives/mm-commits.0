From: akpm@linux-foundation.org
Subject: - ata-remove-fit-macro.patch removed from -mm tree
Date: Tue, 20 May 2008 14:14:14 -0700
Message-ID: <200805202114.m4KLEEl4011445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760936AbYETVXz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:23:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ata: remove FIT() macro
has been removed from the -mm tree.  Its filename was
     ata-remove-fit-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ata: remove FIT() macro
From: Harvey Harrison <harvey.harrison@gmail.com>

Use the kernel-provided clamp_val() macro.

FIT was always applied to a member of struct ata_timing (unsigned short)
and two constants.  clamp_val will not cast to short anymore.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_ali.c     |   10 +++----
 drivers/ata/pata_amd.c     |   14 ++++-----
 drivers/ata/pata_cypress.c |    8 ++---
 drivers/ata/pata_legacy.c  |   50 +++++++++++++++++------------------
 drivers/ata/pata_ns87410.c |    6 ++--
 drivers/ata/pata_ns87415.c |    4 +-
 drivers/ata/pata_qdi.c     |   16 +++++------
 drivers/ata/pata_via.c     |   14 ++++-----
 drivers/ata/pata_winbond.c |    6 ++--
 include/linux/libata.h     |    2 -
 10 files changed, 64 insertions(+), 66 deletions(-)

diff -puN drivers/ata/pata_ali.c~ata-remove-fit-macro drivers/ata/pata_ali.c
--- a/drivers/ata/pata_ali.c~ata-remove-fit-macro
+++ a/drivers/ata/pata_ali.c
@@ -177,11 +177,11 @@ static void ali_program_modes(struct ata
 	u8 udma;
 
 	if (t != NULL) {
-		t->setup = FIT(t->setup, 1, 8) & 7;
-		t->act8b = FIT(t->act8b, 1, 8) & 7;
-		t->rec8b = FIT(t->rec8b, 1, 16) & 15;
-		t->active = FIT(t->active, 1, 8) & 7;
-		t->recover = FIT(t->recover, 1, 16) & 15;
+		t->setup = clamp_val(t->setup, 1, 8) & 7;
+		t->act8b = clamp_val(t->act8b, 1, 8) & 7;
+		t->rec8b = clamp_val(t->rec8b, 1, 16) & 15;
+		t->active = clamp_val(t->active, 1, 8) & 7;
+		t->recover = clamp_val(t->recover, 1, 16) & 15;
 
 		pci_write_config_byte(pdev, cas, t->setup);
 		pci_write_config_byte(pdev, cbt, (t->act8b << 4) | t->rec8b);
diff -puN drivers/ata/pata_amd.c~ata-remove-fit-macro drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~ata-remove-fit-macro
+++ a/drivers/ata/pata_amd.c
@@ -84,32 +84,32 @@ static void timing_setup(struct ata_port
 
 	/* Configure the address set up timing */
 	pci_read_config_byte(pdev, offset + 0x0C, &t);
-	t = (t & ~(3 << ((3 - dn) << 1))) | ((FIT(at.setup, 1, 4) - 1) << ((3 - dn) << 1));
+	t = (t & ~(3 << ((3 - dn) << 1))) | ((clamp_val(at.setup, 1, 4) - 1) << ((3 - dn) << 1));
 	pci_write_config_byte(pdev, offset + 0x0C , t);
 
 	/* Configure the 8bit I/O timing */
 	pci_write_config_byte(pdev, offset + 0x0E + (1 - (dn >> 1)),
-		((FIT(at.act8b, 1, 16) - 1) << 4) | (FIT(at.rec8b, 1, 16) - 1));
+		((clamp_val(at.act8b, 1, 16) - 1) << 4) | (clamp_val(at.rec8b, 1, 16) - 1));
 
 	/* Drive timing */
 	pci_write_config_byte(pdev, offset + 0x08 + (3 - dn),
-		((FIT(at.active, 1, 16) - 1) << 4) | (FIT(at.recover, 1, 16) - 1));
+		((clamp_val(at.active, 1, 16) - 1) << 4) | (clamp_val(at.recover, 1, 16) - 1));
 
 	switch (clock) {
 		case 1:
-		t = at.udma ? (0xc0 | (FIT(at.udma, 2, 5) - 2)) : 0x03;
+		t = at.udma ? (0xc0 | (clamp_val(at.udma, 2, 5) - 2)) : 0x03;
 		break;
 
 		case 2:
-		t = at.udma ? (0xc0 | amd_cyc2udma[FIT(at.udma, 2, 10)]) : 0x03;
+		t = at.udma ? (0xc0 | amd_cyc2udma[clamp_val(at.udma, 2, 10)]) : 0x03;
 		break;
 
 		case 3:
-		t = at.udma ? (0xc0 | amd_cyc2udma[FIT(at.udma, 1, 10)]) : 0x03;
+		t = at.udma ? (0xc0 | amd_cyc2udma[clamp_val(at.udma, 1, 10)]) : 0x03;
 		break;
 
 		case 4:
-		t = at.udma ? (0xc0 | amd_cyc2udma[FIT(at.udma, 1, 15)]) : 0x03;
+		t = at.udma ? (0xc0 | amd_cyc2udma[clamp_val(at.udma, 1, 15)]) : 0x03;
 		break;
 
 		default:
diff -puN drivers/ata/pata_cypress.c~ata-remove-fit-macro drivers/ata/pata_cypress.c
--- a/drivers/ata/pata_cypress.c~ata-remove-fit-macro
+++ a/drivers/ata/pata_cypress.c
@@ -62,14 +62,14 @@ static void cy82c693_set_piomode(struct 
 		return;
 	}
 
-	time_16 = FIT(t.recover, 0, 15) | (FIT(t.active, 0, 15) << 4);
-	time_8 = FIT(t.act8b, 0, 15) | (FIT(t.rec8b, 0, 15) << 4);
+	time_16 = clamp_val(t.recover, 0, 15) | (clamp_val(t.active, 0, 15) << 4);
+	time_8 = clamp_val(t.act8b, 0, 15) | (clamp_val(t.rec8b, 0, 15) << 4);
 
 	if (adev->devno == 0) {
 		pci_read_config_dword(pdev, CY82_IDE_ADDRSETUP, &addr);
 
 		addr &= ~0x0F;	/* Mask bits */
-		addr |= FIT(t.setup, 0, 15);
+		addr |= clamp_val(t.setup, 0, 15);
 
 		pci_write_config_dword(pdev, CY82_IDE_ADDRSETUP, addr);
 		pci_write_config_byte(pdev, CY82_IDE_MASTER_IOR, time_16);
@@ -79,7 +79,7 @@ static void cy82c693_set_piomode(struct 
 		pci_read_config_dword(pdev, CY82_IDE_ADDRSETUP, &addr);
 
 		addr &= ~0xF0;	/* Mask bits */
-		addr |= (FIT(t.setup, 0, 15) << 4);
+		addr |= (clamp_val(t.setup, 0, 15) << 4);
 
 		pci_write_config_dword(pdev, CY82_IDE_ADDRSETUP, addr);
 		pci_write_config_byte(pdev, CY82_IDE_SLAVE_IOR, time_16);
diff -puN drivers/ata/pata_legacy.c~ata-remove-fit-macro drivers/ata/pata_legacy.c
--- a/drivers/ata/pata_legacy.c~ata-remove-fit-macro
+++ a/drivers/ata/pata_legacy.c
@@ -343,8 +343,8 @@ static void ht6560a_set_piomode(struct a
 	/* Get the timing data in cycles. For now play safe at 50Mhz */
 	ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
 
-	active = FIT(t.active, 2, 15);
-	recover = FIT(t.recover, 4, 15);
+	active = clamp_val(t.active, 2, 15);
+	recover = clamp_val(t.recover, 4, 15);
 
 	inb(0x3E6);
 	inb(0x3E6);
@@ -377,8 +377,8 @@ static void ht6560b_set_piomode(struct a
 	/* Get the timing data in cycles. For now play safe at 50Mhz */
 	ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
 
-	active = FIT(t.active, 2, 15);
-	recover = FIT(t.recover, 2, 16);
+	active = clamp_val(t.active, 2, 15);
+	recover = clamp_val(t.recover, 2, 16);
 	recover &= 0x15;
 
 	inb(0x3E6);
@@ -462,9 +462,9 @@ static void opti82c611a_set_piomode(stru
 		ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
 	}
 
-	active = FIT(t.active, 2, 17) - 2;
-	recover = FIT(t.recover, 1, 16) - 1;
-	setup = FIT(t.setup, 1, 4) - 1;
+	active = clamp_val(t.active, 2, 17) - 2;
+	recover = clamp_val(t.recover, 1, 16) - 1;
+	setup = clamp_val(t.setup, 1, 4) - 1;
 
 	/* Select the right timing bank for write timing */
 	rc = ioread8(ap->ioaddr.lbal_addr);
@@ -541,9 +541,9 @@ static void opti82c46x_set_piomode(struc
 		ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
 	}
 
-	active = FIT(t.active, 2, 17) - 2;
-	recover = FIT(t.recover, 1, 16) - 1;
-	setup = FIT(t.setup, 1, 4) - 1;
+	active = clamp_val(t.active, 2, 17) - 2;
+	recover = clamp_val(t.recover, 1, 16) - 1;
+	setup = clamp_val(t.setup, 1, 4) - 1;
 
 	/* Select the right timing bank for write timing */
 	rc = ioread8(ap->ioaddr.lbal_addr);
@@ -624,11 +624,11 @@ static void qdi6500_set_piomode(struct a
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
 	if (ld_qdi->fast) {
-		active = 8 - FIT(t.active, 1, 8);
-		recovery = 18 - FIT(t.recover, 3, 18);
+		active = 8 - clamp_val(t.active, 1, 8);
+		recovery = 18 - clamp_val(t.recover, 3, 18);
 	} else {
-		active = 9 - FIT(t.active, 2, 9);
-		recovery = 15 - FIT(t.recover, 0, 15);
+		active = 9 - clamp_val(t.active, 2, 9);
+		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
 
@@ -658,11 +658,11 @@ static void qdi6580dp_set_piomode(struct
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
 	if (ld_qdi->fast) {
-		active = 8 - FIT(t.active, 1, 8);
-		recovery = 18 - FIT(t.recover, 3, 18);
+		active = 8 - clamp_val(t.active, 1, 8);
+		recovery = 18 - clamp_val(t.recover, 3, 18);
 	} else {
-		active = 9 - FIT(t.active, 2, 9);
-		recovery = 15 - FIT(t.recover, 0, 15);
+		active = 9 - clamp_val(t.active, 2, 9);
+		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
 
@@ -695,11 +695,11 @@ static void qdi6580_set_piomode(struct a
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
 	if (ld_qdi->fast) {
-		active = 8 - FIT(t.active, 1, 8);
-		recovery = 18 - FIT(t.recover, 3, 18);
+		active = 8 - clamp_val(t.active, 1, 8);
+		recovery = 18 - clamp_val(t.recover, 3, 18);
 	} else {
-		active = 9 - FIT(t.active, 2, 9);
-		recovery = 15 - FIT(t.recover, 0, 15);
+		active = 9 - clamp_val(t.active, 2, 9);
+		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
 	ld_qdi->clock[adev->devno] = timing;
@@ -830,8 +830,8 @@ static void winbond_set_piomode(struct a
 	else
 		ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
-	active = (FIT(t.active, 3, 17) - 1) & 0x0F;
-	recovery = (FIT(t.recover, 1, 15) + 1) & 0x0F;
+	active = (clamp_val(t.active, 3, 17) - 1) & 0x0F;
+	recovery = (clamp_val(t.recover, 1, 15) + 1) & 0x0F;
 	timing = (active << 4) | recovery;
 	winbond_writecfg(ld_winbond->timing, timing, reg);
 
@@ -842,7 +842,7 @@ static void winbond_set_piomode(struct a
 		reg |= 0x08;	/* FIFO off */
 	if (!ata_pio_need_iordy(adev))
 		reg |= 0x02;	/* IORDY off */
-	reg |= (FIT(t.setup, 0, 3) << 6);
+	reg |= (clamp_val(t.setup, 0, 3) << 6);
 	winbond_writecfg(ld_winbond->timing, timing + 1, reg);
 }
 
diff -puN drivers/ata/pata_ns87410.c~ata-remove-fit-macro drivers/ata/pata_ns87410.c
--- a/drivers/ata/pata_ns87410.c~ata-remove-fit-macro
+++ a/drivers/ata/pata_ns87410.c
@@ -91,9 +91,9 @@ static void ns87410_set_piomode(struct a
 		return;
 	}
 
-	at.active = FIT(at.active, 2, 16) - 2;
-	at.setup = FIT(at.setup, 1, 4) - 1;
-	at.recover = FIT(at.recover, 1, 12) - 1;
+	at.active = clamp_val(at.active, 2, 16) - 2;
+	at.setup = clamp_val(at.setup, 1, 4) - 1;
+	at.recover = clamp_val(at.recover, 1, 12) - 1;
 
 	idetcr = (at.setup << 6) | (recoverbits[at.recover] << 3) | activebits[at.active];
 
diff -puN drivers/ata/pata_ns87415.c~ata-remove-fit-macro drivers/ata/pata_ns87415.c
--- a/drivers/ata/pata_ns87415.c~ata-remove-fit-macro
+++ a/drivers/ata/pata_ns87415.c
@@ -66,8 +66,8 @@ static void ns87415_set_mode(struct ata_
 
 	ata_timing_compute(adev, adev->pio_mode, &t, T, 0);
 
-	clocking = 17 - FIT(t.active, 2, 17);
-	clocking |= (16 - FIT(t.recover, 1, 16)) << 4;
+	clocking = 17 - clamp_val(t.active, 2, 17);
+	clocking |= (16 - clamp_val(t.recover, 1, 16)) << 4;
  	/* Use the same timing for read and write bytes */
 	clocking |= (clocking << 8);
 	pci_write_config_word(dev, timing, clocking);
diff -puN drivers/ata/pata_qdi.c~ata-remove-fit-macro drivers/ata/pata_qdi.c
--- a/drivers/ata/pata_qdi.c~ata-remove-fit-macro
+++ a/drivers/ata/pata_qdi.c
@@ -60,11 +60,11 @@ static void qdi6500_set_piomode(struct a
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
 	if (qdi->fast) {
-		active = 8 - FIT(t.active, 1, 8);
-		recovery = 18 - FIT(t.recover, 3, 18);
+		active = 8 - clamp_val(t.active, 1, 8);
+		recovery = 18 - clamp_val(t.recover, 3, 18);
 	} else {
-		active = 9 - FIT(t.active, 2, 9);
-		recovery = 15 - FIT(t.recover, 0, 15);
+		active = 9 - clamp_val(t.active, 2, 9);
+		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
 
@@ -84,11 +84,11 @@ static void qdi6580_set_piomode(struct a
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
 	if (qdi->fast) {
-		active = 8 - FIT(t.active, 1, 8);
-		recovery = 18 - FIT(t.recover, 3, 18);
+		active = 8 - clamp_val(t.active, 1, 8);
+		recovery = 18 - clamp_val(t.recover, 3, 18);
 	} else {
-		active = 9 - FIT(t.active, 2, 9);
-		recovery = 15 - FIT(t.recover, 0, 15);
+		active = 9 - clamp_val(t.active, 2, 9);
+		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
 
diff -puN drivers/ata/pata_via.c~ata-remove-fit-macro drivers/ata/pata_via.c
--- a/drivers/ata/pata_via.c~ata-remove-fit-macro
+++ a/drivers/ata/pata_via.c
@@ -259,15 +259,15 @@ static void via_do_set_mode(struct ata_p
 
 		pci_read_config_byte(pdev, 0x4C, &setup);
 		setup &= ~(3 << shift);
-		setup |= FIT(t.setup, 1, 4) << shift;	/* 1,4 or 1,4 - 1  FIXME */
+		setup |= clamp_val(t.setup, 1, 4) << shift;	/* 1,4 or 1,4 - 1  FIXME */
 		pci_write_config_byte(pdev, 0x4C, setup);
 	}
 
 	/* Load the PIO mode bits */
 	pci_write_config_byte(pdev, 0x4F - ap->port_no,
-		((FIT(t.act8b, 1, 16) - 1) << 4) | (FIT(t.rec8b, 1, 16) - 1));
+		((clamp_val(t.act8b, 1, 16) - 1) << 4) | (clamp_val(t.rec8b, 1, 16) - 1));
 	pci_write_config_byte(pdev, 0x48 + offset,
-		((FIT(t.active, 1, 16) - 1) << 4) | (FIT(t.recover, 1, 16) - 1));
+		((clamp_val(t.active, 1, 16) - 1) << 4) | (clamp_val(t.recover, 1, 16) - 1));
 
 	/* Load the UDMA bits according to type */
 	switch(udma_type) {
@@ -275,16 +275,16 @@ static void via_do_set_mode(struct ata_p
 			/* BUG() ? */
 			/* fall through */
 		case 33:
-			ut = t.udma ? (0xe0 | (FIT(t.udma, 2, 5) - 2)) : 0x03;
+			ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 5) - 2)) : 0x03;
 			break;
 		case 66:
-			ut = t.udma ? (0xe8 | (FIT(t.udma, 2, 9) - 2)) : 0x0f;
+			ut = t.udma ? (0xe8 | (clamp_val(t.udma, 2, 9) - 2)) : 0x0f;
 			break;
 		case 100:
-			ut = t.udma ? (0xe0 | (FIT(t.udma, 2, 9) - 2)) : 0x07;
+			ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
 			break;
 		case 133:
-			ut = t.udma ? (0xe0 | (FIT(t.udma, 2, 9) - 2)) : 0x07;
+			ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
 			break;
 	}
 
diff -puN drivers/ata/pata_winbond.c~ata-remove-fit-macro drivers/ata/pata_winbond.c
--- a/drivers/ata/pata_winbond.c~ata-remove-fit-macro
+++ a/drivers/ata/pata_winbond.c
@@ -75,8 +75,8 @@ static void winbond_set_piomode(struct a
 	else
 		ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
-	active = (FIT(t.active, 3, 17) - 1) & 0x0F;
-	recovery = (FIT(t.recover, 1, 15) + 1) & 0x0F;
+	active = (clamp_val(t.active, 3, 17) - 1) & 0x0F;
+	recovery = (clamp_val(t.recover, 1, 15) + 1) & 0x0F;
 	timing = (active << 4) | recovery;
 	winbond_writecfg(winbond->config, timing, reg);
 
@@ -87,7 +87,7 @@ static void winbond_set_piomode(struct a
 		reg |= 0x08;	/* FIFO off */
 	if (!ata_pio_need_iordy(adev))
 		reg |= 0x02;	/* IORDY off */
-	reg |= (FIT(t.setup, 0, 3) << 6);
+	reg |= (clamp_val(t.setup, 0, 3) << 6);
 	winbond_writecfg(winbond->config, timing + 1, reg);
 }
 
diff -puN include/linux/libata.h~ata-remove-fit-macro include/linux/libata.h
--- a/include/linux/libata.h~ata-remove-fit-macro
+++ a/include/linux/libata.h
@@ -821,8 +821,6 @@ struct ata_timing {
 	unsigned short udma;		/* t2CYCTYP/2 */
 };
 
-#define FIT(v, vmin, vmax)	max_t(short, min_t(short, v, vmax), vmin)
-
 /*
  * Core layer - drivers/ata/libata-core.c
  */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
git-input.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
video-fix-integer-as-null-pointer-warnings.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch


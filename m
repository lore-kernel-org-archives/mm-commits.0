From: akpm@linux-foundation.org
Subject: + ata-remove-fit-macro.patch added to -mm tree
Date: Fri, 14 Mar 2008 12:48:15 -0700
Message-ID: <200803141948.m2EJmFtM016305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857AbYCNTtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 15:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     ata: remove FIT() macro
has been added to the -mm tree.  Its filename is
     ata-remove-fit-macro.patch

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
@@ -173,11 +173,11 @@ static void ali_program_modes(struct ata
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
@@ -414,8 +414,8 @@ static void ht6560a_set_piomode(struct a
 	/* Get the timing data in cycles. For now play safe at 50Mhz */
 	ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
 
-	active = FIT(t.active, 2, 15);
-	recover = FIT(t.recover, 4, 15);
+	active = clamp_val(t.active, 2, 15);
+	recover = clamp_val(t.recover, 4, 15);
 
 	inb(0x3E6);
 	inb(0x3E6);
@@ -470,8 +470,8 @@ static void ht6560b_set_piomode(struct a
 	/* Get the timing data in cycles. For now play safe at 50Mhz */
 	ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
 
-	active = FIT(t.active, 2, 15);
-	recover = FIT(t.recover, 2, 16);
+	active = clamp_val(t.active, 2, 15);
+	recover = clamp_val(t.recover, 2, 16);
 	recover &= 0x15;
 
 	inb(0x3E6);
@@ -577,9 +577,9 @@ static void opti82c611a_set_piomode(stru
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
@@ -678,9 +678,9 @@ static void opti82c46x_set_piomode(struc
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
@@ -782,11 +782,11 @@ static void qdi6500_set_piomode(struct a
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
 
@@ -816,11 +816,11 @@ static void qdi6580dp_set_piomode(struct
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
 
@@ -853,11 +853,11 @@ static void qdi6580_set_piomode(struct a
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
@@ -1050,8 +1050,8 @@ static void winbond_set_piomode(struct a
 	else
 		ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
-	active = (FIT(t.active, 3, 17) - 1) & 0x0F;
-	recovery = (FIT(t.recover, 1, 15) + 1) & 0x0F;
+	active = (clamp_val(t.active, 3, 17) - 1) & 0x0F;
+	recovery = (clamp_val(t.recover, 1, 15) + 1) & 0x0F;
 	timing = (active << 4) | recovery;
 	winbond_writecfg(ld_winbond->timing, timing, reg);
 
@@ -1062,7 +1062,7 @@ static void winbond_set_piomode(struct a
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
@@ -105,9 +105,9 @@ static void ns87410_set_piomode(struct a
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
@@ -271,15 +271,15 @@ static void via_do_set_mode(struct ata_p
 
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
@@ -287,16 +287,16 @@ static void via_do_set_mode(struct ata_p
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
@@ -755,8 +755,6 @@ struct ata_timing {
 	unsigned short udma;		/* t2CYCTYP/2 */
 };
 
-#define FIT(v, vmin, vmax)	max_t(short, min_t(short, v, vmax), vmin)
-
 extern const unsigned long sata_deb_timing_normal[];
 extern const unsigned long sata_deb_timing_hotplug[];
 extern const unsigned long sata_deb_timing_long[];
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
git-acpi.patch
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
git-cifs.patch
cifs-remove-global_extern-macro.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
git-ieee1394.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
git-async-tx.patch
git-mips.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
power-replace-remaining-__function__-occurrences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ioc3c-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
ext2-replace-remaining-__function__-occurrences.patch
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch


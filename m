From: akpm@linux-foundation.org
Subject: - libata-add-ata_cbl_pata_ign.patch removed from -mm tree
Date: Mon, 03 Dec 2007 23:38:10 -0800
Message-ID: <200712040738.lB47cAdC006878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45081 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791AbXLDHjG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 02:39:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     libata: add ATA_CBL_PATA_IGN
has been removed from the -mm tree.  Its filename was
     libata-add-ata_cbl_pata_ign.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: add ATA_CBL_PATA_IGN
From: Tejun Heo <htejun@gmail.com>

ATA_CBL_PATA_UNK indicates that the cable type can't be determined from the
host side and might be either 80c or 40c.  libata applies drive or other
generic limit in this case.  However, there are controllers where both host
and drive side detections are misimplemented and the driver has to rely solely
on private method - peeking BIOS or ACPI configuration or using some other
private mechanism.

This patch adds ATA_CBL_PATA_IGN which tells libata to ignore the cable type
completely and just let the LLD determine the transfer mode via host transfer
mode masks and ->mode_filter().

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   13 +++++++++++++
 include/linux/ata.h       |    7 ++++---
 include/linux/libata.h    |    1 +
 3 files changed, 18 insertions(+), 3 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-add-ata_cbl_pata_ign drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-add-ata_cbl_pata_ign
+++ a/drivers/ata/libata-core.c
@@ -2345,6 +2345,18 @@ int ata_cable_unknown(struct ata_port *a
 }
 
 /**
+ *	ata_cable_ignore	-	return ignored PATA cable.
+ *	@ap: port
+ *
+ *	Helper method for drivers which don't use cable type to limit
+ *	transfer mode.
+ */
+int ata_cable_ignore(struct ata_port *ap)
+{
+	return ATA_CBL_PATA_IGN;
+}
+
+/**
  *	ata_cable_sata	-	return SATA cable type
  *	@ap: port
  *
@@ -7713,4 +7725,5 @@ EXPORT_SYMBOL_GPL(ata_dev_try_classify);
 EXPORT_SYMBOL_GPL(ata_cable_40wire);
 EXPORT_SYMBOL_GPL(ata_cable_80wire);
 EXPORT_SYMBOL_GPL(ata_cable_unknown);
+EXPORT_SYMBOL_GPL(ata_cable_ignore);
 EXPORT_SYMBOL_GPL(ata_cable_sata);
diff -puN include/linux/ata.h~libata-add-ata_cbl_pata_ign include/linux/ata.h
--- a/include/linux/ata.h~libata-add-ata_cbl_pata_ign
+++ a/include/linux/ata.h
@@ -271,9 +271,10 @@ enum {
 	ATA_CBL_NONE		= 0,
 	ATA_CBL_PATA40		= 1,
 	ATA_CBL_PATA80		= 2,
-	ATA_CBL_PATA40_SHORT	= 3,		/* 40 wire cable to high UDMA spec */
-	ATA_CBL_PATA_UNK	= 4,
-	ATA_CBL_SATA		= 5,
+	ATA_CBL_PATA40_SHORT	= 3,	/* 40 wire cable to high UDMA spec */
+	ATA_CBL_PATA_UNK	= 4,	/* don't know, maybe 80c? */
+	ATA_CBL_PATA_IGN	= 5,	/* don't know, ignore cable handling */
+	ATA_CBL_SATA		= 6,
 
 	/* SATA Status and Control Registers */
 	SCR_STATUS		= 0,
diff -puN include/linux/libata.h~libata-add-ata_cbl_pata_ign include/linux/libata.h
--- a/include/linux/libata.h~libata-add-ata_cbl_pata_ign
+++ a/include/linux/libata.h
@@ -919,6 +919,7 @@ extern u8 ata_irq_on(struct ata_port *ap
 extern int ata_cable_40wire(struct ata_port *ap);
 extern int ata_cable_80wire(struct ata_port *ap);
 extern int ata_cable_sata(struct ata_port *ap);
+extern int ata_cable_ignore(struct ata_port *ap);
 extern int ata_cable_unknown(struct ata_port *ap);
 
 /*
_

Patches currently in -mm which might be from htejun@gmail.com are

git-libata-all.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch
libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch
sata_nv-dont-use-legacy-dma-in-adma-mode-v3.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
ata-ahci-enclosure-management-via-led.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
scsi-early-detection-of-medium-not-present-updated.patch

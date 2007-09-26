From: akpm@linux-foundation.org
Subject: + libata_scsi-fix-transfer-lengths.patch added to -mm tree
Date: Wed, 26 Sep 2007 15:45:53 -0700
Message-ID: <200709262245.l8QMjrGM007801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34666 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758818AbXIZWqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 18:46:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata_scsi: Fix transfer lengths
has been added to the -mm tree.  Its filename is
     libata_scsi-fix-transfer-lengths.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata_scsi: Fix transfer lengths
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This should get into the base tree very soon anyway but it fixes a ton of
devices so it would be nice to have in -mm so I can get people to test -mm not
"-mm + a bit" when reporting ATAPI problems.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/ata/libata-scsi.c~libata_scsi-fix-transfer-lengths drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~libata_scsi-fix-transfer-lengths
+++ a/drivers/ata/libata-scsi.c
@@ -2345,8 +2345,8 @@ static void atapi_request_sense(struct a
 		qc->tf.feature |= ATAPI_PKT_DMA;
 	} else {
 		qc->tf.protocol = ATA_PROT_ATAPI;
-		qc->tf.lbam = (8 * 1024) & 0xff;
-		qc->tf.lbah = (8 * 1024) >> 8;
+		qc->tf.lbam = SCSI_SENSE_BUFFERSIZE;
+		qc->tf.lbah = 0;
 	}
 	qc->nbytes = SCSI_SENSE_BUFFERSIZE;
 
@@ -2455,6 +2455,7 @@ static unsigned int atapi_xlat(struct at
 	struct ata_device *dev = qc->dev;
 	int using_pio = (dev->flags & ATA_DFLAG_PIO);
 	int nodata = (scmd->sc_data_direction == DMA_NONE);
+	unsigned int nbytes;
 
 	memset(qc->cdb, 0, dev->cdb_len);
 	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
@@ -2474,14 +2475,20 @@ static unsigned int atapi_xlat(struct at
 	if (!using_pio && ata_check_atapi_dma(qc))
 		using_pio = 1;
 
+	/* Some controller variants snoop this value for Packet transfers
+	   to do state machine and FIFO management. Thus we want to set it
+	   properly, and for DMA where it is effectively meaningless */
+	nbytes = min(qc->nbytes, (unsigned int)63 * 1024);
+
+	qc->tf.lbam = (nbytes & 0xFF);
+	qc->tf.lbah = (nbytes >> 8);
+
 	if (using_pio || nodata) {
 		/* no data, or PIO data xfer */
 		if (nodata)
 			qc->tf.protocol = ATA_PROT_ATAPI_NODATA;
 		else
 			qc->tf.protocol = ATA_PROT_ATAPI;
-		qc->tf.lbam = (8 * 1024) & 0xff;
-		qc->tf.lbah = (8 * 1024) >> 8;
 	} else {
 		/* DMA data xfer */
 		qc->tf.protocol = ATA_PROT_ATAPI_DMA;
@@ -2492,6 +2499,9 @@ static unsigned int atapi_xlat(struct at
 			qc->tf.feature |= ATAPI_DMADIR;
 	}
 
+
+	/* FIXME: We need to translate 0x05 READ_BLOCK_LIMITS to a MODE_SENSE
+	   as ATAPI tape drives don't get this right otherwise */
 	return 0;
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
pata_acpi-use-ata_sff_port_start.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch
pata_pdc202xx_old-fix-timings.patch
pata_ns87415-initial-cut-at-87415-87560-ide-support.patch
fix-hpa-handling-regression.patch
libata_scsi-fix-transfer-lengths.patch
pata_atiixp-audit-notes-on-locking.patch
pata_hpt3x2n-clean-up-dpll-stuff.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
tty-bring-the-old-cris-driver-back-somewhere-into-the.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
ide-cd-is-unmaintained.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch

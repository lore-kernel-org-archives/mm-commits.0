From: akpm@linux-foundation.org
Subject: - libata_scsi-fix-transfer-lengths.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:57:04 -0700
Message-ID: <200710051957.l95Jv4wW022435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763433AbXJEUBY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata_scsi: Fix transfer lengths
has been removed from the -mm tree.  Its filename was
     libata_scsi-fix-transfer-lengths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata_scsi: Fix transfer lengths
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This should get into the base tree very soon anyway but it fixes a ton of
devices so it would be nice to have in -mm so I can get people to test -mm not
"-mm + a bit" when reporting ATAPI problems.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN drivers/ata/libata-scsi.c~libata_scsi-fix-transfer-lengths drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~libata_scsi-fix-transfer-lengths
+++ a/drivers/ata/libata-scsi.c
@@ -2336,8 +2336,8 @@ static void atapi_request_sense(struct a
 		qc->tf.feature |= ATAPI_PKT_DMA;
 	} else {
 		qc->tf.protocol = ATA_PROT_ATAPI;
-		qc->tf.lbam = (8 * 1024) & 0xff;
-		qc->tf.lbah = (8 * 1024) >> 8;
+		qc->tf.lbam = SCSI_SENSE_BUFFERSIZE;
+		qc->tf.lbah = 0;
 	}
 	qc->nbytes = SCSI_SENSE_BUFFERSIZE;
 
@@ -2446,6 +2446,7 @@ static unsigned int atapi_xlat(struct at
 	struct ata_device *dev = qc->dev;
 	int using_pio = (dev->flags & ATA_DFLAG_PIO);
 	int nodata = (scmd->sc_data_direction == DMA_NONE);
+	unsigned int nbytes;
 
 	memset(qc->cdb, 0, dev->cdb_len);
 	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
@@ -2465,14 +2466,20 @@ static unsigned int atapi_xlat(struct at
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
@@ -2483,6 +2490,9 @@ static unsigned int atapi_xlat(struct at
 			qc->tf.feature |= ATAPI_DMADIR;
 	}
 
+
+	/* FIXME: We need to translate 0x05 READ_BLOCK_LIMITS to a MODE_SENSE
+	   as ATAPI tape drives don't get this right otherwise */
 	return 0;
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
git-scsi-misc.patch
initio-fix-conflict-when-loading-driver.patch
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
fs-correct-sus-compliance-for-open-of-large-file-without.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
funsoft-fix-termios.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
visor-termios-bits.patch

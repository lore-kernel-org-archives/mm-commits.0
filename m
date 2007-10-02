From: akpm@linux-foundation.org
Subject: - libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch removed from -mm tree
Date: Tue, 02 Oct 2007 15:11:20 -0700
Message-ID: <200710022211.l92MBK4Z025146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43628 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbXJBWLf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 18:11:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata: add a horkage entry for DRQ mishandling (atapi tapes)
has been removed from the -mm tree.  Its filename was
     libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: libata: add a horkage entry for DRQ mishandling (atapi tapes)
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This will allow us to handle the tape drive problems Mark Lord reported

On Thu, 20 Sep 2007 22:42:17 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > According to information I have received, some ATA (and possibly ATAPI?) 
> > devices intentionally return some data in these cases.  In the case of 
> > certain ATA devices, this returned data permits inspection of the 
> > incorrected data.
> 
> News to me. ATA like ST-506/ST-412 exposes error data on I/O READ/WRITE
> via the READ_BUFFER functionality but its basically useless without a lot
> of knowledge of the drive on anything post ST-412 era.
> 
> Got any references ?
> 
> The other possibility is to whine but accept it happens - on the other
> hand being lax about HSM errors is asking for corruption and it seems
> to be unique to this tape device.
> 
> (and someone please don't tell me early pre ATAPI standard devices are
> trying to return the sense data in this way or I'll be ill)

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    9 +++++++--
 include/linux/libata.h    |    1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-add-a-horkage-entry-for-drq-mishandling-atapi drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-add-a-horkage-entry-for-drq-mishandling-atapi
+++ a/drivers/ata/libata-core.c
@@ -5240,8 +5240,13 @@ fsm_start:
 		if (unlikely(status & (ATA_ERR | ATA_DF))) {
 			ata_port_printk(ap, KERN_WARNING, "DRQ=1 with device "
 					"error, dev_stat 0x%X\n", status);
-			qc->err_mask |= AC_ERR_HSM;
-			ap->hsm_task_state = HSM_ST_ERR;
+
+			/* Some tape drives muck this up so don't explode
+			   in those cases */
+			if (!(qc->dev->horkage & ATA_HORKAGE_DRQ)) {
+				qc->err_mask |= AC_ERR_HSM;
+				ap->hsm_task_state = HSM_ST_ERR;
+			}
 			goto fsm_start;
 		}
 
diff -puN include/linux/libata.h~libata-add-a-horkage-entry-for-drq-mishandling-atapi include/linux/libata.h
--- a/include/linux/libata.h~libata-add-a-horkage-entry-for-drq-mishandling-atapi
+++ a/include/linux/libata.h
@@ -338,6 +338,7 @@ enum {
 	ATA_HORKAGE_BROKEN_HPA	= (1 << 4),	/* Broken HPA */
 	ATA_HORKAGE_SKIP_PM	= (1 << 5),	/* Skip PM operations */
 	ATA_HORKAGE_HPA_SIZE	= (1 << 6),	/* native size off by one */
+	ATA_HORKAGE_DRQ		= (1 << 7),	/* Device forgets to clear DRQ on error */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT 
 	    renumber */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
libata-correct-handling-of-srst-reset-sequences.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch
libata_scsi-fix-transfer-lengths.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
fix-ide-legacy-mode-resources.patch
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

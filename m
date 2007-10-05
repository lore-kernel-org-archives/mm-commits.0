From: akpm@linux-foundation.org
Subject: - libata-fix-hopefully-all-the-remaining-problems-with.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:57:06 -0700
Message-ID: <200710051957.l95Jv6uF022438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35917 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762564AbXJEUBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     libata: fix (hopefully) all the remaining problems with devices failing setup/identify
has been removed from the -mm tree.  Its filename was
     libata-fix-hopefully-all-the-remaining-problems-with.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: fix (hopefully) all the remaining problems with devices failing setup/identify
From: Alan <alan@lxorguk.ukuu.org.uk>

Two fixes in this test patch.  One of them allows old CF cards to refuse
pio mode setting, and one to wait for the drive to settle after a set
features changes the speed settings, which is based upon the workarounds
used by drivers/ide.

Please test and report back if you have an afflicted system.  This patch
isn't for merging just testing.

The CF card fix will still display errors when the card works (got fixes
for that once I know the cure works) but should then be found/usable.

Not signed off by anyone, not for merging


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN drivers/ata/libata-core.c~libata-fix-hopefully-all-the-remaining-problems-with drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-fix-hopefully-all-the-remaining-problems-with
+++ a/drivers/ata/libata-core.c
@@ -5933,6 +5933,7 @@ inline unsigned int ata_host_intr (struc
 {
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	u8 status, host_stat = 0;
+	int i;
 
 	VPRINTK("ata%u: protocol %d task_state %d\n",
 		ap->print_id, qc->tf.protocol, ap->hsm_task_state);
@@ -5989,6 +5990,20 @@ inline unsigned int ata_host_intr (struc
 	if (unlikely(status & ATA_BUSY))
 		goto idle_irq;
 
+	if (unlikely(qc->tf.command == ATA_CMD_SET_FEATURES &&
+			qc->tf.feature == SETFEATURES_XFER)) {
+		/* Let the timings change settle and the drive catch up as
+		   some hardware needs up to 10uS to get its brain back in
+		   gear. Taken from the workarounds in drivers/ide done by
+		   Matthew Faupel/Niccolo Rigacci */
+		for (i = 0; i < 10; i++) {
+			if ((status & (ATA_BUSY | ATA_DRQ | ATA_ERR)) == 0)
+				break;
+			udelay(1);
+			status = ata_chk_status(ap);
+		}
+	}
+
 	/* ack bmdma irq events */
 	ap->ops->irq_clear(ap);
 
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

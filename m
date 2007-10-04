From: akpm@linux-foundation.org
Subject: + initio-fix-conflict-when-loading-driver.patch added to -mm tree
Date: Thu, 04 Oct 2007 12:18:39 -0700
Message-ID: <200710041918.l94JIdmW024733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756658AbXJDTTL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 15:19:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, James.Bottomley@steeleye.com, alan@redhat.com, simps05192@yahoo.com


The patch titled
     initio: fix conflict when loading driver
has been added to the -mm tree.  Its filename is
     initio-fix-conflict-when-loading-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: initio: fix conflict when loading driver
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

> I have a scanner connected to a Initio INI-950 SCSI card and I recently
> upgraded from SuSE 10.2 to 10.3.  The new kernel doesn't see any of my
> devices.  I get the following in /var/log/messages:
>
> ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 17 (level, low) -> IRQ 16
> initio: I/O port range 0x0 is busy.
> ACPI: PCI interrupt for device 0000:00:0a.0 disabled

Humm not a collision - thats a bug in the driver updating.  Looks like the
changes I made and combined with Christoph's lost a line somewhere when I
was merging it all.  Try the following

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Scott Simpson <simps05192@yahoo.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/scsi/initio.c~initio-fix-conflict-when-loading-driver drivers/scsi/initio.c
--- a/drivers/scsi/initio.c~initio-fix-conflict-when-loading-driver
+++ a/drivers/scsi/initio.c
@@ -2866,6 +2866,7 @@ static int initio_probe_one(struct pci_d
 	}
 	host = (struct initio_host *)shost->hostdata;
 	memset(host, 0, sizeof(struct initio_host));
+	host->addr = pci_resource_start(pdev, 0);
 
 	if (!request_region(host->addr, 256, "i91u")) {
 		printk(KERN_WARNING "initio: I/O port range 0x%x is busy.\n", host->addr);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
libata-correct-handling-of-srst-reset-sequences.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
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

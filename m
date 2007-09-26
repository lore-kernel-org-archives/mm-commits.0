From: akpm@linux-foundation.org
Subject: + funsoft-fix-termios.patch added to -mm tree
Date: Wed, 26 Sep 2007 15:53:25 -0700
Message-ID: <200709262253.l8QMrPX5008109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46529 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759690AbXIZWyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 18:54:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com


The patch titled
     funsoft: fix termios
has been added to the -mm tree.  Its filename is
     funsoft-fix-termios.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: funsoft: fix termios
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Funsoft has a bogus ioctl handler doing bogus termios handling in a bogus
manner. Fortunately we can simply delete all the bogus bits and get the
right default behaviour !

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/usb/serial/funsoft.c~funsoft-fix-termios drivers/usb/serial/funsoft.c
--- a/drivers/usb/serial/funsoft.c~funsoft-fix-termios
+++ a/drivers/usb/serial/funsoft.c
@@ -24,26 +24,6 @@ static struct usb_device_id id_table [] 
 };
 MODULE_DEVICE_TABLE(usb, id_table);
 
-static int funsoft_ioctl(struct usb_serial_port *port, struct file *file,
-			 unsigned int cmd, unsigned long arg)
-{
-	struct ktermios t;
-
-	dbg("%s - port %d, cmd 0x%04x", __FUNCTION__, port->number, cmd);
-
-	if (cmd == TCSETSF) {
-		if (user_termios_to_kernel_termios(&t, (struct termios __user *)arg))
-			return -EFAULT;
-
-		dbg("%s - iflag:%x oflag:%x cflag:%x lflag:%x", __FUNCTION__,
-		    t.c_iflag, t.c_oflag, t.c_cflag, t.c_lflag);
-
-		if (!(t.c_lflag & ICANON))
-			return -EINVAL;
-	}
-	return -ENOIOCTLCMD;
-}
-
 static struct usb_driver funsoft_driver = {
 	.name =		"funsoft",
 	.probe =	usb_serial_probe,
@@ -63,7 +43,6 @@ static struct usb_serial_driver funsoft_
 	.num_bulk_in =		NUM_DONT_CARE,
 	.num_bulk_out =		NUM_DONT_CARE,
 	.num_ports =		1,
-	.ioctl =		funsoft_ioctl,
 };
 
 static int __init funsoft_init(void)
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

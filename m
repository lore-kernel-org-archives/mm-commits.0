From: akpm@linux-foundation.org
Subject: + empeg-clean-up-and-handle-speeds.patch added to -mm tree
Date: Wed, 26 Sep 2007 15:53:23 -0700
Message-ID: <200709262253.l8QMrN78008106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34191 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758143AbXIZWyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 18:54:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com


The patch titled
     empeg: clean up and handle speeds
has been added to the -mm tree.  Its filename is
     empeg-clean-up-and-handle-speeds.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: empeg: clean up and handle speeds
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The empeg is pretty fixed. Tidy up the long foo->bar->baz stuff and
encode the fixed speed properly.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/usb/serial/empeg.c~empeg-clean-up-and-handle-speeds drivers/usb/serial/empeg.c
--- a/drivers/usb/serial/empeg.c~empeg-clean-up-and-handle-speeds
+++ a/drivers/usb/serial/empeg.c
@@ -449,14 +449,9 @@ static int empeg_ioctl (struct usb_seria
 
 static void empeg_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
 {
-
+	struct ktermios *termios = port->tty->termios;
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
-	if ((!port->tty) || (!port->tty->termios)) {
-		dbg("%s - no tty structures", __FUNCTION__);
-		return;
-	}
-
 	/*
          * The empeg-car player wants these particular tty settings.
          * You could, for example, change the baud rate, however the
@@ -466,7 +461,7 @@ static void empeg_set_termios (struct us
          *
          * The default requirements for this device are:
          */
-	port->tty->termios->c_iflag
+	termios->c_iflag
 		&= ~(IGNBRK	/* disable ignore break */
 		| BRKINT	/* disable break causes interrupt */
 		| PARMRK	/* disable mark parity errors */
@@ -476,24 +471,23 @@ static void empeg_set_termios (struct us
 		| ICRNL		/* disable translate CR to NL */
 		| IXON);	/* disable enable XON/XOFF flow control */
 
-	port->tty->termios->c_oflag
+	termios->c_oflag
 		&= ~OPOST;	/* disable postprocess output characters */
 
-	port->tty->termios->c_lflag
+	termios->c_lflag
 		&= ~(ECHO	/* disable echo input characters */
 		| ECHONL	/* disable echo new line */
 		| ICANON	/* disable erase, kill, werase, and rprnt special characters */
 		| ISIG		/* disable interrupt, quit, and suspend special characters */
 		| IEXTEN);	/* disable non-POSIX special characters */
 
-	port->tty->termios->c_cflag
+	termios->c_cflag
 		&= ~(CSIZE	/* no size */
 		| PARENB	/* disable parity bit */
 		| CBAUD);	/* clear current baud rate */
 
-	port->tty->termios->c_cflag
-		|= (CS8		/* character size 8 bits */
-		| B115200);	/* baud rate 115200 */
+	termios->c_cflag
+		|= CS8;		/* character size 8 bits */
 
 	/*
 	 * Force low_latency on; otherwise the pushes are scheduled;
@@ -501,8 +495,7 @@ static void empeg_set_termios (struct us
 	 * on the floor.  We don't want to drop bytes on the floor. :)
 	 */
 	port->tty->low_latency = 1;
-
-	return;
+	tty_encode_baud_rate(port->tty, 115200, 115200);
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

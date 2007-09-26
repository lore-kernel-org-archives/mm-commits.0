From: akpm@linux-foundation.org
Subject: + keyspan-termios-tidy.patch added to -mm tree
Date: Wed, 26 Sep 2007 15:53:29 -0700
Message-ID: <200709262253.l8QMrTVa008122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55279 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760725AbXIZWyP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 18:54:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com


The patch titled
     keyspan termios tidy
has been added to the -mm tree.  Its filename is
     keyspan-termios-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: keyspan termios tidy
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Clear unsupported CMSPAR bit
- Clean up long chains of a->b-> a bit
- Encode baud rate back into tty structure properly

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/usb/serial/keyspan.c~keyspan-termios-tidy drivers/usb/serial/keyspan.c
--- a/drivers/usb/serial/keyspan.c~keyspan-termios-tidy
+++ a/drivers/usb/serial/keyspan.c
@@ -278,29 +278,35 @@ static void keyspan_set_termios (struct 
 	struct keyspan_port_private 	*p_priv;
 	const struct keyspan_device_details	*d_details;
 	unsigned int 			cflag;
+	struct tty_struct		*tty = port->tty;
 
 	dbg("%s", __FUNCTION__); 
 
 	p_priv = usb_get_serial_port_data(port);
 	d_details = p_priv->device_details;
-	cflag = port->tty->termios->c_cflag;
+	cflag = tty->termios->c_cflag;
 	device_port = port->number - port->serial->minor;
 
 	/* Baud rate calculation takes baud rate as an integer
 	   so other rates can be generated if desired. */
-	baud_rate = tty_get_baud_rate(port->tty);
+	baud_rate = tty_get_baud_rate(tty);
 	/* If no match or invalid, don't change */		
-	if (baud_rate >= 0
-	    && d_details->calculate_baud_rate(baud_rate, d_details->baudclk,
+	if (d_details->calculate_baud_rate(baud_rate, d_details->baudclk,
 				NULL, NULL, NULL, device_port) == KEYSPAN_BAUD_RATE_OK) {
 		/* FIXME - more to do here to ensure rate changes cleanly */
+		/* FIXME - calcuate exact rate from divisor ? */
 		p_priv->baud = baud_rate;
-	}
+	} else
+		baud_rate = tty_termios_baud_rate(old_termios);
 
+	tty_encode_baud_rate(tty, baud_rate, baud_rate);
 	/* set CTS/RTS handshake etc. */
 	p_priv->cflag = cflag;
 	p_priv->flow_control = (cflag & CRTSCTS)? flow_cts: flow_none;
 
+	/* Mark/Space not supported */
+	tty->termios->c_cflag &= ~CMSPAR;
+
 	keyspan_send_setup(port, 0);
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

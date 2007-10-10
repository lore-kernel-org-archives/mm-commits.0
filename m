From: akpm@linux-foundation.org
Subject: - visor-termios-bits.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:11:12 -0700
Message-ID: <200710102111.l9ALBCki026027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59362 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755935AbXJJVVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     visor: termios bits
has been removed from the -mm tree.  Its filename was
     visor-termios-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: visor: termios bits
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Visor has a huge complex routine which displays termios bits for debug but
doesn't do anything.  Get the correct behaviour by removing it all

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/usb/serial/visor.c~visor-termios-bits drivers/usb/serial/visor.c
--- a/drivers/usb/serial/visor.c~visor-termios-bits
+++ a/drivers/usb/serial/visor.c
@@ -46,7 +46,6 @@ static int  visor_probe		(struct usb_ser
 static int  visor_calc_num_ports(struct usb_serial *serial);
 static void visor_shutdown	(struct usb_serial *serial);
 static int  visor_ioctl		(struct usb_serial_port *port, struct file * file, unsigned int cmd, unsigned long arg);
-static void visor_set_termios	(struct usb_serial_port *port, struct ktermios *old_termios);
 static void visor_write_bulk_callback	(struct urb *urb);
 static void visor_read_bulk_callback	(struct urb *urb);
 static void visor_read_int_callback	(struct urb *urb);
@@ -203,7 +202,6 @@ static struct usb_serial_driver handspri
 	.calc_num_ports =	visor_calc_num_ports,
 	.shutdown =		visor_shutdown,
 	.ioctl =		visor_ioctl,
-	.set_termios =		visor_set_termios,
 	.write =		visor_write,
 	.write_room =		visor_write_room,
 	.chars_in_buffer =	visor_chars_in_buffer,
@@ -234,7 +232,6 @@ static struct usb_serial_driver clie_5_d
 	.calc_num_ports =	visor_calc_num_ports,
 	.shutdown =		visor_shutdown,
 	.ioctl =		visor_ioctl,
-	.set_termios =		visor_set_termios,
 	.write =		visor_write,
 	.write_room =		visor_write_room,
 	.chars_in_buffer =	visor_chars_in_buffer,
@@ -262,7 +259,6 @@ static struct usb_serial_driver clie_3_5
 	.unthrottle =		visor_unthrottle,
 	.attach =		clie_3_5_startup,
 	.ioctl =		visor_ioctl,
-	.set_termios =		visor_set_termios,
 	.write =		visor_write,
 	.write_room =		visor_write_room,
 	.chars_in_buffer =	visor_chars_in_buffer,
@@ -936,66 +932,6 @@ static int visor_ioctl (struct usb_seria
 	return -ENOIOCTLCMD;
 }
 
-
-/* This function is all nice and good, but we don't change anything based on it :) */
-static void visor_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
-{
-	unsigned int cflag;
-
-	dbg("%s - port %d", __FUNCTION__, port->number);
-
-	if ((!port->tty) || (!port->tty->termios)) {
-		dbg("%s - no tty structures", __FUNCTION__);
-		return;
-	}
-
-	cflag = port->tty->termios->c_cflag;
-
-	/* get the byte size */
-	switch (cflag & CSIZE) {
-		case CS5:	dbg("%s - data bits = 5", __FUNCTION__);   break;
-		case CS6:	dbg("%s - data bits = 6", __FUNCTION__);   break;
-		case CS7:	dbg("%s - data bits = 7", __FUNCTION__);   break;
-		default:
-		case CS8:	dbg("%s - data bits = 8", __FUNCTION__);   break;
-	}
-	
-	/* determine the parity */
-	if (cflag & PARENB)
-		if (cflag & PARODD)
-			dbg("%s - parity = odd", __FUNCTION__);
-		else
-			dbg("%s - parity = even", __FUNCTION__);
-	else
-		dbg("%s - parity = none", __FUNCTION__);
-
-	/* figure out the stop bits requested */
-	if (cflag & CSTOPB)
-		dbg("%s - stop bits = 2", __FUNCTION__);
-	else
-		dbg("%s - stop bits = 1", __FUNCTION__);
-
-	
-	/* figure out the flow control settings */
-	if (cflag & CRTSCTS)
-		dbg("%s - RTS/CTS is enabled", __FUNCTION__);
-	else
-		dbg("%s - RTS/CTS is disabled", __FUNCTION__);
-	
-	/* determine software flow control */
-	if (I_IXOFF(port->tty))
-		dbg("%s - XON/XOFF is enabled, XON = %2x, XOFF = %2x",
-		    __FUNCTION__, START_CHAR(port->tty), STOP_CHAR(port->tty));
-	else
-		dbg("%s - XON/XOFF is disabled", __FUNCTION__);
-
-	/* get the baud rate wanted */
-	dbg("%s - baud rate = %d", __FUNCTION__, tty_get_baud_rate(port->tty));
-
-	return;
-}
-
-
 static int __init visor_init (void)
 {
 	int i, retval;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

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
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch

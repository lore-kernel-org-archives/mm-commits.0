From: akpm@linux-foundation.org
Subject: + ftd_sio-clean-ups-and-updates-for-new-termios-work.patch added to -mm tree
Date: Mon, 15 Oct 2007 16:37:48 -0700
Message-ID: <200710152337.l9FNbmHF031160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54524 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755066AbXJOXiE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 19:38:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     ftd_sio: cleanups and updates for new termios work
has been added to the -mm tree.  Its filename is
     ftd_sio-clean-ups-and-updates-for-new-termios-work.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ftd_sio: cleanups and updates for new termios work
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Remove can't happen tests
- Rework speed validation in terms of baud rates not CBAUD bits
- Report speed set (or chosen)
- Minor termios correctness

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ftdi_sio.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff -puN drivers/usb/serial/ftdi_sio.c~ftd_sio-clean-ups-and-updates-for-new-termios-work drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~ftd_sio-clean-ups-and-updates-for-new-termios-work
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -294,7 +294,7 @@ struct ftdi_private {
 
 	__u16 interface;	/* FT2232C port interface (0 for FT232/245) */
 
-	int force_baud;		/* if non-zero, force the baud rate to this value */
+	speed_t force_baud;	/* if non-zero, force the baud rate to this value */
 	int force_rtscts;	/* if non-zero, force RTS-CTS to always be enabled */
 
 	spinlock_t tx_lock;	/* spinlock for transmit state */
@@ -878,6 +878,7 @@ static __u32 get_ftdi_divisor(struct usb
 		if (div_value == 0) {
 			dbg("%s - Baudrate (%d) requested is not supported", __FUNCTION__,  baud);
 			div_value = ftdi_sio_b9600;
+	                baud = 9600;
 			div_okay = 0;
 		}
 		break;
@@ -886,6 +887,7 @@ static __u32 get_ftdi_divisor(struct usb
 			div_value = ftdi_232am_baud_to_divisor(baud);
 		} else {
 	                dbg("%s - Baud rate too high!", __FUNCTION__);
+	                baud = 9600;
 			div_value = ftdi_232am_baud_to_divisor(9600);
 			div_okay = 0;
 		}
@@ -899,6 +901,7 @@ static __u32 get_ftdi_divisor(struct usb
 	                dbg("%s - Baud rate too high!", __FUNCTION__);
 			div_value = ftdi_232bm_baud_to_divisor(9600);
 			div_okay = 0;
+			baud = 9600;
 		}
 		break;
 	} /* priv->chip_type */
@@ -909,6 +912,7 @@ static __u32 get_ftdi_divisor(struct usb
 			ftdi_chip_name[priv->chip_type]);
 	}
 
+	tty_encode_baud_rate(port->tty, baud, baud);
 	return(div_value);
 }
 
@@ -1263,7 +1267,7 @@ static void ftdi_USB_UIRT_setup (struct 
 
 	priv->flags |= ASYNC_SPD_CUST;
 	priv->custom_divisor = 77;
-	priv->force_baud = B38400;
+	priv->force_baud = 38400;
 } /* ftdi_USB_UIRT_setup */
 
 /* Setup for the HE-TIRA1 device, which requires hardwired
@@ -1274,7 +1278,7 @@ static void ftdi_HE_TIRA1_setup (struct 
 
 	priv->flags |= ASYNC_SPD_CUST;
 	priv->custom_divisor = 240;
-	priv->force_baud = B38400;
+	priv->force_baud = 38400;
 	priv->force_rtscts = 1;
 } /* ftdi_HE_TIRA1_setup */
 
@@ -1363,7 +1367,7 @@ static int  ftdi_open (struct usb_serial
 
 	/* ftdi_set_termios  will send usb control messages */
 	if (port->tty)
-		ftdi_set_termios(port, NULL);
+		ftdi_set_termios(port, port->tty->termios);
 
 	/* FIXME: Flow control might be enabled, so it should be checked -
 	   we have no control of defaults! */
@@ -1933,32 +1937,32 @@ static void ftdi_break_ctl( struct usb_s
 static void ftdi_set_termios (struct usb_serial_port *port, struct ktermios *old_termios)
 { /* ftdi_termios */
 	struct usb_device *dev = port->serial->dev;
-	unsigned int cflag = port->tty->termios->c_cflag;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
+	struct ktermios *termios = port->tty->termios;
+	unsigned int cflag = termios->c_cflag;
 	__u16 urb_value; /* will hold the new flags */
 	char buf[1]; /* Perhaps I should dynamically alloc this? */
 
 	// Added for xon/xoff support
-	unsigned int iflag = port->tty->termios->c_iflag;
+	unsigned int iflag = termios->c_iflag;
 	unsigned char vstop;
 	unsigned char vstart;
 
 	dbg("%s", __FUNCTION__);
 
 	/* Force baud rate if this device requires it, unless it is set to B0. */
-	if (priv->force_baud && ((port->tty->termios->c_cflag & CBAUD) != B0)) {
+	if (priv->force_baud && ((termios->c_cflag & CBAUD) != B0)) {
 		dbg("%s: forcing baud rate for this device", __FUNCTION__);
-		port->tty->termios->c_cflag &= ~CBAUD;
-		port->tty->termios->c_cflag |= priv->force_baud;
+		tty_encode_baud_rate(port->tty, priv->force_baud, priv->force_baud);
 	}
 
 	/* Force RTS-CTS if this device requires it. */
 	if (priv->force_rtscts) {
 		dbg("%s: forcing rtscts for this device", __FUNCTION__);
-		port->tty->termios->c_cflag |= CRTSCTS;
+		termios->c_cflag |= CRTSCTS;
 	}
 
-	cflag = port->tty->termios->c_cflag;
+	cflag = termios->c_cflag;
 
 	/* FIXME -For this cut I don't care if the line is really changing or
 	   not  - so just do the change regardless  - should be able to
@@ -1969,6 +1973,8 @@ static void ftdi_set_termios (struct usb
 
 	/* Set number of data bits, parity, stop bits */
 
+	termios->c_cflag &= ~CMSPAR;
+
 	urb_value = 0;
 	urb_value |= (cflag & CSTOPB ? FTDI_SIO_SET_DATA_STOP_BITS_2 :
 		      FTDI_SIO_SET_DATA_STOP_BITS_1);
@@ -2048,8 +2054,8 @@ static void ftdi_set_termios (struct usb
 			// Set the vstart and vstop -- could have been done up above where
 			// a lot of other dereferencing is done but that would be very
 			// inefficient as vstart and vstop are not always needed
-			vstart=port->tty->termios->c_cc[VSTART];
-			vstop=port->tty->termios->c_cc[VSTOP];
+			vstart = termios->c_cc[VSTART];
+			vstop = termios->c_cc[VSTOP];
 			urb_value=(vstop << 8) | (vstart);
 
 			if (usb_control_msg(dev,
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
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
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
whiteheat-clean-up-cant-happen-checks-and-encode-baud.patch
cp2101-convert-to-new-termios.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work.patch
io_edgeport-cleanups-and-tty-speed-reporting.patch
tty-kill-tty_flipbuf_size.patch

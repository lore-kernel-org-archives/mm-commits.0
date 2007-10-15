From: akpm@linux-foundation.org
Subject: + cp2101-convert-to-new-termios.patch added to -mm tree
Date: Mon, 15 Oct 2007 16:37:38 -0700
Message-ID: <200710152337.l9FNbcqp031153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305AbXJOXhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 19:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     cp2101: convert to new termios
has been added to the -mm tree.  Its filename is
     cp2101-convert-to-new-termios.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cp2101: convert to new termios
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Convert to new baud rate functions
- Add baud rate reporting

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/cp2101.c |   48 +++++++---------------------------
 1 file changed, 11 insertions(+), 37 deletions(-)

diff -puN drivers/usb/serial/cp2101.c~cp2101-convert-to-new-termios drivers/usb/serial/cp2101.c
--- a/drivers/usb/serial/cp2101.c~cp2101-convert-to-new-termios
+++ a/drivers/usb/serial/cp2101.c
@@ -361,7 +361,6 @@ static void cp2101_get_termios (struct u
 		dbg("%s - no tty structures", __FUNCTION__);
 		return;
 	}
-	cflag = port->tty->termios->c_cflag;
 
 	cp2101_get_config(port, CP2101_BAUDRATE, &baud, 2);
 	/* Convert to baudrate */
@@ -369,40 +368,9 @@ static void cp2101_get_termios (struct u
 		baud = BAUD_RATE_GEN_FREQ / baud;
 
 	dbg("%s - baud rate = %d", __FUNCTION__, baud);
-	cflag &= ~CBAUD;
-	switch (baud) {
-		/*
-		 * The baud rates which are commented out below
-		 * appear to be supported by the device
-		 * but are non-standard
-		 */
-		case 600:	cflag |= B600;		break;
-		case 1200:	cflag |= B1200;		break;
-		case 1800:	cflag |= B1800;		break;
-		case 2400:	cflag |= B2400;		break;
-		case 4800:	cflag |= B4800;		break;
-		/*case 7200:	cflag |= B7200;		break;*/
-		case 9600:	cflag |= B9600;		break;
-		/*case 14400:	cflag |= B14400;	break;*/
-		case 19200:	cflag |= B19200;	break;
-		/*case 28800:	cflag |= B28800;	break;*/
-		case 38400:	cflag |= B38400;	break;
-		/*case 55854:	cflag |= B55054;	break;*/
-		case 57600:	cflag |= B57600;	break;
-		case 115200:	cflag |= B115200;	break;
-		/*case 127117:	cflag |= B127117;	break;*/
-		case 230400:	cflag |= B230400;	break;
-		case 460800:	cflag |= B460800;	break;
-		case 921600:	cflag |= B921600;	break;
-		/*case 3686400:	cflag |= B3686400;	break;*/
-		default:
-			dbg("%s - Baud rate is not supported, "
-					"using 9600 baud", __FUNCTION__);
-			cflag |= B9600;
-			cp2101_set_config_single(port, CP2101_BAUDRATE,
-					(BAUD_RATE_GEN_FREQ/9600));
-			break;
-	}
+
+	tty_encode_baud_rate(port->tty, baud, baud);
+	cflag = port->tty->termios->c_cflag;
 
 	cp2101_get_config(port, CP2101_BITS, &bits, 2);
 	cflag &= ~CSIZE;
@@ -516,7 +484,7 @@ static void cp2101_get_termios (struct u
 static void cp2101_set_termios (struct usb_serial_port *port,
 		struct ktermios *old_termios)
 {
-	unsigned int cflag, old_cflag=0;
+	unsigned int cflag, old_cflag;
 	int baud=0, bits;
 	unsigned int modem_ctl[4];
 
@@ -526,6 +494,8 @@ static void cp2101_set_termios (struct u
 		dbg("%s - no tty structures", __FUNCTION__);
 		return;
 	}
+	port->tty->termios->c_cflag &= ~CMSPAR;
+
 	cflag = port->tty->termios->c_cflag;
 	old_cflag = old_termios->c_cflag;
 	baud = tty_get_baud_rate(port->tty);
@@ -563,11 +533,15 @@ static void cp2101_set_termios (struct u
 			dbg("%s - Setting baud rate to %d baud", __FUNCTION__,
 					baud);
 			if (cp2101_set_config_single(port, CP2101_BAUDRATE,
-						(BAUD_RATE_GEN_FREQ / baud)))
+						(BAUD_RATE_GEN_FREQ / baud))) {
 				dev_err(&port->dev, "Baud rate requested not "
 						"supported by device\n");
+				baud = tty_termios_baud_rate(old_termios);
+			}
 		}
 	}
+	/* Report back the resulting baud rate */
+	tty_encode_baud_rate(port->tty, baud, baud);
 
 	/* If the number of data bits is to be updated */
 	if ((cflag & CSIZE) != (old_cflag & CSIZE)) {
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

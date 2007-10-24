From: akpm@linux-foundation.org
Subject: - empeg-clean-up-and-handle-speeds.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:47 -0700
Message-ID: <200710242141.l9OLflJl013986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52339 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755446AbXJXVqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:46:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     empeg: clean up and handle speeds
has been removed from the -mm tree.  Its filename was
     empeg-clean-up-and-handle-speeds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
serial-keep-the-dtr-setting-for-serial-console.patch
initio-fix-conflict-when-loading-driver.patch
geode-lists-are-subscriber-only.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch

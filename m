From: akpm@linux-foundation.org
Subject: - ark3116-update-termios-handling.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:39 -0700
Message-ID: <200710242141.l9OLfdFo013972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37217 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760557AbXJXVl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:41:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     ark3116: update termios handling
has been removed from the -mm tree.  Its filename was
     ark3116-update-termios-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ark3116: update termios handling
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Set the i/ospeed in the initial termios properly

- Use the tty_encode_baud_rate functions to report resulting rates properly

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/usb/serial/ark3116.c~ark3116-update-termios-handling drivers/usb/serial/ark3116.c
--- a/drivers/usb/serial/ark3116.c~ark3116-update-termios-handling
+++ a/drivers/usb/serial/ark3116.c
@@ -161,7 +161,8 @@ static void ark3116_set_termios(struct u
 {
 	struct usb_serial *serial = port->serial;
 	struct ark3116_private *priv = usb_get_serial_port_data(port);
-	unsigned int cflag = port->tty->termios->c_cflag;
+	struct ktermios *termios = port->tty->termios;
+	unsigned int cflag = termios->c_cflag;
 	unsigned long flags;
 	int baud;
 	int ark3116_baud;
@@ -177,11 +178,14 @@ static void ark3116_set_termios(struct u
 		*(port->tty->termios) = tty_std_termios;
 		port->tty->termios->c_cflag = B9600 | CS8
 					      | CREAD | HUPCL | CLOCAL;
+		termios->c_ispeed = 9600;
+		termios->c_ospeed = 9600;
 		priv->termios_initialized = 1;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	cflag = port->tty->termios->c_cflag;
+	cflag = termios->c_cflag;
+	termios->c_cflag &= ~(CMSPAR|CRTSCTS);
 
 	buf = kmalloc(1, GFP_KERNEL);
 	if (!buf) {
@@ -254,9 +258,13 @@ static void ark3116_set_termios(struct u
 		case 115200:
 		case 230400:
 		case 460800:
+			/* Report the resulting rate back to the caller */
+			tty_encode_baud_rate(port->tty, baud, baud);
 			break;
 		/* set 9600 as default (if given baudrate is invalid for example) */
 		default:
+			tty_encode_baud_rate(port->tty, 9600, 9600);
+		case 0:
 			baud = 9600;
 	}
 
@@ -302,6 +310,7 @@ static void ark3116_set_termios(struct u
 	/* TEST ARK3116_SND(154, 0xFE, 0x40, 0xFFFF, 0x0006); */
 
 	kfree(buf);
+
 	return;
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

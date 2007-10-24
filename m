From: akpm@linux-foundation.org
Subject: - ir_usb-termios-handling.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:49 -0700
Message-ID: <200710242141.l9OLfnWK013989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48424 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759577AbXJXVpv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:45:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     ir_usb: termios handling
has been removed from the -mm tree.  Its filename was
     ir_usb-termios-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ir_usb: termios handling
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Clean up paranoia checks
- Propogate back a correct fixed termios

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/usb/serial/ir-usb.c~ir_usb-termios-handling drivers/usb/serial/ir-usb.c
--- a/drivers/usb/serial/ir-usb.c~ir_usb-termios-handling
+++ a/drivers/usb/serial/ir-usb.c
@@ -504,11 +504,6 @@ static void ir_set_termios (struct usb_s
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
-	if ((!port->tty) || (!port->tty->termios)) {
-		dbg("%s - no tty structures", __FUNCTION__);
-		return;
-	}
-
 	baud = tty_get_baud_rate(port->tty);
 
 	/*
@@ -531,8 +526,6 @@ static void ir_set_termios (struct usb_s
 		default:
 			ir_baud = SPEED_9600;
 			baud = 9600;
-			/* And once the new tty stuff is all done we need to
-			   call back to correct the baud bits */
 	}
 
 	if (xbof == -1)
@@ -562,6 +555,10 @@ static void ir_set_termios (struct usb_s
 	result = usb_submit_urb (port->write_urb, GFP_KERNEL);
 	if (result)
 		dev_err(&port->dev, "%s - failed submitting write urb, error %d\n", __FUNCTION__, result);
+
+	/* Only speed changes are supported */
+	tty_termios_copy_hw(port->tty->termios, old_termios);
+	tty_encode_baud_rate(port->tty, baud, baud);
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

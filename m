From: akpm@linux-foundation.org
Subject: - keyspan-termios-tidy.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:51 -0700
Message-ID: <200710242141.l9OLfpNd013992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60540 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759532AbXJXVpv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:45:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     keyspan termios tidy
has been removed from the -mm tree.  Its filename was
     keyspan-termios-tidy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

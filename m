From: akpm@linux-foundation.org
Subject: - keyspan-init-termios-properly.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:16 -0800
Message-ID: <200711152111.lAFLBGFs015748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58274 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932357AbXKOVRX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, greg@kroah.com, lucy@keyspan.com, mm-commits@vger.kernel.org


The patch titled
     keyspan: init termios properly
has been removed from the -mm tree.  Its filename was
     keyspan-init-termios-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: keyspan: init termios properly
From: Borislav Petkov <bbpetkov@yahoo.de>

Remove redundant code leading to NULL ptr deref and let terminal config
settings take place in the proper initialization path in
usb_console_setup().

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Cc: <lucy@keyspan.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/keyspan.c |   38 +++++----------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff -puN drivers/usb/serial/keyspan.c~keyspan-init-termios-properly drivers/usb/serial/keyspan.c
--- a/drivers/usb/serial/keyspan.c~keyspan-init-termios-properly
+++ a/drivers/usb/serial/keyspan.c
@@ -1215,20 +1215,18 @@ static int keyspan_chars_in_buffer (stru
 
 static int keyspan_open (struct usb_serial_port *port, struct file *filp)
 {
-	struct keyspan_port_private 	*p_priv;
-	struct keyspan_serial_private 	*s_priv;
-	struct usb_serial 		*serial = port->serial;
+	struct keyspan_port_private	*p_priv;
+	struct keyspan_serial_private	*s_priv;
+	struct usb_serial		*serial = port->serial;
 	const struct keyspan_device_details	*d_details;
 	int				i, err;
-	int				baud_rate, device_port;
 	struct urb			*urb;
-	unsigned int			cflag;
 
 	s_priv = usb_get_serial_data(serial);
 	p_priv = usb_get_serial_port_data(port);
 	d_details = p_priv->device_details;
-	
-	dbg("%s - port%d.", __FUNCTION__, port->number); 
+
+	dbg("%s - port%d.", __FUNCTION__, port->number);
 
 	/* Set some sane defaults */
 	p_priv->rts_state = 1;
@@ -1249,7 +1247,7 @@ static int keyspan_open (struct usb_seri
 		urb->dev = serial->dev;
 
 		/* make sure endpoint data toggle is synchronized with the device */
-		
+
 		usb_clear_halt(urb->dev, urb->pipe);
 
 		if ((err = usb_submit_urb(urb, GFP_KERNEL)) != 0) {
@@ -1265,30 +1263,6 @@ static int keyspan_open (struct usb_seri
 		/* usb_settoggle(urb->dev, usb_pipeendpoint(urb->pipe), usb_pipeout(urb->pipe), 0); */
 	}
 
-	/* get the terminal config for the setup message now so we don't 
-	 * need to send 2 of them */
-
-	cflag = port->tty->termios->c_cflag;
-	device_port = port->number - port->serial->minor;
-
-	/* Baud rate calculation takes baud rate as an integer
-	   so other rates can be generated if desired. */
-	baud_rate = tty_get_baud_rate(port->tty);
-	/* If no match or invalid, leave as default */		
-	if (baud_rate >= 0
-	    && d_details->calculate_baud_rate(baud_rate, d_details->baudclk,
-				NULL, NULL, NULL, device_port) == KEYSPAN_BAUD_RATE_OK) {
-		p_priv->baud = baud_rate;
-	}
-
-	/* set CTS/RTS handshake etc. */
-	p_priv->cflag = cflag;
-	p_priv->flow_control = (cflag & CRTSCTS)? flow_cts: flow_none;
-
-	keyspan_send_setup(port, 1);
-	//mdelay(100);
-	//keyspan_set_termios(port, NULL);
-
 	return (0);
 }
 
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch
revert-keyspan-init-termios-properly.patch
usbserial-fix-inconsistent-lock-state.patch

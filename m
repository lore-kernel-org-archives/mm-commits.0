From: akpm@linux-foundation.org
Subject: - usb-serial-more-fixes-and-groundwork-for-tty-changes.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:40:22 -0700
Message-ID: <200804130240.m3D2eMFZ032501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561AbYDMClI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:41:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb serial: more fixes and groundwork for tty changes
has been removed from the -mm tree.  Its filename was
     usb-serial-more-fixes-and-groundwork-for-tty-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb serial: more fixes and groundwork for tty changes
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- If a termios change fails due to lack of memory we should copy the old
settings back over as the device has not changed
- Note various locking problems
- kl5kusb105 had various remaining tty flag handling problems
- Make safe_serial use tty_insert_flip_string not open coded loops
- set termios speed properly in usb_serial

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ark3116.c     |    1 
 drivers/usb/serial/cyberjack.c   |   31 +++++++++++----------
 drivers/usb/serial/generic.c     |    5 ++-
 drivers/usb/serial/keyspan.c     |   19 +++++++------
 drivers/usb/serial/keyspan_pda.c |    9 ++++--
 drivers/usb/serial/kl5kusb105.c  |   41 +++++++++++++++++------------
 drivers/usb/serial/mos7720.c     |    1 
 drivers/usb/serial/navman.c      |   10 +++----
 drivers/usb/serial/omninet.c     |    3 +-
 drivers/usb/serial/option.c      |    3 ++
 drivers/usb/serial/pl2303.c      |    2 +
 drivers/usb/serial/safe_serial.c |   27 +++++++------------
 drivers/usb/serial/sierra.c      |    2 +
 drivers/usb/serial/usb-serial.c  |    2 +
 drivers/usb/serial/visor.c       |    2 +
 drivers/usb/serial/whiteheat.c   |    2 -
 16 files changed, 93 insertions(+), 67 deletions(-)

diff -puN drivers/usb/serial/ark3116.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/ark3116.c
--- a/drivers/usb/serial/ark3116.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/ark3116.c
@@ -192,6 +192,7 @@ static void ark3116_set_termios(struct u
 	buf = kmalloc(1, GFP_KERNEL);
 	if (!buf) {
 		dbg("error kmalloc");
+		*port->tty->termios = *old_termios;
 		return;
 	}
 
diff -puN drivers/usb/serial/cyberjack.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/cyberjack.c
--- a/drivers/usb/serial/cyberjack.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/cyberjack.c
@@ -154,7 +154,7 @@ static void cyberjack_shutdown (struct u
 	
 	dbg("%s", __func__);
 
-	for (i=0; i < serial->num_ports; ++i) {
+	for (i = 0; i < serial->num_ports; ++i) {
 		usb_kill_urb(serial->port[i]->interrupt_in_urb);
 		/* My special items, the standard routines free my urbs */
 		kfree(usb_get_serial_port_data(serial->port[i]));
@@ -212,7 +212,7 @@ static int cyberjack_write (struct usb_s
 
 	if (count == 0) {
 		dbg("%s - write request of 0 bytes", __func__);
-		return (0);
+		return 0;
 	}
 
 	spin_lock_bh(&port->lock);
@@ -226,12 +226,12 @@ static int cyberjack_write (struct usb_s
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if( (count+priv->wrfilled)>sizeof(priv->wrbuf) ) {
+	if( (count+priv->wrfilled) > sizeof(priv->wrbuf) ) {
 		/* To much data for buffer. Reset buffer. */
-		priv->wrfilled=0;
-		spin_unlock_irqrestore(&priv->lock, flags);
+		priv->wrfilled = 0;
 		port->write_urb_busy = 0;
-		return (0);
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return 0;
 	}
 
 	/* Copy data */
@@ -272,8 +272,8 @@ static int cyberjack_write (struct usb_s
 		if (result) {
 			err("%s - failed submitting write urb, error %d", __func__, result);
 			/* Throw away data. No better idea what to do with it. */
-			priv->wrfilled=0;
-			priv->wrsent=0;
+			priv->wrfilled = 0;
+			priv->wrsent = 0;
 			spin_unlock_irqrestore(&priv->lock, flags);
 			port->write_urb_busy = 0;
 			return 0;
@@ -285,8 +285,8 @@ static int cyberjack_write (struct usb_s
 		if( priv->wrsent>=priv->wrfilled ) {
 			dbg("%s - buffer cleaned", __func__);
 			memset( priv->wrbuf, 0, sizeof(priv->wrbuf) );
-			priv->wrfilled=0;
-			priv->wrsent=0;
+			priv->wrfilled = 0;
+			priv->wrsent = 0;
 		}
 	}
 
@@ -297,6 +297,7 @@ static int cyberjack_write (struct usb_s
 
 static int cyberjack_write_room( struct usb_serial_port *port )
 {
+	/* FIXME: .... */
 	return CYBERJACK_LOCAL_BUF_SIZE;
 }
 
@@ -317,7 +318,7 @@ static void cyberjack_read_int_callback(
 	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length, data);
 
 	/* React only to interrupts signaling a bulk_in transfer */
-	if( (urb->actual_length==4) && (data[0]==0x01) ) {
+	if( (urb->actual_length == 4) && (data[0] == 0x01) ) {
 		short old_rdtodo;
 
 		/* This is a announcement of coming bulk_ins. */
@@ -453,8 +454,8 @@ static void cyberjack_write_bulk_callbac
 		if (result) {
 			err("%s - failed submitting write urb, error %d", __func__, result);
 			/* Throw away data. No better idea what to do with it. */
-			priv->wrfilled=0;
-			priv->wrsent=0;
+			priv->wrfilled = 0;
+			priv->wrsent = 0;
 			goto exit;
 		}
 
@@ -466,8 +467,8 @@ static void cyberjack_write_bulk_callbac
 		if( (priv->wrsent>=priv->wrfilled) || (priv->wrsent>=blksize) ) {
 			dbg("%s - buffer cleaned", __func__);
 			memset( priv->wrbuf, 0, sizeof(priv->wrbuf) );
-			priv->wrfilled=0;
-			priv->wrsent=0;
+			priv->wrfilled = 0;
+			priv->wrsent = 0;
 		}
 	}
 
diff -puN drivers/usb/serial/generic.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/generic.c
--- a/drivers/usb/serial/generic.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/generic.c
@@ -265,13 +265,14 @@ int usb_serial_generic_write_room (struc
 
 	dbg("%s - port %d", __func__, port->number);
 
+	/* FIXME: Locking */
 	if (serial->num_bulk_out) {
 		if (!(port->write_urb_busy))
 			room = port->bulk_out_size;
 	}
 
 	dbg("%s - returns %d", __func__, room);
-	return (room);
+	return room;
 }
 
 int usb_serial_generic_chars_in_buffer (struct usb_serial_port *port)
@@ -281,6 +282,7 @@ int usb_serial_generic_chars_in_buffer (
 
 	dbg("%s - port %d", __func__, port->number);
 
+	/* FIXME: Locking */
 	if (serial->num_bulk_out) {
 		if (port->write_urb_busy)
 			chars = port->write_urb->transfer_buffer_length;
@@ -371,7 +373,6 @@ void usb_serial_generic_write_bulk_callb
 		    __func__, status);
 		return;
 	}
-
 	usb_serial_port_softint(port);
 }
 EXPORT_SYMBOL_GPL(usb_serial_generic_write_bulk_callback);
diff -puN drivers/usb/serial/keyspan.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/keyspan.c
--- a/drivers/usb/serial/keyspan.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/keyspan.c
@@ -1187,6 +1187,7 @@ static int keyspan_write_room (struct us
 	p_priv = usb_get_serial_port_data(port);
 	d_details = p_priv->device_details;
 
+	/* FIXME: locking */
 	if (d_details->msg_format == msg_usa90)
    		data_len = 64;
 	else
@@ -1203,13 +1204,13 @@ static int keyspan_write_room (struct us
 			if (this_urb->status != -EINPROGRESS)
 				return (data_len);
 	}
-	return (0);
+	return 0;
 }
 
 
 static int keyspan_chars_in_buffer (struct usb_serial_port *port)
 {
-	return (0);
+	return 0;
 }
 
 
@@ -1289,7 +1290,7 @@ static int keyspan_open (struct usb_seri
 	//mdelay(100);
 	//keyspan_set_termios(port, NULL);
 
-	return (0);
+	return 0;
 }
 
 static inline void stop_urb(struct urb *urb)
@@ -2006,7 +2007,7 @@ static int keyspan_usa26_send_setup(stru
 	}
 #endif
 
-	return (0);
+	return 0;
 }
 
 static int keyspan_usa28_send_setup(struct usb_serial *serial,
@@ -2131,7 +2132,7 @@ static int keyspan_usa28_send_setup(stru
 	}
 #endif
 
-	return (0);
+	return 0;
 }
 
 static int keyspan_usa49_send_setup(struct usb_serial *serial,
@@ -2317,7 +2318,7 @@ static int keyspan_usa49_send_setup(stru
 	}
 #endif
 
-	return (0);
+	return 0;
 }
 
 static int keyspan_usa90_send_setup(struct usb_serial *serial,
@@ -2455,7 +2456,7 @@ static int keyspan_usa90_send_setup(stru
 	if ((err = usb_submit_urb(this_urb, GFP_ATOMIC)) != 0) {
 		dbg("%s - usb_submit_urb(setup) failed (%d)", __func__, err);
 	}
-	return (0);
+	return 0;
 }
 
 static int keyspan_usa67_send_setup(struct usb_serial *serial,
@@ -2603,7 +2604,7 @@ static int keyspan_usa67_send_setup(stru
 	if (err != 0)
 		dbg("%s - usb_submit_urb(setup) failed (%d)", __func__,
 				err);
-	return (0);
+	return 0;
 }
 
 static void keyspan_send_setup(struct usb_serial_port *port, int reset_port)
@@ -2696,7 +2697,7 @@ static int keyspan_startup (struct usb_s
 				err);
 	}
 			
-	return (0);
+	return 0;
 }
 
 static void keyspan_shutdown (struct usb_serial *serial)
diff -puN drivers/usb/serial/keyspan_pda.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/keyspan_pda.c
--- a/drivers/usb/serial/keyspan_pda.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/keyspan_pda.c
@@ -636,14 +636,19 @@ static int keyspan_pda_write_room (struc
 static int keyspan_pda_chars_in_buffer (struct usb_serial_port *port)
 {
 	struct keyspan_pda_private *priv;
+	unsigned long flags;
+	int ret = 0;
 
 	priv = usb_get_serial_port_data(port);
 
 	/* when throttled, return at least WAKEUP_CHARS to tell select() (via
 	   n_tty.c:normal_poll() ) that we're not writeable. */
+
+	spin_lock_irqsave(&port->lock, flags);
 	if (port->write_urb_busy || priv->tx_throttled)
-		return 256;
-	return 0;
+		ret = 256;
+	spin_unlock_irqrestore(&port->lock, flags);
+	return ret;
 }
 
 
diff -puN drivers/usb/serial/kl5kusb105.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/kl5kusb105.c
--- a/drivers/usb/serial/kl5kusb105.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/kl5kusb105.c
@@ -705,12 +705,14 @@ static void klsi_105_set_termios (struct
 				  struct ktermios *old_termios)
 {
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
-	unsigned int iflag = port->tty->termios->c_iflag;
+	struct tty_struct *tty = port->tty;
+	unsigned int iflag = tty->termios->c_iflag;
 	unsigned int old_iflag = old_termios->c_iflag;
-	unsigned int cflag = port->tty->termios->c_cflag;
+	unsigned int cflag = tty->termios->c_cflag;
 	unsigned int old_cflag = old_termios->c_cflag;
 	struct klsi_105_port_settings cfg;
 	unsigned long flags;
+	speed_t baud;
 	
 	/* lock while we are modifying the settings */
 	spin_lock_irqsave (&priv->lock, flags);
@@ -718,6 +720,8 @@ static void klsi_105_set_termios (struct
 	/*
 	 * Update baud rate
 	 */
+	baud = tty_get_baud_rate(tty);
+
 	if( (cflag & CBAUD) != (old_cflag & CBAUD) ) {
 	        /* reassert DTR and (maybe) RTS on transition from B0 */
 		if( (old_cflag & CBAUD) == B0 ) {
@@ -731,8 +735,8 @@ static void klsi_105_set_termios (struct
 			mct_u232_set_modem_ctrl(serial, priv->control_state);
 #endif
 		}
-		
-		switch(tty_get_baud_rate(port->tty)) {
+	}
+	switch(baud) {
 		case 0: /* handled below */
 			break;
 		case 1200:
@@ -760,25 +764,26 @@ static void klsi_105_set_termios (struct
 			priv->cfg.baudrate = kl5kusb105a_sio_b115200;
 			break;
 		default:
-			err("KLSI USB->Serial converter:"
+			dbg("KLSI USB->Serial converter:"
 			    " unsupported baudrate request, using default"
 			    " of 9600");
 			priv->cfg.baudrate = kl5kusb105a_sio_b9600;
+			baud = 9600;
 			break;
-		}
-		if ((cflag & CBAUD) == B0 ) {
-			dbg("%s: baud is B0", __func__);
-			/* Drop RTS and DTR */
-			/* maybe this should be simulated by sending read
-			 * disable and read enable messages?
-			 */
-			;
+	}
+	if ((cflag & CBAUD) == B0 ) {
+		dbg("%s: baud is B0", __func__);
+		/* Drop RTS and DTR */
+		/* maybe this should be simulated by sending read
+		 * disable and read enable messages?
+		 */
+		;
 #if 0
-			priv->control_state &= ~(TIOCM_DTR | TIOCM_RTS);
-        		mct_u232_set_modem_ctrl(serial, priv->control_state);
+		priv->control_state &= ~(TIOCM_DTR | TIOCM_RTS);
+       		mct_u232_set_modem_ctrl(serial, priv->control_state);
 #endif
-		}
 	}
+	tty_encode_baud_rate(tty, baud, baud);
 
 	if ((cflag & CSIZE) != (old_cflag & CSIZE)) {
 		/* set the number of data bits */
@@ -810,6 +815,8 @@ static void klsi_105_set_termios (struct
 	if ((cflag & (PARENB|PARODD)) != (old_cflag & (PARENB|PARODD))
 	    || (cflag & CSTOPB) != (old_cflag & CSTOPB) ) {
 		
+		/* Not currently supported */
+		tty->termios->c_cflag &= ~(PARENB|PARODD|CSTOPB);
 #if 0
 		priv->last_lcr = 0;
 
@@ -837,6 +844,8 @@ static void klsi_105_set_termios (struct
 	    || (iflag & IXON) != (old_iflag & IXON)
 	    ||  (cflag & CRTSCTS) != (old_cflag & CRTSCTS) ) {
 		
+		/* Not currently supported */
+		tty->termios->c_cflag &= ~CRTSCTS;
 		/* Drop DTR/RTS if no flow control otherwise assert */
 #if 0
 		if ((iflag & IXOFF) || (iflag & IXON) || (cflag & CRTSCTS) )
diff -puN drivers/usb/serial/mos7720.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/mos7720.c
--- a/drivers/usb/serial/mos7720.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/mos7720.c
@@ -635,6 +635,7 @@ static int mos7720_write_room(struct usb
 		return -ENODEV;
 	}
 
+	/* FIXME: Locking */
 	for (i = 0; i < NUM_URBS; ++i) {
 		if (mos7720_port->write_urb_pool[i] && mos7720_port->write_urb_pool[i]->status != -EINPROGRESS)
 			room += URB_TRANSFER_BUFFER_SIZE;
diff -puN drivers/usb/serial/navman.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/navman.c
--- a/drivers/usb/serial/navman.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/navman.c
@@ -6,6 +6,10 @@
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
  *	version 2 as published by the Free Software Foundation.
+ *
+ * TODO:
+ *	Add termios method that uses copy_hw but also kills all echo
+ *	flags as the navman is rx only so cannot echo.
  */
 
 #include <linux/kernel.h>
@@ -106,12 +110,8 @@ static int navman_write(struct usb_seria
 
 	/*
 	 * This device can't write any data, only read from the device
-	 * so we just silently eat all data sent to us and say it was
-	 * successfully sent.
-	 * Evil, I know, but do you have a better idea?
 	 */
-
-	return count;
+	return -EOPNOTSUPP;
 }
 
 static struct usb_serial_driver navman_device = {
diff -puN drivers/usb/serial/omninet.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/omninet.c
--- a/drivers/usb/serial/omninet.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/omninet.c
@@ -298,8 +298,9 @@ static int omninet_write_room (struct us
 	struct usb_serial 	*serial = port->serial;
 	struct usb_serial_port 	*wport 	= serial->port[1];
 
-	int room = 0; // Default: no room
+	int room = 0; /* Default: no room */
 
+	/* FIXME: no consistent locking for write_urb_busy */
 	if (wport->write_urb_busy)
 		room = wport->bulk_out_size - OMNINET_HEADERLEN;
 
diff -puN drivers/usb/serial/option.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/option.c
@@ -607,6 +607,7 @@ static int option_write_room(struct usb_
 
 	portdata = usb_get_serial_port_data(port);
 
+
 	for (i=0; i < N_OUT_URB; i++) {
 		this_urb = portdata->out_urbs[i];
 		if (this_urb && !test_bit(i, &portdata->out_busy))
@@ -628,6 +629,8 @@ static int option_chars_in_buffer(struct
 
 	for (i=0; i < N_OUT_URB; i++) {
 		this_urb = portdata->out_urbs[i];
+		/* FIXME: This locking is insufficient as this_urb may
+		   go unused during the test */
 		if (this_urb && test_bit(i, &portdata->out_busy))
 			data_len += this_urb->transfer_buffer_length;
 	}
diff -puN drivers/usb/serial/pl2303.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/pl2303.c
--- a/drivers/usb/serial/pl2303.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/pl2303.c
@@ -546,6 +546,8 @@ static void pl2303_set_termios(struct us
 	buf = kzalloc(7, GFP_KERNEL);
 	if (!buf) {
 		dev_err(&port->dev, "%s - out of memory.\n", __func__);
+		/* Report back no change occurred */
+		*port->tty->termios = *old_termios;
 		return;
 	}
 
diff -puN drivers/usb/serial/safe_serial.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/safe_serial.c
--- a/drivers/usb/serial/safe_serial.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/safe_serial.c
@@ -198,7 +198,6 @@ static void safe_read_bulk_callback (str
 	struct usb_serial_port *port =  urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	unsigned char length = urb->actual_length;
-	int i;
 	int result;
 	int status = urb->status;
 
@@ -227,16 +226,10 @@ static void safe_read_bulk_callback (str
 	if (safe) {
 		__u16 fcs;
 		if (!(fcs = fcs_compute10 (data, length, CRC10_INITFCS))) {
-
 			int actual_length = data[length - 2] >> 2;
-
 			if (actual_length <= (length - 2)) {
-
 				info ("%s - actual: %d", __func__, actual_length);
-
-				for (i = 0; i < actual_length; i++) {
-					tty_insert_flip_char (port->tty, data[i], 0);
-				}
+				tty_insert_flip_string(port->tty, data, actual_length);
 				tty_flip_buffer_push (port->tty);
 			} else {
 				err ("%s - inconsistent lengths %d:%d", __func__,
@@ -246,9 +239,7 @@ static void safe_read_bulk_callback (str
 			err ("%s - bad CRC %x", __func__, fcs);
 		}
 	} else {
-		for (i = 0; i < length; i++) {
-			tty_insert_flip_char (port->tty, data[i], 0);
-		}
+		tty_insert_flip_string(port->tty, data, length);
 		tty_flip_buffer_push (port->tty);
 	}
 
@@ -260,6 +251,7 @@ static void safe_read_bulk_callback (str
 
 	if ((result = usb_submit_urb (urb, GFP_ATOMIC))) {
 		err ("%s - failed resubmitting read urb, error %d", __func__, result);
+		/* FIXME: Need a mechanism to retry later if this happens */
 	}
 }
 
@@ -275,7 +267,7 @@ static int safe_write (struct usb_serial
 
 	if (!port->write_urb) {
 		dbg ("%s - write urb NULL", __func__);
-		return (0);
+		return 0;
 	}
 
 	dbg ("safe_write write_urb: %d transfer_buffer_length",
@@ -283,11 +275,11 @@ static int safe_write (struct usb_serial
 
 	if (!port->write_urb->transfer_buffer_length) {
 		dbg ("%s - write urb transfer_buffer_length zero", __func__);
-		return (0);
+		return 0;
 	}
 	if (count == 0) {
 		dbg ("%s - write request of 0 bytes", __func__);
-		return (0);
+		return 0;
 	}
 	spin_lock_bh(&port->lock);
 	if (port->write_urb_busy) {
@@ -359,18 +351,21 @@ static int safe_write (struct usb_serial
 
 static int safe_write_room (struct usb_serial_port *port)
 {
-	int room = 0;		// Default: no room
+	int room = 0;		/* Default: no room */
+	unsigned long flags;
 
 	dbg ("%s", __func__);
 
+	spin_lock_irqsave(&port->lock, flags);
 	if (port->write_urb_busy)
 		room = port->bulk_out_size - (safe ? 2 : 0);
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	if (room) {
 		dbg ("safe_write_room returns %d", room);
 	}
 
-	return (room);
+	return room;
 }
 
 static int safe_startup (struct usb_serial *serial)
diff -puN drivers/usb/serial/sierra.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/sierra.c
@@ -525,6 +525,8 @@ static int sierra_chars_in_buffer(struct
 	 * have sent out, but hasn't made it through to the
 	 * device as we can't see the backend here, so just
 	 * tell the tty layer that everything is flushed.
+	 *
+	 * FIXME: should walk the outstanding urbs info
 	 */
 	return 0;
 }
diff -puN drivers/usb/serial/usb-serial.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/usb-serial.c
@@ -1193,6 +1193,8 @@ static int __init usb_serial_init(void)
 	usb_serial_tty_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
 	usb_serial_tty_driver->init_termios = tty_std_termios;
 	usb_serial_tty_driver->init_termios.c_cflag = B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	usb_serial_tty_driver->init_termios.c_ispeed = 9600;
+	usb_serial_tty_driver->init_termios.c_ospeed = 9600;
 	tty_set_operations(usb_serial_tty_driver, &serial_ops);
 	result = tty_register_driver(usb_serial_tty_driver);
 	if (result) {
diff -puN drivers/usb/serial/visor.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/visor.c
--- a/drivers/usb/serial/visor.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/visor.c
@@ -478,6 +478,8 @@ static int visor_chars_in_buffer (struct
 	 * have sent out, but hasn't made it through to the
 	 * device, so just tell the tty layer that everything
 	 * is flushed.
+	 *
+	 * FIXME: Should walk outstanding_urbs
 	 */
 	return 0;
 }
diff -puN drivers/usb/serial/whiteheat.c~usb-serial-more-fixes-and-groundwork-for-tty-changes drivers/usb/serial/whiteheat.c
--- a/drivers/usb/serial/whiteheat.c~usb-serial-more-fixes-and-groundwork-for-tty-changes
+++ a/drivers/usb/serial/whiteheat.c
@@ -225,7 +225,7 @@ struct whiteheat_urb_wrap {
 struct whiteheat_private {
 	spinlock_t		lock;
 	__u8			flags;
-	__u8			mcr;
+	__u8			mcr;		/* FIXME: no locking on mcr */
 	struct list_head	rx_urbs_free;
 	struct list_head	rx_urbs_submitted;
 	struct list_head	rx_urb_q;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
git-libata-all.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-simplex-clear-fix.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
parisc-new-termios-definitions.patch
aacraid-fix-unchecked-down_interruptible.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
serial-8250-tighten-test-for-using-backup-timer.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
tty_ioctl-locking-for-tty_wait_until_sent.patch
tty_ioctl-soft-carrier-handling.patch
tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch
sxc-fix-printk-warnings-on-sparc32.patch
istallion-tiocg-ssoftcar-handling-removal.patch
tty-serial-lay-the-foundations-for-the-next-set-of-reworks.patch
edac-new-support-for-intel-3100-chipset.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
edac-fix-module-initialization-on-several-modules-2nd-time.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch


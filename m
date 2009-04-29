From: akpm@linux-foundation.org
Subject: + usb-serial-ftdi_sio-fix-reference-counting-of-ftdi_private.patch added to -mm tree
Date: Wed, 29 Apr 2009 15:24:10 -0700
Message-ID: <200904292224.n3TMOAPA031810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761775AbZD2W1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 18:27:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, daniel@caiaq.de, greg@kroah.com


The patch titled
     usb-serial: ftdi_sio: fix reference counting of ftdi_private
has been added to the -mm tree.  Its filename is
     usb-serial-ftdi_sio-fix-reference-counting-of-ftdi_private.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb-serial: ftdi_sio: fix reference counting of ftdi_private
From: Alan Stern <stern@rowland.harvard.edu>

In search of a changelog and sob.

Reported-by: Daniel Mack <daniel@caiaq.de>
Tested-by: Daniel Mack <daniel@caiaq.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ftdi_sio.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN drivers/usb/serial/ftdi_sio.c~usb-serial-ftdi_sio-fix-reference-counting-of-ftdi_private drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~usb-serial-ftdi_sio-fix-reference-counting-of-ftdi_private
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -56,6 +56,7 @@ static __u16 vendor = FTDI_VID;
 static __u16 product;
 
 struct ftdi_private {
+	struct kref kref;
 	ftdi_chip_type_t chip_type;
 				/* type of device, either SIO or FT8U232AM */
 	int baud_base;		/* baud base clock for divisor setting */
@@ -1423,6 +1424,7 @@ static int ftdi_sio_port_probe(struct us
 		return -ENOMEM;
 	}
 
+	kref_init(&priv->kref);
 	spin_lock_init(&priv->rx_lock);
 	spin_lock_init(&priv->tx_lock);
 	init_waitqueue_head(&priv->delta_msr_wait);
@@ -1539,6 +1541,13 @@ static void ftdi_shutdown(struct usb_ser
 	dbg("%s", __func__);
 }
 
+static void ftdi_sio_priv_release(struct kref *k)
+{
+	struct ftdi_private *priv = container_of(k, struct ftdi_private, kref);
+
+	kfree(priv);
+}
+
 static int ftdi_sio_port_remove(struct usb_serial_port *port)
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
@@ -1553,7 +1562,7 @@ static int ftdi_sio_port_remove(struct u
 
 	if (priv) {
 		usb_set_serial_port_data(port, NULL);
-		kfree(priv);
+		kref_put(&priv->kref, ftdi_sio_priv_release);
 	}
 
 	return 0;
@@ -1618,7 +1627,8 @@ static int ftdi_open(struct tty_struct *
 		dev_err(&port->dev,
 			"%s - failed submitting read urb, error %d\n",
 			__func__, result);
-
+	else
+		kref_get(&priv->kref);
 
 	return result;
 } /* ftdi_open */
@@ -1665,11 +1675,11 @@ static void ftdi_close(struct usb_serial
 
 
 	/* cancel any scheduled reading */
-	cancel_delayed_work(&priv->rx_work);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&priv->rx_work);
 
 	/* shutdown our bulk read */
 	usb_kill_urb(port->read_urb);
+	kref_put(&priv->kref, ftdi_sio_priv_release);
 } /* ftdi_close */
 
 
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

origin.patch
linux-next.patch
usb-serial-ftdi_sio-fix-reference-counting-of-ftdi_private.patch


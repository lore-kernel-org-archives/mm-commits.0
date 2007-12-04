From: akpm@linux-foundation.org
Subject: + edgeport-usb-serial-converter-convert-es_sem-to-mutex.patch added to -mm tree
Date: Tue, 04 Dec 2007 12:16:52 -0800
Message-ID: <200712042016.lB4KGqB7002976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43254 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbXLDUQz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 15:16:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     Edgeport USB Serial Converter: convert es_sem to mutex
has been added to the -mm tree.  Its filename is
     edgeport-usb-serial-converter-convert-es_sem-to-mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Edgeport USB Serial Converter: convert es_sem to mutex
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Edgeport USB Serial Converter: convert semaphore es_sem to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/io_ti.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN drivers/usb/serial/io_ti.c~edgeport-usb-serial-converter-convert-es_sem-to-mutex drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c~edgeport-usb-serial-converter-convert-es_sem-to-mutex
+++ a/drivers/usb/serial/io_ti.c
@@ -34,6 +34,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/serial.h>
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
@@ -133,7 +134,7 @@ struct edgeport_serial {
 	struct product_info product_info;
 	u8 TI_I2C_Type;			// Type of I2C in UMP
 	u8 TiReadI2C;			// Set to TRUE if we have read the I2c in Boot Mode
-	struct semaphore es_sem;
+	struct mutex es_lock;
 	int num_ports_open;
 	struct usb_serial *serial;
 };
@@ -2044,7 +2045,7 @@ static int edge_open (struct usb_serial_
 	dbg ("ShadowMCR 0x%X", edge_port->shadow_mcr);
 
 	edge_serial = edge_port->edge_serial;
-	if (down_interruptible(&edge_serial->es_sem))
+	if (mutex_lock_interruptible(&edge_serial->es_lock))
 		return -ERESTARTSYS;
 	if (edge_serial->num_ports_open == 0) {
 		/* we are the first port to be opened, let's post the interrupt urb */
@@ -2052,7 +2053,7 @@ static int edge_open (struct usb_serial_
 		if (!urb) {
 			dev_err (&port->dev, "%s - no interrupt urb present, exiting\n", __FUNCTION__);
 			status = -EINVAL;
-			goto up_es_sem;
+			goto release_es_lock;
 		}
 		urb->complete = edge_interrupt_callback;
 		urb->context = edge_serial;
@@ -2060,7 +2061,7 @@ static int edge_open (struct usb_serial_
 		status = usb_submit_urb (urb, GFP_KERNEL);
 		if (status) {
 			dev_err (&port->dev, "%s - usb_submit_urb failed with value %d\n", __FUNCTION__, status);
-			goto up_es_sem;
+			goto release_es_lock;
 		}
 	}
 
@@ -2092,13 +2093,13 @@ static int edge_open (struct usb_serial_
 
 	dbg("%s - exited", __FUNCTION__);
 
-	goto up_es_sem;
+	goto release_es_lock;
 
 unlink_int_urb:
 	if (edge_port->edge_serial->num_ports_open == 0)
 		usb_kill_urb(port->serial->port[0]->interrupt_in_urb);
-up_es_sem:
-	up(&edge_serial->es_sem);
+release_es_lock:
+	mutex_unlock(&edge_serial->es_lock);
 	return status;
 }
 
@@ -2137,14 +2138,14 @@ static void edge_close (struct usb_seria
 				     0,
 				     NULL,
 				     0);
-	down(&edge_serial->es_sem);
+	mutex_lock(&edge_serial->es_lock);
 	--edge_port->edge_serial->num_ports_open;
 	if (edge_port->edge_serial->num_ports_open <= 0) {
 		/* last port is now closed, let's shut down our interrupt urb */
 		usb_kill_urb(port->serial->port[0]->interrupt_in_urb);
 		edge_port->edge_serial->num_ports_open = 0;
 	}
-	up(&edge_serial->es_sem);
+	mutex_unlock(&edge_serial->es_lock);
 	edge_port->close_pending = 0;
 
 	dbg("%s - exited", __FUNCTION__);
@@ -2743,7 +2744,7 @@ static int edge_startup (struct usb_seri
 		dev_err(&serial->dev->dev, "%s - Out of memory\n", __FUNCTION__);
 		return -ENOMEM;
 	}
-	sema_init(&edge_serial->es_sem, 1);
+	mutex_init(&edge_serial->es_lock);
 	edge_serial->serial = serial;
 	usb_set_serial_data(serial, edge_serial);
 
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

git-dvb.patch
git-infiniband.patch
git-netdev-all.patch
git-scsi-misc.patch
edgeport-usb-serial-converter-convert-es_sem-to-mutex.patch
parallel-port-convert-port_mutex-to-the-mutex-api.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
mbcs-convert-algolock-to-mutex.patch
mbcs-convert-dmawritelock-to-mutex.patch
mbcs-convert-dmareadlock-to-mutex.patch

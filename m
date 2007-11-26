From: akpm@linux-foundation.org
Subject: - ti-3410-5052-usb-serial-convert-td_open_close_lock-to-mutex.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:49:43 -0800
Message-ID: <200711262149.lAQLnhpU024781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60595 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755725AbXKZV6g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:58:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     TI 3410/5052 USB Serial: convert td_open_close_lock to mutex
has been removed from the -mm tree.  Its filename was
     ti-3410-5052-usb-serial-convert-td_open_close_lock-to-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: TI 3410/5052 USB Serial: convert td_open_close_lock to mutex
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

TI 3410/5052 USB Serial: convert semaphore td_open_close_lock to the mutex
API.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ti_usb_3410_5052.c |   27 ++++++++++++------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff -puN drivers/usb/serial/ti_usb_3410_5052.c~ti-3410-5052-usb-serial-convert-td_open_close_lock-to-mutex drivers/usb/serial/ti_usb_3410_5052.c
--- a/drivers/usb/serial/ti_usb_3410_5052.c~ti-3410-5052-usb-serial-convert-td_open_close_lock-to-mutex
+++ a/drivers/usb/serial/ti_usb_3410_5052.c
@@ -80,6 +80,7 @@
 #include <linux/ioctl.h>
 #include <linux/serial.h>
 #include <linux/circ_buf.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 #include <linux/usb.h>
@@ -139,7 +140,7 @@ struct ti_port {
 };
 
 struct ti_device {
-	struct semaphore	td_open_close_sem;
+	struct mutex		td_open_close_lock;
 	int			td_open_port_count;
 	struct usb_serial	*td_serial;
 	int			td_is_3410;
@@ -424,7 +425,7 @@ static int ti_startup(struct usb_serial 
 		dev_err(&dev->dev, "%s - out of memory\n", __FUNCTION__);
 		return -ENOMEM;
 	}
-	sema_init(&tdev->td_open_close_sem, 1);
+	mutex_init(&tdev->td_open_close_lock);
 	tdev->td_serial = serial;
 	usb_set_serial_data(serial, tdev);
 
@@ -547,7 +548,7 @@ static int ti_open(struct usb_serial_por
 	tdev = tport->tp_tdev;
 
 	/* only one open on any port on a device at a time */
-	if (down_interruptible(&tdev->td_open_close_sem))
+	if (mutex_lock_interruptible(&tdev->td_open_close_lock))
 		return -ERESTARTSYS;
 
 	if (port->tty)
@@ -568,7 +569,7 @@ static int ti_open(struct usb_serial_por
 		if (!urb) {
 			dev_err(&port->dev, "%s - no interrupt urb\n", __FUNCTION__);
 			status = -EINVAL;
-			goto up_sem;
+			goto release_lock;
 		}
 		urb->complete = ti_interrupt_callback;
 		urb->context = tdev;
@@ -576,7 +577,7 @@ static int ti_open(struct usb_serial_por
 		status = usb_submit_urb(urb, GFP_KERNEL);
 		if (status) {
 			dev_err(&port->dev, "%s - submit interrupt urb failed, %d\n", __FUNCTION__, status);
-			goto up_sem;
+			goto release_lock;
 		}
 	}
 
@@ -656,13 +657,13 @@ static int ti_open(struct usb_serial_por
 	tport->tp_is_open = 1;
 	++tdev->td_open_port_count;
 
-	goto up_sem;
+	goto release_lock;
 
 unlink_int_urb:
 	if (tdev->td_open_port_count == 0)
 		usb_kill_urb(port->serial->port[0]->interrupt_in_urb);
-up_sem:
-	up(&tdev->td_open_close_sem);
+release_lock:
+	mutex_unlock(&tdev->td_open_close_lock);
 	dbg("%s - exit %d", __FUNCTION__, status);
 	return status;
 }
@@ -674,7 +675,7 @@ static void ti_close(struct usb_serial_p
 	struct ti_port *tport;
 	int port_number;
 	int status;
-	int do_up;
+	int do_unlock;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 			 
@@ -699,16 +700,16 @@ static void ti_close(struct usb_serial_p
 	if (status)
 		dev_err(&port->dev, "%s - cannot send close port command, %d\n" , __FUNCTION__, status);
 
-	/* if down is interrupted, continue anyway */
-	do_up = !down_interruptible(&tdev->td_open_close_sem);
+	/* if mutex_lock is interrupted, continue anyway */
+	do_unlock = !mutex_lock_interruptible(&tdev->td_open_close_lock);
 	--tport->tp_tdev->td_open_port_count;
 	if (tport->tp_tdev->td_open_port_count <= 0) {
 		/* last port is closed, shut down interrupt urb */
 		usb_kill_urb(port->serial->port[0]->interrupt_in_urb);
 		tport->tp_tdev->td_open_port_count = 0;
 	}
-	if (do_up)
-		up(&tdev->td_open_close_sem);
+	if (do_unlock)
+		mutex_unlock(&tdev->td_open_close_lock);
 
 	dbg("%s - exit", __FUNCTION__);
 }
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

git-dvb.patch
git-infiniband.patch
git-netdev-all.patch
git-scsi-misc.patch
parallel-port-convert-port_mutex-to-the-mutex-api.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
mbcs-convert-algolock-to-mutex.patch
mbcs-convert-dmawritelock-to-mutex.patch
mbcs-convert-dmareadlock-to-mutex.patch

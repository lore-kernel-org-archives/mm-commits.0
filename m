From: akpm@linux-foundation.org
Subject: - use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:54 -0700
Message-ID: <200707192007.l6JK7sbH020401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50329 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761515AbXGSUQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, david-b@pacbell.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     use mutex instead of semaphore in the USB gadget serial driver
has been removed from the -mm tree.  Its filename was
     use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use mutex instead of semaphore in the USB gadget serial driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The USB gadget serial driver uses a semaphore as mutex. Use the
mutex API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Greg KH <greg@kroah.com>
Acked-by: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/serial.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff -puN drivers/usb/gadget/serial.c~use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver drivers/usb/gadget/serial.c
--- a/drivers/usb/gadget/serial.c~use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver
+++ a/drivers/usb/gadget/serial.c
@@ -33,6 +33,7 @@
 #include <linux/device.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
+#include <linux/mutex.h>
 
 #include <asm/byteorder.h>
 #include <asm/io.h>
@@ -258,7 +259,7 @@ static const char *EP_IN_NAME;
 static const char *EP_OUT_NAME;
 static const char *EP_NOTIFY_NAME;
 
-static struct semaphore	gs_open_close_sem[GS_NUM_PORTS];
+static struct mutex gs_open_close_lock[GS_NUM_PORTS];
 
 static unsigned int read_q_size = GS_DEFAULT_READ_Q_SIZE;
 static unsigned int write_q_size = GS_DEFAULT_WRITE_Q_SIZE;
@@ -595,7 +596,7 @@ static int __init gs_module_init(void)
 	tty_set_operations(gs_tty_driver, &gs_tty_ops);
 
 	for (i=0; i < GS_NUM_PORTS; i++)
-		sema_init(&gs_open_close_sem[i], 1);
+		mutex_init(&gs_open_close_lock[i]);
 
 	retval = tty_register_driver(gs_tty_driver);
 	if (retval) {
@@ -635,7 +636,7 @@ static int gs_open(struct tty_struct *tt
 	struct gs_port *port;
 	struct gs_dev *dev;
 	struct gs_buf *buf;
-	struct semaphore *sem;
+	struct mutex *mtx;
 	int ret;
 
 	port_num = tty->index;
@@ -656,10 +657,10 @@ static int gs_open(struct tty_struct *tt
 		return -ENODEV;
 	}
 
-	sem = &gs_open_close_sem[port_num];
-	if (down_interruptible(sem)) {
+	mtx = &gs_open_close_lock[port_num];
+	if (mutex_lock_interruptible(mtx)) {
 		printk(KERN_ERR
-		"gs_open: (%d,%p,%p) interrupted waiting for semaphore\n",
+		"gs_open: (%d,%p,%p) interrupted waiting for mutex\n",
 			port_num, tty, file);
 		return -ERESTARTSYS;
 	}
@@ -754,12 +755,12 @@ static int gs_open(struct tty_struct *tt
 
 exit_unlock_port:
 	spin_unlock_irqrestore(&port->port_lock, flags);
-	up(sem);
+	mutex_unlock(mtx);
 	return ret;
 
 exit_unlock_dev:
 	spin_unlock_irqrestore(&dev->dev_lock, flags);
-	up(sem);
+	mutex_unlock(mtx);
 	return ret;
 
 }
@@ -781,7 +782,7 @@ exit_unlock_dev:
 static void gs_close(struct tty_struct *tty, struct file *file)
 {
 	struct gs_port *port = tty->driver_data;
-	struct semaphore *sem;
+	struct mutex *mtx;
 
 	if (port == NULL) {
 		printk(KERN_ERR "gs_close: NULL port pointer\n");
@@ -790,8 +791,8 @@ static void gs_close(struct tty_struct *
 
 	gs_debug("gs_close: (%d,%p,%p)\n", port->port_num, tty, file);
 
-	sem = &gs_open_close_sem[port->port_num];
-	down(sem);
+	mtx = &gs_open_close_lock[port->port_num];
+	mutex_lock(mtx);
 
 	spin_lock_irq(&port->port_lock);
 
@@ -846,7 +847,7 @@ static void gs_close(struct tty_struct *
 
 exit:
 	spin_unlock_irq(&port->port_lock);
-	up(sem);
+	mutex_unlock(mtx);
 }
 
 /*
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch

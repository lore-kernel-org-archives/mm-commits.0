From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch added to -mm tree
Date: Fri, 13 Jul 2007 13:39:29 -0700
Message-ID: <200707132039.l6DKdTxA018440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48281 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757553AbXGMUkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 16:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, david-b@pacbell.net, greg@kroah.com


The patch titled
     use mutex instead of semaphore in the USB gadget serial driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-dvb.patch
git-mtd.patch
git-net.patch
use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver.patch
git-block.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
drivers-block-ubc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch
use-mutex-instead-of-semaphore-in-the-elan-u132-adapter-driver.patch
use-mutex-instead-of-semaphore-in-the-adutux-driver.patch
use-mutex-instead-of-semaphore-in-the-ftdi-elan-driver.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fs-block_devc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-spi-core-init-code.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch

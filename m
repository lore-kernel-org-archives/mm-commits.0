From: akpm@linux-foundation.org
Subject: - drivers-usb-misc-auerswaldc-convert-stats_sem-into-a-mutex.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:30 -0800
Message-ID: <200802232023.m1NKNUWt013527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761447AbYBWU2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias@kaehlcke.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/misc/auerswald.c: convert stats_sem into a mutex
has been removed from the -mm tree.  Its filename was
     drivers-usb-misc-auerswaldc-convert-stats_sem-into-a-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/misc/auerswald.c: convert stats_sem into a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

The semaphore cp->mutex is used as mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/auerswald.c |   45 +++++++++++++++++----------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff -puN drivers/usb/misc/auerswald.c~drivers-usb-misc-auerswaldc-convert-stats_sem-into-a-mutex drivers/usb/misc/auerswald.c
--- a/drivers/usb/misc/auerswald.c~drivers-usb-misc-auerswaldc-convert-stats_sem-into-a-mutex
+++ a/drivers/usb/misc/auerswald.c
@@ -31,6 +31,7 @@
 #include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/usb.h>
+#include <linux/mutex.h>
 
 /*-------------------------------------------------------------------*/
 /* Debug support 						     */
@@ -232,7 +233,7 @@ typedef struct auerscon
 /* USB device context */
 typedef struct
 {
-	struct semaphore 	mutex;         	    /* protection in user context */
+	struct mutex 	mutex;         	    /* protection in user context */
 	char 			name[20];	    /* name of the /dev/usb entry */
 	unsigned int		dtindex;	    /* index in the device table */
 	struct usb_device *	usbdev;      	    /* USB device handle */
@@ -1376,7 +1377,7 @@ static int auerchar_open (struct inode *
 	if (cp == NULL) {
 		return -ENODEV;
 	}
-	if (down_interruptible (&cp->mutex)) {
+	if (mutex_lock_interruptible(&cp->mutex)) {
 		return -ERESTARTSYS;
 	}
 
@@ -1405,7 +1406,7 @@ static int auerchar_open (struct inode *
 	cp->open_count++;
 	ccp->auerdev = cp;
 	dbg("open %s as /dev/%s", cp->dev_desc, cp->name);
-	up (&cp->mutex);
+	mutex_unlock(&cp->mutex);
 
 	/* file IO stuff */
 	file->f_pos = 0;
@@ -1413,7 +1414,7 @@ static int auerchar_open (struct inode *
 	return nonseekable_open(inode, file);
 
 	/* Error exit */
-ofail:	up (&cp->mutex);
+ofail:	mutex_unlock(&cp->mutex);
 	auerchar_delete (ccp);
 	return ret;
 }
@@ -1440,14 +1441,14 @@ static int auerchar_ioctl (struct inode 
 		up (&ccp->mutex);
                 return -ENODEV;
 	}
-	if (down_interruptible (&cp->mutex)) {
+	if (mutex_lock_interruptible(&cp->mutex)) {
 		up(&ccp->mutex);
 		return -ERESTARTSYS;
 	}
 
 	/* Check for removal */
 	if (!cp->usbdev) {
-		up(&cp->mutex);
+		mutex_unlock(&cp->mutex);
 		up(&ccp->mutex);
                 return -ENODEV;
 	}
@@ -1550,7 +1551,7 @@ static int auerchar_ioctl (struct inode 
 		break;
         }
 	/* release the mutexes */
-	up(&cp->mutex);
+	mutex_unlock(&cp->mutex);
 	up(&ccp->mutex);
 	return ret;
 }
@@ -1721,12 +1722,12 @@ write_again:
 		up (&ccp->mutex);
 		return -ERESTARTSYS;
 	}
-	if (down_interruptible (&cp->mutex)) {
+	if (mutex_lock_interruptible(&cp->mutex)) {
 		up (&ccp->mutex);
 		return -ERESTARTSYS;
 	}
 	if (!cp->usbdev) {
-		up (&cp->mutex);
+		mutex_unlock(&cp->mutex);
 		up (&ccp->mutex);
 		return -EIO;
 	}
@@ -1750,7 +1751,7 @@ write_again:
 
 	/* are there any buffers left? */
 	if (!bp) {
-		up (&cp->mutex);
+		mutex_unlock(&cp->mutex);
 		up (&ccp->mutex);
 
 		/* NONBLOCK: don't wait */
@@ -1783,7 +1784,7 @@ write_again:
 		auerbuf_releasebuf (bp);
 		/* Wake up all processes waiting for a buffer */
 		wake_up (&cp->bufferwait);
-		up (&cp->mutex);
+		mutex_unlock(&cp->mutex);
 		up (&ccp->mutex);
 		return -EFAULT;
 	}
@@ -1803,7 +1804,7 @@ write_again:
 		    auerchar_ctrlwrite_complete, bp);
 	/* up we go */
 	ret = auerchain_submit_urb (&cp->controlchain, bp->urbp);
-	up (&cp->mutex);
+	mutex_unlock(&cp->mutex);
 	if (ret) {
 		dbg ("auerchar_write: nonzero result of auerchain_submit_urb %d", ret);
 		auerbuf_releasebuf (bp);
@@ -1830,16 +1831,16 @@ static int auerchar_release (struct inod
 	down(&ccp->mutex);
 	cp = ccp->auerdev;
 	if (cp) {
-		down(&cp->mutex);
+		mutex_lock(&cp->mutex);
 		/* remove an open service */
 		auerswald_removeservice (cp, &ccp->scontext);
 		/* detach from device */
 		if ((--cp->open_count <= 0) && (cp->usbdev == NULL)) {
 			/* usb device waits for removal */
-			up (&cp->mutex);
+			mutex_unlock(&cp->mutex);
 			auerswald_delete (cp);
 		} else {
-			up (&cp->mutex);
+			mutex_unlock(&cp->mutex);
 		}
 		cp = NULL;
 		ccp->auerdev = NULL;
@@ -1917,7 +1918,7 @@ static int auerswald_probe (struct usb_i
 	}
 
 	/* Initialize device descriptor */
-	init_MUTEX (&cp->mutex);
+	mutex_init(&cp->mutex);
 	cp->usbdev = usbdev;
 	auerchain_init (&cp->controlchain);
         auerbuf_init (&cp->bufctl);
@@ -2042,7 +2043,7 @@ static void auerswald_disconnect (struct
 	/* give back our USB minor number */
 	usb_deregister_dev(intf, &auerswald_class);
 
-	down (&cp->mutex);
+	mutex_lock(&cp->mutex);
 	info ("device /dev/%s now disconnecting", cp->name);
 
 	/* Stop the interrupt endpoint */
@@ -2057,16 +2058,18 @@ static void auerswald_disconnect (struct
 
 	if (cp->open_count == 0) {
 		/* nobody is using this device. So we can clean up now */
-		up (&cp->mutex);/* up() is possible here because no other task
-				   can open the device (see above). I don't want
-				   to kfree() a locked mutex. */
+		mutex_unlock(&cp->mutex);
+		/* mutex_unlock() is possible here because no other task
+		   can open the device (see above). I don't want
+		   to kfree() a locked mutex. */
+
 		auerswald_delete (cp);
 	} else {
 		/* device is used. Remove the pointer to the
 		   usb device (it's not valid any more). The last
 		   release() will do the clean up */
 		cp->usbdev = NULL;
-		up (&cp->mutex);
+		mutex_unlock(&cp->mutex);
 		/* Terminate waiting writers */
 		wake_up (&cp->bufferwait);
 		/* Inform all waiting readers */
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

cosa-srp-convert-channel_datarsem-to-mutex.patch
convert-acl-sem-in-a-mutex.patch
convert-stats_sem-in-a-mutex.patch
convert-wpa_sem-in-a-mutex.patch

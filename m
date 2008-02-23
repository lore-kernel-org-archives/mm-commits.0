From: akpm@linux-foundation.org
Subject: - drivers-usb-misc-auerswaldc-convert-ccp-mutex-into-a-mutex.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:34 -0800
Message-ID: <200802232023.m1NKNYgw013534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762006AbYBWU2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias@kaehlcke.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/misc/auerswald.c: convert ccp->mutex into a mutex
has been removed from the -mm tree.  Its filename was
     drivers-usb-misc-auerswaldc-convert-ccp-mutex-into-a-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/misc/auerswald.c: convert ccp->mutex into a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

The semaphore ccp->mutex is used as mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/auerswald.c |   52 ++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff -puN drivers/usb/misc/auerswald.c~drivers-usb-misc-auerswaldc-convert-ccp-mutex-into-a-mutex drivers/usb/misc/auerswald.c
--- a/drivers/usb/misc/auerswald.c~drivers-usb-misc-auerswaldc-convert-ccp-mutex-into-a-mutex
+++ a/drivers/usb/misc/auerswald.c
@@ -254,7 +254,7 @@ typedef struct
 /* character device context */
 typedef struct
 {
-	struct semaphore mutex;         /* protection in user context */
+	struct mutex mutex;		/* protection in user context */
 	pauerswald_t auerdev;           /* context pointer of assigned device */
         auerbufctl_t bufctl;            /* controls the buffer chain */
         auerscon_t scontext;            /* service context */
@@ -1390,7 +1390,7 @@ static int auerchar_open (struct inode *
 	}
 
 	/* Initialize device descriptor */
-	init_MUTEX( &ccp->mutex);
+	mutex_init(&ccp->mutex);
 	mutex_init(&ccp->readmutex);
         auerbuf_init (&ccp->bufctl);
         ccp->scontext.id = AUH_UNASSIGNED;
@@ -1433,23 +1433,23 @@ static int auerchar_ioctl (struct inode 
         dbg ("ioctl");
 
 	/* get the mutexes */
-	if (down_interruptible (&ccp->mutex)) {
+	if (mutex_lock_interruptible(&ccp->mutex)) {
 		return -ERESTARTSYS;
 	}
 	cp = ccp->auerdev;
 	if (!cp) {
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
                 return -ENODEV;
 	}
 	if (mutex_lock_interruptible(&cp->mutex)) {
-		up(&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -ERESTARTSYS;
 	}
 
 	/* Check for removal */
 	if (!cp->usbdev) {
 		mutex_unlock(&cp->mutex);
-		up(&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
                 return -ENODEV;
 	}
 
@@ -1552,7 +1552,7 @@ static int auerchar_ioctl (struct inode 
         }
 	/* release the mutexes */
 	mutex_unlock(&cp->mutex);
-	up(&ccp->mutex);
+	mutex_unlock(&ccp->mutex);
 	return ret;
 }
 
@@ -1575,18 +1575,18 @@ static ssize_t auerchar_read (struct fil
 		return 0;
 
 	/* get the mutex */
-	if (down_interruptible (&ccp->mutex))
+	if (mutex_lock_interruptible(&ccp->mutex))
 		return -ERESTARTSYS;
 
 	/* Can we expect to read something? */
 	if (ccp->scontext.id == AUH_UNASSIGNED) {
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
                 return -EIO;
 	}
 
 	/* only one reader per device allowed */
 	if (mutex_lock_interruptible(&ccp->readmutex)) {
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -ERESTARTSYS;
 	}
 
@@ -1604,7 +1604,7 @@ doreadbuf:
 			if (copy_to_user (buf, bp->bufp+ccp->readoffset, count)) {
 				dbg ("auerswald_read: copy_to_user failed");
 				mutex_unlock(&ccp->readmutex);
-				up (&ccp->mutex);
+				mutex_unlock(&ccp->mutex);
 				return -EFAULT;
 			}
 		}
@@ -1619,7 +1619,7 @@ doreadbuf:
 		/* return with number of bytes read */
 		if (count) {
 			mutex_unlock(&ccp->readmutex);
-			up (&ccp->mutex);
+			mutex_unlock(&ccp->mutex);
 			return count;
 		}
 	}
@@ -1656,12 +1656,12 @@ doreadlist:
 		set_current_state (TASK_RUNNING);
 		remove_wait_queue (&ccp->readwait, &wait);
 		mutex_unlock(&ccp->readmutex);
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -EAGAIN;  /* nonblocking, no data available */
         }
 
 	/* yes, we should wait! */
-	up (&ccp->mutex); /* allow other operations while we wait */
+	mutex_unlock(&ccp->mutex); /* allow other operations while we wait */
 	schedule();
 	remove_wait_queue (&ccp->readwait, &wait);
 	if (signal_pending (current)) {
@@ -1676,7 +1676,7 @@ doreadlist:
 		return -EIO;
 	}
 
-	if (down_interruptible (&ccp->mutex)) {
+	if (mutex_lock_interruptible(&ccp->mutex)) {
 		mutex_unlock(&ccp->readmutex);
 		return -ERESTARTSYS;
 	}
@@ -1708,27 +1708,27 @@ static ssize_t auerchar_write (struct fi
 
 write_again:
 	/* get the mutex */
-	if (down_interruptible (&ccp->mutex))
+	if (mutex_lock_interruptible(&ccp->mutex))
 		return -ERESTARTSYS;
 
 	/* Can we expect to write something? */
 	if (ccp->scontext.id == AUH_UNASSIGNED) {
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
                 return -EIO;
 	}
 
 	cp = ccp->auerdev;
 	if (!cp) {
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -ERESTARTSYS;
 	}
 	if (mutex_lock_interruptible(&cp->mutex)) {
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -ERESTARTSYS;
 	}
 	if (!cp->usbdev) {
 		mutex_unlock(&cp->mutex);
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -EIO;
 	}
 	/* Prepare for sleep */
@@ -1752,7 +1752,7 @@ write_again:
 	/* are there any buffers left? */
 	if (!bp) {
 		mutex_unlock(&cp->mutex);
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 
 		/* NONBLOCK: don't wait */
 		if (file->f_flags & O_NONBLOCK) {
@@ -1785,7 +1785,7 @@ write_again:
 		/* Wake up all processes waiting for a buffer */
 		wake_up (&cp->bufferwait);
 		mutex_unlock(&cp->mutex);
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -EFAULT;
 	}
 
@@ -1810,12 +1810,12 @@ write_again:
 		auerbuf_releasebuf (bp);
 		/* Wake up all processes waiting for a buffer */
 		wake_up (&cp->bufferwait);
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return -EIO;
 	}
 	else {
 		dbg ("auerchar_write: Write OK");
-		up (&ccp->mutex);
+		mutex_unlock(&ccp->mutex);
 		return len;
 	}
 }
@@ -1828,7 +1828,7 @@ static int auerchar_release (struct inod
 	pauerswald_t cp;
 	dbg("release");
 
-	down(&ccp->mutex);
+	mutex_lock(&ccp->mutex);
 	cp = ccp->auerdev;
 	if (cp) {
 		mutex_lock(&cp->mutex);
@@ -1845,7 +1845,7 @@ static int auerchar_release (struct inod
 		cp = NULL;
 		ccp->auerdev = NULL;
 	}
-	up (&ccp->mutex);
+	mutex_unlock(&ccp->mutex);
 	auerchar_delete (ccp);
 
 	return 0;
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

cosa-srp-convert-channel_datarsem-to-mutex.patch
convert-acl-sem-in-a-mutex.patch
convert-stats_sem-in-a-mutex.patch
convert-wpa_sem-in-a-mutex.patch

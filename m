From: akpm@linux-foundation.org
Subject: + drivers-usb-misc-auerswaldc-convert-ccp-readmutex-into-a-mutex.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:31:13 -0800
Message-ID: <200802230732.m1N7W2Mg018055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbYBWHyF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias@kaehlcke.net, greg@kroah.com


The patch titled
     drivers/usb/misc/auerswald.c: convert ccp->readmutex into a mutex
has been added to the -mm tree.  Its filename is
     drivers-usb-misc-auerswaldc-convert-ccp-readmutex-into-a-mutex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/misc/auerswald.c: convert ccp->readmutex into a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

The semaphore ccp->readmutex is used as mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/auerswald.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/usb/misc/auerswald.c~drivers-usb-misc-auerswaldc-convert-ccp-readmutex-into-a-mutex drivers/usb/misc/auerswald.c
--- a/drivers/usb/misc/auerswald.c~drivers-usb-misc-auerswaldc-convert-ccp-readmutex-into-a-mutex
+++ a/drivers/usb/misc/auerswald.c
@@ -259,7 +259,7 @@ typedef struct
         auerbufctl_t bufctl;            /* controls the buffer chain */
         auerscon_t scontext;            /* service context */
 	wait_queue_head_t readwait;     /* for synchronous reading */
-	struct semaphore readmutex;     /* protection against multiple reads */
+	struct mutex readmutex;		/* protection against multiple reads */
 	pauerbuf_t readbuf;		/* buffer held for partial reading */
 	unsigned int readoffset;	/* current offset in readbuf */
 	unsigned int removed;		/* is != 0 if device is removed */
@@ -1391,7 +1391,7 @@ static int auerchar_open (struct inode *
 
 	/* Initialize device descriptor */
 	init_MUTEX( &ccp->mutex);
-	init_MUTEX( &ccp->readmutex);
+	mutex_init(&ccp->readmutex);
         auerbuf_init (&ccp->bufctl);
         ccp->scontext.id = AUH_UNASSIGNED;
         ccp->scontext.dispatch = auerchar_ctrlread_dispatch;
@@ -1585,7 +1585,7 @@ static ssize_t auerchar_read (struct fil
 	}
 
 	/* only one reader per device allowed */
-	if (down_interruptible (&ccp->readmutex)) {
+	if (mutex_lock_interruptible(&ccp->readmutex)) {
 		up (&ccp->mutex);
 		return -ERESTARTSYS;
 	}
@@ -1603,7 +1603,7 @@ doreadbuf:
 		if (count) {
 			if (copy_to_user (buf, bp->bufp+ccp->readoffset, count)) {
 				dbg ("auerswald_read: copy_to_user failed");
-				up (&ccp->readmutex);
+				mutex_unlock(&ccp->readmutex);
 				up (&ccp->mutex);
 				return -EFAULT;
 			}
@@ -1618,7 +1618,7 @@ doreadbuf:
 		}
 		/* return with number of bytes read */
 		if (count) {
-			up (&ccp->readmutex);
+			mutex_unlock(&ccp->readmutex);
 			up (&ccp->mutex);
 			return count;
 		}
@@ -1655,7 +1655,7 @@ doreadlist:
                 dbg ("No read buffer available, returning -EAGAIN");
 		set_current_state (TASK_RUNNING);
 		remove_wait_queue (&ccp->readwait, &wait);
-		up (&ccp->readmutex);
+		mutex_unlock(&ccp->readmutex);
 		up (&ccp->mutex);
 		return -EAGAIN;  /* nonblocking, no data available */
         }
@@ -1666,18 +1666,18 @@ doreadlist:
 	remove_wait_queue (&ccp->readwait, &wait);
 	if (signal_pending (current)) {
 		/* waked up by a signal */
-		up (&ccp->readmutex);
+		mutex_unlock(&ccp->readmutex);
 		return -ERESTARTSYS;
 	}
 
 	/* Anything left to read? */
 	if ((ccp->scontext.id == AUH_UNASSIGNED) || ccp->removed) {
-		up (&ccp->readmutex);
+		mutex_unlock(&ccp->readmutex);
 		return -EIO;
 	}
 
 	if (down_interruptible (&ccp->mutex)) {
-		up (&ccp->readmutex);
+		mutex_unlock(&ccp->readmutex);
 		return -ERESTARTSYS;
 	}
 
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

cosa-srp-convert-channel_datarsem-to-mutex.patch
drivers-usb-misc-auerswaldc-convert-stats_sem-into-a-mutex.patch
drivers-usb-misc-auerswaldc-convert-ccp-readmutex-into-a-mutex.patch
drivers-usb-misc-auerswaldc-convert-ccp-mutex-into-a-mutex.patch
convert-acl-sem-in-a-mutex.patch
convert-stats_sem-in-a-mutex.patch
convert-wpa_sem-in-a-mutex.patch

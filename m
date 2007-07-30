From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-the-scsi-tape-driver.patch added to -mm tree
Date: Mon, 30 Jul 2007 16:46:37 -0700
Message-ID: <200707302346.l6UNkbdY004637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34236 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757722AbXG3Xqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 19:46:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, kai.makisara@kolumbus.fi, satyam@infradead.org


The patch titled
     Use mutex instead of semaphore in the SCSI Tape driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-the-scsi-tape-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use mutex instead of semaphore in the SCSI Tape driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The SCSI Tape driver uses a semaphore as mutex.  Use the mutex API instead of
the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Reviewed-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Kai Makisara <kai.makisara@kolumbus.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/st.c |   16 ++++++++--------
 drivers/scsi/st.h |    3 ++-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/st.c~use-mutex-instead-of-semaphore-in-the-scsi-tape-driver drivers/scsi/st.c
--- a/drivers/scsi/st.c~use-mutex-instead-of-semaphore-in-the-scsi-tape-driver
+++ a/drivers/scsi/st.c
@@ -1485,7 +1485,7 @@ st_write(struct file *filp, const char _
 	struct st_buffer *STbp;
 	char *name = tape_name(STp);
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
 
 	retval = rw_checks(STp, filp, count);
@@ -1736,7 +1736,7 @@ st_write(struct file *filp, const char _
 	if (SRpnt != NULL)
 		st_release_request(SRpnt);
 	release_buffering(STp, 0);
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return retval;
 }
@@ -1942,7 +1942,7 @@ st_read(struct file *filp, char __user *
 	struct st_buffer *STbp = STp->buffer;
 	DEB( char *name = tape_name(STp); )
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
 
 	retval = rw_checks(STp, filp, count);
@@ -2069,7 +2069,7 @@ st_read(struct file *filp, char __user *
 		release_buffering(STp, 1);
 		STbp->buffer_bytes = 0;
 	}
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 
 	return retval;
 }
@@ -3226,7 +3226,7 @@ static int st_ioctl(struct inode *inode,
 	char *name = tape_name(STp);
 	void __user *p = (void __user *)arg;
 
-	if (down_interruptible(&STp->lock))
+	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
 
         DEB(
@@ -3537,7 +3537,7 @@ static int st_ioctl(struct inode *inode,
 			retval = (-EFAULT);
 		goto out;
 	}
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 	switch (cmd_in) {
 		case SCSI_IOCTL_GET_IDLUN:
 		case SCSI_IOCTL_GET_BUS_NUMBER:
@@ -3563,7 +3563,7 @@ static int st_ioctl(struct inode *inode,
 	return retval;
 
  out:
-	up(&STp->lock);
+	mutex_unlock(&STp->lock);
 	return retval;
 }
 
@@ -4029,7 +4029,7 @@ static int st_probe(struct device *dev)
 
 	tpnt->density_changed = tpnt->compression_changed =
 	    tpnt->blksize_changed = 0;
-	init_MUTEX(&tpnt->lock);
+	mutex_init(&tpnt->lock);
 
 	st_nr_dev++;
 	write_unlock(&st_dev_arr_lock);
diff -puN drivers/scsi/st.h~use-mutex-instead-of-semaphore-in-the-scsi-tape-driver drivers/scsi/st.h
--- a/drivers/scsi/st.h~use-mutex-instead-of-semaphore-in-the-scsi-tape-driver
+++ a/drivers/scsi/st.h
@@ -3,6 +3,7 @@
 #define _ST_H
 
 #include <linux/completion.h>
+#include <linux/mutex.h>
 #include <linux/kref.h>
 #include <scsi/scsi_cmnd.h>
 
@@ -98,7 +99,7 @@ struct st_partstat {
 struct scsi_tape {
 	struct scsi_driver *driver;
 	struct scsi_device *device;
-	struct semaphore lock;	/* For serialization */
+	struct mutex lock;	/* For serialization */
 	struct completion wait;	/* For SCSI commands */
 	struct st_buffer *buffer;
 
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch
use-mutex-instead-of-semaphore-in-the-host-ap-driver.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch
use-mutex-instead-of-semaphore-in-the-dvb-frontend-tuning-interface.patch

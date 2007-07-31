From: akpm@linux-foundation.org
Subject: - use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch removed from -mm tree
Date: Tue, 31 Jul 2007 01:51:17 -0700
Message-ID: <200707310856.l6V8u0DD025117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752529AbXGaI4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 04:56:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, kkeil@suse.de, satyam@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Use mutex instead of semaphore in ISDN subsystem common functions
has been removed from the -mm tree.  Its filename was
     use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Use mutex instead of semaphore in ISDN subsystem common functions
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The ISDN subsystem common functions use a semaphore as mutex.  Use the mutex
API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Reviewed-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/i4l/isdn_common.c |   26 +++++++++++++-------------
 include/linux/isdn.h           |    3 ++-
 2 files changed, 15 insertions(+), 14 deletions(-)

diff -puN drivers/isdn/i4l/isdn_common.c~use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions drivers/isdn/i4l/isdn_common.c
--- a/drivers/isdn/i4l/isdn_common.c~use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions
+++ a/drivers/isdn/i4l/isdn_common.c
@@ -1364,7 +1364,7 @@ isdn_ioctl(struct inode *inode, struct f
 				} else {
 					s = NULL;
 				}
-				ret = down_interruptible(&dev->sem);
+				ret = mutex_lock_interruptible(&dev->mtx);
 				if( ret ) return ret;
 				if ((s = isdn_net_new(s, NULL))) {
 					if (copy_to_user(argp, s, strlen(s) + 1)){
@@ -1374,7 +1374,7 @@ isdn_ioctl(struct inode *inode, struct f
 					}
 				} else
 					ret = -ENODEV;
-				up(&dev->sem);
+				mutex_unlock(&dev->mtx);
 				return ret;
 			case IIOCNETASL:
 				/* Add a slave to a network-interface */
@@ -1383,7 +1383,7 @@ isdn_ioctl(struct inode *inode, struct f
 						return -EFAULT;
 				} else
 					return -EINVAL;
-				ret = down_interruptible(&dev->sem);
+				ret = mutex_lock_interruptible(&dev->mtx);
 				if( ret ) return ret;
 				if ((s = isdn_net_newslave(bname))) {
 					if (copy_to_user(argp, s, strlen(s) + 1)){
@@ -1393,17 +1393,17 @@ isdn_ioctl(struct inode *inode, struct f
 					}
 				} else
 					ret = -ENODEV;
-				up(&dev->sem);
+				mutex_unlock(&dev->mtx);
 				return ret;
 			case IIOCNETDIF:
 				/* Delete a network-interface */
 				if (arg) {
 					if (copy_from_user(name, argp, sizeof(name)))
 						return -EFAULT;
-					ret = down_interruptible(&dev->sem);
+					ret = mutex_lock_interruptible(&dev->mtx);
 					if( ret ) return ret;
 					ret = isdn_net_rm(name);
-					up(&dev->sem);
+					mutex_unlock(&dev->mtx);
 					return ret;
 				} else
 					return -EINVAL;
@@ -1432,10 +1432,10 @@ isdn_ioctl(struct inode *inode, struct f
 				if (arg) {
 					if (copy_from_user(&phone, argp, sizeof(phone)))
 						return -EFAULT;
-					ret = down_interruptible(&dev->sem);
+					ret = mutex_lock_interruptible(&dev->mtx);
 					if( ret ) return ret;
 					ret = isdn_net_addphone(&phone);
-					up(&dev->sem);
+					mutex_unlock(&dev->mtx);
 					return ret;
 				} else
 					return -EINVAL;
@@ -1444,10 +1444,10 @@ isdn_ioctl(struct inode *inode, struct f
 				if (arg) {
 					if (copy_from_user(&phone, argp, sizeof(phone)))
 						return -EFAULT;
-					ret = down_interruptible(&dev->sem);
+					ret = mutex_lock_interruptible(&dev->mtx);
 					if( ret ) return ret;
 					ret = isdn_net_getphones(&phone, argp);
-					up(&dev->sem);
+					mutex_unlock(&dev->mtx);
 					return ret;
 				} else
 					return -EINVAL;
@@ -1456,10 +1456,10 @@ isdn_ioctl(struct inode *inode, struct f
 				if (arg) {
 					if (copy_from_user(&phone, argp, sizeof(phone)))
 						return -EFAULT;
-					ret = down_interruptible(&dev->sem);
+					ret = mutex_lock_interruptible(&dev->mtx);
 					if( ret ) return ret;
 					ret = isdn_net_delphone(&phone);
-					up(&dev->sem);
+					mutex_unlock(&dev->mtx);
 					return ret;
 				} else
 					return -EINVAL;
@@ -2303,7 +2303,7 @@ static int __init isdn_init(void)
 #ifdef MODULE
 	dev->owner = THIS_MODULE;
 #endif
-	init_MUTEX(&dev->sem);
+	mutex_init(&dev->mtx);
 	init_waitqueue_head(&dev->info_waitq);
 	for (i = 0; i < ISDN_MAX_CHANNELS; i++) {
 		dev->drvmap[i] = -1;
diff -puN include/linux/isdn.h~use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions include/linux/isdn.h
--- a/include/linux/isdn.h~use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions
+++ a/include/linux/isdn.h
@@ -15,6 +15,7 @@
 #define __ISDN_H__
 
 #include <linux/ioctl.h>
+#include <linux/mutex.h>
 
 #ifdef CONFIG_COBALT_MICRO_SERVER
 /* Save memory */
@@ -624,7 +625,7 @@ typedef struct isdn_devt {
 	int               v110emu[ISDN_MAX_CHANNELS]; /* V.110 emulator-mode 0=none */
 	atomic_t          v110use[ISDN_MAX_CHANNELS]; /* Usage-Semaphore for stream */
 	isdn_v110_stream  *v110[ISDN_MAX_CHANNELS];   /* V.110 private data         */
-	struct semaphore  sem;                        /* serialize list access*/
+	struct mutex      mtx;                        /* serialize list access*/
 	unsigned long     global_features;
 } isdn_dev;
 
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
kcopyd-use-mutex-instead-of-semaphore.patch
git-dvb.patch
git-mtd.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-the-host-ap-driver.patch
use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch

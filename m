From: akpm@linux-foundation.org
Subject: - use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:39:59 -0700
Message-ID: <200710162039.l9GKdxpm015611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57616 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964823AbXJPVMB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:12:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     use mutexinstead of semaphore in isdn subsystem common functions
has been removed from the -mm tree.  Its filename was
     use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use mutexinstead of semaphore in isdn subsystem common functions
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The ISDN subsystem common functions use a semaphore as mutex. Use the
mutex API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/i4l/isdn_common.c |   26 +++++++++++++-------------
 include/linux/isdn.h           |    3 ++-
 2 files changed, 15 insertions(+), 14 deletions(-)

diff -puN drivers/isdn/i4l/isdn_common.c~use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions drivers/isdn/i4l/isdn_common.c
--- a/drivers/isdn/i4l/isdn_common.c~use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions
+++ a/drivers/isdn/i4l/isdn_common.c
@@ -1365,7 +1365,7 @@ isdn_ioctl(struct inode *inode, struct f
 				} else {
 					s = NULL;
 				}
-				ret = down_interruptible(&dev->sem);
+				ret = mutex_lock_interruptible(&dev->mtx);
 				if( ret ) return ret;
 				if ((s = isdn_net_new(s, NULL))) {
 					if (copy_to_user(argp, s, strlen(s) + 1)){
@@ -1375,7 +1375,7 @@ isdn_ioctl(struct inode *inode, struct f
 					}
 				} else
 					ret = -ENODEV;
-				up(&dev->sem);
+				mutex_unlock(&dev->mtx);
 				return ret;
 			case IIOCNETASL:
 				/* Add a slave to a network-interface */
@@ -1384,7 +1384,7 @@ isdn_ioctl(struct inode *inode, struct f
 						return -EFAULT;
 				} else
 					return -EINVAL;
-				ret = down_interruptible(&dev->sem);
+				ret = mutex_lock_interruptible(&dev->mtx);
 				if( ret ) return ret;
 				if ((s = isdn_net_newslave(bname))) {
 					if (copy_to_user(argp, s, strlen(s) + 1)){
@@ -1394,17 +1394,17 @@ isdn_ioctl(struct inode *inode, struct f
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
@@ -1433,10 +1433,10 @@ isdn_ioctl(struct inode *inode, struct f
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
@@ -1445,10 +1445,10 @@ isdn_ioctl(struct inode *inode, struct f
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
@@ -1457,10 +1457,10 @@ isdn_ioctl(struct inode *inode, struct f
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
@@ -2304,7 +2304,7 @@ static int __init isdn_init(void)
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
@@ -167,6 +167,7 @@ typedef struct {
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/tcp.h>
+#include <linux/mutex.h>
 
 #define ISDN_TTY_MAJOR    43
 #define ISDN_TTYAUX_MAJOR 44
@@ -616,7 +617,7 @@ typedef struct isdn_devt {
 	int               v110emu[ISDN_MAX_CHANNELS]; /* V.110 emulator-mode 0=none */
 	atomic_t          v110use[ISDN_MAX_CHANNELS]; /* Usage-Semaphore for stream */
 	isdn_v110_stream  *v110[ISDN_MAX_CHANNELS];   /* V.110 private data         */
-	struct semaphore  sem;                        /* serialize list access*/
+	struct mutex      mtx;                        /* serialize list access*/
 	unsigned long     global_features;
 } isdn_dev;
 
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
git-alsa.patch
generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
git-ieee1394.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch

From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-capi-20-interface.patch added to -mm tree
Date: Thu, 03 May 2007 20:16:39 -0700
Message-ID: <200705040316.l443GdQw027970@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767614AbXEDDQp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 23:16:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, kkeil@suse.de


The patch titled
     use mutex instead of semaphore in CAPI 2.0 interface
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-capi-20-interface.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use mutex instead of semaphore in CAPI 2.0 interface
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The CAPI 2.0 interface uses a semaphore as mutex.  Use the mutex API instead
of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capi.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN drivers/isdn/capi/capi.c~use-mutex-instead-of-semaphore-in-capi-20-interface drivers/isdn/capi/capi.c
--- a/drivers/isdn/capi/capi.c~use-mutex-instead-of-semaphore-in-capi-20-interface
+++ a/drivers/isdn/capi/capi.c
@@ -146,7 +146,7 @@ struct capidev {
 
 	struct capincci *nccis;
 
-	struct semaphore ncci_list_sem;
+	struct mutex ncci_list_mtx;
 };
 
 /* -------- global variables ---------------------------------------- */
@@ -394,7 +394,7 @@ static struct capidev *capidev_alloc(voi
 	if (!cdev)
 		return NULL;
 
-	init_MUTEX(&cdev->ncci_list_sem);
+	mutex_init(&cdev->ncci_list_mtx);
 	skb_queue_head_init(&cdev->recvqueue);
 	init_waitqueue_head(&cdev->recvwait);
 	write_lock_irqsave(&capidev_list_lock, flags);
@@ -413,9 +413,9 @@ static void capidev_free(struct capidev 
 	}
 	skb_queue_purge(&cdev->recvqueue);
 
-	down(&cdev->ncci_list_sem);
+	mutex_lock(&cdev->ncci_list_mtx);
 	capincci_free(cdev, 0xffffffff);
-	up(&cdev->ncci_list_sem);
+	mutex_unlock(&cdev->ncci_list_mtx);
 
 	write_lock_irqsave(&capidev_list_lock, flags);
 	list_del(&cdev->list);
@@ -602,15 +602,15 @@ static void capi_recv_message(struct cap
 	if (CAPIMSG_CMD(skb->data) == CAPI_CONNECT_B3_CONF) {
 		u16 info = CAPIMSG_U16(skb->data, 12); // Info field
 		if (info == 0) {
-			down(&cdev->ncci_list_sem);
+			mutex_lock(&cdev->ncci_list_mtx);
 			capincci_alloc(cdev, CAPIMSG_NCCI(skb->data));
-			up(&cdev->ncci_list_sem);
+			mutex_unlock(&cdev->ncci_list_mtx);
 		}
 	}
 	if (CAPIMSG_CMD(skb->data) == CAPI_CONNECT_B3_IND) {
-		down(&cdev->ncci_list_sem);
+		mutex_lock(&cdev->ncci_list_mtx);
 		capincci_alloc(cdev, CAPIMSG_NCCI(skb->data));
-		up(&cdev->ncci_list_sem);
+		mutex_unlock(&cdev->ncci_list_mtx);
 	}
 	spin_lock_irqsave(&workaround_lock, flags);
 	if (CAPIMSG_COMMAND(skb->data) != CAPI_DATA_B3) {
@@ -751,9 +751,9 @@ capi_write(struct file *file, const char
 	CAPIMSG_SETAPPID(skb->data, cdev->ap.applid);
 
 	if (CAPIMSG_CMD(skb->data) == CAPI_DISCONNECT_B3_RESP) {
-		down(&cdev->ncci_list_sem);
+		mutex_lock(&cdev->ncci_list_mtx);
 		capincci_free(cdev, CAPIMSG_NCCI(skb->data));
-		up(&cdev->ncci_list_sem);
+		mutex_unlock(&cdev->ncci_list_mtx);
 	}
 
 	cdev->errcode = capi20_put_message(&cdev->ap, skb);
@@ -938,9 +938,9 @@ capi_ioctl(struct inode *inode, struct f
 			if (copy_from_user(&ncci, argp, sizeof(ncci)))
 				return -EFAULT;
 
-			down(&cdev->ncci_list_sem);
+			mutex_lock(&cdev->ncci_list_mtx);
 			if ((nccip = capincci_find(cdev, (u32) ncci)) == 0) {
-				up(&cdev->ncci_list_sem);
+				mutex_unlock(&cdev->ncci_list_mtx);
 				return 0;
 			}
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
@@ -948,7 +948,7 @@ capi_ioctl(struct inode *inode, struct f
 				count += atomic_read(&mp->ttyopencount);
 			}
 #endif /* CONFIG_ISDN_CAPI_MIDDLEWARE */
-			up(&cdev->ncci_list_sem);
+			mutex_unlock(&cdev->ncci_list_mtx);
 			return count;
 		}
 		return 0;
@@ -963,14 +963,14 @@ capi_ioctl(struct inode *inode, struct f
 			if (copy_from_user(&ncci, argp,
 					   sizeof(ncci)))
 				return -EFAULT;
-			down(&cdev->ncci_list_sem);
+			mutex_lock(&cdev->ncci_list_mtx);
 			nccip = capincci_find(cdev, (u32) ncci);
 			if (!nccip || (mp = nccip->minorp) == 0) {
-				up(&cdev->ncci_list_sem);
+				mutex_unlock(&cdev->ncci_list_mtx);
 				return -ESRCH;
 			}
 			unit = mp->minor;
-			up(&cdev->ncci_list_sem);
+			mutex_unlock(&cdev->ncci_list_mtx);
 			return unit;
 		}
 		return 0;
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
include-kern_-constant-in-printk-calls-in-mm-slabc.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
git-dvb.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
qla1280-use-dma_64bit_mask-instead-of-0ull.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch
use-mutex-instead-of-semaphore-in-rocketport-driver.patch
use-mutex-instead-of-semaphore-in-tpm-driver.patch
use-mutex-instead-of-semaphore-in-hdaps-driver.patch
use-mutex-instead-of-semaphore-for-misc-char-devices.patch
fix-spinlock-usage-in-hysdn_log_close.patch
use-mutex-instead-of-semaphore-in-capi-20-interface.patch
use-mutex-instead-of-semaphore-in-virtual-console-driver.patch

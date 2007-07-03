From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-virtual-video-driver.patch added to -mm tree
Date: Tue, 03 Jul 2007 14:24:07 -0700
Message-ID: <200707032124.l63LO7rQ016553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757734AbXGCVYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 17:24:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, mchehab@infradead.org


The patch titled
     use mutex instead of semaphore in Virtual Video driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-virtual-video-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use mutex instead of semaphore in Virtual Video driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The Virtual Video driver uses a semaphore as mutex.  Use the mutex API instead
of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/vivi.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/media/video/vivi.c~use-mutex-instead-of-semaphore-in-virtual-video-driver drivers/media/video/vivi.c
--- a/drivers/media/video/vivi.c~use-mutex-instead-of-semaphore-in-virtual-video-driver
+++ a/drivers/media/video/vivi.c
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <linux/random.h>
 #include <linux/version.h>
+#include <linux/mutex.h>
 #include <linux/videodev2.h>
 #include <linux/dma-mapping.h>
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
@@ -165,7 +166,7 @@ static LIST_HEAD(vivi_devlist);
 struct vivi_dev {
 	struct list_head           vivi_devlist;
 
-	struct semaphore           lock;
+	struct mutex               lock;
 
 	int                        users;
 
@@ -738,16 +739,16 @@ static struct videobuf_queue_ops vivi_vi
 static int res_get(struct vivi_dev *dev, struct vivi_fh *fh)
 {
 	/* is it free? */
-	down(&dev->lock);
+	mutex_lock(&dev->lock);
 	if (dev->resources) {
 		/* no, someone else uses it */
-		up(&dev->lock);
+		mutex_unlock(&dev->lock);
 		return 0;
 	}
 	/* it's free, grab it */
 	dev->resources =1;
 	dprintk(1,"res: get\n");
-	up(&dev->lock);
+	mutex_unlock(&dev->lock);
 	return 1;
 }
 
@@ -758,10 +759,10 @@ static int res_locked(struct vivi_dev *d
 
 static void res_free(struct vivi_dev *dev, struct vivi_fh *fh)
 {
-	down(&dev->lock);
+	mutex_lock(&dev->lock);
 	dev->resources = 0;
 	dprintk(1,"res: put\n");
-	up(&dev->lock);
+	mutex_lock(&dev->lock);
 }
 
 /* ------------------------------------------------------------------
@@ -1260,7 +1261,7 @@ static int __init vivi_init(void)
 	init_waitqueue_head(&dev->vidq.wq);
 
 	/* initialize locks */
-	init_MUTEX(&dev->lock);
+	mutex_init(&dev->lock);
 
 	dev->vidq.timeout.function = vivi_vid_timeout;
 	dev->vidq.timeout.data     = (unsigned long)dev;
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
git-netdev-all.patch
block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
drivers-block-ubc-use-list_for_each_entry.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fs-block_devc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver.patch
use-mutex-instead-of-semaphore-in-philips-webcam-driver.patch
use-mutex-instead-of-semaphore-in-virtual-video-driver.patch
use-mutex-instead-of-semaphore-in-vlsi-82c147-irda-controller-driver.patch

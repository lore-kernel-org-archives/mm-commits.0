From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-philips-webcam-driver.patch added to -mm tree
Date: Tue, 03 Jul 2007 14:24:05 -0700
Message-ID: <200707032124.l63LO5V4016550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756946AbXGCVYQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 17:24:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, mchehab@infradead.org


The patch titled
     use mutex instead of semaphore in Philips webcam driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-philips-webcam-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use mutex instead of semaphore in Philips webcam driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The Philips webcam driver uses a semaphore as mutex.  Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/pwc/pwc-if.c |   12 ++++++------
 drivers/media/video/pwc/pwc.h    |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/media/video/pwc/pwc-if.c~use-mutex-instead-of-semaphore-in-philips-webcam-driver drivers/media/video/pwc/pwc-if.c
--- a/drivers/media/video/pwc/pwc-if.c~use-mutex-instead-of-semaphore-in-philips-webcam-driver
+++ a/drivers/media/video/pwc/pwc-if.c
@@ -1099,7 +1099,7 @@ static int pwc_video_open(struct inode *
 		return -EBUSY;
 	}
 
-	down(&pdev->modlock);
+	mutex_lock(&pdev->modlock);
 	if (!pdev->usb_init) {
 		PWC_DEBUG_OPEN("Doing first time initialization.\n");
 		pdev->usb_init = 1;
@@ -1131,7 +1131,7 @@ static int pwc_video_open(struct inode *
 	if (i < 0) {
 		PWC_DEBUG_OPEN("Failed to allocate buffers memory.\n");
 		pwc_free_buffers(pdev);
-		up(&pdev->modlock);
+		mutex_unlock(&pdev->modlock);
 		return i;
 	}
 
@@ -1172,7 +1172,7 @@ static int pwc_video_open(struct inode *
 	if (i) {
 		PWC_DEBUG_OPEN("Second attempt at set_video_mode failed.\n");
 		pwc_free_buffers(pdev);
-		up(&pdev->modlock);
+		mutex_unlock(&pdev->modlock);
 		return i;
 	}
 
@@ -1181,7 +1181,7 @@ static int pwc_video_open(struct inode *
 		PWC_DEBUG_OPEN("Failed to init ISOC stuff = %d.\n", i);
 		pwc_isoc_cleanup(pdev);
 		pwc_free_buffers(pdev);
-		up(&pdev->modlock);
+		mutex_unlock(&pdev->modlock);
 		return i;
 	}
 
@@ -1191,7 +1191,7 @@ static int pwc_video_open(struct inode *
 
 	pdev->vopen++;
 	file->private_data = vdev;
-	up(&pdev->modlock);
+	mutex_unlock(&pdev->modlock);
 	PWC_DEBUG_OPEN("<< video_open() returns 0.\n");
 	return 0;
 }
@@ -1685,7 +1685,7 @@ static int usb_pwc_probe(struct usb_inte
 		pdev->angle_range.tilt_max =  2500;
 	}
 
-	init_MUTEX(&pdev->modlock);
+	mutex_init(&pdev->modlock);
 	spin_lock_init(&pdev->ptrlock);
 
 	pdev->udev = udev;
diff -puN drivers/media/video/pwc/pwc.h~use-mutex-instead-of-semaphore-in-philips-webcam-driver drivers/media/video/pwc/pwc.h
--- a/drivers/media/video/pwc/pwc.h~use-mutex-instead-of-semaphore-in-philips-webcam-driver
+++ a/drivers/media/video/pwc/pwc.h
@@ -31,7 +31,7 @@
 #include <linux/wait.h>
 #include <linux/smp_lock.h>
 #include <linux/version.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 #include <asm/errno.h>
 #include <linux/videodev.h>
 #include <media/v4l2-common.h>
@@ -244,7 +244,7 @@ struct pwc_device
    int image_read_pos;			/* In case we read data in pieces, keep track of were we are in the imagebuffer */
    int image_used[MAX_IMAGES];		/* For MCAPTURE and SYNC */
 
-   struct semaphore modlock;		/* to prevent races in video_open(), etc */
+   struct mutex modlock;		/* to prevent races in video_open(), etc */
    spinlock_t ptrlock;			/* for manipulating the buffer pointers */
 
    /*** motorized pan/tilt feature */
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

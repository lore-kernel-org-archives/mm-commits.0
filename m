From: akpm@linux-foundation.org
Subject: + media-video-usbvision-remove-ctrlurblock.patch added to -mm tree
Date: Tue, 11 Dec 2007 22:03:27 -0800
Message-ID: <200712120603.lBC63R7B028766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012AbXLLGEX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 01:04:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, mchehab@infradead.org


The patch titled
     media: video: usbvision: remove ctrlUrbLock
has been added to the -mm tree.  Its filename is
     media-video-usbvision-remove-ctrlurblock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: media: video: usbvision: remove ctrlUrbLock
From: Daniel Walker <dwalker@mvista.com>

The ctrlUrbLock has all it's users commented out, and so it's unused.  This
patch removes it.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/usbvision/usbvision-core.c  |    3 ---
 drivers/media/video/usbvision/usbvision-video.c |    1 -
 drivers/media/video/usbvision/usbvision.h       |    1 -
 3 files changed, 5 deletions(-)

diff -puN drivers/media/video/usbvision/usbvision-core.c~media-video-usbvision-remove-ctrlurblock drivers/media/video/usbvision/usbvision-core.c
--- a/drivers/media/video/usbvision/usbvision-core.c~media-video-usbvision-remove-ctrlurblock
+++ a/drivers/media/video/usbvision/usbvision-core.c
@@ -1561,13 +1561,10 @@ static int usbvision_write_reg_irq(struc
 	if (len > 8) {
 		return -EFAULT;
 	}
-//	down(&usbvision->ctrlUrbLock);
 	if (usbvision->ctrlUrbBusy) {
-//		up(&usbvision->ctrlUrbLock);
 		return -EBUSY;
 	}
 	usbvision->ctrlUrbBusy = 1;
-//	up(&usbvision->ctrlUrbLock);
 
 	usbvision->ctrlUrbSetup.bRequestType = USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_ENDPOINT;
 	usbvision->ctrlUrbSetup.bRequest     = USBVISION_OP_CODE;
diff -puN drivers/media/video/usbvision/usbvision.h~media-video-usbvision-remove-ctrlurblock drivers/media/video/usbvision/usbvision.h
--- a/drivers/media/video/usbvision/usbvision.h~media-video-usbvision-remove-ctrlurblock
+++ a/drivers/media/video/usbvision/usbvision.h
@@ -370,7 +370,6 @@ struct usb_usbvision {
 	int ctrlUrbBusy;
 	struct usb_ctrlrequest ctrlUrbSetup;
 	wait_queue_head_t ctrlUrb_wq;					// Processes waiting
-	struct semaphore ctrlUrbLock;
 
 	/* configuration part */
 	int have_tuner;
diff -puN drivers/media/video/usbvision/usbvision-video.c~media-video-usbvision-remove-ctrlurblock drivers/media/video/usbvision/usbvision-video.c
--- a/drivers/media/video/usbvision/usbvision-video.c~media-video-usbvision-remove-ctrlurblock
+++ a/drivers/media/video/usbvision/usbvision-video.c
@@ -1651,7 +1651,6 @@ static struct usb_usbvision *usbvision_a
 		goto err_exit;
 	}
 	init_waitqueue_head(&usbvision->ctrlUrb_wq);
-	init_MUTEX(&usbvision->ctrlUrbLock);	/* to 1 == available */
 
 	usbvision_init_powerOffTimer(usbvision);
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

media-video-usbvision-add-mutex_unlock-to-error-paths.patch
media-video-usbvision-add-mutex_unlock-to-error-paths-fix.patch
media-video-usbvision-remove-ctrlurblock.patch
usb-testing-driver-dont-free-a-locked-mutex.patch
mcheck-mce_64-mce_read_sem-to-mutex.patch
drivers-char-tty_ioc-remove-pty_sem.patch
drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
docs-kernel-locking-convert-semaphore-references.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch

From: akpm@linux-foundation.org
Subject: - media-video-usbvision-add-mutex_unlock-to-error-paths.patch removed from -mm tree
Date: Thu, 13 Dec 2007 15:32:22 -0800
Message-ID: <200712132332.lBDNWMci023959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47783 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757501AbXLMXdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 18:33:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     media: video: usbvision: add mutex_unlock() to error paths
has been removed from the -mm tree.  Its filename was
     media-video-usbvision-add-mutex_unlock-to-error-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: media: video: usbvision: add mutex_unlock() to error paths
From: Daniel Walker <dwalker@mvista.com>

There are a few error paths which don't unlock the usbvision->lock.

So I've added mutex_unlock() calls to fix those paths.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/usbvision/usbvision-video.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/media/video/usbvision/usbvision-video.c~media-video-usbvision-add-mutex_unlock-to-error-paths drivers/media/video/usbvision/usbvision-video.c
--- a/drivers/media/video/usbvision/usbvision-video.c~media-video-usbvision-add-mutex_unlock-to-error-paths
+++ a/drivers/media/video/usbvision/usbvision-video.c
@@ -1290,6 +1290,7 @@ static int usbvision_radio_open(struct i
 		errCode = usbvision_set_alternate(usbvision);
 		if (errCode < 0) {
 			usbvision->last_error = errCode;
+			mutex_unlock(&usbvision->lock);
 			return -EBUSY;
 		}
 
@@ -1807,6 +1808,7 @@ static int __devinit usbvision_probe(str
 					      usbvision->num_alt,GFP_KERNEL);
 	if (usbvision->alt_max_pkt_size == NULL) {
 		err("usbvision: out of memory!\n");
+		mutex_unlock(&usbvision->lock);
 		return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

git-dvb.patch
usb-testing-driver-dont-free-a-locked-mutex.patch
mcheck-mce_64-mce_read_sem-to-mutex.patch
drivers-char-tty_ioc-remove-pty_sem.patch
drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
docs-kernel-locking-convert-semaphore-references.patch
stopmachine-semaphore-to-mutex.patch
stopmachine-semaphore-to-mutex-fix.patch
amiga-serial-driver-port_write_mutex-fixup.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch

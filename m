From: akpm@linux-foundation.org
Subject: + drivers-usb-misc-iowarriorc-null-dereference.patch added to -mm tree
Date: Mon, 19 Mar 2007 23:32:26 -0800
Message-ID: <200703200732.l2K7WQeP028499@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51619 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339AbXCTHiu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Mar 2007 03:38:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oneukum@suse.de, bunk@stusta.de, greg@kroah.com


The patch titled
     drivers/usb/misc/iowarrior.c: NULL dereference
has been added to the -mm tree.  Its filename is
     drivers-usb-misc-iowarriorc-null-dereference.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/usb/misc/iowarrior.c: NULL dereference
From: Oliver Neukum <oneukum@suse.de>

Fix an oops upon allocation failures.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/iowarrior.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/usb/misc/iowarrior.c~drivers-usb-misc-iowarriorc-null-dereference drivers/usb/misc/iowarrior.c
--- a/drivers/usb/misc/iowarrior.c~drivers-usb-misc-iowarriorc-null-dereference
+++ a/drivers/usb/misc/iowarrior.c
@@ -417,14 +417,14 @@ static ssize_t iowarrior_write(struct fi
 		if (!int_out_urb) {
 			retval = -ENOMEM;
 			dbg("%s Unable to allocate urb ", __func__);
-			goto error;
+			goto error_no_urb;
 		}
 		buf = usb_buffer_alloc(dev->udev, dev->report_size,
 				       GFP_KERNEL, &int_out_urb->transfer_dma);
 		if (!buf) {
 			retval = -ENOMEM;
 			dbg("%s Unable to allocate buffer ", __func__);
-			goto error;
+			goto error_no_buffer;
 		}
 		usb_fill_int_urb(int_out_urb, dev->udev,
 				 usb_sndintpipe(dev->udev,
@@ -459,7 +459,9 @@ static ssize_t iowarrior_write(struct fi
 error:
 	usb_buffer_free(dev->udev, dev->report_size, buf,
 			int_out_urb->transfer_dma);
+error_no_buffer:
 	usb_free_urb(int_out_urb);
+error_no_urb:
 	atomic_dec(&dev->write_busy);
 	wake_up_interruptible(&dev->write_wait);
 exit:
_

Patches currently in -mm which might be from oneukum@suse.de are

agp-prevent-probe-collision-of-sis-agp-and-amd64_agp.patch
git-dvb.patch
drivers-usb-misc-iowarriorc-null-dereference.patch

From: akpm@osdl.org
Subject: + drivers-media-video-cpia2-cpia2_usbc-free.patch added to -mm tree
Date: Thu, 07 Dec 2006 12:20:50 -0800
Message-ID: <200612072020.kB7KKoph024284@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35670 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163277AbWLGUVA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 15:21:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amit2030@gmail.com, mchehab@infradead.org


The patch titled
     drivers/media/video/cpia2/cpia2_usb.c: fix error-path leak
has been added to the -mm tree.  Its filename is
     drivers-media-video-cpia2-cpia2_usbc-free.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/media/video/cpia2/cpia2_usb.c: fix error-path leak
From: Amit Choudhary <amit2030@gmail.com>

Free previously allocated memory (in array elements) if kmalloc() returns
NULL in submit_urbs().

Signed-off-by: Amit Choudhary <amit2030@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/cpia2/cpia2_usb.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN drivers/media/video/cpia2/cpia2_usb.c~drivers-media-video-cpia2-cpia2_usbc-free drivers/media/video/cpia2/cpia2_usb.c
--- a/drivers/media/video/cpia2/cpia2_usb.c~drivers-media-video-cpia2-cpia2_usbc-free
+++ a/drivers/media/video/cpia2/cpia2_usb.c
@@ -640,6 +640,10 @@ static int submit_urbs(struct camera_dat
 		cam->sbuf[i].data =
 		    kmalloc(FRAMES_PER_DESC * FRAME_SIZE_PER_DESC, GFP_KERNEL);
 		if (!cam->sbuf[i].data) {
+			while (--i >= 0) {
+				kfree(cam->sbuf[i].data);
+				cam->sbuf[i].data = NULL;
+			}
 			return -ENOMEM;
 		}
 	}
_

Patches currently in -mm which might be from amit2030@gmail.com are

git-dvb.patch
drivers-media-video-cpia2-cpia2_usbc-free.patch


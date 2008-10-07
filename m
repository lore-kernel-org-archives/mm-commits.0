From: akpm@linux-foundation.org
Subject: - fix-buffer-overflow-in-uvc-video.patch removed from -mm tree
Date: Tue, 07 Oct 2008 16:39:46 -0700
Message-ID: <200810072339.m97Ndk0L009586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758064AbYJGXkD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 19:40:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suckfish@ihug.co.nz, duck@freescale.com, hverkuil@xs4all.nl, laurent.pinchart@skynet.be, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     fix buffer overflow in uvc-video
has been removed from the -mm tree.  Its filename was
     fix-buffer-overflow-in-uvc-video.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix buffer overflow in uvc-video
From: Ralph Loader <suckfish@ihug.co.nz>

There is a buffer overflow in drivers/media/video/uvc/uvc_ctrl.c:

INFO: 0xf2c5ce08-0xf2c5ce0b. First byte 0xa1 instead of 0xcc
INFO: Allocated in uvc_query_v4l2_ctrl+0x3c/0x239 [uvcvideo] age=13 cpu=1 pid=4975
...

A fixed size 8-byte buffer is allocated, and a variable size field is read
into it; there is no particular bound on the size of the field (it is
dependent on hardware and configuration) and it can overflow [also
verified by inserting printk's.]

The patch attempts to size the buffer to the correctly.

Cc: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Bruce Schmid <duck@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/uvc/uvc_ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/uvc/uvc_ctrl.c~fix-buffer-overflow-in-uvc-video drivers/media/video/uvc/uvc_ctrl.c
--- a/drivers/media/video/uvc/uvc_ctrl.c~fix-buffer-overflow-in-uvc-video
+++ a/drivers/media/video/uvc/uvc_ctrl.c
@@ -592,7 +592,7 @@ int uvc_query_v4l2_ctrl(struct uvc_video
 	if (ctrl == NULL)
 		return -EINVAL;
 
-	data = kmalloc(8, GFP_KERNEL);
+	data = kmalloc(ctrl->info->size, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from suckfish@ihug.co.nz are



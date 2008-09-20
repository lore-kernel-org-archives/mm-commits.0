From: akpm@linux-foundation.org
Subject: + fix-buffer-overflow-in-uvc-video.patch added to -mm tree
Date: Sat, 20 Sep 2008 15:17:27 -0700
Message-ID: <200809202217.m8KMHR2j026766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289AbYITWRv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 20 Sep 2008 18:17:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suckfish@ihug.co.nz, duck@freescale.com, hverkuil@xs4all.nl, laurent.pinchart@skynet.be, mchehab@infradead.org


The patch titled
     fix buffer overflow in uvc-video
has been added to the -mm tree.  Its filename is
     fix-buffer-overflow-in-uvc-video.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

fix-buffer-overflow-in-uvc-video.patch


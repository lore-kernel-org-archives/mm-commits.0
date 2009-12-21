From: akpm@linux-foundation.org
Subject: [merged] drivers-usb-gadget-use-err_ptr-is_err.patch removed from -mm tree
Date: Mon, 21 Dec 2009 12:25:15 -0800
Message-ID: <200912212025.nBLKPFZH027207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756811AbZLUU0F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 15:26:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, dbrownell@users.sourceforge.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/gadget: use ERR_PTR/IS_ERR
has been removed from the -mm tree.  Its filename was
     drivers-usb-gadget-use-err_ptr-is_err.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/gadget: use ERR_PTR/IS_ERR
From: Julia Lawall <julia@diku.dk>

Use ERR_PTR and IS_ERR rather than mixing integers and pointers.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *E;
@@

* E < 0
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/f_audio.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/usb/gadget/f_audio.c~drivers-usb-gadget-use-err_ptr-is_err drivers/usb/gadget/f_audio.c
--- a/drivers/usb/gadget/f_audio.c~drivers-usb-gadget-use-err_ptr-is_err
+++ a/drivers/usb/gadget/f_audio.c
@@ -252,12 +252,12 @@ static struct f_audio_buf *f_audio_buffe
 
 	copy_buf = kzalloc(sizeof *copy_buf, GFP_ATOMIC);
 	if (!copy_buf)
-		return (struct f_audio_buf *)-ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	copy_buf->buf = kzalloc(buf_size, GFP_ATOMIC);
 	if (!copy_buf->buf) {
 		kfree(copy_buf);
-		return (struct f_audio_buf *)-ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	return copy_buf;
@@ -332,7 +332,7 @@ static int f_audio_out_ep_complete(struc
 		list_add_tail(&copy_buf->list, &audio->play_queue);
 		schedule_work(&audio->playback_work);
 		copy_buf = f_audio_buffer_alloc(audio_buf_size);
-		if (copy_buf < 0)
+		if (IS_ERR(copy_buf))
 			return -ENOMEM;
 	}
 
@@ -576,6 +576,8 @@ static int f_audio_set_alt(struct usb_fu
 			usb_ep_enable(out_ep, audio->out_desc);
 			out_ep->driver_data = audio;
 			audio->copy_buf = f_audio_buffer_alloc(audio_buf_size);
+			if (IS_ERR(audio->copy_buf))
+				return -ENOMEM;
 
 			/*
 			 * allocate a bunch of read buffers
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-media-video-move-dereference-after-null-test.patch
arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer.patch
drivers-isdn-eliminate-duplicated-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-usb-wusbcore-introduce-missing-usb_free_urb.patch
drivers-usb-correct-code-taking-the-size-of-a-pointer.patch
drivers-edac-introduce-missing-kfree.patch


From: akpm@linux-foundation.org
Subject: + drivers-usb-gadget-use-err_ptr-is_err.patch added to -mm tree
Date: Wed, 16 Dec 2009 14:32:25 -0800
Message-ID: <200912162232.nBGMWPdf018815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934497AbZLPWdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 17:33:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, dbrownell@users.sourceforge.net, greg@kroah.com


The patch titled
     drivers/usb/gadget: use ERR_PTR/IS_ERR
has been added to the -mm tree.  Its filename is
     drivers-usb-gadget-use-err_ptr-is_err.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-video-via-viafbdevc-correct-code-taking-the-size-of-a-pointer.patch
linux-next.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-isdn-eliminate-duplicated-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-usb-wusbcore-introduce-missing-usb_free_urb.patch
drivers-usb-gadget-use-err_ptr-is_err.patch
drivers-edac-introduce-missing-kfree.patch


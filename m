From: akpm@linux-foundation.org
Subject: + drivers-usb-correct-code-taking-the-size-of-a-pointer.patch added to -mm tree
Date: Wed, 16 Dec 2009 15:53:53 -0800
Message-ID: <200912162353.nBGNrrSc023003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757692AbZLPXyH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 18:54:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, david.vrabel@csr.com


The patch titled
     drivers/usb: correct code taking the size of a pointer
has been added to the -mm tree.  Its filename is
     drivers-usb-correct-code-taking-the-size-of-a-pointer.patch

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
Subject: drivers/usb: correct code taking the size of a pointer
From: Julia Lawall <julia@diku.dk>

sizeof(chid) is just the size of the pointer.  Change it to the size of the
referenced structure.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
expression f;
type T;
@@

*f(...,(T)x,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: David Vrabel <david.vrabel@csr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/wusbcore/mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/wusbcore/mmc.c~drivers-usb-correct-code-taking-the-size-of-a-pointer drivers/usb/wusbcore/mmc.c
--- a/drivers/usb/wusbcore/mmc.c~drivers-usb-correct-code-taking-the-size-of-a-pointer
+++ a/drivers/usb/wusbcore/mmc.c
@@ -263,7 +263,7 @@ int wusbhc_chid_set(struct wusbhc *wusbh
 {
 	int result = 0;
 
-	if (memcmp(chid, &wusb_ckhdid_zero, sizeof(chid)) == 0)
+	if (memcmp(chid, &wusb_ckhdid_zero, sizeof(*chid)) == 0)
 		chid = NULL;
 
 	mutex_lock(&wusbhc->mutex);
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
arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer.patch
drivers-usb-correct-code-taking-the-size-of-a-pointer.patch


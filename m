From: akpm@linux-foundation.org
Subject: + drivers-video-via-viafbdevc-correct-code-taking-the-size-of-a-pointer.patch added to -mm tree
Date: Wed, 16 Dec 2009 13:47:23 -0800
Message-ID: <200912162147.nBGLlNeL016721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757013AbZLPVrb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 16:47:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     drivers/video/via/viafbdev.c: correct code taking the size of a pointer
has been added to the -mm tree.  Its filename is
     drivers-video-via-viafbdevc-correct-code-taking-the-size-of-a-pointer.patch

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
Subject: drivers/video/via/viafbdev.c: correct code taking the size of a pointer
From: Julia Lawall <julia@diku.dk>

sizeof(viafb_gamma_table) is just the size of the pointer.  This is changed
to the size used when calling kmalloc to initialize the pointer.

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
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/via/viafbdev.c~drivers-video-via-viafbdevc-correct-code-taking-the-size-of-a-pointer drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~drivers-video-via-viafbdevc-correct-code-taking-the-size-of-a-pointer
+++ a/drivers/video/via/viafbdev.c
@@ -680,7 +680,7 @@ static int viafb_ioctl(struct fb_info *i
 		if (!viafb_gamma_table)
 			return -ENOMEM;
 		if (copy_from_user(viafb_gamma_table, argp,
-				sizeof(viafb_gamma_table))) {
+				256 * sizeof(u32))) {
 			kfree(viafb_gamma_table);
 			return -EFAULT;
 		}
@@ -694,7 +694,7 @@ static int viafb_ioctl(struct fb_info *i
 			return -ENOMEM;
 		viafb_get_gamma_table(viafb_gamma_table);
 		if (copy_to_user(argp, viafb_gamma_table,
-			sizeof(viafb_gamma_table))) {
+			256 * sizeof(u32))) {
 			kfree(viafb_gamma_table);
 			return -EFAULT;
 		}
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
drivers-edac-introduce-missing-kfree.patch


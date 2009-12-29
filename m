From: akpm@linux-foundation.org
Subject: [merged] drivers-usb-correct-code-taking-the-size-of-a-pointer.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:33:29 -0800
Message-ID: <200912292133.nBTLXT22008710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835AbZL2Vdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, david.vrabel@csr.com, mm-commits@vger.kernel.org


The patch titled
     drivers/usb: correct code taking the size of a pointer
has been removed from the -mm tree.  Its filename was
     drivers-usb-correct-code-taking-the-size-of-a-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
drivers-media-video-move-dereference-after-null-test.patch
arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer.patch
drivers-isdn-eliminate-duplicated-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-edac-introduce-missing-kfree.patch


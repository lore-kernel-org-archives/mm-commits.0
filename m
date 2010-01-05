From: akpm@linux-foundation.org
Subject: + drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch added to -mm tree
Date: Mon, 04 Jan 2010 16:25:18 -0800
Message-ID: <201001050025.o050PI7k027482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965Ab0AEAZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 19:25:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, gregkh@suse.de, mchehab@redhat.com


The patch titled
     drivers/staging/tm6000/tm6000-video.c: correct NULL test
has been added to the -mm tree.  Its filename is
     drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch

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
Subject: drivers/staging/tm6000/tm6000-video.c: correct NULL test
From: Julia Lawall <julia@diku.dk>

Test the just-allocated value for NULL rather than some other value.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,y;
statement S;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
(
if ((x) == NULL) S
|
if (
-   y
+   x
       == NULL)
 S
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/tm6000/tm6000-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/tm6000/tm6000-video.c~drivers-staging-tm6000-tm6000-videoc-correct-null-test drivers/staging/tm6000/tm6000-video.c
--- a/drivers/staging/tm6000/tm6000-video.c~drivers-staging-tm6000-tm6000-videoc-correct-null-test
+++ a/drivers/staging/tm6000/tm6000-video.c
@@ -642,7 +642,7 @@ static int tm6000_prepare_isoc(struct tm
 
 	dev->isoc_ctl.transfer_buffer = kmalloc(sizeof(void *)*num_bufs,
 				   GFP_KERNEL);
-	if (!dev->isoc_ctl.urb) {
+	if (!dev->isoc_ctl.transfer_buffer) {
 		tm6000_err("cannot allocate memory for usbtransfer\n");
 		kfree(dev->isoc_ctl.urb);
 		return -ENOMEM;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-scsi-sesc-eliminate-double-free.patch
kernel-credc-use-kmem_cache_free.patch
drivers-media-video-move-dereference-after-null-test.patch
arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer.patch
drivers-isdn-eliminate-duplicated-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-edac-introduce-missing-kfree.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-block-drbd-drbd_receiverc-correct-null-test.patch
drivers-gpu-drm-nouveau-nouveau_grctxc-correct-null-test.patch
drivers-net-can-mcp251xc-correct-null-test.patch
drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch


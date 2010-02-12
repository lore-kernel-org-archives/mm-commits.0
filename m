From: akpm@linux-foundation.org
Subject: [merged] drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch removed from -mm tree
Date: Fri, 12 Feb 2010 11:03:42 -0800
Message-ID: <201002121903.o1CJ3gGL021136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757244Ab0BLTGw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 14:06:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, gregkh@suse.de, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     drivers/staging/tm6000/tm6000-video.c: correct NULL test
has been removed from the -mm tree.  Its filename was
     drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
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
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
net-ipv4-correct-the-size-argument-to-kzalloc.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-misc-iwmc3200top-mainc-eliminate-useless-code.patch
rtc-at91sam9-correct-size-given-to-memset.patch
drivers-edac-introduce-missing-kfree.patch
drivers-char-mmtimerc-eliminate-useless-code.patch


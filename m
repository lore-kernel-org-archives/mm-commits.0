From: akpm@linux-foundation.org
Subject: [merged] drivers-staging-go7007-s2250-loaderc-eliminate-useless-code.patch removed from -mm tree
Date: Fri, 29 Jan 2010 12:16:59 -0800
Message-ID: <201001292017.o0TKGxX9003273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754808Ab0A2URr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 15:17:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, gregkh@suse.de, hverkuil@xs4all.nl, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     drivers/staging/go7007/s2250-loader.c: eliminate useless code
has been removed from the -mm tree.  Its filename was
     drivers-staging-go7007-s2250-loaderc-eliminate-useless-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/staging/go7007/s2250-loader.c: eliminate useless code
From: Julia Lawall <julia@diku.dk>

The variable s is initialized twice to the same (side effect-free)
expression.  Drop one initialization.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@forall@
idexpression *x;
identifier f!=ERR_PTR;
@@

x = f(...)
... when != x
(
x = f(...,<+...x...+>,...)
|
* x = f(...)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/go7007/s2250-loader.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/go7007/s2250-loader.c~drivers-staging-go7007-s2250-loaderc-eliminate-useless-code drivers/staging/go7007/s2250-loader.c
--- a/drivers/staging/go7007/s2250-loader.c~drivers-staging-go7007-s2250-loaderc-eliminate-useless-code
+++ a/drivers/staging/go7007/s2250-loader.c
@@ -139,7 +139,7 @@ failed2:
 
 static void s2250loader_disconnect(struct usb_interface *interface)
 {
-	pdevice_extension_t s = usb_get_intfdata(interface);
+	pdevice_extension_t s;
 	printk(KERN_INFO "s2250: disconnect\n");
 	lock_kernel();
 	s = usb_get_intfdata(interface);
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-scsi-sesc-eliminate-double-free.patch
kernel-credc-use-kmem_cache_free.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-gpu-drm-nouveau-nouveau_grctxc-correct-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
net-ipv4-correct-the-size-argument-to-kzalloc.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch
drivers-misc-iwmc3200top-mainc-eliminate-useless-code.patch
rtc-at91sam9-correct-size-given-to-memset.patch
drivers-edac-introduce-missing-kfree.patch
drivers-char-mmtimerc-eliminate-useless-code.patch


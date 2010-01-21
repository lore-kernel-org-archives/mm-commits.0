From: akpm@linux-foundation.org
Subject: [alternative-merged] drivers-usb-correct-the-size-argument-to-kzalloc.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:25:46 -0800
Message-ID: <201001212125.o0LLPkSp030492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755284Ab0AUV0M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:26:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, avorontsov@ru.mvista.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/host/fhci-hcd.c: correct the size argument to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-usb-correct-the-size-argument-to-kzalloc.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/host/fhci-hcd.c: correct the size argument to kzalloc
From: Julia Lawall <julia@diku.dk>

urb_priv->tds has type struct td **, not struct td *, so the elements of
the array should have pointer type, not structure type.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@disable sizeof_type_expr@
type T;
T **x;
@@

  x =
  <+...sizeof(
- T
+ *x
  )...+>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/fhci-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/host/fhci-hcd.c~drivers-usb-correct-the-size-argument-to-kzalloc drivers/usb/host/fhci-hcd.c
--- a/drivers/usb/host/fhci-hcd.c~drivers-usb-correct-the-size-argument-to-kzalloc
+++ a/drivers/usb/host/fhci-hcd.c
@@ -432,7 +432,7 @@ static int fhci_urb_enqueue(struct usb_h
 		return -ENOMEM;
 
 	/* allocate the private part of the URB */
-	urb_priv->tds = kzalloc(size * sizeof(struct td), mem_flags);
+	urb_priv->tds = kzalloc(size * sizeof(*urb_priv->tds), mem_flags);
 	if (!urb_priv->tds) {
 		kfree(urb_priv);
 		return -ENOMEM;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
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
drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch
drivers-usb-correct-the-size-argument-to-kzalloc.patch
drivers-edac-introduce-missing-kfree.patch


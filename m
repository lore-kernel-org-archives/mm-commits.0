From: akpm@linux-foundation.org
Subject: [merged] drivers-usb-gadget-s3c-hsotgc-add-missing-unlock.patch removed from -mm tree
Date: Thu, 29 Apr 2010 13:56:46 -0400
Message-ID: <201004292058.o3TKwJfV011781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932756Ab0D3RJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 13:09:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, dbrownell@users.sourceforge.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/gadget/s3c-hsotg.c: add missing unlock
has been removed from the -mm tree.  Its filename was
     drivers-usb-gadget-s3c-hsotgc-add-missing-unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/gadget/s3c-hsotg.c: add missing unlock
From: Julia Lawall <julia@diku.dk>

In an error handling case the lock is not unlocked.  The return is
converted to a goto, to share the unlock at the end of the function.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E1;
identifier f;
@@

f (...) { <+...
* spin_lock_irqsave (E1,...);
... when != E1
* return ...;
...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/s3c-hsotg.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/usb/gadget/s3c-hsotg.c~drivers-usb-gadget-s3c-hsotgc-add-missing-unlock drivers/usb/gadget/s3c-hsotg.c
--- a/drivers/usb/gadget/s3c-hsotg.c~drivers-usb-gadget-s3c-hsotgc-add-missing-unlock
+++ a/drivers/usb/gadget/s3c-hsotg.c
@@ -2145,6 +2145,7 @@ static int s3c_hsotg_ep_enable(struct us
 	u32 epctrl;
 	u32 mps;
 	int dir_in;
+	int ret = 0;
 
 	dev_dbg(hsotg->dev,
 		"%s: ep %s: a 0x%02x, attr 0x%02x, mps 0x%04x, intr %d\n",
@@ -2196,7 +2197,8 @@ static int s3c_hsotg_ep_enable(struct us
 	switch (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
 	case USB_ENDPOINT_XFER_ISOC:
 		dev_err(hsotg->dev, "no current ISOC support\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 
 	case USB_ENDPOINT_XFER_BULK:
 		epctrl |= S3C_DxEPCTL_EPType_Bulk;
@@ -2235,8 +2237,9 @@ static int s3c_hsotg_ep_enable(struct us
 	/* enable the endpoint interrupt */
 	s3c_hsotg_ctrl_epint(hsotg, index, dir_in, 1);
 
+out:
 	spin_unlock_irqrestore(&hs_ep->lock, flags);
-	return 0;
+	return ret;
 }
 
 static int s3c_hsotg_ep_disable(struct usb_ep *ep)
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-serial-pmac_zilogc-add-missing-unlock.patch
drivers-acpi-use-kasprintf.patch
arch-x86-pci-use-kasprintf.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-media-video-avoid-null-dereference.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-char-ppdevc-use-kasprintf.patch
drivers-edac-introduce-missing-kfree.patch


From: akpm@linux-foundation.org
Subject: + drivers-usb-gadget-s3c-hsotgc-add-missing-unlock.patch added to -mm tree
Date: Thu, 01 Apr 2010 12:42:49 -0700
Message-ID: <201004011942.o31Jgosf005137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754773Ab0DATnB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 15:43:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, dbrownell@users.sourceforge.net, greg@kroah.com


The patch titled
     drivers/usb/gadget/s3c-hsotg.c: add missing unlock
has been added to the -mm tree.  Its filename is
     drivers-usb-gadget-s3c-hsotgc-add-missing-unlock.patch

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

linux-next.patch
arch-powerpc-kernel-vioc-add-missing-unlock.patch
drivers-acpi-use-kasprintf.patch
drivers-acpi-use-kasprintf-fix.patch
arch-x86-pci-use-kasprintf.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
arch-powerpc-platforms-pseries-use-kasprintf.patch
drivers-media-video-avoid-null-dereference.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-char-ppdevc-use-kasprintf.patch
drivers-edac-introduce-missing-kfree.patch
drivers-char-amiserialc-add-missing-local_irq_restore.patch
drivers-gpio-timbgpioc-add-missing-unlock.patch
drivers-macintosh-macio-adbc-add-missing-unlock.patch
drivers-scsi-qla2xxx-qla_attrc-add-missing-unlock.patch
drivers-serial-pmac_zilogc-add-missing-unlock.patch
drivers-usb-gadget-s3c-hsotgc-add-missing-unlock.patch


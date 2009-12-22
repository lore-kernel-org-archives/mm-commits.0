From: akpm@linux-foundation.org
Subject: [alternative-merged] drivers-usb-wusbcore-introduce-missing-usb_free_urb.patch removed from -mm tree
Date: Mon, 21 Dec 2009 18:12:31 -0800
Message-ID: <200912220212.nBM2CVuX009992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199AbZLVCMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 21:12:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/wusbcore: introduce missing usb_free_urb
has been removed from the -mm tree.  Its filename was
     drivers-usb-wusbcore-introduce-missing-usb_free_urb.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/wusbcore: introduce missing usb_free_urb
From: Julia Lawall <julia@diku.dk>

Error handling code following a usb_alloc_urb should free the allocated data.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = usb_alloc_urb(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s alloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/wusbcore/devconnect.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/usb/wusbcore/devconnect.c~drivers-usb-wusbcore-introduce-missing-usb_free_urb drivers/usb/wusbcore/devconnect.c
--- a/drivers/usb/wusbcore/devconnect.c~drivers-usb-wusbcore-introduce-missing-usb_free_urb
+++ a/drivers/usb/wusbcore/devconnect.c
@@ -123,7 +123,7 @@ static struct wusb_dev *wusb_dev_alloc(s
 
 	req = kmalloc(sizeof(*req), GFP_KERNEL);
 	if (req == NULL)
-		goto err;
+		goto err2;
 	wusb_dev->set_gtk_req = req;
 
 	req->bRequestType = USB_DIR_OUT | USB_TYPE_STANDARD | USB_RECIP_DEVICE;
@@ -133,6 +133,8 @@ static struct wusb_dev *wusb_dev_alloc(s
 	req->wLength = cpu_to_le16(wusbhc->gtk.descr.bLength);
 
 	return wusb_dev;
+err2:
+	usb_free_urb(urb);
 err:
 	wusb_dev_free(wusb_dev);
 	return NULL;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-media-video-move-dereference-after-null-test.patch
arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer.patch
drivers-isdn-eliminate-duplicated-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-usb-wusbcore-introduce-missing-usb_free_urb.patch
drivers-usb-correct-code-taking-the-size-of-a-pointer.patch
drivers-edac-introduce-missing-kfree.patch


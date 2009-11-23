From: akpm@linux-foundation.org
Subject: + drivers-usb-wusbcore-introduce-missing-usb_free_urb.patch added to -mm tree
Date: Mon, 23 Nov 2009 15:47:42 -0800
Message-ID: <200911232347.nANNlgwm007707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756829AbZKWXsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 18:48:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, greg@kroah.com


The patch titled
     drivers/usb/wusbcore: introduce missing usb_free_urb
has been added to the -mm tree.  Its filename is
     drivers-usb-wusbcore-introduce-missing-usb_free_urb.patch

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
@@ -122,7 +122,7 @@ static struct wusb_dev *wusb_dev_alloc(s
 
 	req = kmalloc(sizeof(struct usb_ctrlrequest), GFP_KERNEL);
 	if (req == NULL)
-		goto err;
+		goto err2;
 
 	req->bRequestType = USB_DIR_OUT | USB_TYPE_STANDARD | USB_RECIP_DEVICE;
 	req->bRequest = USB_REQ_SET_DESCRIPTOR;
@@ -134,6 +134,8 @@ static struct wusb_dev *wusb_dev_alloc(s
 	wusb_dev->set_gtk_req = req;
 
 	return wusb_dev;
+err2:
+	usb_free_urb(urb);
 err:
 	wusb_dev_free(wusb_dev);
 	return NULL;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-media-video-introduce-missing-kfree.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-usb-host-xhci-memc-introduce-missing-kfree.patch
drivers-usb-host-ehci-omapc-introduce-missing-kfree.patch
drivers-usb-wusbcore-introduce-missing-usb_free_urb.patch
drivers-cpuidle-move-dereference-after-null-test.patch
drivers-mmc-move-dereference-after-null-test.patch
drivers-video-move-dereference-after-null-test.patch
drivers-char-ipmi-use-kcs_idle_state.patch
drivers-edac-introduce-missing-kfree.patch


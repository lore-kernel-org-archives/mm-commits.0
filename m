From: akpm@linux-foundation.org
Subject: + usb-gadget-dummy_hcdc-fix-nested-switch-statements.patch added to -mm tree
Date: Mon, 17 Mar 2008 14:54:07 -0700
Message-ID: <200803172154.m2HLs725000300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182AbYCQVyV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:54:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: inguin@gmx.de, david-b@pacbell.net, greg@kroah.com


The patch titled
     usb gadget: dummy_hcd.c: fix nested switch statements
has been added to the -mm tree.  Its filename is
     usb-gadget-dummy_hcdc-fix-nested-switch-statements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb gadget: dummy_hcd.c: fix nested switch statements
From: Ingo van Lil <inguin@gmx.de>

Fix a messed up combination of two nested switch statements in
drivers/usb/gadget/dummy_hcd.c.

According to the USB spec (section 5.8.3) the maximum packet size for bulk
endpoints can be 512 for high-speed devices and 8, 16, 32 or 64 for full-speed
devices.  Low-speed devices must not have bulk endpoints.

Signed-off-by: Ingo van Lil <inguin@gmx.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/dummy_hcd.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/usb/gadget/dummy_hcd.c~usb-gadget-dummy_hcdc-fix-nested-switch-statements drivers/usb/gadget/dummy_hcd.c
--- a/drivers/usb/gadget/dummy_hcd.c~usb-gadget-dummy_hcdc-fix-nested-switch-statements
+++ a/drivers/usb/gadget/dummy_hcd.c
@@ -365,16 +365,14 @@ dummy_enable (struct usb_ep *_ep, const 
 		case USB_SPEED_HIGH:
 			if (max == 512)
 				break;
-			/* conserve return statements */
-		default:
-			switch (max) {
-			case 8: case 16: case 32: case 64:
+			goto done;
+		case USB_SPEED_FULL:
+			if (max == 8 || max == 16 || max == 32 || max == 64)
 				/* we'll fake any legal size */
 				break;
-			default:
-		case USB_SPEED_LOW:
-				goto done;
-			}
+			/* save a return statement */
+		default:
+			goto done;
 		}
 		break;
 	case USB_ENDPOINT_XFER_INT:
_

Patches currently in -mm which might be from inguin@gmx.de are

usb-gadget-dummy_hcdc-fix-nested-switch-statements.patch


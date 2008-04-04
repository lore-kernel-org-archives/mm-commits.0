From: akpm@linux-foundation.org
Subject: - usb-gadget-dummy_hcdc-fix-nested-switch-statements.patch removed from -mm tree
Date: Fri, 04 Apr 2008 12:00:31 -0700
Message-ID: <200804041900.m34J0V9E004275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756560AbYDDTAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 15:00:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: inguin@gmx.de, david-b@pacbell.net, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb gadget: dummy_hcd.c: fix nested switch statements
has been removed from the -mm tree.  Its filename was
     usb-gadget-dummy_hcdc-fix-nested-switch-statements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



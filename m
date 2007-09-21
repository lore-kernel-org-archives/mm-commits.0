From: akpm@linux-foundation.org
Subject: + usb-dont-propagate-freeze-or-prethaw-suspends.patch added to -mm tree
Date: Fri, 21 Sep 2007 00:09:07 -0700
Message-ID: <200709210709.l8L797XV023921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44259 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753837AbXIUHJl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 03:09:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, greg@kroah.com


The patch titled
     USB: don't propagate FREEZE or PRETHAW suspends
has been added to the -mm tree.  Its filename is
     usb-dont-propagate-freeze-or-prethaw-suspends.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: USB: don't propagate FREEZE or PRETHAW suspends
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as992) fixes a recently-added bug.  During a FREEZE or PRETHAW
suspend notification, non-root devices don't actually get suspended.  So we
shouldn't tell their parent hubs that they did.

(This code path used to be skipped over, until the FREEZE/PRETHAW test got
moved out of usb_suspend_both() into generic_suspend().)

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/driver.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/usb/core/driver.c~usb-dont-propagate-freeze-or-prethaw-suspends drivers/usb/core/driver.c
--- a/drivers/usb/core/driver.c~usb-dont-propagate-freeze-or-prethaw-suspends
+++ a/drivers/usb/core/driver.c
@@ -1097,7 +1097,12 @@ static int usb_suspend_both(struct usb_d
 			usb_hcd_flush_endpoint(udev, udev->ep_out[i]);
 			usb_hcd_flush_endpoint(udev, udev->ep_in[i]);
 		}
-		if (parent)
+
+		/* If this is just a FREEZE or a PRETHAW, udev might
+		 * not really be suspended.  Only true suspends get
+		 * propagated up the device tree.
+		 */
+		if (parent && udev->state == USB_STATE_SUSPENDED)
 			usb_autosuspend_device(parent);
 	}
 
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

scsi-early-detection-of-medium-not-present-updated.patch
usb-dont-propagate-freeze-or-prethaw-suspends.patch
mystery-usb-fix.patch

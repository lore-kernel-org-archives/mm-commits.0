From: akpm@linux-foundation.org
Subject: + possible-bug-fix-in-ehci-hcd.patch added to -mm tree
Date: Fri, 08 Feb 2008 13:55:03 -0800
Message-ID: <200802082155.m18Lt3JU015310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59815 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476AbYBHVzy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:55:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy@smile.org.ua, david-b@pacbell.net, greg@kroah.com, sgosne@sequans.com, stern@rowland.harvard.edu


The patch titled
     Possible bug fix in ehci-hcd
has been added to the -mm tree.  Its filename is
     possible-bug-fix-in-ehci-hcd.patch

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
Subject: Possible bug fix in ehci-hcd
From: Andy Shevchenko <andy@smile.org.ua>

The Sequans company who produce WiMAX chips provides the USB driver and
kthp addon driver.  However the USB device doesn't work correctly.

Here is more true hack for Sequans SQN11x0 based modem.

P.S. For more details, please, ask Sequans staff (see Signed-off-by lines).

Signed-off-by: Andy Shevchenko <andy@smile.org.ua>
Signed-off-by: Gosne Stephane <sgosne@sequans.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ehci-q.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/usb/host/ehci-q.c~possible-bug-fix-in-ehci-hcd drivers/usb/host/ehci-q.c
--- a/drivers/usb/host/ehci-q.c~possible-bug-fix-in-ehci-hcd
+++ a/drivers/usb/host/ehci-q.c
@@ -756,8 +756,14 @@ qh_make (
 			info1 |= 1 << 14;	/* toggle from qtd */
 			info2 |= (EHCI_TUNE_MULT_HS << 30);
 		} else if (type == PIPE_BULK) {
+			struct usb_device_descriptor *desc = &urb->dev->descriptor;
 			info1 |= (EHCI_TUNE_RL_HS << 28);
-			info1 |= 512 << 16;	/* usb2 fixed maxpacket */
+			/* Special hook for SQN11x0 */
+			if (desc->idVendor == 0x148e && desc->idProduct == 0x0900) {
+				info1 |= max_packet (maxp) << 16;
+			} else {
+				info1 |= 512 << 16;	/* usb2 fixed maxpacket */
+			}
 			info2 |= (EHCI_TUNE_MULT_HS << 30);
 		} else {		/* PIPE_INTERRUPT */
 			info1 |= max_packet (maxp) << 16;
_

Patches currently in -mm which might be from andy@smile.org.ua are

origin.patch
usb-yet-another-dell-wireless-cdma-evdo-modem.patch
possible-bug-fix-in-ehci-hcd.patch

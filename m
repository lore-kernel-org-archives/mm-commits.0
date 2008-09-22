From: akpm@linux-foundation.org
Subject: + usb-g_printer-fix-handling-zero-length-packet.patch added to -mm tree
Date: Mon, 22 Sep 2008 15:41:15 -0700
Message-ID: <200809222241.m8MMfFxF001842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753519AbYIVWly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 18:41:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sangsu@gmail.com, david-b@pacbell.net, greg@kroah.com, stern@rowland.harvard.edu


The patch titled
     USB: g_printer: fix handling zero-length packet
has been added to the -mm tree.  Its filename is
     usb-g_printer-fix-handling-zero-length-packet.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: USB: g_printer: fix handling zero-length packet
From: SangSu Park<sangsu@gmail.com>

g_printer doesn't have to check whether the data size is a multiple of
MaxPacketSize, because device controller driver already make that check.

Signed-off-by: SangSu Park<sangsu@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/printer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/usb/gadget/printer.c~usb-g_printer-fix-handling-zero-length-packet drivers/usb/gadget/printer.c
--- a/drivers/usb/gadget/printer.c~usb-g_printer-fix-handling-zero-length-packet
+++ a/drivers/usb/gadget/printer.c
@@ -1278,8 +1278,7 @@ unknown:
 	/* respond with data transfer before status phase? */
 	if (value >= 0) {
 		req->length = value;
-		req->zero = value < wLength
-				&& (value % gadget->ep0->maxpacket) == 0;
+		req->zero = value < wLength;
 		value = usb_ep_queue(gadget->ep0, req, GFP_ATOMIC);
 		if (value < 0) {
 			DBG(dev, "ep_queue --> %d\n", value);
_

Patches currently in -mm which might be from sangsu@gmail.com are

usb-g_printer-fix-handling-zero-length-packet.patch


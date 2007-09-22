From: akpm@linux-foundation.org
Subject: + usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race-v2-comments-update.patch added to -mm tree
Date: Sat, 22 Sep 2007 10:52:38 -0700
Message-ID: <200709221752.l8MHqc85008257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41553 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754344AbXIVRxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Sep 2007 13:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bene@linutronix.de, david-b@pacbell.net, greg@kroah.com, stable@kernel.org, tglx@linutronix.de


The patch titled
     usb-gadget-ether: Prevent oops caused by error interrupt race -V2 (comments update)
has been added to the -mm tree.  Its filename is
     usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race-v2-comments-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb-gadget-ether: Prevent oops caused by error interrupt race -V2 (comments update)
From: Benedikt Spranger <bene@linutronix.de>

eth_start_xmit() can race against a disconnect interrupt in the gadget
device driver, which nukes all pending request. Right now we access the
pending request list unconditionally and dereference the request list
head itself in such a case, which results in an Oops.

Check whether the list is empty before actually dereferencing
dev->tx_reqs.next. Also add a comment for the second list_empty check
further down to avoid confusion.

Long standing bug. Patch should be applied to stable as well.

Signed-off-by: Benedikt Spranger <bene@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/ether.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/usb/gadget/ether.c~usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race-v2-comments-update drivers/usb/gadget/ether.c
--- a/drivers/usb/gadget/ether.c~usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race-v2-comments-update
+++ a/drivers/usb/gadget/ether.c
@@ -1958,8 +1958,9 @@ static int eth_start_xmit (struct sk_buf
 
 	spin_lock_irqsave(&dev->req_lock, flags);
 	/*
-	 * dev->tx_reqs may be empty due to an error interrupt which
-	 * nuked all requests.
+	 * dev->tx_reqs may be empty. We raced against a disconnect
+	 * interrupt in the gadget device driver, which nuked all
+	 * pending requests.
 	 */
 	if (list_empty(&dev->tx_reqs)) {
 		netif_stop_queue(net);
_

Patches currently in -mm which might be from bene@linutronix.de are

usb-gadget-ether-prevent-oops-caused-by-error-interrupt.patch
usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race-v2-comments-update.patch

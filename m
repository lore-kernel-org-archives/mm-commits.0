From: akpm@linux-foundation.org
Subject: + usb-gadget-ether-prevent-oops-caused-by-error-interrupt.patch added to -mm tree
Date: Fri, 21 Sep 2007 00:02:53 -0700
Message-ID: <200709210702.l8L72rLM023670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43226 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753420AbXIUHEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 03:04:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bene@linutronix.de, david-b@pacbell.net, greg@kroah.com, stable@kernel.org, tglx@linutronix.de


The patch titled
     usb-gadget-ether: Prevent oops caused by error interrupt race
has been added to the -mm tree.  Its filename is
     usb-gadget-ether-prevent-oops-caused-by-error-interrupt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb-gadget-ether: Prevent oops caused by error interrupt race
From: Benedikt Spranger <bene@linutronix.de>

An USB error interrupt (e.g.  disconnect) nukes the pending requests for an
ethernet gadget device asynchronously.  This can race against
eth_start_xmit(), where we end up dereferencing the list head itself.

The nuke code is serialized against eth_start_xmit via dev->req_lock, but
we need to check the list for empty first instead of unconditionally
accessing dev->tx_reqs.next.

This is a long standing bug, which should be fixed in stable as well.

Signed-off-by: Benedikt Spranger <bene@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/ether.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/usb/gadget/ether.c~usb-gadget-ether-prevent-oops-caused-by-error-interrupt drivers/usb/gadget/ether.c
--- a/drivers/usb/gadget/ether.c~usb-gadget-ether-prevent-oops-caused-by-error-interrupt
+++ a/drivers/usb/gadget/ether.c
@@ -1957,8 +1957,20 @@ static int eth_start_xmit (struct sk_buf
 	}
 
 	spin_lock_irqsave(&dev->req_lock, flags);
+	/*
+	 * dev->tx_reqs may be empty due to an error interrupt which
+	 * nuked all requests.
+	 */
+	if (list_empty(&dev->tx_reqs)) {
+		netif_stop_queue(net);
+		spin_unlock_irqrestore(&dev->req_lock, flags);
+		return 1;
+	}
+
 	req = container_of (dev->tx_reqs.next, struct usb_request, list);
 	list_del (&req->list);
+
+	/* last request in list: stop queue */
 	if (list_empty (&dev->tx_reqs))
 		netif_stop_queue (net);
 	spin_unlock_irqrestore(&dev->req_lock, flags);
_

Patches currently in -mm which might be from bene@linutronix.de are

usb-gadget-ether-prevent-oops-caused-by-error-interrupt.patch

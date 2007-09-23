From: akpm@linux-foundation.org
Subject: + usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race.patch added to -mm tree
Date: Sat, 22 Sep 2007 21:20:01 -0700
Message-ID: <200709230420.l8N4K15h027967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48727 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748AbXIWEVV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 23 Sep 2007 00:21:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bene@linutronix.de, dbrownell@users.sourceforge.net, greg@kroah.com, tglx@linutronix.de


The patch titled
     usb-gadget-ether: prevent oops caused by error interrupt race
has been added to the -mm tree.  Its filename is
     usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb-gadget-ether: prevent oops caused by error interrupt race
From: Benedikt Spranger <bene@linutronix.de>

Fix a longstanding race in the Ethernet gadget driver, which can cause an
oops on device disconnect.  The fix is just to make the TX path check
whether its freelist is empty.  That check is otherwise not necessary,
since the queue is always stopped when that list empties (and restarted
when request completion puts an entry back on that freelist).

The race window starts when the network code decides to transmit a packet,
and ends when hard_start_xmit() grabs the freelist lock.  When disconnect()
is called inside that window, it shuts down the TX queue and breaks the
otherwise-solid assumption that packets are never sent through a TX queue
that's stopped.

Signed-off-by: Benedikt Spranger <bene@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/ether.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/usb/gadget/ether.c~usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race drivers/usb/gadget/ether.c
--- a/drivers/usb/gadget/ether.c~usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race
+++ a/drivers/usb/gadget/ether.c
@@ -1957,8 +1957,20 @@ static int eth_start_xmit (struct sk_buf
 	}
 
 	spin_lock_irqsave(&dev->req_lock, flags);
+	/*
+	 * this freelist can be empty if an interrupt triggered disconnect()
+	 * and reconfigured the gadget (shutting down this queue) after the
+	 * network stack decided to xmit but before we got the spinlock.
+	 */
+	if (list_empty(&dev->tx_reqs)) {
+		spin_unlock_irqrestore(&dev->req_lock, flags);
+		return 1;
+	}
+
 	req = container_of (dev->tx_reqs.next, struct usb_request, list);
 	list_del (&req->list);
+
+	/* temporarily stop TX queue when the freelist empties */
 	if (list_empty (&dev->tx_reqs))
 		netif_stop_queue (net);
 	spin_unlock_irqrestore(&dev->req_lock, flags);
_

Patches currently in -mm which might be from bene@linutronix.de are

usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race.patch

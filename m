From: akpm@linux-foundation.org
Subject: - usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:58:24 -0700
Message-ID: <200710051958.l95JwOkn022542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42427 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763175AbXJEUBl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bene@linutronix.de, dbrownell@users.sourceforge.net, greg@kroah.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     usb-gadget-ether: prevent oops caused by error interrupt race
has been removed from the -mm tree.  Its filename was
     usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

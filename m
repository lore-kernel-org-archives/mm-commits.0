From: akpm@linux-foundation.org
Subject: [merged] usb-ftdi_sio-remove-obsolete-comment.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:33:26 -0800
Message-ID: <200912292133.nBTLXQWE008706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbZL2Vdf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhovold@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: ftdi_sio: remove obsolete comment
has been removed from the -mm tree.  Its filename was
     usb-ftdi_sio-remove-obsolete-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: ftdi_sio: remove obsolete comment
From: Johan Hovold <jhovold@gmail.com>

We always push characters to ldisc immediately regardless of
ASYNC_LOW_LATENCY.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ftdi_sio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/usb/serial/ftdi_sio.c~usb-ftdi_sio-remove-obsolete-comment drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~usb-ftdi_sio-remove-obsolete-comment
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -1532,8 +1532,7 @@ static int ftdi_sio_port_probe(struct us
 	kref_init(&priv->kref);
 	spin_lock_init(&priv->tx_lock);
 	init_waitqueue_head(&priv->delta_msr_wait);
-	/* This will push the characters through immediately rather
-	   than queue a task to deliver them */
+
 	priv->flags = ASYNC_LOW_LATENCY;
 
 	if (quirk && quirk->port_probe)
_

Patches currently in -mm which might be from jhovold@gmail.com are

linux-next.patch


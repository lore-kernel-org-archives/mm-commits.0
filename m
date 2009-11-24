From: akpm@linux-foundation.org
Subject: + usb-ftdi_sio-remove-obsolete-comment.patch added to -mm tree
Date: Tue, 24 Nov 2009 12:38:30 -0800
Message-ID: <200911242038.nAOKcUMY018549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932823AbZKXUjE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 15:39:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jhovold@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     usb: ftdi_sio: remove obsolete comment
has been added to the -mm tree.  Its filename is
     usb-ftdi_sio-remove-obsolete-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1518,8 +1518,7 @@ static int ftdi_sio_port_probe(struct us
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

usb-ftdi_sio-fix-error-message-on-close.patch
usb-ftdi_sio-remove-obsolete-comment.patch


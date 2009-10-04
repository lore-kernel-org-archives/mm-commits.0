From: akpm@linux-foundation.org
Subject: + usb-digi_acceleport-fix-broken-unthrottle.patch added to -mm tree
Date: Sun, 04 Oct 2009 14:00:59 -0700
Message-ID: <200910042100.n94L0xBs013208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbZJDVBr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 4 Oct 2009 17:01:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jhovold@gmail.com, greg@kroah.com, oliver@neukum.org, rjw@sisk.pl


The patch titled
     usb: digi_acceleport: fix broken unthrottle
has been added to the -mm tree.  Its filename is
     usb-digi_acceleport-fix-broken-unthrottle.patch

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
Subject: usb: digi_acceleport: fix broken unthrottle
From: Johan Hovold <jhovold@gmail.com>

Fix a regression introduced in 39892da44b21b5362eb848ca424d73a25ccc488f
("USB: Digi AccelePort adapted to new tty buffering").

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Oliver Neukum <oliver@neukum.org>
Cc: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/digi_acceleport.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/usb/serial/digi_acceleport.c~usb-digi_acceleport-fix-broken-unthrottle drivers/usb/serial/digi_acceleport.c
--- a/drivers/usb/serial/digi_acceleport.c~usb-digi_acceleport-fix-broken-unthrottle
+++ a/drivers/usb/serial/digi_acceleport.c
@@ -898,16 +898,16 @@ static void digi_rx_unthrottle(struct tt
 
 	spin_lock_irqsave(&priv->dp_port_lock, flags);
 
-	/* turn throttle off */
-	priv->dp_throttled = 0;
-	priv->dp_throttle_restart = 0;

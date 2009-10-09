From: akpm@linux-foundation.org
Subject: [merged] usb-digi_acceleport-fix-broken-unthrottle.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:05:48 -0700
Message-ID: <200910092205.n99M5mLf022166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934703AbZJIWGh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:06:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhovold@gmail.com, greg@kroah.com, oliver@neukum.org, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     usb: digi_acceleport: fix broken unthrottle
has been removed from the -mm tree.  Its filename was
     usb-digi_acceleport-fix-broken-unthrottle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

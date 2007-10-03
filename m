From: akpm@linux-foundation.org
Subject: + ircomm-discovery-indication-simplification.patch added to -mm tree
Date: Wed, 03 Oct 2007 14:22:30 -0700
Message-ID: <200710032122.l93LMUOr009346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753844AbXJCVWo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 17:22:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ryanr23@gmail.com, samuel@sortiz.org


The patch titled
     IrCOMM discovery indication simplification
has been added to the -mm tree.  Its filename is
     ircomm-discovery-indication-simplification.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IrCOMM discovery indication simplification
From: Ryan Reading <ryanr23@gmail.com>

Every IrCOMM socket is registered with the discovery subsystem, so we don't
need to loop over all of them for every discovery event. We just need to
do it for the registered IrCOMM socket.

Signed-off-by: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN net/irda/ircomm/ircomm_tty_attach.c~ircomm-discovery-indication-simplification net/irda/ircomm/ircomm_tty_attach.c
--- a/net/irda/ircomm/ircomm_tty_attach.c~ircomm-discovery-indication-simplification
+++ a/net/irda/ircomm/ircomm_tty_attach.c
@@ -381,18 +381,9 @@ static void ircomm_tty_discovery_indicat
 	info.daddr = discovery->daddr;
 	info.saddr = discovery->saddr;
 
-	/* FIXME. We have a locking problem on the hashbin here.
-	 * We probably need to use hashbin_find_next(), but we first
-	 * need to ensure that "line" is unique. - Jean II */
-	self = (struct ircomm_tty_cb *) hashbin_get_first(ircomm_tty);
-	while (self != NULL) {
-		IRDA_ASSERT(self->magic == IRCOMM_TTY_MAGIC, return;);
-
-		ircomm_tty_do_event(self, IRCOMM_TTY_DISCOVERY_INDICATION,
-				    NULL, &info);
-
-		self = (struct ircomm_tty_cb *) hashbin_get_next(ircomm_tty);
-	}
+	self = (struct ircomm_tty_cb *) priv;
+	ircomm_tty_do_event(self, IRCOMM_TTY_DISCOVERY_INDICATION,
+			    NULL, &info);
 }
 
 /*
_

Patches currently in -mm which might be from ryanr23@gmail.com are

ircomm-discovery-indication-simplification.patch

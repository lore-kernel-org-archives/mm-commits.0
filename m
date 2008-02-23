From: akpm@linux-foundation.org
Subject: - usb-queue-usb-usb_cdc_get_encapsulated_response-message.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:24:05 -0800
Message-ID: <200802232024.m1NKO5tI013608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763164AbYBWU3c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.altenberg@linutronix.de, b.spranger@linutronix.de, dbrownell@users.sourceforge.net, greg@kroah.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     usb: queue usb USB_CDC_GET_ENCAPSULATED_RESPONSE message
has been removed from the -mm tree.  Its filename was
     usb-queue-usb-usb_cdc_get_encapsulated_response-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: queue usb USB_CDC_GET_ENCAPSULATED_RESPONSE message
From: Jan Altenberg <jan.altenberg@linutronix.de>

commit 0cf4f2de0a0f4100795f38ef894d4910678c74f8 introduced a bug, which
prevents sending an USB_CDC_GET_ENCAPSULATED_RESPONSE message. This
breaks the RNDIS initialization (especially / only Windoze machines
dislike this behavior...).

Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/ether.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/usb/gadget/ether.c~usb-queue-usb-usb_cdc_get_encapsulated_response-message drivers/usb/gadget/ether.c
--- a/drivers/usb/gadget/ether.c~usb-queue-usb-usb_cdc_get_encapsulated_response-message
+++ a/drivers/usb/gadget/ether.c
@@ -1561,6 +1561,7 @@ done_set_intf:
 				memcpy(req->buf, buf, n);
 				req->complete = rndis_response_complete;
 				rndis_free_response(dev->rndis_config, buf);
+				value = n;
 			}
 			/* else stalls ... spec says to avoid that */
 		}
_

Patches currently in -mm which might be from jan.altenberg@linutronix.de are

origin.patch

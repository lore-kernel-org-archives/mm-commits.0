From: akpm@linux-foundation.org
Subject: + usb-queue-usb-usb_cdc_get_encapsulated_response-message.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:26 -0800
Message-ID: <200802230733.m1N7XFBS018202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763450AbYBWIEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:04:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jan.altenberg@linutronix.de, b.spranger@linutronix.de, dbrownell@users.sourceforge.net, greg@kroah.com, tglx@linutronix.de


The patch titled
     usb: queue usb USB_CDC_GET_ENCAPSULATED_RESPONSE message
has been added to the -mm tree.  Its filename is
     usb-queue-usb-usb_cdc_get_encapsulated_response-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

usb-queue-usb-usb_cdc_get_encapsulated_response-message.patch

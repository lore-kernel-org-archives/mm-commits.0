From: akpm@linux-foundation.org
Subject: - usb-at91_udc-correct-hanging-while-disconnecting-usb-cable.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:41:24 -0800
Message-ID: <200712172341.lBHNfOAP008388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936529AbXLQXwW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:52:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, david-b@pacbell.net, greg@kroah.com, nicolas.ferre@rfo.atmel.com, mm-commits@vger.kernel.org


The patch titled
     usb: at91_udc: correct hanging while disconnecting usb cable
has been removed from the -mm tree.  Its filename was
     usb-at91_udc-correct-hanging-while-disconnecting-usb-cable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb: at91_udc: correct hanging while disconnecting usb cable
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Correct hanging while disconnecting the USB device cable.  Prevent a race
between vbus and UDP interrupts.  This bug was tracked on at91sam9260ek
boards.

A usb resume interrupt was firing after the vbus interrupt : the IP was
then already stoped and not able to deal with it (no more clock).  A simple
interrupt disabling is ok as the "end of bus reset" irq is non maskable and
ok to resume the USB device IP.

Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Acked-by: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/at91_udc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/usb/gadget/at91_udc.c~usb-at91_udc-correct-hanging-while-disconnecting-usb-cable drivers/usb/gadget/at91_udc.c
--- a/drivers/usb/gadget/at91_udc.c~usb-at91_udc-correct-hanging-while-disconnecting-usb-cable
+++ a/drivers/usb/gadget/at91_udc.c
@@ -887,6 +887,7 @@ static void pullup(struct at91_udc *udc,
 
 	if (is_on) {
 		clk_on(udc);
+		at91_udp_write(udc, AT91_UDP_ICR, AT91_UDP_RXRSM);
 		at91_udp_write(udc, AT91_UDP_TXVC, 0);
 		if (cpu_is_at91rm9200())
 			at91_set_gpio_value(udc->board.pullup_pin, 1);
@@ -904,6 +905,7 @@ static void pullup(struct at91_udc *udc,
 		}
 	} else {
 		stop_activity(udc);
+		at91_udp_write(udc, AT91_UDP_IDR, AT91_UDP_RXRSM);
 		at91_udp_write(udc, AT91_UDP_TXVC, AT91_UDP_TXVC_TXVDIS);
 		if (cpu_is_at91rm9200())
 			at91_set_gpio_value(udc->board.pullup_pin, 0);
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

origin.patch
git-arm.patch

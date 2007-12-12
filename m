From: akpm@linux-foundation.org
Subject: + usb-at91_udc-correct-hanging-while-disconnecting-usb-cable.patch added to -mm tree
Date: Wed, 12 Dec 2007 00:47:25 -0800
Message-ID: <200712120847.lBC8lPd2001673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60542 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754919AbXLLIrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 03:47:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, david-b@pacbell.net, greg@kroah.com, nicolas.ferre@rfo.atmel.com


The patch titled
     usb: at91_udc: correct hanging while disconnecting usb cable
has been added to the -mm tree.  Its filename is
     usb-at91_udc-correct-hanging-while-disconnecting-usb-cable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-arm.patch
usb-at91_udc-correct-hanging-while-disconnecting-usb-cable.patch

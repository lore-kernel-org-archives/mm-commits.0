From: akpm@linux-foundation.org
Subject: + usb-imx_udc-dont-queue-more-data-when-zlp-is-to-be-sent.patch added to -mm tree
Date: Mon, 01 Jun 2009 14:47:30 -0700
Message-ID: <200906012147.n51LlUKX004822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbZFAVsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 17:48:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dg@emlix.com, augulis.darius@gmail.com, david-b@pacbell.net, greg@kroah.com


The patch titled
     usb: imx_udc: don't queue more data when zlp is to be sent
has been added to the -mm tree.  Its filename is
     usb-imx_udc-dont-queue-more-data-when-zlp-is-to-be-sent.patch

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
Subject: usb: imx_udc: don't queue more data when zlp is to be sent
From: Daniel Glockner <dg@emlix.com>

When a zero-length packet has been requested and another packet is written
into the fifo, the MX1 tends to send the first byte of the previous packet
instead of the first byte of the current packet.  The CRC is adjusted
accordingly so that this packet is _not_ discarded by the host.

Waiting for the ZLPS bit to clear avoids these bad packets.

Signed-off-by: Daniel Glockner <dg@emlix.com>
Cc: Darius Augulis <augulis.darius@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/imx_udc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/usb/gadget/imx_udc.c~usb-imx_udc-dont-queue-more-data-when-zlp-is-to-be-sent drivers/usb/gadget/imx_udc.c
--- a/drivers/usb/gadget/imx_udc.c~usb-imx_udc-dont-queue-more-data-when-zlp-is-to-be-sent
+++ a/drivers/usb/gadget/imx_udc.c
@@ -415,6 +415,13 @@ static int write_packet(struct imx_ep_st
 	u8	*buf;
 	int	length, count, temp;
 
+	if (unlikely(__raw_readl(imx_ep->imx_usb->base +
+				 USB_EP_STAT(EP_NO(imx_ep))) & EPSTAT_ZLPS)) {
+		D_TRX(imx_ep->imx_usb->dev, "<%s> zlp still queued in EP %s\n",
+			__func__, imx_ep->ep.name);
+		return -1;
+	}
+
 	buf = req->req.buf + req->req.actual;
 	prefetch(buf);
 
_

Patches currently in -mm which might be from dg@emlix.com are

linux-next.patch
usb-g_serial-append-zlp-when-tx-buffer-becomes-empty.patch
usb-imx_udc-dont-queue-more-data-when-zlp-is-to-be-sent.patch
xtensa-variant-specific-code.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-s6000-dma-engine-support.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
xtensa-add-m41t62-rtc-to-s6105-platform.patch
xtensa-enable-m41t80-driver-in-s6105_defconfig.patch
atmel-lcdc-fix-pixclock-upper-bound-detection.patch


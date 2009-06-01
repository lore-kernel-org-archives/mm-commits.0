From: akpm@linux-foundation.org
Subject: + usb-g_serial-append-zlp-when-tx-buffer-becomes-empty.patch added to -mm tree
Date: Mon, 01 Jun 2009 14:46:28 -0700
Message-ID: <200906012146.n51LkSNO004024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752817AbZFAVrR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 17:47:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dg@emlix.com, david-b@pacbell.net, greg@kroah.com


The patch titled
     usb: g_serial: append zlp when tx buffer becomes empty
has been added to the -mm tree.  Its filename is
     usb-g_serial-append-zlp-when-tx-buffer-becomes-empty.patch

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
Subject: usb: g_serial: append zlp when tx buffer becomes empty
From: Daniel Glockner <dg@emlix.com>

Some usb serial host drivers expect a short packet before they forward the
data to the application.  This is caused by them trying to read more than
one packet at a time.  So when the gadget sends an exact multiple of the
maximum packet size, it should append a zero-length packet.

Signed-off-by: Daniel Glockner <dg@emlix.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/u_serial.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/usb/gadget/u_serial.c~usb-g_serial-append-zlp-when-tx-buffer-becomes-empty drivers/usb/gadget/u_serial.c
--- a/drivers/usb/gadget/u_serial.c~usb-g_serial-append-zlp-when-tx-buffer-becomes-empty
+++ a/drivers/usb/gadget/u_serial.c
@@ -371,6 +371,7 @@ __acquires(&port->port_lock)
 
 		req->length = len;
 		list_del(&req->list);
+		req->zero = (gs_buf_data_avail(&port->port_write_buf) == 0);
 
 		pr_vdebug(PREFIX "%d: tx len=%d, 0x%02x 0x%02x 0x%02x ...\n",
 				port->port_num, len, *((u8 *)req->buf),
_

Patches currently in -mm which might be from dg@emlix.com are

linux-next.patch
usb-g_serial-append-zlp-when-tx-buffer-becomes-empty.patch
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


From: akpm@linux-foundation.org
Subject: + usbtouchscreen-support-bigger-inexio-touchscreens.patch added to -mm tree
Date: Thu, 01 Apr 2010 15:17:54 -0700
Message-ID: <201004012217.o31MHsq7012323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524Ab0DAWSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 18:18:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, dtor@mail.ru, oliver@neukum.org


The patch titled
     usbtouchscreen: support bigger iNexio touchscreens
has been added to the -mm tree.  Its filename is
     usbtouchscreen-support-bigger-inexio-touchscreens.patch

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
Subject: usbtouchscreen: support bigger iNexio touchscreens
From: Ondrej Zary <linux@rainbow-software.org>

Bigger Nexio touchscreens not only send more data but also the header
values are modified somehow.  Fix the header somehow (it's a guesswork but
it works at least on one 46" touchscreen with 2.00SMS firmware) and also
increase rept_size.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/usbtouchscreen.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-support-bigger-inexio-touchscreens drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-support-bigger-inexio-touchscreens
+++ a/drivers/input/touchscreen/usbtouchscreen.c
@@ -858,6 +858,11 @@ static int nexio_read_data(struct usbtou
 	if ((pkt[0] & 0xe0) != 0xe0)
 		return 0;
 
+	if (be16_to_cpu(packet->data_len) > 0xff)
+		packet->data_len = cpu_to_be16(be16_to_cpu(packet->data_len) - 0x100);
+	if (be16_to_cpu(packet->x_len) > 0xff)
+		packet->x_len = cpu_to_be16(be16_to_cpu(packet->x_len) - 0x80);
+
 	/* send ACK */
 	ret = usb_submit_urb(priv->ack, GFP_ATOMIC);
 
@@ -1113,7 +1118,7 @@ static struct usbtouch_device_info usbto
 
 #ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
 	[DEVTYPE_NEXIO] = {
-		.rept_size	= 128,
+		.rept_size	= 1024,
 		.irq_always	= true,
 		.read_data	= nexio_read_data,
 		.init		= nexio_init,
_

Patches currently in -mm which might be from linux@rainbow-software.org are

linux-next.patch
usbtouchscreen-support-bigger-inexio-touchscreens.patch
g_ncr5380-remove-misleading-pnp-error-message.patch
g_ncr5380-fix-broken-mmio-compilation.patch
g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod.patch


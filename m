From: akpm@linux-foundation.org
Subject: + input-tsc-10-dm-usb-touchscreen-driver-assumes-2-byte-response-from-controller.patch added to -mm tree
Date: Thu, 06 Nov 2008 16:37:18 -0800
Message-ID: <200811070037.mA70bIii019034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754567AbYKGAh0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 19:37:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ntlucas@gmail.com, dtor@mail.ru


The patch titled
     input: TSC-10 DM USB touchscreen driver assumes 2-byte response from controller
has been added to the -mm tree.  Its filename is
     input-tsc-10-dm-usb-touchscreen-driver-assumes-2-byte-response-from-controller.patch

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
Subject: input: TSC-10 DM USB touchscreen driver assumes 2-byte response from controller
From: "Nuno Lucas" <ntlucas@gmail.com>

The usbtouchscreen module implements a driver for the TSC-10 DM USB
touchscreen controllers, but assumes a 2-byte response for the CMD_RESET
and CMD_RATE commands, when they can be only a single byte when no EEPROM
is connected.

The driver worked with an earlier controller revision, but new revisions
of the controller fail.

It seems the problem is that the early controller had the SEL4/EEPROM-CS
pin high, but the new controller has it down, making the response
different.

Without the fix, the controller would answer the single byte 0x06 (ACK),
making the init fail with -ENODEV because buf[1] is 0xFF (as initialized
before).

As the single byte is the only thing we need to check it was ok, there is
no need to verify the second byte.

The [0x15 0x01] case is the NAK [0x15] response for when there is no data
in the EEPROM [bit-0 of second byte set], so I let that be, as I don't
have any controller with an EEPROM.

With this patch, both the earlier and latest controller work the same.

Note: This was previously submited as BUG #11961 on the bugzilla
tracker, but rebased to version 2.6.27.4 and with unnecessary comments and
printk's removed.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11961

Signed-off-by: Nuno Lucas <ntlucas@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/usbtouchscreen.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/input/touchscreen/usbtouchscreen.c~input-tsc-10-dm-usb-touchscreen-driver-assumes-2-byte-response-from-controller drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c~input-tsc-10-dm-usb-touchscreen-driver-assumes-2-byte-response-from-controller
+++ a/drivers/input/touchscreen/usbtouchscreen.c
@@ -424,7 +424,7 @@ static int dmc_tsc10_init(struct usbtouc
 	                      0, 0, buf, 2, USB_CTRL_SET_TIMEOUT);
 	if (ret < 0)
 		goto err_out;
-	if (buf[0] != 0x06 || buf[1] != 0x00) {
+	if (buf[0] != 0x06) {
 		ret = -ENODEV;
 		goto err_out;
 	}
@@ -437,8 +437,7 @@ static int dmc_tsc10_init(struct usbtouc
 	                      TSC10_RATE_150, 0, buf, 2, USB_CTRL_SET_TIMEOUT);
 	if (ret < 0)
 		goto err_out;
-	if ((buf[0] != 0x06 || buf[1] != 0x00) &&
-	    (buf[0] != 0x15 || buf[1] != 0x01)) {
+	if ((buf[0] != 0x06) && (buf[0] != 0x15 || buf[1] != 0x01)) {
 		ret = -ENODEV;
 		goto err_out;
 	}
_

Patches currently in -mm which might be from ntlucas@gmail.com are

input-tsc-10-dm-usb-touchscreen-driver-assumes-2-byte-response-from-controller.patch


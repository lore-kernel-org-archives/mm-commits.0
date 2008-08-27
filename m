From: akpm@linux-foundation.org
Subject: + correct-sierra-wireless-usb-evdo-modem-device-id.patch added to -mm tree
Date: Wed, 27 Aug 2008 13:20:40 -0700
Message-ID: <200808272020.m7RKKeDf020365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118AbYH0UUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 16:20:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: murraytony@gmail.com, greg@kroah.com, klloyd@sierrawireless.com


The patch titled
     usb: correct Sierra Wireless USB EVDO Modem Device ID
has been added to the -mm tree.  Its filename is
     correct-sierra-wireless-usb-evdo-modem-device-id.patch

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
Subject: usb: correct Sierra Wireless USB EVDO Modem Device ID
From: "Tony Murray" <murraytony@gmail.com>

I was trying to figure out why my device wasn't supported by the
drivers/usb/serial/sierra.c driver, while looking throught the device
IDs I spotted what I believe to be a typo in the device IDs.

Cc: <klloyd@sierrawireless.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/sierra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/sierra.c~correct-sierra-wireless-usb-evdo-modem-device-id drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c~correct-sierra-wireless-usb-evdo-modem-device-id
+++ a/drivers/usb/serial/sierra.c
@@ -163,7 +163,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x0017) },	/* Sierra Wireless EM5625 */
 	{ USB_DEVICE(0x1199, 0x0018) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0218) },	/* Sierra Wireless MC5720 */
-	{ USB_DEVICE(0x0f30, 0x1b1d) },	/* Sierra Wireless MC5720 */
+	{ USB_DEVICE(0x03f0, 0x1b1d) }, /* HP ev2200 a.k.a MC5720 */
 	{ USB_DEVICE(0x1199, 0x0020) },	/* Sierra Wireless MC5725 */
 	{ USB_DEVICE(0x1199, 0x0024) },	/* Sierra Wireless MC5727 */
 	{ USB_DEVICE(0x1199, 0x0220) },	/* Sierra Wireless MC5725 */
_

Patches currently in -mm which might be from murraytony@gmail.com are

correct-sierra-wireless-usb-evdo-modem-device-id.patch


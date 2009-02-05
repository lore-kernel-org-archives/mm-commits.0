From: akpm@linux-foundation.org
Subject: + at76_usb-add-support-for-oqo-model-01.patch added to -mm tree
Date: Thu, 05 Feb 2009 13:07:44 -0800
Message-ID: <200902052107.n15L7ifm002551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659AbZBEVHy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 16:07:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jm@lentin.co.uk, greg@kroah.com


The patch titled
     at76_usb: add support for OQO Model 01+
has been added to the -mm tree.  Its filename is
     at76_usb-add-support-for-oqo-model-01.patch

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
Subject: at76_usb: add support for OQO Model 01+
From: Jamie Lentin <jm@lentin.co.uk>

Add USB device ID for OQO 01+'s internal wireless LAN

An OQO employee mentions the chip's true identity here:-

   ftp://ftp.oqo.com/unsupported/linux/OQOLinux.html

Works fine with the current staging driver.  I see there's a mac80211 port
in the works which I haven't tried, but more than happy to help test if
required.

Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/at76_usb/at76_usb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/staging/at76_usb/at76_usb.c~at76_usb-add-support-for-oqo-model-01 drivers/staging/at76_usb/at76_usb.c
--- a/drivers/staging/at76_usb/at76_usb.c~at76_usb-add-support-for-oqo-model-01
+++ a/drivers/staging/at76_usb/at76_usb.c
@@ -231,6 +231,8 @@ static struct usb_device_id dev_table[] 
 	{USB_DEVICE(0x03eb, 0x7617), USB_DEVICE_DATA(BOARD_505A)},
 	/* Siemens Gigaset USB WLAN Adapter 11 */
 	{USB_DEVICE(0x1690, 0x0701), USB_DEVICE_DATA(BOARD_505A)},
+	/* OQO Model 01+ Internal Wi-Fi */
+	{USB_DEVICE(0x1557, 0x0002), USB_DEVICE_DATA(BOARD_505A)},
 	/*
 	 * at76c505amx-rfmd
 	 */
_

Patches currently in -mm which might be from jm@lentin.co.uk are

at76_usb-add-support-for-oqo-model-01.patch


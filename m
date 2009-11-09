From: akpm@linux-foundation.org
Subject: + usb-optionc-add-support-for-d-link-dwm-162-u5.patch added to -mm tree
Date: Mon, 09 Nov 2009 15:23:27 -0800
Message-ID: <200911092323.nA9NNRI8028497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbZKIXXl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 18:23:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: r0bertz@gentoo.org, greg@kroah.com


The patch titled
     usb: option.c: add support for D-Link DWM-162-U5
has been added to the -mm tree.  Its filename is
     usb-optionc-add-support-for-d-link-dwm-162-u5.patch

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
Subject: usb: option.c: add support for D-Link DWM-162-U5
From: Zhang Le <r0bertz@gentoo.org>

Add D-Link DWM-162-U5 device id 1e0e:ce16 into option driver.  The device
has 4 interfaces, of which 1 is handled by storage and the other 3 by
option driver.

The device appears first as CD-only 05c6:2100 device and must be switched
to 1e0e:ce16 mode either by using "eject CD" or usb_modeswitch.

The MessageContent for usb_modeswitch.conf is:
"55534243e0c26a85000000000000061b000000020000000000000000000000"

Signed-off-by: Zhang Le <r0bertz@gentoo.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/usb/serial/option.c~usb-optionc-add-support-for-d-link-dwm-162-u5 drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~usb-optionc-add-support-for-d-link-dwm-162-u5
+++ a/drivers/usb/serial/option.c
@@ -595,6 +595,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_G450) },
 	{ USB_DEVICE(TOSHIBA_VENDOR_ID, TOSHIBA_PRODUCT_HSDPA_MINICARD ) }, /* Toshiba 3G HSDPA == Novatel Expedite EU870D MiniCard */
 	{ USB_DEVICE(ALINK_VENDOR_ID, 0x9000) },
+	{ USB_DEVICE(ALINK_VENDOR_ID, 0xce16) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ALINK_VENDOR_ID, ALINK_PRODUCT_3GU, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
_

Patches currently in -mm which might be from r0bertz@gentoo.org are

linux-next.patch
usb-optionc-add-support-for-d-link-dwm-162-u5.patch


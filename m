From: akpm@linux-foundation.org
Subject: [merged] usb-optionc-add-support-for-d-link-dwm-162-u5.patch removed from -mm tree
Date: Mon, 23 Nov 2009 11:37:56 -0800
Message-ID: <200911231937.nANJbuG7018969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788AbZKWThx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 14:37:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: r0bertz@gentoo.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: option.c: add support for D-Link DWM-162-U5
has been removed from the -mm tree.  Its filename was
     usb-optionc-add-support-for-d-link-dwm-162-u5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

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


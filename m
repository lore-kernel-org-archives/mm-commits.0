From: akpm@linux-foundation.org
Subject: [merged] btusb-patch-add_apple_macbookpro62.patch removed from -mm tree
Date: Wed, 09 Nov 2011 13:44:12 -0800
Message-ID: <201111092144.pA9LiDu5012879@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:41071 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1KIVo1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2011 16:44:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: froemel@vmars.tuwien.ac.at, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/bluetooth/btusb.c: add_apple_MacBookPro62
has been removed from the -mm tree.  Its filename was
     btusb-patch-add_apple_macbookpro62.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Subject: drivers/bluetooth/btusb.c: add_apple_MacBookPro62

The Apple MBP model 6.2 (and maybe other recent MBPs) uses an Apple
branded BCM2046 USB bluetooth device that works well [1] with your generic
driver.  Add the vendor and device id.

Output from Marcel's "usb-devices" script:

T:  Bus=1 Dev#=8 Spd=12 MxCh=0
D:  Ver=2.00 Cls=ff(vendr) Sub=01 Prot=01 MxPS=64 #Cfgs=1
P:  Vendor=05ac ProdID=8218 Rev=0.22
S:  Manufacturer=Apple Inc.
S:  Product=Bluetooth USB Host Controller
C:  #Ifs=4 Cfg#=1 Atr=e0 MxPwr=0mA
E:  Ad=00(both) Atr=00(Control) MxPS=0040 Ivl=0ms
I:  If#=00 Alt=0 #EPs=03 Cls=ff(vendr) Sub=01 Prot=01 Driver=(none)
I:  If#=01 Alt=0 #EPs=02 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
I:  If#=02 Alt=0 #EPs=02 Cls=ff(vendr) Sub=ff Prot=ff Driver=(none)
I:  If#=03 Alt=0 #EPs=00 Cls=fe(apspe) Sub=01 Prot=01 Driver=(none)

Signed-off-by: Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/bluetooth/btusb.c~btusb-patch-add_apple_macbookpro62 drivers/bluetooth/btusb.c
--- a/drivers/bluetooth/btusb.c~btusb-patch-add_apple_macbookpro62
+++ a/drivers/bluetooth/btusb.c
@@ -103,6 +103,9 @@ static struct usb_device_id btusb_table[
 	/* Broadcom BCM20702A0 */
 	{ USB_DEVICE(0x413c, 0x8197) },
 
+	/* Apple MacBookPro6 BT device */
+	{ USB_DEVICE(0x05ac, 0x8218) },
+
 	{ }	/* Terminating entry */
 };
 
_

Patches currently in -mm which might be from froemel@vmars.tuwien.ac.at are



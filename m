From: akpm@linux-foundation.org
Subject: - usb-add-nikon-d300-camera-to-unusual_devs.patch removed from -mm tree
Date: Mon, 01 Dec 2008 14:33:01 -0800
Message-ID: <200812012233.mB1MX1Ih019959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbYLAWdl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 17:33:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lxtwin@homecall.co.uk, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb: add Nikon D300 camera to unusual_devs
has been removed from the -mm tree.  Its filename was
     usb-add-nikon-d300-camera-to-unusual_devs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: add Nikon D300 camera to unusual_devs
From: Paul Ready <lxtwin@homecall.co.uk>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11685

When A Nikon D300 camera is connected to a system it is seen in
/proc/bus/pci/devices but is not accessible.

This is seen in the above file:

T:  Bus=01 Lev=01 Prnt=01 Port=05 Cnt=03 Dev#= 11 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=04b0 ProdID=041a Rev= 1.03
S:  Manufacturer=NIKON
S:  Product=NIKON DSC D300
S:  SerialNumber=000008014379
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  2mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=06(still) Sub=01 Prot=01 Driver=usbfs
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=   8 Ivl=32ms

Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/usb/storage/unusual_devs.h~usb-add-nikon-d300-camera-to-unusual_devs drivers/usb/storage/unusual_devs.h
--- a/drivers/usb/storage/unusual_devs.h~usb-add-nikon-d300-camera-to-unusual_devs
+++ a/drivers/usb/storage/unusual_devs.h
@@ -468,6 +468,13 @@ UNUSUAL_DEV(  0x04b0, 0x0419, 0x0100, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY),
 
+/* Reported by paul ready <lxtwin@homecall.co.uk> */
+UNUSUAL_DEV(  0x04b0, 0x0419, 0x0100, 0x0200,
+		"NIKON",
+		"NIKON DSC D300",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY),
+
 /* Reported by Doug Maxey (dwm@austin.ibm.com) */
 UNUSUAL_DEV(  0x04b3, 0x4001, 0x0110, 0x0110,
 		"IBM",
_

Patches currently in -mm which might be from lxtwin@homecall.co.uk are

usb-add-nikon-d300-camera-to-unusual_devs.patch


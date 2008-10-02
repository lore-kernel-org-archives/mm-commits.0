From: akpm@linux-foundation.org
Subject: + usb-add-nikon-d300-to-unusual_devsh.patch added to -mm tree
Date: Thu, 02 Oct 2008 15:41:55 -0700
Message-ID: <200810022241.m92Mftst030319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752995AbYJBWmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 18:42:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lxtwin@homecall.co.uk, greg@kroah.com


The patch titled
     usb: add Nikon D300 to unusual_devs.h
has been added to the -mm tree.  Its filename is
     usb-add-nikon-d300-to-unusual_devsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: add Nikon D300 to unusual_devs.h
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/usb/storage/unusual_devs.h~usb-add-nikon-d300-to-unusual_devsh drivers/usb/storage/unusual_devs.h
--- a/drivers/usb/storage/unusual_devs.h~usb-add-nikon-d300-to-unusual_devsh
+++ a/drivers/usb/storage/unusual_devs.h
@@ -120,6 +120,13 @@ UNUSUAL_DEV(  0x0411, 0x001c, 0x0113, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY ),
 
+/* Reported by paul ready <lxtwin@homecall.co.uk> */
+UNUSUAL_DEV(  0x04b0, 0x0419, 0x0100, 0x0200,
+		"NIKON",
+		"NIKON DSC D300",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_INQUIRY),
+
 /* Submitted by Ernestas Vaiciukevicius <ernisv@gmail.com> */
 UNUSUAL_DEV(  0x0419, 0x0100, 0x0100, 0x0100,
 		"Samsung Info. Systems America, Inc.",
_

Patches currently in -mm which might be from lxtwin@homecall.co.uk are

usb-add-nikon-d300-to-unusual_devsh.patch


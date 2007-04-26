From: akpm@linux-foundation.org
Subject: + ohci1394-fix-mistake-in-printk-message.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:34:09 -0700
Message-ID: <200704260034.l3Q0Y9TI017045@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423463AbXDZAep (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:34:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: simon@fire.lp0.eu, stefanr@s5r6.in-berlin.de


The patch titled
     ohci1394: Fix mistake in printk message.
has been added to the -mm tree.  Its filename is
     ohci1394-fix-mistake-in-printk-message.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ohci1394: Fix mistake in printk message.
From: Simon Arlott <simon@fire.lp0.eu>

Fix the "attempting to setting" message in ohci1394.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ieee1394/ohci1394.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ieee1394/ohci1394.c~ohci1394-fix-mistake-in-printk-message drivers/ieee1394/ohci1394.c
--- a/drivers/ieee1394/ohci1394.c~ohci1394-fix-mistake-in-printk-message
+++ a/drivers/ieee1394/ohci1394.c
@@ -610,7 +610,7 @@ static void ohci_initialize(struct ti_oh
 #endif
 
 		PRINT(KERN_DEBUG, "Serial EEPROM has suspicious values, "
-                      "attempting to setting max_packet_size to 512 bytes");
+                      "attempting to set max_packet_size to 512 bytes");
 		reg_write(ohci, OHCI1394_BusOptions,
 			  (reg_read(ohci, OHCI1394_BusOptions) & 0xf007) | 0x8002);
 		ohci->max_packet_size = 512;
_

Patches currently in -mm which might be from simon@fire.lp0.eu are

ohci1394-fix-mistake-in-printk-message.patch
usbatm-detect-usb-device-shutdown-and-ignore-failed-urbs.patch
usb-cxacru-adsl-state-management.patch
usb-cxacru-adsl-state-management-udpate.patch
cxacru-add-documentation-file.patch
cxacru-add-documentation-file-fix.patch

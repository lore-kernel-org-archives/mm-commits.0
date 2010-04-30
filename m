From: akpm@linux-foundation.org
Subject: + usb-atm-speedtch-use-new-hex_to_bin-method.patch added to -mm tree
Date: Fri, 30 Apr 2010 12:02:14 -0700
Message-ID: <201004301902.o3UJ2E6l005909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933165Ab0D3TCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 15:02:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-andriy.shevchenko@nokia.com, duncan.sands@free.fr


The patch titled
     usb: atm: speedtch: use new hex_to_bin() method
has been added to the -mm tree.  Its filename is
     usb-atm-speedtch-use-new-hex_to_bin-method.patch

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
Subject: usb: atm: speedtch: use new hex_to_bin() method
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Instead of using own implementation which potentialy has bugs involve
hex_to_bin() function.  It requires to have hex_to_bin() implementation
introduced by starter patch in series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Duncan Sands <duncan.sands@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/speedtch.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/usb/atm/speedtch.c~usb-atm-speedtch-use-new-hex_to_bin-method drivers/usb/atm/speedtch.c
--- a/drivers/usb/atm/speedtch.c~usb-atm-speedtch-use-new-hex_to_bin-method
+++ a/drivers/usb/atm/speedtch.c
@@ -127,8 +127,6 @@ MODULE_PARM_DESC(ModemOption, "default: 
 #define ENDPOINT_ISOC_DATA	0x07
 #define ENDPOINT_FIRMWARE	0x05
 
-#define hex2int(c) ( (c >= '0') && (c <= '9') ? (c - '0') : ((c & 0xf) + 9) )
-
 struct speedtch_params {
 	unsigned int altsetting;
 	unsigned int BMaxDSL;
@@ -669,7 +667,8 @@ static int speedtch_atm_start(struct usb
 	memset(atm_dev->esi, 0, sizeof(atm_dev->esi));
 	if (usb_string(usb_dev, usb_dev->descriptor.iSerialNumber, mac_str, sizeof(mac_str)) == 12) {
 		for (i = 0; i < 6; i++)
-			atm_dev->esi[i] = (hex2int(mac_str[i * 2]) * 16) + (hex2int(mac_str[i * 2 + 1]));
+			atm_dev->esi[i] = (hex_to_bin(mac_str[i * 2]) << 4) +
+				hex_to_bin(mac_str[i * 2 + 1]);
 	}
 
 	/* Start modem synchronisation */
_

Patches currently in -mm which might be from ext-andriy.shevchenko@nokia.com are

linux-next.patch
lib-introduce-common-method-to-convert-hex-digits.patch
drivers-isdn-use-new-hex_to_bin-method.patch
usb-atm-speedtch-use-new-hex_to_bin-method.patch
sysctl-dont-use-own-implementation-of-hex_to_bin.patch
staging-rt2860-use-new-hex_to_bin-method.patch
fs-ldm-dont-use-own-implementation-of-hex_to_bin.patch
drivers-wireless-use-new-hex_to_bin-method.patch
drivers-acpi-dont-use-own-implementation-of-hex_to_bin.patch


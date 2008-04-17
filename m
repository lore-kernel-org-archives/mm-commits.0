From: akpm@linux-foundation.org
Subject: + miscacpibacklight-compal-laptop-extras-use-bitmask-not-hex.patch added to -mm tree
Date: Thu, 17 Apr 2008 14:33:27 -0700
Message-ID: <200804172133.m3HLXRxw028979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561AbYDQVeY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 17:34:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cezary.jackiewicz@gmail.com, aystarik@gmail.com, hmh@hmh.eng.br, lenb@kernel.org, rpurdie@rpsys.net


The patch titled
     misc,acpi,backlight: Compal Laptop Extras - use bitmask, not hex
has been added to the -mm tree.  Its filename is
     miscacpibacklight-compal-laptop-extras-use-bitmask-not-hex.patch

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
Subject: misc,acpi,backlight: Compal Laptop Extras - use bitmask, not hex
From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>

Clean up code. Use bitmask for operations.

Signed-off-by: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>
Cc: Alexey Starikovskiy <aystarik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/compal-laptop.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN drivers/misc/compal-laptop.c~miscacpibacklight-compal-laptop-extras-use-bitmask-not-hex drivers/misc/compal-laptop.c
--- a/drivers/misc/compal-laptop.c~miscacpibacklight-compal-laptop-extras-use-bitmask-not-hex
+++ a/drivers/misc/compal-laptop.c
@@ -1,7 +1,7 @@
 /*-*-linux-c-*-*/
 
 /*
-  Copyright (C) 2008 Cezary Jackiewicz <cezary.Jackiewicz (at) gmail.com>
+  Copyright (C) 2008 Cezary Jackiewicz <cezary.jackiewicz (at) gmail.com>
 
   based on MSI driver
 
@@ -56,13 +56,17 @@
 #include <linux/platform_device.h>
 #include <linux/autoconf.h>
 
-#define COMPAL_DRIVER_VERSION "0.2.2"
+#define COMPAL_DRIVER_VERSION "0.2.5"
 
 #define COMPAL_LCD_LEVEL_MAX 8
 
 #define COMPAL_EC_COMMAND_WIRELESS 0xBB
 #define COMPAL_EC_COMMAND_LCD_LEVEL 0xB9
 
+#define KILLSWITCH_MASK	0x10
+#define WLAN_MASK	0x01
+#define BT_MASK		0x02
+
 static int force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
@@ -94,13 +98,13 @@ static int set_wlan_state(int state)
 
 	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
 
-	if ((result & 0x10) == 0)
+	if ((result & KILLSWITCH_MASK) == 0)
 		return -EINVAL;
 	else {
 		if (state)
-			value = (u8) (result | 0x01);
+			value = (u8) (result | WLAN_MASK);
 		else
-			value = (u8) (result & 0xFE);
+			value = (u8) (result & ~WLAN_MASK);
 		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
 	}
 
@@ -113,13 +117,13 @@ static int set_bluetooth_state(int state
 
 	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
 
-	if ((result & 0x10) == 0)
+	if ((result & KILLSWITCH_MASK) == 0)
 		return -EINVAL;
 	else {
 		if (state)
-			value = (u8) (result | 0x02);
+			value = (u8) (result | BT_MASK);
 		else
-			value = (u8) (result & 0xFD);
+			value = (u8) (result & ~BT_MASK);
 		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
 	}
 
@@ -133,17 +137,17 @@ static int get_wireless_state(int *wlan,
 	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
 
 	if (wlan) {
-		if ((result & 0x10) == 0)
+		if ((result & KILLSWITCH_MASK) == 0)
 			*wlan = 0;
 		else
-			*wlan = result & 0x01;
+			*wlan = result & WLAN_MASK;
 	}
 
 	if (bluetooth) {
-		if ((result & 0x10) == 0)
+		if ((result & KILLSWITCH_MASK) == 0)
 			*bluetooth = 0;
 		else
-			*bluetooth = (result >> 1) & 0x01;
+			*bluetooth = (result & BT_MASK) >> 1;
 	}
 
 	return 0;
_

Patches currently in -mm which might be from cezary.jackiewicz@gmail.com are

miscacpibacklight-compal-laptop-extras-3rd-try.patch
miscacpibacklight-compal-laptop-extras-add-entry-to-maintainers.patch
miscacpibacklight-compal-laptop-extras-use-bitmask-not-hex.patch
miscacpibacklight-compal-laptop-extras-add-support-for-new-laptops.patch


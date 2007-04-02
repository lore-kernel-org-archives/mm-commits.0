From: akpm@linux-foundation.org
Subject: + hid-add-two-led-codes-to-hid-input-mapping.patch added to -mm tree
Date: Mon, 02 Apr 2007 13:51:38 -0700
Message-ID: <200704022051.l32Kpd0q009129@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45015 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965860AbXDBUvr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 16:51:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dengel@sourceharvest.com


The patch titled
     hid: add two led codes to hid input mapping
has been added to the -mm tree.  Its filename is
     hid-add-two-led-codes-to-hid-input-mapping.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hid: add two led codes to hid input mapping
From: Daniel P. Engel <dengel@sourceharvest.com>

Add the "Off-hook" and "Speaker" LED codes 0xb and 0xc to the hid-input
configuration, mapping them to the 0x17 and 0x1e usages in the HID usage
table.

Signed-off-by: Daniel P. Engel <dengel@sourceharvest.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-input.c |    2 ++
 include/linux/input.h   |    2 ++
 2 files changed, 4 insertions(+)

diff -puN drivers/hid/hid-input.c~hid-add-two-led-codes-to-hid-input-mapping drivers/hid/hid-input.c
--- a/drivers/hid/hid-input.c~hid-add-two-led-codes-to-hid-input-mapping
+++ a/drivers/hid/hid-input.c
@@ -379,6 +379,8 @@ static void hidinput_configure_usage(str
 				case 0x4b:  map_led (LED_MISC);     break;    /*   "Generic Indicator"        */
 				case 0x19:  map_led (LED_MAIL);     break;    /*   "Message Waiting"          */
 				case 0x4d:  map_led (LED_CHARGING); break;    /*   "External Power Connected" */
+				case 0x17:  map_led (LED_OFFHOOK);  break;    /*   "Off Hook"                 */
+				case 0x1e:  map_led (LED_SPEAKER);  break;    /*   "Speaker"                  */
 
 				default: goto ignore;
 			}
diff -puN include/linux/input.h~hid-add-two-led-codes-to-hid-input-mapping include/linux/input.h
--- a/include/linux/input.h~hid-add-two-led-codes-to-hid-input-mapping
+++ a/include/linux/input.h
@@ -630,6 +630,8 @@ struct input_absinfo {
 #define LED_MISC		0x08
 #define LED_MAIL		0x09
 #define LED_CHARGING		0x0a
+#define LED_OFFHOOK		0x0b
+#define LED_SPEAKER		0x0c
 #define LED_MAX			0x0f
 
 /*
_

Patches currently in -mm which might be from dengel@sourceharvest.com are

hid-add-two-led-codes-to-hid-input-mapping.patch

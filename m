From: akpm@linux-foundation.org
Subject: - hid-add-two-led-codes-to-hid-input-mapping.patch removed from -mm tree
Date: Thu, 26 Apr 2007 00:49:21 -0700
Message-ID: <200704260749.l3Q7nLHE024708@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933471AbXDZHte (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 03:49:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dengel@sourceharvest.com, mm-commits@vger.kernel.org


The patch titled
     hid: add two led codes to hid input mapping
has been removed from the -mm tree.  Its filename was
     hid-add-two-led-codes-to-hid-input-mapping.patch

This patch was dropped because it was nacked by the maintainer

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

git-hid.patch
hid-add-two-led-codes-to-hid-input-mapping.patch

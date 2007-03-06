From: akpm@linux-foundation.org
Subject: + wistron-button-support-for-travelmate-610.patch added to -mm tree
Date: Mon, 05 Mar 2007 21:00:28 -0800
Message-ID: <200703060500.l2650S98012484@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51057 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbXCFFAh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 00:00:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, dtor@mail.ru


The patch titled
     Wistron button support for TravelMate 610
has been added to the -mm tree.  Its filename is
     wistron-button-support-for-travelmate-610.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Wistron button support for TravelMate 610
From: Eric Piel <eric.piel@tremplin-utc.net>

TM610 support for wistron_btns.

Adds support for Acer TravelMate 610 to wistron_btns, coming from info of
acer_hk.  All special keys are detected, but the 2 leds are not handled
(yet).

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/wistron_btns.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN drivers/input/misc/wistron_btns.c~wistron-button-support-for-travelmate-610 drivers/input/misc/wistron_btns.c
--- a/drivers/input/misc/wistron_btns.c~wistron-button-support-for-travelmate-610
+++ a/drivers/input/misc/wistron_btns.c
@@ -324,6 +324,21 @@ static struct key_entry keymap_acer_trav
 	{ KE_END, 0 }
 };
 
+/* Wifi subsystem only activate the led. Therefore we need to pass
+ * wifi event as a normal key, then userspace can really change the wifi state.
+ * TODO we need to export led state to userspace (wifi and mail) */
+static struct key_entry keymap_acer_travelmate_610[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_PROG3 },
+	{ KE_KEY, 0x14, KEY_MAIL },
+	{ KE_KEY, 0x15, KEY_WWW },
+	{ KE_KEY, 0x40, KEY_XFER }, /* Wifi */
+	{ KE_END, 0 }
+};
+
 static struct key_entry keymap_aopen_1559as[] = {
 	{ KE_KEY,  0x01, KEY_HELP },
 	{ KE_KEY,  0x06, KEY_PROG3 },
@@ -408,6 +423,15 @@ static struct dmi_system_id dmi_ids[] __
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Acer TravelMate 610",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ACER"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 610"),
+		},
+		.driver_data = keymap_acer_travelmate_610
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "AOpen 1559AS",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "E2U"),
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net are

wistron-button-support-for-travelmate-610.patch

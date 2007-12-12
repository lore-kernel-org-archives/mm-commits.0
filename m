From: akpm@linux-foundation.org
Subject: + wistron_btns-add-support-for-fujitsu-siemens-amilo-pro-edition-v3505.patch added to -mm tree
Date: Wed, 12 Dec 2007 00:29:07 -0800
Message-ID: <200712120829.lBC8T7rb001034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39131 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753398AbXLLI3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 03:29:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rherilier@yahoo.fr, dtor@mail.ru, jikos@jikos.cz, mitr@volny.cz


The patch titled
     wistron_btns: add support for fujitsu-siemens amilo pro edition v3505
has been added to the -mm tree.  Its filename is
     wistron_btns-add-support-for-fujitsu-siemens-amilo-pro-edition-v3505.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wistron_btns: add support for fujitsu-siemens amilo pro edition v3505
From: Remi Herilier <rherilier@yahoo.fr>

Wistron button support for Fujitsu-Siemens Amilo Pro Edition V3505.

Signed-off-by: Remi Herilier <rherilier@yahoo.fr>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jikos@jikos.cz>
Cc: Miloslav Trmac <mitr@volny.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/wistron_btns.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN drivers/input/misc/wistron_btns.c~wistron_btns-add-support-for-fujitsu-siemens-amilo-pro-edition-v3505 drivers/input/misc/wistron_btns.c
--- a/drivers/input/misc/wistron_btns.c~wistron_btns-add-support-for-fujitsu-siemens-amilo-pro-edition-v3505
+++ a/drivers/input/misc/wistron_btns.c
@@ -285,6 +285,16 @@ static struct key_entry keymap_fs_amilo_
 	{ KE_END,  0 }
 };
 
+static struct key_entry keymap_fs_amilo_pro_v3505[] __initdata = {
+	{ KE_KEY,       0x01, {KEY_HELP} },          /* Fn+F1 */
+	{ KE_KEY,       0x06, {KEY_DISPLAYTOGGLE} }, /* Fn+F4 */
+	{ KE_BLUETOOTH, 0x30 },                      /* Fn+F10 */
+	{ KE_KEY,       0x31, {KEY_MAIL} },          /* mail button */
+	{ KE_KEY,       0x36, {KEY_WWW} },           /* www button */
+	{ KE_WIFI,      0x78 },                      /* satelite dish button */
+	{ KE_END,       0 }
+};
+
 static struct key_entry keymap_fujitsu_n3510[] __initdata = {
 	{ KE_KEY, 0x11, {KEY_PROG1} },
 	{ KE_KEY, 0x12, {KEY_PROG2} },
@@ -626,6 +636,15 @@ static struct dmi_system_id dmi_ids[] __
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Fujitsu-Siemens Amilo Pro Edition V3505",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pro Edition V3505"),
+		},
+		.driver_data = keymap_fs_amilo_pro_v3505
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Fujitsu-Siemens Amilo M7400",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
_

Patches currently in -mm which might be from rherilier@yahoo.fr are

wistron_btns-add-support-for-x86_64-systems.patch
wistron_btns-add-support-for-fujitsu-siemens-amilo-pro-edition-v3505.patch

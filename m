From: akpm@linux-foundation.org
Subject: - wistron_btns-add-support-for-fujitsu-siemens-amilo-pro-edition-v3505.patch removed from -mm tree
Date: Tue, 12 Aug 2008 17:45:56 -0700
Message-ID: <200808130059.m7D0x1Ur023072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079AbYHMA7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 20:59:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rherilier@yahoo.fr, dtor@mail.ru, jikos@jikos.cz, mitr@volny.cz, mm-commits@vger.kernel.org


The patch titled
     wistron_btns: add support for fujitsu-siemens amilo pro edition v3505
has been removed from the -mm tree.  Its filename was
     wistron_btns-add-support-for-fujitsu-siemens-amilo-pro-edition-v3505.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -277,6 +277,16 @@ static struct key_entry keymap_fs_amilo_
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
@@ -618,6 +628,15 @@ static struct dmi_system_id dmi_ids[] __
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

linux-next.patch
wistron_btns-add-support-for-fujitsu-siemens-amilo-pro-edition-v3505.patch


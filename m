From: akpm@linux-foundation.org
Subject: - make-wistron-btns-recognize-special-keys-on-medion-wim2160-notebooks.patch removed from -mm tree
Date: Wed, 21 Nov 2007 17:21:04 -0800
Message-ID: <200711220121.lAM1L6cM018590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970AbXKVBVf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Nov 2007 20:21:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bero@arklinux.org, cathectic@gmail.com, dtor@mail.ru, jkosina@suse.cz, mitr@volny.cz, mm-commits@vger.kernel.org


The patch titled
     Make wistron-btns recognize special keys on Medion WIM2160 notebooks
has been removed from the -mm tree.  Its filename was
     make-wistron-btns-recognize-special-keys-on-medion-wim2160-notebooks.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: Make wistron-btns recognize special keys on Medion WIM2160 notebooks
From: Bernhard Rosenkraenzer <bero@arklinux.org>

Add support for Medion WIM2160 notebooks to the wistron-btns driver.

Signed-off-by: Bernhard Rosenkraenzer <bero@arklinux.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Carlos Corbacho <cathectic@gmail.com>
Cc: Miloslav Trmac <mitr@volny.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/wistron_btns.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN drivers/input/misc/wistron_btns.c~make-wistron-btns-recognize-special-keys-on-medion-wim2160-notebooks drivers/input/misc/wistron_btns.c
--- a/drivers/input/misc/wistron_btns.c~make-wistron-btns-recognize-special-keys-on-medion-wim2160-notebooks
+++ a/drivers/input/misc/wistron_btns.c
@@ -533,6 +533,13 @@ static struct key_entry keymap_fs_amilo_
 	{ KE_END, FE_MAIL_LED | FE_WIFI_LED | FE_UNTESTED }
 };
 
+static struct key_entry keymap_medion_wim2160[] __initdata = {
+	{ KE_WIFI, 0x30 },
+	{ KE_KEY, 0x11, {KEY_PROG1} },
+	{ KE_KEY, 0x12, {KEY_PROG2} },
+	{ KE_END, 0 }
+};
+
 static struct key_entry keymap_wistron_md2900[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
@@ -914,6 +921,15 @@ static struct dmi_system_id dmi_ids[] __
 		},
 		.driver_data = keymap_fs_amilo_d88x0
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Medion WIM2160",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "WIM2160"),
+		},
+		.driver_data = keymap_medion_wim2160
+	},
 	{ NULL, }
 };
 
_

Patches currently in -mm which might be from bero@arklinux.org are

make-wistron-btns-recognize-special-keys-on-medion-wim2160-notebooks.patch

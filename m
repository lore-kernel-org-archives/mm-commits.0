From: akpm@linux-foundation.org
Subject: + wistron_btns-generic-keymap.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:49:24 -0800
Message-ID: <200703151849.l2FInQDh023268@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35453 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbXCOStf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:49:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Eric.Piel@tremplin-utc.net, dtor@mail.ru, eric.piel@tremplin-utc.net


The patch titled
     wistron_btns: Generic keymap
has been added to the -mm tree.  Its filename is
     wistron_btns-generic-keymap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wistron_btns: Generic keymap
From: Eric Piel <Eric.Piel@tremplin-utc.net>

It turns out that the mapping of the wistron code is always the same, the
main present.  Therefore it's possible to write a generic keymap which
would allow the use of unknown keyboard.  The user can select it specifying
the parameter "keymap=generic".

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/wistron_btns.c |   42 ++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff -puN drivers/input/misc/wistron_btns.c~wistron_btns-generic-keymap drivers/input/misc/wistron_btns.c
--- a/drivers/input/misc/wistron_btns.c~wistron_btns-generic-keymap
+++ a/drivers/input/misc/wistron_btns.c
@@ -58,7 +58,7 @@ MODULE_PARM_DESC(force, "Load even if co
 
 static char *keymap_name; /* = NULL; */
 module_param_named(keymap, keymap_name, charp, 0);
-MODULE_PARM_DESC(keymap, "Keymap name, if it can't be autodetected");
+MODULE_PARM_DESC(keymap, "Keymap name, if it can't be autodetected [generic, 1557/MS2141]");
 
 static struct platform_device *wistron_device;
 
@@ -562,6 +562,42 @@ static struct key_entry keymap_wistron_m
 	{ KE_END, FE_UNTESTED }
 };
 
+static struct key_entry keymap_wistron_generic[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x03, KEY_POWER },
+	{ KE_KEY, 0x05, KEY_MEDIA }, /* Display switch */
+	{ KE_KEY, 0x06, KEY_SCREEN }, /* Display on/off */
+	{ KE_KEY, 0x08, KEY_MUTE },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_PROG3 },
+	{ KE_KEY, 0x14, KEY_MAIL },
+	{ KE_KEY, 0x15, KEY_WWW },
+	{ KE_KEY, 0x20, KEY_VOLUMEUP },
+	{ KE_KEY, 0x21, KEY_VOLUMEDOWN },
+	{ KE_KEY, 0x22, KEY_REWIND },
+	{ KE_KEY, 0x23, KEY_FORWARD },
+	{ KE_KEY, 0x24, KEY_PLAYPAUSE },
+	{ KE_KEY, 0x25, KEY_STOPCD },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x37, KEY_SCREEN }, /* Display on/off */
+	{ KE_KEY, 0x40, KEY_WLAN },
+	{ KE_KEY, 0x49, KEY_CONFIG },
+	{ KE_KEY, 0x4a, KEY_CLOSE }, /* lid close */
+	{ KE_KEY, 0x4b, KEY_OPEN }, /* lid open */
+	{ KE_KEY, 0x6a, KEY_CONFIG },
+	{ KE_KEY, 0x6d, KEY_POWER },
+	{ KE_KEY, 0x71, KEY_STOPCD },
+	{ KE_KEY, 0x72, KEY_PLAYPAUSE },
+	{ KE_KEY, 0x74, KEY_REWIND },
+	{ KE_KEY, 0x78, KEY_FORWARD },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_BLUETOOTH, 0x44, 0 },
+	{ KE_END, 0 }
+};
+
 /*
  * If your machine is not here (which is currently rather likely), please send
  * a list of buttons and their key codes (reported when loading this module
@@ -880,15 +916,17 @@ static struct dmi_system_id dmi_ids[] __
 
 static int __init select_keymap(void)
 {
+	dmi_check_system(dmi_ids);
 	if (keymap_name != NULL) {
 		if (strcmp (keymap_name, "1557/MS2141") == 0)
 			keymap = keymap_wistron_ms2141;
+		else if (strcmp (keymap_name, "generic") == 0)
+			keymap = keymap_wistron_generic;
 		else {
 			printk(KERN_ERR "wistron_btns: Keymap unknown\n");
 			return -EINVAL;
 		}
 	}
-	dmi_check_system(dmi_ids);
 	if (keymap == NULL) {
 		if (!force) {
 			printk(KERN_ERR "wistron_btns: System unknown\n");
_

Patches currently in -mm which might be from Eric.Piel@tremplin-utc.net are

wriston_btns-add-acerhk-laptop-database.patch
wistron_btns-generic-keymap.patch

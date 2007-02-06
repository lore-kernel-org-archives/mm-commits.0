From: akpm@linux-foundation.org
Subject: + wistron-button-support-for-fujitsu-siemens-amilo-d88x0.patch added to -mm tree
Date: Tue, 06 Feb 2007 15:07:09 -0800
Message-ID: <200702062307.l16N79kV032085@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54689 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030531AbXBFXHe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 18:07:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ml@newton.leun.net, dtor@mail.ru, mitr@volny.cz


The patch titled
     wistron button support for fujitsu-siemens Amilo D88x0
has been added to the -mm tree.  Its filename is
     wistron-button-support-for-fujitsu-siemens-amilo-d88x0.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wistron button support for fujitsu-siemens Amilo D88x0
From: Michael Leun <ml@newton.leun.net>

Works just fine for me on a Amilo D8820.

Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Miloslav Trmac <mitr@volny.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/wistron_btns.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+)

diff -puN drivers/input/misc/wistron_btns.c~wistron-button-support-for-fujitsu-siemens-amilo-d88x0 drivers/input/misc/wistron_btns.c
--- a/drivers/input/misc/wistron_btns.c~wistron-button-support-for-fujitsu-siemens-amilo-d88x0
+++ a/drivers/input/misc/wistron_btns.c
@@ -335,6 +335,17 @@ static struct key_entry keymap_aopen_155
 	{ KE_END,  0 },
 };
 
+static struct key_entry keymap_fs_amilo_d88x0[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x08, KEY_MUTE },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_PROG3 },
+	{ KE_END, 0 }
+};
+
 /*
  * If your machine is not here (which is currently rather likely), please send
  * a list of buttons and their key codes (reported when loading this module
@@ -413,6 +424,15 @@ static struct dmi_system_id dmi_ids[] __
 		},
 		.driver_data = keymap_wistron_ms2111
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Fujitsu Siemens Amilo D88x0",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO D"),
+		},
+		.driver_data = keymap_fs_amilo_d88x0
+	},
 	{ NULL, }
 };
 
_

Patches currently in -mm which might be from ml@newton.leun.net are

wistron-button-support-for-fujitsu-siemens-amilo-d88x0.patch

From: akpm@linux-foundation.org
Subject: - wriston_btns-add-acerhk-laptop-database.patch removed from -mm tree
Date: Mon, 19 Mar 2007 14:13:11 -0700
Message-ID: <200703192113.l2JLDBNh017393@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56610 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833AbXCSVNZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 17:13:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Eric.Piel@tremplin-utc.net, dtor@mail.ru, eric.piel@tremplin-utc.net, mm-commits@vger.kernel.org


The patch titled
     wriston_btns: Add acerhk laptop database
has been removed from the -mm tree.  Its filename was
     wriston_btns-add-acerhk-laptop-database.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: wriston_btns: Add acerhk laptop database
From: Eric Piel <Eric.Piel@tremplin-utc.net>

acerhk supports already a lot of laptops.  Lets import its database so that
everyone can benefit of the work of Olaf Tauber.  Only the "tm_new" laptops
were imported.  "tm_old" laptops could be possible but requires more
testing and probably only few laptops are still alive.  "dritek" laptops
should probably be imported into a different driver.  Also compress the
keymaps by fitting each entry on an int.  Most of the dmi matching was
written based on google searches, so it's rather prone to errors.  That's
why I'm asking people to confirm it works.

This adds the following hardware:
Acer TravelMate 370
Acer TravelMate 380
Acer TravelMate C300
Acer TravelMate C100
Acer TravelMate C110
Acer TravelMate 250
Acer TravelMate 350
Acer TravelMate 620
Acer TravelMate 630
Acer TravelMate 220
Acer TravelMate 230
Acer TravelMate 260
Acer TravelMate 280
Acer TravelMate 360
Acer TravelMate 2100
Acer TravelMate 2410
Acer Aspire 1500
Acer Aspire 1600
Acer Aspire 3020
Acer Aspire 5020
Medion MD 2900
Medion MD 40100
Medion MD 95400
Medion MD 96500
Fujitsu Siemens Amilo 7820

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/wistron_btns.c |  438 +++++++++++++++++++++++++++-
 1 file changed, 431 insertions(+), 7 deletions(-)

diff -puN drivers/input/misc/wistron_btns.c~wriston_btns-add-acerhk-laptop-database drivers/input/misc/wistron_btns.c
--- a/drivers/input/misc/wistron_btns.c~wriston_btns-add-acerhk-laptop-database
+++ a/drivers/input/misc/wistron_btns.c
@@ -233,11 +233,15 @@ static void bios_set_state(u8 subsys, in
 struct key_entry {
 	char type;		/* See KE_* below */
 	u8 code;
-	unsigned keycode;	/* For KE_KEY */
+	u16 keycode;		/* For KE_KEY */
 };
 
 enum { KE_END, KE_KEY, KE_WIFI, KE_BLUETOOTH };
 
+#define FE_MAIL_LED 0x01
+#define FE_WIFI_LED 0x02
+#define FE_UNTESTED 0x80
+
 static const struct key_entry *keymap; /* = NULL; Current key map */
 static int have_wifi;
 static int have_bluetooth;
@@ -288,7 +292,16 @@ static struct key_entry keymap_wistron_m
 	{ KE_KEY,  0x13, KEY_PROG3 },
 	{ KE_KEY,  0x31, KEY_MAIL },
 	{ KE_KEY,  0x36, KEY_WWW },
-	{ KE_END,  0 }
+	{ KE_END, FE_MAIL_LED }
+};
+
+static struct key_entry keymap_wistron_md40100[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x37, KEY_SCREEN }, /* Display on/off */
+	{ KE_END, FE_MAIL_LED | FE_WIFI_LED | FE_UNTESTED }
 };
 
 static struct key_entry keymap_wistron_ms2141[] = {
@@ -305,23 +318,163 @@ static struct key_entry keymap_wistron_m
 };
 
 static struct key_entry keymap_acer_aspire_1500[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x03, KEY_POWER },
 	{ KE_KEY, 0x11, KEY_PROG1 },
 	{ KE_KEY, 0x12, KEY_PROG2 },
 	{ KE_WIFI, 0x30, 0 },
 	{ KE_KEY, 0x31, KEY_MAIL },
 	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x49, KEY_CONFIG },
 	{ KE_BLUETOOTH, 0x44, 0 },
-	{ KE_END, 0 }
+	{ KE_END, FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_aspire_1600[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x03, KEY_POWER },
+	{ KE_KEY, 0x08, KEY_MUTE },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_PROG3 },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x49, KEY_CONFIG },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_BLUETOOTH, 0x44, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
+};
+
+/* 3020 has been tested */
+static struct key_entry keymap_acer_aspire_5020[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x03, KEY_POWER },
+	{ KE_KEY, 0x05, KEY_MEDIA }, /* Display switch */
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x6a, KEY_CONFIG },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_BLUETOOTH, 0x44, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_travelmate_2410[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x6d, KEY_POWER },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x6a, KEY_CONFIG },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_BLUETOOTH, 0x44, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_travelmate_110[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x03, KEY_POWER },
+	{ KE_KEY, 0x08, KEY_MUTE },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x20, KEY_VOLUMEUP },
+	{ KE_KEY, 0x21, KEY_VOLUMEDOWN },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x4a, KEY_CLOSE }, /* lid close */
+	{ KE_KEY, 0x4b, KEY_OPEN }, /* lid open */
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_travelmate_300[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x03, KEY_POWER },
+	{ KE_KEY, 0x08, KEY_MUTE },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x20, KEY_VOLUMEUP },
+	{ KE_KEY, 0x21, KEY_VOLUMEDOWN },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_BLUETOOTH, 0x44, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_travelmate_380[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x03, KEY_POWER }, /* TM370 doesn't have this one */
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_PROG3 },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
+};
+
+/* unusual map */
+static struct key_entry keymap_acer_travelmate_220[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x11, KEY_MAIL },
+	{ KE_KEY, 0x12, KEY_WWW },
+	{ KE_KEY, 0x13, KEY_PROG2 },
+	{ KE_KEY, 0x31, KEY_PROG1 },
+	{ KE_END, FE_WIFI_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_travelmate_230[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_END, FE_WIFI_LED | FE_UNTESTED }
 };
 
 static struct key_entry keymap_acer_travelmate_240[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x03, KEY_POWER },
+	{ KE_KEY, 0x08, KEY_MUTE },
 	{ KE_KEY, 0x31, KEY_MAIL },
 	{ KE_KEY, 0x36, KEY_WWW },
 	{ KE_KEY, 0x11, KEY_PROG1 },
 	{ KE_KEY, 0x12, KEY_PROG2 },
 	{ KE_BLUETOOTH, 0x44, 0 },
 	{ KE_WIFI, 0x30, 0 },
-	{ KE_END, 0 }
+	{ KE_END, FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_travelmate_350[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_MAIL },
+	{ KE_KEY, 0x14, KEY_PROG3 },
+	{ KE_KEY, 0x15, KEY_WWW },
+	{ KE_END, FE_MAIL_LED | FE_WIFI_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_travelmate_360[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_MAIL },
+	{ KE_KEY, 0x14, KEY_PROG3 },
+	{ KE_KEY, 0x15, KEY_WWW },
+	{ KE_KEY, 0x40, KEY_WLAN },
+	{ KE_END, FE_WIFI_LED | FE_UNTESTED } /* no mail led */
 };
 
 /* Wifi subsystem only activates the led. Therefore we need to pass
@@ -335,8 +488,24 @@ static struct key_entry keymap_acer_trav
 	{ KE_KEY, 0x13, KEY_PROG3 },
 	{ KE_KEY, 0x14, KEY_MAIL },
 	{ KE_KEY, 0x15, KEY_WWW },
-	{ KE_KEY, 0x40, KEY_WLAN }, /* Wifi */
-	{ KE_END, 0 }
+	{ KE_KEY, 0x40, KEY_WLAN },
+	{ KE_END, FE_MAIL_LED | FE_WIFI_LED }
+};
+
+static struct key_entry keymap_acer_travelmate_630[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x03, KEY_POWER },
+	{ KE_KEY, 0x08, KEY_MUTE }, /* not 620 */
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_PROG3 },
+	{ KE_KEY, 0x20, KEY_VOLUMEUP },
+	{ KE_KEY, 0x21, KEY_VOLUMEDOWN },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
 };
 
 static struct key_entry keymap_aopen_1559as[] = {
@@ -358,7 +527,39 @@ static struct key_entry keymap_fs_amilo_
 	{ KE_KEY, 0x11, KEY_PROG1 },
 	{ KE_KEY, 0x12, KEY_PROG2 },
 	{ KE_KEY, 0x13, KEY_PROG3 },
-	{ KE_END, 0 }
+	{ KE_END, FE_MAIL_LED | FE_WIFI_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_wistron_md2900[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_wistron_md96500[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x05, KEY_MEDIA }, /* Display switch */
+	{ KE_KEY, 0x06, KEY_SCREEN }, /* Display on/off */
+	{ KE_KEY, 0x08, KEY_MUTE },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x20, KEY_VOLUMEUP },
+	{ KE_KEY, 0x21, KEY_VOLUMEDOWN },
+	{ KE_KEY, 0x22, KEY_REWIND },
+	{ KE_KEY, 0x23, KEY_FORWARD },
+	{ KE_KEY, 0x24, KEY_PLAYPAUSE },
+	{ KE_KEY, 0x25, KEY_STOPCD },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_BLUETOOTH, 0x44, 0 },
+	{ KE_END, FE_UNTESTED }
 };
 
 /*
@@ -405,6 +606,133 @@ static struct dmi_system_id dmi_ids[] __
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Acer Aspire 1600",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1600"),
+		},
+		.driver_data = keymap_acer_aspire_1600
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer Aspire 3020",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 3020"),
+		},
+		.driver_data = keymap_acer_aspire_5020
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer Aspire 5020",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5020"),
+		},
+		.driver_data = keymap_acer_aspire_5020
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 2100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 2100"),
+		},
+		.driver_data = keymap_acer_aspire_5020
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 2410",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 2410"),
+		},
+		.driver_data = keymap_acer_travelmate_2410
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate C300",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate C300"),
+		},
+		.driver_data = keymap_acer_travelmate_300
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate C100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate C100"),
+		},
+		.driver_data = keymap_acer_travelmate_300
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate C110",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate C110"),
+		},
+		.driver_data = keymap_acer_travelmate_110
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 380",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 380"),
+		},
+		.driver_data = keymap_acer_travelmate_380
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 370",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 370"),
+		},
+		.driver_data = keymap_acer_travelmate_380 /* keyboard minus 1 key */
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 220",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 220"),
+		},
+		.driver_data = keymap_acer_travelmate_220
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 260",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 260"),
+		},
+		.driver_data = keymap_acer_travelmate_220
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 230",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 230"),
+			/* acerhk looks for "TravelMate F4..." ?! */
+		},
+		.driver_data = keymap_acer_travelmate_230
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 280",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 280"),
+		},
+		.driver_data = keymap_acer_travelmate_230
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Acer TravelMate 240",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
@@ -414,6 +742,15 @@ static struct dmi_system_id dmi_ids[] __
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Acer TravelMate 250",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 250"),
+		},
+		.driver_data = keymap_acer_travelmate_240
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Acer TravelMate 2424NWXCi",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
@@ -423,6 +760,24 @@ static struct dmi_system_id dmi_ids[] __
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Acer TravelMate 350",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 350"),
+		},
+		.driver_data = keymap_acer_travelmate_350
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 360",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 360"),
+		},
+		.driver_data = keymap_acer_travelmate_360
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Acer TravelMate 610",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ACER"),
@@ -432,6 +787,24 @@ static struct dmi_system_id dmi_ids[] __
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Acer TravelMate 620",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 620"),
+		},
+		.driver_data = keymap_acer_travelmate_630
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 630",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 630"),
+		},
+		.driver_data = keymap_acer_travelmate_630
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "AOpen 1559AS",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "E2U"),
@@ -450,6 +823,51 @@ static struct dmi_system_id dmi_ids[] __
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Medion MD 40100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDIONNB"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "WID2000"),
+		},
+		.driver_data = keymap_wistron_md40100
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Medion MD 2900",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDIONNB"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "WIM 2000"),
+		},
+		.driver_data = keymap_wistron_md2900
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Medion MD 96500",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDIONPC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "WIM 2040"),
+		},
+		.driver_data = keymap_wistron_md96500
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Medion MD 95400",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDIONPC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "WIM 2050"),
+		},
+		.driver_data = keymap_wistron_md96500
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Fujitsu Siemens Amilo D7820",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"), /* not sure */
+			DMI_MATCH(DMI_PRODUCT_NAME, "Amilo D"),
+		},
+		.driver_data = keymap_fs_amilo_d88x0
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Fujitsu Siemens Amilo D88x0",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
@@ -506,6 +924,12 @@ static int __devinit setup_input_dev(voi
 		}
 	}
 
+	/* reads information flags on KE_END */
+	if (key->code & FE_UNTESTED)
+		printk(KERN_WARNING "Untested laptop multimedia keys, "
+			"please report success or failure to eric.piel"
+			"@tremplin-utc.net\n");
+
 	error = input_register_device(input_dev);
 	if (error) {
 		input_free_device(input_dev);
_

Patches currently in -mm which might be from Eric.Piel@tremplin-utc.net are

wriston_btns-add-acerhk-laptop-database.patch
wistron_btns-generic-keymap.patch

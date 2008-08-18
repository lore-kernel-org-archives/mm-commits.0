From: akpm@linux-foundation.org
Subject: - abituguru3-prefer-dmi-probing-to-manual-probing.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:04 -0700
Message-ID: <200808181940.m7IJe4nk008421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763498AbYHRTu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:50:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alistair@devzero.co.uk, j.w.r.degoede@hhs.nl, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     abituguru3: prefer DMI probing to manual probing
has been removed from the -mm tree.  Its filename was
     abituguru3-prefer-dmi-probing-to-manual-probing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: abituguru3: prefer DMI probing to manual probing
From: Alistair John Strachan <alistair@devzero.co.uk>

Previously the driver was only using DMI to prevent smbus probing on
non-Abit motherboards.  However, since the manual probing method is
brittle and prone to failure on some Abit motherboards (esp.  the Abit
IP35 Pro) it is better to use DMI to also read the board name and then
decide whether or not to probe the bus.

At the moment, we do not have a list of valid DMI name strings to use for
existing and supported motherboards.  This patch only implements DMI
probing for the IP35 Pro.  For motherboards that can not yet use DMI
probing, a warning will be printed to the kernel log asking those users to
email me their dmidecode output.

The existing manual probing mechanism will be used if CONFIG_DMI is not
enabled, if DMI probing fails (for DMI-unsupported motherboards), or if
DMI probing fails and the "force" option is set (for DMI-supported
motherboards).  Ideally in the longer term this manual probing method
would be removed.

This patch should be safe to apply as it does not change the probing
behaviour for most of the supported motherboards, just the IP35 Pro, which
already has regressions filed against it in 2.6.26.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11212

Signed-off-by: Alistair John Strachan <alistair@devzero.co.uk>
Acked-by: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/abituguru3.c |  132 ++++++++++++++++++++++++-----------
 1 file changed, 93 insertions(+), 39 deletions(-)

diff -puN drivers/hwmon/abituguru3.c~abituguru3-prefer-dmi-probing-to-manual-probing drivers/hwmon/abituguru3.c
--- a/drivers/hwmon/abituguru3.c~abituguru3-prefer-dmi-probing-to-manual-probing
+++ a/drivers/hwmon/abituguru3.c
@@ -1,5 +1,8 @@
 /*
-    abituguru3.c Copyright (c) 2006 Hans de Goede <j.w.r.degoede@hhs.nl>
+    abituguru3.c
+
+    Copyright (c) 2006-2008 Hans de Goede <j.w.r.degoede@hhs.nl>
+    Copyright (c) 2008 Alistair John Strachan <alistair@devzero.co.uk>
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
@@ -116,7 +119,7 @@ struct abituguru3_sensor_info {
 
 struct abituguru3_motherboard_info {
 	u16 id;
-	const char *name;
+	const char *dmi_name;
 	/* + 1 -> end of sensors indicated by a sensor with name == NULL */
 	struct abituguru3_sensor_info sensors[ABIT_UGURU3_MAX_NO_SENSORS + 1];
 };
@@ -161,7 +164,7 @@ struct abituguru3_data {
 
 /* Constants */
 static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
-	{ 0x000C, "unknown", {
+	{ 0x000C, NULL /* Unknown, need DMI string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -183,7 +186,7 @@ static const struct abituguru3_motherboa
 		{ "AUX1 Fan",		35, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x000D, "Abit AW8", {
+	{ 0x000D, NULL /* Abit AW8, need DMI string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -212,7 +215,7 @@ static const struct abituguru3_motherboa
 		{ "AUX5 Fan",		39, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x000E, "AL-8", {
+	{ 0x000E, NULL /* AL-8, need DMI string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -233,7 +236,7 @@ static const struct abituguru3_motherboa
 		{ "SYS Fan",		34, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x000F, "unknown", {
+	{ 0x000F, NULL /* Unknown, need DMI string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -254,7 +257,7 @@ static const struct abituguru3_motherboa
 		{ "SYS Fan",		34, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x0010, "Abit NI8 SLI GR", {
+	{ 0x0010, NULL /* Abit NI8 SLI GR, need DMI string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -276,7 +279,7 @@ static const struct abituguru3_motherboa
 		{ "OTES1 Fan",		36, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x0011, "Abit AT8 32X", {
+	{ 0x0011, NULL /* Abit AT8 32X, need DMI string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 20, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -302,7 +305,7 @@ static const struct abituguru3_motherboa
 		{ "AUX2 Fan",		36, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x0012, "Abit AN8 32X", {
+	{ 0x0012, NULL /* Abit AN8 32X, need DMI string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 20, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -324,7 +327,7 @@ static const struct abituguru3_motherboa
 		{ "AUX1 Fan",		36, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x0013, "Abit AW8D", {
+	{ 0x0013, NULL /* Abit AW8D, need DMI string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -353,7 +356,7 @@ static const struct abituguru3_motherboa
 		{ "AUX5 Fan",		39, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x0014, "Abit AB9 Pro", {
+	{ 0x0014, NULL /* Abit AB9 Pro, need DMI string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 10, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -374,7 +377,7 @@ static const struct abituguru3_motherboa
 		{ "SYS Fan",		34, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x0015, "unknown", {
+	{ 0x0015, NULL /* Unknown, need DMI string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR",		 1, 0, 20, 1, 0 },
 		{ "DDR VTT",		 2, 0, 10, 1, 0 },
@@ -398,7 +401,7 @@ static const struct abituguru3_motherboa
 		{ "AUX3 Fan",		36, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x0016, "AW9D-MAX", {
+	{ 0x0016, NULL /* AW9D-MAX, need DMI string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR2",		 1, 0, 20, 1, 0 },
 		{ "DDR2 VTT",		 2, 0, 10, 1, 0 },
@@ -426,7 +429,7 @@ static const struct abituguru3_motherboa
 		{ "OTES1 Fan",		38, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x0017, "unknown", {
+	{ 0x0017, NULL /* Unknown, need DMI string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR2",		 1, 0, 20, 1, 0 },
 		{ "DDR2 VTT",		 2, 0, 10, 1, 0 },
@@ -451,7 +454,7 @@ static const struct abituguru3_motherboa
 		{ "AUX3 FAN",		37, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x0018, "unknown", {
+	{ 0x0018, NULL /* Unknown, need DMI string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR2",		 1, 0, 20, 1, 0 },
 		{ "DDR2 VTT",		 2, 0, 10, 1, 0 },
@@ -478,7 +481,7 @@ static const struct abituguru3_motherboa
 		{ "AUX3 Fan",		36, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x0019, "unknown", {
+	{ 0x0019, NULL /* Unknown, need DMI string */, {
 		{ "CPU Core",		 7, 0, 10, 1, 0 },
 		{ "DDR2",		13, 0, 20, 1, 0 },
 		{ "DDR2 VTT",		14, 0, 10, 1, 0 },
@@ -505,7 +508,7 @@ static const struct abituguru3_motherboa
 		{ "AUX3 FAN",		36, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x001A, "Abit IP35 Pro", {
+	{ 0x001A, "IP35 Pro(Intel P35-ICH9R)", {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR2",		 1, 0, 20, 1, 0 },
 		{ "DDR2 VTT",		 2, 0, 10, 1, 0 },
@@ -533,7 +536,7 @@ static const struct abituguru3_motherboa
 		{ "AUX4 Fan",		37, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x001B, "unknown", {
+	{ 0x001B, NULL /* Unknown, need DMI string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR3",		 1, 0, 20, 1, 0 },
 		{ "DDR3 VTT",		 2, 0, 10, 1, 0 },
@@ -560,7 +563,7 @@ static const struct abituguru3_motherboa
 		{ "AUX3 Fan",		36, 2, 60, 1, 0 },
 		{ NULL, 0, 0, 0, 0, 0 } }
 	},
-	{ 0x001C, "unknown", {
+	{ 0x001C, NULL /* Unknown, need DMI string */, {
 		{ "CPU Core",		 0, 0, 10, 1, 0 },
 		{ "DDR2",		 1, 0, 20, 1, 0 },
 		{ "DDR2 VTT",		 2, 0, 10, 1, 0 },
@@ -935,9 +938,18 @@ static int __devinit abituguru3_probe(st
 		goto abituguru3_probe_error;
 	}
 	data->sensors = abituguru3_motherboards[i].sensors;
+
 	printk(KERN_INFO ABIT_UGURU3_NAME ": found Abit uGuru3, motherboard "
-		"ID: %04X (%s)\n", (unsigned int)id,
-		abituguru3_motherboards[i].name);
+		"ID: %04X\n", (unsigned int)id);
+
+#ifdef CONFIG_DMI
+	if (!abituguru3_motherboards[i].dmi_name) {
+		printk(KERN_WARNING ABIT_UGURU3_NAME ": this motherboard was "
+			"not detected using DMI. Please send the output of "
+			"\"dmidecode\" to the abituguru3 maintainer"
+			"(see MAINTAINERS)\n");
+	}
+#endif
 
 	/* Fill the sysfs attr array */
 	sysfs_attr_i = 0;
@@ -1109,6 +1121,46 @@ static struct platform_driver abituguru3
 	.resume = abituguru3_resume
 };
 
+#ifdef CONFIG_DMI
+
+static int __init abituguru3_dmi_detect(void)
+{
+	const char *board_vendor, *board_name;
+	int i, err = (force) ? 1 : -ENODEV;
+
+	board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
+	if (!board_vendor || strcmp(board_vendor, "http://www.abit.com.tw/"))
+		return err;
+
+	board_name = dmi_get_system_info(DMI_BOARD_NAME);
+	if (!board_name)
+		return err;
+
+	for (i = 0; abituguru3_motherboards[i].id; i++) {
+		const char *dmi_name = abituguru3_motherboards[i].dmi_name;
+		if (dmi_name && !strcmp(dmi_name, board_name))
+			break;
+	}
+
+	if (!abituguru3_motherboards[i].id)
+		return 1;
+
+	return 0;
+}
+
+#else /* !CONFIG_DMI */
+
+static inline int abituguru3_dmi_detect(void)
+{
+	return -ENODEV;
+}
+
+#endif /* CONFIG_DMI */
+
+/* FIXME: Manual detection should die eventually; we need to collect stable
+ *        DMI model names first before we can rely entirely on CONFIG_DMI.
+ */
+
 static int __init abituguru3_detect(void)
 {
 	/* See if there is an uguru3 there. An idle uGuru3 will hold 0x00 or
@@ -1119,7 +1171,7 @@ static int __init abituguru3_detect(void
 	if (((data_val == 0x00) || (data_val == 0x08)) &&
 			((cmd_val == 0xAC) || (cmd_val == 0x05) ||
 			 (cmd_val == 0x55)))
-		return ABIT_UGURU3_BASE;
+		return 0;
 
 	ABIT_UGURU3_DEBUG("no Abit uGuru3 found, data = 0x%02X, cmd = "
 		"0x%02X\n", (unsigned int)data_val, (unsigned int)cmd_val);
@@ -1127,7 +1179,7 @@ static int __init abituguru3_detect(void
 	if (force) {
 		printk(KERN_INFO ABIT_UGURU3_NAME ": Assuming Abit uGuru3 is "
 				"present because of \"force\" parameter\n");
-		return ABIT_UGURU3_BASE;
+		return 0;
 	}
 
 	/* No uGuru3 found */
@@ -1138,27 +1190,29 @@ static struct platform_device *abituguru
 
 static int __init abituguru3_init(void)
 {
-	int address, err;
 	struct resource res = { .flags = IORESOURCE_IO };
+	int err;
 
-#ifdef CONFIG_DMI
-	const char *board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
-
-	/* safety check, refuse to load on non Abit motherboards */
-	if (!force && (!board_vendor ||
-			strcmp(board_vendor, "http://www.abit.com.tw/")))
-		return -ENODEV;
-#endif
-
-	address = abituguru3_detect();
-	if (address < 0)
-		return address;
+	/* Attempt DMI detection first */
+	err = abituguru3_dmi_detect();
+	if (err < 0)
+		return err;
+
+	/* Fall back to manual detection if there was no exact
+	 * board name match, or force was specified.
+	 */
+	if (err > 0) {
+		err = abituguru3_detect();
+		if (err)
+			return err;
+	}
 
 	err = platform_driver_register(&abituguru3_driver);
 	if (err)
 		goto exit;
 
-	abituguru3_pdev = platform_device_alloc(ABIT_UGURU3_NAME, address);
+	abituguru3_pdev = platform_device_alloc(ABIT_UGURU3_NAME,
+						ABIT_UGURU3_BASE);
 	if (!abituguru3_pdev) {
 		printk(KERN_ERR ABIT_UGURU3_NAME
 			": Device allocation failed\n");
@@ -1166,8 +1220,8 @@ static int __init abituguru3_init(void)
 		goto exit_driver_unregister;
 	}
 
-	res.start = address;
-	res.end = address + ABIT_UGURU3_REGION_LENGTH - 1;
+	res.start = ABIT_UGURU3_BASE;
+	res.end = ABIT_UGURU3_BASE + ABIT_UGURU3_REGION_LENGTH - 1;
 	res.name = ABIT_UGURU3_NAME;
 
 	err = platform_device_add_resources(abituguru3_pdev, &res, 1);
_

Patches currently in -mm which might be from alistair@devzero.co.uk are

origin.patch


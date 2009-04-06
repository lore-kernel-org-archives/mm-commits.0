From: akpm@linux-foundation.org
Subject: [wrecked] thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:25:13 -0700
Message-ID: <200904061925.n36JPDAW008026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276AbZDFTak (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:30:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, hmh@hmh.eng.br, hpa@zytor.com, mingo@elte.hu, rpurdie@rpsys.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     thinkpad-acpi: split delayed LEDs stuff, clean up code
has been removed from the -mm tree.  Its filename was
     thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thinkpad-acpi: split delayed LEDs stuff, clean up code
From: Pavel Machek <pavel@suse.cz>

Reduce code duplication and clean up thinkpad_acpi a bit.  In future, I'd
like to make delayed-leds.h to be useful for HP accelerometer driver (and
move to drivers/leds, of course)...

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/delayed-leds.h  |   39 ++++++++++
 drivers/platform/x86/thinkpad_acpi.c |   96 +++++++------------------
 2 files changed, 68 insertions(+), 67 deletions(-)

diff -puN /dev/null drivers/platform/x86/delayed-leds.h
--- /dev/null
+++ a/drivers/platform/x86/delayed-leds.h
@@ -0,0 +1,39 @@
+/*
+ *  delayed-leds.h - LEDs that can't be set from atomic context
+ *
+ *
+ *  Copyright (C) 2004-2005 Borislav Deianov <borislav@users.sf.net>
+ *  Copyright (C) 2006-2008 Henrique de Moraes Holschuh <hmh@hmh.eng.br>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ */
+
+/* Special LED class that can defer work */
+struct delayed_led_classdev {
+	struct led_classdev led_classdev;
+	struct work_struct work;
+	enum led_brightness new_brightness;
+
+	unsigned int led;		/* For driver */
+	int (*set_status)(struct delayed_led_classdev *data);
+};
+
+static void delayed_set_status_worker(struct work_struct *work)
+{
+	struct delayed_led_classdev *data =
+			container_of(work, struct delayed_led_classdev, work);
+
+	data->set_status(data);
+}
+
+static void delayed_sysfs_set(struct led_classdev *led_cdev,
+			      enum led_brightness brightness)
+{
+	struct delayed_led_classdev *data = container_of(led_cdev,
+			     struct delayed_led_classdev, led_classdev);
+	data->new_brightness = brightness;
+	queue_work(tpacpi_wq, &data->work);
+}
diff -puN drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-split-delayed-leds-stuff-clean-up-code drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-split-delayed-leds-stuff-clean-up-code
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -79,7 +79,6 @@
 
 #include <linux/pci_ids.h>
 
-
 /* ThinkPad CMOS commands */
 #define TP_CMOS_VOLUME_DOWN	0
 #define TP_CMOS_VOLUME_UP	1
@@ -306,13 +305,8 @@ static u32 dbg_level;
 
 static struct workqueue_struct *tpacpi_wq;
 
-/* Special LED class that can defer work */
-struct tpacpi_led_classdev {
-	struct led_classdev led_classdev;
-	struct work_struct work;
-	enum led_brightness new_brightness;
-	unsigned int led;
-};
+#include "delayed-leds.h"
+
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 static int dbg_wlswemul;
@@ -4031,9 +4025,13 @@ static int light_get_status(void)
 	return -ENXIO;
 }
 
-static int light_set_status(int status)
+static int light_set_status(struct delayed_led_classdev *data)
 {
 	int rc;
+	int status = (data->new_brightness != LED_OFF);
+
+	if (tpacpi_lifecycle != TPACPI_LIFE_RUNNING)
+		return -EINVAL;
 
 	if (tp_features.light) {
 		if (cmos_handle) {
@@ -4051,37 +4049,19 @@ static int light_set_status(int status)
 	return -ENXIO;
 }
 
-static void light_set_status_worker(struct work_struct *work)
-{
-	struct tpacpi_led_classdev *data =
-			container_of(work, struct tpacpi_led_classdev, work);
-
-	if (likely(tpacpi_lifecycle == TPACPI_LIFE_RUNNING))
-		light_set_status((data->new_brightness != LED_OFF));
-}
-
-static void light_sysfs_set(struct led_classdev *led_cdev,
-			enum led_brightness brightness)
-{
-	struct tpacpi_led_classdev *data =
-		container_of(led_cdev,
-			     struct tpacpi_led_classdev,
-			     led_classdev);
-	data->new_brightness = brightness;
-	queue_work(tpacpi_wq, &data->work);
-}
 
 static enum led_brightness light_sysfs_get(struct led_classdev *led_cdev)
 {
 	return (light_get_status() == 1)? LED_FULL : LED_OFF;
 }
 
-static struct tpacpi_led_classdev tpacpi_led_thinklight = {
+static struct delayed_led_classdev tpacpi_led_thinklight = {
 	.led_classdev = {
 		.name		= "tpacpi::thinklight",
-		.brightness_set	= &light_sysfs_set,
+		.brightness_set	= &delayed_sysfs_set,
 		.brightness_get	= &light_sysfs_get,
-	}
+	},
+	.set_status = light_set_status,
 };
 
 static int __init light_init(struct ibm_init_struct *iibm)
@@ -4093,7 +4073,7 @@ static int __init light_init(struct ibm_
 	TPACPI_ACPIHANDLE_INIT(ledb);
 	TPACPI_ACPIHANDLE_INIT(lght);
 	TPACPI_ACPIHANDLE_INIT(cmos);
-	INIT_WORK(&tpacpi_led_thinklight.work, light_set_status_worker);
+	INIT_WORK(&tpacpi_led_thinklight.work, delayed_set_status_worker);
 
 	/* light not supported on 570, 600e/x, 770e, 770x, G4x, R30, R31 */
 	tp_features.light = (cmos_handle || lght_handle) && !ledb_handle;
@@ -4169,7 +4149,8 @@ static int light_write(char *buf)
 			return -EINVAL;
 	}
 
-	return light_set_status(newstatus);
+	tpacpi_led_thinklight.new_brightness = newstatus;
+	return light_set_status(&tpacpi_led_thinklight);
 }
 
 static struct ibm_struct light_driver_data = {
@@ -4589,7 +4570,7 @@ TPACPI_HANDLE(led, ec, "SLED",	/* 570 */
 	   );			/* R30, R31 */
 
 #define TPACPI_LED_NUMLEDS 8
-static struct tpacpi_led_classdev *tpacpi_leds;
+static struct delayed_led_classdev *tpacpi_leds;
 static enum led_status_t tpacpi_led_state_cache[TPACPI_LED_NUMLEDS];
 static const char * const tpacpi_led_names[TPACPI_LED_NUMLEDS] = {
 	/* there's a limit of 19 chars + NULL before 2.6.26 */
@@ -4633,7 +4614,6 @@ static int led_set_status(const unsigned
 	/* off, on, blink. Index is led_status_t */
 	static const unsigned int led_sled_arg1[] = { 0, 1, 3 };
 	static const unsigned int led_led_arg1[] = { 0, 0x80, 0xc0 };
-
 	int rc = 0;
 
 	switch (led_supported) {
@@ -4673,40 +4653,21 @@ static int led_set_status(const unsigned
 	return rc;
 }
 
-static void led_sysfs_set_status(unsigned int led,
-				 enum led_brightness brightness)
+static int led_set_class_status(struct delayed_led_classdev *data)
 {
-	led_set_status(led,
-			(brightness == LED_OFF) ?
-			TPACPI_LED_OFF :
-			(tpacpi_led_state_cache[led] == TPACPI_LED_BLINK) ?
-				TPACPI_LED_BLINK : TPACPI_LED_ON);
-}
-
-static void led_set_status_worker(struct work_struct *work)
-{
-	struct tpacpi_led_classdev *data =
-		container_of(work, struct tpacpi_led_classdev, work);
-
-	if (likely(tpacpi_lifecycle == TPACPI_LIFE_RUNNING))
-		led_sysfs_set_status(data->led, data->new_brightness);
-}
-
-static void led_sysfs_set(struct led_classdev *led_cdev,
-			enum led_brightness brightness)
-{
-	struct tpacpi_led_classdev *data = container_of(led_cdev,
-			     struct tpacpi_led_classdev, led_classdev);
-
-	data->new_brightness = brightness;
-	queue_work(tpacpi_wq, &data->work);
+	if (tpacpi_lifecycle != TPACPI_LIFE_RUNNING)
+		return -EINVAL;
+	return led_set_status(data->led, (data->new_brightness == LED_OFF) ?
+		    TPACPI_LED_OFF :
+		    (tpacpi_led_state_cache[data->led] == TPACPI_LED_BLINK) ?
+			TPACPI_LED_BLINK : TPACPI_LED_ON);
 }
 
 static int led_sysfs_blink_set(struct led_classdev *led_cdev,
 			unsigned long *delay_on, unsigned long *delay_off)
 {
-	struct tpacpi_led_classdev *data = container_of(led_cdev,
-			     struct tpacpi_led_classdev, led_classdev);
+	struct delayed_led_classdev *data = container_of(led_cdev,
+			     struct delayed_led_classdev, led_classdev);
 
 	/* Can we choose the flash rate? */
 	if (*delay_on == 0 && *delay_off == 0) {
@@ -4726,8 +4687,8 @@ static enum led_brightness led_sysfs_get
 {
 	int rc;
 
-	struct tpacpi_led_classdev *data = container_of(led_cdev,
-			     struct tpacpi_led_classdev, led_classdev);
+	struct delayed_led_classdev *data = container_of(led_cdev,
+			     struct delayed_led_classdev, led_classdev);
 
 	rc = led_get_status(data->led);
 
@@ -4786,15 +4747,16 @@ static int __init led_init(struct ibm_in
 	for (i = 0; i < TPACPI_LED_NUMLEDS; i++) {
 		tpacpi_leds[i].led = i;
 
-		tpacpi_leds[i].led_classdev.brightness_set = &led_sysfs_set;
+		tpacpi_leds[i].led_classdev.brightness_set = &delayed_sysfs_set;
 		tpacpi_leds[i].led_classdev.blink_set = &led_sysfs_blink_set;
 		if (led_supported == TPACPI_LED_570)
 			tpacpi_leds[i].led_classdev.brightness_get =
 							&led_sysfs_get;
 
 		tpacpi_leds[i].led_classdev.name = tpacpi_led_names[i];
+		tpacpi_leds[i].set_status = led_set_class_status;
 
-		INIT_WORK(&tpacpi_leds[i].work, led_set_status_worker);
+		INIT_WORK(&tpacpi_leds[i].work, delayed_set_status_worker);
 
 		rc = led_classdev_register(&tpacpi_pdev->dev,
 					   &tpacpi_leds[i].led_classdev);
_

Patches currently in -mm which might be from pavel@suse.cz are

origin.patch
linux-next.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch


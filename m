From: akpm@linux-foundation.org
Subject: - eeepc-laptop-use-standard-interfaces.patch removed from -mm tree
Date: Tue, 19 Aug 2008 02:58:49 -0700
Message-ID: <200808190958.m7J9wnk0010603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370AbYHSKA1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 06:00:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, corentincj@iksaif.net, hmh@hmh.eng.br, mjg@redhat.com, sziwan@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     eeepc-laptop: use standard interfaces
has been removed from the -mm tree.  Its filename was
     eeepc-laptop-use-standard-interfaces.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eeepc-laptop: use standard interfaces
From: Matthew Garrett <mjg59@srcf.ucam.org>

eeepc-laptop currently only sends key events via ACPI and has non-standard
rfkill control.  Add an input device and use the rfkill infrastructure.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Karol Kozimor <sziwan@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/eeepc-laptop.c |  228 +++++++++++++++++++++++++++++++---
 1 file changed, 209 insertions(+), 19 deletions(-)

diff -puN drivers/misc/eeepc-laptop.c~eeepc-laptop-use-standard-interfaces drivers/misc/eeepc-laptop.c
--- a/drivers/misc/eeepc-laptop.c~eeepc-laptop-use-standard-interfaces
+++ a/drivers/misc/eeepc-laptop.c
@@ -28,6 +28,8 @@
 #include <acpi/acpi_drivers.h>
 #include <acpi/acpi_bus.h>
 #include <linux/uaccess.h>
+#include <linux/input.h>
+#include <linux/rfkill.h>
 
 #define EEEPC_LAPTOP_VERSION	"0.1"
 
@@ -125,6 +127,10 @@ struct eeepc_hotk {
 					   by this BIOS */
 	uint init_flag;			/* Init flags */
 	u16 event_count[128];		/* count for each event */
+	struct input_dev *inputdev;
+	u16 *keycode_map;
+	struct rfkill *eeepc_wlan_rfkill;
+	struct rfkill *eeepc_bluetooth_rfkill;
 };
 
 /* The actual device the driver binds to */
@@ -140,6 +146,27 @@ static struct platform_driver platform_d
 
 static struct platform_device *platform_device;
 
+struct key_entry {
+	char type;
+	u8 code;
+	u16 keycode;
+};
+
+enum { KE_KEY, KE_END };
+
+static struct key_entry eeepc_keymap[] = {
+	/* Sleep already handled via generic ACPI code */
+	{KE_KEY, 0x10, KEY_WLAN },
+	{KE_KEY, 0x12, KEY_PROG1 },
+	{KE_KEY, 0x13, KEY_MUTE },
+	{KE_KEY, 0x14, KEY_VOLUMEDOWN },
+	{KE_KEY, 0x15, KEY_VOLUMEUP },
+	{KE_KEY, 0x30, KEY_SWITCHVIDEOMODE },
+	{KE_KEY, 0x31, KEY_SWITCHVIDEOMODE },
+	{KE_KEY, 0x32, KEY_SWITCHVIDEOMODE },
+	{KE_END, 0},
+};
+
 /*
  * The hotkey driver declaration
  */
@@ -261,6 +288,44 @@ static int update_bl_status(struct backl
 }
 
 /*
+ * Rfkill helpers
+ */
+
+static int eeepc_wlan_rfkill_set(void *data, enum rfkill_state state)
+{
+	if (state == RFKILL_STATE_SOFT_BLOCKED)
+		return set_acpi(CM_ASL_WLAN, 0);
+	else
+		return set_acpi(CM_ASL_WLAN, 1);
+}
+
+static int eeepc_wlan_rfkill_state(void *data, enum rfkill_state *state)
+{
+	if (get_acpi(CM_ASL_WLAN) == 1)
+		*state = RFKILL_STATE_UNBLOCKED;
+	else
+		*state = RFKILL_STATE_SOFT_BLOCKED;
+	return 0;
+}
+
+static int eeepc_wlan_bluetooth_set(void *data, enum rfkill_state state)
+{
+	if (state == RFKILL_STATE_SOFT_BLOCKED)
+		return set_acpi(CM_ASL_BLUETOOTH, 0);
+	else
+		return set_acpi(CM_ASL_BLUETOOTH, 1);
+}
+
+static int eeepc_wlan_bluetooth_state(void *data, enum rfkill_state *state)
+{
+	if (get_acpi(CM_ASL_BLUETOOTH) == 1)
+		*state = RFKILL_STATE_UNBLOCKED;
+	else
+		*state = RFKILL_STATE_SOFT_BLOCKED;
+	return 0;
+}
+
+/*
  * Sys helpers
  */
 static int parse_arg(const char *buf, unsigned long count, int *val)
@@ -311,13 +376,11 @@ static ssize_t show_sys_acpi(int cm, cha
 EEEPC_CREATE_DEVICE_ATTR(camera, CM_ASL_CAMERA);
 EEEPC_CREATE_DEVICE_ATTR(cardr, CM_ASL_CARDREADER);
 EEEPC_CREATE_DEVICE_ATTR(disp, CM_ASL_DISPLAYSWITCH);
-EEEPC_CREATE_DEVICE_ATTR(wlan, CM_ASL_WLAN);
 
 static struct attribute *platform_attributes[] = {
 	&dev_attr_camera.attr,
 	&dev_attr_cardr.attr,
 	&dev_attr_disp.attr,
-	&dev_attr_wlan.attr,
 	NULL
 };
 
@@ -328,8 +391,64 @@ static struct attribute_group platform_a
 /*
  * Hotkey functions
  */
+static struct key_entry *eepc_get_entry_by_scancode(int code)
+{
+	struct key_entry *key;
+
+	for (key = eeepc_keymap; key->type != KE_END; key++)
+		if (code == key->code)
+			return key;
+
+	return NULL;
+}
+
+static struct key_entry *eepc_get_entry_by_keycode(int code)
+{
+	struct key_entry *key;
+
+	for (key = eeepc_keymap; key->type != KE_END; key++)
+		if (code == key->keycode && key->type == KE_KEY)
+			return key;
+
+	return NULL;
+}
+
+static int eeepc_getkeycode(struct input_dev *dev, int scancode, int *keycode)
+{
+	struct key_entry *key = eepc_get_entry_by_scancode(scancode);
+
+	if (key && key->type == KE_KEY) {
+		*keycode = key->keycode;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int eeepc_setkeycode(struct input_dev *dev, int scancode, int keycode)
+{
+	struct key_entry *key;
+	int old_keycode;
+
+	if (keycode < 0 || keycode > KEY_MAX)
+		return -EINVAL;
+
+	key = eepc_get_entry_by_scancode(scancode);
+	if (key && key->type == KE_KEY) {
+		old_keycode = key->keycode;
+		key->keycode = keycode;
+		set_bit(keycode, dev->keybit);
+		if (!eepc_get_entry_by_keycode(old_keycode))
+			clear_bit(old_keycode, dev->keybit);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 static int eeepc_hotk_check(void)
 {
+	const struct key_entry *key;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	int result;
 
@@ -356,6 +475,31 @@ static int eeepc_hotk_check(void)
 			       "Get control methods supported: 0x%x\n",
 			       ehotk->cm_supported);
 		}
+		ehotk->inputdev = input_allocate_device();
+		if (!ehotk->inputdev) {
+			printk(EEEPC_INFO "Unable to allocate input device\n");
+			return 0;
+		}
+		ehotk->inputdev->name = "Asus EeePC extra buttons";
+		ehotk->inputdev->phys = EEEPC_HOTK_FILE "/input0";
+		ehotk->inputdev->id.bustype = BUS_HOST;
+		ehotk->inputdev->getkeycode = eeepc_getkeycode;
+		ehotk->inputdev->setkeycode = eeepc_setkeycode;
+
+		for (key = eeepc_keymap; key->type != KE_END; key++) {
+			switch (key->type) {
+			case KE_KEY:
+				set_bit(EV_KEY, ehotk->inputdev->evbit);
+				set_bit(key->keycode, ehotk->inputdev->keybit);
+				break;
+			}
+		}
+		result = input_register_device(ehotk->inputdev);
+		if (result) {
+			printk(EEEPC_INFO "Unable to register input device\n");
+			input_free_device(ehotk->inputdev);
+			return 0;
+		}
 	} else {
 		printk(EEEPC_ERR "Hotkey device not present, aborting\n");
 		return -EINVAL;
@@ -363,21 +507,6 @@ static int eeepc_hotk_check(void)
 	return 0;
 }
 
-static void notify_wlan(u32 *event)
-{
-	/* if DISABLE_ASL_WLAN is set, the notify code for fn+f2
-	   will always be 0x10 */
-	if (ehotk->cm_supported & (0x1 << CM_ASL_WLAN)) {
-		const char *method = cm_getv[CM_ASL_WLAN];
-		int value;
-		if (read_acpi_int(ehotk->handle, method, &value))
-			printk(EEEPC_WARNING "Error reading %s\n",
-			       method);
-		else if (value == 1)
-			*event = 0x11;
-	}
-}
-
 static void notify_brn(void)
 {
 	struct backlight_device *bd = eeepc_backlight_device;
@@ -386,14 +515,28 @@ static void notify_brn(void)
 
 static void eeepc_hotk_notify(acpi_handle handle, u32 event, void *data)
 {
+	static struct key_entry *key;
 	if (!ehotk)
 		return;
-	if (event == NOTIFY_WLAN_ON && (DISABLE_ASL_WLAN & ehotk->init_flag))
-		notify_wlan(&event);
 	if (event >= NOTIFY_BRN_MIN && event <= NOTIFY_BRN_MAX)
 		notify_brn();
 	acpi_bus_generate_proc_event(ehotk->device, event,
 				     ehotk->event_count[event % 128]++);
+	if (ehotk->inputdev) {
+		key = eepc_get_entry_by_scancode(event);
+		if (key) {
+			switch (key->type) {
+			case KE_KEY:
+				input_report_key(ehotk->inputdev, key->keycode,
+						 1);
+				input_sync(ehotk->inputdev);
+				input_report_key(ehotk->inputdev, key->keycode,
+						 0);
+				input_sync(ehotk->inputdev);
+				break;
+			}
+		}
+	}
 }
 
 static int eeepc_hotk_add(struct acpi_device *device)
@@ -420,6 +563,47 @@ static int eeepc_hotk_add(struct acpi_de
 					     eeepc_hotk_notify, ehotk);
 	if (ACPI_FAILURE(status))
 		printk(EEEPC_ERR "Error installing notify handler\n");
+
+	if (get_acpi(CM_ASL_WLAN) != -1) {
+		ehotk->eeepc_wlan_rfkill = rfkill_allocate(&device->dev,
+							   RFKILL_TYPE_WLAN);
+
+		if (!ehotk->eeepc_wlan_rfkill)
+			goto end;
+
+		ehotk->eeepc_wlan_rfkill->name = "eeepc-wlan";
+		ehotk->eeepc_wlan_rfkill->toggle_radio = eeepc_wlan_rfkill_set;
+		ehotk->eeepc_wlan_rfkill->get_state = eeepc_wlan_rfkill_state;
+		if (get_acpi(CM_ASL_WIFI) == 1)
+			ehotk->eeepc_wlan_rfkill->state =
+				RFKILL_STATE_UNBLOCKED;
+		else
+			ehotk->eeepc_wlan_rfkill->state =
+				RFKILL_STATE_SOFT_BLOCKED;
+		rfkill_register(ehotk->eeepc_wlan_rfkill);
+	}
+
+	if (get_acpi(CM_ASL_BLUETOOTH) != -1) {
+		ehotk->eeepc_bluetooth_rfkill =
+			rfkill_allocate(&device->dev, RFKILL_TYPE_BLUETOOTH);
+
+		if (!ehotk->eeepc_bluetooth_rfkill)
+			goto end;
+
+		ehotk->eeepc_bluetooth_rfkill->name = "eeepc-bluetooth";
+		ehotk->eeepc_bluetooth_rfkill->toggle_radio =
+			eeepc_bluetooth_rfkill_set;
+		ehotk->eeepc_bluetooth_rfkill->get_state =
+			eeepc_bluetooth_rfkill_state;
+		if (get_acpi(CM_ASL_BLUETOOTH) == 1)
+			ehotk->eeepc_bluetooth_rfkill->state =
+				RFKILL_STATE_UNBLOCKED;
+		else
+			ehotk->eeepc_bluetooth_rfkill->state =
+				RFKILL_STATE_SOFT_BLOCKED;
+		rfkill_register(ehotk->eeepc_bluetooth_rfkill);
+	}
+
  end:
 	if (result) {
 		kfree(ehotk);
@@ -543,6 +727,12 @@ static void eeepc_backlight_exit(void)
 {
 	if (eeepc_backlight_device)
 		backlight_device_unregister(eeepc_backlight_device);
+	if (ehotk->inputdev)
+		input_unregister_device(ehotk->inputdev);
+	if (ehotk->eeepc_wlan_rfkill)
+		rfkill_unregister(ehotk->eeepc_wlan_rfkill);
+	if (ehotk->eeepc_bluetooth_rfkill)
+		rfkill_unregister(ehotk->eeepc_bluetooth_rfkill);
 	eeepc_backlight_device = NULL;
 }
 
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

eeepc-laptop-fix-user-after-free.patch
linux-next.patch
eeepc-laptop-use-standard-interfaces.patch
rtc-cmos-strongly-avoid-hpet-emulation.patch


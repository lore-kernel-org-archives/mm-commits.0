From: akpm@linux-foundation.org
Subject: [merged] toshiba_acpi-add-full-hotkey-support.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:50:29 -0700
Message-ID: <200904141950.n3EJoTs1020187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836AbZDNUEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 16:04:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, lenb@kernel.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     toshiba_acpi: add full hotkey support
has been removed from the -mm tree.  Its filename was
     toshiba_acpi-add-full-hotkey-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: toshiba_acpi: add full hotkey support
From: Matthew Garrett <mjg59@srcf.ucam.org>

Calling the ENAB method on Toshiba laptops results in notifications being
sent when laptop hotkeys are pressed.  This patch simply calls that method
and sets up an input device if it's successful.

[akpm@linux-foundation.org: fix some compile warnings]
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/toshiba_acpi.c |  206 +++++++++++++++++++++++++-
 1 file changed, 199 insertions(+), 7 deletions(-)

diff -puN drivers/platform/x86/toshiba_acpi.c~toshiba_acpi-add-full-hotkey-support drivers/platform/x86/toshiba_acpi.c
--- a/drivers/platform/x86/toshiba_acpi.c~toshiba_acpi-add-full-hotkey-support
+++ a/drivers/platform/x86/toshiba_acpi.c
@@ -46,6 +46,7 @@
 #include <linux/platform_device.h>
 #include <linux/rfkill.h>
 #include <linux/input-polldev.h>
+#include <linux/input.h>
 
 #include <asm/uaccess.h>
 
@@ -62,9 +63,10 @@ MODULE_LICENSE("GPL");
 
 /* Toshiba ACPI method paths */
 #define METHOD_LCD_BRIGHTNESS	"\\_SB_.PCI0.VGA_.LCD_._BCM"
-#define METHOD_HCI_1		"\\_SB_.VALD.GHCI"
-#define METHOD_HCI_2		"\\_SB_.VALZ.GHCI"
+#define TOSH_INTERFACE_1	"\\_SB_.VALD"
+#define TOSH_INTERFACE_2	"\\_SB_.VALZ"
 #define METHOD_VIDEO_OUT	"\\_SB_.VALX.DSSX"
+#define GHCI_METHOD		".GHCI"
 
 /* Toshiba HCI interface definitions
  *
@@ -116,6 +118,36 @@ static const struct acpi_device_id toshi
 };
 MODULE_DEVICE_TABLE(acpi, toshiba_device_ids);
 
+struct key_entry {
+	char type;
+	u16 code;
+	u16 keycode;
+};
+
+enum {KE_KEY, KE_END};
+
+static struct key_entry toshiba_acpi_keymap[]  = {
+	{KE_KEY, 0x101, KEY_MUTE},
+	{KE_KEY, 0x13b, KEY_COFFEE},
+	{KE_KEY, 0x13c, KEY_BATTERY},
+	{KE_KEY, 0x13d, KEY_SLEEP},
+	{KE_KEY, 0x13e, KEY_SUSPEND},
+	{KE_KEY, 0x13f, KEY_SWITCHVIDEOMODE},
+	{KE_KEY, 0x140, KEY_BRIGHTNESSDOWN},
+	{KE_KEY, 0x141, KEY_BRIGHTNESSUP},
+	{KE_KEY, 0x142, KEY_WLAN},
+	{KE_KEY, 0x143, KEY_PROG1},
+	{KE_KEY, 0xb05, KEY_PROG2},
+	{KE_KEY, 0xb06, KEY_WWW},
+	{KE_KEY, 0xb07, KEY_MAIL},
+	{KE_KEY, 0xb30, KEY_STOP},
+	{KE_KEY, 0xb31, KEY_PREVIOUSSONG},
+	{KE_KEY, 0xb32, KEY_NEXTSONG},
+	{KE_KEY, 0xb33, KEY_PLAYPAUSE},
+	{KE_KEY, 0xb5a, KEY_MEDIA},
+	{KE_END, 0, 0},
+};
+
 /* utility
  */
 
@@ -252,6 +284,8 @@ struct toshiba_acpi_dev {
 	struct platform_device *p_dev;
 	struct rfkill *rfk_dev;
 	struct input_polled_dev *poll_dev;
+	struct input_dev *hotkey_dev;
+	acpi_handle handle;
 
 	const char *bt_name;
 	const char *rfk_name;
@@ -700,6 +734,154 @@ static struct backlight_ops toshiba_back
         .update_status  = set_lcd_status,
 };
 
+static struct key_entry *toshiba_acpi_get_entry_by_scancode(int code)
+{
+	struct key_entry *key;
+
+	for (key = toshiba_acpi_keymap; key->type != KE_END; key++)
+		if (code == key->code)
+			return key;
+
+	return NULL;
+}
+
+static struct key_entry *toshiba_acpi_get_entry_by_keycode(int code)
+{
+	struct key_entry *key;
+
+	for (key = toshiba_acpi_keymap; key->type != KE_END; key++)
+		if (code == key->keycode && key->type == KE_KEY)
+			return key;
+
+	return NULL;
+}
+
+static int toshiba_acpi_getkeycode(struct input_dev *dev, int scancode,
+				   int *keycode)
+{
+	struct key_entry *key = toshiba_acpi_get_entry_by_scancode(scancode);
+
+	if (key && key->type == KE_KEY) {
+		*keycode = key->keycode;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int toshiba_acpi_setkeycode(struct input_dev *dev, int scancode,
+				   int keycode)
+{
+	struct key_entry *key;
+	int old_keycode;
+
+	if (keycode < 0 || keycode > KEY_MAX)
+		return -EINVAL;
+
+	key = toshiba_acpi_get_entry_by_scancode(scancode);
+	if (key && key->type == KE_KEY) {
+		old_keycode = key->keycode;
+		key->keycode = keycode;
+		set_bit(keycode, dev->keybit);
+		if (!toshiba_acpi_get_entry_by_keycode(old_keycode))
+			clear_bit(old_keycode, dev->keybit);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static void toshiba_acpi_notify(acpi_handle handle, u32 event, void *context)
+{
+	u32 hci_result, value;
+	struct key_entry *key;
+
+	if (event != 0x80)
+		return;
+	do {
+		hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
+		if (hci_result == HCI_SUCCESS) {
+			if (value == 0x100)
+				continue;
+			else if (value & 0x80) {
+				key = toshiba_acpi_get_entry_by_scancode
+					(value & ~0x80);
+				if (!key) {
+					printk(MY_INFO "Unknown key %x\n",
+					       value & ~0x80);
+					continue;
+				}
+				input_report_key(toshiba_acpi.hotkey_dev,
+						 key->keycode, 1);
+				input_sync(toshiba_acpi.hotkey_dev);
+				input_report_key(toshiba_acpi.hotkey_dev,
+						 key->keycode, 0);
+				input_sync(toshiba_acpi.hotkey_dev);
+			}
+		} else if (hci_result == HCI_NOT_SUPPORTED) {
+			/* This is a workaround for an unresolved issue on
+			 * some machines where system events sporadically
+			 * become disabled. */
+			hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
+			printk(MY_NOTICE "Re-enabled hotkeys\n");
+		}
+	} while (hci_result != HCI_EMPTY);
+}
+
+static int toshiba_acpi_setup_keyboard(char *device)
+{
+	acpi_status status;
+	acpi_handle handle;
+	int result;
+	const struct key_entry *key;
+
+	status = acpi_get_handle(NULL, device, &handle);
+	if (ACPI_FAILURE(status)) {
+		printk(MY_INFO "Unable to get notification device\n");
+		return -ENODEV;
+	}
+
+	toshiba_acpi.handle = handle;
+
+	status = acpi_evaluate_object(handle, "ENAB", NULL, NULL);
+	if (ACPI_FAILURE(status)) {
+		printk(MY_INFO "Unable to enable hotkeys\n");
+		return -ENODEV;
+	}
+
+	status = acpi_install_notify_handler(handle, ACPI_DEVICE_NOTIFY,
+					      toshiba_acpi_notify, NULL);
+	if (ACPI_FAILURE(status)) {
+		printk(MY_INFO "Unable to install hotkey notification\n");
+		return -ENODEV;
+	}
+
+	toshiba_acpi.hotkey_dev = input_allocate_device();
+	if (!toshiba_acpi.hotkey_dev) {
+		printk(MY_INFO "Unable to register input device\n");
+		return -ENOMEM;
+	}
+
+	toshiba_acpi.hotkey_dev->name = "Toshiba input device";
+	toshiba_acpi.hotkey_dev->phys = device;
+	toshiba_acpi.hotkey_dev->id.bustype = BUS_HOST;
+	toshiba_acpi.hotkey_dev->getkeycode = toshiba_acpi_getkeycode;
+	toshiba_acpi.hotkey_dev->setkeycode = toshiba_acpi_setkeycode;
+
+	for (key = toshiba_acpi_keymap; key->type != KE_END; key++) {
+		set_bit(EV_KEY, toshiba_acpi.hotkey_dev->evbit);
+		set_bit(key->keycode, toshiba_acpi.hotkey_dev->keybit);
+	}
+
+	result = input_register_device(toshiba_acpi.hotkey_dev);
+	if (result) {
+		printk(MY_INFO "Unable to register input device\n");
+		return result;
+	}
+
+	return 0;
+}
+
 static void toshiba_acpi_exit(void)
 {
 	if (toshiba_acpi.poll_dev) {
@@ -707,12 +889,18 @@ static void toshiba_acpi_exit(void)
 		input_free_polled_device(toshiba_acpi.poll_dev);
 	}
 
+	if (toshiba_acpi.hotkey_dev)
+		input_unregister_device(toshiba_acpi.hotkey_dev);
+
 	if (toshiba_acpi.rfk_dev)
 		rfkill_unregister(toshiba_acpi.rfk_dev);
 
 	if (toshiba_backlight_device)
 		backlight_device_unregister(toshiba_backlight_device);
 
+	acpi_remove_notify_handler(toshiba_acpi.handle, ACPI_DEVICE_NOTIFY,
+				   toshiba_acpi_notify);
+
 	remove_device();
 
 	if (toshiba_proc_dir)
@@ -736,11 +924,15 @@ static int __init toshiba_acpi_init(void
 		return -ENODEV;
 
 	/* simple device detection: look for HCI method */
-	if (is_valid_acpi_path(METHOD_HCI_1))
-		method_hci = METHOD_HCI_1;
-	else if (is_valid_acpi_path(METHOD_HCI_2))
-		method_hci = METHOD_HCI_2;
-	else
+	if (is_valid_acpi_path(TOSH_INTERFACE_1 GHCI_METHOD)) {
+		method_hci = TOSH_INTERFACE_1 GHCI_METHOD;
+		if (toshiba_acpi_setup_keyboard(TOSH_INTERFACE_1))
+			printk(MY_INFO "Unable to activate hotkeys\n");
+	} else if (is_valid_acpi_path(TOSH_INTERFACE_2 GHCI_METHOD)) {
+		method_hci = TOSH_INTERFACE_2 GHCI_METHOD;
+		if (toshiba_acpi_setup_keyboard(TOSH_INTERFACE_2))
+			printk(MY_INFO "Unable to activate hotkeys\n");
+	} else
 		return -ENODEV;
 
 	printk(MY_INFO "Toshiba Laptop ACPI Extras version %s\n",
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

origin.patch
linux-next.patch


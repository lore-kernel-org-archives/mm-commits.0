From: akpm@linux-foundation.org
Subject: [obsolete] revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch removed from -mm tree
Date: Mon, 29 Mar 2010 11:37:16 -0400
Message-ID: <201003291838.o2TIcMgC030843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957Ab0C2SjD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Mar 2010 14:39:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dmitry.torokhov@gmail.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     revert "Input: wistron_btns - switch to using sparse keymap library"
has been removed from the -mm tree.  Its filename was
     revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "Input: wistron_btns - switch to using sparse keymap library"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

: commit 6d673f1b9c98dcdccf4542ce97eb1d457f285ede
: Author:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
: AuthorDate: Fri Dec 4 10:22:24 2009 -0800
: Commit:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
: CommitDate: Fri Dec 4 22:17:41 2009 -0800
: 
:     Input: wistron_btns - switch to using sparse keymap library
:     
:     The keymap manipulation code was split into a library module,
:     so let's make us of it.
:     
:     Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
: 

Missing sparse-keymap.h, breaks i386 allmodconfig.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/Kconfig        |    1 
 drivers/input/misc/wistron_btns.c |  176 +++++++++++++++++++++-------
 2 files changed, 133 insertions(+), 44 deletions(-)

diff -puN drivers/input/misc/Kconfig~revert-input-wistron_btns-switch-to-using-sparse-keymap-library drivers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~revert-input-wistron_btns-switch-to-using-sparse-keymap-library
+++ a/drivers/input/misc/Kconfig
@@ -90,7 +90,6 @@ config INPUT_WISTRON_BTNS
 	tristate "x86 Wistron laptop button interface"
 	depends on X86 && !X86_64
 	select INPUT_POLLDEV
-	select INPUT_SPARSEKMAP
 	select NEW_LEDS
 	select LEDS_CLASS
 	select CHECK_SIGNATURE
diff -puN drivers/input/misc/wistron_btns.c~revert-input-wistron_btns-switch-to-using-sparse-keymap-library drivers/input/misc/wistron_btns.c
--- a/drivers/input/misc/wistron_btns.c~revert-input-wistron_btns-switch-to-using-sparse-keymap-library
+++ a/drivers/input/misc/wistron_btns.c
@@ -21,7 +21,6 @@
 #include <linux/dmi.h>
 #include <linux/init.h>
 #include <linux/input-polldev.h>
-#include <linux/input/sparse-keymap.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
@@ -225,8 +224,19 @@ static void bios_set_state(u8 subsys, in
 
 /* Hardware database */
 
-#define KE_WIFI		(KE_LAST + 1)
-#define KE_BLUETOOTH	(KE_LAST + 2)
+struct key_entry {
+	char type;		/* See KE_* below */
+	u8 code;
+	union {
+		u16 keycode;		/* For KE_KEY */
+		struct {		/* For KE_SW */
+			u8 code;
+			u8 value;
+		} sw;
+	};
+};
+
+enum { KE_END, KE_KEY, KE_SW, KE_WIFI, KE_BLUETOOTH };
 
 #define FE_MAIL_LED 0x01
 #define FE_WIFI_LED 0x02
@@ -1027,6 +1037,21 @@ static unsigned long jiffies_last_press;
 static bool wifi_enabled;
 static bool bluetooth_enabled;
 
+static void report_key(struct input_dev *dev, unsigned int keycode)
+{
+	input_report_key(dev, keycode, 1);
+	input_sync(dev);
+	input_report_key(dev, keycode, 0);
+	input_sync(dev);
+}
+
+static void report_switch(struct input_dev *dev, unsigned int code, int value)
+{
+	input_report_switch(dev, code, value);
+	input_sync(dev);
+}
+
+
  /* led management */
 static void wistron_mail_led_set(struct led_classdev *led_cdev,
 				enum led_brightness value)
@@ -1103,13 +1128,43 @@ static inline void wistron_led_resume(vo
 		led_classdev_resume(&wistron_wifi_led);
 }
 
+static struct key_entry *wistron_get_entry_by_scancode(int code)
+{
+	struct key_entry *key;
+
+	for (key = keymap; key->type != KE_END; key++)
+		if (code == key->code)
+			return key;
+
+	return NULL;
+}
+
+static struct key_entry *wistron_get_entry_by_keycode(int keycode)
+{
+	struct key_entry *key;
+
+	for (key = keymap; key->type != KE_END; key++)
+		if (key->type == KE_KEY && keycode == key->keycode)
+			return key;
+
+	return NULL;
+}
+
 static void handle_key(u8 code)
 {
-	const struct key_entry *key =
-		sparse_keymap_entry_from_scancode(wistron_idev->input, code);
+	const struct key_entry *key = wistron_get_entry_by_scancode(code);
 
 	if (key) {
 		switch (key->type) {
+		case KE_KEY:
+			report_key(wistron_idev->input, key->keycode);
+			break;
+
+		case KE_SW:
+			report_switch(wistron_idev->input,
+				      key->sw.code, key->sw.value);
+			break;
+
 		case KE_WIFI:
 			if (have_wifi) {
 				wifi_enabled = !wifi_enabled;
@@ -1125,9 +1180,7 @@ static void handle_key(u8 code)
 			break;
 
 		default:
-			sparse_keymap_report_entry(wistron_idev->input,
-						   key, 1, true);
-			break;
+			BUG();
 		}
 		jiffies_last_press = jiffies;
 	} else
@@ -1167,39 +1220,42 @@ static void wistron_poll(struct input_po
 		dev->poll_interval = POLL_INTERVAL_DEFAULT;
 }
 
-static int __devinit wistron_setup_keymap(struct input_dev *dev,
-					  struct key_entry *entry)
+static int wistron_getkeycode(struct input_dev *dev, int scancode, int *keycode)
 {
-	switch (entry->type) {
+	const struct key_entry *key = wistron_get_entry_by_scancode(scancode);
 
-	/* if wifi or bluetooth are not available, create normal keys */
-	case KE_WIFI:
-		if (!have_wifi) {
-			entry->type = KE_KEY;
-			entry->keycode = KEY_WLAN;
-		}
-		break;
+	if (key && key->type == KE_KEY) {
+		*keycode = key->keycode;
+		return 0;
+	}
 
-	case KE_BLUETOOTH:
-		if (!have_bluetooth) {
-			entry->type = KE_KEY;
-			entry->keycode = KEY_BLUETOOTH;
-		}
-		break;
+	return -EINVAL;
+}
+
+static int wistron_setkeycode(struct input_dev *dev, int scancode, int keycode)
+{
+	struct key_entry *key;
+	int old_keycode;
+
+	if (keycode < 0 || keycode > KEY_MAX)
+		return -EINVAL;
 
-	case KE_END:
-		if (entry->code & FE_UNTESTED)
-			printk(KERN_WARNING "Untested laptop multimedia keys, "
-				"please report success or failure to "
-				"eric.piel@tremplin-utc.net\n");
-		break;
+	key = wistron_get_entry_by_scancode(scancode);
+	if (key && key->type == KE_KEY) {
+		old_keycode = key->keycode;
+		key->keycode = keycode;
+		set_bit(keycode, dev->keybit);
+		if (!wistron_get_entry_by_keycode(old_keycode))
+			clear_bit(old_keycode, dev->keybit);
+		return 0;
 	}
 
-	return 0;
+	return -EINVAL;
 }
 
 static int __devinit setup_input_dev(void)
 {
+	struct key_entry *key;
 	struct input_dev *input_dev;
 	int error;
 
@@ -1217,21 +1273,56 @@ static int __devinit setup_input_dev(voi
 	input_dev->id.bustype = BUS_HOST;
 	input_dev->dev.parent = &wistron_device->dev;
 
-	error = sparse_keymap_setup(input_dev, keymap, wistron_setup_keymap);
-	if (error)
-		goto err_free_dev;
+	input_dev->getkeycode = wistron_getkeycode;
+	input_dev->setkeycode = wistron_setkeycode;
+
+	for (key = keymap; key->type != KE_END; key++) {
+		switch (key->type) {
+			case KE_KEY:
+				set_bit(EV_KEY, input_dev->evbit);
+				set_bit(key->keycode, input_dev->keybit);
+				break;
+
+			case KE_SW:
+				set_bit(EV_SW, input_dev->evbit);
+				set_bit(key->sw.code, input_dev->swbit);
+				break;
+
+			/* if wifi or bluetooth are not available, create normal keys */
+			case KE_WIFI:
+				if (!have_wifi) {
+					key->type = KE_KEY;
+					key->keycode = KEY_WLAN;
+					key--;
+				}
+				break;
+
+			case KE_BLUETOOTH:
+				if (!have_bluetooth) {
+					key->type = KE_KEY;
+					key->keycode = KEY_BLUETOOTH;
+					key--;
+				}
+				break;
+
+			default:
+				break;
+		}
+	}
+
+	/* reads information flags on KE_END */
+	if (key->code & FE_UNTESTED)
+		printk(KERN_WARNING "Untested laptop multimedia keys, "
+			"please report success or failure to eric.piel"
+			"@tremplin-utc.net\n");
 
 	error = input_register_polled_device(wistron_idev);
-	if (error)
-		goto err_free_keymap;
+	if (error) {
+		input_free_polled_device(wistron_idev);
+		return error;
+	}
 
 	return 0;
-
- err_free_keymap:
-	sparse_keymap_free(input_dev);
- err_free_dev:
-	input_free_polled_device(wistron_idev);
-	return error;
 }
 
 /* Driver core */
@@ -1280,7 +1371,6 @@ static int __devexit wistron_remove(stru
 {
 	wistron_led_remove();
 	input_unregister_polled_device(wistron_idev);
-	sparse_keymap_free(wistron_idev->input);
 	input_free_polled_device(wistron_idev);
 	bios_detach();
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
ratelimit-annotate-___ratelimit-fix.patch
rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method-checkpatch-fixes.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
serial-add-driver-for-the-altera-uart-unbork.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch


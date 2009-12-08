From: akpm@linux-foundation.org
Subject: + revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch added to -mm tree
Date: Mon, 07 Dec 2009 16:56:49 -0800
Message-ID: <200912080120.nB81Kx8G023673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965270AbZLHBVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2009 20:21:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dmitry.torokhov@gmail.com, dtor@mail.ru


The patch titled
     revert "Input: wistron_btns - switch to using sparse keymap library"
has been added to the -mm tree.  Its filename is
     revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -80,7 +80,6 @@ config INPUT_WISTRON_BTNS
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
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
acpi-remove-nid_inval.patch
drivers-acpi-acpi_padc-squish-warning.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
kbuild-generate-modulesbuiltin-fix-2-checkpatch-fixes.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
drivers-staging-wlags49_h2-remove-cvs-metadata.patch
wusb-use-sizeof-struct-rather-than-pointer.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
net-rfkill-corec-work-around-gcc-402-silliness.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-memory_hotplug-make-offline_pages-static.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim-checkpatch-fixes.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup.patch
ipc-remove-unreachable-code-in-semc-fix.patch
char-cyclades-fix-compiler-warning.patch
ip2-remove-ifdef-module-from-ip2mainc-fix-2.patch
drivers-edac-amd64_edacc-fix-use-uninitialised-bug.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
kfifo-move-struct-kfifo-in-place-fix.patch
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch


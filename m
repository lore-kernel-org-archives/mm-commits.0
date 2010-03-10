From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-fixups.patch removed from -mm tree
Date: Wed, 10 Mar 2010 12:27:34 -0800
Message-ID: <201003102027.o2AKRY8Z001820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593Ab0CJU1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 15:27:37 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o2AKRY8s018830
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 10 Mar 2010 12:27:35 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-fixups
has been removed from the -mm tree.  Its filename was
     linux-next-fixups.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-fixups
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.c         |    4 +-
 drivers/platform/x86/eeepc-laptop.c |   52 --------------------------
 mm/memcontrol.c                     |    2 -
 3 files changed, 3 insertions(+), 55 deletions(-)

diff -puN drivers/mmc/host/tmio_mmc.c~linux-next-fixups drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~linux-next-fixups
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -577,14 +577,14 @@ static int __devinit tmio_mmc_probe(stru
 	if (ret >= 0)
 		host->irq = ret;
 	else
-		goto unmap_cnf;
+		goto unmap_ctl;
 
 	disable_mmc_irqs(host, TMIO_MASK_ALL);
 
 	ret = request_irq(host->irq, tmio_mmc_irq, IRQF_DISABLED |
 		IRQF_TRIGGER_FALLING, dev_name(&dev->dev), host);
 	if (ret)
-		goto unmap_cnf;
+		goto unmap_ctl;
 
 	mmc_add_host(mmc);
 
diff -puN drivers/platform/x86/eeepc-laptop.c~linux-next-fixups drivers/platform/x86/eeepc-laptop.c
--- a/drivers/platform/x86/eeepc-laptop.c~linux-next-fixups
+++ a/drivers/platform/x86/eeepc-laptop.c
@@ -120,58 +120,6 @@ static const char *cm_setv[] = {
 	NULL, NULL, "PBPS", "TPDS"
 };
 
-#define EEEPC_EC	"\\_SB.PCI0.SBRG.EC0."
-
-#define EEEPC_EC_FAN_PWM	EEEPC_EC "SC02" /* Fan PWM duty cycle (%) */
-#define EEEPC_EC_SC02		0x63
-#define EEEPC_EC_FAN_HRPM	EEEPC_EC "SC05" /* High byte, fan speed (RPM) */
-#define EEEPC_EC_FAN_LRPM	EEEPC_EC "SC06" /* Low byte, fan speed (RPM) */
-#define EEEPC_EC_FAN_CTRL	EEEPC_EC "SFB3" /* Byte containing SF25  */
-#define EEEPC_EC_SFB3		0xD3
-
-/*
- * This is the main structure, we can use it to store useful information
- * about the hotk device
- */
-struct eeepc_hotk {
-	struct acpi_device *device;	/* the device we are in */
-	acpi_handle handle;		/* the handle of the hotk device */
-	u32 cm_supported;		/* the control methods supported
-					   by this BIOS */
-	uint init_flag;			/* Init flags */
-	u16 event_count[128];		/* count for each event */
-	struct input_dev *inputdev;
-	u16 *keycode_map;
-	struct rfkill *wlan_rfkill;
-	struct rfkill *bluetooth_rfkill;
-	struct rfkill *wwan3g_rfkill;
-	struct rfkill *wimax_rfkill;
-	struct hotplug_slot *hotplug_slot;
-	struct mutex hotplug_lock;
-};
-
-/* The actual device the driver binds to */
-static struct eeepc_hotk *ehotk;
-
-/* Platform device/driver */
-static int eeepc_hotk_thaw(struct device *device);
-static int eeepc_hotk_restore(struct device *device);
-
-static const struct dev_pm_ops eeepc_pm_ops = {
-	.thaw = eeepc_hotk_thaw,
-	.restore = eeepc_hotk_restore,
-};
-
-static struct platform_driver platform_driver = {
-	.driver = {
-		.name = EEEPC_HOTK_FILE,
-		.owner = THIS_MODULE,
-		.pm = &eeepc_pm_ops,
-	}
-};
-
-static struct platform_device *platform_device;
-
 struct key_entry {
 	char type;
 	u8 code;
diff -puN mm/memcontrol.c~linux-next-fixups mm/memcontrol.c
--- a/mm/memcontrol.c~linux-next-fixups
+++ a/mm/memcontrol.c
@@ -1745,7 +1745,7 @@ int mem_cgroup_try_charge_swapin(struct 
 	 */
 	if (!PageSwapCache(page))
 		goto charge_cur_mm;
-	mem = try_get_mem_cgroup_from_swapcache(page);
+	mem = try_get_mem_cgroup_from_page(page);
 	if (!mem)
 		goto charge_cur_mm;
 	*ptr = mem;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

add-generic-sys_ipc-wrapper-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-move-charges-of-anonymous-swap-fix-3-fix.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api-fix.patch
pps-linuxpps-clients-support-v3-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
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


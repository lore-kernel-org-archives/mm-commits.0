From: akpm@linux-foundation.org
Subject: + led-driver-for-leds-on-pcengines-alix2-and-alix3-boards-fix.patch added to -mm tree
Date: Fri, 22 Aug 2008 11:52:04 -0700
Message-ID: <200808221852.m7MIq4qs010864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120AbYHVSwR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 14:52:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, const@tltsu.ru, rpurdie@rpsys.net


The patch titled
     led-driver-for-leds-on-pcengines-alix2-and-alix3-boards-fix
has been added to the -mm tree.  Its filename is
     led-driver-for-leds-on-pcengines-alix2-and-alix3-boards-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: led-driver-for-leds-on-pcengines-alix2-and-alix3-boards-fix
From: Andrew Morton <akpm@linux-foundation.org>

- cleanups

- fix off-by-one on error path

Cc: Constantin Baranov <const@tltsu.ru>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-alix.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/leds/leds-alix.c~led-driver-for-leds-on-pcengines-alix2-and-alix3-boards-fix drivers/leds/leds-alix.c
--- a/drivers/leds/leds-alix.c~led-driver-for-leds-on-pcengines-alix2-and-alix3-boards-fix
+++ a/drivers/leds/leds-alix.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2008 Constantin Baranov <const@tltsu.ru>
  */
 
-#include <asm/io.h>
+#include <linux/io.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/leds.h>
@@ -22,6 +22,7 @@ static void alix_led_set(struct led_clas
 {
 	struct alix_led *led_dev =
 		container_of(led_cdev, struct alix_led, cdev);
+
 	if (brightness)
 		outl(led_dev->on_value, led_dev->port);
 	else
@@ -63,6 +64,7 @@ static struct alix_led alix_leds[] = {
 static int alix_led_suspend(struct platform_device *dev, pm_message_t state)
 {
 	int i;
+
 	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
 		led_classdev_suspend(&alix_leds[i].cdev);
 	return 0;
@@ -71,6 +73,7 @@ static int alix_led_suspend(struct platf
 static int alix_led_resume(struct platform_device *dev)
 {
 	int i;
+
 	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
 		led_classdev_resume(&alix_leds[i].cdev);
 	return 0;
@@ -92,7 +95,7 @@ static int __init alix_led_probe(struct 
 		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
 
 	if (ret < 0) {
-		for (i = i - 2; i >= 0; i--)
+		while (--i >= 0)
 			led_classdev_unregister(&alix_leds[i].cdev);
 	}
 
@@ -102,6 +105,7 @@ static int __init alix_led_probe(struct 
 static int alix_led_remove(struct platform_device *pdev)
 {
 	int i;
+
 	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
 		led_classdev_unregister(&alix_leds[i].cdev);
 	return 0;
@@ -122,6 +126,7 @@ static struct platform_device *pdev;
 static int __init alix_led_init(void)
 {
 	int ret;
+
 	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
 	if (!IS_ERR(pdev)) {
 		ret = platform_driver_probe(&alix_led_driver, alix_led_probe);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails-fix.patch
acer-wmi-remove-debugfs-entries-upon-unloading-cleanup.patch
mm-show-quicklist-memory-usage-in-proc-meminfo.patch
mm-quicklist-shouldnt-be-proportional-to-number-of-cpus.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
arch-x86-kernel-io_apic_32c-fix-printk-warnings.patch
arch-x86-kernel-io_apic_64c-fix-printk-warnings.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards-fix.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers.patch
ftrace-printk-formatting-infrastructure.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-watchdog.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
mm-rewrite-vmap-layer-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
nilfs2-continuous-snapshotting-file-system-fix.patch
nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch


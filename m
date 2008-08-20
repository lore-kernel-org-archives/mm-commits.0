From: akpm@linux-foundation.org
Subject: - power-support-for-texas-instruments-bq27x00-battery-managers-tweaks.patch removed from -mm tree
Date: Wed, 20 Aug 2008 16:52:14 -0700
Message-ID: <200808202352.m7KNqFIV006071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755504AbYHTXwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 19:52:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cbouatmailru@gmail.com, dwmw2@infradead.org, giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     power-support-for-texas-instruments-bq27x00-battery-managers-tweaks
has been removed from the -mm tree.  Its filename was
     power-support-for-texas-instruments-bq27x00-battery-managers-tweaks.patch

This patch was dropped because it was folded into power-support-for-texas-instruments-bq27x00-battery-managers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: power-support-for-texas-instruments-bq27x00-battery-managers-tweaks
From: Andrew Morton <akpm@linux-foundation.org>

- make things static

- use kasprintf()

Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/bq27x00_battery.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/power/bq27x00_battery.c~power-support-for-texas-instruments-bq27x00-battery-managers-tweaks drivers/power/bq27x00_battery.c
--- a/drivers/power/bq27x00_battery.c~power-support-for-texas-instruments-bq27x00-battery-managers-tweaks
+++ a/drivers/power/bq27x00_battery.c
@@ -40,8 +40,8 @@
 /* If the system has several batteries we need a different name for each
  * of them...
  */
-DEFINE_IDR(battery_id);
-DEFINE_MUTEX(battery_mutex);
+static DEFINE_IDR(battery_id);
+static DEFINE_MUTEX(battery_mutex);
 
 struct bq27x00_device_info;
 struct bq27x00_access_methods {
@@ -275,13 +275,12 @@ static int bq27200_battery_probe(struct 
 	if (retval < 0)
 		return retval;
 
-	name = kmalloc(16, GFP_KERNEL);
+	name = kasprintf(GFP_KERNEL, "bq27200-%d", num);
 	if (!name) {
 		dev_err(&client->dev, "failed to allocate device name\n");
 		retval = -ENOMEM;
 		goto batt_failed_1;
 	}
-	sprintf(name, "bq27200-%d", num);
 
 	di = kzalloc(sizeof(*di), GFP_KERNEL);
 	if (!di) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
proc-self-maps-doesnt-display-the-real-file-offset.patch
drivers-char-ipmi-ipmi_si_intfc-default_find_bmc-fix-leak.patch
mm-show-quicklist-memory-usage-in-proc-meminfo-fix.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
arch-x86-kernel-io_apic_32c-fix-printk-warnings.patch
arch-x86-kernel-io_apic_64c-fix-printk-warnings.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
kvm-is-still-busted-on-ia64.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
drivers-ata-pata_it821xc-fix-warning.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers.patch
power-support-for-texas-instruments-bq27x00-battery-managers-tweaks.patch
ftrace-printk-formatting-infrastructure.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-watchdog.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
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
h8300-generic_bug-support-checkpatch-fixes.patch
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


From: akpm@linux-foundation.org
Subject: - sata-blacklist-systems-that-spin-off-disks-during-acpi-power-offpatch-added-to-mm-tree-2-fix.patch removed from -mm tree
Date: Thu, 18 Sep 2008 17:47:47 -0700
Message-ID: <200809190101.m8J11hSN028550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755720AbYISBCz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 21:02:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, htejun@gmail.com, jeff@garzik.org, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     sata-blacklist-systems-that-spin-off-disks-during-acpi-power-offpatch-added-to-mm-tree-2-fix
has been removed from the -mm tree.  Its filename was
     sata-blacklist-systems-that-spin-off-disks-during-acpi-power-offpatch-added-to-mm-tree-2-fix.patch

This patch was dropped because 32/64-bit problems and general coding-style ug

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sata-blacklist-systems-that-spin-off-disks-during-acpi-power-offpatch-added-to-mm-tree-2-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/firmware/dmi_scan.c: In function 'dmi_first_match':
drivers/firmware/dmi_scan.c:478: warning: return discards qualifiers from pointer target type
drivers/firmware/dmi_scan.c:473: warning: unused variable 'i'

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |    3 +--
 include/linux/dmi.h         |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-offpatch-added-to-mm-tree-2-fix drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-offpatch-added-to-mm-tree-2-fix
+++ a/drivers/firmware/dmi_scan.c
@@ -468,9 +468,8 @@ EXPORT_SYMBOL(dmi_check_system);
  *	Walk the blacklist table until the first match is found.  Return the
  *	pointer to the matching entry or NULL if there's no match.
  */
-struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list)
+const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list)
 {
-	int i;
 	const struct dmi_system_id *d;
 
 	for (d = list; d->ident; d++)
diff -puN include/linux/dmi.h~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-offpatch-added-to-mm-tree-2-fix include/linux/dmi.h
--- a/include/linux/dmi.h~sata-blacklist-systems-that-spin-off-disks-during-acpi-power-offpatch-added-to-mm-tree-2-fix
+++ a/include/linux/dmi.h
@@ -75,7 +75,7 @@ struct dmi_device {
 #ifdef CONFIG_DMI
 
 extern int dmi_check_system(const struct dmi_system_id *list);
-struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list);
+const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list);
 extern const char * dmi_get_system_info(int field);
 extern const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-tiny-shmem-fix-lor-mmap_sem-vs-i_mutex-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
revert-acpi-ec-do-transaction-from-interrupt-context.patch
acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix.patch
acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix-fix.patch
acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix-fix-fix.patch
acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix-fix-fix-fix.patch
acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix-fix-fix-fix-fix.patch
fix-x86-sparse_irq-needs-spin_lock-in-allocations.patch
fix-x86-hpet_msi-initialise-per-cpu-hpet-timers.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
drivers-media-video-tda9840c-unbreak.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver-fix.patch
sata-blacklist-systems-that-spin-off-disks-during-acpi-power-offpatch-added-to-mm-tree-2-fix.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-checkpatch-fixes.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-fix.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
fix-cred-wrap-current-cred-and-a-few-other-accessors-on-mips.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
sched-clarify-ifdef-tangle.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32.patch
drivers-usb-musb-disable-it-on-superh.patch
introduce-new-lsm-hooks-where-vfsmount-is-available-fix.patch
git-watchdog.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
acpi-cope-with-pnpacpi-tables-missing-an-rtc-entry-fix.patch
drivers-media-video-cafe_ccicc-needs-mmh.patch
e1000e-prevent-corruption-of-eeprom-nvm.patch
drivers-net-mlx4-allocc-needs-mmh.patch
net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
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
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
fix-a-race-condtion-of-oops_in_progress-fix.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
make-taint-bit-reliable-v3-fix.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday-checkpatch-fixes.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
allow-recursion-in-binfmt_script-and-binfmt_misc-fix.patch
serial-make-uart_ports-ioport-unsigned-long-fix.patch
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
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
genirq-record-trigger-type-fix.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
tty-fix-echo-tab-erase-and-locking-fix.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
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


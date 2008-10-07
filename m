From: akpm@linux-foundation.org
Subject: - drivers-media-video-tda9840c-unbreak.patch removed from -mm tree
Date: Tue, 07 Oct 2008 16:39:42 -0700
Message-ID: <200810072339.m97Ndgxe009578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758034AbYJGXjq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 19:39:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/tda9840.c: unbreak
has been removed from the -mm tree.  Its filename was
     drivers-media-video-tda9840c-unbreak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/tda9840.c: unbreak
From: Andrew Morton <akpm@linux-foundation.org>

drivers/media/video/tda9840.c: In function 'tda9840_command':
drivers/media/video/tda9840.c:152: warning: 'result' is used uninitialized in this function

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/tda9840.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/media/video/tda9840.c~drivers-media-video-tda9840c-unbreak drivers/media/video/tda9840.c
--- a/drivers/media/video/tda9840.c~drivers-media-video-tda9840c-unbreak
+++ a/drivers/media/video/tda9840.c
@@ -62,7 +62,6 @@ static void tda9840_write(struct i2c_cli
 
 static int tda9840_command(struct i2c_client *client, unsigned cmd, void *arg)
 {
-	int result;
 	int byte = *(int *)arg;
 
 	switch (cmd) {
@@ -134,7 +133,6 @@ static int tda9840_command(struct i2c_cl
 
 		v4l_dbg(1, debug, client, "TDA9840_DETECT: byte: 0x%02x\n", byte);
 		*ret = (byte & 0x60) >> 5;
-		result = 0;
 		break;
 	}
 	case TDA9840_TEST:
@@ -149,9 +147,6 @@ static int tda9840_command(struct i2c_cl
 		return -ENOIOCTLCMD;
 	}
 
-	if (result)
-		return -EIO;
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

acpi-cope-with-pnpacpi-tables-missing-an-rtc-entry.patch
mm-remove-the-might_sleep-from-lock_page.patch
git-tip.patch
git-tip-rejects.patch
git-powerpc.patch
git-sparc.patch
git-xtensa.patch
git-sched-rejects.patch
git-stackprotector-rejects.patch
git-timers-fix-printk-errors-clean-up.patch
git-pci.patch
git-hid.patch
git-v4l-dvb.patch
git-v4l-dvb-git-rejects.patch
git-acpi-git-rejects.patch
git-nfsd.patch
git-dlm.patch
git-scsi.patch
git-tests-fixup.patch
git-ext4.patch
git-ext4-vs-git-ocfs2.patch
git-async_tx.patch
git-net.patch
git-mtd.patch
git-vfs-vs-git-ext4.patch
git-sound.patch
git-sound-vs-git-arm.patch
git-input.patch
git-block.patch
git-block-reject-fix.patch
git-pcmcia-git-rejects.patch
git-battery.patch
git-battery-rejects.patch
git-slab-rejects.patch
git-md-rejects.patch
git-mfd.patch
git-drm.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver.patch
misdn-misc-timerdev-fixes-fix.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
drivers-scsi-sdh-use-inlined-c-functions-not-macros.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
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
mm-vmallocc-revert-git-tip-change.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
revert-mm-vmallocc-revert-git-tip-change.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
make-taint-bit-reliable-v3-fix.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday-checkpatch-fixes.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
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
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
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


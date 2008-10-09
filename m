From: akpm@linux-foundation.org
Subject: - git-timers-fix-printk-errors-clean-up.patch removed from -mm tree
Date: Thu, 09 Oct 2008 13:35:11 -0700
Message-ID: <200810092035.m99KZBm2031144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416AbYJIUfh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 16:35:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     git-timers: fix printk errors, clean up
has been removed from the -mm tree.  Its filename was
     git-timers-fix-printk-errors-clean-up.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-timers: fix printk errors, clean up
From: Andrew Morton <akpm@linux-foundation.org>

Fix these:

kernel/resource.c: In function '__reserve_region_with_split':
kernel/resource.c:564: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
kernel/resource.c:564: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
kernel/resource.c:564: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'resource_size_t'
kernel/resource.c:564: warning: format '%llx' expects type 'long long unsigned int', but argument 7 has type 'resource_size_t'

and use __func__ and lay the code out better so it's
less-than-totally-revolting in an 80-col display.

Should be folded into

commit 268364a0f48aee2f851f9d1ef8a6cda0f3039ef1
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Thu Sep 4 21:02:44 2008 +0200

    IO resources: add reserve_region_with_split()

Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   48 ++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff -puN kernel/resource.c~git-timers-fix-printk-errors-clean-up kernel/resource.c
--- a/kernel/resource.c~git-timers-fix-printk-errors-clean-up
+++ a/kernel/resource.c
@@ -558,31 +558,37 @@ static void __init __reserve_region_with
 		break;
 	}
 
-	if (!res) {
-		printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
-			 conflict->name, conflict->start, conflict->end,
-			 name, start, end);
+	if (res)
+		return;
 
-		/* failed, split and try again */
+	printk(KERN_DEBUG "   %s: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
+		__func__, conflict->name,
+		(unsigned long long)conflict->start,
+		(unsigned long long)conflict->end,
+		name,
+		(unsigned long long)start,
+		(unsigned long long)end);
 
-		/* conflict coverred whole area */
-		if (conflict->start <= start && conflict->end >= end)
-			return;
+	/* failed, split and try again */
 
-		if (conflict->start > start)
-			__reserve_region_with_split(root, start, conflict->start-1, name);
-		if (!(conflict->flags & IORESOURCE_BUSY)) {
-			resource_size_t common_start, common_end;
-
-			common_start = max(conflict->start, start);
-			common_end = min(conflict->end, end);
-			if (common_start < common_end)
-				__reserve_region_with_split(root, common_start, common_end, name);
-		}
-		if (conflict->end < end)
-			__reserve_region_with_split(root, conflict->end+1, end, name);
+	/* conflict coverred whole area */
+	if (conflict->start <= start && conflict->end >= end)
+		return;
+
+	if (conflict->start > start)
+		__reserve_region_with_split(root, start, conflict->start-1,
+						name);
+	if (!(conflict->flags & IORESOURCE_BUSY)) {
+		resource_size_t common_start, common_end;
+
+		common_start = max(conflict->start, start);
+		common_end = min(conflict->end, end);
+		if (common_start < common_end)
+			__reserve_region_with_split(root, common_start,
+						common_end, name);
 	}
-
+	if (conflict->end < end)
+		__reserve_region_with_split(root, conflict->end+1, end, name);
 }
 
 void reserve_region_with_split(struct resource *root,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-remove-the-might_sleep-from-lock_page.patch
git-tip.patch
git-powerpc.patch
git-sparc.patch
git-xtensa.patch
git-timers-fix-printk-errors-clean-up.patch
git-pci.patch
git-hid.patch
git-v4l-dvb.patch
git-v4l-dvb-git-rejects.patch
git-nfs.patch
git-acpi-git-rejects.patch
git-nfsd.patch
git-kvm.patch
git-dlm.patch
git-scsi.patch
git-tests-fixup.patch
git-ext4.patch
git-ext4-vs-git-ocfs2.patch
git-async_tx.patch
git-net.patch
git-net-rejects.patch
git-mtd.patch
git-wireless.patch
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
git-kmemcheck.patch
git-mfd.patch
git-drm.patch
git-sparseirq.patch
git-scsi-post-merge.patch
git-bdev.patch
usb-usb-remove-warn-macro-from-usbh-vs-git-hid-fix.patch
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
tpm-addition-of-pnp_remove-checkpatch-fixes.patch
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


From: akpm@linux-foundation.org
Subject: + ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch added to -mm tree
Date: Wed, 17 Sep 2008 12:30:01 -0700
Message-ID: <200809171930.m8HJU1CM026827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754566AbYIQTa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 15:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, eugene@ibrix.com, msnitzer@ibrix.com, tytso@mit.edu


The patch titled
     ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#37: FILE: fs/ext3/dir.c:453:
+                if (call_filldir(filp, dirent, filldir, info->extra_fname))$

ERROR: code indent should use tabs where possible
#38: FILE: fs/ext3/dir.c:454:
+                        goto finished;$

ERROR: code indent should use tabs where possible
#40: FILE: fs/ext3/dir.c:456:
+                info->extra_fname = NULL;$

ERROR: code indent should use tabs where possible
#41: FILE: fs/ext3/dir.c:457:
+                info->curr_node = rb_next(info->curr_node);$

ERROR: code indent should use tabs where possible
#42: FILE: fs/ext3/dir.c:458:
+                if (!info->curr_node) {$

ERROR: code indent should use tabs where possible
#43: FILE: fs/ext3/dir.c:459:
+                        if (info->next_hash == ~0) {$

ERROR: code indent should use tabs where possible
#44: FILE: fs/ext3/dir.c:460:
+                                filp->f_pos = EXT3_HTREE_EOF;$

ERROR: code indent should use tabs where possible
#45: FILE: fs/ext3/dir.c:461:
+                                goto finished;$

ERROR: code indent should use tabs where possible
#46: FILE: fs/ext3/dir.c:462:
+                        }$

ERROR: code indent should use tabs where possible
#47: FILE: fs/ext3/dir.c:463:
+                        info->curr_hash = info->next_hash;$

ERROR: code indent should use tabs where possible
#48: FILE: fs/ext3/dir.c:464:
+                        info->curr_minor_hash = 0;$

ERROR: code indent should use tabs where possible
#49: FILE: fs/ext3/dir.c:465:
+                }$

ERROR: code indent should use tabs where possible
#50: FILE: fs/ext3/dir.c:466:
+        } else if (!info->curr_node)$

total: 13 errors, 0 warnings, 34 lines checked

./patches/ext3-fix-ext3_dx_readdir-hash-collision-handling.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eugene Dashevsky <eugene@ibrix.com>
Cc: Mike Snitzer <msnitzer@ibrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN fs/ext3/dir.c~ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes fs/ext3/dir.c
--- a/fs/ext3/dir.c~ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes
+++ a/fs/ext3/dir.c
@@ -450,20 +450,20 @@ static int ext3_dx_readdir(struct file *
 	 * chain, return them first.
 	 */
 	if (info->extra_fname) {
-                if (call_filldir(filp, dirent, filldir, info->extra_fname))
-                        goto finished;
+		if (call_filldir(filp, dirent, filldir, info->extra_fname))
+			goto finished;
 
-                info->extra_fname = NULL;
-                info->curr_node = rb_next(info->curr_node);
-                if (!info->curr_node) {
-                        if (info->next_hash == ~0) {
-                                filp->f_pos = EXT3_HTREE_EOF;
-                                goto finished;
-                        }
-                        info->curr_hash = info->next_hash;
-                        info->curr_minor_hash = 0;
-                }
-        } else if (!info->curr_node)
+		info->extra_fname = NULL;
+		info->curr_node = rb_next(info->curr_node);
+		if (!info->curr_node) {
+			if (info->next_hash == ~0) {
+				filp->f_pos = EXT3_HTREE_EOF;
+				goto finished;
+			}
+			info->curr_hash = info->next_hash;
+			info->curr_minor_hash = 0;
+		}
+	} else if (!info->curr_node)
 		info->curr_node = rb_first(&info->root);
 
 	while (1) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-ioporth-add-missing-macro-argument-for-devm_release_-family.patch
rescan_partitions-make-device-capacity-errors-non-fatal.patch
linux-next.patch
linux-next-fixups.patch
next-remove-localversion.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
revert-acpi-ec-do-transaction-from-interrupt-context.patch
acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix.patch
acpi-catch-calls-of-acpi_driver_data-on-pointer-of-wrong-type-fix-fix.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
itimers-fix-itimer-many-thread-hang-checkpatch-fixes.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver-fix.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-checkpatch-fixes.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-fix.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
fix-cred-wrap-current-cred-and-a-few-other-accessors-on-mips.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
sched-clarify-ifdef-tangle.patch
debug_locks_warn_on-disable-if-oops_in_progress.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32.patch
drivers-usb-musb-disable-it-on-superh.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
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
gru-driver-minor-updates-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
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


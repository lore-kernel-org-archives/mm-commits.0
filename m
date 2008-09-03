From: akpm@linux-foundation.org
Subject: - linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 03 Sep 2008 08:50:27 -0700
Message-ID: <200809031550.m83FoR30022907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047AbYICPu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 11:50:29 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m83FoRGF020494
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 3 Sep 2008 08:50:28 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cmd-filter.c |    3 ---
 block/genhd.c      |   21 ++++-----------------
 kernel/auditsc.c   |    4 ----
 3 files changed, 4 insertions(+), 24 deletions(-)

diff -puN block/cmd-filter.c~linux-next-git-rejects block/cmd-filter.c
--- a/block/cmd-filter.c~linux-next-git-rejects
+++ a/block/cmd-filter.c
@@ -227,7 +227,4 @@ void blk_unregister_filter(struct gendis
 
 	kobject_put(&filter->kobj);
 }
-<<<<<<< HEAD:block/cmd-filter.c
 EXPORT_SYMBOL(blk_unregister_filter);
-=======
->>>>>>> FETCH_HEAD:block/cmd-filter.c
diff -puN block/genhd.c~linux-next-git-rejects block/genhd.c
--- a/block/genhd.c~linux-next-git-rejects
+++ a/block/genhd.c
@@ -526,12 +526,9 @@ EXPORT_SYMBOL(del_gendisk);	/* in partit
 
 void unlink_gendisk(struct gendisk *disk)
 {
-<<<<<<< HEAD:block/genhd.c
-	sysfs_remove_link(&disk->dev.kobj, "bdi");
-=======
+//	sysfs_remove_link(&disk->dev.kobj, "bdi");
 	blk_unregister_filter(disk);
 	sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
->>>>>>> FETCH_HEAD:block/genhd.c
 	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_queue(disk);
 	blk_unregister_region(disk_devt(disk), disk->minors);
@@ -678,19 +675,9 @@ static void *disk_seqf_next(struct seq_f
 {
 	struct device *dev;
 
-<<<<<<< HEAD:block/genhd.c
-	if (!k)
-		part->private = (void *)1LU;	/* tell show to print header */
-
-	mutex_lock(&block_class_lock);
-	dev = class_find_device(&block_class, NULL, &k, find_start);
-	if (dev) {
-		put_device(dev);
-=======
 	(*pos)++;
 	dev = class_dev_iter_next(seqf->private);
 	if (dev)
->>>>>>> FETCH_HEAD:block/genhd.c
 		return dev_to_disk(dev);
 
 	return NULL;
@@ -730,9 +717,9 @@ static int show_partition(struct seq_fil
 	 * partition exists.  This hackery will be removed later with
 	 * class iteration clean up.
 	 */
-	if (part->private) {
-		seq_puts(part, "major minor  #blocks  name\n\n");
-		part->private = NULL;
+	if (seqf->private) {
+		seq_puts(seqf, "major minor  #blocks  name\n\n");
+		seqf->private = NULL;
 	}
 
 	/* Don't show non-partitionable removeable devices or empty devices */
diff -puN kernel/auditsc.c~linux-next-git-rejects kernel/auditsc.c
--- a/kernel/auditsc.c~linux-next-git-rejects
+++ a/kernel/auditsc.c
@@ -248,10 +248,6 @@ static int audit_match_perm(struct audit
 		return 0;
 	n = ctx->major;
 
-<<<<<<< HEAD:kernel/auditsc.c
-	n = ctx->major;
-=======
->>>>>>> FETCH_HEAD:kernel/auditsc.c
 	switch (audit_classify_syscall(ctx->arch, n)) {
 	case 0:	/* native */
 		if ((mask & AUDIT_PERM_WRITE) &&
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
linux-next-git-rejects.patch
linux-next-avoid-tty-oops.patch
git-acpi.patch
acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically-cleanup.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix-fix.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86-make-poll_idle-behave-more-like-the-other-idle-methods-checkpatch-fixes.patch
git-alsa-tiwai.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
git-powerpc.patch
fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
git-drm.patch
fs-dlm-configc-choose-better-identifiers.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
git-kvm.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver-fix.patch
git-mtd.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-checkpatch-fixes.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-fix.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
git-battery.patch
git-pci-next.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32.patch
git-xtensa.patch
modules-remove-stop_machine-during-module-load-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-media-video-cafe_ccicc-needs-mmh.patch
e1000e-prevent-corruption-of-eeprom-nvm.patch
drivers-net-mlx4-allocc-needs-mmh.patch
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
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
gru-driver-minor-updates-fix.patch
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


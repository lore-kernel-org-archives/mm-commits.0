From: akpm@linux-foundation.org
Subject: + git-block-fixup.patch added to -mm tree
Date: Fri, 05 Oct 2007 12:18:10 -0700
Message-ID: <200710051918.l95JIAAV020805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58477 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842AbXJETSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:18:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com


The patch titled
     git-block-fixup
has been added to the -mm tree.  Its filename is
     git-block-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-block-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Fix rejects between git-block and rest-of-the-world

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c   |    3 +--
 drivers/md/dm.c         |    5 ++---
 drivers/md/raid5.c      |   13 +++----------
 drivers/scsi/hosts.c    |    1 +
 drivers/scsi/ide-scsi.c |   13 +------------
 drivers/scsi/scsi_lib.c |    9 +++++----
 drivers/scsi/sd.c       |    1 -
 include/linux/blkdev.h  |    2 --
 8 files changed, 13 insertions(+), 34 deletions(-)

diff -puN drivers/scsi/scsi_lib.c~git-block-fixup drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~git-block-fixup
+++ a/drivers/scsi/scsi_lib.c
@@ -290,13 +290,14 @@ static int scsi_req_map_sg(struct reques
 	int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	unsigned int data_len = bufflen, len, bytes, off;
 	struct page *page;
+	struct scatterlist *sg;
 	struct bio *bio = NULL;
 	int i, err, nr_vecs = 0;
 
-	for (i = 0; i < nsegs; i++) {
-		page = sgl[i].page;
-		off = sgl[i].offset;
-		len = sgl[i].length;
+	for_each_sg(sgl, sg, nsegs, i) {
+		page = sg->page;
+		off = sg->offset;
+		len = sg->length;
 
 		while (len > 0 && data_len > 0) {
 			/*
diff -puN drivers/scsi/hosts.c~git-block-fixup drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c~git-block-fixup
+++ a/drivers/scsi/hosts.c
@@ -343,6 +343,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
 	shost->active_mode = sht->supported_mode;
+	shost->use_sg_chaining = sht->use_sg_chaining;
 
 	if (sht->max_host_blocked)
 		shost->max_host_blocked = sht->max_host_blocked;
diff -puN drivers/infiniband/ulp/iser/iser_memory.c~git-block-fixup drivers/infiniband/ulp/iser/iser_memory.c
diff -puN drivers/scsi/sd.c~git-block-fixup drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~git-block-fixup
+++ a/drivers/scsi/sd.c
@@ -1682,7 +1682,6 @@ static int sd_probe(struct device *dev)
 	sd_revalidate_disk(gd);
 
 	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
-	blk_queue_issue_flush_fn(sdp->request_queue, sd_issue_flush);
 
 	gd->driverfs_dev = &sdp->sdev_gendev;
 	gd->flags = GENHD_FL_DRIVERFS;
diff -puN drivers/scsi/ide-scsi.c~git-block-fixup drivers/scsi/ide-scsi.c
--- a/drivers/scsi/ide-scsi.c~git-block-fixup
+++ a/drivers/scsi/ide-scsi.c
@@ -174,12 +174,6 @@ static void idescsi_input_buffers (ide_d
 	char *buf;
 
 	while (bcount) {
-		if (pc->sg - scsi_sglist(pc->scsi_cmd) >
-		                                 scsi_sg_count(pc->scsi_cmd)) {
-			printk (KERN_ERR "ide-scsi: scatter gather table too small, discarding data\n");
-			idescsi_discard_data (drive, bcount);
-			return;
-		}
 		count = min(pc->sg->length - pc->b_count, bcount);
 		if (PageHighMem(pc->sg->page)) {
 			unsigned long flags;
@@ -217,12 +211,6 @@ static void idescsi_output_buffers (ide_
 	char *buf;
 
 	while (bcount) {
-		if (pc->sg - scsi_sglist(pc->scsi_cmd) >
-		                                 scsi_sg_count(pc->scsi_cmd)) {
-			printk (KERN_ERR "ide-scsi: scatter gather table too small, padding with zeros\n");
-			idescsi_output_zeros (drive, bcount);
-			return;
-		}
 		count = min(pc->sg->length - pc->b_count, bcount);
 		if (PageHighMem(pc->sg->page)) {
 			unsigned long flags;
@@ -819,6 +807,7 @@ static int idescsi_queue (struct scsi_cm
 	memcpy (pc->c, cmd->cmnd, cmd->cmd_len);
 	pc->buffer = NULL;
 	pc->sg = scsi_sglist(cmd);
+	pc->last_sg = sg_last(pc->sg, cmd->use_sg);
 	pc->b_count = 0;
 	pc->request_transfer = pc->buffer_size = scsi_bufflen(cmd);
 	pc->scsi_cmd = cmd;
diff -puN include/linux/blkdev.h~git-block-fixup include/linux/blkdev.h
--- a/include/linux/blkdev.h~git-block-fixup
+++ a/include/linux/blkdev.h
@@ -346,8 +346,6 @@ struct bio_vec;
 typedef int (merge_bvec_fn) (struct request_queue *, struct block_device *bi_bdev,
 			     sector_t bi_sector, unsigned bi_size,
 			     unsigned long bi_rw, struct bio_vec *);
-typedef int (issue_flush_fn) (struct request_queue *, struct gendisk *, sector_t *);
-typedef void (prepare_flush_fn) (struct request_queue *, struct request *);
 typedef void (softirq_done_fn)(struct request *);
 
 enum blk_queue_state {
diff -puN drivers/scsi/advansys.c~git-block-fixup drivers/scsi/advansys.c
diff -puN drivers/md/raid5.c~git-block-fixup drivers/md/raid5.c
--- a/drivers/md/raid5.c~git-block-fixup
+++ a/drivers/md/raid5.c
@@ -1674,11 +1674,9 @@ static void raid5_end_read_request(struc
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
-	return 0;
 }
 
-static int raid5_end_write_request (struct bio *bi, unsigned int bytes_done,
-				    int error)
+static void raid5_end_write_request(struct bio *bi, int error)
 {
  	struct stripe_head *sh = bi->bi_private;
 	struct stripe_queue *sq = sh->sq;
@@ -1686,9 +1684,6 @@ static int raid5_end_write_request (stru
 	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
-	if (bi->bi_size)
-		return 1;
-
 	for (i=0 ; i<disks; i++)
 		if (bi == &sh->dev[i].req)
 			break;
@@ -1709,7 +1704,6 @@ static int raid5_end_write_request (stru
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
-	return 0;
 }
 
 static void raid5_build_block (struct stripe_head *sh, int i)
@@ -3891,17 +3885,16 @@ static void raid5_align_endio(struct bio
 	rdev_dec_pending(rdev, conf->mddev);
 
 	if (!error && uptodate) {
-		bio_endio(raid_bi, bytes, 0);
+		bio_endio(raid_bi, 0);
 		if (atomic_dec_and_test(&conf->active_aligned_reads))
 			wake_up(&conf->wait_for_queue);
-		return 0;
+		return;
 	}
 
 
 	pr_debug("raid5_align_endio : io error...handing IO for a retry\n");
 
 	add_bio_to_retry(raid_bi, conf);
-	return 0;
 }
 
 static int bio_fits_rdev(struct bio *bi)
diff -puN drivers/md/dm.c~git-block-fixup drivers/md/dm.c
--- a/drivers/md/dm.c~git-block-fixup
+++ a/drivers/md/dm.c
@@ -877,7 +877,7 @@ static int dm_request(struct request_que
 
 out_req:
 	if (r < 0)
-		bio_io_error(bio, bio->bi_size);
+		bio_io_error(bio);
 
 	return 0;
 }
@@ -1030,7 +1030,6 @@ static struct mapped_device *alloc_dev(i
 	blk_queue_make_request(md->queue, dm_request);
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
 	md->queue->unplug_fn = dm_unplug_all;
-	md->queue->issue_flush_fn = dm_flush_all;
 	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
 
 	md->io_pool = mempool_create_slab_pool(MIN_IOS, _io_cache);
@@ -1278,7 +1277,7 @@ static void __flush_deferred_io(struct m
 		n = c->bi_next;
 		c->bi_next = NULL;
 		if (__split_bio(md, c))
-			bio_io_error(c, c->bi_size);
+			bio_io_error(c);
 		c = n;
 	}
 }
diff -puN drivers/md/dm-crypt.c~git-block-fixup drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~git-block-fixup
+++ a/drivers/md/dm-crypt.c
@@ -550,12 +550,11 @@ static void crypt_endio(struct bio *clon
 
 	bio_put(clone);
 	kcryptd_queue_crypt(io);
-	return 0;
+	return;
 
 out:
 	bio_put(clone);
 	crypt_dec_pending(io, error);
-	return error;
 }
 
 static void clone_init(struct dm_crypt_io *io, struct bio *clone)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
longhaul-add-auto-enabled-revid_errata-option-checkpatch-fixes.patch
slow-down-printk-during-boot.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
acpi-suppress-uninitialized-var-warning.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
git-cifs.patch
git-cpufreq.patch
git-powerpc.patch
git-dvb.patch
git-hwmon-fixup.patch
git-infiniband.patch
git-input.patch
git-input-fixup.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-jg-warning-fixes.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-libata-all.patch
ide-arm-hack.patch
git-mips.patch
git-mips-fixup.patch
git-mmc.patch
git-mmc-fixup2.patch
mmc-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-mtd-vs-powerpc.patch
git-net.patch
git-net-fixup.patch
forcedeth-power-down-phy-when-interface-is-down-checkpatch-fixes.patch
git-backlight.patch
git-net-vs-git-nfs.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-nfsd-fixup.patch
git-ocfs2.patch
git-s390.patch
git-sched.patch
git-sh.patch
git-sh64.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
git-scsi-misc-arcmsr-build-fix.patch
git-block.patch
git-block-fixup.patch
git-unionfs.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-net-vs-git-wireless.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
net-add-ath5k-wireless-driver-fix.patch
revert-x86_64-mm-cpa-einval.patch
fix-x86_64-mm-sched-clock-share.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
x86_64-cleanup-apic-c.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
asm-i386-ioh-fix-constness.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch
git-xfs.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
git-nfs-vs-nfs-convert-to-new-aops-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2-3.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-do-not-take-callback_mutex-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
uml-clocksource-support-fix.patch
uml-tickless-support-fix.patch
uml-fix-stub-address-calculations-checkpatch-fixes.patch
uml-arch-um-drivers-formatting-checkpatch-fixes.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
keys-make-request_key-and-co-fundamentally-asynchronous-vs-git-mmc.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
userc-ifdef-mq_bytes-fix.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
binfmt_flat-minimum-support-for-the-blackfin-relocations-checkpatch-fixes.patch
f_dupfd_cloexec-implementation-fix-2.patch
ext3-lighten-up-resize-transaction-requirements-checkpatch-fixes.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
export-font_vga_8x16.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
fbcon-logo-disable-logo-at-boot-fix.patch
md-software-raid-autodetect-dev-list-not-array.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
w1-build-fix.patch

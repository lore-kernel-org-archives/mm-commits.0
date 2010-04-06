From: akpm@linux-foundation.org
Subject: + vfs-rename-block_fsync-to-blkdev_fsync.patch added to -mm tree
Date: Tue, 06 Apr 2010 11:29:43 -0400
Message-ID: <201004061831.o36IV7o8000431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755649Ab0DFShD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 14:37:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, anton@samba.org, hch@lst.de, jack@suse.cz, jens.axboe@oracle.com, jmoyer@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: rename block_fsync() to blkdev_fsync()
has been added to the -mm tree.  Its filename is
     vfs-rename-block_fsync-to-blkdev_fsync.patch

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
Subject: vfs: rename block_fsync() to blkdev_fsync()
From: Andrew Morton <akpm@linux-foundation.org>

Requested by hch, for consistency now it is exported.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Anton Blanchard <anton@samba.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/raw.c |    2 +-
 fs/block_dev.c     |    6 +++---
 include/linux/fs.h |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/char/raw.c~vfs-rename-block_fsync-to-blkdev_fsync drivers/char/raw.c
--- a/drivers/char/raw.c~vfs-rename-block_fsync-to-blkdev_fsync
+++ a/drivers/char/raw.c
@@ -248,7 +248,7 @@ static const struct file_operations raw_
 	.aio_read = 	generic_file_aio_read,
 	.write	=	do_sync_write,
 	.aio_write =	blkdev_aio_write,
-	.fsync	=	block_fsync,
+	.fsync	=	blkdev_fsync,
 	.open	=	raw_open,
 	.release=	raw_release,
 	.ioctl	=	raw_ioctl,
diff -puN fs/block_dev.c~vfs-rename-block_fsync-to-blkdev_fsync fs/block_dev.c
--- a/fs/block_dev.c~vfs-rename-block_fsync-to-blkdev_fsync
+++ a/fs/block_dev.c
@@ -404,7 +404,7 @@ static loff_t block_llseek(struct file *
  *	NULL first argument is nfsd_sync_dir() and that's not a directory.
  */
  
-int block_fsync(struct file *filp, struct dentry *dentry, int datasync)
+int blkdev_fsync(struct file *filp, struct dentry *dentry, int datasync)
 {
 	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
 	int error;
@@ -418,7 +418,7 @@ int block_fsync(struct file *filp, struc
 		error = 0;
 	return error;
 }
-EXPORT_SYMBOL(block_fsync);
+EXPORT_SYMBOL(blkdev_fsync);
 
 /*
  * pseudo-fs
@@ -1482,7 +1482,7 @@ const struct file_operations def_blk_fop
   	.aio_read	= generic_file_aio_read,
 	.aio_write	= blkdev_aio_write,
 	.mmap		= generic_file_mmap,
-	.fsync		= block_fsync,
+	.fsync		= blkdev_fsync,
 	.unlocked_ioctl	= block_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= compat_blkdev_ioctl,
diff -puN include/linux/fs.h~vfs-rename-block_fsync-to-blkdev_fsync include/linux/fs.h
--- a/include/linux/fs.h~vfs-rename-block_fsync-to-blkdev_fsync
+++ a/include/linux/fs.h
@@ -2208,7 +2208,7 @@ extern int generic_segment_checks(const 
 /* fs/block_dev.c */
 extern ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
-extern int block_fsync(struct file *filp, struct dentry *dentry, int datasync);
+extern int blkdev_fsync(struct file *filp, struct dentry *dentry, int datasync);
 
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bitops-remove-temporary-for_each_bit.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
exit-fix-oops-in-sync_mm_rss-fix.patch
drivers-char-amiserialc-add-missing-local_irq_restore.patch
mxser-spin_lock-=-spin_lock_irq-fix.patch
vfs-rename-block_fsync-to-blkdev_fsync.patch
ratelimit-annotate-___ratelimit-fix.patch
rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method-checkpatch-fixes.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915-checkpatch-fixes.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cifs-provide-user-with-a-hint-when-name-resolution-fails-fix.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch
ipc-mqueuec-let-message-queue-timeout-use-hrtimers-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
x86_32-use-asm-generic-scatterlisth.patch
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


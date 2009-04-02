From: akpm@linux-foundation.org
Subject: [folded] nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 02 Apr 2009 16:22:47 -0700
Message-ID: <200904022322.n32NMldR011652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757284AbZDBXZ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 19:25:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jens.axboe@oracle.com, paul.clements@steeleye.com, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     nbd-add-locking-to-nbd_ioctl-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch

This patch was dropped because it was folded into nbd-add-locking-to-nbd_ioctl.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nbd-add-locking-to-nbd_ioctl-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#74: FILE: drivers/block/nbd.c:577:
+			 * Set these to sane values in case server implementation

WARNING: line over 80 characters
#75: FILE: drivers/block/nbd.c:578:
+			 * fails to check the request type first and also to keep

WARNING: line over 80 characters
#132: FILE: drivers/block/nbd.c:610:
+				struct inode *inode = file->f_path.dentry->d_inode;

WARNING: line over 80 characters
#211: FILE: drivers/block/nbd.c:663:
+			thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);

WARNING: line over 80 characters
#227: FILE: drivers/block/nbd.c:679:
+			printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);

total: 0 errors, 5 warnings, 253 lines checked

./patches/nbd-add-locking-to-nbd_ioctl.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Paul Clements <paul.clements@steeleye.com>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |  163 ++++++++++++++++++++----------------------
 1 file changed, 80 insertions(+), 83 deletions(-)

diff -puN drivers/block/nbd.c~nbd-add-locking-to-nbd_ioctl-checkpatch-fixes drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-add-locking-to-nbd_ioctl-checkpatch-fixes
+++ a/drivers/block/nbd.c
@@ -565,61 +565,59 @@ static int __nbd_ioctl(struct block_devi
 		       unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
-	case NBD_DISCONNECT:
+	case NBD_DISCONNECT: {
+		struct request sreq;
+
 	        printk(KERN_INFO "%s: NBD_DISCONNECT\n", lo->disk->disk_name);
-		{
-			struct request sreq;
 
-			blk_rq_init(NULL, &sreq);
-			sreq.cmd_type = REQ_TYPE_SPECIAL;
-			nbd_cmd(&sreq) = NBD_CMD_DISC;
-			/*
-			 * Set these to sane values in case server implementation
-			 * fails to check the request type first and also to keep
-			 * debugging output cleaner.
-			 */
-			sreq.sector = 0;
-			sreq.nr_sectors = 0;
-			if (!lo->sock)
-				return -EINVAL;
-			nbd_send_req(lo, &sreq);
-		}
+		blk_rq_init(NULL, &sreq);
+		sreq.cmd_type = REQ_TYPE_SPECIAL;
+		nbd_cmd(&sreq) = NBD_CMD_DISC;
+		/*
+		 * Set these to sane values in case server implementation
+		 * fails to check the request type first and also to keep
+		 * debugging output cleaner.
+		 */
+		sreq.sector = 0;
+		sreq.nr_sectors = 0;
+		if (!lo->sock)
+			return -EINVAL;
+		nbd_send_req(lo, &sreq);
                 return 0;
+	}
  
-	case NBD_CLEAR_SOCK:
-		{
-			struct file *file;
-
-			lo->sock = NULL;
-			file = lo->file;
-			lo->file = NULL;
-			nbd_clear_que(lo);
-			BUG_ON(!list_empty(&lo->queue_head));
-			if (file)
-				fput(file);
-		}
-	return 0;
+	case NBD_CLEAR_SOCK: {
+		struct file *file;
 
-	case NBD_SET_SOCK:
-		{
-			struct file *file;
-			if (lo->file)
-				return -EBUSY;
-			file = fget(arg);
-			if (file) {
-				struct inode *inode = file->f_path.dentry->d_inode;
-				if (S_ISSOCK(inode->i_mode)) {
-					lo->file = file;
-					lo->sock = SOCKET_I(inode);
-					if (max_part > 0)
-						bdev->bd_invalidated = 1;
-					return 0;
-				} else {
-					fput(file);
-				}
+		lo->sock = NULL;
+		file = lo->file;
+		lo->file = NULL;
+		nbd_clear_que(lo);
+		BUG_ON(!list_empty(&lo->queue_head));
+		if (file)
+			fput(file);
+		return 0;
+	}
+
+	case NBD_SET_SOCK: {
+		struct file *file;
+		if (lo->file)
+			return -EBUSY;
+		file = fget(arg);
+		if (file) {
+			struct inode *inode = file->f_path.dentry->d_inode;
+			if (S_ISSOCK(inode->i_mode)) {
+				lo->file = file;
+				lo->sock = SOCKET_I(inode);
+				if (max_part > 0)
+					bdev->bd_invalidated = 1;
+				return 0;
+			} else {
+				fput(file);
 			}
 		}
 		return -EINVAL;
+	}
 
 	case NBD_SET_BLKSIZE:
 		lo->blksize = arg;
@@ -647,45 +645,44 @@ static int __nbd_ioctl(struct block_devi
 		set_capacity(lo->disk, lo->bytesize >> 9);
 		return 0;
 
-	case NBD_DO_IT:
-		{
-			struct task_struct *thread;
-			struct file *file;
-			int error;
-
-			if (lo->pid)
-				return -EBUSY;
-			if (!lo->file)
-				return -EINVAL;
-
-			mutex_unlock(&lo->tx_lock);
-
-			thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
-			if (IS_ERR(thread)) {
-				mutex_lock(&lo->tx_lock);
-				return PTR_ERR(thread);
-			}
-			wake_up_process(thread);
-			error = nbd_do_it(lo);
-			kthread_stop(thread);
+	case NBD_DO_IT: {
+		struct task_struct *thread;
+		struct file *file;
+		int error;
+
+		if (lo->pid)
+			return -EBUSY;
+		if (!lo->file)
+			return -EINVAL;
+
+		mutex_unlock(&lo->tx_lock);
 
+		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
+		if (IS_ERR(thread)) {
 			mutex_lock(&lo->tx_lock);
-			if (error)
-				return error;
-			sock_shutdown(lo, 0);
-			file = lo->file;
-			lo->file = NULL;
-			nbd_clear_que(lo);
-			printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
-			if (file)
-				fput(file);
-			lo->bytesize = 0;
-			bdev->bd_inode->i_size = 0;
-			set_capacity(lo->disk, 0);
-			if (max_part > 0)
-				ioctl_by_bdev(bdev, BLKRRPART, 0);
-			return lo->harderror;
+			return PTR_ERR(thread);
 		}
+		wake_up_process(thread);
+		error = nbd_do_it(lo);
+		kthread_stop(thread);
+
+		mutex_lock(&lo->tx_lock);
+		if (error)
+			return error;
+		sock_shutdown(lo, 0);
+		file = lo->file;
+		lo->file = NULL;
+		nbd_clear_que(lo);
+		printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
+		if (file)
+			fput(file);
+		lo->bytesize = 0;
+		bdev->bd_inode->i_size = 0;
+		set_capacity(lo->disk, 0);
+		if (max_part > 0)
+			ioctl_by_bdev(bdev, BLKRRPART, 0);
+		return lo->harderror;
+	}
 
 	case NBD_CLEAR_QUE:
 		/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
workqueue-add-to_delayed_work-helper-function.patch
simplify-copy_thread.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-show-memcg-information-during-oom.patch
forget_original_parent-do-not-abuse-child-ptrace_entry.patch
hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-against-smi.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
nbd-add-locking-to-nbd_ioctl.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
arch-x86-mm-iomap_32c-fix-warning.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
flex-onenand-support-v2-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
xtensa-add-flat-support-checkpatch-fixes.patch
max3100-spi-uart-driver-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
kernel-auditscc-fix-warning.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch


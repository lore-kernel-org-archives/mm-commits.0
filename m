From: akpm@linux-foundation.org
Subject: + nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch added to -mm tree
Date: Wed, 28 Jan 2009 17:19:07 -0800
Message-ID: <200901290119.n0T1J736012523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757830AbZA2BTo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 20:19:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com, paul.clements@steeleye.com, pavel@suse.cz


The patch titled
     nbd-add-locking-to-nbd_ioctl-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch

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

kprobes-fix-module-compilation-error-with-config_kprobes=n.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
kvm-unbork.patch
acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
mm-mmapc-avoid-referencing-a-freed-vma-in-mmap_region.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read-simplification.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-checkpatch-fixes.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
sgi-gru-add-definitions-of-x86_64-gru-mmrs-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch


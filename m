From: akpm@linux-foundation.org
Subject: - remove-invalidate_inode_pages.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:57 -0800
Message-ID: <200702112252.l1BMqv3t016065@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60310 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932794AbXBKWw7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:59 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1BMqvUI016376
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Sun, 11 Feb 2007 14:52:57 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     remove invalidate_inode_pages()
has been removed from the -mm tree.  Its filename was
     remove-invalidate_inode_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove invalidate_inode_pages()
From: Andrew Morton <akpm@osdl.org>

Convert all calls to invalidate_inode_pages() into open-coded calls to
invalidate_mapping_pages().

Leave the invalidate_inode_pages() wrapper in place for now, marked as
deprecated.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c               |    2 +-
 drivers/mtd/devices/block2mtd.c   |    3 ++-
 drivers/usb/gadget/file_storage.c |    2 +-
 fs/9p/vfs_file.c                  |    4 ++--
 fs/buffer.c                       |    2 +-
 fs/drop_caches.c                  |    2 +-
 fs/fuse/file.c                    |    2 +-
 fs/fuse/inode.c                   |    2 +-
 fs/inode.c                        |    3 ++-
 fs/jffs/inode-v23.c               |    4 ++--
 include/linux/fs.h                |    4 ++--
 mm/truncate.c                     |    4 ++--
 12 files changed, 18 insertions(+), 16 deletions(-)

diff -puN drivers/md/bitmap.c~remove-invalidate_inode_pages drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~remove-invalidate_inode_pages
+++ a/drivers/md/bitmap.c
@@ -666,7 +666,7 @@ static void bitmap_file_put(struct bitma
 
 	if (file) {
 		struct inode *inode = file->f_path.dentry->d_inode;
-		invalidate_inode_pages(inode->i_mapping);
+		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		fput(file);
 	}
 }
diff -puN drivers/mtd/devices/block2mtd.c~remove-invalidate_inode_pages drivers/mtd/devices/block2mtd.c
--- a/drivers/mtd/devices/block2mtd.c~remove-invalidate_inode_pages
+++ a/drivers/mtd/devices/block2mtd.c
@@ -278,7 +278,8 @@ static void block2mtd_free_device(struct
 	kfree(dev->mtd.name);
 
 	if (dev->blkdev) {
-		invalidate_inode_pages(dev->blkdev->bd_inode->i_mapping);
+		invalidate_mapping_pages(dev->blkdev->bd_inode->i_mapping,
+					0, -1);
 		close_bdev_excl(dev->blkdev);
 	}
 
diff -puN drivers/usb/gadget/file_storage.c~remove-invalidate_inode_pages drivers/usb/gadget/file_storage.c
--- a/drivers/usb/gadget/file_storage.c~remove-invalidate_inode_pages
+++ a/drivers/usb/gadget/file_storage.c
@@ -1953,7 +1953,7 @@ static void invalidate_sub(struct lun *c
 	struct inode	*inode = filp->f_path.dentry->d_inode;
 	unsigned long	rc;
 
-	rc = invalidate_inode_pages(inode->i_mapping);
+	rc = invalidate_mapping_pages(inode->i_mapping, 0, -1);
 	VLDBG(curlun, "invalidate_inode_pages -> %ld\n", rc);
 }
 
diff -puN fs/9p/vfs_file.c~remove-invalidate_inode_pages fs/9p/vfs_file.c
--- a/fs/9p/vfs_file.c~remove-invalidate_inode_pages
+++ a/fs/9p/vfs_file.c
@@ -110,7 +110,7 @@ static int v9fs_file_lock(struct file *f
 
 	if ((IS_SETLK(cmd) || IS_SETLKW(cmd)) && fl->fl_type != F_UNLCK) {
 		filemap_write_and_wait(inode->i_mapping);
-		invalidate_inode_pages(&inode->i_data);
+		invalidate_mapping_pages(&inode->i_data, 0, -1);
 	}
 
 	return res;
@@ -234,7 +234,7 @@ v9fs_file_write(struct file *filp, const
 		total += result;
 	} while (count);
 
-		invalidate_inode_pages2(inode->i_mapping);
+	invalidate_inode_pages2(inode->i_mapping);
 	return total;
 }
 
diff -puN fs/buffer.c~remove-invalidate_inode_pages fs/buffer.c
--- a/fs/buffer.c~remove-invalidate_inode_pages
+++ a/fs/buffer.c
@@ -345,7 +345,7 @@ void invalidate_bdev(struct block_device
 	 * We really want to use invalidate_inode_pages2() for
 	 * that, but not until that's cleaned up.
 	 */
-	invalidate_inode_pages(mapping);
+	invalidate_mapping_pages(mapping, 0, -1);
 }
 
 /*
diff -puN fs/drop_caches.c~remove-invalidate_inode_pages fs/drop_caches.c
--- a/fs/drop_caches.c~remove-invalidate_inode_pages
+++ a/fs/drop_caches.c
@@ -20,7 +20,7 @@ static void drop_pagecache_sb(struct sup
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE))
 			continue;
-		invalidate_inode_pages(inode->i_mapping);
+		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 	}
 	spin_unlock(&inode_lock);
 }
diff -puN fs/fuse/file.c~remove-invalidate_inode_pages fs/fuse/file.c
--- a/fs/fuse/file.c~remove-invalidate_inode_pages
+++ a/fs/fuse/file.c
@@ -69,7 +69,7 @@ void fuse_finish_open(struct inode *inod
 	if (outarg->open_flags & FOPEN_DIRECT_IO)
 		file->f_op = &fuse_direct_io_file_operations;
 	if (!(outarg->open_flags & FOPEN_KEEP_CACHE))
-		invalidate_inode_pages(inode->i_mapping);
+		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 	ff->fh = outarg->fh;
 	file->private_data = ff;
 }
diff -puN fs/fuse/inode.c~remove-invalidate_inode_pages fs/fuse/inode.c
--- a/fs/fuse/inode.c~remove-invalidate_inode_pages
+++ a/fs/fuse/inode.c
@@ -112,7 +112,7 @@ void fuse_change_attributes(struct inode
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	if (S_ISREG(inode->i_mode) && i_size_read(inode) != attr->size)
-		invalidate_inode_pages(inode->i_mapping);
+		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 
 	inode->i_ino     = attr->ino;
 	inode->i_mode    = (inode->i_mode & S_IFMT) + (attr->mode & 07777);
diff -puN fs/inode.c~remove-invalidate_inode_pages fs/inode.c
--- a/fs/inode.c~remove-invalidate_inode_pages
+++ a/fs/inode.c
@@ -414,7 +414,8 @@ static void prune_icache(int nr_to_scan)
 			__iget(inode);
 			spin_unlock(&inode_lock);
 			if (remove_inode_buffers(inode))
-				reap += invalidate_inode_pages(&inode->i_data);
+				reap += invalidate_mapping_pages(&inode->i_data,
+								0, -1);
 			iput(inode);
 			spin_lock(&inode_lock);
 
diff -puN fs/jffs/inode-v23.c~remove-invalidate_inode_pages fs/jffs/inode-v23.c
--- a/fs/jffs/inode-v23.c~remove-invalidate_inode_pages
+++ a/fs/jffs/inode-v23.c
@@ -296,7 +296,7 @@ jffs_setattr(struct dentry *dentry, stru
 		inode->i_blocks = (inode->i_size + 511) >> 9;
 
 		if (len) {
-			invalidate_inode_pages(inode->i_mapping);
+			invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		}
 		inode->i_ctime = CURRENT_TIME_SEC;
 		inode->i_mtime = inode->i_ctime;
@@ -1518,7 +1518,7 @@ jffs_file_write(struct file *filp, const
 	}
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
-	invalidate_inode_pages(inode->i_mapping);
+	invalidate_mapping_pages(inode->i_mapping, 0, -1);
 
  out_isem:
 	return err;
diff -puN include/linux/fs.h~remove-invalidate_inode_pages include/linux/fs.h
--- a/include/linux/fs.h~remove-invalidate_inode_pages
+++ a/include/linux/fs.h
@@ -1574,7 +1574,7 @@ extern int invalidate_inodes(struct supe
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
 
-static inline unsigned long
+static inline unsigned long __deprecated
 invalidate_inode_pages(struct address_space *mapping)
 {
 	return invalidate_mapping_pages(mapping, 0, ~0UL);
@@ -1584,7 +1584,7 @@ static inline void invalidate_remote_ino
 {
 	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
 	    S_ISLNK(inode->i_mode))
-		invalidate_inode_pages(inode->i_mapping);
+		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 }
 extern int invalidate_inode_pages2(struct address_space *mapping);
 extern int invalidate_inode_pages2_range(struct address_space *mapping,
diff -puN mm/truncate.c~remove-invalidate_inode_pages mm/truncate.c
--- a/mm/truncate.c~remove-invalidate_inode_pages
+++ a/mm/truncate.c
@@ -85,7 +85,7 @@ EXPORT_SYMBOL(cancel_dirty_page);
  *
  * We need to bale out if page->mapping is no longer equal to the original
  * mapping.  This happens a) when the VM reclaimed the page while we waited on
- * its lock, b) when a concurrent invalidate_inode_pages got there first and
+ * its lock, b) when a concurrent invalidate_mapping_pages got there first and
  * c) when tmpfs swizzles a page between a tmpfs inode and swapper_space.
  */
 static void
@@ -106,7 +106,7 @@ truncate_complete_page(struct address_sp
 }
 
 /*
- * This is for invalidate_inode_pages().  That function can be called at
+ * This is for invalidate_mapping_pages().  That function can be called at
  * any time, and is not supposed to throw away dirty pages.  But pages can
  * be marked dirty at any time too, so use remove_mapping which safely
  * discards clean, unused pages.
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
add-an-rcu-version-of-list-splicing.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
git-agpgart.patch
git-dvb.patch
git-ia64.patch
git-ieee1394.patch
git-infiniband.patch
git-libata-all.patch
git-lxdialog-fixup.patch
git-mtd.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
netfilter-warning-fix.patch
git-backlight.patch
net-uninline-skb_put.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-block-xfs-barriers-broke.patch
nokia-e70-is-an-unusual-device.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
factor-outstanding-i-o-error-handling-tidy.patch
sync_sb_inodes-propagate-errors.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
vmi-versus-hrtimers.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
i386-use-gtod-persistent-clock-support.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i383-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-generalize-metadata-read-write-fix.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
dynamic-kernel-command-line-ia64-fix.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
reiser4-test_clear_page_dirty.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
slim-main-include-fix.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
ia64-enable-config_debug_spinlock_sleep.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

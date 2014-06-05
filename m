From: akpm@linux-foundation.org
Subject: [merged] fs-add-generic-data-flush-to-fsync.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:43:04 -0700
Message-ID: <5390c848.YJq2i/DchB2A2jqQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaFETnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:43:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, jack@suse.cz, hch@infradead.org, fabf@skynet.be

Subject: [merged] fs-add-generic-data-flush-to-fsync.patch removed from -mm tree
To: fabf@skynet.be,hch@infradead.org,jack@suse.cz,tytso@mit.edu,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:43:04 -0700


The patch titled
     Subject: fs/libfs.c: add generic data flush to fsync
has been removed from the -mm tree.  Its filename was
     fs-add-generic-data-flush-to-fsync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/libfs.c: add generic data flush to fsync

Description by Jan Kara:
"A lot of older filesystems don't properly flush volatile disk caches
on fsync(2) which can lead to loss of fsynced data after power failure.

This patch makes generic_file_fsync() issue proper cache flush to fix the
problem.  Sysadmin can use /sys/devices/.../cache_type to tell the system
it should not send the cache flush."

[akpm@linux-foundation.org: nuke ifdef]
[akpm@linux-foundation.org: fix warning]
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c             |   34 +++++++++++++++++++++++++++++++---
 include/linux/blkdev.h |    9 +++++++++
 include/linux/fs.h     |    1 +
 3 files changed, 41 insertions(+), 3 deletions(-)

diff -puN fs/libfs.c~fs-add-generic-data-flush-to-fsync fs/libfs.c
--- a/fs/libfs.c~fs-add-generic-data-flush-to-fsync
+++ a/fs/libfs.c
@@ -3,6 +3,7 @@
  *	Library for filesystems writers.
  */
 
+#include <linux/blkdev.h>
 #include <linux/export.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
@@ -923,16 +924,19 @@ struct dentry *generic_fh_to_parent(stru
 EXPORT_SYMBOL_GPL(generic_fh_to_parent);
 
 /**
- * generic_file_fsync - generic fsync implementation for simple filesystems
+ * __generic_file_fsync - generic fsync implementation for simple filesystems
+ *
  * @file:	file to synchronize
+ * @start:	start offset in bytes
+ * @end:	end offset in bytes (inclusive)
  * @datasync:	only synchronize essential metadata if true
  *
  * This is a generic implementation of the fsync method for simple
  * filesystems which track all non-inode metadata in the buffers list
  * hanging off the address_space structure.
  */
-int generic_file_fsync(struct file *file, loff_t start, loff_t end,
-		       int datasync)
+int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
+				 int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	int err;
@@ -952,10 +956,34 @@ int generic_file_fsync(struct file *file
 	err = sync_inode_metadata(inode, 1);
 	if (ret == 0)
 		ret = err;
+
 out:
 	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(__generic_file_fsync);
+
+/**
+ * generic_file_fsync - generic fsync implementation for simple filesystems
+ *			with flush
+ * @file:	file to synchronize
+ * @start:	start offset in bytes
+ * @end:	end offset in bytes (inclusive)
+ * @datasync:	only synchronize essential metadata if true
+ *
+ */
+
+int generic_file_fsync(struct file *file, loff_t start, loff_t end,
+		       int datasync)
+{
+	struct inode *inode = file->f_mapping->host;
+	int err;
+
+	err = __generic_file_fsync(file, start, end, datasync);
+	if (err)
+		return err;
+	return blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+}
 EXPORT_SYMBOL(generic_file_fsync);
 
 /**
diff -puN include/linux/blkdev.h~fs-add-generic-data-flush-to-fsync include/linux/blkdev.h
--- a/include/linux/blkdev.h~fs-add-generic-data-flush-to-fsync
+++ a/include/linux/blkdev.h
@@ -1607,6 +1607,9 @@ struct block_device_operations {
 extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
 				 unsigned long);
 #else /* CONFIG_BLOCK */
+
+struct block_device;
+
 /*
  * stubs for when the block layer is configured out
  */
@@ -1642,6 +1645,12 @@ static inline bool blk_needs_flush_plug(
 	return false;
 }
 
+static inline int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
+				     sector_t *error_sector)
+{
+	return 0;
+}
+
 #endif /* CONFIG_BLOCK */
 
 #endif
diff -puN include/linux/fs.h~fs-add-generic-data-flush-to-fsync include/linux/fs.h
--- a/include/linux/fs.h~fs-add-generic-data-flush-to-fsync
+++ a/include/linux/fs.h
@@ -2590,6 +2590,7 @@ extern ssize_t simple_read_from_buffer(v
 extern ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
 		const void __user *from, size_t count);
 
+extern int __generic_file_fsync(struct file *, loff_t, loff_t, int);
 extern int generic_file_fsync(struct file *, loff_t, loff_t, int);
 
 extern int generic_check_addressable(unsigned, u64);
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch
fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch
fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
fs-hpfs-increase-pr_warn-level.patch
documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch
fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch
fs-proc-vmcorec-remove-null-assignment-on-static.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-cachefiles-convert-printk-to-pr_foo.patch
fs-cachefiles-replace-kerror-by-pr_err.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
mm-kmemleak-testc-use-pr_fmt-for-logging.patch
ufs-sb-mutex-merge-mutex_destroy.patch


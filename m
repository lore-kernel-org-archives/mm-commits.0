From: akpm@linux-foundation.org
Subject: + fs-add-generic-data-flush-to-fsync.patch added to -mm tree
Date: Thu, 15 May 2014 12:52:11 -0700
Message-ID: <53751aeb.l/5Zha33a85blDAx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaEOTwM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 15:52:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, jack@suse.cz, hch@infradead.org, fabf@skynet.be

Subject: + fs-add-generic-data-flush-to-fsync.patch added to -mm tree
To: fabf@skynet.be,hch@infradead.org,jack@suse.cz,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 12:52:11 -0700


The patch titled
     Subject: fs/libfs.c: add generic data flush to fsync
has been added to the -mm tree.  Its filename is
     fs-add-generic-data-flush-to-fsync.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-add-generic-data-flush-to-fsync.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-add-generic-data-flush-to-fsync.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/libfs.c: add generic data flush to fsync

Description by Jan Kara:
"A lot of older filesystems don't properly flush volatile disk caches
on fsync(2) which can lead to loss of fsynced data after power failure.

This patch makes generic_file_fsync() issue proper cache flush to fix the
problem.  Sysadmin can use /sys/devices/.../cache_type to tell the system
it should not send the cache flush."

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c         |   39 ++++++++++++++++++++++++++++++++++++---
 include/linux/fs.h |    1 +
 2 files changed, 37 insertions(+), 3 deletions(-)

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
@@ -952,10 +956,39 @@ int generic_file_fsync(struct file *file
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
+#ifdef CONFIG_BLOCK
+	return blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+#else
+	return err;
+#endif
+
+}
 EXPORT_SYMBOL(generic_file_fsync);
 
 /**
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

fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
fs-fscache-convert-printk-to-pr_foo.patch
fs-fscache-replace-seq_printf-by-seq_puts.patch
fs-gfs2-bmapc-kernel-doc-warning-fixes.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-time-ntpc-convert-simple_strtol-to-kstrtol.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
fs-configfs-convert-printk-to-pr_foo.patch
fs-configfs-use-pr_fmt.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
fs-add-generic-data-flush-to-fsync.patch
fs-add-generic-data-flush-to-fsync-fix.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-mempolicyc-parameter-doc-uniformization.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-efivarfs-superc-use-static-const-for-dentry_operations.patch
fs-exportfs-expfsc-kernel-doc-warning-fixes.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-exec_domainc-code-clean-up.patch
kernel-latencytopc-convert-seq_printf-to-seq_puts.patch
kernel-stop_machinec-kernel-doc-warning-fix.patch
kernel-tracepointc-kernel-doc-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch
kernel-utsname_sysctlc-replace-obsolete-__initcall-by-device_initcall.patch
kernel-hung_taskc-convert-simple_strtoul-to-kstrtouint.patch
documentation-expand-clarify-debug-documentation.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
fs-efs-convert-printk-to-pr_foo.patch
fs-efs-add-pr_fmt-use-__func__.patch
fs-efs-convert-printkkern_debug-to-pr_debug.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
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
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
ufs-sb-mutex-merge-mutex_destroy.patch


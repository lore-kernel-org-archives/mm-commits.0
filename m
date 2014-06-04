From: akpm@linux-foundation.org
Subject: [merged]
 fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch removed
 from -mm tree
Date: Wed, 04 Jun 2014 12:01:21 -0700
Message-ID: <538f6d01.EzBWkZlor8G47gfg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaFDTBW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 15:01:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shaggy@kernel.org, fabf@skynet.be

Subject: [merged] fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch removed from -mm tree
To: fabf@skynet.be,shaggy@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 12:01:21 -0700


The patch titled
     Subject: fs/jfs/super.c: remove 0 assignement to static + code clean-up
has been removed from the -mm tree.  Its filename was
     fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/jfs/super.c: remove 0 assignement to static + code clean-up

-Static values are automatically initialized to NULL
-Coalesce format fragments
-Remove unnecessary {}
-Small typo fixes
-Fix lines > 80 characters

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Dave Kleikamp <shaggy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/super.c |   45 +++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff -puN fs/jfs/super.c~fs-jfs-superc-remove-0-assignement-to-static-code-clean-up fs/jfs/super.c
--- a/fs/jfs/super.c~fs-jfs-superc-remove-0-assignement-to-static-code-clean-up
+++ a/fs/jfs/super.c
@@ -50,14 +50,14 @@ MODULE_DESCRIPTION("The Journaled Filesy
 MODULE_AUTHOR("Steve Best/Dave Kleikamp/Barry Arndt, IBM");
 MODULE_LICENSE("GPL");
 
-static struct kmem_cache * jfs_inode_cachep;
+static struct kmem_cache *jfs_inode_cachep;
 
 static const struct super_operations jfs_super_operations;
 static const struct export_operations jfs_export_operations;
 static struct file_system_type jfs_fs_type;
 
 #define MAX_COMMIT_THREADS 64
-static int commit_threads = 0;
+static int commit_threads;
 module_param(commit_threads, int, 0);
 MODULE_PARM_DESC(commit_threads, "Number of commit threads");
 
@@ -84,8 +84,7 @@ static void jfs_handle_error(struct supe
 		panic("JFS (device %s): panic forced after error\n",
 			sb->s_id);
 	else if (sbi->flag & JFS_ERR_REMOUNT_RO) {
-		jfs_err("ERROR: (device %s): remounting filesystem "
-			"as read-only\n",
+		jfs_err("ERROR: (device %s): remounting filesystem as read-only\n",
 			sb->s_id);
 		sb->s_flags |= MS_RDONLY;
 	}
@@ -363,12 +362,10 @@ static int parse_options(char *options,
 			 * -> user has more control over the online trimming
 			 */
 			sbi->minblks_trim = 64;
-			if (blk_queue_discard(q)) {
+			if (blk_queue_discard(q))
 				*flag |= JFS_DISCARD;
-			} else {
-				pr_err("JFS: discard option " \
-					"not supported on device\n");
-			}
+			else
+				pr_err("JFS: discard option not supported on device\n");
 			break;
 		}
 
@@ -385,15 +382,14 @@ static int parse_options(char *options,
 				sbi->minblks_trim = simple_strtoull(
 					minblks_trim, &minblks_trim, 0);
 			} else {
-				pr_err("JFS: discard option " \
-					"not supported on device\n");
+				pr_err("JFS: discard option not supported on device\n");
 			}
 			break;
 		}
 
 		default:
-			printk("jfs: Unrecognized mount option \"%s\" "
-					" or missing value\n", p);
+			printk("jfs: Unrecognized mount option \"%s\" or missing value\n",
+			       p);
 			goto cleanup;
 		}
 	}
@@ -419,14 +415,12 @@ static int jfs_remount(struct super_bloc
 	int ret;
 
 	sync_filesystem(sb);
-	if (!parse_options(data, sb, &newLVSize, &flag)) {
+	if (!parse_options(data, sb, &newLVSize, &flag))
 		return -EINVAL;
-	}
 
 	if (newLVSize) {
 		if (sb->s_flags & MS_RDONLY) {
-			pr_err("JFS: resize requires volume" \
-				" to be mounted read-write\n");
+			pr_err("JFS: resize requires volume to be mounted read-write\n");
 			return -EROFS;
 		}
 		rc = jfs_extendfs(sb, newLVSize, 0);
@@ -452,9 +446,8 @@ static int jfs_remount(struct super_bloc
 	}
 	if ((!(sb->s_flags & MS_RDONLY)) && (*flags & MS_RDONLY)) {
 		rc = dquot_suspend(sb, -1);
-		if (rc < 0) {
+		if (rc < 0)
 			return rc;
-		}
 		rc = jfs_umount_rw(sb);
 		JFS_SBI(sb)->flag = flag;
 		return rc;
@@ -487,7 +480,7 @@ static int jfs_fill_super(struct super_b
 	if (!new_valid_dev(sb->s_bdev->bd_dev))
 		return -EOVERFLOW;
 
-	sbi = kzalloc(sizeof (struct jfs_sb_info), GFP_KERNEL);
+	sbi = kzalloc(sizeof(struct jfs_sb_info), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
 
@@ -548,9 +541,8 @@ static int jfs_fill_super(struct super_b
 
 	rc = jfs_mount(sb);
 	if (rc) {
-		if (!silent) {
+		if (!silent)
 			jfs_err("jfs_mount failed w/return code = %d", rc);
-		}
 		goto out_mount_failed;
 	}
 	if (sb->s_flags & MS_RDONLY)
@@ -587,7 +579,8 @@ static int jfs_fill_super(struct super_b
 	 * Page cache is indexed by long.
 	 * I would use MAX_LFS_FILESIZE, but it's only half as big
 	 */
-	sb->s_maxbytes = min(((u64) PAGE_CACHE_SIZE << 32) - 1, (u64)sb->s_maxbytes);
+	sb->s_maxbytes = min(((u64) PAGE_CACHE_SIZE << 32) - 1,
+			     (u64)sb->s_maxbytes);
 #endif
 	sb->s_time_gran = 1;
 	return 0;
@@ -597,9 +590,8 @@ out_no_root:
 
 out_no_rw:
 	rc = jfs_umount(sb);
-	if (rc) {
+	if (rc)
 		jfs_err("jfs_umount failed with return code %d", rc);
-	}
 out_mount_failed:
 	filemap_write_and_wait(sbi->direct_inode->i_mapping);
 	truncate_inode_pages(sbi->direct_inode->i_mapping, 0);
@@ -924,7 +916,8 @@ static int __init init_jfs_fs(void)
 		commit_threads = MAX_COMMIT_THREADS;
 
 	for (i = 0; i < commit_threads; i++) {
-		jfsCommitThread[i] = kthread_run(jfs_lazycommit, NULL, "jfsCommit");
+		jfsCommitThread[i] = kthread_run(jfs_lazycommit, NULL,
+						 "jfsCommit");
 		if (IS_ERR(jfsCommitThread[i])) {
 			rc = PTR_ERR(jfsCommitThread[i]);
 			jfs_err("init_jfs_fs: fork failed w/rc = %d", rc);
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
fs-fscache-convert-printk-to-pr_foo.patch
fs-fscache-replace-seq_printf-by-seq_puts.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
fs-configfs-convert-printk-to-pr_foo.patch
fs-configfs-use-pr_fmt.patch
lib-debugobjectsc-convert-printk-to-pr_foo.patch
lib-debugobjectsc-add-pr_fmt-to-logging.patch
lib-debugobjectsc-convert-printkkern_debug-to-pr_debug.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-ocfs2-ioctlc-add-static-to-local-functions.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
fs-add-generic-data-flush-to-fsync.patch
fs-add-generic-data-flush-to-fsync-fix.patch
fs-add-generic-data-flush-to-fsync-fix-fix.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-mempolicyc-parameter-doc-uniformization.patch
fs-hugetlbfs-inodec-add-static-to-hugetlbfs_i_mmap_mutex_key.patch
fs-hugetlbfs-inodec-use-static-const-for-dentry_operations.patch
fs-hugetlbfs-inodec-remove-null-test-before-kfree.patch
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
lib-radix-treec-kernel-doc-warning-fix.patch
lib-crc32c-remove-unnecessary-__constant.patch
lib-digsigc-kernel-doc-warning-fixes.patch
lib-nlattrc-move-export_symbol-after-functions.patch
lib-textsearchc-move-export_symbol-after-functions.patch
lib-bugc-convert-printk-to-pr_foo.patch
lib-atomic64_testc-convert-printkkern_info-to-pr_info.patch
lib-asn1_decoderc-kernel-doc-warning-fix.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
scripts-checkpatchpl-device_initcall-is-not-the-only-__initcall-substitute.patch
fs-efs-convert-printk-to-pr_foo.patch
fs-efs-add-pr_fmt-use-__func__.patch
fs-efs-convert-printkkern_debug-to-pr_debug.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-ncpfs-getoptc-replace-simple_strtoul-by-kstrtoul.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
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


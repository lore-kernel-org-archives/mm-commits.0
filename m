From: akpm@linux-foundation.org
Subject: +
 fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch added to
 -mm tree
Date: Wed, 30 Apr 2014 15:34:03 -0700
Message-ID: <53617a5b.G2bj3HY22UiFtU4w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759644AbaD3WeE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 18:34:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shaggy@kernel.org, fabf@skynet.be

Subject: + fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch added to -mm tree
To: fabf@skynet.be,shaggy@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 15:34:03 -0700


The patch titled
     Subject: fs/jfs/super.c: remove 0 assignement to static + code clean-up
has been added to the -mm tree.  Its filename is
     fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch

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

ntfs-remove-null-value-assignments.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch


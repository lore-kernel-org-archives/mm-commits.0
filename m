From: akpm@linux-foundation.org
Subject: [merged] fs-configfs-use-pr_fmt.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:42:30 -0700
Message-ID: <5390c826.o9z9TjV91pXAv8CX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaFETma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jlbec@evilplan.org, fabf@skynet.be

Subject: [merged] fs-configfs-use-pr_fmt.patch removed from -mm tree
To: fabf@skynet.be,jlbec@evilplan.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:30 -0700


The patch titled
     Subject: fs/configfs: use pr_fmt
has been removed from the -mm tree.  Its filename was
     fs-configfs-use-pr_fmt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/configfs: use pr_fmt

Add pr_fmt based on module name.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/configfs_internal.h |    6 ++++++
 fs/configfs/dir.c               |    4 ++--
 fs/configfs/inode.c             |    2 +-
 fs/configfs/mount.c             |    4 ++--
 4 files changed, 11 insertions(+), 5 deletions(-)

diff -puN fs/configfs/configfs_internal.h~fs-configfs-use-pr_fmt fs/configfs/configfs_internal.h
--- a/fs/configfs/configfs_internal.h~fs-configfs-use-pr_fmt
+++ a/fs/configfs/configfs_internal.h
@@ -24,6 +24,12 @@
  * configfs Copyright (C) 2005 Oracle.  All rights reserved.
  */
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
diff -puN fs/configfs/dir.c~fs-configfs-use-pr_fmt fs/configfs/dir.c
--- a/fs/configfs/dir.c~fs-configfs-use-pr_fmt
+++ a/fs/configfs/dir.c
@@ -1699,7 +1699,7 @@ void configfs_unregister_subsystem(struc
 	struct dentry *root = dentry->d_sb->s_root;
 
 	if (dentry->d_parent != root) {
-		pr_err("configfs: Tried to unregister non-subsystem!\n");
+		pr_err("Tried to unregister non-subsystem!\n");
 		return;
 	}
 
@@ -1709,7 +1709,7 @@ void configfs_unregister_subsystem(struc
 	mutex_lock(&configfs_symlink_mutex);
 	spin_lock(&configfs_dirent_lock);
 	if (configfs_detach_prep(dentry, NULL)) {
-		pr_err("configfs: Tried to unregister non-empty subsystem!\n");
+		pr_err("Tried to unregister non-empty subsystem!\n");
 	}
 	spin_unlock(&configfs_dirent_lock);
 	mutex_unlock(&configfs_symlink_mutex);
diff -puN fs/configfs/inode.c~fs-configfs-use-pr_fmt fs/configfs/inode.c
--- a/fs/configfs/inode.c~fs-configfs-use-pr_fmt
+++ a/fs/configfs/inode.c
@@ -168,7 +168,7 @@ static void configfs_set_inode_lock_clas
 			 * In practice the maximum level of locking depth is
 			 * already reached. Just inform about possible reasons.
 			 */
-			pr_info("configfs: Too many levels of inodes for the locking correctness validator.\n");
+			pr_info("Too many levels of inodes for the locking correctness validator.\n");
 			pr_info("Spurious warnings may appear.\n");
 		}
 	}
diff -puN fs/configfs/mount.c~fs-configfs-use-pr_fmt fs/configfs/mount.c
--- a/fs/configfs/mount.c~fs-configfs-use-pr_fmt
+++ a/fs/configfs/mount.c
@@ -85,7 +85,7 @@ static int configfs_fill_super(struct su
 		/* directory inodes start off with i_nlink == 2 (for "." entry) */
 		inc_nlink(inode);
 	} else {
-		pr_debug("configfs: could not get root inode\n");
+		pr_debug("could not get root inode\n");
 		return -ENOMEM;
 	}
 
@@ -155,7 +155,7 @@ static int __init configfs_init(void)
 
 	return 0;
 out4:
-	pr_err("configfs: Unable to register filesystem!\n");
+	pr_err("Unable to register filesystem!\n");
 	configfs_inode_exit();
 out3:
 	kobject_put(config_kobj);
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


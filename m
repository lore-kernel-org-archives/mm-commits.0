From: akpm@linux-foundation.org
Subject: [merged] fs-configfs-convert-printk-to-pr_foo.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:42:28 -0700
Message-ID: <5390c824.EtF+Oc0IteAB1xjV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaFETm3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jlbec@evilplan.org, fabf@skynet.be

Subject: [merged] fs-configfs-convert-printk-to-pr_foo.patch removed from -mm tree
To: fabf@skynet.be,jlbec@evilplan.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:28 -0700


The patch titled
     Subject: fs/configfs: convert printk to pr_foo()
has been removed from the -mm tree.  Its filename was
     fs-configfs-convert-printk-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/configfs: convert printk to pr_foo()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/dir.c   |    8 ++++----
 fs/configfs/inode.c |    5 ++---
 fs/configfs/mount.c |    2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

diff -puN fs/configfs/dir.c~fs-configfs-convert-printk-to-pr_foo fs/configfs/dir.c
--- a/fs/configfs/dir.c~fs-configfs-convert-printk-to-pr_foo
+++ a/fs/configfs/dir.c
@@ -940,9 +940,9 @@ static void client_drop_item(struct conf
 #ifdef DEBUG
 static void configfs_dump_one(struct configfs_dirent *sd, int level)
 {
-	printk(KERN_INFO "%*s\"%s\":\n", level, " ", configfs_get_name(sd));
+	pr_info("%*s\"%s\":\n", level, " ", configfs_get_name(sd));
 
-#define type_print(_type) if (sd->s_type & _type) printk(KERN_INFO "%*s %s\n", level, " ", #_type);
+#define type_print(_type) if (sd->s_type & _type) pr_info("%*s %s\n", level, " ", #_type);
 	type_print(CONFIGFS_ROOT);
 	type_print(CONFIGFS_DIR);
 	type_print(CONFIGFS_ITEM_ATTR);
@@ -1699,7 +1699,7 @@ void configfs_unregister_subsystem(struc
 	struct dentry *root = dentry->d_sb->s_root;
 
 	if (dentry->d_parent != root) {
-		printk(KERN_ERR "configfs: Tried to unregister non-subsystem!\n");
+		pr_err("configfs: Tried to unregister non-subsystem!\n");
 		return;
 	}
 
@@ -1709,7 +1709,7 @@ void configfs_unregister_subsystem(struc
 	mutex_lock(&configfs_symlink_mutex);
 	spin_lock(&configfs_dirent_lock);
 	if (configfs_detach_prep(dentry, NULL)) {
-		printk(KERN_ERR "configfs: Tried to unregister non-empty subsystem!\n");
+		pr_err("configfs: Tried to unregister non-empty subsystem!\n");
 	}
 	spin_unlock(&configfs_dirent_lock);
 	mutex_unlock(&configfs_symlink_mutex);
diff -puN fs/configfs/inode.c~fs-configfs-convert-printk-to-pr_foo fs/configfs/inode.c
--- a/fs/configfs/inode.c~fs-configfs-convert-printk-to-pr_foo
+++ a/fs/configfs/inode.c
@@ -168,9 +168,8 @@ static void configfs_set_inode_lock_clas
 			 * In practice the maximum level of locking depth is
 			 * already reached. Just inform about possible reasons.
 			 */
-			printk(KERN_INFO "configfs: Too many levels of inodes"
-			       " for the locking correctness validator.\n");
-			printk(KERN_INFO "Spurious warnings may appear.\n");
+			pr_info("configfs: Too many levels of inodes for the locking correctness validator.\n");
+			pr_info("Spurious warnings may appear.\n");
 		}
 	}
 }
diff -puN fs/configfs/mount.c~fs-configfs-convert-printk-to-pr_foo fs/configfs/mount.c
--- a/fs/configfs/mount.c~fs-configfs-convert-printk-to-pr_foo
+++ a/fs/configfs/mount.c
@@ -155,7 +155,7 @@ static int __init configfs_init(void)
 
 	return 0;
 out4:
-	printk(KERN_ERR "configfs: Unable to register filesystem!\n");
+	pr_err("configfs: Unable to register filesystem!\n");
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


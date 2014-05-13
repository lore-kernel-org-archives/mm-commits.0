From: akpm@linux-foundation.org
Subject: + fs-configfs-convert-printk-to-pr_foo.patch added to -mm tree
Date: Tue, 13 May 2014 13:52:11 -0700
Message-ID: <537285fb.0Rzw9EU+uI/zdD1K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaEMUwM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 16:52:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jlbec@evilplan.org, fabf@skynet.be

Subject: + fs-configfs-convert-printk-to-pr_foo.patch added to -mm tree
To: fabf@skynet.be,jlbec@evilplan.org
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 13:52:11 -0700


The patch titled
     Subject: fs/configfs: convert printk to pr_foo()
has been added to the -mm tree.  Its filename is
     fs-configfs-convert-printk-to-pr_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-configfs-convert-printk-to-pr_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-configfs-convert-printk-to-pr_foo.patch

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

fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
fs-fscache-convert-printk-to-pr_foo.patch
fs-fscache-replace-seq_printf-by-seq_puts.patch
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
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-mempolicyc-parameter-doc-uniformization.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
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
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
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
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
ufs-sb-mutex-merge-mutex_destroy.patch


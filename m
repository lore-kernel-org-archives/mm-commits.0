From: akpm@linux-foundation.org
Subject: + fs-devpts-inodec-convert-printk-to-pr_foo.patch added to -mm
 tree
Date: Tue, 13 May 2014 13:55:52 -0700
Message-ID: <537286d8./AXGTSrRIKpQ7L9f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaEMUzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 16:55:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tytso@mit.edu, joe@perches.com, fabf@skynet.be

Subject: + fs-devpts-inodec-convert-printk-to-pr_foo.patch added to -mm tree
To: fabf@skynet.be,joe@perches.com,tytso@mit.edu
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 13:55:52 -0700


The patch titled
     Subject: fs/devpts/inode.c: convert printk to pr_foo()
has been added to the -mm tree.  Its filename is
     fs-devpts-inodec-convert-printk-to-pr_foo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-devpts-inodec-convert-printk-to-pr_foo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-devpts-inodec-convert-printk-to-pr_foo.patch

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
Subject: fs/devpts/inode.c: convert printk to pr_foo()

Also convert spaces to tabs (checkpatch warnings) if (!dentry) KERN_NOTICE
converted to pr_err (like if (!inode) error process)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN fs/devpts/inode.c~fs-devpts-inodec-convert-printk-to-pr_foo fs/devpts/inode.c
--- a/fs/devpts/inode.c~fs-devpts-inodec-convert-printk-to-pr_foo
+++ a/fs/devpts/inode.c
@@ -10,6 +10,8 @@
  *
  * ------------------------------------------------------------------------- */
 
+#define pr_fmt(fmt) "devpts: " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
@@ -148,10 +150,10 @@ static inline struct super_block *pts_sb
 
 /*
  * parse_mount_options():
- * 	Set @opts to mount options specified in @data. If an option is not
- * 	specified in @data, set it to its default value. The exception is
- * 	'newinstance' option which can only be set/cleared on a mount (i.e.
- * 	cannot be changed during remount).
+ *	Set @opts to mount options specified in @data. If an option is not
+ *	specified in @data, set it to its default value. The exception is
+ *	'newinstance' option which can only be set/cleared on a mount (i.e.
+ *	cannot be changed during remount).
  *
  * Note: @data may be NULL (in which case all options are set to default).
  */
@@ -225,7 +227,7 @@ static int parse_mount_options(char *dat
 			break;
 #endif
 		default:
-			printk(KERN_ERR "devpts: called with bogus options\n");
+			pr_err("called with bogus options\n");
 			return -EINVAL;
 		}
 	}
@@ -261,7 +263,7 @@ static int mknod_ptmx(struct super_block
 
 	dentry = d_alloc_name(root, "ptmx");
 	if (!dentry) {
-		printk(KERN_NOTICE "Unable to alloc dentry for ptmx node\n");
+		pr_err("Unable to alloc dentry for ptmx node\n");
 		goto out;
 	}
 
@@ -270,7 +272,7 @@ static int mknod_ptmx(struct super_block
 	 */
 	inode = new_inode(sb);
 	if (!inode) {
-		printk(KERN_ERR "Unable to alloc inode for ptmx node\n");
+		pr_err("Unable to alloc inode for ptmx node\n");
 		dput(dentry);
 		goto out;
 	}
@@ -303,7 +305,7 @@ static void update_ptmx_mode(struct pts_
 #else
 static inline void update_ptmx_mode(struct pts_fs_info *fsi)
 {
-       return;
+	return;
 }
 #endif
 
@@ -333,9 +335,11 @@ static int devpts_show_options(struct se
 	struct pts_mount_opts *opts = &fsi->mount_opts;
 
 	if (opts->setuid)
-		seq_printf(seq, ",uid=%u", from_kuid_munged(&init_user_ns, opts->uid));
+		seq_printf(seq, ",uid=%u",
+			   from_kuid_munged(&init_user_ns, opts->uid));
 	if (opts->setgid)
-		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, opts->gid));
+		seq_printf(seq, ",gid=%u",
+			   from_kgid_munged(&init_user_ns, opts->gid));
 	seq_printf(seq, ",mode=%03o", opts->mode);
 #ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 	seq_printf(seq, ",ptmxmode=%03o", opts->ptmxmode);
@@ -396,7 +400,7 @@ devpts_fill_super(struct super_block *s,
 	if (s->s_root)
 		return 0;
 
-	printk(KERN_ERR "devpts: get root dentry failed\n");
+	pr_err("get root dentry failed\n");
 
 fail:
 	return -ENOMEM;
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
fs-devpts-inodec-convert-printk-to-pr_foo.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
ufs-sb-mutex-merge-mutex_destroy.patch


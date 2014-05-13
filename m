From: akpm@linux-foundation.org
Subject: + fs-coda-logging-prefix-uniformization.patch added to -mm tree
Date: Tue, 13 May 2014 13:58:19 -0700
Message-ID: <5372876b.wB7PYkLFE3x3dlDQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbaEMU6U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 16:58:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, jaharkes@cs.cmu.edu, fabf@skynet.be

Subject: + fs-coda-logging-prefix-uniformization.patch added to -mm tree
To: fabf@skynet.be,jaharkes@cs.cmu.edu,joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 13:58:19 -0700


The patch titled
     Subject: fs/coda: logging prefix uniformization
has been added to the -mm tree.  Its filename is
     fs-coda-logging-prefix-uniformization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-coda-logging-prefix-uniformization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-coda-logging-prefix-uniformization.patch

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
Subject: fs/coda: logging prefix uniformization

- Add pr_fmt based on module name.

- Remove Coda: coda: from pr_foo()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/coda_linux.h |    6 ++++++
 fs/coda/dir.c        |    2 +-
 fs/coda/inode.c      |    2 +-
 fs/coda/psdev.c      |    6 +++---
 fs/coda/upcall.c     |    6 +++---
 5 files changed, 14 insertions(+), 8 deletions(-)

diff -puN fs/coda/coda_linux.h~fs-coda-logging-prefix-uniformization fs/coda/coda_linux.h
--- a/fs/coda/coda_linux.h~fs-coda-logging-prefix-uniformization
+++ a/fs/coda/coda_linux.h
@@ -12,6 +12,12 @@
 #ifndef _LINUX_CODA_FS
 #define _LINUX_CODA_FS
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/param.h>
 #include <linux/mm.h>
diff -puN fs/coda/dir.c~fs-coda-logging-prefix-uniformization fs/coda/dir.c
--- a/fs/coda/dir.c~fs-coda-logging-prefix-uniformization
+++ a/fs/coda/dir.c
@@ -589,7 +589,7 @@ int coda_revalidate_inode(struct inode *
 		coda_vattr_to_iattr(inode, &attr);
 
 		if ((old_mode & S_IFMT) != (inode->i_mode & S_IFMT)) {
-			pr_warn("Coda: inode %ld, fid %s changed type!\n",
+			pr_warn("inode %ld, fid %s changed type!\n",
 				inode->i_ino, coda_f2s(&(cii->c_fid)));
 		}
 
diff -puN fs/coda/inode.c~fs-coda-logging-prefix-uniformization fs/coda/inode.c
--- a/fs/coda/inode.c~fs-coda-logging-prefix-uniformization
+++ a/fs/coda/inode.c
@@ -247,7 +247,7 @@ static void coda_put_super(struct super_
 	sb->s_fs_info = NULL;
 	mutex_unlock(&vcp->vc_mutex);
 
-	pr_info("Coda: Bye bye.\n");
+	pr_info("Bye bye.\n");
 }
 
 static void coda_evict_inode(struct inode *inode)
diff -puN fs/coda/psdev.c~fs-coda-logging-prefix-uniformization fs/coda/psdev.c
--- a/fs/coda/psdev.c~fs-coda-logging-prefix-uniformization
+++ a/fs/coda/psdev.c
@@ -120,7 +120,7 @@ static ssize_t coda_psdev_write(struct f
 			goto out;
 		}
 		if ( nbytes > size ) {
-			pr_warn("Coda: downcall opc %d, uniq %d, too much!",
+			pr_warn("downcall opc %d, uniq %d, too much!",
 				hdr.opcode, hdr.unique);
 		        nbytes = size;
 		}
@@ -400,7 +400,7 @@ static int __init init_coda(void)
 	
 	status = register_filesystem(&coda_fs_type);
 	if (status) {
-		pr_warn("coda: failed to register filesystem!\n");
+		pr_warn("failed to register filesystem!\n");
 		goto out;
 	}
 	return 0;
@@ -422,7 +422,7 @@ static void __exit exit_coda(void)
 
 	err = unregister_filesystem(&coda_fs_type);
 	if (err != 0)
-		pr_warn("coda: failed to unregister filesystem\n");
+		pr_warn("failed to unregister filesystem\n");
 	for (i = 0; i < MAX_CODADEVS; i++)
 		device_destroy(coda_psdev_class, MKDEV(CODA_PSDEV_MAJOR, i));
 	class_destroy(coda_psdev_class);
diff -puN fs/coda/upcall.c~fs-coda-logging-prefix-uniformization fs/coda/upcall.c
--- a/fs/coda/upcall.c~fs-coda-logging-prefix-uniformization
+++ a/fs/coda/upcall.c
@@ -675,7 +675,7 @@ static int coda_upcall(struct venus_comm
 	mutex_lock(&vcp->vc_mutex);
 
 	if (!vcp->vc_inuse) {
-		pr_notice("coda: Venus dead, not sending upcall\n");
+		pr_notice("Venus dead, not sending upcall\n");
 		error = -ENXIO;
 		goto exit;
 	}
@@ -725,7 +725,7 @@ static int coda_upcall(struct venus_comm
 
 	error = -EINTR;
 	if ((req->uc_flags & CODA_REQ_ABORT) || !signal_pending(current)) {
-		pr_warn("coda: Unexpected interruption.\n");
+		pr_warn("Unexpected interruption.\n");
 		goto exit;
 	}
 
@@ -735,7 +735,7 @@ static int coda_upcall(struct venus_comm
 
 	/* Venus saw the upcall, make sure we can send interrupt signal */
 	if (!vcp->vc_inuse) {
-		pr_info("coda: Venus dead, not sending signal.\n");
+		pr_info("Venus dead, not sending signal.\n");
 		goto exit;
 	}
 
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
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
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


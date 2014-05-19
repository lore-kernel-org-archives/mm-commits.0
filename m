From: akpm@linux-foundation.org
Subject: + mm-kmemleak-testc-use-pr_fmt-for-logging.patch added to -mm
 tree
Date: Mon, 19 May 2014 13:36:46 -0700
Message-ID: <537a6b5e.TcRDsigLU4TJk9w/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaESUgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 16:36:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, fabf@skynet.be

Subject: + mm-kmemleak-testc-use-pr_fmt-for-logging.patch added to -mm tree
To: fabf@skynet.be,catalin.marinas@arm.com
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 13:36:46 -0700


The patch titled
     Subject: mm/kmemleak-test.c: use pr_fmt for logging
has been added to the -mm tree.  Its filename is
     mm-kmemleak-testc-use-pr_fmt-for-logging.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-testc-use-pr_fmt-for-logging.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-testc-use-pr_fmt-for-logging.patch

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
Subject: mm/kmemleak-test.c: use pr_fmt for logging

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak-test.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff -puN mm/kmemleak-test.c~mm-kmemleak-testc-use-pr_fmt-for-logging mm/kmemleak-test.c
--- a/mm/kmemleak-test.c~mm-kmemleak-testc-use-pr_fmt-for-logging
+++ a/mm/kmemleak-test.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) "kmemleak: " fmt
+
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -50,25 +52,25 @@ static int __init kmemleak_test_init(voi
 	printk(KERN_INFO "Kmemleak testing\n");
 
 	/* make some orphan objects */
-	pr_info("kmemleak: kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
+	pr_info("kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
+	pr_info("kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
+	pr_info("kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
+	pr_info("kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
+	pr_info("kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
+	pr_info("kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
+	pr_info("kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
+	pr_info("kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
 #ifndef CONFIG_MODULES
-	pr_info("kmemleak: kmem_cache_alloc(files_cachep) = %p\n",
+	pr_info("kmem_cache_alloc(files_cachep) = %p\n",
 		kmem_cache_alloc(files_cachep, GFP_KERNEL));
-	pr_info("kmemleak: kmem_cache_alloc(files_cachep) = %p\n",
+	pr_info("kmem_cache_alloc(files_cachep) = %p\n",
 		kmem_cache_alloc(files_cachep, GFP_KERNEL));
 #endif
-	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
 
 	/*
 	 * Add elements to a list. They should only appear as orphan
@@ -76,7 +78,7 @@ static int __init kmemleak_test_init(voi
 	 */
 	for (i = 0; i < 10; i++) {
 		elem = kzalloc(sizeof(*elem), GFP_KERNEL);
-		pr_info("kmemleak: kzalloc(sizeof(*elem)) = %p\n", elem);
+		pr_info("kzalloc(sizeof(*elem)) = %p\n", elem);
 		if (!elem)
 			return -ENOMEM;
 		INIT_LIST_HEAD(&elem->list);
@@ -85,7 +87,7 @@ static int __init kmemleak_test_init(voi
 
 	for_each_possible_cpu(i) {
 		per_cpu(kmemleak_test_pointer, i) = kmalloc(129, GFP_KERNEL);
-		pr_info("kmemleak: kmalloc(129) = %p\n",
+		pr_info("kmalloc(129) = %p\n",
 			per_cpu(kmemleak_test_pointer, i));
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
fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch
fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch
fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
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


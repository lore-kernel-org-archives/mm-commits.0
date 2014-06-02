From: akpm@linux-foundation.org
Subject: + lib-atomic64_testc-convert-printkkern_info-to-pr_info.patch
 added to -mm tree
Date: Mon, 02 Jun 2014 13:40:58 -0700
Message-ID: <538ce15a.9a27uVomL7eW2t1E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbaFBUk7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2014 16:40:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, luca@luca-barbieri.com, fabf@skynet.be

Subject: + lib-atomic64_testc-convert-printkkern_info-to-pr_info.patch added to -mm tree
To: fabf@skynet.be,luca@luca-barbieri.com
From: akpm@linux-foundation.org
Date: Mon, 02 Jun 2014 13:40:58 -0700


The patch titled
     Subject: lib/atomic64_test.c: convert printk(KERN_INFO to pr_info
has been added to the -mm tree.  Its filename is
     lib-atomic64_testc-convert-printkkern_info-to-pr_info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-atomic64_testc-convert-printkkern_info-to-pr_info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-atomic64_testc-convert-printkkern_info-to-pr_info.patch

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
Subject: lib/atomic64_test.c: convert printk(KERN_INFO to pr_info

Convert printk to current pr_foo() logging functions.

Also add pr_fmt based on KBUILD_MODNAME to avoid repeating prefix.  Prefix
is now "atomic64_test: "

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Luca Barbieri <luca@luca-barbieri.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/atomic64_test.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN lib/atomic64_test.c~lib-atomic64_testc-convert-printkkern_info-to-pr_info lib/atomic64_test.c
--- a/lib/atomic64_test.c~lib-atomic64_testc-convert-printkkern_info-to-pr_info
+++ a/lib/atomic64_test.c
@@ -8,6 +8,9 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/bug.h>
 #include <linux/kernel.h>
@@ -146,18 +149,18 @@ static __init int test_atomic64(void)
 	BUG_ON(v.counter != r);
 
 #ifdef CONFIG_X86
-	printk(KERN_INFO "atomic64 test passed for %s platform %s CX8 and %s SSE\n",
+	pr_info("passed for %s platform %s CX8 and %s SSE\n",
 #ifdef CONFIG_X86_64
-	       "x86-64",
+		"x86-64",
 #elif defined(CONFIG_X86_CMPXCHG64)
-	       "i586+",
+		"i586+",
 #else
-	       "i386+",
+		"i386+",
 #endif
 	       boot_cpu_has(X86_FEATURE_CX8) ? "with" : "without",
 	       boot_cpu_has(X86_FEATURE_XMM) ? "with" : "without");
 #else
-	printk(KERN_INFO "atomic64 test passed\n");
+	pr_info("passed\n");
 #endif
 
 	return 0;
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
kernel-compatc-use-sizeof-instead-of-sizeof.patch
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


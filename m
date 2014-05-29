From: akpm@linux-foundation.org
Subject: + lib-debugobjectsc-add-pr_fmt-to-logging.patch added to -mm tree
Date: Thu, 29 May 2014 13:18:28 -0700
Message-ID: <53879614.ruIajEIVD0c7KsMs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbaE2US3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 16:18:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org, fabf@skynet.be

Subject: + lib-debugobjectsc-add-pr_fmt-to-logging.patch added to -mm tree
To: fabf@skynet.be,josh@joshtriplett.org
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 13:18:28 -0700


The patch titled
     Subject: lib/debugobjects.c: add pr_fmt to logging
has been added to the -mm tree.  Its filename is
     lib-debugobjectsc-add-pr_fmt-to-logging.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-debugobjectsc-add-pr_fmt-to-logging.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-debugobjectsc-add-pr_fmt-to-logging.patch

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
Subject: lib/debugobjects.c: add pr_fmt to logging

Add ODEBUG: prefix to pr_fmt

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN lib/debugobjects.c~lib-debugobjectsc-add-pr_fmt-to-logging lib/debugobjects.c
--- a/lib/debugobjects.c~lib-debugobjectsc-add-pr_fmt-to-logging
+++ a/lib/debugobjects.c
@@ -7,6 +7,9 @@
  *
  * For licencing details see kernel-base/COPYING
  */
+
+#define pr_fmt(fmt) "ODEBUG: " fmt
+
 #include <linux/debugobjects.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
@@ -218,7 +221,7 @@ static void debug_objects_oom(void)
 	unsigned long flags;
 	int i;
 
-	pr_warn("ODEBUG: Out of memory. ODEBUG disabled\n");
+	pr_warn("Out of memory. ODEBUG disabled\n");
 
 	for (i = 0; i < ODEBUG_HASH_SIZE; i++, db++) {
 		raw_spin_lock_irqsave(&db->lock, flags);
@@ -292,9 +295,9 @@ static void debug_object_is_on_stack(voi
 
 	limit++;
 	if (is_on_stack)
-		pr_warn("ODEBUG: object is on stack, but not annotated\n");
+		pr_warn("object is on stack, but not annotated\n");
 	else
-		pr_warn("ODEBUG: object is not on stack, but annotated\n");
+		pr_warn("object is not on stack, but annotated\n");
 	WARN_ON(1);
 }
 
@@ -983,7 +986,7 @@ static void __init debug_objects_selftes
 	if (check_results(&obj, ODEBUG_STATE_NONE, ++fixups, ++warnings))
 		goto out;
 #endif
-	pr_info("ODEBUG: selftest passed\n");
+	pr_info("selftest passed\n");
 
 out:
 	debug_objects_fixups = oldfixups;
@@ -1088,7 +1091,7 @@ void __init debug_objects_mem_init(void)
 		debug_objects_enabled = 0;
 		if (obj_cache)
 			kmem_cache_destroy(obj_cache);
-		pr_warn("ODEBUG: out of memory.\n");
+		pr_warn("out of memory.\n");
 	} else
 		debug_objects_selftest();
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


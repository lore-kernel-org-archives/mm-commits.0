From: akpm@linux-foundation.org
Subject: + lib-nlattrc-move-export_symbol-after-functions.patch added to
 -mm tree
Date: Thu, 22 May 2014 12:29:05 -0700
Message-ID: <537e5001.jP4ukS8LH+fFV97B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaEVT3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 May 2014 15:29:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pablo@netfilter.org, fabf@skynet.be

Subject: + lib-nlattrc-move-export_symbol-after-functions.patch added to -mm tree
To: fabf@skynet.be,pablo@netfilter.org
From: akpm@linux-foundation.org
Date: Thu, 22 May 2014 12:29:05 -0700


The patch titled
     Subject: lib/nlattr.c: move EXPORT_SYMBOL after functions
has been added to the -mm tree.  Its filename is
     lib-nlattrc-move-export_symbol-after-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-nlattrc-move-export_symbol-after-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-nlattrc-move-export_symbol-after-functions.patch

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
Subject: lib/nlattr.c: move EXPORT_SYMBOL after functions

Fix some checkpatch warnings:
WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Pablo Neira <pablo@netfilter.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/nlattr.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN lib/nlattr.c~lib-nlattrc-move-export_symbol-after-functions lib/nlattr.c
--- a/lib/nlattr.c~lib-nlattrc-move-export_symbol-after-functions
+++ a/lib/nlattr.c
@@ -136,6 +136,7 @@ int nla_validate(const struct nlattr *he
 errout:
 	return err;
 }
+EXPORT_SYMBOL(nla_validate);
 
 /**
  * nla_policy_len - Determin the max. length of a policy
@@ -162,6 +163,7 @@ nla_policy_len(const struct nla_policy *
 
 	return len;
 }
+EXPORT_SYMBOL(nla_policy_len);
 
 /**
  * nla_parse - Parse a stream of attributes into a tb buffer
@@ -208,6 +210,7 @@ int nla_parse(struct nlattr **tb, int ma
 errout:
 	return err;
 }
+EXPORT_SYMBOL(nla_parse);
 
 /**
  * nla_find - Find a specific attribute in a stream of attributes
@@ -228,6 +231,7 @@ struct nlattr *nla_find(const struct nla
 
 	return NULL;
 }
+EXPORT_SYMBOL(nla_find);
 
 /**
  * nla_strlcpy - Copy string attribute payload into a sized buffer
@@ -258,6 +262,7 @@ size_t nla_strlcpy(char *dst, const stru
 
 	return srclen;
 }
+EXPORT_SYMBOL(nla_strlcpy);
 
 /**
  * nla_memcpy - Copy a netlink attribute into another memory area
@@ -278,6 +283,7 @@ int nla_memcpy(void *dest, const struct
 
 	return minlen;
 }
+EXPORT_SYMBOL(nla_memcpy);
 
 /**
  * nla_memcmp - Compare an attribute with sized memory area
@@ -295,6 +301,7 @@ int nla_memcmp(const struct nlattr *nla,
 
 	return d;
 }
+EXPORT_SYMBOL(nla_memcmp);
 
 /**
  * nla_strcmp - Compare a string attribute against a string
@@ -317,6 +324,7 @@ int nla_strcmp(const struct nlattr *nla,
 
 	return d;
 }
+EXPORT_SYMBOL(nla_strcmp);
 
 #ifdef CONFIG_NET
 /**
@@ -502,12 +510,3 @@ int nla_append(struct sk_buff *skb, int
 }
 EXPORT_SYMBOL(nla_append);
 #endif
-
-EXPORT_SYMBOL(nla_validate);
-EXPORT_SYMBOL(nla_policy_len);
-EXPORT_SYMBOL(nla_parse);
-EXPORT_SYMBOL(nla_find);
-EXPORT_SYMBOL(nla_strlcpy);
-EXPORT_SYMBOL(nla_memcpy);
-EXPORT_SYMBOL(nla_memcmp);
-EXPORT_SYMBOL(nla_strcmp);
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
lib-devresc-use-dev-in-devm_request_and_ioremap.patch
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


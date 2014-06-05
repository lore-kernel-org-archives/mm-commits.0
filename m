From: akpm@linux-foundation.org
Subject: [merged] lib-nlattrc-move-export_symbol-after-functions.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 13:05:27 -0700
Message-ID: <5390cd87.KTGdsgEeLwgr3mBk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56830 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaFEUF2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:05:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pablo@netfilter.org, fabf@skynet.be

Subject: [merged] lib-nlattrc-move-export_symbol-after-functions.patch removed from -mm tree
To: fabf@skynet.be,pablo@netfilter.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:05:27 -0700


The patch titled
     Subject: lib/nlattr.c: move EXPORT_SYMBOL after functions
has been removed from the -mm tree.  Its filename was
     lib-nlattrc-move-export_symbol-after-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


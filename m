From: akpm@linux-foundation.org
Subject: + kernel-capabilityc-code-clean-up.patch added to -mm tree
Date: Mon, 05 May 2014 13:14:02 -0700
Message-ID: <5367f10a.d0Tc+P8np1y3TA/r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaEEUOD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 16:14:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, serge.hallyn@canonical.com, fabf@skynet.be

Subject: + kernel-capabilityc-code-clean-up.patch added to -mm tree
To: fabf@skynet.be,serge.hallyn@canonical.com
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 13:14:02 -0700


The patch titled
     Subject: kernel/capability.c: code clean-up
has been added to the -mm tree.  Its filename is
     kernel-capabilityc-code-clean-up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-capabilityc-code-clean-up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-capabilityc-code-clean-up.patch

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
Subject: kernel/capability.c: code clean-up

-EXPORT_SYMBOL
-typo: unexpectidly->unexpectedly
-function prototype over 80 characters

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/capability.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/capability.c~kernel-capabilityc-code-clean-up kernel/capability.c
--- a/kernel/capability.c~kernel-capabilityc-code-clean-up
+++ a/kernel/capability.c
@@ -24,7 +24,6 @@
  */
 
 const kernel_cap_t __cap_empty_set = CAP_EMPTY_SET;
-
 EXPORT_SYMBOL(__cap_empty_set);
 
 int file_caps_enabled = 1;
@@ -189,7 +188,7 @@ SYSCALL_DEFINE2(capget, cap_user_header_
 		 *
 		 * An alternative would be to return an error here
 		 * (-ERANGE), but that causes legacy applications to
-		 * unexpectidly fail; the capget/modify/capset aborts
+		 * unexpectedly fail; the capget/modify/capset aborts
 		 * before modification is attempted and the application
 		 * fails.
 		 */
@@ -395,7 +394,8 @@ EXPORT_SYMBOL(ns_capable);
  * This does not set PF_SUPERPRIV because the caller may not
  * actually be privileged.
  */
-bool file_ns_capable(const struct file *file, struct user_namespace *ns, int cap)
+bool file_ns_capable(const struct file *file, struct user_namespace *ns,
+		     int cap)
 {
 	if (WARN_ON_ONCE(!cap_valid(cap)))
 		return false;
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
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
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
init-mainc-code-clean-up.patch
ufs-sb-mutex-merge-mutex_destroy.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
kernel-exec_domainc-code-clean-up.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-cpusetc-kernel-doc-fixes.patch
kernel-cpusetc-convert-printk-to-pr_foo.patch


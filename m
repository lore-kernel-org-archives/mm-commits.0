From: akpm@linux-foundation.org
Subject: + kernel-compatc-use-sizeof-instead-of-sizeof.patch added to -mm
 tree
Date: Mon, 05 May 2014 13:14:03 -0700
Message-ID: <5367f10b.voGHIU4FLIJdnfYq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaEEUOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 16:14:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hpa@zytor.com, arnd@arndb.de, fabf@skynet.be

Subject: + kernel-compatc-use-sizeof-instead-of-sizeof.patch added to -mm tree
To: fabf@skynet.be,arnd@arndb.de,hpa@zytor.com
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 13:14:03 -0700


The patch titled
     Subject: kernel/compat.c: use sizeof() instead of sizeof
has been added to the -mm tree.  Its filename is
     kernel-compatc-use-sizeof-instead-of-sizeof.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-compatc-use-sizeof-instead-of-sizeof.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-compatc-use-sizeof-instead-of-sizeof.patch

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
Subject: kernel/compat.c: use sizeof() instead of sizeof

Fix 4 checkpatch warnings
WARNING: sizeof *tv should be sizeof(*tv)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/compat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/compat.c~kernel-compatc-use-sizeof-instead-of-sizeof kernel/compat.c
--- a/kernel/compat.c~kernel-compatc-use-sizeof-instead-of-sizeof
+++ a/kernel/compat.c
@@ -157,7 +157,7 @@ static int __compat_put_timespec(const s
 int compat_get_timeval(struct timeval *tv, const void __user *utv)
 {
 	if (COMPAT_USE_64BIT_TIME)
-		return copy_from_user(tv, utv, sizeof *tv) ? -EFAULT : 0;
+		return copy_from_user(tv, utv, sizeof(*tv)) ? -EFAULT : 0;
 	else
 		return __compat_get_timeval(tv, utv);
 }
@@ -166,7 +166,7 @@ EXPORT_SYMBOL_GPL(compat_get_timeval);
 int compat_put_timeval(const struct timeval *tv, void __user *utv)
 {
 	if (COMPAT_USE_64BIT_TIME)
-		return copy_to_user(utv, tv, sizeof *tv) ? -EFAULT : 0;
+		return copy_to_user(utv, tv, sizeof(*tv)) ? -EFAULT : 0;
 	else
 		return __compat_put_timeval(tv, utv);
 }
@@ -175,7 +175,7 @@ EXPORT_SYMBOL_GPL(compat_put_timeval);
 int compat_get_timespec(struct timespec *ts, const void __user *uts)
 {
 	if (COMPAT_USE_64BIT_TIME)
-		return copy_from_user(ts, uts, sizeof *ts) ? -EFAULT : 0;
+		return copy_from_user(ts, uts, sizeof(*ts)) ? -EFAULT : 0;
 	else
 		return __compat_get_timespec(ts, uts);
 }
@@ -184,7 +184,7 @@ EXPORT_SYMBOL_GPL(compat_get_timespec);
 int compat_put_timespec(const struct timespec *ts, void __user *uts)
 {
 	if (COMPAT_USE_64BIT_TIME)
-		return copy_to_user(uts, ts, sizeof *ts) ? -EFAULT : 0;
+		return copy_to_user(uts, ts, sizeof(*ts)) ? -EFAULT : 0;
 	else
 		return __compat_put_timespec(ts, uts);
 }
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


From: akpm@linux-foundation.org
Subject: [merged] kernel-compatc-use-sizeof-instead-of-sizeof.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 13:05:37 -0700
Message-ID: <5390cd91.0fr/JXpSigZQzdAL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaFEUFh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:05:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hpa@zytor.com, arnd@arndb.de, fabf@skynet.be

Subject: [merged] kernel-compatc-use-sizeof-instead-of-sizeof.patch removed from -mm tree
To: fabf@skynet.be,arnd@arndb.de,hpa@zytor.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:05:37 -0700


The patch titled
     Subject: kernel/compat.c: use sizeof() instead of sizeof
has been removed from the -mm tree.  Its filename was
     kernel-compatc-use-sizeof-instead-of-sizeof.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


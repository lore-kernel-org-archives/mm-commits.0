From: akpm@linux-foundation.org
Subject: [merged] lib-bitmapc-fix-documentation-for-scnprintf-functions.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:04 -0700
Message-ID: <20120531192004.79DCEA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:46966 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094Ab2EaTUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:06 -0400
Received: by mail-we0-f202.google.com with SMTP id e53so76004wer.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ozaki.ryota@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: fix documentation for scnprintf() functions
has been removed from the -mm tree.  Its filename was
     lib-bitmapc-fix-documentation-for-scnprintf-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/bitmap.c: fix documentation for scnprintf() functions

The code comments for bscnl_emit() and bitmap_scnlistprintf() are
describing snprintf() return semantics, but these functions use
scnprintf() return semantics.  Fix that, and document the
bitmap_scnprintf() return value as well.

Cc: Ryota Ozaki <ozaki.ryota@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN lib/bitmap.c~lib-bitmapc-fix-documentation-for-scnprintf-functions lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-fix-documentation-for-scnprintf-functions
+++ a/lib/bitmap.c
@@ -369,7 +369,8 @@ EXPORT_SYMBOL(bitmap_find_next_zero_area
  * @nmaskbits: size of bitmap, in bits
  *
  * Exactly @nmaskbits bits are displayed.  Hex digits are grouped into
- * comma-separated sets of eight digits per set.
+ * comma-separated sets of eight digits per set.  Returns the number of
+ * characters which were written to *buf, excluding the trailing \0.
  */
 int bitmap_scnprintf(char *buf, unsigned int buflen,
 	const unsigned long *maskp, int nmaskbits)
@@ -517,8 +518,8 @@ EXPORT_SYMBOL(bitmap_parse_user);
  *
  * Helper routine for bitmap_scnlistprintf().  Write decimal number
  * or range to buf, suppressing output past buf+buflen, with optional
- * comma-prefix.  Return len of what would be written to buf, if it
- * all fit.
+ * comma-prefix.  Return len of what was written to *buf, excluding the
+ * trailing \0.
  */
 static inline int bscnl_emit(char *buf, int buflen, int rbot, int rtop, int len)
 {
@@ -544,9 +545,8 @@ static inline int bscnl_emit(char *buf, 
  * the range.  Output format is compatible with the format
  * accepted as input by bitmap_parselist().
  *
- * The return value is the number of characters which would be
- * generated for the given input, excluding the trailing '\0', as
- * per ISO C99.
+ * The return value is the number of characters which were written to *buf
+ * excluding the trailing '\0', as per ISO C99's scnprintf.
  */
 int bitmap_scnlistprintf(char *buf, unsigned int buflen,
 	const unsigned long *maskp, int nmaskbits)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
kernel-cpuc-document-clear_tasks_mm_cpumask-fix.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
fs-nls-add-apple-nls-fix.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


From: akpm@linux-foundation.org
Subject: + kernel-add-kcov-code-coverage-fix.patch added to -mm tree
Date: Thu, 04 Feb 2016 14:31:50 -0800
Message-ID: <56b3d156.rCVR3bRkBKwa8ho9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906AbcBDWbv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 17:31:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dvyukov@google.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-add-kcov-code-coverage-fix
has been added to the -mm tree.  Its filename is
     kernel-add-kcov-code-coverage-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-add-kcov-code-coverage-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-add-kcov-code-coverage-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-add-kcov-code-coverage-fix

make task_struct.kcov_mode have type `enum kcov_mode'.

Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kcov.h  |    8 ++++++++
 include/linux/sched.h |    3 ++-
 kernel/kcov.c         |    8 --------
 3 files changed, 10 insertions(+), 9 deletions(-)

diff -puN include/linux/kcov.h~kernel-add-kcov-code-coverage-fix include/linux/kcov.h
--- a/include/linux/kcov.h~kernel-add-kcov-code-coverage-fix
+++ a/include/linux/kcov.h
@@ -10,6 +10,14 @@ struct task_struct;
 void kcov_task_init(struct task_struct *t);
 void kcov_task_exit(struct task_struct *t);
 
+enum kcov_mode {
+	/*
+	 * Tracing coverage collection mode.
+	 * Covered PCs are collected in a per-task buffer.
+	 */
+	KCOV_MODE_TRACE = 1,
+};
+
 #else
 
 static inline void kcov_task_init(struct task_struct *t) {}
diff -puN include/linux/sched.h~kernel-add-kcov-code-coverage-fix include/linux/sched.h
--- a/include/linux/sched.h~kernel-add-kcov-code-coverage-fix
+++ a/include/linux/sched.h
@@ -51,6 +51,7 @@ struct sched_param {
 #include <linux/resource.h>
 #include <linux/timer.h>
 #include <linux/hrtimer.h>
+#include <linux/kcov.h>
 #include <linux/task_io_accounting.h>
 #include <linux/latencytop.h>
 #include <linux/cred.h>
@@ -1814,7 +1815,7 @@ struct task_struct {
 #endif /* CONFIG_TRACING */
 #ifdef CONFIG_KCOV
 	/* Coverage collection mode enabled for this task (0 if disabled). */
-	int		kcov_mode;
+	enum kcov_mode kcov_mode;
 	/* Size of the kcov_area. */
 	unsigned	kcov_size;
 	/* Buffer for coverage collection. */
diff -puN kernel/kcov.c~kernel-add-kcov-code-coverage-fix kernel/kcov.c
--- a/kernel/kcov.c~kernel-add-kcov-code-coverage-fix
+++ a/kernel/kcov.c
@@ -13,14 +13,6 @@
 #include <linux/uaccess.h>
 #include <linux/kcov.h>
 
-enum kcov_mode {
-	/*
-	 * Tracing coverage collection mode.
-	 * Covered PCs are collected in a per-task buffer.
-	 */
-	KCOV_MODE_TRACE = 1,
-};
-
 /*
  * kcov descriptor (one per opened debugfs file).
  * State transitions of the descriptor:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
kernel-locking-lockdepc-convert-hash-tables-to-hlists.patch
kernel-locking-lockdepc-convert-hash-tables-to-hlists-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
kernel-add-kcov-code-coverage-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


From: akpm@linux-foundation.org
Subject: +
 vsprintf-kptr_restrict-is-okay-in-irq-when-2-checkpatch-fixes.patch added
 to -mm tree
Date: Mon, 08 Feb 2016 15:50:34 -0800
Message-ID: <56b929ca.COKFEBUY0GFLXszP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113AbcBHXuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 18:50:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Jason@zx2c4.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vsprintf-kptr_restrict-is-okay-in-irq-when-2-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     vsprintf-kptr_restrict-is-okay-in-irq-when-2-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vsprintf-kptr_restrict-is-okay-in-irq-when-2-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vsprintf-kptr_restrict-is-okay-in-irq-when-2-checkpatch-fixes.patch

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
Subject: vsprintf-kptr_restrict-is-okay-in-irq-when-2-checkpatch-fixes

WARNING: line over 80 characters
#46: FILE: lib/vsprintf.c:1674:
+			 * kptr_restrict==1 cannot be used in IRQ context because

total: 0 errors, 1 warnings, 43 lines checked

./patches/vsprintf-kptr_restrict-is-okay-in-irq-when-2.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-kptr_restrict-is-okay-in-irq-when-2-checkpatch-fixes lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-kptr_restrict-is-okay-in-irq-when-2-checkpatch-fixes
+++ a/lib/vsprintf.c
@@ -1671,8 +1671,8 @@ char *pointer(const char *fmt, char *buf
 			const struct cred *cred;
 
 			/*
-			 * kptr_restrict==1 cannot be used in IRQ context because
-			 * its test for CAP_SYSLOG would be meaningless.
+			 * kptr_restrict==1 cannot be used in IRQ context
+			 * because its test for CAP_SYSLOG would be meaningless.
 			 */
 			if (in_irq() || in_serving_softirq() || in_nmi()) {
 				if (spec.field_width == -1)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
vsprintf-kptr_restrict-is-okay-in-irq-when-2-checkpatch-fixes.patch
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
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch
sound-query-dynamic-debug_pagealloc-setting-fix.patch
mm-config_nr_zones_extended-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-global-inbound-port-write-interfaces-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


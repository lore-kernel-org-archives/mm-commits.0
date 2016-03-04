From: akpm@linux-foundation.org
Subject: +
 mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch added to -mm tree
Date: Fri, 04 Mar 2016 12:05:27 -0800
Message-ID: <56d9ea87.oYuHynYSv36q2VKa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbcCDUF2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 15:05:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix
has been added to the -mm tree.  Its filename is
     mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch

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
Subject: mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix

tweak Kconfig text, per Vlastimil

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN mm/Kconfig.debug~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix
+++ a/mm/Kconfig.debug
@@ -82,10 +82,9 @@ config DEBUG_PAGE_REF
 	depends on DEBUG_KERNEL
 	depends on TRACEPOINTS
 	---help---
-	  This is the feature to add tracepoint for tracking down page reference
-	  manipulation. This tracking is useful to diagnosis functional failure
-	  due to migration failure caused by page reference mismatch. Be
-	  careful to turn on this feature because it could bloat some kernel
-	  text. In my configuration, it bloats 30 KB. Although kernel text will
-	  be bloated, there would be no runtime performance overhead if
-	  tracepoint isn't enabled thanks to jump label.
+	  This is a feature to add tracepoint for tracking down page reference
+	  manipulation. This tracking is useful to diagnose functional failure
+	  due to migration failures caused by page reference mismatches.  Be
+	  careful when enabling this feature because it adds about 30 KB to the
+	  kernel code.  However the runtime performance overhead is virtually
+	  nil until the tracepoints are actually enabled.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
slub-drop-lock-at-the-end-of-free_debug_processing-fix.patch
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
mm-add-a-new-vector-based-madvise-syscall-fix.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-mport-char-device-driver-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
net-sched-sch_mqprioc-fix-build-with-older-gcc.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


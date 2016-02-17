From: akpm@linux-foundation.org
Subject: + slub-drop-lock-at-the-end-of-free_debug_processing-fix.patch
 added to -mm tree
Date: Wed, 17 Feb 2016 12:12:10 -0800
Message-ID: <56c4d41a.+xBBIdo+Ygb0LstK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161661AbcBQUML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Feb 2016 15:12:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, js1304@gmail.com, keescook@chromium.org, labbott@fedoraproject.org, minipli@googlemail.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub-drop-lock-at-the-end-of-free_debug_processing-fix
has been added to the -mm tree.  Its filename is
     slub-drop-lock-at-the-end-of-free_debug_processing-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-drop-lock-at-the-end-of-free_debug_processing-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-drop-lock-at-the-end-of-free_debug_processing-fix.patch

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
Subject: slub-drop-lock-at-the-end-of-free_debug_processing-fix

fix build

mm/slub.c: In function 'free_debug_processing':
mm/slub.c:1211:46: warning: return makes integer from pointer without a cast [enabled by default]
  unsigned long addr, unsigned long *flags) { return NULL; }
                                              ^
mm/slub.c: In function '__slab_free':
mm/slub.c:2589:6: error: too few arguments to function 'free_debug_processing'
      !free_debug_processing(s, page, head, tail, cnt, addr))
      ^
mm/slub.c:1208:19: note: declared here
 static inline int free_debug_processing(

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@fedoraproject.org>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-drop-lock-at-the-end-of-free_debug_processing-fix mm/slub.c
--- a/mm/slub.c~slub-drop-lock-at-the-end-of-free_debug_processing-fix
+++ a/mm/slub.c
@@ -1208,7 +1208,7 @@ static inline int alloc_debug_processing
 static inline int free_debug_processing(
 	struct kmem_cache *s, struct page *page,
 	void *head, void *tail, int bulk_cnt,
-	unsigned long addr, unsigned long *flags) { return NULL; }
+	unsigned long addr) { return 0; }
 
 static inline int slab_pad_check(struct kmem_cache *s, struct page *page)
 			{ return 1; }
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
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-mport-char-device-driver-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


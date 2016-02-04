From: akpm@linux-foundation.org
Subject: + mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
 added to -mm tree
Date: Thu, 04 Feb 2016 15:43:23 -0800
Message-ID: <56b3e21b.7w7BkBC/cgPRmo6y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265AbcBDXnY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:43:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, borntraeger@de.ibm.com, cl@linux.com, cmetcalf@ezchip.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix
has been added to the -mm tree.  Its filename is
     mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch

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
Subject: mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix

update comment, per David.  Adjust comment to use 80 cols

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix
+++ a/mm/vmalloc.c
@@ -531,17 +531,16 @@ static void unmap_vmap_area(struct vmap_
 static void vmap_debug_free_range(unsigned long start, unsigned long end)
 {
 	/*
-	 * Unmap page tables and force a TLB flush immediately if
-	 * CONFIG_DEBUG_PAGEALLOC is set. This catches use after free
-	 * bugs similarly to those in linear kernel virtual address
-	 * space after a page has been freed.
+	 * Unmap page tables and force a TLB flush immediately if pagealloc
+	 * debugging is enabled.  This catches use after free bugs similarly to
+	 * those in linear kernel virtual address space after a page has been
+	 * freed.
 	 *
-	 * All the lazy freeing logic is still retained, in order to
-	 * minimise intrusiveness of this debugging feature.
+	 * All the lazy freeing logic is still retained, in order to minimise
+	 * intrusiveness of this debugging feature.
 	 *
-	 * This is going to be *slow* (linear kernel virtual address
-	 * debugging doesn't do a broadcast TLB flush so it is a lot
-	 * faster).
+	 * This is going to be *slow* (linear kernel virtual address debugging
+	 * doesn't do a broadcast TLB flush so it is a lot faster).
 	 */
 	if (debug_pagealloc_enabled()) {
 		vunmap_page_range(start, end);
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
mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch
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


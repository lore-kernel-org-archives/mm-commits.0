From: akpm@linux-foundation.org
Subject: + mm-page_allocc-dont-cache-current-in-a-local.patch added to -mm tree
Date: Tue, 11 Jan 2011 13:55:59 -0800
Message-ID: <201101112155.p0BLtx3v009004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112Ab1AKV4z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Jan 2011 16:56:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hughd@google.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     mm/page_alloc.c: don't cache `current' in a local
has been added to the -mm tree.  Its filename is
     mm-page_allocc-dont-cache-current-in-a-local.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page_alloc.c: don't cache `current' in a local
From: Andrew Morton <akpm@linux-foundation.org>

It's old-fashioned and unneeded.

akpm:/usr/src/25> size mm/page_alloc.o
   text    data     bss     dec     hex filename
  39884 1241317   18808 1300009  13d629 mm/page_alloc.o (before)
  39838 1241317   18808 1299963  13d5fb mm/page_alloc.o (after)

Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-dont-cache-current-in-a-local mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-dont-cache-current-in-a-local
+++ a/mm/page_alloc.c
@@ -1809,15 +1809,14 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	bool sync_migration)
 {
 	struct page *page;
-	struct task_struct *tsk = current;
 
 	if (!order || compaction_deferred(preferred_zone))
 		return NULL;
 
-	tsk->flags |= PF_MEMALLOC;
+	current->flags |= PF_MEMALLOC;
 	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
 						nodemask, sync_migration);
-	tsk->flags &= ~PF_MEMALLOC;
+	current->flags &= ~PF_MEMALLOC;
 	if (*did_some_progress != COMPACT_SKIPPED) {
 
 		/* Page migration frees to the PCP lists but we want merging */
@@ -1869,23 +1868,22 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 {
 	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
-	struct task_struct *p = current;
 	bool drained = false;
 
 	cond_resched();
 
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
-	p->flags |= PF_MEMALLOC;
+	current->flags |= PF_MEMALLOC;
 	lockdep_set_current_reclaim_state(gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
-	p->reclaim_state = &reclaim_state;
+	current->reclaim_state = &reclaim_state;
 
 	*did_some_progress = try_to_free_pages(zonelist, order, gfp_mask, nodemask);
 
-	p->reclaim_state = NULL;
+	current->reclaim_state = NULL;
 	lockdep_clear_current_reclaim_state();
-	p->flags &= ~PF_MEMALLOC;
+	current->flags &= ~PF_MEMALLOC;
 
 	cond_resched();
 
@@ -1950,7 +1948,6 @@ void wake_all_kswapd(unsigned int order,
 static inline int
 gfp_to_alloc_flags(gfp_t gfp_mask)
 {
-	struct task_struct *p = current;
 	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 
@@ -1977,12 +1974,12 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
 		 */
 		alloc_flags &= ~ALLOC_CPUSET;
-	} else if (unlikely(rt_task(p)) && !in_interrupt())
+	} else if (unlikely(rt_task(current)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
 	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
 		if (!in_interrupt() &&
-		    ((p->flags & PF_MEMALLOC) ||
+		    ((current->flags & PF_MEMALLOC) ||
 		     unlikely(test_thread_flag(TIF_MEMDIE))))
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 	}
@@ -2001,7 +1998,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	int alloc_flags;
 	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
-	struct task_struct *p = current;
 	bool sync_migration = false;
 
 	/*
@@ -2060,7 +2056,7 @@ rebalance:
 		goto nopage;
 
 	/* Avoid recursion of direct reclaim */
-	if (p->flags & PF_MEMALLOC)
+	if (current->flags & PF_MEMALLOC)
 		goto nopage;
 
 	/* Avoid allocations with no watermarks from looping endlessly */
@@ -2153,7 +2149,7 @@ nopage:
 	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit()) {
 		printk(KERN_WARNING "%s: page allocation failure."
 			" order:%d, mode:0x%x\n",
-			p->comm, order, gfp_mask);
+			current->comm, order, gfp_mask);
 		dump_stack();
 		show_mem();
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-add-output-inversion-option-to-backlight-trigger.patch
leds-add-output-inversion-option-to-backlight-trigger-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
ext4-dont-use-pr_warning_ratelimited.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix.patch
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
thp-kvm-mmu-transparent-hugepage-support-bisection.patch
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk-fix.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-fix.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch
mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes.patch
mm-page_allocc-dont-cache-current-in-a-local.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
include-linux-unaligned-packed_structh-use-__packed.patch
ihex-fix-unused-return-value-compiler-warning-fix.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch
kptr_restrict-for-hiding-kernel-pointers-v7-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
gpio-ml_ioh_gpio-ml7213-gpio-driver-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-parallel-port-pps-signal-generator-fix.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
aio-remove-unused-aio_run_iocbs-checkpatch-fixes.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch
ramoops-fix-types-remove-typecasts.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


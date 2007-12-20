From: akpm@linux-foundation.org
Subject: - quicklist-set-tlb-need_flush-if-pages-are-remaining-in-quicklist-0.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:36:57 -0800
Message-ID: <200712202336.lBKNavXb018843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755863AbXLTXsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:48:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dhaval@linux.vnet.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     quicklist: Set tlb->need_flush if pages are remaining in quicklist 0
has been removed from the -mm tree.  Its filename was
     quicklist-set-tlb-need_flush-if-pages-are-remaining-in-quicklist-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: quicklist: Set tlb->need_flush if pages are remaining in quicklist 0
From: Christoph Lameter <clameter@sgi.com>

This ensures that the quicklists are drained. Otherwise draining may only
occur when the processor reaches an idle state.

Fixes fatal leakage of pgd_t's on 2.6.22 and later.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Reported-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/asm-generic/tlb.h~quicklist-set-tlb-need_flush-if-pages-are-remaining-in-quicklist-0 include/asm-generic/tlb.h
--- a/include/asm-generic/tlb.h~quicklist-set-tlb-need_flush-if-pages-are-remaining-in-quicklist-0
+++ a/include/asm-generic/tlb.h
@@ -14,6 +14,7 @@
 #define _ASM_GENERIC__TLB_H
 
 #include <linux/swap.h>
+#include <linux/quicklist.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
@@ -85,6 +86,9 @@ tlb_flush_mmu(struct mmu_gather *tlb, un
 static inline void
 tlb_finish_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
 {
+#ifdef CONFIG_QUICKLIST
+	tlb->need_flush += &__get_cpu_var(quicklist)[0].nr_pages != 0;
+#endif
 	tlb_flush_mmu(tlb, start, end);
 
 	/* keep the page table cache within bounds */
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
quicklists-do-not-release-off-node-pages-early.patch
git-sched.patch
git-unionfs.patch
git-x86.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-use-non-atomic-bit-unlock.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-fix.patch
slub-restructure-slab-alloc.patch
slub-comment-kmem_cache_cpu-structure.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
swapin_readahead-excise-numa-bogosity.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
vmstat-remove-prefetch.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup-bugfix-for-memory-cgroup-per-zone-struct-allocation.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

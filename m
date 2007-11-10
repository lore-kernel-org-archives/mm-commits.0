From: akpm@linux-foundation.org
Subject: + x86_64-clean-up-stack-allocation-and-free.patch added to -mm tree
Date: Fri, 09 Nov 2007 16:32:44 -0800
Message-ID: <200711100032.lAA0Wia1007075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35257 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064AbXKJAdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 19:33:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, travis@sgi.com


The patch titled
     x86_64: clean up stack allocation and free
has been added to the -mm tree.  Its filename is
     x86_64-clean-up-stack-allocation-and-free.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: clean up stack allocation and free
From: clameter@sgi.com

Clean up the allocation and freeing of stacks a bit by using a __GFP_ZERO flag
instead of memset.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/thread_info_64.h |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN include/asm-x86/thread_info_64.h~x86_64-clean-up-stack-allocation-and-free include/asm-x86/thread_info_64.h
--- a/include/asm-x86/thread_info_64.h~x86_64-clean-up-stack-allocation-and-free
+++ a/include/asm-x86/thread_info_64.h
@@ -74,20 +74,14 @@ static inline struct thread_info *stack_
 
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk)					\
-    ({								\
-	struct thread_info *ret;				\
-								\
-	ret = ((struct thread_info *) __get_free_pages(GFP_KERNEL,THREAD_ORDER)); \
-	if (ret)						\
-		memset(ret, 0, THREAD_SIZE);			\
-	ret;							\
-    })
+#define THREAD_FLAGS (GFP_KERNEL | __GFP_ZERO)
 #else
-#define alloc_thread_info(tsk) \
-	((struct thread_info *) __get_free_pages(GFP_KERNEL,THREAD_ORDER))
+#define THREAD_FLAGS GFP_KERNEL
 #endif
 
+#define alloc_thread_info(tsk) \
+	((struct thread_info *) __get_free_pages(THREAD_FLAGS, THREAD_ORDER))
+
 #define free_thread_info(ti) free_pages((unsigned long) (ti), THREAD_ORDER)
 
 #else /* !__ASSEMBLY__ */
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-fix-typo-in-allocation-failure-handling.patch
migration-find-correct-vma-in-new_vma_page.patch
ia64-slim-down-__clear_bit_unlock.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
git-unionfs.patch
git-x86.patch
x86_64-clean-up-stack-allocation-and-free.patch
x86_64-configure-stack-size.patch
fix-mm-utilckrealloc.patch
vmstat-fix-section-mismatch-warning.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
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
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-restructure-slab-alloc.patch
slub-comment-kmem_cache_cpu-structure.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
swapin_readahead-excise-numa-bogosity.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

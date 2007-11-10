From: akpm@linux-foundation.org
Subject: + x86_64-configure-stack-size.patch added to -mm tree
Date: Fri, 09 Nov 2007 16:32:47 -0800
Message-ID: <200711100032.lAA0Wlq2007078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbXKJAeJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 19:34:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, travis@sgi.com


The patch titled
     x86_64: configure stack size
has been added to the -mm tree.  Its filename is
     x86_64-configure-stack-size.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: configure stack size
From: clameter@sgi.com

Make the stack size configurable necessary.  SGI NUMA configurations may need
more stack because cpumasks and nodemasks are at times kept on the stack. 
This patch allows to run with 16k or 32k kernel stacks.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig.x86_64          |    6 ++++++
 include/asm-x86/page_64.h        |    3 +--
 include/asm-x86/thread_info_64.h |    4 ++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff -puN arch/x86/Kconfig.x86_64~x86_64-configure-stack-size arch/x86/Kconfig.x86_64
--- a/arch/x86/Kconfig.x86_64~x86_64-configure-stack-size
+++ a/arch/x86/Kconfig.x86_64
@@ -370,6 +370,12 @@ config NODES_SHIFT
 	default "6"
 	depends on NEED_MULTIPLE_NODES
 
+config THREAD_ORDER
+	int "Kernel stack size (in page order)"
+	default "1"
+	help
+	  Page order for the thread stack.
+
 # Dummy CONFIG option to select ACPI_NUMA from drivers/acpi/Kconfig.
 
 config X86_64_ACPI_NUMA
diff -puN include/asm-x86/page_64.h~x86_64-configure-stack-size include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h~x86_64-configure-stack-size
+++ a/include/asm-x86/page_64.h
@@ -9,8 +9,7 @@
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 #define PHYSICAL_PAGE_MASK	(~(PAGE_SIZE-1) & __PHYSICAL_MASK)
 
-#define THREAD_ORDER 1 
-#define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
+#define THREAD_SIZE  (PAGE_SIZE << CONFIG_THREAD_ORDER)
 #define CURRENT_MASK (~(THREAD_SIZE-1))
 
 #define EXCEPTION_STACK_ORDER 0
diff -puN include/asm-x86/thread_info_64.h~x86_64-configure-stack-size include/asm-x86/thread_info_64.h
--- a/include/asm-x86/thread_info_64.h~x86_64-configure-stack-size
+++ a/include/asm-x86/thread_info_64.h
@@ -80,9 +80,9 @@ static inline struct thread_info *stack_
 #endif
 
 #define alloc_thread_info(tsk) \
-	((struct thread_info *) __get_free_pages(THREAD_FLAGS, THREAD_ORDER))
+	((struct thread_info *) __get_free_pages(THREAD_FLAGS, CONFIG_THREAD_ORDER))
 
-#define free_thread_info(ti) free_pages((unsigned long) (ti), THREAD_ORDER)
+#define free_thread_info(ti) free_pages((unsigned long) (ti), CONFIG_THREAD_ORDER)
 
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

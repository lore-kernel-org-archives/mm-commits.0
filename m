From: akpm@linux-foundation.org
Subject: - percpu-make-the-asm-generic-percpuh-more-generic.patch removed from -mm tree
Date: Tue, 27 Nov 2007 15:29:48 -0800
Message-ID: <200711272329.lARNTmQM005046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48877 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872AbXK0X35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 18:29:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, ak@suse.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     percpu: make the asm-generic/percpu.h more generic
has been removed from the -mm tree.  Its filename was
     percpu-make-the-asm-generic-percpuh-more-generic.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: percpu: make the asm-generic/percpu.h more generic
From: Christoph Lameter <clameter@sgi.com>

Add the ability to use generic/percpu even if the arch needs to override
several aspects of its operations.  This will enable the use of generic
percpu.h for all arches.

An arch may define:

__per_cpu_offset	Do not use the generic pointer array. Arch must
			define per_cpu_offset(cpu) (used by x86_64, s390).

__my_cpu_offset		Can be defined to provide an optimized way to determine
			the offset for variables of the currently executing
			processor. Used by ia64, x86_64, x86_32, sparc64, s/390.

SHIFT_PTR(ptr, offset)	If an arch defines it then special handling
			of pointer arithmentic may be implemented. Used
			by s/390.

(Some of these special percpu arch implementations may be later consolidated
so that there are less cases to deal with.)

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/percpu.h |   64 +++++++++++++++++++++++++++------
 1 file changed, 53 insertions(+), 11 deletions(-)

diff -puN include/asm-generic/percpu.h~percpu-make-the-asm-generic-percpuh-more-generic include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h~percpu-make-the-asm-generic-percpuh-more-generic
+++ a/include/asm-generic/percpu.h
@@ -3,27 +3,69 @@
 #include <linux/compiler.h>
 #include <linux/threads.h>
 
+/*
+ * Determine the real variable name from the name visible in the
+ * kernel sources.
+ */
+#define per_cpu_var(var) per_cpu__##var
+
 #ifdef CONFIG_SMP
 
+/*
+ * per_cpu_offset() is the offset that has to be added to a
+ * percpu variable to get to the instance for a certain processor.
+ *
+ * Most arches use the __per_cpu_offset array for those offsets but
+ * some arches have their own ways of determining the offset (x86_64, s390).
+ */
+#ifndef __per_cpu_offset
 extern unsigned long __per_cpu_offset[NR_CPUS];
-
 #define per_cpu_offset(x) (__per_cpu_offset[x])
+#endif
 
-/* var is in discarded region: offset to particular copy we want */
-#define per_cpu(var, cpu) (*({				\
-	extern int simple_identifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __per_cpu_offset[cpu]); }))
-#define __get_cpu_var(var) per_cpu(var, smp_processor_id())
-#define __raw_get_cpu_var(var) per_cpu(var, raw_smp_processor_id())
+/*
+ * Determine the offset for the currently active processor.
+ * An arch may define __my_cpu_offset to provide a more effective
+ * means of obtaining the offset to the per cpu variables of the
+ * current processor.
+ */
+#ifndef __my_cpu_offset
+#define __my_cpu_offset per_cpu_offset(raw_smp_processor_id())
+#define my_cpu_offset per_cpu_offset(smp_processor_id())
+#else
+#define my_cpu_offset __my_cpu_offset
+#endif
+
+/*
+ * Add a offset to a pointer but keep the pointer as is.
+ *
+ * Only S390 provides its own means of moving the pointer.
+ */
+#ifndef SHIFT_PTR
+#define SHIFT_PTR(__p, __offset)	RELOC_HIDE((__p), (__offset))
+#endif
+
+/*
+ * A percpu variable may point to a discarded reghions. The following are
+ * established ways to produce a usable pointer from the percpu variable
+ * offset.
+ */
+#define per_cpu(var, cpu) (*SHIFT_PTR(&per_cpu_var(var), per_cpu_offset(cpu)))
+#define __get_cpu_var(var) (*SHIFT_PTR(&per_cpu_var(var), my_cpu_offset))
+#define __raw_get_cpu_var(var) (*SHIFT_PTR(&per_cpu_var(var), __my_cpu_offset))
+
+#ifdef CONFIG_ARCH_SETS_UP_PER_CPU_AREA
+extern void setup_per_cpu_areas(void);
+#endif
 
 #else /* ! SMP */
 
-#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
-#define __get_cpu_var(var)			per_cpu__##var
-#define __raw_get_cpu_var(var)			per_cpu__##var
+#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu_var(var)))
+#define __get_cpu_var(var)			per_cpu_var(var)
+#define __raw_get_cpu_var(var)			per_cpu_var(var)
 
 #endif	/* SMP */
 
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
+#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu_var(name)
 
 #endif /* _ASM_GENERIC_PERCPU_H_ */
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
ia64-slim-down-__clear_bit_unlock.patch
git-unionfs.patch
git-x86.patch
x86_64-make-sparsemem-vmemmap-the-only-memory-model.patch
acpi-avoid-references-to-impossible-processors.patch
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
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
mm-prevent-dereferencing-non-allocated-per_cpu-variables.patch
mm-prevent-dereferencing-non-allocated-per_cpu-variables-fix.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
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

From: akpm@linux-foundation.org
Subject: + x86_64-use-generic-percpu.patch added to -mm tree
Date: Tue, 27 Nov 2007 13:34:21 -0800
Message-ID: <200711272134.lARLYLAv031546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42556 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758154AbXK0Ve7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 16:34:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de


The patch titled
     x86_64: use generic percpu
has been added to the -mm tree.  Its filename is
     x86_64-use-generic-percpu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: use generic percpu
From: Christoph Lameter <clameter@sgi.com>

x86_64 provides an optimized way to determine the local per cpu area offset
through the pda and determines the base by accessing a remote pda.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/percpu_64.h |   28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff -puN include/asm-x86/percpu_64.h~x86_64-use-generic-percpu include/asm-x86/percpu_64.h
--- a/include/asm-x86/percpu_64.h~x86_64-use-generic-percpu
+++ a/include/asm-x86/percpu_64.h
@@ -8,35 +8,13 @@
    from %gs */
 
 #ifdef CONFIG_SMP
-
 #include <asm/pda.h>
 
 #define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
-#define __my_cpu_offset() read_pda(data_offset)
+#define __my_cpu_offset read_pda(data_offset)
 
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
-/* var is in discarded region: offset to particular copy we want */
-#define per_cpu(var, cpu) (*({				\
-	extern int simple_identifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)); }))
-#define __get_cpu_var(var) (*({				\
-	extern int simple_identifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()); }))
-#define __raw_get_cpu_var(var) (*({			\
-	extern int simple_identifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()); }))
-
-extern void setup_per_cpu_areas(void);
-
-#else /* ! SMP */
-
-#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
-#define __get_cpu_var(var)			per_cpu__##var
-#define __raw_get_cpu_var(var)			per_cpu__##var
-
-#endif	/* SMP */
-
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
-
+#endif
+#include <asm-generic/percpu.h>
 #endif /* _ASM_X8664_PERCPU_H_ */
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
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
ia64-remove-the-__small_addr_area-attribute-for-per-cpu-access.patch
percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup.patch
percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh.patch
percpu-make-the-asm-generic-percpuh-more-generic.patch
x86_32-use-generic-percpuh.patch
x86_64-use-generic-percpu.patch
s390-use-generic-percpu.patch
powerpc-use-generic-per-cpu.patch
sparc64-use-generic-percpu.patch
ia64-use-generic-percpu.patch
ia64-use-generic-percpu-fix.patch
x86-unify-percpuh.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

From: akpm@linux-foundation.org
Subject: - percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup.patch removed from -mm tree
Date: Tue, 27 Nov 2007 15:29:44 -0800
Message-ID: <200711272329.lARNTiwa005040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34786 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753168AbXK0X3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 18:29:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, ak@suse.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     percpu: use a Kconfig variable to configure arch specific percpu setup
has been removed from the -mm tree.  Its filename was
     percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: percpu: use a Kconfig variable to configure arch specific percpu setup
From: Christoph Lameter <clameter@sgi.com>

The use of the __GENERIC_PERCPU is a bit problematic since arches may want to
run their own percpu setup while using the generic percpu definitions. 
Replace it through a kconfig variable.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig            |    4 ++++
 arch/powerpc/Kconfig         |    4 ++++
 arch/sparc64/Kconfig         |    4 ++++
 arch/x86/Kconfig             |    6 +++---
 include/asm-generic/percpu.h |    1 -
 include/asm-s390/percpu.h    |    2 --
 include/asm-x86/percpu_32.h  |    2 --
 init/main.c                  |    4 ++--
 8 files changed, 17 insertions(+), 10 deletions(-)

diff -puN arch/ia64/Kconfig~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup
+++ a/arch/ia64/Kconfig
@@ -75,6 +75,10 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default y
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	bool
+	default y
+
 config DMI
 	bool
 	default y
diff -puN arch/powerpc/Kconfig~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup
+++ a/arch/powerpc/Kconfig
@@ -42,6 +42,10 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	bool
+	default PPC64
+
 config IRQ_PER_CPU
 	bool
 	default y
diff -puN arch/sparc64/Kconfig~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup
+++ a/arch/sparc64/Kconfig
@@ -66,6 +66,10 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config ARCH_SETS_UP_PER_CPU_AREA
+	bool
+	default y
+
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
 
diff -puN arch/x86/Kconfig~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup arch/x86/Kconfig
--- a/arch/x86/Kconfig~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup
+++ a/arch/x86/Kconfig
@@ -120,9 +120,9 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default X86_64
 
-
-
-
+config ARCH_SETS_UP_PER_CPU_AREA
+	bool
+	default X86_64
 
 config ZONE_DMA32
 	bool
diff -puN include/asm-generic/percpu.h~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup
+++ a/include/asm-generic/percpu.h
@@ -3,7 +3,6 @@
 #include <linux/compiler.h>
 #include <linux/threads.h>
 
-#define __GENERIC_PER_CPU
 #ifdef CONFIG_SMP
 
 extern unsigned long __per_cpu_offset[NR_CPUS];
diff -puN include/asm-s390/percpu.h~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup include/asm-s390/percpu.h
--- a/include/asm-s390/percpu.h~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup
+++ a/include/asm-s390/percpu.h
@@ -4,8 +4,6 @@
 #include <linux/compiler.h>
 #include <asm/lowcore.h>
 
-#define __GENERIC_PER_CPU
-
 /*
  * s390 uses its own implementation for per cpu data, the offset of
  * the cpu local data area is cached in the cpu's lowcore memory.
diff -puN include/asm-x86/percpu_32.h~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup include/asm-x86/percpu_32.h
--- a/include/asm-x86/percpu_32.h~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup
+++ a/include/asm-x86/percpu_32.h
@@ -41,8 +41,6 @@
  *    PER_CPU(cpu_gdt_descr, %ebx)
  */
 #ifdef CONFIG_SMP
-/* Same as generic implementation except for optimized local access. */
-#define __GENERIC_PER_CPU
 
 /* This is used for other cpus to find our section. */
 extern unsigned long __per_cpu_offset[];
diff -puN init/main.c~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup init/main.c
--- a/init/main.c~percpu-use-a-kconfig-variable-to-configure-arch-specific-percpu-setup
+++ a/init/main.c
@@ -363,7 +363,7 @@ static inline void smp_prepare_cpus(unsi
 
 #else
 
-#ifdef __GENERIC_PER_CPU
+#ifndef CONFIG_ARCH_SETS_UP_PER_CPU_AREA
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 
 EXPORT_SYMBOL(__per_cpu_offset);
@@ -384,7 +384,7 @@ static void __init setup_per_cpu_areas(v
 		ptr += size;
 	}
 }
-#endif /* !__GENERIC_PER_CPU */
+#endif /* CONFIG_ARCH_SETS_UP_CPU_AREA */
 
 /* Called by boot processor to activate the rest. */
 static void __init smp_init(void)
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

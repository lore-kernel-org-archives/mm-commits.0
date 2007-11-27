From: akpm@linux-foundation.org
Subject: + percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh.patch added to -mm tree
Date: Tue, 27 Nov 2007 13:33:17 -0800
Message-ID: <200711272133.lARLXHQT031458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42188 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755399AbXK0Vd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 16:33:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, rusty@rustcorp.com.au


The patch titled
     percpu: move arch XX_PER_CPU_XX definitions into linux/percpu.h
has been added to the -mm tree.  Its filename is
     percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: percpu: move arch XX_PER_CPU_XX definitions into linux/percpu.h
From: Christoph Lameter <clameter@sgi.com>

The arch definitions are all the same.  So move them into linux/percpu.h.

We cannot move DECLARE_PER_CPU since some include files just include
asm/percpu.h to avoid include recursion problems.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/percpu.h |   18 ------------------
 include/asm-ia64/percpu.h    |   18 ------------------
 include/asm-powerpc/percpu.h |   17 -----------------
 include/asm-s390/percpu.h    |   18 ------------------
 include/asm-sparc64/percpu.h |   16 ----------------
 include/asm-x86/percpu_32.h  |   12 ------------
 include/asm-x86/percpu_64.h  |   17 -----------------
 include/linux/percpu.h       |   17 +++++++++++++++++
 8 files changed, 17 insertions(+), 116 deletions(-)

diff -puN include/asm-generic/percpu.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh
+++ a/include/asm-generic/percpu.h
@@ -9,15 +9,6 @@ extern unsigned long __per_cpu_offset[NR
 
 #define per_cpu_offset(x) (__per_cpu_offset[x])
 
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_aligned_in_smp
-
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*({				\
 	extern int simple_identifier_##var(void);	\
@@ -27,12 +18,6 @@ extern unsigned long __per_cpu_offset[NR
 
 #else /* ! SMP */
 
-#define DEFINE_PER_CPU(type, name) \
-    __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-    DEFINE_PER_CPU(type, name)
-
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
 #define __raw_get_cpu_var(var)			per_cpu__##var
@@ -41,7 +26,4 @@ extern unsigned long __per_cpu_offset[NR
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
 
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 #endif /* _ASM_GENERIC_PERCPU_H_ */
diff -puN include/asm-ia64/percpu.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh include/asm-ia64/percpu.h
--- a/include/asm-ia64/percpu.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh
+++ a/include/asm-ia64/percpu.h
@@ -18,21 +18,6 @@
 #define DECLARE_PER_CPU(type, name)				\
 	extern __typeof__(type) per_cpu__##name
 
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name)				\
-	__attribute__((__section__(".data.percpu")))		\
-	__typeof__(type) per_cpu__##name
-
-#ifdef CONFIG_SMP
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
-	__attribute__((__section__(".data.percpu.shared_aligned")))	\
-	__typeof__(type) per_cpu__##name				\
-	____cacheline_aligned_in_smp
-#else
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-	DEFINE_PER_CPU(type, name)
-#endif
-
 #ifdef CONFIG_SMP
 
 extern unsigned long __per_cpu_offset[NR_CPUS];
@@ -57,9 +42,6 @@ extern void *per_cpu_init(void);
 
 #endif	/* SMP */
 
-#define EXPORT_PER_CPU_SYMBOL(var)		EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var)		EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 /*
  * Be extremely careful when taking the address of this variable!  Due to virtual
  * remapping, it is different from the canonical address returned by __get_cpu_var(var)!
diff -puN include/asm-powerpc/percpu.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh include/asm-powerpc/percpu.h
--- a/include/asm-powerpc/percpu.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh
+++ a/include/asm-powerpc/percpu.h
@@ -16,15 +16,6 @@
 #define __my_cpu_offset() get_paca()->data_offset
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_aligned_in_smp
-
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)))
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()))
@@ -34,11 +25,6 @@ extern void setup_per_cpu_areas(void);
 
 #else /* ! SMP */
 
-#define DEFINE_PER_CPU(type, name) \
-    __typeof__(type) per_cpu__##name
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-    DEFINE_PER_CPU(type, name)
-
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
 #define __raw_get_cpu_var(var)			per_cpu__##var
@@ -47,9 +33,6 @@ extern void setup_per_cpu_areas(void);
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
 
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 #else
 #include <asm-generic/percpu.h>
 #endif
diff -puN include/asm-s390/percpu.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh include/asm-s390/percpu.h
--- a/include/asm-s390/percpu.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh
+++ a/include/asm-s390/percpu.h
@@ -34,16 +34,6 @@
 
 extern unsigned long __per_cpu_offset[NR_CPUS];
 
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) \
-    __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_aligned_in_smp
-
 #define __get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
 #define __raw_get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
 #define per_cpu(var,cpu) __reloc_hide(var,__per_cpu_offset[cpu])
@@ -51,11 +41,6 @@ extern unsigned long __per_cpu_offset[NR
 
 #else /* ! SMP */
 
-#define DEFINE_PER_CPU(type, name) \
-    __typeof__(type) per_cpu__##name
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-    DEFINE_PER_CPU(type, name)
-
 #define __get_cpu_var(var) __reloc_hide(var,0)
 #define __raw_get_cpu_var(var) __reloc_hide(var,0)
 #define per_cpu(var,cpu) __reloc_hide(var,0)
@@ -64,7 +49,4 @@ extern unsigned long __per_cpu_offset[NR
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
 
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 #endif /* __ARCH_S390_PERCPU__ */
diff -puN include/asm-sparc64/percpu.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh include/asm-sparc64/percpu.h
--- a/include/asm-sparc64/percpu.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh
+++ a/include/asm-sparc64/percpu.h
@@ -16,15 +16,6 @@ extern unsigned long __per_cpu_shift;
 	(__per_cpu_base + ((unsigned long)(__cpu) << __per_cpu_shift))
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_aligned_in_smp
-
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)))
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __local_per_cpu_offset))
@@ -33,10 +24,6 @@ extern unsigned long __per_cpu_shift;
 #else /* ! SMP */
 
 #define real_setup_per_cpu_areas()		do { } while (0)
-#define DEFINE_PER_CPU(type, name) \
-    __typeof__(type) per_cpu__##name
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-    DEFINE_PER_CPU(type, name)
 
 #define per_cpu(var, cpu)			(*((void)cpu, &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
@@ -46,7 +33,4 @@ extern unsigned long __per_cpu_shift;
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
 
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 #endif /* __ARCH_SPARC64_PERCPU__ */
diff -puN include/asm-x86/percpu_32.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh include/asm-x86/percpu_32.h
--- a/include/asm-x86/percpu_32.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh
+++ a/include/asm-x86/percpu_32.h
@@ -47,16 +47,7 @@ extern unsigned long __per_cpu_offset[];
 
 #define per_cpu_offset(x) (__per_cpu_offset[x])
 
-/* Separate out the type, so (int[3], foo) works. */
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_aligned_in_smp
-
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
@@ -72,9 +63,6 @@ DECLARE_PER_CPU(unsigned long, this_cpu_
 
 #define __get_cpu_var(var) __raw_get_cpu_var(var)
 
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 /* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
 #define __percpu_seg "%%fs:"
 #else  /* !SMP */
diff -puN include/asm-x86/percpu_64.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh include/asm-x86/percpu_64.h
--- a/include/asm-x86/percpu_64.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh
+++ a/include/asm-x86/percpu_64.h
@@ -16,15 +16,6 @@
 
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
-/* Separate out the type, so (int[3], foo) works. */
-#define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
-    ____cacheline_internodealigned_in_smp
-
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*({				\
 	extern int simple_identifier_##var(void);	\
@@ -40,11 +31,6 @@ extern void setup_per_cpu_areas(void);
 
 #else /* ! SMP */
 
-#define DEFINE_PER_CPU(type, name) \
-    __typeof__(type) per_cpu__##name
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
-    DEFINE_PER_CPU(type, name)
-
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
 #define __get_cpu_var(var)			per_cpu__##var
 #define __raw_get_cpu_var(var)			per_cpu__##var
@@ -53,7 +39,4 @@ extern void setup_per_cpu_areas(void);
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
 
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 #endif /* _ASM_X8664_PERCPU_H_ */
diff -puN include/linux/percpu.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh include/linux/percpu.h
--- a/include/linux/percpu.h~percpu-move-arch-xx_per_cpu_xx-definitions-into-linux-percpuh
+++ a/include/linux/percpu.h
@@ -9,6 +9,23 @@
 
 #include <asm/percpu.h>
 
+#define DEFINE_PER_CPU(type, name)					\
+	 __attribute__((__section__(".data.percpu")))			\
+	__typeof__(type) per_cpu__##name
+
+#ifdef CONFIG_SMP
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
+	__attribute__((__section__(".data.percpu.shared_aligned")))	\
+	__typeof__(type) per_cpu__##name				\
+	____cacheline_aligned_in_smp
+#else
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		      \
+	DEFINE_PER_CPU(type, name)
+#endif
+
+#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
+#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
+
 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_ENOUGH_ROOM
 #ifdef CONFIG_MODULES
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

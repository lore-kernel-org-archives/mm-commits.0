From: akpm@linux-foundation.org
Subject: + modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch added to -mm tree
Date: Mon, 26 Nov 2007 20:26:07 -0800
Message-ID: <200711270426.lAR4Q6Fs026753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50531 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755924AbXK0E07 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 23:26:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, benh@kernel.crashing.org, davem@davemloft.net, heiko.carstens@de.ibm.com, mingo@elte.hu, paulus@samba.org, rusty@rustcorp.com.au, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     modules: fold percpu_modcopy into module.c and get rid of the macro from hell
has been added to the -mm tree.  Its filename is
     modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: modules: fold percpu_modcopy into module.c and get rid of the macro from hell
From: Christoph Lameter <clameter@sgi.com>

percpu_modcopy is defined multiple times in arch files.  However, the only
use is in module.c.  Put a static definition into module.c and remove the
definitions from the arch files.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/module.c    |   10 ----------
 include/asm-generic/percpu.h |    8 --------
 include/asm-ia64/percpu.h    |    5 -----
 include/asm-powerpc/percpu.h |    9 ---------
 include/asm-s390/percpu.h    |    9 ---------
 include/asm-sparc64/percpu.h |    8 --------
 include/asm-x86/percpu_32.h  |    9 ---------
 include/asm-x86/percpu_64.h  |    9 ---------
 kernel/module.c              |    8 ++++++++
 9 files changed, 8 insertions(+), 67 deletions(-)

diff -puN arch/ia64/kernel/module.c~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell arch/ia64/kernel/module.c
--- a/arch/ia64/kernel/module.c~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell
+++ a/arch/ia64/kernel/module.c
@@ -941,13 +941,3 @@ module_arch_cleanup (struct module *mod)
 		unw_remove_unwind_table(mod->arch.core_unw_table);
 }
 
-#ifdef CONFIG_SMP
-void
-percpu_modcopy (void *pcpudst, const void *src, unsigned long size)
-{
-	unsigned int i;
-	for_each_possible_cpu(i) {
-		memcpy(pcpudst + __per_cpu_offset[i], src, size);
-	}
-}
-#endif /* CONFIG_SMP */
diff -puN include/asm-generic/percpu.h~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell
+++ a/include/asm-generic/percpu.h
@@ -26,14 +26,6 @@ extern unsigned long __per_cpu_offset[NR
 #define __get_cpu_var(var) per_cpu(var, smp_processor_id())
 #define __raw_get_cpu_var(var) per_cpu(var, raw_smp_processor_id())
 
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset[__i],		\
-		       (src), (size));				\
-} while (0)
 #else /* ! SMP */
 
 #define DEFINE_PER_CPU(type, name) \
diff -puN include/asm-ia64/percpu.h~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell include/asm-ia64/percpu.h
--- a/include/asm-ia64/percpu.h~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell
+++ a/include/asm-ia64/percpu.h
@@ -39,10 +39,6 @@
 	DEFINE_PER_CPU(type, name)
 #endif
 
-/*
- * Pretty much a literal copy of asm-generic/percpu.h, except that percpu_modcopy() is an
- * external routine, to avoid include-hell.
- */
 #ifdef CONFIG_SMP
 
 extern unsigned long __per_cpu_offset[NR_CPUS];
@@ -55,7 +51,6 @@ DECLARE_PER_CPU(unsigned long, local_per
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __ia64_per_cpu_var(local_per_cpu_offset)))
 #define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __ia64_per_cpu_var(local_per_cpu_offset)))
 
-extern void percpu_modcopy(void *pcpudst, const void *src, unsigned long size);
 extern void setup_per_cpu_areas (void);
 extern void *per_cpu_init(void);
 
diff -puN include/asm-powerpc/percpu.h~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell include/asm-powerpc/percpu.h
--- a/include/asm-powerpc/percpu.h~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell
+++ a/include/asm-powerpc/percpu.h
@@ -30,15 +30,6 @@
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()))
 #define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, local_paca->data_offset))
 
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset(__i),		\
-		       (src), (size));				\
-} while (0)
-
 extern void setup_per_cpu_areas(void);
 
 #else /* ! SMP */
diff -puN include/asm-s390/percpu.h~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell include/asm-s390/percpu.h
--- a/include/asm-s390/percpu.h~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell
+++ a/include/asm-s390/percpu.h
@@ -51,15 +51,6 @@ extern unsigned long __per_cpu_offset[NR
 #define per_cpu(var,cpu) __reloc_hide(var,__per_cpu_offset[cpu])
 #define per_cpu_offset(x) (__per_cpu_offset[x])
 
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset[__i],		\
-		       (src), (size));				\
-} while (0)
-
 #else /* ! SMP */
 
 #define DEFINE_PER_CPU(type, name) \
diff -puN include/asm-sparc64/percpu.h~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell include/asm-sparc64/percpu.h
--- a/include/asm-sparc64/percpu.h~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell
+++ a/include/asm-sparc64/percpu.h
@@ -30,14 +30,6 @@ extern unsigned long __per_cpu_shift;
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __local_per_cpu_offset))
 #define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __local_per_cpu_offset))
 
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset(__i),		\
-		       (src), (size));				\
-} while (0)
 #else /* ! SMP */
 
 #define real_setup_per_cpu_areas()		do { } while (0)
diff -puN include/asm-x86/percpu_32.h~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell include/asm-x86/percpu_32.h
--- a/include/asm-x86/percpu_32.h~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell
+++ a/include/asm-x86/percpu_32.h
@@ -74,15 +74,6 @@ DECLARE_PER_CPU(unsigned long, this_cpu_
 
 #define __get_cpu_var(var) __raw_get_cpu_var(var)
 
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset[__i],		\
-		       (src), (size));				\
-} while (0)
-
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
 
diff -puN include/asm-x86/percpu_64.h~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell include/asm-x86/percpu_64.h
--- a/include/asm-x86/percpu_64.h~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell
+++ a/include/asm-x86/percpu_64.h
@@ -36,15 +36,6 @@
 	extern int simple_identifier_##var(void);	\
 	RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()); }))
 
-/* A macro to avoid #include hell... */
-#define percpu_modcopy(pcpudst, src, size)			\
-do {								\
-	unsigned int __i;					\
-	for_each_possible_cpu(__i)				\
-		memcpy((pcpudst)+__per_cpu_offset(__i),		\
-		       (src), (size));				\
-} while (0)
-
 extern void setup_per_cpu_areas(void);
 
 #else /* ! SMP */
diff -puN kernel/module.c~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell kernel/module.c
--- a/kernel/module.c~modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell
+++ a/kernel/module.c
@@ -421,6 +421,14 @@ static unsigned int find_pcpusec(Elf_Ehd
 	return find_sec(hdr, sechdrs, secstrings, ".data.percpu");
 }
 
+static void percpu_modcopy(void *pcpudest, const void *from, unsigned long size)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		memcpy(pcpudest + per_cpu_offset(cpu), from, size);
+}
+
 static int percpu_modinit(void)
 {
 	pcpu_num_used = 2;
_

Patches currently in -mm which might be from clameter@sgi.com are

ia64-slim-down-__clear_bit_unlock.patch
git-s390.patch
git-unionfs.patch
git-x86.patch
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
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

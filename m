From: akpm@linux-foundation.org
Subject: - ia64-remove-the-__small_addr_area-attribute-for-per-cpu-access.patch removed from -mm tree
Date: Tue, 27 Nov 2007 15:29:41 -0800
Message-ID: <200711272329.lARNTgxt005037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752406AbXK0X3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 18:29:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dmosberger@gmail.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: remove the __SMALL_ADDR_AREA attribute for per cpu access
has been removed from the -mm tree.  Its filename was
     ia64-remove-the-__small_addr_area-attribute-for-per-cpu-access.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ia64: remove the __SMALL_ADDR_AREA attribute for per cpu access
From: Christoph Lameter <clameter@sgi.com>

The model(small) attribute is not supported by gcc 4.X.  The tests will always
be negative today.

Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: David Mosberger-Tang <dmosberger@gmail.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/scripts/check-model.c   |    1 -
 arch/ia64/scripts/toolchain-flags |    6 ------
 include/asm-ia64/percpu.h         |   12 +++---------
 3 files changed, 3 insertions(+), 16 deletions(-)

diff -puN arch/ia64/scripts/check-model.c~ia64-remove-the-__small_addr_area-attribute-for-per-cpu-access /dev/null
--- a/arch/ia64/scripts/check-model.c
+++ /dev/null
@@ -1 +0,0 @@
-int __attribute__ ((__model__ (__small__))) x;
diff -puN arch/ia64/scripts/toolchain-flags~ia64-remove-the-__small_addr_area-attribute-for-per-cpu-access arch/ia64/scripts/toolchain-flags
--- a/arch/ia64/scripts/toolchain-flags~ia64-remove-the-__small_addr_area-attribute-for-per-cpu-access
+++ a/arch/ia64/scripts/toolchain-flags
@@ -35,12 +35,6 @@ if [ $res -eq 0 ]; then
     CPPFLAGS="$CPPFLAGS -DHAVE_WORKING_TEXT_ALIGN"
 fi
 
-if ! $CC -c $dir/check-model.c -o $out 2>&1 | grep  __model__ | grep -q attrib
-then
-    CPPFLAGS="$CPPFLAGS -DHAVE_MODEL_SMALL_ATTRIBUTE"
-fi
-rm -f $out
-
 # Check whether assembler supports .serialize.{data,instruction} directive.
 
 $CC -c $dir/check-serialize.S -o $out 2>/dev/null
diff -puN include/asm-ia64/percpu.h~ia64-remove-the-__small_addr_area-attribute-for-per-cpu-access include/asm-ia64/percpu.h
--- a/include/asm-ia64/percpu.h~ia64-remove-the-__small_addr_area-attribute-for-per-cpu-access
+++ a/include/asm-ia64/percpu.h
@@ -15,24 +15,18 @@
 
 #include <linux/threads.h>
 
-#ifdef HAVE_MODEL_SMALL_ATTRIBUTE
-# define __SMALL_ADDR_AREA	__attribute__((__model__ (__small__)))
-#else
-# define __SMALL_ADDR_AREA
-#endif
-
 #define DECLARE_PER_CPU(type, name)				\
-	extern __SMALL_ADDR_AREA __typeof__(type) per_cpu__##name
+	extern __typeof__(type) per_cpu__##name
 
 /* Separate out the type, so (int[3], foo) works. */
 #define DEFINE_PER_CPU(type, name)				\
 	__attribute__((__section__(".data.percpu")))		\
-	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name
+	__typeof__(type) per_cpu__##name
 
 #ifdef CONFIG_SMP
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
 	__attribute__((__section__(".data.percpu.shared_aligned")))	\
-	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name		\
+	__typeof__(type) per_cpu__##name				\
 	____cacheline_aligned_in_smp
 #else
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
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

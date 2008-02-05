From: akpm@linux-foundation.org
Subject: - slub-optional-fast-path-using-cmpxchg_local.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:45:41 -0800
Message-ID: <200802050245.m152jMbI031182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55218 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbYBECp2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:45:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, linux-arch@vger.kernel.org, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     SLUB: optional fast path using cmpxchg_local
has been removed from the -mm tree.  Its filename was
     slub-optional-fast-path-using-cmpxchg_local.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SLUB: optional fast path using cmpxchg_local
From: Christoph Lameter <clameter@sgi.com>

Provide an alternate implementation of the SLUB fast paths for alloc
and free using cmpxchg_local. The cmpxchg_local fast path is selected
for arches that have CONFIG_FAST_CMPXCHG_LOCAL set. An arch should only
set CONFIG_FAST_CMPXCHG_LOCAL if the cmpxchg_local is faster than an
interrupt enable/disable sequence. This is known to be true for both
x86 platforms so set FAST_CMPXCHG_LOCAL for both arches.

Not all arches can support fast cmpxchg operations. Typically the
architecture must have an optimized cmpxchg instruction. The
cmpxchg fast path makes no sense on platforms whose cmpxchg is
slower than interrupt enable/disable (like f.e. IA64).

The advantages of a cmpxchg_local based fast path are:

1. Lower cycle count (30%-60% faster)

2. There is no need to disable and enable interrupts on the fast path.
   Currently interrupts have to be disabled and enabled on every
   slab operation. This is likely saving a significant percentage
   of interrupt off / on sequences in the kernel.

3. The disposal of freed slabs can occur with interrupts enabled.

The alternate path is realized using #ifdef's. Several attempts to do the
same with macros and in line functions resulted in a mess (in particular due
to the strange way that local_interrupt_save() handles its argument and due
to the need to define macros/functions that sometimes disable interrupts
and sometimes do something else. The macro based approaches made it also

#ifdef seems to be the way to go here to have a readable source.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    4 ++
 mm/slub.c        |   71 +++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 73 insertions(+), 2 deletions(-)

diff -puN arch/x86/Kconfig~slub-optional-fast-path-using-cmpxchg_local arch/x86/Kconfig
--- a/arch/x86/Kconfig~slub-optional-fast-path-using-cmpxchg_local
+++ a/arch/x86/Kconfig
@@ -50,6 +50,10 @@ config HAVE_LATENCYTOP_SUPPORT
 config SEMAPHORE_SLEEPERS
 	def_bool y
 
+config FAST_CMPXCHG_LOCAL
+	bool
+	default y
+
 config MMU
 	def_bool y
 
diff -puN mm/slub.c~slub-optional-fast-path-using-cmpxchg_local mm/slub.c
--- a/mm/slub.c~slub-optional-fast-path-using-cmpxchg_local
+++ a/mm/slub.c
@@ -1496,7 +1496,12 @@ static void *__slab_alloc(struct kmem_ca
 {
 	void **object;
 	struct page *new;
+#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+	unsigned long flags;
 
+	local_irq_save(flags);
+	preempt_enable_no_resched();
+#endif
 	if (!c->page)
 		goto new_slab;
 
@@ -1518,6 +1523,10 @@ load_freelist:
 unlock_out:
 	slab_unlock(c->page);
 out:
+#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+	preempt_disable();
+	local_irq_restore(flags);
+#endif
 	return object;
 
 another_slab:
@@ -1574,9 +1583,26 @@ static __always_inline void *slab_alloc(
 		gfp_t gfpflags, int node, void *addr)
 {
 	void **object;
-	unsigned long flags;
 	struct kmem_cache_cpu *c;
 
+#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+	c = get_cpu_slab(s, get_cpu());
+	do {
+		object = c->freelist;
+		if (unlikely(is_end(object) || !node_match(c, node))) {
+			object = __slab_alloc(s, gfpflags, node, addr, c);
+			if (unlikely(!object)) {
+				put_cpu();
+				goto out;
+			}
+			break;
+		}
+	} while (cmpxchg_local(&c->freelist, object, object[c->offset])
+								!= object);
+	put_cpu();
+#else
+	unsigned long flags;
+
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
 	if (unlikely((is_end(c->freelist)) || !node_match(c, node))) {
@@ -1591,6 +1617,7 @@ static __always_inline void *slab_alloc(
 		c->freelist = object[c->offset];
 	}
 	local_irq_restore(flags);
+#endif
 
 	if (unlikely((gfpflags & __GFP_ZERO)))
 		memset(object, 0, c->objsize);
@@ -1626,6 +1653,11 @@ static void __slab_free(struct kmem_cach
 	void *prior;
 	void **object = (void *)x;
 
+#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+	unsigned long flags;
+
+	local_irq_save(flags);
+#endif
 	slab_lock(page);
 
 	if (unlikely(SlabDebug(page)))
@@ -1651,6 +1683,9 @@ checks_ok:
 
 out_unlock:
 	slab_unlock(page);
+#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+	local_irq_restore(flags);
+#endif
 	return;
 
 slab_empty:
@@ -1661,6 +1696,9 @@ slab_empty:
 		remove_partial(s, page);
 
 	slab_unlock(page);
+#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+	local_irq_restore(flags);
+#endif
 	discard_slab(s, page);
 	return;
 
@@ -1685,9 +1723,37 @@ static __always_inline void slab_free(st
 			struct page *page, void *x, void *addr)
 {
 	void **object = (void *)x;
-	unsigned long flags;
 	struct kmem_cache_cpu *c;
 
+#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+	void **freelist;
+
+	c = get_cpu_slab(s, get_cpu());
+	debug_check_no_locks_freed(object, s->objsize);
+	do {
+		freelist = c->freelist;
+		barrier();
+		/*
+		 * If the compiler would reorder the retrieval of c->page to
+		 * come before c->freelist then an interrupt could
+		 * change the cpu slab before we retrieve c->freelist. We
+		 * could be matching on a page no longer active and put the
+		 * object onto the freelist of the wrong slab.
+		 *
+		 * On the other hand: If we already have the freelist pointer
+		 * then any change of cpu_slab will cause the cmpxchg to fail
+		 * since the freelist pointers are unique per slab.
+		 */
+		if (unlikely(page != c->page || c->node < 0)) {
+			__slab_free(s, page, x, addr, c->offset);
+			break;
+		}
+		object[c->offset] = freelist;
+	} while (cmpxchg_local(&c->freelist, freelist, object) != freelist);
+	put_cpu();
+#else
+	unsigned long flags;
+
 	local_irq_save(flags);
 	debug_check_no_locks_freed(object, s->objsize);
 	c = get_cpu_slab(s, smp_processor_id());
@@ -1698,6 +1764,7 @@ static __always_inline void slab_free(st
 		__slab_free(s, page, x, addr, c->offset);
 
 	local_irq_restore(flags);
+#endif
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-restructure-slab-alloc.patch
slub-comment-kmem_cache_cpu-structure.patch
slub-fix-sysfs-refcounting.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
swapin_readahead-excise-numa-bogosity.patch
page-allocator-clean-up-pcp-draining-functions.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
vmstat-remove-prefetch.patch
set_page_refcounted-vm_bug_on-fix.patch
page-migraton-handle-orphaned-pages.patch
mm-fix-section-mismatch-warning-in-sparsec.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
git-newsetup.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

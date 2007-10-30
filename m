From: akpm@linux-foundation.org
Subject: + slub-optional-fast-path-using-cmpxchg_local.patch added to -mm tree
Date: Tue, 30 Oct 2007 11:49:38 -0700
Message-ID: <200710301849.l9UIncnk022148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54395 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029AbXJ3Sts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:49:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, linux-arch@vger.kernel.org, penberg@cs.helsinki.fi


The patch titled
     SLUB: optional fast path using cmpxchg_local
has been added to the -mm tree.  Its filename is
     slub-optional-fast-path-using-cmpxchg_local.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/x86/Kconfig.i386   |    4 ++
 arch/x86/Kconfig.x86_64 |    4 ++
 mm/slub.c               |   71 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 77 insertions(+), 2 deletions(-)

diff -puN arch/x86/Kconfig.i386~slub-optional-fast-path-using-cmpxchg_local arch/x86/Kconfig.i386
--- a/arch/x86/Kconfig.i386~slub-optional-fast-path-using-cmpxchg_local
+++ a/arch/x86/Kconfig.i386
@@ -51,6 +51,10 @@ config X86
 	bool
 	default y
 
+config FAST_CMPXCHG_LOCAL
+	bool
+	default y
+
 config MMU
 	bool
 	default y
diff -puN arch/x86/Kconfig.x86_64~slub-optional-fast-path-using-cmpxchg_local arch/x86/Kconfig.x86_64
--- a/arch/x86/Kconfig.x86_64~slub-optional-fast-path-using-cmpxchg_local
+++ a/arch/x86/Kconfig.x86_64
@@ -97,6 +97,10 @@ config X86_CMPXCHG
 	bool
 	default y
 
+config FAST_CMPXCHG_LOCAL
+	bool
+	default y
+
 config GENERIC_ISA_DMA
 	bool
 	default y
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
@@ -1592,9 +1601,26 @@ static __always_inline void *slab_alloc(
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
@@ -1609,6 +1635,7 @@ static __always_inline void *slab_alloc(
 		c->freelist = object[c->offset];
 	}
 	local_irq_restore(flags);
+#endif
 
 	if (unlikely((gfpflags & __GFP_ZERO)))
 		memset(object, 0, c->objsize);
@@ -1644,6 +1671,11 @@ static void __slab_free(struct kmem_cach
 	void *prior;
 	void **object = (void *)x;
 
+#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+	unsigned long flags;
+
+	local_irq_save(flags);
+#endif
 	slab_lock(page);
 
 	if (unlikely(SlabDebug(page)))
@@ -1669,6 +1701,9 @@ checks_ok:
 
 out_unlock:
 	slab_unlock(page);
+#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+	local_irq_restore(flags);
+#endif
 	return;
 
 slab_empty:
@@ -1679,6 +1714,9 @@ slab_empty:
 		remove_partial(s, page);
 
 	slab_unlock(page);
+#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+	local_irq_restore(flags);
+#endif
 	discard_slab(s, page);
 	return;
 
@@ -1703,9 +1741,37 @@ static __always_inline void slab_free(st
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
@@ -1716,6 +1782,7 @@ static __always_inline void slab_free(st
 		__slab_free(s, page, x, addr, c->offset);
 
 	local_irq_restore(flags);
+#endif
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
_

Patches currently in -mm which might be from clameter@sgi.com are

ia64-slim-down-__clear_bit_unlock.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
git-unionfs.patch
git-x86.patch
fix-mm-utilckrealloc.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
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
slub-restructure-slab-alloc.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
swapin_readahead-excise-numa-bogosity.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

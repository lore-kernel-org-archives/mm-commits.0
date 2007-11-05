From: akpm@linux-foundation.org
Subject: + slub-restructure-slab-alloc.patch added to -mm tree
Date: Mon, 05 Nov 2007 14:28:05 -0800
Message-ID: <200711052228.lA5MS5xb022810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35072 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754123AbXKEW2K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 17:28:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     SLUB: restructure slab alloc
has been added to the -mm tree.  Its filename is
     slub-restructure-slab-alloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: restructure slab alloc
From: Christoph Lameter <clameter@sgi.com>

Restructure slab_alloc so that the code flows in the sequence it is usually
executed.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff -puN mm/slub.c~slub-restructure-slab-alloc mm/slub.c
--- a/mm/slub.c~slub-restructure-slab-alloc
+++ a/mm/slub.c
@@ -1563,16 +1563,28 @@ static void *__slab_alloc(struct kmem_ca
 	local_irq_save(flags);
 	preempt_enable_no_resched();
 #endif
-	if (!c->page)
-		goto new_slab;
+	if (likely(c->page)) {
+		state = slab_lock(c->page);
+
+		if (unlikely(node_match(c, node) &&
+			c->page->freelist != c->page->end))
+				goto load_freelist;
+
+		deactivate_slab(s, c, state);
+	}
+
+another_slab:
+	state = get_partial(s, c, gfpflags, node);
+	if (!state)
+		goto grow_slab;
 
-	state = slab_lock(c->page);
-	if (unlikely(!node_match(c, node)))
-		goto another_slab;
 load_freelist:
-	object = c->page->freelist;
-	if (unlikely(object == c->page->end))
-		goto another_slab;
+	/*
+	 * slabs from the partial list must have at least
+	 * one free object.
+	 */
+	VM_BUG_ON(c->page->freelist == c->page->end);
+
 	if (unlikely(state & SLABDEBUG))
 		goto debug;
 
@@ -1590,20 +1602,16 @@ out:
 #endif
 	return object;
 
-another_slab:
-	deactivate_slab(s, c, state);
-
-new_slab:
-	state = get_partial(s, c, gfpflags, node);
-	if (state)
-		goto load_freelist;
-
+/* Extend the slabcache with a new slab */
+grow_slab:
 	state = get_new_slab(s, &c, gfpflags, node);
 	if (state)
 		goto load_freelist;
 
 	object = NULL;
 	goto out;
+
+/* Perform debugging */
 debug:
 	object = c->page->freelist;
 	if (!alloc_debug_processing(s, c->page, object, addr))
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
ia64-slim-down-__clear_bit_unlock.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
git-unionfs.patch
git-x86.patch
fix-mm-utilckrealloc.patch
vmstat-fix-section-mismatch-warning.patch
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
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

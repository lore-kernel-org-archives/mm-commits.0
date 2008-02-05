From: akpm@linux-foundation.org
Subject: - slub-restructure-slab-alloc.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:45:51 -0800
Message-ID: <200802050245.m152jWhu031188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44723 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbYBECpi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:45:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     SLUB: restructure slab alloc
has been removed from the -mm tree.  Its filename was
     slub-restructure-slab-alloc.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -1564,16 +1564,28 @@ static void *__slab_alloc(struct kmem_ca
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
 
@@ -1591,20 +1603,16 @@ out:
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
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
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

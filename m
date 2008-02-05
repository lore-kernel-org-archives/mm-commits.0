From: akpm@linux-foundation.org
Subject: - slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:45:35 -0800
Message-ID: <200802050245.m152jHSB031179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43312 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267AbYBECpW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:45:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     SLUB: avoid referencing kmem_cache structure in __slab_alloc
has been removed from the -mm tree.  Its filename was
     slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SLUB: avoid referencing kmem_cache structure in __slab_alloc
From: Christoph Lameter <clameter@sgi.com>

There is the need to use the objects per slab in the first part of
__slab_alloc() which is still pretty hot.  Copy the number of objects per slab
into the kmem_cache_cpu structure.  That way we can get the value from a cache
line that we already need to touch.  This brings the kmem_cache_cpu structure
up to 4 even words.

There is no increase in the size of kmem_cache_cpu since the size of object
is rounded to the next word.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    1 +
 mm/slub.c                |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/slub_def.h~slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc
+++ a/include/linux/slub_def.h
@@ -17,6 +17,7 @@ struct kmem_cache_cpu {
 	int node;
 	unsigned int offset;
 	unsigned int objsize;
+	unsigned int objects;
 };
 
 struct kmem_cache_node {
diff -puN mm/slub.c~slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc mm/slub.c
--- a/mm/slub.c~slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc
+++ a/mm/slub.c
@@ -1512,7 +1512,7 @@ load_freelist:
 
 	object = c->page->freelist;
 	c->freelist = object[c->offset];
-	c->page->inuse = s->objects;
+	c->page->inuse = c->objects;
 	c->page->freelist = c->page->end;
 	c->node = page_to_nid(c->page);
 unlock_out:
@@ -1878,6 +1878,7 @@ static void init_kmem_cache_cpu(struct k
 	c->node = 0;
 	c->offset = s->offset / sizeof(void *);
 	c->objsize = s->objsize;
+	c->objects = s->objects;
 }
 
 static void init_kmem_cache_node(struct kmem_cache_node *n)
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
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

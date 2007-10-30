From: akpm@linux-foundation.org
Subject: + slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch added to -mm tree
Date: Tue, 30 Oct 2007 11:38:53 -0700
Message-ID: <200710301838.l9UIcrH9021713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41040 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104AbXJ3SjB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:39:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     SLUB: avoid referencing kmem_cache structure in __slab_alloc
has been added to the -mm tree.  Its filename is
     slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1896,6 +1896,7 @@ static void init_kmem_cache_cpu(struct k
 	c->node = 0;
 	c->offset = s->offset / sizeof(void *);
 	c->objsize = s->objsize;
+	c->objects = s->objects;
 }
 
 static void init_kmem_cache_node(struct kmem_cache_node *n)
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

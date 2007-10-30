From: akpm@linux-foundation.org
Subject: + slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch added to -mm tree
Date: Tue, 30 Oct 2007 11:32:13 -0700
Message-ID: <200710301832.l9UIWDXb021456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679AbXJ3ScT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:32:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     SLUB: avoid checking for a valid object before zeroing on the fast path
has been added to the -mm tree.  Its filename is
     slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: avoid checking for a valid object before zeroing on the fast path
From: Christoph Lameter <clameter@sgi.com>

The fast path always results in a valid object.  Move the check for the NULL
pointer to the slow branch that calls __slab_alloc.  Only __slab_alloc can
return NULL if there is no memory available anymore and that case is
exceedingly rare.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/slub.c~slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path mm/slub.c
--- a/mm/slub.c~slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path
+++ a/mm/slub.c
@@ -1573,19 +1573,22 @@ static __always_inline void *slab_alloc(
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (unlikely(!c->freelist || !node_match(c, node)))
+	if (unlikely(!c->freelist || !node_match(c, node))) {
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
-
-	else {
+		if (unlikely(!object)) {
+			local_irq_restore(flags);
+			goto out;
+		}
+	} else {
 		object = c->freelist;
 		c->freelist = object[c->offset];
 	}
 	local_irq_restore(flags);
 
-	if (unlikely((gfpflags & __GFP_ZERO) && object))
+	if (unlikely((gfpflags & __GFP_ZERO)))
 		memset(object, 0, c->objsize);
-
+out:
 	return object;
 }
 
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

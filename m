From: akpm@linux-foundation.org
Subject: [folded-merged]
 slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub-fix.patch
 removed from -mm tree
Date: Tue, 15 Mar 2016 14:35:38 -0700
Message-ID: <56e8802a.vIOGtIQBWwldWv1z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbcCOVfj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:35:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub-fix
has been removed from the -mm tree.  Its filename was
     slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub-fix.patch

This patch was dropped because it was folded into slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub.patch

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub-fix

Second fix is for correct masking of allowed GFP flags (gfp_allowed_mask),
in SLAB allocator.  This triggered a WARN, by percpu_init_late ->
pcpu_mem_zalloc invoking kzalloc with GFP_KERNEL flags. The linux-next
commit needing this fix is a1fd55538cae ("slab: use
slab_pre_alloc_hook in SLAB allocator shared with SLUB").

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/slab.c~slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub-fix mm/slab.c
--- a/mm/slab.c~slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub-fix
+++ a/mm/slab.c
@@ -3143,6 +3143,7 @@ slab_alloc_node(struct kmem_cache *cache
 	void *ptr;
 	int slab_node = numa_mem_id();
 
+	flags &= gfp_allowed_mask;
 	cachep = slab_pre_alloc_hook(cachep, flags);
 	if (unlikely(!cachep))
 		return NULL;
@@ -3226,6 +3227,7 @@ slab_alloc(struct kmem_cache *cachep, gf
 	unsigned long save_flags;
 	void *objp;
 
+	flags &= gfp_allowed_mask;
 	cachep = slab_pre_alloc_hook(cachep, flags);
 	if (unlikely(!cachep))
 		return NULL;
_

Patches currently in -mm which might be from brouer@redhat.com are

slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk.patch
mm-slab-move-slub-alloc-hooks-to-common-mm-slabh.patch
mm-fault-inject-take-over-bootstrap-kmem_cache-check.patch
slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub.patch
mm-kmemcheck-skip-object-if-slab-allocation-failed.patch
slab-use-slab_post_alloc_hook-in-slab-allocator-shared-with-slub.patch
slab-implement-bulk-alloc-in-slab-allocator.patch
slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk.patch
slab-implement-bulk-free-in-slab-allocator.patch
mm-new-api-kfree_bulk-for-slabslub-allocators.patch
mm-fix-some-spelling.patch


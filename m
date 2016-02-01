From: akpm@linux-foundation.org
Subject: +
 slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub-fix.patch
 added to -mm tree
Date: Mon, 01 Feb 2016 15:36:34 -0800
Message-ID: <56afec02.8lgBJ7zKxnyNn/jV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbcBAXge (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2016 18:36:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub-fix
has been added to the -mm tree.  Its filename is
     slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

diff -puN mm/failslab.c~slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub-fix mm/failslab.c
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
mm-fault-inject-take-over-bootstrap-kmem_cache-check-fix.patch
slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub.patch
slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub-fix.patch
mm-kmemcheck-skip-object-if-slab-allocation-failed.patch
slab-use-slab_post_alloc_hook-in-slab-allocator-shared-with-slub.patch
slab-implement-bulk-alloc-in-slab-allocator.patch
slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk.patch
slab-implement-bulk-free-in-slab-allocator.patch
mm-new-api-kfree_bulk-for-slabslub-allocators.patch
mm-fix-some-spelling.patch


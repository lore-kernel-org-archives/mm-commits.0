From: akpm@linux-foundation.org
Subject: +
 slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 19:29:05 -0800
Message-ID: <56a83981.nm+/PyztQRg0letw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbcA0D3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 22:29:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: cleanup code for kmem cgroup support to kmem_cache_free_bulk
has been added to the -mm tree.  Its filename is
     slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk.patch

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
Subject: slub: cleanup code for kmem cgroup support to kmem_cache_free_bulk

This change is primarily an attempt to make it easier to realize the
optimizations the compiler performs in-case CONFIG_MEMCG_KMEM is not
enabled.

Performance wise, even when CONFIG_MEMCG_KMEM is compiled in, the overhead
is zero.  This is because, as long as no process have enabled kmem cgroups
accounting, the assignment is replaced by asm-NOP operations.  This is
possible because memcg_kmem_enabled() uses a static_key_false() construct.

It also helps readability as it avoid accessing the p[] array like: p[size
- 1] which "expose" that the array is processed backwards inside helper
function build_detached_freelist().

Lastly this also makes the code more robust, in error case like passing
NULL pointers in the array.  Which were previously handled before commit
033745189b1b ("slub: add missing kmem cgroup support to
kmem_cache_free_bulk").

Fixes: 033745189b1b ("slub: add missing kmem cgroup support to kmem_cache_free_bulk")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/slub.c~slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk mm/slub.c
--- a/mm/slub.c~slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk
+++ a/mm/slub.c
@@ -2821,6 +2821,7 @@ struct detached_freelist {
 	void *tail;
 	void *freelist;
 	int cnt;
+	struct kmem_cache *s;
 };
 
 /*
@@ -2835,8 +2836,9 @@ struct detached_freelist {
  * synchronization primitive.  Look ahead in the array is limited due
  * to performance reasons.
  */
-static int build_detached_freelist(struct kmem_cache *s, size_t size,
-				   void **p, struct detached_freelist *df)
+static inline
+int build_detached_freelist(struct kmem_cache *s, size_t size,
+			    void **p, struct detached_freelist *df)
 {
 	size_t first_skipped_index = 0;
 	int lookahead = 3;
@@ -2852,8 +2854,11 @@ static int build_detached_freelist(struc
 	if (!object)
 		return 0;
 
+	/* Support for memcg, compiler can optimize this out */
+	df->s = cache_from_obj(s, object);
+
 	/* Start new detached freelist */
-	set_freepointer(s, object, NULL);
+	set_freepointer(df->s, object, NULL);
 	df->page = virt_to_head_page(object);
 	df->tail = object;
 	df->freelist = object;
@@ -2868,7 +2873,7 @@ static int build_detached_freelist(struc
 		/* df->page is always set at this point */
 		if (df->page == virt_to_head_page(object)) {
 			/* Opportunity build freelist */
-			set_freepointer(s, object, df->freelist);
+			set_freepointer(df->s, object, df->freelist);
 			df->freelist = object;
 			df->cnt++;
 			p[size] = NULL; /* mark object processed */
@@ -2887,25 +2892,20 @@ static int build_detached_freelist(struc
 	return first_skipped_index;
 }
 
-
 /* Note that interrupts must be enabled when calling this function. */
-void kmem_cache_free_bulk(struct kmem_cache *orig_s, size_t size, void **p)
+void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 {
 	if (WARN_ON(!size))
 		return;
 
 	do {
 		struct detached_freelist df;
-		struct kmem_cache *s;
-
-		/* Support for memcg */
-		s = cache_from_obj(orig_s, p[size - 1]);
 
 		size = build_detached_freelist(s, size, p, &df);
 		if (unlikely(!df.page))
 			continue;
 
-		slab_free(s, df.page, df.freelist, df.tail, df.cnt, _RET_IP_);
+		slab_free(df.s, df.page, df.freelist, df.tail, df.cnt,_RET_IP_);
 	} while (likely(size));
 }
 EXPORT_SYMBOL(kmem_cache_free_bulk);
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


From: akpm@linux-foundation.org
Subject: + mm-slab-lockless-decision-to-grow-cache.patch added to -mm tree
Date: Mon, 28 Mar 2016 14:22:41 -0700
Message-ID: <56f9a0a1.cC6W1x0i5E+XF5aj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbcC1VWm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 17:22:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: lockless decision to grow cache
has been added to the -mm tree.  Its filename is
     mm-slab-lockless-decision-to-grow-cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-lockless-decision-to-grow-cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-lockless-decision-to-grow-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: lockless decision to grow cache

To check whther free objects exist or not precisely, we need to grab a
lock.  But, accuracy isn't that important because race window would be
even small and if there is too much free object, cache reaper would reap
it.  So, this patch makes the check for free object exisistence not to
hold a lock.  This will reduce lock contention in heavily allocation case.

Note that until now, n->shared can be freed during the processing by
writing slabinfo, but, with some trick in this patch, we can access it
freely within interrupt disabled period.

Below is the result of concurrent allocation/free in slab allocation
benchmark made by Christoph a long time ago.  I make the output simpler. 
The number shows cycle count during alloc/free respectively so less is
better.

* Before
Kmalloc N*alloc N*free(32): Average=248/966
Kmalloc N*alloc N*free(64): Average=261/949
Kmalloc N*alloc N*free(128): Average=314/1016
Kmalloc N*alloc N*free(256): Average=741/1061
Kmalloc N*alloc N*free(512): Average=1246/1152
Kmalloc N*alloc N*free(1024): Average=2437/1259
Kmalloc N*alloc N*free(2048): Average=4980/1800
Kmalloc N*alloc N*free(4096): Average=9000/2078

* After
Kmalloc N*alloc N*free(32): Average=344/792
Kmalloc N*alloc N*free(64): Average=347/882
Kmalloc N*alloc N*free(128): Average=390/959
Kmalloc N*alloc N*free(256): Average=393/1067
Kmalloc N*alloc N*free(512): Average=683/1229
Kmalloc N*alloc N*free(1024): Average=1295/1325
Kmalloc N*alloc N*free(2048): Average=2513/1664
Kmalloc N*alloc N*free(4096): Average=4742/2172

It shows that allocation performance decreases for the object size up to
128 and it may be due to extra checks in cache_alloc_refill().  But, with
considering improvement of free performance, net result looks the same. 
Result for other size class looks very promising, roughly, 50% performance
improvement.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff -puN mm/slab.c~mm-slab-lockless-decision-to-grow-cache mm/slab.c
--- a/mm/slab.c~mm-slab-lockless-decision-to-grow-cache
+++ a/mm/slab.c
@@ -958,6 +958,15 @@ static int setup_kmem_cache_node(struct
 	spin_unlock_irq(&n->list_lock);
 	slabs_destroy(cachep, &list);
 
+	/*
+	 * To protect lockless access to n->shared during irq disabled context.
+	 * If n->shared isn't NULL in irq disabled context, accessing to it is
+	 * guaranteed to be valid until irq is re-enabled, because it will be
+	 * freed after kick_all_cpus_sync().
+	 */
+	if (force_change)
+		kick_all_cpus_sync();
+
 fail:
 	kfree(old_shared);
 	kfree(new_shared);
@@ -2862,7 +2871,7 @@ static void *cache_alloc_refill(struct k
 {
 	int batchcount;
 	struct kmem_cache_node *n;
-	struct array_cache *ac;
+	struct array_cache *ac, *shared;
 	int node;
 	void *list = NULL;
 	struct page *page;
@@ -2883,11 +2892,16 @@ static void *cache_alloc_refill(struct k
 	n = get_node(cachep, node);
 
 	BUG_ON(ac->avail > 0 || !n);
+	shared = READ_ONCE(n->shared);
+	if (!n->free_objects && (!shared || !shared->avail))
+		goto direct_grow;
+
 	spin_lock(&n->list_lock);
+	shared = READ_ONCE(n->shared);
 
 	/* See if we can refill from the shared array */
-	if (n->shared && transfer_objects(ac, n->shared, batchcount)) {
-		n->shared->touched = 1;
+	if (shared && transfer_objects(ac, shared, batchcount)) {
+		shared->touched = 1;
 		goto alloc_done;
 	}
 
@@ -2909,6 +2923,7 @@ alloc_done:
 	spin_unlock(&n->list_lock);
 	fixup_objfreelist_debug(cachep, &list);
 
+direct_grow:
 	if (unlikely(!ac->avail)) {
 		/* Check if we can use obj in pfmemalloc slab */
 		if (sk_memalloc_socks()) {
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount.patch
mm-slab-hold-a-slab_mutex-when-calling-__kmem_cache_shrink.patch
mm-slab-remove-bad_alien_magic-again.patch
mm-slab-drain-the-free-slab-as-much-as-possible.patch
mm-slab-factor-out-kmem_cache_node-initialization-code.patch
mm-slab-clean-up-kmem_cache_node-setup.patch
mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit.patch
mm-slab-racy-access-modify-the-slab-color.patch
mm-slab-make-cache_grow-handle-the-page-allocated-on-arbitrary-node.patch
mm-slab-separate-cache_grow-to-two-parts.patch
mm-slab-refill-cpu-cache-through-a-new-slab-without-holding-a-node-lock.patch
mm-slab-lockless-decision-to-grow-cache.patch


From: akpm@linux-foundation.org
Subject: + mm-slab-fix-the-theoretical-race-by-holding-proper-lock.patch
 added to -mm tree
Date: Fri, 22 Apr 2016 15:01:53 -0700
Message-ID: <571a9f51.giqQ6aEFOOjVPat/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbcDVWBz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 18:01:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: fix the theoretical race by holding proper lock
has been added to the -mm tree.  Its filename is
     mm-slab-fix-the-theoretical-race-by-holding-proper-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-fix-the-theoretical-race-by-holding-proper-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-fix-the-theoretical-race-by-holding-proper-lock.patch

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
Subject: mm/slab: fix the theoretical race by holding proper lock

While processing concurrent allocation, SLAB could be contended a lot
because it did a lots of work with holding a lock.  This patchset try to
reduce the number of critical section to reduce lock contention.  Major
changes are lockless decision to allocate more slab and lockless cpu cache
refill from the newly allocated slab.

Below is the result of concurrent allocation/free in slab allocation
benchmark made by Christoph a long time ago.  I make the output simpler. 
The number shows cycle count during alloc/free respectively so less is
better.

* Before
Kmalloc N*alloc N*free(32): Average=365/806
Kmalloc N*alloc N*free(64): Average=452/690
Kmalloc N*alloc N*free(128): Average=736/886
Kmalloc N*alloc N*free(256): Average=1167/985
Kmalloc N*alloc N*free(512): Average=2088/1125
Kmalloc N*alloc N*free(1024): Average=4115/1184
Kmalloc N*alloc N*free(2048): Average=8451/1748
Kmalloc N*alloc N*free(4096): Average=16024/2048

* After
Kmalloc N*alloc N*free(32): Average=344/792
Kmalloc N*alloc N*free(64): Average=347/882
Kmalloc N*alloc N*free(128): Average=390/959
Kmalloc N*alloc N*free(256): Average=393/1067
Kmalloc N*alloc N*free(512): Average=683/1229
Kmalloc N*alloc N*free(1024): Average=1295/1325
Kmalloc N*alloc N*free(2048): Average=2513/1664
Kmalloc N*alloc N*free(4096): Average=4742/2172

It shows that performance improves greatly (roughly more than 50%) for the
object class whose size is more than 128 bytes.

This patch (of 11):

If we don't hold neither the slab_mutex nor the node lock, node's shared
array cache could be freed and re-populated.  If __kmem_cache_shrink() is
called at the same time, it will call drain_array() with n->shared without
holding node lock so problem can happen.  This patch fix the situation by
holding the node lock before trying to drain the shared array.

In addition, add a debug check to confirm that n->shared access race
doesn't exist.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   68 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 23 deletions(-)

diff -puN mm/slab.c~mm-slab-fix-the-theoretical-race-by-holding-proper-lock mm/slab.c
--- a/mm/slab.c~mm-slab-fix-the-theoretical-race-by-holding-proper-lock
+++ a/mm/slab.c
@@ -2180,6 +2180,11 @@ static void check_irq_on(void)
 	BUG_ON(irqs_disabled());
 }
 
+static void check_mutex_acquired(void)
+{
+	BUG_ON(!mutex_is_locked(&slab_mutex));
+}
+
 static void check_spinlock_acquired(struct kmem_cache *cachep)
 {
 #ifdef CONFIG_SMP
@@ -2199,13 +2204,27 @@ static void check_spinlock_acquired_node
 #else
 #define check_irq_off()	do { } while(0)
 #define check_irq_on()	do { } while(0)
+#define check_mutex_acquired()	do { } while(0)
 #define check_spinlock_acquired(x) do { } while(0)
 #define check_spinlock_acquired_node(x, y) do { } while(0)
 #endif
 
-static void drain_array(struct kmem_cache *cachep, struct kmem_cache_node *n,
-			struct array_cache *ac,
-			int force, int node);
+static void drain_array_locked(struct kmem_cache *cachep, struct array_cache *ac,
+				int node, bool free_all, struct list_head *list)
+{
+	int tofree;
+
+	if (!ac || !ac->avail)
+		return;
+
+	tofree = free_all ? ac->avail : (ac->limit + 4) / 5;
+	if (tofree > ac->avail)
+		tofree = (ac->avail + 1) / 2;
+
+	free_block(cachep, ac->entry, tofree, node, list);
+	ac->avail -= tofree;
+	memmove(ac->entry, &(ac->entry[tofree]), sizeof(void *) * ac->avail);
+}
 
 static void do_drain(void *arg)
 {
@@ -2229,6 +2248,7 @@ static void drain_cpu_caches(struct kmem
 {
 	struct kmem_cache_node *n;
 	int node;
+	LIST_HEAD(list);
 
 	on_each_cpu(do_drain, cachep, 1);
 	check_irq_on();
@@ -2236,8 +2256,13 @@ static void drain_cpu_caches(struct kmem
 		if (n->alien)
 			drain_alien_cache(cachep, n->alien);
 
-	for_each_kmem_cache_node(cachep, node, n)
-		drain_array(cachep, n, n->shared, 1, node);
+	for_each_kmem_cache_node(cachep, node, n) {
+		spin_lock_irq(&n->list_lock);
+		drain_array_locked(cachep, n->shared, node, true, &list);
+		spin_unlock_irq(&n->list_lock);
+
+		slabs_destroy(cachep, &list);
+	}
 }
 
 /*
@@ -3869,29 +3894,26 @@ skip_setup:
  * if drain_array() is used on the shared array.
  */
 static void drain_array(struct kmem_cache *cachep, struct kmem_cache_node *n,
-			 struct array_cache *ac, int force, int node)
+			 struct array_cache *ac, int node)
 {
 	LIST_HEAD(list);
-	int tofree;
+
+	/* ac from n->shared can be freed if we don't hold the slab_mutex. */
+	check_mutex_acquired();
 
 	if (!ac || !ac->avail)
 		return;
-	if (ac->touched && !force) {
+
+	if (ac->touched) {
 		ac->touched = 0;
-	} else {
-		spin_lock_irq(&n->list_lock);
-		if (ac->avail) {
-			tofree = force ? ac->avail : (ac->limit + 4) / 5;
-			if (tofree > ac->avail)
-				tofree = (ac->avail + 1) / 2;
-			free_block(cachep, ac->entry, tofree, node, &list);
-			ac->avail -= tofree;
-			memmove(ac->entry, &(ac->entry[tofree]),
-				sizeof(void *) * ac->avail);
-		}
-		spin_unlock_irq(&n->list_lock);
-		slabs_destroy(cachep, &list);
+		return;
 	}
+
+	spin_lock_irq(&n->list_lock);
+	drain_array_locked(cachep, ac, node, false, &list);
+	spin_unlock_irq(&n->list_lock);
+
+	slabs_destroy(cachep, &list);
 }
 
 /**
@@ -3929,7 +3951,7 @@ static void cache_reap(struct work_struc
 
 		reap_alien(searchp, n);
 
-		drain_array(searchp, n, cpu_cache_get(searchp), 0, node);
+		drain_array(searchp, n, cpu_cache_get(searchp), node);
 
 		/*
 		 * These are racy checks but it does not matter
@@ -3940,7 +3962,7 @@ static void cache_reap(struct work_struc
 
 		n->next_reap = jiffies + REAPTIMEOUT_NODE;
 
-		drain_array(searchp, n, n->shared, 0, node);
+		drain_array(searchp, n, n->shared, node);
 
 		if (n->free_touched)
 			n->free_touched = 0;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-fix-the-theoretical-race-by-holding-proper-lock.patch
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
mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix-fix.patch
mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic.patch
mm-memory_hotplug-add-comment-to-some-functions-related-to-memory-hotplug.patch
mm-vmstat-add-zone-range-overlapping-check.patch
mm-page_owner-add-zone-range-overlapping-check.patch
power-add-zone-range-overlapping-check.patch
mm-writeback-correct-dirty-page-calculation-for-highmem.patch
mm-page_alloc-correct-highmem-memory-statistics.patch
mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself.patch
mm-vmstat-make-node_page_state-handles-all-zones-by-itself.patch


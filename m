From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-slab-hold-a-slab_mutex-when-calling-__kmem_cache_shrink.patch removed
 from -mm tree
Date: Fri, 22 Apr 2016 14:56:04 -0700
Message-ID: <571a9df4.ZNt2wn7MPv1d1gyd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbcDVV4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 17:56:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: hold a slab_mutex when calling __kmem_cache_shrink()
has been removed from the -mm tree.  Its filename was
     mm-slab-hold-a-slab_mutex-when-calling-__kmem_cache_shrink.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: hold a slab_mutex when calling __kmem_cache_shrink()

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

Major kmem_cache metadata in slab subsystem is synchronized with the
slab_mutex.  In SLAB, if some of them is changed, node's shared array
cache would be freed and re-populated.  If __kmem_cache_shrink() is called
at the same time, it will call drain_array() with n->shared without
holding node lock so problem can happen.

We can fix this small theoretical race condition by holding node lock in
drain_array(), but, holding a slab_mutex in kmem_cache_shrink() looks more
appropriate solution because stable state would make things less
error-prone and this is not performance critical path.

In addtion, annotate on SLAB functions.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    2 ++
 mm/slab_common.c |    2 ++
 2 files changed, 4 insertions(+)

diff -puN mm/slab.c~mm-slab-hold-a-slab_mutex-when-calling-__kmem_cache_shrink mm/slab.c
--- a/mm/slab.c~mm-slab-hold-a-slab_mutex-when-calling-__kmem_cache_shrink
+++ a/mm/slab.c
@@ -2225,6 +2225,7 @@ static void do_drain(void *arg)
 	ac->avail = 0;
 }
 
+/* Should be called with slab_mutex to prevent from freeing shared array */
 static void drain_cpu_caches(struct kmem_cache *cachep)
 {
 	struct kmem_cache_node *n;
@@ -3867,6 +3868,7 @@ skip_setup:
  * Drain an array if it contains any elements taking the node lock only if
  * necessary. Note that the node listlock also protects the array_cache
  * if drain_array() is used on the shared array.
+ * Should be called with slab_mutex to prevent from freeing shared array.
  */
 static void drain_array(struct kmem_cache *cachep, struct kmem_cache_node *n,
 			 struct array_cache *ac, int force, int node)
diff -puN mm/slab_common.c~mm-slab-hold-a-slab_mutex-when-calling-__kmem_cache_shrink mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-hold-a-slab_mutex-when-calling-__kmem_cache_shrink
+++ a/mm/slab_common.c
@@ -753,7 +753,9 @@ int kmem_cache_shrink(struct kmem_cache
 
 	get_online_cpus();
 	get_online_mems();
+	mutex_lock(&slab_mutex);
 	ret = __kmem_cache_shrink(cachep, false);
+	mutex_unlock(&slab_mutex);
 	put_online_mems();
 	put_online_cpus();
 	return ret;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-remove-bad_alien_magic-again.patch
mm-slab-drain-the-free-slab-as-much-as-possible.patch
mm-slab-factor-out-kmem_cache_node-initialization-code.patch
mm-slab-clean-up-kmem_cache_node-setup.patch
mm-slab-clean-up-kmem_cache_node-setup-fix.patch
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


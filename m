From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-slab-remove-bad_alien_magic-again.patch
 removed from -mm tree
Date: Fri, 22 Apr 2016 14:56:07 -0700
Message-ID: <571a9df7.qS0TNhVH2lvWAheG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbcDVV4I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 17:56:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, geert@linux-m68k.org, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: remove BAD_ALIEN_MAGIC again
has been removed from the -mm tree.  Its filename was
     mm-slab-remove-bad_alien_magic-again.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: remove BAD_ALIEN_MAGIC again

Initial attemp to remove BAD_ALIEN_MAGIC is once reverted by 'commit
edcad2509550 ("Revert "slab: remove BAD_ALIEN_MAGIC"")' because it causes
a problem on m68k which has many node but !CONFIG_NUMA.  In this case,
although alien cache isn't used at all but to cope with some
initialization path, garbage value is used and that is BAD_ALIEN_MAGIC. 
Now, this patch set use_alien_caches to 0 when !CONFIG_NUMA, there is no
initialization path problem so we don't need BAD_ALIEN_MAGIC at all.  So
remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~mm-slab-remove-bad_alien_magic-again mm/slab.c
--- a/mm/slab.c~mm-slab-remove-bad_alien_magic-again
+++ a/mm/slab.c
@@ -421,8 +421,6 @@ static struct kmem_cache kmem_cache_boot
 	.name = "kmem_cache",
 };
 
-#define BAD_ALIEN_MAGIC 0x01020304ul
-
 static DEFINE_PER_CPU(struct delayed_work, slab_reap_work);
 
 static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
@@ -644,7 +642,7 @@ static int transfer_objects(struct array
 static inline struct alien_cache **alloc_alien_cache(int node,
 						int limit, gfp_t gfp)
 {
-	return (struct alien_cache **)BAD_ALIEN_MAGIC;
+	return NULL;
 }
 
 static inline void free_alien_cache(struct alien_cache **ac_ptr)
@@ -1212,7 +1210,7 @@ void __init kmem_cache_init(void)
 					sizeof(struct rcu_head));
 	kmem_cache = &kmem_cache_boot;
 
-	if (num_possible_nodes() == 1)
+	if (!IS_ENABLED(CONFIG_NUMA) || num_possible_nodes() == 1)
 		use_alien_caches = 0;
 
 	for (i = 0; i < NUM_INIT_LISTS; i++)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

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


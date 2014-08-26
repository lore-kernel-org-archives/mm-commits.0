From: akpm@linux-foundation.org
Subject: + mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch
 added to -mm tree
Date: Tue, 26 Aug 2014 16:17:13 -0700
Message-ID: <53fd1579.opfch0DA+bbWJOqr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:63655 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbaHZXRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:17:15 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so1789829ieb.2
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:17:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: factor out unlikely part of cache_free_alien()
has been added to the -mm tree.  Its filename is
     mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch

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
Subject: mm/slab: factor out unlikely part of cache_free_alien()

cache_free_alien() is rarely used function when node mismatch.  But, it is
defined with inline attribute so it is inlined to __cache_free() which is
core free function of slab allocator.  It uselessly makes
kmem_cache_free()/kfree() functions large.  What we really need to inline
is just checking node match so this patch factor out other parts of
cache_free_alien() to reduce code size of kmem_cache_free()/ kfree().

<Before>
nm -S mm/slab.o | grep -e "T kfree" -e "T kmem_cache_free"
00000000000011e0 0000000000000228 T kfree
0000000000000670 0000000000000216 T kmem_cache_free

<After>
nm -S mm/slab.o | grep -e "T kfree" -e "T kmem_cache_free"
0000000000001110 00000000000001b5 T kfree
0000000000000750 0000000000000181 T kmem_cache_free

You can see slightly reduced size of text: 0x228->0x1b5, 0x216->0x181.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff -puN mm/slab.c~mm-slab-factor-out-unlikely-part-of-cache_free_alien mm/slab.c
--- a/mm/slab.c~mm-slab-factor-out-unlikely-part-of-cache_free_alien
+++ a/mm/slab.c
@@ -984,46 +984,50 @@ static void drain_alien_cache(struct kme
 	}
 }
 
-static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
+static int __cache_free_alien(struct kmem_cache *cachep, void *objp,
+				int node, int page_node)
 {
-	int nodeid = page_to_nid(virt_to_page(objp));
 	struct kmem_cache_node *n;
 	struct alien_cache *alien = NULL;
 	struct array_cache *ac;
-	int node;
 	LIST_HEAD(list);
 
-	node = numa_mem_id();
-
-	/*
-	 * Make sure we are not freeing a object from another node to the array
-	 * cache on this cpu.
-	 */
-	if (likely(nodeid == node))
-		return 0;
-
 	n = get_node(cachep, node);
 	STATS_INC_NODEFREES(cachep);
-	if (n->alien && n->alien[nodeid]) {
-		alien = n->alien[nodeid];
+	if (n->alien && n->alien[page_node]) {
+		alien = n->alien[page_node];
 		ac = &alien->ac;
 		spin_lock(&alien->lock);
 		if (unlikely(ac->avail == ac->limit)) {
 			STATS_INC_ACOVERFLOW(cachep);
-			__drain_alien_cache(cachep, ac, nodeid, &list);
+			__drain_alien_cache(cachep, ac, page_node, &list);
 		}
 		ac_put_obj(cachep, ac, objp);
 		spin_unlock(&alien->lock);
 		slabs_destroy(cachep, &list);
 	} else {
-		n = get_node(cachep, nodeid);
+		n = get_node(cachep, page_node);
 		spin_lock(&n->list_lock);
-		free_block(cachep, &objp, 1, nodeid, &list);
+		free_block(cachep, &objp, 1, page_node, &list);
 		spin_unlock(&n->list_lock);
 		slabs_destroy(cachep, &list);
 	}
 	return 1;
 }
+
+static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
+{
+	int page_node = page_to_nid(virt_to_page(objp));
+	int node = numa_mem_id();
+	/*
+	 * Make sure we are not freeing a object from another node to the array
+	 * cache on this cpu.
+	 */
+	if (likely(node == page_node))
+		return 0;
+
+	return __cache_free_alien(cachep, objp, node, page_node);
+}
 #endif
 
 /*
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab_commonc-suppress-warning.patch
mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch
mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch
mm-slab-noinline-__ac_put_obj.patch
mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-report-maximum-used-memory.patch
page-owners-correct-page-order-when-to-free-page.patch


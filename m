From: akpm@linux-foundation.org
Subject: + mm-remove-gfp_thisnode.patch added to -mm tree
Date: Mon, 02 Mar 2015 14:58:25 -0800
Message-ID: <54f4eb11.POIr+V0FRf8rMhW7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbbCBW61 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 17:58:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, jrajahalme@nicira.com, lizefan@huawei.com, mgorman@suse.de, penberg@kernel.org, pshelar@nicira.com, tj@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove GFP_THISNODE
has been added to the -mm tree.  Its filename is
     mm-remove-gfp_thisnode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-gfp_thisnode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-gfp_thisnode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm: remove GFP_THISNODE

NOTE: this is not about __GFP_THISNODE, this is only about GFP_THISNODE.

GFP_THISNODE is a secret combination of gfp bits that have different
behavior than expected.  It is a combination of __GFP_THISNODE,
__GFP_NORETRY, and __GFP_NOWARN and is special-cased in the page allocator
slowpath to fail without trying reclaim even though it may be used in
combination with __GFP_WAIT.

An example of the problem this creates: commit e97ca8e5b864 ("mm: fix
GFP_THISNODE callers and clarify") fixed up many users of GFP_THISNODE
that really just wanted __GFP_THISNODE.  The problem doesn't end there,
however, because even it was a no-op for alloc_misplaced_dst_page(), which
also sets __GFP_NORETRY and __GFP_NOWARN, and
migrate_misplaced_transhuge_page(), where __GFP_NORETRY and __GFP_NOWAIT
is set in GFP_TRANSHUGE.  Converting GFP_THISNODE to __GFP_THISNODE is a
no-op in these cases since the page allocator special-cases __GFP_THISNODE
&& __GFP_NORETRY && __GFP_NOWARN.

It's time to just remove GFP_THISNODE entirely.  We leave __GFP_THISNODE
to restrict an allocation to a local node, but remove GFP_THISNODE and its
obscurity.  Instead, we require that a caller clear __GFP_WAIT if it wants
to avoid reclaim.

This allows the aforementioned functions to actually reclaim as they
should.  It also enables any future callers that want to do __GFP_THISNODE
but also __GFP_NORETRY && __GFP_NOWARN to reclaim.  The rule is simple: if
you don't want to reclaim, then don't set __GFP_WAIT.

Aside: ovs_flow_stats_update() really wants to avoid reclaim as well, so
it is unchanged.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pravin Shelar <pshelar@nicira.com>
Cc: Jarno Rajahalme <jrajahalme@nicira.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |   10 ----------
 mm/page_alloc.c        |   22 ++++++----------------
 mm/slab.c              |   22 ++++++++++++++++++----
 net/openvswitch/flow.c |    4 +++-
 4 files changed, 27 insertions(+), 31 deletions(-)

diff -puN include/linux/gfp.h~mm-remove-gfp_thisnode include/linux/gfp.h
--- a/include/linux/gfp.h~mm-remove-gfp_thisnode
+++ a/include/linux/gfp.h
@@ -117,16 +117,6 @@ struct vm_area_struct;
 			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | \
 			 __GFP_NO_KSWAPD)
 
-/*
- * GFP_THISNODE does not perform any reclaim, you most likely want to
- * use __GFP_THISNODE to allocate from a given node without fallback!
- */
-#ifdef CONFIG_NUMA
-#define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
-#else
-#define GFP_THISNODE	((__force gfp_t)0)
-#endif
-
 /* This mask makes up all the page movable related flags */
 #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
 
diff -puN mm/page_alloc.c~mm-remove-gfp_thisnode mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-gfp_thisnode
+++ a/mm/page_alloc.c
@@ -2412,13 +2412,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 			*did_some_progress = 1;
 			goto out;
 		}
-		/*
-		 * GFP_THISNODE contains __GFP_NORETRY and we never hit this.
-		 * Sanity check for bare calls of __GFP_THISNODE, not real OOM.
-		 * The caller should handle page allocation failure by itself if
-		 * it specifies __GFP_THISNODE.
-		 * Note: Hugepage uses it but will hit PAGE_ALLOC_COSTLY_ORDER.
-		 */
++		/* The OOM killer may not free memory on a specific node */
 		if (gfp_mask & __GFP_THISNODE)
 			goto out;
 	}
@@ -2673,15 +2667,11 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	}
 
 	/*
-	 * GFP_THISNODE (meaning __GFP_THISNODE, __GFP_NORETRY and
-	 * __GFP_NOWARN set) should not cause reclaim since the subsystem
-	 * (f.e. slab) using GFP_THISNODE may choose to trigger reclaim
-	 * using a larger set of nodes after it has established that the
-	 * allowed per node queues are empty and that nodes are
-	 * over allocated.
+	 * If this allocation cannot block and it is for a specific node, then
+	 * fail early.  There's no need to wakeup kswapd or retry for a
+	 * speculative node-specific allocation.
 	 */
-	if (IS_ENABLED(CONFIG_NUMA) &&
-	    (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
+	if (IS_ENABLED(CONFIG_NUMA) && (gfp_mask & __GFP_THISNODE) && !wait)
 		goto nopage;
 
 retry:
@@ -2874,7 +2864,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	/*
 	 * Check the zones suitable for the gfp_mask contain at least one
 	 * valid zone. It's possible to have an empty zonelist as a result
-	 * of GFP_THISNODE and a memoryless node
+	 * of __GFP_THISNODE and a memoryless node
 	 */
 	if (unlikely(!zonelist->_zonerefs->zone))
 		return NULL;
diff -puN mm/slab.c~mm-remove-gfp_thisnode mm/slab.c
--- a/mm/slab.c~mm-remove-gfp_thisnode
+++ a/mm/slab.c
@@ -857,6 +857,11 @@ static inline void *____cache_alloc_node
 	return NULL;
 }
 
+static inline gfp_t gfp_exact_node(gfp_t flags)
+{
+	return flags;
+}
+
 #else	/* CONFIG_NUMA */
 
 static void *____cache_alloc_node(struct kmem_cache *, gfp_t, int);
@@ -1023,6 +1028,15 @@ static inline int cache_free_alien(struc
 
 	return __cache_free_alien(cachep, objp, node, page_node);
 }
+
+/*
+ * Construct gfp mask to allocate from a specific node but do not invoke reclaim
+ * or warn about failures.
+ */
+static inline gfp_t gfp_exact_node(gfp_t flags)
+{
+	return (flags | __GFP_THISNODE | __GFP_NOWARN) & ~__GFP_WAIT;
+}
 #endif
 
 /*
@@ -2825,7 +2839,7 @@ alloc_done:
 	if (unlikely(!ac->avail)) {
 		int x;
 force_grow:
-		x = cache_grow(cachep, flags | GFP_THISNODE, node, NULL);
+		x = cache_grow(cachep, gfp_exact_node(flags), node, NULL);
 
 		/* cache_grow can reenable interrupts, then ac could change. */
 		ac = cpu_cache_get(cachep);
@@ -3019,7 +3033,7 @@ retry:
 			get_node(cache, nid) &&
 			get_node(cache, nid)->free_objects) {
 				obj = ____cache_alloc_node(cache,
-					flags | GFP_THISNODE, nid);
+					gfp_exact_node(flags), nid);
 				if (obj)
 					break;
 		}
@@ -3047,7 +3061,7 @@ retry:
 			nid = page_to_nid(page);
 			if (cache_grow(cache, flags, nid, page)) {
 				obj = ____cache_alloc_node(cache,
-					flags | GFP_THISNODE, nid);
+					gfp_exact_node(flags), nid);
 				if (!obj)
 					/*
 					 * Another processor may allocate the
@@ -3118,7 +3132,7 @@ retry:
 
 must_grow:
 	spin_unlock(&n->list_lock);
-	x = cache_grow(cachep, flags | GFP_THISNODE, nodeid, NULL);
+	x = cache_grow(cachep, gfp_exact_node(flags), nodeid, NULL);
 	if (x)
 		goto retry;
 
diff -puN net/openvswitch/flow.c~mm-remove-gfp_thisnode net/openvswitch/flow.c
--- a/net/openvswitch/flow.c~mm-remove-gfp_thisnode
+++ a/net/openvswitch/flow.c
@@ -100,7 +100,9 @@ void ovs_flow_stats_update(struct sw_flo
 
 				new_stats =
 					kmem_cache_alloc_node(flow_stats_cache,
-							      GFP_THISNODE |
+							      GFP_NOWAIT |
+							      __GFP_THISNODE |
+							      __GFP_NOWARN |
 							      __GFP_NOMEMALLOC,
 							      node);
 				if (likely(new_stats)) {
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages.patch
mm-slub-parse-slub_debug-o-option-in-switch-statement.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-remove-gfp_thisnode.patch
mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
mm-utilc-add-kstrimdup.patch


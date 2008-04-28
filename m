From: akpm@linux-foundation.org
Subject: - mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:57 -0700
Message-ID: <200804282150.m3SLoves017533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964862AbYD1Vvq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:51:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, clameter@sgi.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: introduce node_zonelist() for accessing the zonelist for a GFP mask
has been removed from the -mm tree.  Its filename was
     mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: introduce node_zonelist() for accessing the zonelist for a GFP mask
From: Mel Gorman <mel@csn.ul.ie>

Introduce a node_zonelist() helper function.  It is used to lookup the
appropriate zonelist given a node and a GFP mask.  The patch on its own is a
cleanup but it helps clarify parts of the two-zonelist-per-node patchset.  If
necessary, it can be merged with the next patch in this set without problems.

Reviewed-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c      |    3 +--
 fs/buffer.c               |    6 +++---
 include/linux/gfp.h       |    8 ++++++--
 include/linux/mempolicy.h |    2 +-
 mm/mempolicy.c            |    6 +++---
 mm/page_alloc.c           |    3 +--
 mm/slab.c                 |    3 +--
 mm/slub.c                 |    3 +--
 8 files changed, 17 insertions(+), 17 deletions(-)

diff -puN drivers/char/sysrq.c~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask
+++ a/drivers/char/sysrq.c
@@ -271,8 +271,7 @@ static struct sysrq_key_op sysrq_term_op
 
 static void moom_callback(struct work_struct *ignored)
 {
-	out_of_memory(&NODE_DATA(0)->node_zonelists[ZONE_NORMAL],
-			GFP_KERNEL, 0);
+	out_of_memory(node_zonelist(0, GFP_KERNEL), GFP_KERNEL, 0);
 }
 
 static DECLARE_WORK(moom_work, moom_callback);
diff -puN fs/buffer.c~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask fs/buffer.c
--- a/fs/buffer.c~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask
+++ a/fs/buffer.c
@@ -361,13 +361,13 @@ void invalidate_bdev(struct block_device
 static void free_more_memory(void)
 {
 	struct zonelist *zonelist;
-	pg_data_t *pgdat;
+	int nid;
 
 	wakeup_pdflush(1024);
 	yield();
 
-	for_each_online_pgdat(pgdat) {
-		zonelist = &pgdat->node_zonelists[gfp_zone(GFP_NOFS)];
+	for_each_online_node(nid) {
+		zonelist = node_zonelist(nid, GFP_NOFS);
 		if (zonelist->zones[0])
 			try_to_free_pages(zonelist, 0, GFP_NOFS);
 	}
diff -puN include/linux/gfp.h~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask include/linux/gfp.h
--- a/include/linux/gfp.h~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask
+++ a/include/linux/gfp.h
@@ -154,10 +154,15 @@ static inline enum zone_type gfp_zone(gf
 /*
  * We get the zone list from the current node and the gfp_mask.
  * This zone list contains a maximum of MAXNODES*MAX_NR_ZONES zones.
+ * There are many zonelists per node, two for each active zone.
  *
  * For the normal case of non-DISCONTIGMEM systems the NODE_DATA() gets
  * optimized to &contig_page_data at compile-time.
  */
+static inline struct zonelist *node_zonelist(int nid, gfp_t flags)
+{
+	return NODE_DATA(nid)->node_zonelists + gfp_zone(flags);
+}
 
 #ifndef HAVE_ARCH_FREE_PAGE
 static inline void arch_free_page(struct page *page, int order) { }
@@ -178,8 +183,7 @@ static inline struct page *alloc_pages_n
 	if (nid < 0)
 		nid = numa_node_id();
 
-	return __alloc_pages(gfp_mask, order,
-		NODE_DATA(nid)->node_zonelists + gfp_zone(gfp_mask));
+	return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
 }
 
 #ifdef CONFIG_NUMA
diff -puN include/linux/mempolicy.h~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask
+++ a/include/linux/mempolicy.h
@@ -241,7 +241,7 @@ static inline void mpol_fix_fork_child_f
 static inline struct zonelist *huge_zonelist(struct vm_area_struct *vma,
  		unsigned long addr, gfp_t gfp_flags, struct mempolicy **mpol)
 {
-	return NODE_DATA(0)->node_zonelists + gfp_zone(gfp_flags);
+	return node_zonelist(0, gfp_flags);
 }
 
 static inline int do_migrate_pages(struct mm_struct *mm,
diff -puN mm/mempolicy.c~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask mm/mempolicy.c
--- a/mm/mempolicy.c~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask
+++ a/mm/mempolicy.c
@@ -1183,7 +1183,7 @@ static struct zonelist *zonelist_policy(
 		nd = 0;
 		BUG();
 	}
-	return NODE_DATA(nd)->node_zonelists + gfp_zone(gfp);
+	return node_zonelist(nd, gfp);
 }
 
 /* Do dynamic interleaving for a process */
@@ -1299,7 +1299,7 @@ struct zonelist *huge_zonelist(struct vm
 		if (unlikely(pol != &default_policy &&
 				pol != current->mempolicy))
 			__mpol_free(pol);	/* finished with pol */
-		return NODE_DATA(nid)->node_zonelists + gfp_zone(gfp_flags);
+		return node_zonelist(nid, gfp_flags);
 	}
 
 	zl = zonelist_policy(GFP_HIGHUSER, pol);
@@ -1321,7 +1321,7 @@ static struct page *alloc_page_interleav
 	struct zonelist *zl;
 	struct page *page;
 
-	zl = NODE_DATA(nid)->node_zonelists + gfp_zone(gfp);
+	zl = node_zonelist(nid, gfp);
 	page = __alloc_pages(gfp, order, zl);
 	if (page && page_zone(page) == zl->zones[0])
 		inc_zone_page_state(page, NUMA_INTERLEAVE_HIT);
diff -puN mm/page_alloc.c~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask
+++ a/mm/page_alloc.c
@@ -1713,10 +1713,9 @@ EXPORT_SYMBOL(free_pages);
 static unsigned int nr_free_zone_pages(int offset)
 {
 	/* Just pick one node, since fallback list is circular */
-	pg_data_t *pgdat = NODE_DATA(numa_node_id());
 	unsigned int sum = 0;
 
-	struct zonelist *zonelist = pgdat->node_zonelists + offset;
+	struct zonelist *zonelist = node_zonelist(numa_node_id(), GFP_KERNEL);
 	struct zone **zonep = zonelist->zones;
 	struct zone *zone;
 
diff -puN mm/slab.c~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask mm/slab.c
--- a/mm/slab.c~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask
+++ a/mm/slab.c
@@ -3249,8 +3249,7 @@ static void *fallback_alloc(struct kmem_
 	if (flags & __GFP_THISNODE)
 		return NULL;
 
-	zonelist = &NODE_DATA(slab_node(current->mempolicy))
-			->node_zonelists[gfp_zone(flags)];
+	zonelist = node_zonelist(slab_node(current->mempolicy), flags);
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 
 retry:
diff -puN mm/slub.c~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask mm/slub.c
--- a/mm/slub.c~mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask
+++ a/mm/slub.c
@@ -1309,8 +1309,7 @@ static struct page *get_any_partial(stru
 			get_cycles() % 1024 > s->remote_node_defrag_ratio)
 		return NULL;
 
-	zonelist = &NODE_DATA(
-		slab_node(current->mempolicy))->node_zonelists[gfp_zone(flags)];
+	zonelist = node_zonelist(slab_node(current->mempolicy), flags);
 	for (z = zonelist->zones; *z; z++) {
 		struct kmem_cache_node *n;
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-fix-usemap-initialization.patch
mm-fix-misleading-__gfp_repeat-related-comments.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch


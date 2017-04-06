From: akpm@linux-foundation.org
Subject: + mm-introduce-memalloc_noreclaim_saverestore.patch added to -mm
 tree
Date: Thu, 06 Apr 2017 16:22:03 -0700
Message-ID: <58e6cd9b.woefvqPpxezbXXvp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51412 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755303AbdDFXWF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2017 19:22:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aryabinin@virtuozzo.com, boris.brezillon@free-electrons.com, cleech@redhat.com, davem@davemloft.net, edumazet@google.com, hannes@cmpxchg.org, jbacik@fb.com, lduncan@suse.com, mgorman@techsingularity.net, mhocko@suse.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce memalloc_noreclaim_{save,restore}
has been added to the -mm tree.  Its filename is
     mm-introduce-memalloc_noreclaim_saverestore.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-memalloc_noreclaim_saverestore.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-memalloc_noreclaim_saverestore.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: introduce memalloc_noreclaim_{save,restore}

The previous patch ("mm: prevent potential recursive reclaim due to
clearing PF_MEMALLOC") has shown that simply setting and clearing
PF_MEMALLOC in current->flags can result in wrongly clearing a
pre-existing PF_MEMALLOC flag and potentially lead to recursive reclaim. 
Let's introduce helpers that support proper nesting by saving the previous
stat of the flag, similar to the existing memalloc_noio_* and
memalloc_nofs_* helpers.  Convert existing setting/clearing of PF_MEMALLOC
within mm to the new helpers.

There are no known issues with the converted code, but the change makes it
more robust.

Link: http://lkml.kernel.org/r/20170405074700.29871-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Chris Leech <cleech@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Lee Duncan <lduncan@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |   12 ++++++++++++
 mm/page_alloc.c          |   11 ++++++-----
 mm/vmscan.c              |   17 +++++++++++------
 3 files changed, 29 insertions(+), 11 deletions(-)

diff -puN include/linux/sched/mm.h~mm-introduce-memalloc_noreclaim_saverestore include/linux/sched/mm.h
--- a/include/linux/sched/mm.h~mm-introduce-memalloc_noreclaim_saverestore
+++ a/include/linux/sched/mm.h
@@ -191,4 +191,16 @@ static inline void memalloc_nofs_restore
 	current->flags = (current->flags & ~PF_MEMALLOC_NOFS) | flags;
 }
 
+static inline unsigned int memalloc_noreclaim_save(void)
+{
+	unsigned int flags = current->flags & PF_MEMALLOC;
+	current->flags |= PF_MEMALLOC;
+	return flags;
+}
+
+static inline void memalloc_noreclaim_restore(unsigned int flags)
+{
+	current->flags = (current->flags & ~PF_MEMALLOC) | flags;
+}
+
 #endif /* _LINUX_SCHED_MM_H */
diff -puN mm/page_alloc.c~mm-introduce-memalloc_noreclaim_saverestore mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-memalloc_noreclaim_saverestore
+++ a/mm/page_alloc.c
@@ -3288,15 +3288,15 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		enum compact_priority prio, enum compact_result *compact_result)
 {
 	struct page *page;
-	unsigned int noreclaim_flag = current->flags & PF_MEMALLOC;
+	unsigned int noreclaim_flag;
 
 	if (!order)
 		return NULL;
 
-	current->flags |= PF_MEMALLOC;
+	noreclaim_flag = memalloc_noreclaim_save();
 	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
 									prio);
-	current->flags = (current->flags & ~PF_MEMALLOC) | noreclaim_flag;
+	memalloc_noreclaim_restore(noreclaim_flag);
 
 	if (*compact_result <= COMPACT_INACTIVE)
 		return NULL;
@@ -3443,12 +3443,13 @@ __perform_reclaim(gfp_t gfp_mask, unsign
 {
 	struct reclaim_state reclaim_state;
 	int progress;
+	unsigned int noreclaim_flag;
 
 	cond_resched();
 
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
-	current->flags |= PF_MEMALLOC;
+	noreclaim_flag = memalloc_noreclaim_save();
 	lockdep_set_current_reclaim_state(gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
 	current->reclaim_state = &reclaim_state;
@@ -3458,7 +3459,7 @@ __perform_reclaim(gfp_t gfp_mask, unsign
 
 	current->reclaim_state = NULL;
 	lockdep_clear_current_reclaim_state();
-	current->flags &= ~PF_MEMALLOC;
+	memalloc_noreclaim_restore(noreclaim_flag);
 
 	cond_resched();
 
diff -puN mm/vmscan.c~mm-introduce-memalloc_noreclaim_saverestore mm/vmscan.c
--- a/mm/vmscan.c~mm-introduce-memalloc_noreclaim_saverestore
+++ a/mm/vmscan.c
@@ -3036,6 +3036,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	struct zonelist *zonelist;
 	unsigned long nr_reclaimed;
 	int nid;
+	unsigned int noreclaim_flag;
 	struct scan_control sc = {
 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
 		.gfp_mask = (current_gfp_context(gfp_mask) & GFP_RECLAIM_MASK) |
@@ -3062,9 +3063,9 @@ unsigned long try_to_free_mem_cgroup_pag
 					    sc.gfp_mask,
 					    sc.reclaim_idx);
 
-	current->flags |= PF_MEMALLOC;
+	noreclaim_flag = memalloc_noreclaim_save();
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
-	current->flags &= ~PF_MEMALLOC;
+	memalloc_noreclaim_restore(noreclaim_flag);
 
 	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
 
@@ -3589,8 +3590,9 @@ unsigned long shrink_all_memory(unsigned
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 	struct task_struct *p = current;
 	unsigned long nr_reclaimed;
+	unsigned int noreclaim_flag;
 
-	p->flags |= PF_MEMALLOC;
+	noreclaim_flag = memalloc_noreclaim_save();
 	lockdep_set_current_reclaim_state(sc.gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
@@ -3599,7 +3601,7 @@ unsigned long shrink_all_memory(unsigned
 
 	p->reclaim_state = NULL;
 	lockdep_clear_current_reclaim_state();
-	p->flags &= ~PF_MEMALLOC;
+	memalloc_noreclaim_restore(noreclaim_flag);
 
 	return nr_reclaimed;
 }
@@ -3764,6 +3766,7 @@ static int __node_reclaim(struct pglist_
 	struct task_struct *p = current;
 	struct reclaim_state reclaim_state;
 	int classzone_idx = gfp_zone(gfp_mask);
+	unsigned int noreclaim_flag;
 	struct scan_control sc = {
 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
 		.gfp_mask = (gfp_mask = current_gfp_context(gfp_mask)),
@@ -3781,7 +3784,8 @@ static int __node_reclaim(struct pglist_
 	 * and we also need to be able to write out pages for RECLAIM_WRITE
 	 * and RECLAIM_UNMAP.
 	 */
-	p->flags |= PF_MEMALLOC | PF_SWAPWRITE;
+	noreclaim_flag = memalloc_noreclaim_save();
+	p->flags |= PF_SWAPWRITE;
 	lockdep_set_current_reclaim_state(gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
@@ -3797,7 +3801,8 @@ static int __node_reclaim(struct pglist_
 	}
 
 	p->reclaim_state = NULL;
-	current->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE);
+	current->flags &= ~PF_SWAPWRITE;
+	memalloc_noreclaim_restore(noreclaim_flag);
 	lockdep_clear_current_reclaim_state();
 	return sc.nr_reclaimed >= nr_pages;
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-reorder-fields-in-struct-compact_control.patch
mm-compaction-remove-redundant-watermark-check-in-compact_finished.patch
mm-page_alloc-split-smallest-stolen-page-in-fallback.patch
mm-page_alloc-split-smallest-stolen-page-in-fallback-fix.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch
mm-compaction-change-migrate_async_suitable-to-suitable_migration_source.patch
mm-compaction-add-migratetype-to-compact_control.patch
mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype.patch
mm-compaction-finish-whole-pageblock-to-reduce-fragmentation.patch
mm-prevent-potential-recursive-reclaim-due-to-clearing-pf_memalloc.patch
mm-introduce-memalloc_noreclaim_saverestore.patch
treewide-convert-pf_memalloc-manipulations-to-new-helpers.patch
mtd-nand-nandsim-convert-to-memalloc_noreclaim_.patch

